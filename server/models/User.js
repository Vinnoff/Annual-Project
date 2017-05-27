const Schema = require('mongoose').Schema;
const timestamps = require('mongoose-timestamps');

module.exports = (api) => {
    const schema = new Schema({
        userName: {
            type: String,
            required: true,
            unique: true
        },
        firstName: {
            type: String
        },
        lastName: {
            type: String
        },
        password: {
            type: String,
            required: true
        },
        mail: {
            type: String,
            required: true,
            unique: true
        },
        Rank: {
            type: Schema.Types.ObjectId,
            ref: 'Rank'
        },
        Scores: [{
            type: Schema.Types.ObjectId,
            ref: 'Score'
        }],
        avatar: {
            type: String
        },
        location: {
            type: String
        },
        birthDate: {
            type: Date
        },
        Rewards: [{
            type: Schema.Types.ObjectId,
            ref: 'Reward'
        }],
        Friends: [{
            type: Schema.Types.ObjectId,
            ref: 'User'
        }],
        Playlists: [{
            type: Schema.Types.ObjectId,
            ref: 'Playlist'
        }]
    });

    schema.plugin(timestamps);
    return api.mongoose.model('User', schema);
};
