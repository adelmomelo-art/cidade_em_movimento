import test from 'node:test';
import assert from 'node:assert/strict';

import worker from '../worker.mjs';

test('health Faixita responde contrato V1', async () => {
  const response = await worker.fetch(
    new Request('https://example.test/health'),
    {},
  );

  assert.equal(response.status, 200);
  const body = await response.json();
  assert.equal(body.ok, true);
  assert.equal(body.version, 1);
});

test('request invalido retorna 400', async () => {
  const response = await worker.fetch(
    new Request('https://example.test/v1/faixita/chat', {
      method: 'POST',
      headers: { 'content-type': 'application/json' },
      body: JSON.stringify({ question: '' }),
    }),
    {},
  );

  assert.equal(response.status, 400);
});

test('sem provider configurado retorna 503', async () => {
  const response = await worker.fetch(
    new Request('https://example.test/v1/faixita/chat', {
      method: 'POST',
      headers: { 'content-type': 'application/json' },
      body: JSON.stringify({
        question: 'O que devo estudar?',
        profileType: 'adult',
        progress: {},
      }),
    }),
    {},
  );

  assert.equal(response.status, 503);
  const body = await response.json();
  assert.equal(body.error, 'provider_not_configured');
});