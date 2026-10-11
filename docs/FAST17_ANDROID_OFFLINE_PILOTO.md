# FAST-17 - Android, Offline e Empacotamento

## Identidade do piloto
- App: Cidade em Movimento
- Application ID: br.com.flybuddies.cidadeemmovimento
- Versao: 1.0.0+2
- Escopo: piloto Android e Web
- Assinatura: chave debug usada no build release atual; nao e assinatura definitiva de loja.

## Offline
O MVP atual nao depende de backend para jogar.
Perfil e progresso sao persistidos localmente com SharedPreferences.

Homologacao obrigatoria em aparelho:
1. Instalar o APK.
2. Abrir com internet e criar/usar perfil.
3. Executar uma acao que altere progresso.
4. Fechar o app.
5. Ativar modo aviao.
6. Abrir o app novamente.
7. Confirmar perfil, progresso, Duelo e Construa o Bairro.
8. Navegar nas telas principais sem erro.
9. Fechar e reabrir ainda offline.
10. Confirmar persistencia novamente.

## APK piloto
O script FAST-17 gera um APK release para homologacao local.
O build release atual usa assinatura debug por decisao temporaria do projeto.
Nao publicar em loja ate existir keystore de producao e politica de assinatura.

## Icone
O icone Flutter atual permanece tecnicamente funcional.
Identidade visual final do icone deve ser homologada separadamente antes de publicacao em loja.