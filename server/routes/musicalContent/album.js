const router = require('express').Router();

module.exports = (api) => {
	router.get('/',
		api.actions.album.findAll);

	router.get('/:id',
		api.actions.album.findOne);

	router.get('/user/:id',
		api.actions.album.findAllFromUser);

	router.get('/title/:title',
		api.actions.album.findByTitle);

	router.get('/allsong/:id',
		api.actions.album.getAllSongs);

	router.post('/',
		api.middlewares.ensureAuthentificated,
		api.middlewares.bodyParser.json(),
		api.middlewares.cache.clean('Album'),
		api.actions.album.create);

	router.put('/:id',
		api.middlewares.ensureAuthentificated,
		api.middlewares.bodyParser.json(),
		api.actions.album.update);

	router.put('/addsong/:id',
		api.middlewares.ensureAuthentificated,
		api.middlewares.bodyParser.json(),
		api.actions.album.update);

	router.delete('/:id',
		api.middlewares.ensureAuthentificated,
		api.actions.album.remove);

	router.delete('/dalsong/:id',
		api.middlewares.ensureAuthentificated,
		api.actions.album.delSong);

	return router;
}
