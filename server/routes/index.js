module.exports = (api) => {
    api.use('/auth', require('./auth')(api));
    api.use('/game', require('./game')(api));
    api.use('/album', require('./musicalContent/album')(api));
    api.use('/artist', require('./musicalContent/artist')(api));
    api.use('/kind', require('./musicalContent/kind')(api));
    api.use('/playlist', require('./musicalContent/playlist')(api));
    api.use('/song', require('./musicalContent/song')(api));
    api.use('/rank', require('./rank')(api));
    api.use('/reward', require('./reward')(api));
    api.use('/stats', require('./stats')(api));
    api.use('/users', require('./users')(api));
};
