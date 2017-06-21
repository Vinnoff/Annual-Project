const router = require('express').Router();

module.exports = (api) => {
    router.get('/',
        api.middlewares.musicalContent.get,
        api.actions.song.findAll);

    router.get('/:id',
        api.actions.song.findOne);

    router.get('/:title',
        api.actions.song.findByTitle);

    router.post('/',
        api.middlewares.ensureAdmin,
        api.middlewares.bodyParser.json(),
        api.middlewares.musicalContentCreation,
        api.middlewares.cache.clean('Album'),
        api.actions.song.create);

    router.put('/:id',
        api.middlewares.ensureAdmin,
        api.middlewares.bodyParser.json(),
        api.actions.song.update);

    router.delete('/:id',
        api.middlewares.ensureAdmin,
        api.actions.song.remove);

    return router;
}
