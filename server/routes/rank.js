const router = require('express').Router();

module.exports = (api) => {
    router.get('/',
        api.actions.rank.findAll);

    router.get('/:nb',
        api.actions.rank.findByNb);

    router.post('/',
        api.middlewares.ensureAuthentificated,
        api.middlewares.ensureAdmin,
        api.middlewares.bodyParser.json(),
        api.middlewares.cache.clean("Rank"),
        api.actions.rank.create);

    router.put('/:title',
        api.middlewares.ensureAuthentificated,
        api.middlewares.ensureAdmin,
        api.middlewares.bodyParser.json(),
        api.actions.rank.update)

    router.delete('/:title',
        api.middlewares.ensureAuthentificated,
        api.middlewares.ensureAdmin,
        api.actions.rank.remove)

    return router;
}
