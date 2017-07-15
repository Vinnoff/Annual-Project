const router = require('express').Router();

module.exports = (api) => {
  router.get('/',
    api.middlewares.cache.get,
    api.actions.score.findAll);

  return router;
}
