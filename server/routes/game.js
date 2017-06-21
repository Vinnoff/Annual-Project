const router = require('express').Router();

module.exports = (api) => {
    router.get('/',
        api.middlewares.ensureAdmin,
        api.actions.game.findAll);

    router.get('/user/:id',
        api.actions.game.findByUser);

    router.get('/sorted/:id',
        api.actions.game.findSortedByUser);

    router.post('/',
        api.middlewares.bodyParser.json(),
        api.middlewares.ensureAuthenticated,
        api.middlewares.cache.clean("Game"),
        api.actions.game.create);

    router.post('/score',
        api.middlewares.bodyParser.json(),
        api.middlewares.ensureAuthenticated,
        api.middlewares.cache.clean("Score"),
        api.actions.score.create);

    router.put('/score/:id',
        api.middlewares.bodyParser.json(),
        api.actions.score.update);

    return router;
}
