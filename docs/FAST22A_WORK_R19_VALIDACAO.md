# R19 — validação e homologação

Verificado aqui: formatação/parser Dart, PNG com canal alfa e recorte justo,
layout do mapa idêntico à R18A/R17, integridade dos arquivos/pacote,
manifesto de 185 arquivos protegidos inalterado.

Não executados aqui: analyze, testes Flutter, renderização Flutter, Web/APK.
Cache de dependências Flutter ausente. Nenhum PASS técnico nem homologação
visual R19 declarados na preparação. Não confundir mockup gerado com captura
da implementação. O novo recorte do Melo foi gerado por edição de imagem.

Instalador exige os gates e gera novo APK. Os testes de consistência visual
geram capturas em build/fast22a_r19_evidencias no computador do usuário.

## Homologação

- Comparar com mockup 3: Melo protagonista à esquerda, título centralizado,
  pergunta/contexto em balão amarelo, respostas e botão confirmador legíveis.
- Introdução, consequência, explicação e resultado seguem o mesmo padrão,
  sem grandes painéis brancos. Janela não muda de tamanho entre etapas.
- Cenário preserva dia/noite e melhorias reais; mapa restaurado inalterado.
- Escolher alternativa não responde nem premia; confirmar aciona consequência.
- Trocar seleção, erro, tentar novamente, sair e repetir sem prêmio duplicado.
- Fechar após conclusão atualiza estrelas/pontuação; progresso persiste.
- A05 horizontal/vertical, fontes ampliadas, rotação, textos longos legíveis
  com rolagem apenas dentro da janela; nenhum corte de cap/rosto do Melo.
- Confirmar desativado permanece visível, mas só habilita após escolha.
- Voz e cronômetro futuros; sem contagem/limite de tempo.

Aceite visual do usuário obrigatório antes de fechamento. Commit, push e
merge não executados. O mapa sem rolagem no A05 continua como trabalho futuro.
