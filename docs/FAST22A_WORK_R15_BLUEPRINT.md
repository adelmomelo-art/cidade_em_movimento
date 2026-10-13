# FAST22A WORK R15 — navegação no mapa e perguntas destacadas

Proposta aprovada em 12/10/2026. Preferência final: cenário horizontal, responsivo no Web e celular. Vertical continua funcional; não há bloqueio de orientação.

## Navegação dentro do cenário

Retirada a linha externa de controles. Mapa de Fortaleza, Dia/Noite, Meu Progresso e Próxima Zona ficam em um balão branco dentro do quadro principal. Na tela larga, canto superior direito, ao lado dos KPIs de Cidadania, Conhecimento, Moedas e Estrelas; espaços separados, sem cobrir a medalha. No celular estreito, segunda linha abaixo dos indicadores, ainda dentro do quadro. Avanço só aparece quando o motor libera Zona 2. Ícones com dicas e áreas de toque mínimas de 48 px.

Margens menores e largura adaptável até 1600 px. Composição horizontal original preservada, sem esticar ou cortar a arte do bairro na vertical: no celular estreito, imagem proporcional na parte superior e controles abaixo dentro do mesmo quadro. Em telas baixas pode haver rolagem para manter texto e toque confortáveis. Não há trava de orientação. Aviso discreto recomenda girar o celular; pode ser fechado com Continuar na vertical. O aviso desaparece em paisagem.

## Perguntas

Melo passa de 76x72 para 152x144 px, aumento exato de 100%. Em janela estreita, desenho acima da orientação para não apertar o texto; em janela larga, ao lado. Enunciado em caixa amarelo suave (#FFEDAC), texto azul-escuro e borda amarela; alternativas brancas. Pergunta, consequência, explicação e resultado seguem na mesma janela sobre o bairro, com rolagem quando necessária.

## Preservação

Conteúdo pedagógico, perguntas e alternativas por perfil, controllers, scoring, regras, custos, persistência, medalha, recompensas e quatro assets preservados. Faixas, ciclovia e iluminação mantidas. Inclui integralmente a R14 para aplicação tanto sobre R13 sincronizada quanto sobre R14 ainda sem commit. Base Git 1c1739f; branch local feat/fast-22a-zona1-missoes-integradas. Sem commit/push/merge automáticos.

## Melhoria futura — voz do Melo

Narrar pergunta, alternativas e explicação com identidade de voz consistente. Prever Ouvir novamente, silenciar e texto sempre visível. Avaliar funcionamento sem internet, qualidade da voz, acessibilidade e tamanho do pacote antes da implementação. Não há áudio, permissões ou botões de voz simulados nesta entrega.
