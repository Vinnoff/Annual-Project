module.exports = (api) => {
    const Song = api.models.Song;

    function findAll(req, res, next) {
      Song.find((err,data) => {
        if (err) {
          return res.status(500).send(err);
        }

        if (!data || data.lenght == 0) {
          return res.status(204).send(data);
        }

        api.middlewares.cache.set('Song', data, req.originalUrl);
        return res.send(data);
      })

    }

    function findOne(req, res, next) {
      Song.findById(req.params.id, (err, data) => {
          if (err) {
              return res.status(500).send(err);
          }
          if (!data) {
              return res.status(204).send(data);
          }
          return res.send(data);
      });
    }

    function findByTitle(req, res, next) {
      Produit.find({
        title: req.params.title,
      }, (err, data) => {
        if (err) {
          return res.status(500).send();
        }

        if (!data) {
          return res.status(204).send();
        }

        return res.send(data)
      })
    }

    function create(req, res, next) {
      let Song = new Song(req.body);

      song.save((err,data) => {
        if (err) {
          return res.status(500).send();
        }

        if (!data) {
          return res.status(204).send();
        }
      })
    }

    function update(req, res, next) {
      Song.findByIdAndUpdate(req.params.id, (err, data) => {
        if (err) {
          return res.status(500).send(err);
        }

        if (!data) {
          return res.status(204).send();
        }

        return res.send(data);
        })
    }

    function remove(req, res, next) {
      Song.findById(req.params.id, (err, data) => {
            if (err) {
                return res.status(500).send(err);
            }

            if (!data) {
                return res.status(204).send();
            }

            data.remove((err, data) => {
              if (err) {
                return res.status(500).send();
              }

              return res.send(data);
            });

        });
    }

    function getAllArtists(req, res, next) {
      Song.findById(req.params.id).populate('Artists').exec((err, data) => {
          if (err) {
            return res.status(500).send(err)
          }

          if (!data) {
            return res.status(204).send();
          }

          return res.send(data);
      })
    }

    function putArtist(req, res, next) {
      Song.findByIdAndUpdate(req.params.id, {$push : { Artists : req.body.artist}}, (err,data) => {
        if (err) {
          return res.status(500).send(err)
        }

        if (!data) {
          return res.status(204).send();
        }

        return res.send(data);
      })
    }

    function delArtist(req, res, next) {
      Song.findByIdAndUpdate(req.params.id, {$pull : { Artists : req.body.artist}}, (err,data) => {
        if (err) {
          return res.status(500).send(err)
        }

        if (!data) {
          return res.status(204).send();
        }

        return res.send(data);
      })
    }

    return {
        findAll,
        findOne,
        findByTitle,
        create,
        update,
        getAllArtists,
        putArtist,
        delArtist,
        remove
    };
}
