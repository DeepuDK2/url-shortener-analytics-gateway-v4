-- Schema definition for High-Performance URL Shortener & Analytics Gateway
CREATE TABLE IF NOT EXISTS transactions (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  idempotency_key VARCHAR(128) UNIQUE NOT NULL,
  tenant_id UUID NOT NULL,
  payload JSONB NOT NULL,
  status VARCHAR(32) NOT NULL DEFAULT 'PENDING',
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- Compound B-Tree indexes for sub-10ms queries under heavy write load
CREATE INDEX IF NOT EXISTS idx_transactions_tenant_created 
  ON transactions (tenant_id, created_at DESC);

CREATE INDEX IF NOT EXISTS idx_transactions_status_created 
  ON transactions (status, created_at);
