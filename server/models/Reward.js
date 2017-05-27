const Schema = require('mongoose').Schema;
const timestamps = require('mongoose-timestamps');

module.exports = (api) => {
    const schema = new Schema({
        title: {
            type: String,
            required: true,
            unique: true
        },
        type: {
            type: String,
            required: true
        },
        scoreToAccess: {
            type: Number,
            required: true
        },
        isRelatedTo: [{
            type: Schema.Types.ObjectId,
            ref: 'Content',
            required: true
        }],
        Owners: [{
            type: Schema.Types.ObjectId,
            ref: 'User'
        }]
    });

    schema.plugin(timestamps);
    return api.mongoose.model('Reward', schema);
};
