# FAST22A WORK R26 — personagens e apresentação aprovados

14/10/2026. Fluxo: início R24A → perfil R25 → gênero R26 → apresentação do Melo → mapa de Fortaleza.

## Direção aprovada

Três telas de escolha: criança, adolescente e adulto. Cada tela mostra os dois personagens homenageados, baseados em Rafael e Maria Laura, sem nomes nos desenhos. As seis interpretações e os três mockups foram aprovados pelo usuário. A apresentação é a imagem anexada Boas-vindas à Cidade em Movimento(1).png, aprovada separadamente.

As quatro imagens aprovadas são copiadas integralmente, sem redesenho, recorte ou nova geração. A composição principal usa a proporção real de cada arquivo, BoxFit.contain e SafeArea. Nas proporções diferentes, o mesmo cenário desfocado cobre a área restante. Não existe rolagem nas telas de gênero ou apresentação.

## Implementação

- AvatarScreen mantém a assinatura controller/type da rota existente e oferece masculino/feminino nos três perfis.
- Os cartões inteiros e VOLTAR têm controles Flutter transparentes, semântica e foco de teclado; as coordenadas são medidas individualmente em cada imagem.
- A escolha chama o método existente createProfile. IDs masculinos legados child_boy/teen_default/adult_default são preservados; femininos child_girl/teen_girl/adult_woman. PlayerProfile já aceita strings, sem migração de armazenamento.
- Enquanto salva, bloqueia repetição, VOLTAR e retorno Android. Em falha mostra mensagem e permite nova tentativa. Perfil só navega para apresentação após conclusão da gravação.
- A apresentação usa a arte anexada, fala acessível do Melo e botão COMEÇAR. Com perfil, substitui apresentação pelo mapa existente; sem perfil, retorna à escolha do perfil.
- O comportamento atual de limpeza da pilha após escolher avatar é mantido: volta ao início, sem reabrir cadastro pelo botão de retorno.
- Perfil R25 permanece visualmente idêntico. Seu teste de integração passa a conferir os dois cartões novos em vez dos antigos textos Menino/Menina.
- Home, orientação, mapas, missões, motor, recompensas, persistência e rotas não são modificados. Voz e cronômetro continuam para etapa futura.

## Entrega única

Pacote cumulativo R25+R26, preparado para HEAD c070a943b4b6d705e4afc5b4c4f73eaa4c0329ad, branch feat/fast-22a-perfis-r25 (R25 ainda sem commit) ou main limpa. O instalador aceita bytes R24A/R25/R26 somente nos arquivos declarados, confere hashes e arquivos protegidos antes de escrever, cria backup e repete todos os gates. Não faz commit, push ou merge. Fechamento Git único após homologação técnica e visual do fluxo completo.
