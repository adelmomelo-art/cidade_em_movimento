# R48/R48.1 - Cidade em Movimento publicado e homologado

Endereco definitivo: https://cidade.flybuddies.com.br/
Projeto Cloudflare Pages: cidade-em-movimento.
Endereco Pages: https://cidade-em-movimento.pages.dev/
Implantacao ativa conferida no painel em 29/10/2026: c2c6c127.
Dominio ativo com SSL; tela inicial conferida no endereco definitivo.

Base de fontes: e4edf51bf0ac6aa214c178a26113b9b740e918de (merge R47).
Versao preservada: 1.0.0+4. Sem alteracoes de Dart, Android ou assets.
Esta versao permanece como demonstracao/apresentacao. Cidade em Movimento 2
sera um projeto separado; nao faz parte deste fechamento.

## Escopo de fontes

- web/manifest.json: orientacao landscape para o jogo horizontal.
- web/_headers: revalidacao de cache e X-Content-Type-Options nosniff.
- Este registro. Nenhum artefato compilado ou arquivo privado e commitado.

Orientacao no manifesto e uma preferencia para navegadores/PWA compativeis,
nao uma garantia de travamento de orientacao em todos os dispositivos.

## Gates locais R48

Diff check, pub get com lock preservado, analyze sem problemas, 3 testes
aprovados nos dois arquivos existentes de configuracao e build Web release:
PASS. Nao foi repetida a suite completa de 937 testes da R47 nem o build APK;
nao ha alteracoes de Dart/Android na R48.

Pacote preparado: 92 arquivos, 151305191 bytes (144.30 MiB sem compactacao).
Maior arquivo: canvaskit/canvaskit.wasm, 7229467 bytes.
As 51 imagens e o video permaneceram identicos aos assets de origem.
Source maps foram excluidos da copia publica. Limites de arquivos conferidos.
Evidencias: RELATORIOS_R48_ENVIAR.zip e inventario_publicacao.csv no backup.

## R48.1 - Correcao do ZIP de publicacao

O ZIP inicial, criado por ZipFile.CreateFromDirectory no Windows PowerShell
5.1, tinha 82 caminhos com barra invertida. O deploy foi aceito, mas os
manifestos internos nao carregaram corretamente, causando tela branca e
JSON recebendo HTML. A falha foi de empacotamento; nao exigiu recompilacao.

ZIP original preservado SHA-256:
44314a59ca06cba8d7fbbd41664722834f0031c7959bf02a844d7fbc0749a2b0

O corretor R48.1 criou WEB_PUBLICAR_R48_1.zip com nomes explicitos usando /,
conferiu tamanhos e SHA-256 dos 92 arquivos contra o inventario aprovado,
recusou entradas extras/duplicadas e preservou o ZIP original.
Resultado local informado: 92 arquivos, 82 caminhos corrigidos, zero barras
invertidas no novo ZIP, todos os conteudos preservados = PASS.

Para futuras publicacoes, os nomes dentro do ZIP devem usar /, com
index.html na raiz. Nao usar novamente CreateFromDirectory sem verificar os
separadores no ambiente PS5.1. Criar entradas explicitamente, por exemplo:

```powershell
$entry = $archive.CreateEntry($relativePath.Replace('\', '/'))
```

Conferir a lista e os hashes de TODAS as entradas antes do upload. A pasta
do projeto inteiro, chaves, key.properties e arquivos .env nunca sao enviados.
Atualizacoes sao novas implantacoes no projeto Pages existente; nao recriar
o projeto nem alterar GEDUC, EAD ou certificados.

## Homologacao Web

No endereco Pages, o responsavel informou PASS para:
- Perfil, avatar e mapas.
- Missao com video e perguntas.
- Melhorias, medalhas e progresso.
- Fechar e reabrir no mesmo navegador mantendo o progresso.

No dominio definitivo cidade.flybuddies.com.br, missao com video e
persistencia apos fechar/reabrir foram novamente informadas como PASS.
O assistente conferiu a tela inicial carregando por HTTPS no dominio.

## Persistencia e continuidade

O jogo atual salva um unico jogador local por perfil do navegador/origem ou
instalacao. Escolha de faixa etaria/avatar nao cria contas independentes.
O progresso nao e migrado automaticamente entre localhost, Pages, dominio
definitivo, APK ou aparelhos. Limpar dados locais pode remover o progresso.
Nao existe cadastro escolar ou sincronizacao central na versao de demonstracao.
Escola/professor/turma/alunos e progresso individual em servidor ficam para
Cidade em Movimento 2, em ambiente e repositorio separados.

O APK R47 com assinatura propria permanece com homologacao de primeira
instalacao/funcional PENDENTE. Os passes Web nao substituem esse teste.
O A05 e seus dados do APK permanecem preservados.

## Fechamento autorizado

Commit, push e abertura do PR R48/R48.1 autorizados pelo responsavel.
Este fechamento altera somente a documentacao apos os gates ja aprovados.
Nao realiza merge, novo deploy, DNS, build ou instalacao. macOS local,
chaves privadas e dados de jogadores ficam fora do commit e preservados.
