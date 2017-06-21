const router = require('express').Router();

module.exports = (api) => {
    router.get('/',
        api.actions.album.findAll);

    router.get('/:id',
        api.actions.album.findOne);

    router.get('/:title',
        api.actions.album.findByTitle);

    router.post('/',
        api.middlewares.ensureAdmin,
        api.middlewares.bodyParser.json(),
        api.middlewares.musicalContentCreation,
        api.middlewares.cache.clean('Album'),
        api.actions.album.create);

    router.put('/:id',
        api.middlewares.ensureAdmin,
        api.middlewares.bodyParser.json(),
        api.actions.album.update);

    router.delete('/:id',
        api.middlewares.ensureAdmin,
        api.actions.album.remove);

    return router;
}
