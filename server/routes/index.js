module.exports = (api) => {
    api.use('/auth', require('./auth')(api));
    console.log("auth ok")
    api.use('/game', require('./game')(api));
    console.log("game ok")
    api.use('/album', require('./musicalContent/album')(api));
    console.log("album ok")
    api.use('/artist', require('./musicalContent/artist')(api));
    console.log("artist ok")
    api.use('/kind', require('./musicalContent/kind')(api));
    console.log("kind ok")
    api.use('/playlist', require('./musicalContent/playlist')(api));
    console.log("playlist ok")
    api.use('/song', require('./musicalContent/song')(api));
    console.log("song ok")
    api.use('/reward', require('./reward')(api));
    console.log("reward ok")
    api.use('/stats', require('./stats')(api));
    console.log("stats ok")
    api.use('/users', require('./users')(api));
    console.log("users ok")
};
