import java.io.File
import java.security.KeyStore
import java.security.PrivateKey
import java.security.MessageDigest
import java.security.cert.X509Certificate
import java.util.Locale
import java.util.Properties

plugins {
    id("com.android.application")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

// R47: credentials are local; only the certificate fingerprint is versioned.
val releasePropertiesFile = rootProject.file("key.properties")
val releaseProperties = Properties().apply {
    if (releasePropertiesFile.isFile) {
        releasePropertiesFile.inputStream().use { load(it) }
    }
}
val releaseKeyStoreFile: File? = if (releasePropertiesFile.isFile) {
    fun requiredSigningProperty(name: String): String =
        releaseProperties.getProperty(name)?.takeIf { it.isNotBlank() }
            ?: throw GradleException("R47_PROPRIEDADE_AUSENTE: $name")

    val alias = requiredSigningProperty("keyAlias")
    val storePassword = requiredSigningProperty("storePassword").toCharArray()
    val keyPassword = requiredSigningProperty("keyPassword").toCharArray()
    val store = File(requiredSigningProperty("storeFile"))
    val pinFile = rootProject.file("release-signing-certificate.sha256")
    try {
        if (!store.isAbsolute || !store.isFile) {
            throw GradleException("R47_CHAVE_AUSENTE: verifique a chave local registrada.")
        }
        val projectRoot = rootProject.projectDir.parentFile.canonicalFile
        if (store.canonicalFile.toPath().startsWith(projectRoot.toPath())) {
            throw GradleException("R47_CHAVE_NO_PROJETO: mantenha a chave fora do projeto.")
        }
        if (!pinFile.isFile) {
            throw GradleException("R47_CERTIFICADO_AUSENTE: fingerprint publico nao configurado.")
        }
        val pin = pinFile.readText().trim().lowercase(Locale.ROOT)
        if (!Regex("[0-9a-f]{64}").matches(pin)) {
            throw GradleException("R47_CERTIFICADO_INVALIDO: fingerprint publico invalido.")
        }
        val keyStore = KeyStore.getInstance("JKS")
        try {
            store.inputStream().use { keyStore.load(it, storePassword) }
            if (keyStore.getKey(alias, keyPassword) !is PrivateKey) {
                throw GradleException("R47_CHAVE_PRIVADA_INVALIDA")
            }
        } catch (_: Exception) {
            // Never include credential values or provider exception details.
            throw GradleException("R47_CREDENCIAIS_INVALIDAS: confira a configuracao privada local.")
        }
        val cert = keyStore.getCertificate(alias) as? X509Certificate
            ?: throw GradleException("R47_CERTIFICADO_INVALIDO")
        cert.checkValidity()
        val digest = MessageDigest.getInstance("SHA-256")
            .digest(cert.encoded).joinToString("") { "%02x".format(it.toInt() and 0xff) }
        if (digest == "e337afb4feb5f18a3a24dfbe9f95aa38307e1f25140287938b4143362ebefefb" ||
            cert.subjectX500Principal.name.contains("CN=Android Debug", ignoreCase = true)) {
            throw GradleException("R47_DEBUG_RECUSADO: release exige a chave propria.")
        }
        if (digest != pin) {
            throw GradleException("R47_CERTIFICADO_DIVERGENTE: a chave nao corresponde a identidade registrada.")
        }
        store
    } finally {
        storePassword.fill('\u0000')
        keyPassword.fill('\u0000')
    }
} else {
    // A clone without private credentials can still build debug.
    // Release receives a complete signing config pointing at this absent file,
    // so AGP validateSigningRelease fails instead of producing an unsigned APK.
    null
}

android {
    namespace = "br.com.flybuddies.cidadeemmovimento"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    defaultConfig {
        applicationId = "br.com.flybuddies.cidadeemmovimento"
        // You can update the following values to match your application needs.
        // For more information, see: https://flutter.dev/to/review-gradle-config.
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    signingConfigs {
        create("release") {
            storeType = "JKS"
            storeFile = releaseKeyStoreFile ?: releasePropertiesFile
            // Nonempty markers make the missing-file release fail AGP validation.
            // These are configuration markers, never real credentials.
            storePassword = releaseProperties.getProperty("storePassword") ?: "R47_CONFIGURAR_KEY_PROPERTIES"
            keyAlias = releaseProperties.getProperty("keyAlias") ?: "R47_CONFIGURAR_KEY_PROPERTIES"
            keyPassword = releaseProperties.getProperty("keyPassword") ?: "R47_CONFIGURAR_KEY_PROPERTIES"
        }
    }

    buildTypes {
        release {
            signingConfig = signingConfigs.getByName("release")
        }
    }
}

kotlin {
    compilerOptions {
        jvmTarget = org.jetbrains.kotlin.gradle.dsl.JvmTarget.JVM_17
    }
}

flutter {
    source = "../.."
}
