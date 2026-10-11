import test from 'node:test';
import assert from 'node:assert/strict';
import worker from '../worker.mjs';

test('health contrato V1', async () => {
  const response = await worker.fetch(new Request('https://example.test/health'), {});
  assert.equal(response.status, 200);
  const body = await response.json();
  assert.equal(body.ok, true);
  assert.equal(body.version, 1);
});

test('snapshot invalido retorna 400', async () => {
  const response = await worker.fetch(new Request('https://example.test/v1/pedagogical/snapshots', { method: 'POST', headers: { 'content-type': 'application/json' }, body: JSON.stringify({ schemaVersion: 1 }) }), {});
  assert.equal(response.status, 400);
});