'use strict';

const supertest = require('supertest');
const app = require('../../app');

const server = app.listen();

afterAll(async () => {
  await app.terminate();
});

describe('Spec', () => {
  const request = supertest(server);

  describe('GET /spec', () => {
    it('<200> should always return API specification in swagger format', async () => {
      const res = await request
        .get('/spec')
        .expect('Content-Type', /json/)
        .expect(200);

      const spec = res.body;
      // expect(spec).toHaveProperty('openapi', '3.0.0');
      expect(spec).toHaveProperty('info');
      expect(spec).toHaveProperty('paths');
      expect(spec).toHaveProperty('tags');
    });
  });
});
