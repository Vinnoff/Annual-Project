const mongoose = require('mongoose');
const fs = require('fs');

module.exports = (api) => {
    api.mongoose = mongoose.connect(api.settings.db.url);

    api.models = {
        Album: require('./Album')(api),
        Artist: require('./Artist')(api),
        Content: require('./Content')(api),
        Game: require('./Game')(api),
        Kind: require('./Kind')(api),
        Playlist: require('./Playlist')(api),
        Preferences: require('./Preferences')(api),
        Rank: require('./Rank')(api),
        Reward: require('./Reward')(api),
        Score: require('./Score')(api),
        Song: require('./Song')(api),
        Statistics: require('./Statistics')(api),
        Token: require('./Token')(api),
        User: require('./User')(api)
    };
};
