# FAST22A WORK R14 — validação

12/10/2026. Base main R13 1c1739f. Proposta aprovada: missões em janela sobre o cenário e retirada dos quadros externos redundantes.

## Verificação de preparação

- Flutter 3.44.4 / Dart 3.12.2 em modo CI.
- Formatação PASS; flutter analyze: 0 issues.
- 50 testes dedicados PASS.
- Suíte completa: 266 testes PASS (259 anteriores + 7 novos).
- FAST9 Z1/theme/390.0/installed isolado: PASS.
- Build Web release: PASS.
- git diff --check e arquivos novos: PASS.
- Capturas de mapa, pergunta, orientação, resultado, noite sem luz e noite iluminada em 390/800/1280 inspecionadas. Dados simulados nas capturas.
- Novos testes percorrem as seis missões em criança/390, adolescente/800 e adulto/1280. Verificam mesmo mapa montado, resultado, valores reais, medalha, desbloqueios, reload da persistência e repetição sem recompensa extra.
- Cancelamento sem prêmio; resposta errada e nova tentativa na mesma janela; falha de salvamento e recuperação sem duplicação; saída bloqueada enquanto salva; dia/noite sem mudança de progresso, refletindo compra real; celular horizontal 600x390 com texto ampliado e botão Voltar do Android.
- Testes de interação/título da Zona 1 atualizados para a proposta; FAST9 aceita tela sem scroll somente quando o conteúdo cabe inteiro. Verificações de regressão das demais zonas preservadas.
- Motor, conteúdo pedagógico, scoring, persistência, recompensas, assets, rotas externas e demais zonas preservados.
- APK release e PowerShell 5.1: não executados neste ambiente sem SDK Android/PowerShell. Instalador inclui build APK obrigatório no Windows antes de declarar PASS.

## Aplicação

Instalador verifica HEAD main R13 1c1739f, arquivos de entrada/payload e conteúdo protegido antes de escrever. Aceita somente diferenças de CRLF/LF em arquivos textuais. Backup de arquivos alterados, APK anterior se existir e log. Cria branch local feat/fast-22a-zona1-missoes-integradas quando iniciado na main. Executa dependências, format, analyze, testes, Web, APK e diff check; confere hashes após os gates. Sem commit, push ou merge.

Homologação local R14 Web/celular pendente. Conferir pergunta sobre bairro visível, alternativas legíveis, consequência/explicação/resultado na mesma janela, fechamento e atualização do mapa, cancelamento/Voltar, compras, medalha e modo noturno antes/depois da compra de luz. R13 sincronização e celular foram informados PASS pelo usuário; não equivalem à homologação desta R14.
