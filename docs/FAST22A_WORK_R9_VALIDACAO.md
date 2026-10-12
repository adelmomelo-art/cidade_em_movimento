# FAST22A WORK R9 — revisão do cenário

12/10/2026. Pré-requisito: R8 aplicada, conforme capturas do usuário.

## Resultado

Melo mantém o desenho aprovado da R8. Agora aparece dentro da imagem, no canto superior esquerdo, com fala em balão branco e ponta voltada para ele. O painel externo foi removido. Em celular, os três marcadores superiores descem para reservar espaço para a fala.

Extremos das três travessias ajustados. A travessia frontal termina junto à borda da ciclovia. As duas outras foram encurtadas nas áreas que invadiam a vegetação. A posição final deve ser conferida no Chrome pelo usuário.

A ciclovia, iluminação e comparação noturna foram preservadas. Os três assets R7/R8 permanecem idênticos, inclusive o Melo de corpo inteiro guardado. Nenhuma alteração no motor, regras, custos, compras, moedas, estrelas, persistência ou rotas. Bairro Vivo segue como proposta futura.

## Verificação

- dart format: PASS.
- flutter analyze: 0 issues.
- testes dedicados: 26 PASS.
- suíte completa: 242 PASS.
- FAST9 Z1/theme/390.0/installed isolado: PASS.
- Web release: PASS.
- git diff --check e arquivos novos: PASS.
- 63 arquivos protegidos de motor/conteúdo, 83 arquivos de testes anteriores à R8 e os três assets preservados.
- O teste visual da R8 foi atualizado para conferir mentor e balão dentro do mapa; suas verificações de transparência, iluminação e repintura permanecem.
- Novo teste verifica ausência de tinta das faixas em dois pontos de sobreposição anterior com vegetação.
- Renderizações em 390, 800 e 1280 px inspecionadas; evidências com progresso simulado e todas as melhorias instaladas.
- APK release: não reexecutado neste ambiente, que não dispõe do SDK Android. O instalador inclui obrigatoriamente esse gate no Windows antes de declarar VALIDACAO TECNICA = PASS.

A validação usou Flutter 3.44.4 / Dart 3.12.2. Uma inicialização tentou consultar metadados da máquina em nuvem e foi bloqueada pela revisão automática; a validação seguiu no modo CI, que evita essa consulta, conforme o código da ferramenta. Não foi necessário acesso a metadados.

## Aplicação e homologação

Instalador PowerShell 5.1: valida hashes da entrada R8 e do payload, HEAD fa15589 e branch feat/fast-22a-zona1-visual-mestre antes de escrever; cria backup e log; aplica os arquivos completos; repete análise, testes e builds Web/APK.

Execução PowerShell e homologação visual pendentes no Windows do usuário. Conferir fala do Melo, extremos das faixas, vegetação, ciclovia e seis cliques. Nenhum commit, push ou merge executado.
