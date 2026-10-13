# R18A — correção de seletor no teste

13/10/2026.

Defeito identificado por inspeção: o novo teste usa find.text(m.title)
na árvore inteira, onde o título Travessia Segura aparece tanto no mapa
montado ao fundo como no cabeçalho da janela. tester.widget exige apenas
um elemento; a busca global é ambígua nos quatro tamanhos testados.
O trecho final enviado pelo usuário não inclui a exceção original; esta
revisão corrige o defeito comprovado no código sem afirmar que o log
confirmou a exceção ou excluir a possibilidade de outras falhas.

Correção: buscar o texto como descendente de zone1-mission-header.
A asserção de letras brancas permanece. Não se usa first nem remove a
verificação. Testes de confirmação/recompensa preservados integralmente.

Implementação visual, mapa, assets e motor idênticos à R18.
Formatação e hashes verificados aqui; testes Flutter/builds pendentes
no Windows por ausência de dependências no ambiente de preparação.
Todos os gates continuam obrigatórios, incluindo novo APK.
Nenhum commit, push ou merge executado.
