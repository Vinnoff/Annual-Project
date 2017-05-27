const Schema = require('mongoose').Schema;
const timestamps = require('mongoose-timestamps');

module.exports = (api) => {
    const schema = new Schema({
        title: {
            type: String,
            required: true
        },
        Statistics: {
            type: Schema.Types.ObjectId,
            ref: 'Statistics'
        },
        relatedRewards: [{
            type: Schema.Types.ObjectId,
            ref: 'Reward'
        }]
    });

    schema.plugin(timestamps);
    return api.mongoose.model('Content', schema);
};
