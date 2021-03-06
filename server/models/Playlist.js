const Schema = require('mongoose').Schema;
const timestamps = require('mongoose-timestamps');

module.exports = (api) => {
    const schema = new Schema({
        title: {
            type: String,
            required: true
        },
        isPublic: {
            type: Boolean,
            /*par defaut:false,*/
            required: true
        },
        image: {
            type: String
        },
        Songs: [{
            type: Schema.Types.ObjectId,
            ref: 'Song'
        }],
        Creator: {
            type: Schema.Types.ObjectId,
            ref: 'User'
        }
    });

    schema.plugin(timestamps);
    return api.mongoose.model('Playlist', schema);
};
