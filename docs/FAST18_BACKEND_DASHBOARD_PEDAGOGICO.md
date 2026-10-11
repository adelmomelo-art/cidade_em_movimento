# FAST-18 - Backend Pedagogico + Dashboard V1

## Escopo
- snapshot pedagogico anonimizado;
- fila offline com apenas o estado mais recente;
- jogo nunca depende do backend para funcionar;
- Dashboard Pedagogico local no app;
- contrato Cloudflare Worker + D1 pronto para HML;
- nenhum dado civil: nome, email, telefone, CPF ou localizacao precisa.

## Configuracao futura HML
Use PEDAGOGICAL_API_BASE_URL no build Flutter.
O deploy Cloudflare HML nao e automatico neste pacote porque o D1 e o dominio ainda precisam de identificadores reais.

## API V1
GET /health
POST /v1/pedagogical/snapshots
GET /v1/pedagogical/summary

## Limite deliberado
Antes de producao multi-escola: autenticar administradores, definir RBAC e politica de retencao.