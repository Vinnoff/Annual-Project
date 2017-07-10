const router = require('express').Router();

module.exports = (api) => {
    router.get('/',
        api.actions.kind.findAll);

    router.get('/:id',
        api.actions.kind.findOne);

    router.get('/:title',
        api.actions.kind.findByTitle);

    router.post('/',
        api.middlewares.ensureAuthentificated,
        api.middlewares.bodyParser.json(),
        api.middlewares.cache.clean('Album'),
        api.actions.kind.create);

    router.put('/:id',
        api.middlewares.ensureAuthentificated,
        api.middlewares.bodyParser.json(),
        api.actions.kind.update);

    router.delete('/:id',
        api.middlewares.ensureAuthentificated,
        api.actions.kind.remove);

    return router;
}
