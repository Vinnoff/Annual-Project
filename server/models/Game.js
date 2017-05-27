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
        dificulty: {
            type: Number
        },
        isMultiplayer: {
            type: Boolean,
            required: true
        }
    });

    schema.plugin(timestamps);
    return api.mongoose.model('Game', schema);
};
