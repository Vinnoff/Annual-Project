const router = require('express').Router();

module.exports = (api) => {
    router.get('/',
        api.middlewares.musicalContent.get,
        api.actions.kind.findAll);

    router.get('/:id',
        api.actions.kind.findOne);

    router.get('/:title',
        api.actions.kind.findByTitle);

    router.post('/',
        api.middlewares.ensureAdmin,
        api.middlewares.bodyParser.json(),
        api.middlewares.musicalContentCreation,
        api.middlewares.cache.clean('Album'),
        api.actions.kind.create);

    router.put('/:id',
        api.middlewares.ensureAdmin,
        api.middlewares.bodyParser.json(),
        api.actions.kind.update);

    router.delete('/:id',
        api.middlewares.ensureAdmin,
        api.actions.kind.remove);

    return router;
}
