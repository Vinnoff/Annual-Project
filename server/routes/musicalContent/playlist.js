const router = require('express').Router();

module.exports = (api) => {
    router.get('/',
        api.actions.playlist.findAll);

    router.get('/:id',
        api.actions.playlist.findOne);

    router.get('/:title',
        api.actions.playlist.findByTitle);

    router.post('/',
        api.middlewares.ensureAdmin,
        api.middlewares.bodyParser.json(),
        api.middlewares.musicalContentCreation,
        api.middlewares.cache.clean('Album'),
        api.actions.playlist.create);

    router.put('/:id',
        api.middlewares.ensureAdmin,
        api.middlewares.bodyParser.json(),
        api.actions.playlist.update);

    router.delete('/:id',
        api.middlewares.ensureAdmin,
        api.actions.playlist.remove);

    return router;
}
