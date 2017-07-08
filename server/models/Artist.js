const Schema = require('mongoose').Schema;
const timestamps = require('mongoose-timestamps');

module.exports = (api) => {
<<<<<<< HEAD
  const schema = new Schema({
    title: {
      type: String,
      required: true
    },
=======
    const schema = new Schema({
        title: {
            type: String,
            required: true
        },
        Albums: [{
            type: Schema.Types.ObjectId,
            ref: 'Album'
        }],
        image: {
            type: String
        }
    });
>>>>>>> Dev_music_content

    Albums: [{
      type: Schema.Types.ObjectId,
      ref: 'Album'
    }],
    image: {
      type: String
    }
  });

  schema.plugin(timestamps);
  return api.mongoose.model('Artist', schema);
};
