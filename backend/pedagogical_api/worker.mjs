const JSON_HEADERS = { 'content-type': 'application/json; charset=utf-8', 'cache-control': 'no-store' };
const json = (data, status = 200) => new Response(JSON.stringify(data), { status, headers: JSON_HEADERS });

function validSnapshot(p) {
  return p && p.schemaVersion === 1 && typeof p.playerId === 'string' && p.playerId.length >= 8 && typeof p.profileType === 'string' && typeof p.updatedAt === 'string';
}

export default {
  async fetch(request, env) {
    const url = new URL(request.url);
    if (request.method === 'GET' && url.pathname === '/health') {
      return json({ ok: true, service: 'cidade-em-movimento-pedagogical-api', version: 1 });
    }
    if (request.method === 'GET' && url.pathname === '/v1/pedagogical/summary') {
      if (!env.DB) return json({ ok: false, error: 'database_not_configured' }, 503);
      const summary = await env.DB.prepare(`SELECT COUNT(*) AS players, ROUND(AVG(completed_missions),2) AS avg_completed_missions, ROUND(AVG(total_stars),2) AS avg_total_stars, ROUND(AVG(completed_zones),2) AS avg_completed_zones, ROUND(AVG(sign_duel_best_correct),2) AS avg_sign_duel_best_correct FROM pedagogical_snapshots`).first();
      return json({ ok: true, summary: summary || {} });
    }
    if (request.method === 'POST' && url.pathname === '/v1/pedagogical/snapshots') {
      let p;
      try { p = await request.json(); } catch { return json({ ok: false, error: 'invalid_json' }, 400); }
      if (!validSnapshot(p)) return json({ ok: false, error: 'invalid_snapshot' }, 400);
      if (!env.DB) return json({ ok: false, error: 'database_not_configured' }, 503);
      await env.DB.prepare(`INSERT INTO pedagogical_snapshots (player_id, profile_type, completed_missions, total_stars, completed_zones, medals, purchased_upgrades, sign_duel_best_correct, payload_json, updated_at, received_at) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?) ON CONFLICT(player_id) DO UPDATE SET profile_type=excluded.profile_type, completed_missions=excluded.completed_missions, total_stars=excluded.total_stars, completed_zones=excluded.completed_zones, medals=excluded.medals, purchased_upgrades=excluded.purchased_upgrades, sign_duel_best_correct=excluded.sign_duel_best_correct, payload_json=excluded.payload_json, updated_at=excluded.updated_at, received_at=excluded.received_at`)
        .bind(p.playerId, p.profileType, Number(p.completedMissions || 0), Number(p.totalStars || 0), Number(p.completedZones || 0), Number(p.medals || 0), Number(p.purchasedUpgrades || 0), Number(p.signDuelBestCorrect || 0), JSON.stringify(p), p.updatedAt, new Date().toISOString()).run();
      return json({ ok: true });
    }
    return json({ ok: false, error: 'not_found' }, 404);
  },
};