const router = require('express').Router();

module.exports = (api) => {
	router.get('/',
		api.middlewares.cache.get,
		api.actions.users.findAll);

	router.get('/:start/:limit',
		api.middlewares.cache.get,
		api.actions.users.findSorted);

	router.get('/:id',
		api.actions.users.findById);

	router.get('/userName/:userName',
		api.actions.users.findByUserName);

	router.post('/',
		api.middlewares.bodyParser.json(),
		api.middlewares.cache.clean('User'),
		api.actions.users.create);

	router.put('/:id',
		api.middlewares.bodyParser.json(),
		api.middlewares.ensureAuthentificated,
		api.actions.users.update);

	router.put('/:id/globalScore',
		api.middlewares.bodyParser.json(),
		api.middlewares.ensureAuthentificated,
		api.actions.users.updateGlobalScore);

	router.put('/friend/:id',
		api.middlewares.bodyParser.json(),
		api.middlewares.ensureAuthentificated,
		api.actions.users.updateFriends)

	router.delete('/:id',
		api.middlewares.ensureAuthentificated,
		api.actions.users.remove);

	return router;
}
