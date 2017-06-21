const router = require('express').Router();

module.exports = (api) => {
    router.get('/:id',
        api.middlewares.ensureAdmin,
        api.actions.stats.findById);

    router.post('/',
        api.middlewares.ensureAdmin,
        api.middlewares.bodyParser.json(),
        api.middlewares.cache.clean("Reward"),
        api.actions.stats.create);

    router.put('/:id',
        api.middlewares.ensureAdmin,
        api.middlewares.bodyParser.json(),
        api.actions.stats.update)

    router.delete('/:id',
        api.middlewares.ensureAdmin,
        api.actions.stats.remove)

    return router;
}
