const router = require('koa-joi-router');
const SpecController = require('../controllers/spec');

const specRouter = router();

// const { Joi } = router;

specRouter.prefix('');

specRouter.route({
  method: 'get',
  path: '/spec',
  validate: {},
  handler: SpecController.spec
});

specRouter.route({
  method: 'get',
  path: '/docs',
  validate: {},
  handler: SpecController.redoc
});

// TODO: not working properly
specRouter.route({
  method: 'get',
  path: '/swagger',
  validate: {},
  handler: SpecController.swagger
});

module.exports = specRouter;
