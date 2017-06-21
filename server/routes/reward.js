const router = require('express').Router();

module.exports = (api) => {
    router.get('/sorted',
        api.actions.reward.findSortedByScore);

    router.get('/:id',
        api.actions.reward.findById);

    router.post('/',
        api.middlewares.ensureAdmin,
        api.middlewares.bodyParser.json(),
        api.middlewares.cache.clean("Reward"),
        api.actions.reward.create);

    router.put('/:id',
        api.middlewares.ensureAdmin,
        api.middlewares.bodyParser.json(),
        api.actions.reward.update)

    router.delete('/:id',
        api.middlewares.ensureAdmin,
        api.actions.reward.remove)

    return router;
}
