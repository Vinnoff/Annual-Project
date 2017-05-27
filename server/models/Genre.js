const Schema = require('mongoose').Schema;
const timestamps = require('mongoose-timestamps');

module.exports = (api) => {
    const schema = new Schema({
        Albums: [{
            type: Schema.Types.ObjectId,
            ref: 'Album'
        }],
        image: {
            type: String
        }
    });

    schema.plugin(timestamps);
    return api.mongoose.model('Genre', schema);
};
