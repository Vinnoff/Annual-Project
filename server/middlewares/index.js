module.exports = (api) => {
    api.middlewares = {
        bodyParser: require('body-parser'),
        cache: require('./cache'),
        ensureAuthentificated: require('./ensureAuthentificated')(api),
        ensureAdmin: require('./ensureAdmin')(api),
        musicalContentCreation: require('./musicalContentCreation')(api)
    };
};
