const router = require('koa-joi-router');
const MiscController = require('../controllers/misc');

const miscRouter = router();

// const { Joi } = router;

miscRouter.prefix('');

miscRouter.route({
  meta: {
    swagger: {
      summary: 'Get API Info',
      description: 'Show API name, version, description, environments (node version, hostname, platform)',
      tags: ['misc'],
    }
  },
  method: 'get',
  path: '/',
  validate: {},
  handler: MiscController.getApiInfo
});

miscRouter.route({
  meta: {
    swagger: {
      summary: 'Get API Status',
      description: 'Show current status',
      tags: ['misc'],
    }
  },
  method: 'get',
  path: '/status',
  validate: {},
  handler: MiscController.healthCheck
});

module.exports = miscRouter;
