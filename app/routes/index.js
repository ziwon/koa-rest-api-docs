const miscRouter = require('./misc');
const specRouter = require('./spec');
const userRouter = require('./user');

const routes = [
  miscRouter.middleware(),
  specRouter.middleware(),
  userRouter.middleware(),
];

module.exports = routes;
