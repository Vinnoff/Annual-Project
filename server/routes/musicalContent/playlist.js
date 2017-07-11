const router = require('express').Router();

module.exports = (api) => {
    router.get('/',
        api.actions.playlist.findAll);

    router.get('/:id',
        api.actions.playlist.findOne);

    router.get('/:title',
        api.actions.playlist.findByTitle);

    router.get('/allsongs',
        api.actions.playlist.getAllSongs);

    router.post('/',
        api.middlewares.ensureAuthentificated,
        api.middlewares.bodyParser.json(),
        api.middlewares.cache.clean('Album'),
        api.actions.playlist.create);

    router.put('/:id',
        api.middlewares.ensureAuthentificated,
        api.middlewares.bodyParser.json(),
        api.actions.playlist.update);

    router.put('/addsong/:id',
        api.middlewares.ensureAuthentificated,
        api.middlewares.bodyParser.json(),
        api.actions.playlist.putSong);

    router.delete('/:id',
        api.middlewares.ensureAuthentificated,
        api.actions.playlist.remove);

    router.delete('/delsong/:id',
        api.middlewares.ensureAuthentificated,
        api.actions.playlist.delSong);

    return router;
}
