const router = require('express').Router();

module.exports = (api) => {
    router.get('/',
        api.actions.artist.findAll);

    router.get('/:id',
        api.actions.artist.findOne);

    router.get('/:title',
        api.actions.artist.findByTitle);

    router.post('/',
        api.middlewares.ensureAuthentificated,
        api.middlewares.bodyParser.json(),
        api.middlewares.cache.clean('Album'),
        api.actions.artist.create);

    router.put('/:id',
        api.middlewares.ensureAuthentificated,
        api.middlewares.bodyParser.json(),
        api.actions.artist.update);

    router.delete('/:id',
        api.middlewares.ensureAuthentificated,
        api.actions.artist.remove);

    return router;
}
