# FAST22A WORK R26 — validação

## Situação na preparação

- Mockups dos seis personagens, três escolhas e apresentação do Melo: aprovados pelo usuário.
- Formatação/sintaxe Dart dos arquivos de código e testes: verificada com Dart 3.12.2.
- Quatro assets: iguais em bytes às imagens aprovadas, dimensões nativas mantidas (1672×941 em criança/adolescente/apresentação; 1672×940 em adulto).
- Manifesto, registros de assets, hashes, áreas de toque, conteúdo e ZIP: verificados na preparação.
- flutter analyze, execução dos testes/goldens, build Web e build APK: PENDENTES de execução no Windows. Este ambiente perdeu o cache de dependências do Flutter; não foi declarado PASS desses gates aqui.
- Execução PowerShell e homologação do aplicativo atualizado: PENDENTES. A aprovação dos mockups não substitui a aprovação do aplicativo.

## Verificações incluídas

Arquivo fast22a_r26_avatar_intro_test.dart: as seis escolhas em cinco tamanhos (600×390, 800×360, 844×390, 1280×800, 1366×768), margens seguras e texto 1,4, cartões completos sem rolagem, igualdade nativa das quatro artes, retorno sem criar perfil, rotação, falha/repetição durante gravação, teclado, compatibilidade com IDs antigos, persistência após reinício e fluxo real início/perfil/gênero/apresentação/mapa sem modificar progresso.

O teste R25 é ajustado somente na expectativa da tela de avatar. Seus cliques, tipos, retorno, teclado, arte e preservação do progresso seguem cobertos. A suíte inteira, R24A e FAST21 são executadas pelo instalador.

## Gates no Windows

O instalador faz pub get, format, analyze (zero issues), testes dedicados e goldens, suíte completa, Web release, APK release, git diff --check e conferência final dos hashes. Somente após todos passarem imprime VALIDACAO TECNICA = PASS. Se qualquer gate falhar, interrompe e conserva logs e backup; não faz rollback automático sobre alterações em uso.

## Homologação visual e funcional

1. Em sessão sem perfil, JOGAR abre a escolha do perfil R25 aprovada.
2. Criança, adolescente e adulto abrem a respectiva dupla aprovada, sem nomes pessoais, cortes, distorção ou rolagem.
3. VOLTAR retorna ao perfil sem salvar uma escolha.
4. Toque no retrato ou faixa MASCULINO/FEMININO; confirme apresentação do Melo exatamente como a referência anexada.
5. COMEÇAR abre o mapa existente. Voltar ao início e JOGAR continuam com o perfil salvo.
6. Teste as seis combinações em sessões de teste novas, Chrome e A05 horizontal; compare os mockups também no tablet. Em dispositivo com progresso real não apague dados para testar novos perfis; use sessão/dispositivo de teste separado.
7. Reinicie e confirme perfil/progresso preservados. No Chrome confira Tab/Enter e retorno; no A05 confira retorno Android.

Evidências automáticas: build/fast22a_r26_evidencias. Em falha envie o log dedicado completo, incluindo a primeira exceção acima do resumo, e a captura correspondente.

Após técnica PASS e visual PASS, fechar R25+R26 juntos em um único commit/PR. Nenhuma ação Git remota executada por este pacote.
