const Schema = require('mongoose').Schema;
const timestamps = require('mongoose-timestamps');

module.exports = (api) => {
  const schema = new Schema({
      title: {
          type: String,
          required: true
      },
      Genres: [{
        type: Schema.Types.ObjectId,
        ref: 'Kind'
      }],
      image: {
        type: String
      }
    });

  schema.plugin(timestamps);
  return api.mongoose.model('Artist', schema);
};
