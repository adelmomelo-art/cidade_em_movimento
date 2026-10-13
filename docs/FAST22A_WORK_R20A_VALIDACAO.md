# R20A — testes de toque na janela compacta

13/10/2026. Diagnóstico confirmado no FAST22A_dedicado.log fornecido.

1. Teste de salvamento tentou tocar VER RESULTADO fora da região visível.
   O clique não iniciou o salvamento, logo fechar continuava habilitado.
2. Os dois casos com texto1,4 tentaram tocar alternativas com centro fora
   da área de rolagem. A seleção não ocorreu: confirmação permaneceu
   desabilitada e consequência/etapa esperada não foi alcançada.
Não há erro RenderFlex/overflow registrado no log recebido.

Correção exclusiva dos testes: Scrollable.ensureVisible com alinhamento
0,5 antes de cada toque; asserção hitTestable exige que o centro realmente
receba o toque. Não usar warnIfMissed=false nem chamar onPressed diretamente.
No salvamento, posicionar botão e estabilizar renderização ANTES de criar
o Completer pendente; após clique, bombear somente um frame para conferir
o bloqueio durante a gravação. Mantidas falha simulada, retry, persistência
e proteção contra recompensa duplicada.

Todos os arquivos de produção, assets, pubspec, proporção31,4%/1,87:1 e
piso360px idênticos à R20. Capturas continuam em build/fast22a_r20_evidencias.
Conferido aqui: formatação, diferença limitada ao teste e hashes do pacote.
Flutter analyze/testes e builds Web/APK pendentes no Windows por ausência
de dependências no ambiente de preparação. Não declarar PASS antecipado.
Nenhum commit, push ou merge executado.
