const Schema = require('mongoose').Schema;
const timestamps = require('mongoose-timestamps');
const fs = require('fs');

module.exports = (api) => {
    const schema = new Schema({
        Artists: [{
            type: Schema.Types.ObjectId,
            ref: 'Artist'
        }],
        Songs: [{
            type: Schema.Types.ObjectId,
            ref: 'Song'
        }],
        Genres: [{
            type: Schema.Types.ObjectId,
            ref: 'Genre'
        }],
        image: {
            type: String
        }
    });

    schema.plugin(timestamps);
    return api.mongoose.model('Album', schema);
};
