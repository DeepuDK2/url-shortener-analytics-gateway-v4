import { executeCoreTransaction } from '../src/core/engine';

describe('High-Performance URL Shortener & Analytics Gateway - Core Engine Suite', () => {
  it('should process transaction successfully with sub-50ms execution time', async () => {
    const key = `test_${Date.now()}`;
    const result = await executeCoreTransaction(key, { amount: 100, currency: 'USD' });
    
    expect(result.status).toBe('PROCESSED');
    expect(result.idempotencyKey).toBe(key);
    expect(result.executionTimeMs).toBeLessThan(50);
  });

  it('should reject duplicate executions with the same idempotency key', async () => {
    const key = `dup_${Date.now()}`;
    await executeCoreTransaction(key, { data: 'first' });

    await expect(executeCoreTransaction(key, { data: 'duplicate' }))
      .rejects
      .toThrow('Duplicate transaction');
  });
});
