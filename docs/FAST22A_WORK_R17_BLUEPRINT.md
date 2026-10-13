# FAST22A WORK R17 — restauração da composição R15

13/10/2026. Autorização: voltar ao projeto anterior à tela reprovada.

## Escopo

Restaurar exatamente os arquivos de implementação/testes do pacote R15,
com missões integradas, KPIs e navegação no cenário, melhorias e Melo no
layout anterior à R16. Restaurar também a janela de missões existente na
R15. Nenhuma pergunta, regra, recompensa, dado salvo ou imagem alterada.

Remover do projeto ativo apenas game_scene_viewport.dart e
fast22a_r16_viewport_test.dart, ambos exclusivos da abordagem R16 agora
revertida. A remoção representa retirada do requisito daquela abordagem,
não ocultação do overflow. Os testes de missão, texto ampliado, retorno,
compras e navegação R14/R15 são restaurados e continuam obrigatórios.
Os documentos R16 ficam preservados como histórico. Backup dos removidos
é obrigatório; hashes conhecidos são conferidos antes da aplicação.

## Decisões para evolução futura

PROPOSTA 3 — PERGUNTA CENTRAL escolhida como padrão visual pelo usuário.
Título azul com letras brancas; Melo junto à pergunta escrita; cenário da
zona com esmaecimento/degradê de 50%; botões nas cores padrão; ícone de
voz futura. Cronômetro e voz serão implementados posteriormente.
Esta revisão NÃO implementa esse mockup nem cria limite de tempo.

Ajustar o cenário inteiro ao A05 horizontal sem rolagem segue pendente.
A R17 devolve o comportamento R15, incluindo rolagem onde existente.
FAST22B e outras zonas permanecem fora deste escopo.

## Aplicação e fechamento

Pacote cumulativo R14/R15 com manifesto que aceita R16/R16A/R16B sem
commit, backup e gates de análise, testes dedicados/completos, Web e APK.
O instalador captura saída por gate. Nenhum commit/push/merge automático.
