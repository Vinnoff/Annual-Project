const router = require('express').Router();

module.exports = (api) => {
	router.post('/login/iOs/:id/',
		api.actions.auth.login.iOs);

	router.post('/login/adminSys/',
		api.middlewares.bodyParser.json(),
		api.actions.auth.login.adminSys);

	router.post('/logout',
		api.middlewares.ensureAuthentificated,
		api.actions.auth.logout);

	return router;
}
