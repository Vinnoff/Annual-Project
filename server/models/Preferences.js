const Schema = require('mongoose').Schema;
const timestamps = require('mongoose-timestamps');

module.exports = (api) => {
	const schema = new Schema({
		Songs: [{
			type: Schema.Types.ObjectId,
			ref: 'Song'
        }],
		Albums: [{
			type: Schema.Types.ObjectId,
			ref: 'Album'
        }],
		Artists: [{
			type: Schema.Types.ObjectId,
			ref: 'Artist'
        }],
		Genres: [{
			type: Schema.Types.ObjectId,
			ref: 'Genre'
        }]
	});

	schema.plugin(timestamps);
	return api.mongoose.model('Preferences', schema);
};
