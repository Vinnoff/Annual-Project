const router = require('express').Router();

module.exports = (api) => {
	router.get('/',
		api.actions.reward.findSortedByScore);

	router.get('/range/:min/:max',
		api.actions.reward.findInRange);

	router.get('/id/:id',
		api.actions.reward.findById);

	router.post('/',
		api.middlewares.ensureAuthentificated,
		api.middlewares.ensureAdmin,
		api.middlewares.bodyParser.json(),
		api.middlewares.cache.clean("Reward"),
		api.actions.reward.create);

	router.put('/:id',
		api.middlewares.ensureAuthentificated,
		api.middlewares.ensureAdmin,
		api.middlewares.bodyParser.json(),
		api.actions.reward.update)

	router.delete('/:id',
		api.middlewares.ensureAuthentificated,
		api.middlewares.ensureAdmin,
		api.actions.reward.remove)

	return router;
}