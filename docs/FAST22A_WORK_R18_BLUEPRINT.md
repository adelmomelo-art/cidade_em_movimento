# FAST22A WORK R18 — perguntas na proposta 3

13/10/2026. Proposta 3 aprovada pelo usuário após restauração R17.

Janela sobre o cenário: título azul #1565C0 com letras brancas, bairro
como fundo e gradiente com opacidade 50%, pergunta central em amarelo
com Melo apresentando e ponta do balão voltada para ele.
Alternativas azuis com letras A/B/C; seleção destacada em amarelo.
CONFIRMAR RESPOSTA só habilita após escolher uma alternativa. Pode trocar
a seleção antes de confirmar; apenas a confirmação aciona o motor atual.
Nenhuma alternativa revela acerto/erro antes da confirmação.

Celular vertical: Melo acima da pergunta; telas largas: Melo à esquerda
da pergunta e respostas. Textos com altura natural; rolagem restrita à
janela. Ao mudar de etapa o conteúdo volta ao topo. Rotação mantém etapa
e seleção pendente. Introdução, consequência, explicação e resultado
continuam na mesma janela, com painéis claros para leitura.

Fundo acompanha as melhorias reais e o modo dia/noite aberto no mapa.
Texto da pergunta preservado. Ícone de voz desativado: Voz em breve.
Cronômetro/voz não implementados, não há contagem nem limite de tempo.

O layout da tela do mapa R17/R15 é preservado. Única alteração de integração
no mapa: enviar modo noturno atual à janela. Motor, imagens, regras,
persistência e recompensas não alterados. FAST22B fora do escopo.

Testes existentes de seis missões/perfis, cancelamento, repetição, salvamento
e tentativa errada adaptados apenas para a nova confirmação explícita.
Contrato de tamanho do Melo passa a respeitar largura responsiva com
mínimo de 152 x 144; pergunta continua amarela.

Novos testes: quatro telas/escala incluindo 600x390 texto 1,4; seleção
não premia nem mostra consequência, troca de seleção antes de confirmar
não conta erro, confirmação premia pelo motor, cenário/cores/ícone de
voz, rotação e cancelamento sem recompensa, modo noturno.

Entrega CPB cumulativa com backup e validação Windows. Nenhum commit,
push, merge ou homologação automática.
