const Schema = require('mongoose').Schema;
const timestamps = require('mongoose-timestamps');

module.exports = (api) => {
    const schema = new Schema({
        scoreInGame: {
            type: Number,
            required: true
        },
        User: {
            type: Schema.Types.ObjectId,
            ref: 'User',
            required: true
        },
        Game: {
            type: Schema.Types.ObjectId,
            ref: 'Game',
            required: true
        }
    });

    schema.plugin(timestamps);
    return api.mongoose.model('Score', schema);
};
