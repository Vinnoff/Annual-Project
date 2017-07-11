const Schema = require('mongoose').Schema;
const timestamps = require('mongoose-timestamps');

module.exports = (api) => {
    const schema = new Schema({
        title: {
            type: String,
            required: true
        },
        url: {
            type: String,
            required: true
        },
        uri: {
            type: String,
            required: true
        },
        duration: {
            type: Number
        },
        Artists: [{
            type: Schema.Types.ObjectId,
            ref: 'Artist'
        }]
    });

    schema.plugin(timestamps);
    return api.mongoose.model('Song', schema);
};
