module.exports = (api) => {
    const Album = api.models.Album;

    function findAll(req, res, next) {
      Album.find((err,data) => {
        if (err) {
          return res.status(500).send(err);
        }

        if (!data || data.lenght == 0) {
          return res.status(204).send(data);
        }

        api.middlewares.cache.set('Album', data, req.originalUrl);
        return res.send(data);
      })
    }

    function findOne(req, res, next) {
      Album.findById(req.params.id, (err,data) => {
        if (err) {
          return res.status(500).send(err);
        }

        if (!data) {
          return res.status(204).send(data);
        }

        return res.send(data);
      })
    }

    function findByTitle(req, res, next) {
      Album.find({
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
      let album = new Album(req.body);

      album.save((err, data) => {
        if (err) {
          return res.status(500).send();
        }

        if (!data) {
          return res.status(204).send();
        }

        return res.send(data);
      });
    }

    function update(req, res, next) {
      Album.findByIdAndUpdate(req.params.id, req.body, (err,data) => {
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
      Album.findById(req.params.id, (err, data) => {
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

    function addSong(req, res, next) {
      Album.findById()
    }

    return {
        findAll,
        findOne,
        findByTitle,
        create,
        update,
        remove
    };
}
