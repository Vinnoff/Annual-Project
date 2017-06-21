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
        },
        Users: [{
            type: Schema.Types.ObjectId,
            ref: 'User'
        }]
    });

    schema.plugin(timestamps);
    return api.mongoose.model('Rank', schema);
};
