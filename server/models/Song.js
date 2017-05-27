const Schema = require('mongoose').Schema;
const timestamps = require('mongoose-timestamps');

module.exports = (api) => {
    const schema = new Schema({
        duration: {
            type: Number
        },
        PlaylistIn: [{
            type: Schema.Types.ObjectId,
            ref: 'Playlist'
        }],
        Artists: [{
            type: Schema.Types.ObjectId,
            ref: 'Artist'
        }],
        Album: {
            type: Schema.Types.ObjectId,
            ref: 'Album'
        }
    });

    schema.plugin(timestamps);
    return api.mongoose.model('Song', schema);
};