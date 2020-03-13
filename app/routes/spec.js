const router = require('koa-joi-router');
const SpecController = require('../controllers/spec');

const specRouter = router();

// const { Joi } = router;

specRouter.prefix('');

specRouter.route({
  method: 'get',
  path: '/spec',
  handler: SpecController.spec
});

specRouter.route({
  method: 'get',
  path: '/docs',
  handler: SpecController.redoc
});

specRouter.route({
  method: 'get',
  path: '/console',
  handler: SpecController.swagger
});

module.exports = specRouter;
