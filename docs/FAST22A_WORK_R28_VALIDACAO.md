# R28 — validacao

## Preparacao

- Formatacao/sintaxe pelo dart format: PASS.
- Geometria independente: PASS em 22801 instantes do ciclo comum, tres barcos; limites, separacao e exclusao das areas de HUD, zona 3, rotulos e rochas do farol.
- Integridade de payload, manifesto e ZIP: conferida no empacotamento.
- Flutter analyze, testes Flutter, Web e APK: NAO EXECUTADOS neste ambiente, que nao dispoe de Flutter funcional e cache de dependencias. Execucao obrigatoria pelo instalador no Windows.

## Homologacao Chrome, A05 horizontal e tablet

1. Tres barcos visiveis, um em cada faixa do mar, tamanhos conforme perspectiva.
2. Nenhum barco estatico antigo permanece no cenario.
3. Ritmo suave; observar os retornos e ausencia de fade, cortes ou teletransporte.
4. Sem passagem sobre cards, indicadores, rotulos, ponte, farol ou praia.
5. Abrir zonas desbloqueadas, menu, Minhas Missoes, Minha Cidade e Medalhas. Retornar ao mapa; progresso e perfil preservados.
6. Alternar aplicativo/aba e retornar: sem salto abrupto nem aceleracao para compensar tempo ausente.
7. Com movimento reduzido ativado no sistema: barcos estaticos e mapa funcional.
8. Verificar ausencia de engasgos perceptiveis no A05 durante pelo menos dois minutos. Observar aquecimento anormal e erros no terminal; desempenho ainda depende da verificacao no aparelho.

VALIDACAO TECNICA = PENDENTE
CHROME = PENDENTE
A05 HORIZONTAL = PENDENTE
TABLET = PENDENTE

Capturas de regressao: build/fast22a_r27_evidencias. Teste de fundo R28: r28_actual_background.png; referencia: r27c_approved_reference.png. Relatorio preservado em r27c_pixels.txt.
