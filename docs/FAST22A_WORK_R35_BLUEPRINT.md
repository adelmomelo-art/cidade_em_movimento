# R35 — Experiência de vídeo: Travessia Segura

Baseline: eb09fc16a4e7327918f180a063d189ee76896a2c (R34).
Branch: feat/fast-22a-video-travessia-r35.

## Escopo
Somente Z1_M01, perfil Criança/menino, inclusive identificadores legados masculinos. Os outros perfis e missões mantêm a ilustração. Arquivo enviado pelo usuário, 1280×720, 24 fps, 10,005 s, incluído no aplicativo; nenhuma URL externa.

A cena ocupa o quadro existente (340,255,753,651), sem recorte, com fundo azul e controles de reproduzir/pausar e repetir. O áudio permanece em zero. Reprodução automática única quando permitida; movimento reduzido pede reprodução manual. Falhas de carregamento/decodificação preservam a cena aprovada ao fundo. O final permanece parado e permite repetir.

O vídeo pausa ao sair do aplicativo, ocultar a rota ou avançar para consequência/feedback/resultado. Fechar a missão libera o player. Rotação mantém a instância e a posição enquanto o diálogo permanecer montado. O motor de missão, perguntas, respostas, pontuação e persistência não foram alterados.

## Limites
É uma experiência visual. O vídeo enviado ainda requer revisão pedagógica antes da adoção definitiva: o carro chega a ocupar a faixa. Não representa aprovação final de conteúdo. As correções de textos cortados e animação de veículos continuam fora deste trabalho.

Dependência oficial video_player fixada em 2.11.1, compatível com Dart >=3.10/Flutter >=3.38; interface de teste 6.6.0. pubspec.lock será gerado pelo flutter pub get, protegido por backup e incluído no futuro commit. Sem alterações no conteúdo dos avatares e cenários aprovados.
