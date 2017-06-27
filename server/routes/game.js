const router = require('express').Router();

module.exports = (api) => {

    router.get('/:id',
        api.actions.game.findById);

    router.get('/user/:id',
        api.actions.game.findByUser);

    router.get('/difficulty/:difficulty/:start/:limit',
        api.actions.game.findByDifficulty);

    router.post('/',
        api.middlewares.bodyParser.json(),
        api.middlewares.ensureAuthentificated,
        api.middlewares.cache.clean("Game"),
        api.actions.game.create);

    router.put('/score/:id',
        api.middlewares.bodyParser.json(),
        api.actions.score.update);

    return router;
}
