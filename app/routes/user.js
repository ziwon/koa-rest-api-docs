const router = require('koa-joi-router');
const UserController = require('../controllers/user');

const userRouter = router();

const { Joi } = router;

userRouter.prefix('/user');

userRouter.route({
  meta: {
    swagger: {
      summary: 'Get User Info',
      description: `
        Note:
        Sensitive data can only be viewed by the \`corresponding user\` or \`Admin\`.
        `,
      tags: ['users']
    }
  },
  method: 'get',
  path: '/:id',
  validate: {
    params: {
      _id: Joi.string().alphanum().max(24).example('abcdefg').description('User id').required()
    },
    output: {
      '200-299': {
        body: Joi.object({
          userId: Joi.string().description('User id')
        }).options({
          allowUnknown: true
        }).description('User object')
      },
      '500': {
        body: Joi.object({
          message: Joi.string().description('error message')
        }).description('error body')
      }
    }
  },
  handler: UserController.getOne
});

userRouter.route({
  meta: {
    swagger: {
      summary: 'User Signup',
      description: 'Signup with username and password.',
      tags: ['users']
    }
  },
  method: 'post',
  path: '/signup',
  validate: {
    type: 'json',
    body: Joi.object({
      username: Joi.string().alphanum().min(3).max(30).required(),
      password: Joi.string().alphanum().min(6).max(30).required()
    }).example({ username: 'abcdefg', password: '123123' }),
    output: {
      200: {
        body: {
          userId: Joi.string().description('Newly created user id')
        }
      },
      500: {
        body: {
          code: Joi.number().description('error code'),
        }
      }
    }
  },
  handler: UserController.postSignUp
});

module.exports = userRouter;
