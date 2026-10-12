# FAST-22A R7 — Composição ilustrada da Zona 1

## Problema e objetivo

A R6 foi validada tecnicamente, mas sua arte vetorial ficou distante dos mockups aprovados. A R7 substitui a apresentação principal por um bairro e um Melo ilustrados, mantendo os marcadores Flutter e os contratos do motor.

## Camadas

1. `bairro_escola_base_r7.png`: cenário completo em 1536 × 1024, com escola, ruas, praça, costa de Fortaleza, veículos e pedestres. Sem faixa segura, ciclovia vermelha ou novos postes de iluminação escolar incorporados à base.
2. `Zone1IllustratedUpgradePainter`: infraestrutura pintada sobre a imagem a partir das flags já compradas: `FAIXA_SEGURA`, `ILUMINACAO_ESCOLAR`, `TRECHO_CICLOVIARIO`.
3. `melo_mentor_r7.png`: personagem com alpha real, desenhado separadamente por `MeloMascot`.
4. Marcadores Flutter: identidade, disponibilidade, estrelas e rotas continuam vindos da tela e do controller.
5. HUD, lista de missões, compras e ANTES/AGORA continuam vivos e usam os contratos existentes.

Imagem e infraestrutura compartilham o mesmo mundo de 1536 × 1024. `FittedBox` aplica a mesma transformação às duas camadas; o desenho não se estica na largura estreita. A cena principal usa proporção 3:2. ANTES/AGORA preserva o layout legado com recorte conjunto de imagem e infraestrutura.

No celular, o mapa usa marcadores numerados de pelo menos 48 px, com estrelas, tooltip e semântica; os nomes completos ficam na lista existente. O mentor aparece acima do cenário nas larguras menores. No desktop largo, aparece sobre a cena sem ocupar a região das missões.

## Estado e performance

Não existe estado visual persistente paralelo. As três flags são derivadas de `progress.purchasedUpgrades` e a pintura reage somente a sua alteração.

O cenário é decodificado uma vez no cache compartilhado, com largura 1536; o Melo usa largura de decodificação 512. As imagens são assets locais do Flutter e estão incluídas nos builds. A camada de infraestrutura ignora ponteiros para não interferir nos marcadores. O fallback vetorial existente permanece para falhas de carregamento do asset, sem mudar o motor.

## Arte e rastreabilidade

Assets produzidos com a ferramenta imagegen integrada, a partir das referências visuais fornecidas pelo usuário. Os prompts estão em `PROMPTS_ARTE_R7.txt`; os arquivos consumidos pelo app ficam em `assets/zone_1`. O Melo teve uma edição adicional para retirar o fundo e manter o personagem. O teste de assets valida decodificação e pixels alpha-zero nos quatro cantos do recorte.

## Validação e limites

Preservar todos os testes existentes. Acrescentar verificação do bundle, alpha e das oito combinações de melhorias. Executar os testes de interação da R6, FAST9 em 390/800/1280 px, suíte completa, analyze, builds e diff check.

A aceitação visual em relação ao mockup depende da homologação no Chrome. Performance no Samsung A05 depende da verificação no aparelho. Nenhuma aprovação visual ou de dispositivo é presumida a partir dos testes automatizados.
