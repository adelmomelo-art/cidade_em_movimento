# FAST-20 - Release Piloto Fortaleza

## Identificacao
Produto: Cidade em Movimento
Release: Piloto Fortaleza
VersionName: 1.0.0
VersionCode: 3
Application ID Android: br.com.flybuddies.cidadeemmovimento

## Escopo congelado
O piloto Fortaleza possui exatamente 6 zonas:
1. Bairro / Escola
2. Centro Historico
3. Orla / Praia de Iracema
4. Cultura / Eventos
5. Grandes Vias
6. Polo Castelao

Nao existe Zona 7 no MVP Fortaleza.

## Pilares entregues
- Jornada principal de 6 zonas;
- Duelo das Placas;
- Construa o Bairro;
- Progressao Global;
- Dashboard Pedagogico local;
- Faixita em modo local-first;
- funcionamento Web;
- funcionamento Android;
- persistencia offline.

## Estado de backend
O piloto pode funcionar integralmente sem backend.

Backend pedagogico:
- contrato pronto;
- HML deploy pendente.

Faixita remota:
- contrato pronto;
- HML deploy pendente;
- modo local homologado.

## Privacidade do piloto
O produto nao exige nome, email, telefone, CPF ou localizacao precisa.
A telemetria pedagogica V1 usa identificador tecnico local e dados agregados.

## Assinatura Android
ATENCAO:
O APK de piloto ainda utiliza a chave de debug no build release.
Ele e adequado para distribuicao controlada do piloto, mas NAO e pacote final
para publicacao em loja.

Antes de Play Store:
- criar keystore de producao;
- configurar signing release;
- guardar credenciais fora do repositorio;
- gerar AAB assinado;
- validar upgrade path.