# R46.2 — Reducao de assets e homologacao do APK ARM64

A conversao de 37 imagens de PNG para WebP lossless reduz o APK ARM64 de
144,60 MiB para 121,71 MiB, aproximadamente 22,9 MiB (15,8%). Os 14 PNGs
originais das imagens que divergiram na comparacao exata do Flutter foram
preservados. Dimensoes, transparencias, enquadramentos e regras do jogo
permanecem iguais. A reducao nao comprova menor consumo de memoria decodificada.

## Implementacao

Referencias diretas, caminhos dinamicos de avatares e sprites, pubspec e testes
acompanham os formatos finais. Nenhuma tolerancia de pixels foi adicionada:
os testes continuam comparando todos os bytes RGBA premultiplicados das 51
imagens, decodificadas pelo Flutter, contra os PNGs originais do backup.
O gate usa --dart-define=R46_ORIGINALS_BACKUP=<backup> para executar essas
comparacoes; sem o backup elas ficam explicitamente marcadas como skip.

Os builds foram limpos e conferidos por hash para impedir a inclusao simultanea
de PNG e WebP da mesma imagem. O runtime libapp.so/libflutter.so e ARM64;
bibliotecas auxiliares pequenas de outras ABIs nao foram excluidas.

## Validacao concluida em 28/10/2026

- Diff check, flutter analyze, suite completa e comparacao de pixels: PASS.
- Build web e APK ARM64, hashes dos assets e ausencia de duplicatas: PASS.
- Chrome: inicio, perfil, avatares, mapas das seis zonas, melhorias, perguntas,
  Melo sem sobreposicao, telas de apoio, video e navegacao: PASS.
- APK: assinatura v2 valida e certificado igual ao ARM64 anterior: PASS.
- A05: atualizacao sem desinstalar, progresso preservado, seis zonas,
  missoes, video, melhorias, medalhas e persistencia apos reabrir: PASS.
- Arquivo local macOS preservado e excluido do fechamento.

APK SHA-256:
befa59f37ebec7928a65d8a9563707e097b83ce43be5a2d2d5e6011ed9e7e51b

Certificado SHA-256:
e337afb4feb5f18a3a24dfbe9f95aa38307e1f25140287938b4143362ebefefb

Application ID br.com.flybuddies.cidadeemmovimento; versao 1.0.0+3.
A assinatura Android Debug e as permissoes existentes foram mantidas.
A assinatura definitiva e a configuracao de lancamento continuam pendentes.
Este fechamento nao inclui merge nem deploy.
