# R36 — Legibilidade nas seis zonas

Baseline: eb09fc16a4e7327918f180a063d189ee76896a2c (R34/PR12).
Branch: feat/fast-22a-legibilidade-r36.

## Solicitação e evidências
Capturas image(20261016-121121).png, image(20261016-121221).png e image(20261016-121303).png: Conhecimento e Progresso quebram/cortam no mapa da Zona 1. Captura image(20261016-123551).png: painel de Embarque Seguro com pergunta, alternativas e confirmação visualmente apertadas. Usuário pediu fonte menor para facilitar a leitura.

## Implementação
- Pergunta: limite nominal 45 -> 36 (-20%).
- Alternativas: 32 -> 26 (-18,75%).
- Confirmar resposta: 38 -> 30 (-21,05%), uma linha.
- Conhecimento e demais rótulos do HUD: uma linha.
- Rótulos do rodapé, inclusive Progresso: uma linha.
- Medição e renderização usam o mesmo estilo completo, incluindo fonte e espaçamento herdados, escala de acessibilidade, direção e locale. Margem técnica de 0,5 unidade nativa; redução automática continua disponível para textos maiores.
- Perguntas e alternativas podem ocupar várias linhas; nenhum texto é abreviado ou substituído por reticências.

Aplicação consistente às zonas 1 a 6. Janela, Melo, cenários, ícones, letras A/B/C, coordenadas, tamanhos das caixas, conteúdo pedagógico, respostas corretas e recompensas preservados. As reduções são limites máximos em coordenadas da arte, não pixels físicos fixos de todos os aparelhos.

## Compatibilidade com experiência R35
O instalador aceita R34 limpa ou R35 exatamente como entregue, ainda no mesmo HEAD. Se R35 estiver aplicado, escolhe o arquivo completo compatível da Zona 1, preservando o vídeo e seus arquivos; não o remove, não o amplia e não o considera homologado. Demais arquivos são idênticos nas duas variantes. pubspec.yaml não é alterado por R36. Backups são anteriores à aplicação. Sem commit/push/merge automático.

## Limites
Cortes visuais confirmados somente nas capturas da Zona 1. Código equivalente nas seis zonas motivou o ajuste consistente. Esta entrega não declara revisão visual completa de todas as missões; a homologação nos dispositivos continua necessária. Revisão pedagógica, piloto, novas animações e 3D continuam posteriores.
