# R47.1 — Assinatura propria para APK direto

Canal escolhido: APK direto para escolas e equipes.
Application ID: br.com.flybuddies.cidadeemmovimento.
Versao base: 1.0.0+4. Os APKs por ABI usam offsets do Flutter:
armeabi-v7a = 1004; arm64-v8a = 2004.

Certificado esperado SHA-256:
e616d2aab60f0bb84cf9e2bed85d5db43c8a99173196000d938ace9d0d96e79b

## Configuracao

O Gradle carrega android/key.properties, que e privado e ignorado pelo Git.
A chave JKS permanece fora do projeto. Alias/senhas nao entram no codigo,
relatorios, pacotes de correcao ou commits. Somente o fingerprint publico
fica em android/release-signing-certificate.sha256.

Quando existem credenciais, o Gradle valida acesso a chave privada e exige
o certificado registrado. Android Debug e outro certificado sao recusados.
Sem credenciais, debug continua configuravel e release falha na validacao
de assinatura do AGP; nao ha fallback para debug ou artefato sem assinatura.

## Validacao exigida

O aplicador confere a base R46, preserva o macOS e os originais rastreados,
testa a recusa de certificado divergente e de release sem credenciais,
confere a configuracao debug sem chave por dry-run, executa diff/analyze,
suite completa com pixels R46, web e APKs ARMv7/ARM64.

Os APKs sao verificados por apksigner e aapt: assinatura propria, package,
versao, SDKs, permissoes e ausencia de debuggable. As 51 imagens e o video
devem corresponder ao APK R46.2 homologado. As ABIs de libapp/libflutter sao
conferidas por artefato. Manifesto, permissoes e logica permanecem iguais.

Os resultados reais ficam no backup local. A copia segura da chave fora
do computador foi confirmada pelo responsavel. Homologacao de instalacao
da assinatura definitiva permanece PENDENTE. A05 debug nao recebe instalacao automatica:
o certificado e diferente, e uma desinstalacao apagaria o progresso local.

Para distribuir, use o APK correspondente a ABI do aparelho. Instalar a
primeira versao definitiva requer aparelho sem a instalacao debug ou uma
migracao de dados planejada. Futuras atualizacoes devem manter chave,
application ID e aumentar o build number. Preserve uma copia segura da chave
fora do computador e mantenha a senha separada.

Fechamento de fontes com commit, push e PR autorizado pelo responsavel.
Merge, instalacao, distribuicao e deploy nao fazem parte deste fechamento.

## Resultado tecnico R47.1B

Analyze: zero problemas. Suite completa: 937 testes aprovados, incluindo
comparacao de pixels R46. Builds Web, ARMv7 e ARM64: PASS.
Recusa de certificado divergente e release sem credenciais: PASS.
Debug sem credenciais: dry-run PASS. Nao equivale a instalacao homologada.
Assinatura v2 propria, metadados, permissoes e imagens/video dos APKs: PASS.
Os dois testes herdados agora exigem 1.0.0+4 e assinatura release,
preservando identidade Android, nome e backend opcional.

| APK | MiB | VersionCode | SHA-256 |
| --- | ---: | ---: | --- |
| ARMv7 | 119.33 | 1004 | aa8205de1bedaf478845df29fa28c42a06f1e1655ae50db48c53b7cc2fb09995 |
| ARM64 | 121.68 | 2004 | 4913c240d2e3396ab5dd27d3a362da82618ff4465caa28caf8e43f0d42c90d5f |

As evidencias locais foram conferidas no ZIP publico
RELATORIOS_PUBLICOS_20261028_165229_996_ENVIAR.zip.
android/build/reports/problems/problems-report.html e diagnostico gerado
pelo Gradle. /android/build/ fica ignorado; nenhum arquivo gerado e commitado.
Alteracao local macOS e material privado permanecem fora do fechamento.

## Pendencias para distribuicao

- Primeira instalacao com a assinatura propria: PENDENTE (sem outro aparelho).
- Homologacao funcional dos APKs R47 instalados: PENDENTE.
- Distribuicao para escolas/equipes: PENDENTE.

Os passes anteriores do A05 cobrem o R46 com assinatura debug. Nao substituem
a homologacao dos APKs R47. O A05 e seu progresso permanecem intactos.
