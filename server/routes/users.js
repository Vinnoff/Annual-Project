const router = require('express').Router();

module.exports = (api) => {
    router.get('/',
        api.middlewares.cache.get,
        api.actions.users.findAll);

    router.get('/:id',
        api.actions.users.findByUserName);

    router.get('/friends',
        api.actions.users.findFriends);

    router.post('/',
        api.middlewares.bodyParser.json(),
        api.middlewares.cache.clean('User'),
        api.actions.users.create);

    router.put('/:id',
        api.middlewares.ensureAuthentificated,
        api.middlewares.bodyParser.json(),
        api.actions.users.update);

    router.delete('/:id',
        api.middlewares.ensureAuthentificated,
        api.actions.users.remove);

    return router;
}
