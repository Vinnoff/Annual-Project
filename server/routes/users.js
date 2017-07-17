const router = require('express').Router();

module.exports = (api) => {
	router.get('/',
		api.middlewares.cache.get,
		api.actions.users.findAll);

	router.get('/sorted/:start/:limit',
		api.middlewares.cache.get,
		api.actions.users.findSorted);

	router.get('/id/:id',
		api.actions.users.findById);

	router.get('/userName/:userName',
		api.actions.users.findByUserName);

	router.get('/userNameResearch/:userName',
		api.actions.users.findByAproximateUserName);

	router.post('/',
		api.middlewares.bodyParser.json(),
		api.middlewares.cache.clean('User'),
		api.actions.users.create);

	router.put('/:id',
		api.middlewares.bodyParser.json(),
		api.middlewares.ensureAuthentificated,
		api.actions.users.update);

	router.put('/friend/:firstId/:secondId',
		api.middlewares.bodyParser.json(),
		api.middlewares.ensureAuthentificated,
		api.actions.users.updateFriends)

	router.delete('/:id',
		api.middlewares.ensureAuthentificated,
		api.middlewares.cache.clean('User'),
		api.actions.users.remove);

	router.get('/preferences/:id',
		api.middlewares.bodyParser.json(),
		api.actions.preferences.findById);

	router.put('/preferences/:id',
		api.middlewares.bodyParser.json(),
		api.actions.preferences.update);

	return router;
}
