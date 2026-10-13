# FAST22A R22 — validação

Verificação local: sintaxe/formatação Dart e integridade do pacote.
Flutter analyze/test/build e homologação visual: PENDENTES no Windows.
Nenhum commit, push, merge ou aprovação visual automática.

O instalador cria backup e registra logs separados, valida hashes antes de
aplicar, mantém os arquivos protegidos e exige pub get, formatação, analyze,
testes dedicados R8–R22, FAST9, suíte completa, Web release, APK release e
git diff --check. Imprime PASS somente após todos esses gates.

Novo teste R22: telas horizontais 600×390 (texto 1,4), 844×390 (SafeArea),
1280×800 (texto 1,4) e 1366×768; proporção da arte, todos os painéis dentro,
sem Scrollable, arraste não desloca mapa, seis missões abrindo corretamente.
Rotação em uma missão com resposta pendente mantém o mesmo State de mapa/dialog
sem recompensa; confirmar depois da volta mostra a consequência correta.
Canal Android solicita as duas posições horizontais; desktop não solicita.
Capturas de enquadramento: build/fast22a_r22_evidencias.
Capturas das etapas de pergunta R21: build/fast22a_r21_evidencias.

Depois de PASS, conferir Chrome, A05 e tablet reais:
- Mapa completo sem rolar, imagem proporcional e posições aprovadas.
- Ler KPIs, missões e melhorias; tocar todos os controles com precisão.
- Trocar noite/dia, comprar melhorias e abrir progresso/mapa de Fortaleza.
- Abrir as seis missões; janela/Melo/textos inteiros iguais à R21.
- Girar em uma pergunta selecionada: aviso na vertical; mesma seleção na volta.
- Fechar sem recompensa e concluir com recompensa única; reabrir progresso.
- Web estreita exibe o aviso; janela horizontal devolve o jogo sem reinício.
- APK atualizado solicita horizontal; se o sistema recusar, aviso segue ativo.

Se algum gate falhar, enviar o log completo desde a primeira exceção,
disponível no diretório de backup indicado. Um resumo de “Failing tests”
sozinho não contém a causa.
