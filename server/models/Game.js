const Schema = require('mongoose').Schema;
const timestamps = require('mongoose-timestamps');

module.exports = (api) => {
    const schema = new Schema({
        Songs: [{
            type: Schema.Types.ObjectId,
            ref: 'Song'
        }],
        Scores: [{
            type: Schema.Types.ObjectId,
            ref: 'Score'
        }],
        Players: [{
            type: Schema.Types.ObjectId,
            ref: 'User'
        }],
        difficulty: {
            type: Number
        },
        isMultiplayer: {
            type: Boolean,
            default: false
        },
        isPublic: {
            type: Boolean,
            default: false
        }
    });

    schema.plugin(timestamps);
    return api.mongoose.model('Game', schema);
};
