'use strict';

const supertest = require('supertest');
const os = require('os');
const pkg = require('../../package.json');
const app = require('../../app');


const server = app.listen();

afterAll(async () => {
  await app.terminate();
});

describe('Misc', () => {
  const request = supertest(server);

  describe('GET /', () => {
    it('<200> should always return with the API server information', async () => {
      const res = await request
        .get('/')
        .expect('Content-Type', /json/)
        .expect(200);

      const info = res.body;
      const expected = ['name', 'version', 'description', 'environments'];
      expect(Object.keys(info)).toEqual(expect.arrayContaining(expected));
      expect(info.name).toBe(pkg.name);
      expect(info.version).toBe(pkg.version);
      expect(info.description).toBe(pkg.description);
      expect(info.environments).toBeInstanceOf(Object);

      const environments = info.environments;
      expect(environments.hostname).toBe(os.hostname());
      expect(environments.node_version).toBe(process.versions['node']);
      expect(environments.platform).toBe(`${process.platform}/${process.arch}`);
    });
  });

  describe('GET /status', () => {
    it('<200> should return `healthy` status if all components are healthy', async () => {
      const res = await request
        .get('/status')
        .expect('Content-Type', /json/)
        .expect(200);

      const { status } = res.body;
      expect(status).toBe('pass');
    });
  });
});
