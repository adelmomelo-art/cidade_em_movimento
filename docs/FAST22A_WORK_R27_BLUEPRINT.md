# FAST22A WORK R27 — mapa funcional de Fortaleza

14/10/2026. Base main: 2adfd2d094ff60920f693c5da99f64b78d7d2a10, PR #4 R25+R26 homologado. Branch de trabalho: feat/fast-22a-mapa-fortaleza-r27.

## Referência aprovada

Imagem selecionada pelo usuário: image-edit-target-38d10cf8bc5c3e23.png, mapa horizontal aprovado com Ponte dos Ingleses, Farol do Mucuripe, seis zonas e avatar no INÍCIO. Esse arquivo é copiado inteiro para mapa_aprovado_r27.png. As posições e os desenhos dos demais marcos permanecem exatamente na imagem aprovada.

Composição inteira proporcional em SafeArea, sem rolagem. O cenário desfocado cobre apenas as áreas extras em telas de outra proporção, seguindo a estratégia R24–R26. O mapa completo fica visível. Orientação horizontal do aplicativo permanece controlada pela R22/R23 existente.

## Camadas funcionais

- Arte original estática, com todos os marcos e rótulos aprovados.
- Apenas o retângulo pequeno do personagem fixo no INÍCIO usa uma região da versão editada sem o menino; o restante da imagem editada não é usado. Assim, a edição não redesenha o cenário aprovado.
- Seis sprites de corpo inteiro derivados dos personagens R26 por imagegen, transparentes, sem nomes: criança/adolescente/adulto, masculino/feminino. O perfil salvo seleciona o sprite. No cabeçalho, o retrato é recortado diretamente da arte R26 correspondente, sem gerar outro rosto. IDs legados e fallback por tipo preservados.
- Conhecimento, cidadania e moedas exibem respectivamente progress.knowledge, progress.citizenshipXp e progress.coins. O motor não possui carteira/vidas; nenhum contador desse tipo é inventado. Ícones do mockup permanecem, com rótulos e semântica para as métricas reais.
- Seis cartões inteiros interativos. Disponibilidade vem exclusivamente de isZoneUnlocked; conclusão e medalhas vêm de completedZones/medals e do catálogo existente. Bloqueadas não navegam; disponíveis têm play; concluídas têm check e medalha quando conquistada. O cadeado decorativo acima da Zona 4 acompanha seu estado.
- Progressão inferior: seis nós e quantidade de zonas concluídas reais, sem conceder moedas ou medalhas na apresentação.
- MINHAS MISSÕES abre a primeira zona disponível ainda não concluída; após conclusão de todas, retorna à Zona 1 para revisitar.
- MINHA CIDADE abre Construa o Bairro existente; MEDALHAS abre Meu Progresso existente; faixa de progressão abre Progressão Global existente.
- Engrenagem abre Mais opções com Faixita, Duelo das Placas, progresso global e retorno à tela inicial. São os acessos já existentes, sem tela de configurações fictícia ou novas funções.
- Nada muda em rotas, controllers, catálogo, motor, persistência, recompensas, perguntas, apresentação, perfis ou outras telas. Animações de carros/barcos/pedestres estão fora da R27, conforme combinado.

## Regressões

Mantidos os casos anteriores do mapa: seis zonas, bloqueios, conclusão sequencial, medalhas e rota central. Os testes substituem a expectativa de rolagem e de textos antigos pelas áreas da arte e estados acessíveis atuais. Progressão Global e Duelo continuam cobertos, agora no menu. FAST21 exige o componente de arte aprovada no mapa, mantendo suas verificações de identidade e escopo de seis zonas.

Novo teste R27: cinco tamanhos, seis variantes do personagem, rotas e bloqueios, HUD real, atualizações em tela após conclusões pelo motor, teclado, rotação, nenhuma alteração de progresso pela navegação e amostras dos pixels aprovados nos marcos Catedral/Ponte/Farol.

## Aplicação

Instalador PS 5.1 confere baseline/branch/payload, todos os arquivos protegidos e hashes normalizados LF/CRLF antes de escrever. Na main limpa cria branch R27. Backup completo dos arquivos alterados e logs ficam ao lado do projeto. Não faz commit/push/merge ou limpeza dos dados do jogador.
