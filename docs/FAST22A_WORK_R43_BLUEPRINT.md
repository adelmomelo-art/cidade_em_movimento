# FAST22A R43 — Construa o Bairro por zona

Base verificada: `3f4f63c3c31e64dbb39a55442fb6ab65904fe3fc`, PR #15, R42 homologado pelo usuário.

## Escopo aprovado

- Cinco melhorias por zona (30 no total), com saldo global e compra vinculada à zona.
- Preservação integral dos 18 IDs/preços anteriores e dos três itens de Meu Bairro.
- Duas adições por zona: 40 e 60 moedas.
- Adicional de 130 moedas ao concluir uma zona, uma única vez, retroativo para zonas já concluídas.
- Tela horizontal: moldura e Melo aprovados, cenário da zona, cinco opções fixas, saldo, prévia e confirmação.
- Compras exibidas por camadas ilustrativas sobre o cenário e sobre o mapa da zona. Modo noturno destaca iluminação. Posição e leitura das intervenções exigem homologação visual por zona.

## Catálogo acrescentado

| Zona | 40 moedas | 60 moedas |
|---|---|---|
| Escola | Calçada acessível | Bicicletário escolar |
| Centro | Iluminação das travessias | Praça de convivência |
| Orla | Acesso acessível ao calçadão | Bicicletário da orla |
| Cultura e Eventos | Rota acessível ao evento | Iluminação dos acessos |
| Grandes Vias | Ponto de ônibus acessível | Calçada contínua |
| Castelão | Rota acessível ao estádio | Bicicletário do estádio |

## Persistência e migração

`GameProgress.claimedR43ZoneBonuses` é um conjunto independente de IDs de zonas. Saves sem esse campo recebem um conjunto vazio. A inicialização e a conclusão de missão reconciliam os adicionais pendentes. IDs desconhecidos não geram bônus. O registro anterior `claimedZoneCompletionBonuses` continua intacto; seus bônus não são substituídos pelos novos.

Saldo e marcação do bônus são persistidos no mesmo JSON. Todas as reconstruções de GameProgress no controller preservam o novo campo, inclusive compras e Duelo das Placas. Compra em andamento bloqueia nova compra concorrente; o desconto ocorre uma única vez. Falha de gravação retorna erro e restaura o estado anterior quando ele ainda é a transação corrente. O armazenamento verifica o retorno de gravação.

## Economia

Catálogo antigo: 1.420 moedas. Novos itens: 600. Meu Bairro: 180. Total: 2.200.
Recompensas anteriores das zonas: 1.420. Adicional: 6 × 130 = 780. Total: 2.200.
A compra de todas as melhorias usa todo o orçamento disponível. Não há moedas por replay.

## Interface

Zona → Melhorias abre a tela já na zona correspondente. O acesso geral começa na Escola. As setas navegam pelas seis zonas e Meu Bairro; zonas bloqueadas podem ser consultadas, mas não compradas pela tela. Selecionar não altera o save; Construir abre a confirmação; Cancelar não debita; Confirmar grava e exibe orientação. Comprado desabilita nova compra. Saldo insuficiente mostra a diferença. Todas as melhorias construídas geram mensagem de conclusão.

## Gates e limites

O instalador verifica hashes normalizados (LF/CRLF), protege dependências, faz backup e copia somente arquivos do manifesto. Cópia com falha aciona restauração. Falha de validação interrompe os gates com log, sem declarar PASS. Não faz commit/push/merge. A validação do aplicativo e a homologação em dispositivos constam no documento de validação.
