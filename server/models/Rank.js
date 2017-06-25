const Schema = require('mongoose').Schema;
const timestamps = require('mongoose-timestamps');

module.exports = (api) => {
    const schema = new Schema({
        nb: {
            type: Number,
            required: true,
            unique: true
        },
        title: {
            type: String,
            required: true,
            unique: true
        }
    });

    schema.plugin(timestamps);
    return api.mongoose.model('Rank', schema);
};
