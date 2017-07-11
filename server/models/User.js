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
		isAdmin: {
			type: Boolean,
			default: false
		},
		mail: {
			type: String,
			unique: true,
			sparse: true
		},
		Rank: {
			type: Schema.Types.ObjectId,
			ref: 'Rank'
		},
		globalScore: {
			type: Number,
			default: 0
		},
		gold: {
			type: Number,
			default: 0
		},
		Games: [{
			type: Schema.Types.ObjectId,
			ref: 'Game'
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
        }],
		Preferences: {
			type: Schema.Types.ObjectId,
			ref: 'Preferences'
		}
	});

	schema.plugin(timestamps);
	return api.mongoose.model('User', schema);
};
