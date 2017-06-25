const router = require('express').Router();

module.exports = (api) => {
    router.get('/',
        api.middlewares.cache.get,
        api.actions.users.findAll);

    router.get('/:userName',
        api.actions.users.findByUserName);

    router.post('/',
        api.middlewares.bodyParser.json(),
        api.middlewares.cache.clean('User'),
        api.actions.users.create);

    router.put('/:userName',
        api.middlewares.bodyParser.json(),
        api.middlewares.ensureAuthentificated,
        api.actions.users.update);

    router.delete('/:userName',
        api.middlewares.ensureAuthentificated,
        api.actions.users.remove);

    return router;
}
