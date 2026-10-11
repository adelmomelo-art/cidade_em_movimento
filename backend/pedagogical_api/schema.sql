CREATE TABLE IF NOT EXISTS pedagogical_snapshots (
  player_id TEXT PRIMARY KEY,
  profile_type TEXT NOT NULL,
  completed_missions INTEGER NOT NULL DEFAULT 0,
  total_stars INTEGER NOT NULL DEFAULT 0,
  completed_zones INTEGER NOT NULL DEFAULT 0,
  medals INTEGER NOT NULL DEFAULT 0,
  purchased_upgrades INTEGER NOT NULL DEFAULT 0,
  sign_duel_best_correct INTEGER NOT NULL DEFAULT 0,
  payload_json TEXT NOT NULL,
  updated_at TEXT NOT NULL,
  received_at TEXT NOT NULL
);
CREATE INDEX IF NOT EXISTS idx_pedagogical_profile_type ON pedagogical_snapshots(profile_type);