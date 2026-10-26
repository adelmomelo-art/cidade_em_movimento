# R43.7 — candidato das 25 intervenções das zonas 2 a 6

Data: 26/10/2026. Base: commit `20fbb7d`, branch `feat/fast-22a-construa-bairro-r43`.

A R43.6 da Zona 1 foi homologada pelo usuário e enviada à branch. A R43.7 implementa camadas próprias para as cinco compras de cada uma das outras cinco zonas. Esta revisão é candidata: não tem homologação visual nem PASS Flutter confirmado.

## Escopo

| Zona | Intervenções |
|---|---|
| Centro | Travessia Acessível; Ponto Seguro; Rota Compartilhada; Iluminação das travessias; Praça de convivência |
| Orla | Travessia da Orla; Ciclovia Conectada; Embarque Organizado; Acesso acessível ao calçadão; Bicicletário da orla |
| Cultura/Eventos | Travessia do Evento; Sinalização Temporária; Embarque Organizado; Rota acessível ao evento; Iluminação dos acessos |
| Grandes Vias | Travessia Protegida; Iluminação do Corredor; Refúgio de Pedestres; Ponto de ônibus acessível; Calçada contínua |
| Castelão | Corredor de Pedestres; Iluminação do Entorno; Área de Embarque Integrada; Rota acessível ao estádio; Bicicletário do estádio |

Referência documental: CIDADE_EM_MOVIMENTO_RETOMADA_2026-10-23.md, versão 8, seções 15 a 21. As 11 pranchas corrigidas de estudo dessas zonas foram recuperadas e inspecionadas. Elas orientam os materiais e as intervenções; não são telas permanentes do jogo nem prova da implantação final no aplicativo.

## Implementação

Fundos iniciais foram preparados por edição de imagens. O aplicativo usa somente recortes locais desses fundos, mantendo o cenário original fora das áreas de intervenção. Travessias, abrigo, trecho cicloviário, banco, sinalização temporária e refúgio usam substituições locais; acessos e sinalização usam desenho no plano do chão; luminárias e bicicletários usam os sprites existentes da R43.5. A ciclorrota do Centro tem marcações brancas na pista cinza, sem nova faixa vermelha exclusiva. O corredor do Castelão usa proteção lateral e símbolo de pedestre.

As 32 combinações por zona são derivadas exclusivamente do conjunto de compras. A prévia usa o mesmo registro espacial da construção e não grava progresso. Compras antigas aparecem automaticamente nos novos visuais sem cobrança adicional. A correção das portas voltadas à pista na Orla é permanente e independe das compras. Máscaras preservam personagens, veículos e marcadores. O mapa continua com os marcadores originais, que ocultam parcialmente algumas intervenções; seus botões e coordenadas não foram redesenhados.

O pacote não altera controller, modelo, armazenamento, catálogo, preços, moedas, bônus, missões, desbloqueios ou código específico de construção da Zona 1. A geometria compartilhada recebe os novos pontos das intervenções ajustadas das zonas 2 a 6; o trecho da Zona 1 permanece idêntico.

A integração abrange Construa o Bairro e os mapas das zonas 2 a 6. Os fundos ilustrativos estáticos das janelas de missão não passam a reagir às compras nesta revisão. O vídeo educativo existente permanece preservado.

## Validação e limites

- Sintaxe Dart e PowerShell: verificar o relatório estático do pacote.
- Composições estáticas: 32 combinações por zona; conferir o resultado final em ESTADOS.json.
- Testes Flutter acrescentados: catálogo das 25 intervenções; 160 combinações de widgets; cancelamento de prévia; isolamento da Zona 1; clipping dos marcadores em duas escalas; correção permanente da Orla.
- Analyze, suíte Flutter, build web, build APK: PENDENTES até execução no computador do usuário.
- Homologação no Chrome, Samsung A05 horizontal e tablet: PENDENTE por zona.

As pranchas PROVA_ZONA são aproximações estáticas do código e dos assets. Os ícones das placas são esquemáticos e a coloração de prévia dos sprites pode diferir do Flutter. Não são capturas do aplicativo. A inspeção visual real deve conferir especialmente alinhamento dos acessos, oclusão de personagens, colocação do mobiliário, legibilidade diurna/noturna e os mapas com marcadores.

Não fazer commit, push, merge ou deploy desta revisão antes da homologação visual. A autorização de fechamento anterior já foi atendida no commit 20fbb7d; este candidato é uma nova revisão.
