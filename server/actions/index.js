module.exports = (api) => {
  api.actions = {
    album: require('./album/crud')(api),
    artist: require('./artist/crud')(api),
    auth: require('./auth')(api),
    game: require('./game/crud')(api),
    kind: require('./kind/crud')(api),
    playlist: require('./playlist/crud')(api),
    rank: require('./rank/crud')(api),
    reward: require('./reward/crud')(api),
    score: require('./score/crud')(api),
    song: require('./song/crud')(api),
    users: require('./users/crud')(api)
  };
};
