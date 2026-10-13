# FAST22A WORK R14 — missão dentro do bairro

Proposta aprovada em 12/10/2026, após sincronização e homologação no celular da R13 = PASS. Base: main 1c1739f0ce0eac895e526e7405b114d469281a70.

## Experiência

Uma única tela de bairro. Retirados o título externo Zona 1 — Bairro/Escola, o quadro de apresentação e a seção Cidade Evolutiva/Antes/Depois. Mantidos cenário R13, pontuação, medalha real, seis missões e melhorias. Controles discretos: voltar ao mapa de Fortaleza, dia/noite, Meu Progresso e avanço para Zona 2 apenas quando desbloqueada.

Ao tocar uma missão liberada, janela modal sobre o bairro, sem substituir a tela do mapa. O mapa volta ao topo antes da abertura, deixando a escola visível ao fundo no celular. Janela com cores do jogo, nome da missão, Melo, cena, pergunta e alternativas. Mantida a sequência do motor: introdução, escolha, consequência, explicação do Melo, resultado. Resposta errada permite tentar novamente na mesma janela; resposta correta salva antes de liberar o retorno ao bairro. Estrelas, pontuação, medalha e desbloqueios atualizados pelo PlayerController existente.

No celular, margens menores e conteúdo rolável; cabeçalho e saída permanecem acessíveis. Fechar antes de concluir não gera prêmio. Salvamento bloqueia saída e impede reentrada; falha informa o problema e oferece nova tentativa. Repetição mostra que as recompensas já foram recebidas e preserva a melhor marca. Faixita continua acessível no resultado como consulta opcional.

## Iluminação

Botão dia/noite muda apenas a visualização. À noite, os postes brilham somente se ILUMINACAO_ESCOLAR foi comprada. Não compra, concede nem altera progresso. Geometria das faixas, ciclovia e assets preservados.

## Escopo e compatibilidade

Controllers, dados por perfil, perguntas, opções, scoring, custos, regras, bônus, persistência e serviços preservados. Rotas externas de missões permanecem disponíveis para compatibilidade e para as demais zonas. Os cliques da Zona 1 usam a nova janela. O widget legado de comparação não é mais instanciado no mapa da Zona 1; não foi removido do código para preservar consumidores/testes independentes.

Teste FAST9 atualizado para aceitar ausência de rolagem quando a tela simplificada cabe inteira, mantendo verificações de rolagem onde existe conteúdo excedente. Testes de interação da Zona 1 agora verificam seis janelas corretas, em vez de seis rotas externas. Novo teste percorre as seis missões em três perfis/tamanhos, persistência, medalha, idempotência, cancelamento, erro/repetição, falha de gravação, modo noturno real e celular horizontal com texto ampliado.

Instalador admite apenas a base R13 verificada, guarda backup/log e cria a branch local feat/fast-22a-zona1-missoes-integradas quando iniciado na main. Verificações textuais aceitam apenas diferença de CRLF/LF; alterações reais de conteúdo interrompem a aplicação. Sem commit/push/merge automáticos. Homologação visual Web/celular necessária antes do fechamento.
