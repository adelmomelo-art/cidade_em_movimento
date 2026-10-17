# R36 — Validação

## Verificações de preparação
- Posições/dimensões numéricas dos seis mapas e seis janelas comparadas à R34: preservadas.
- Conteúdo das missões, controladores, pontuação e assets: protegidos por hashes de baseline.
- Teste novo: rótulos completos nos seis componentes com espaçamento herdado e escalas 1,0/1,4/2,0; pergunta e respostas da missão Embarque Seguro nos três perfis.
- Testes Flutter, builds e homologação visual: executar no Windows, sem presumir PASS.

## Gates
G1 pub get, formatação e analyze; G2 textos e regressões visuais/funcionais das seis zonas; G3 suíte completa; G4 Web release; G5 APK release; G6 diff check e integridade.

## Homologação
1. Zona 1: Conhecimento e Progresso completos em uma linha, inclusive após liberar Próxima zona.
2. Embarque Seguro: pergunta, três alternativas e confirmação menores e legíveis, sem cortes e sem rolagem; mesma janela/Melo.
3. Conferir os mesmos elementos nas zonas 2 a 6.
4. Conferir Criança, Adolescente e Adulto; textos longos devem caber integralmente.
5. Conferir consequência e Melo explica, acertar/errar/repetir e fechar: persistência e prêmios preservados.
6. Repetir no Chrome, A05 horizontal e tablet; registrar novas ocorrências com zona/missão/perfil.

VALIDACAO TECNICA = PENDENTE
CHROME = PENDENTE
A05 HORIZONTAL = PENDENTE
TABLET = PENDENTE
OBSERVACOES =

Sem fechamento no Git até técnica e visual PASS.
