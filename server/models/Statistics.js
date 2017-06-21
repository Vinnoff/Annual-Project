const Schema = require('mongoose').Schema;
const timestamps = require('mongoose-timestamps');

module.exports = (api) => {
    const schema = new Schema({
        uses: {
            type: Number,
            required: true
        },
        popularity: {
            type: Number,
            required: true
        },
        Content: {
            type: Schema.Types.ObjectId,
            ref: 'Content'
        }
    });

    schema.plugin(timestamps);
    return api.mongoose.model('Statistics', schema);
};
