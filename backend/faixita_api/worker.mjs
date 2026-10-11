const JSON_HEADERS = {
  'content-type': 'application/json; charset=utf-8',
  'cache-control': 'no-store',
};

function json(data, status = 200) {
  return new Response(JSON.stringify(data), {
    status,
    headers: JSON_HEADERS,
  });
}

function validPayload(payload) {
  return (
    payload &&
    typeof payload.question === 'string' &&
    payload.question.trim().length > 0 &&
    payload.question.length <= 800 &&
    typeof payload.profileType === 'string'
  );
}

export default {
  async fetch(request, env) {
    const url = new URL(request.url);

    if (request.method === 'GET' && url.pathname === '/health') {
      return json({
        ok: true,
        service: 'cidade-em-movimento-faixita-api',
        version: 1,
      });
    }

    if (request.method === 'POST' && url.pathname === '/v1/faixita/chat') {
      let payload;

      try {
        payload = await request.json();
      } catch {
        return json({ ok: false, error: 'invalid_json' }, 400);
      }

      if (!validPayload(payload)) {
        return json({ ok: false, error: 'invalid_request' }, 400);
      }

      if (!env.FAIXITA_PROVIDER_URL || !env.FAIXITA_PROVIDER_TOKEN) {
        return json(
          {
            ok: false,
            error: 'provider_not_configured',
          },
          503,
        );
      }

      const prompt = [
        'Voce e Faixita, mentora pedagogica do jogo Cidade em Movimento.',
        'Responda em portugues brasileiro, de forma acolhedora, objetiva e educativa.',
        'Foque em educacao para o transito, cidadania, mobilidade, seguranca e conteudo do jogo.',
        'Nao invente leis, artigos ou penalidades. Quando nao houver base suficiente, diga que nao pode afirmar.',
        'Nao solicite dados pessoais.',
        'Perfil: ' + payload.profileType,
        'Contexto de progresso: ' + JSON.stringify(payload.progress || {}),
        'Resultado de missao: ' + JSON.stringify(payload.missionResult || null),
        'Pergunta: ' + payload.question,
      ].join('\n');

      try {
        const providerResponse = await fetch(env.FAIXITA_PROVIDER_URL, {
          method: 'POST',
          headers: {
            'content-type': 'application/json',
            authorization: `Bearer ${env.FAIXITA_PROVIDER_TOKEN}`,
          },
          body: JSON.stringify({
            prompt,
          }),
        });

        if (!providerResponse.ok) {
          return json({ ok: false, error: 'provider_failed' }, 502);
        }

        const providerBody = await providerResponse.json();
        const answer =
          typeof providerBody.answer === 'string'
            ? providerBody.answer.trim()
            : '';

        if (!answer) {
          return json({ ok: false, error: 'empty_provider_answer' }, 502);
        }

        return json({
          ok: true,
          answer,
        });
      } catch {
        return json({ ok: false, error: 'provider_unavailable' }, 502);
      }
    }

    return json({ ok: false, error: 'not_found' }, 404);
  },
};