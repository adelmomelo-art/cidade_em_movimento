# FAST-19 - IA Faixita V1

## Objetivo
Adicionar a Faixita como mentora pedagogica do Cidade em Movimento sem criar
dependencia obrigatoria de internet e sem alterar o motor de jogo.

## Arquitetura
A Faixita opera em dois niveis:

1. Modo local:
- funciona offline;
- respostas pedagogicas deterministicas;
- usa apenas perfil e progresso do jogo;
- nenhuma chamada de rede;
- fallback obrigatorio.

2. IA conectada:
- opcional;
- configurada por FAIXITA_API_BASE_URL;
- aplicativo nunca recebe token do provedor de IA;
- backend faz o relay para o provedor;
- se a rede ou provedor falhar, o app retorna ao modo local.

## Privacidade
O cliente envia apenas:
- pergunta;
- tipo de perfil;
- indicadores agregados do progresso;
- resultado da missao quando explicitamente aberto a partir da tela de resultado.

Nao envia:
- nome;
- email;
- telefone;
- CPF;
- localizacao;
- contatos;
- arquivos pessoais.

## Pontos de acesso
- Mapa de Fortaleza -> Faixita.
- Resultado da missao -> Perguntar a Faixita.

## Limites do V1
A Faixita deve atuar somente em:
- educacao para o transito;
- seguranca;
- cidadania;
- mobilidade;
- explicacao do progresso;
- conteudo pedagogico do jogo.

O prompt remoto proibe inventar leis, artigos ou penalidades.

## Backend
Fonte:
backend/faixita_api/worker.mjs

Endpoints:
GET /health
POST /v1/faixita/chat

O backend HML nao e publicado automaticamente neste FAST.
Secrets esperados no Worker:
- FAIXITA_PROVIDER_URL
- FAIXITA_PROVIDER_TOKEN

## Build conectado
Exemplo futuro:

flutter run -d chrome --dart-define=FAIXITA_API_BASE_URL=https://SEU-WORKER.workers.dev

Sem esse define, o app opera integralmente em modo local.