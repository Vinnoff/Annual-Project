module.exports = (api) => {
    const Artist = api.models.Artist;

    function findAll(req, res, next) {
      Artist.find((err,data) => {
        if (err) {
          return res.status(500).send(err);
        }

        if (!data || data.lenght == 0) {
          return res.status(204).send(data);
        }

        api.middlewares.cache.set('Artist', data, req.originalUrl);
        return res.send(data);
      })
    }

    function findOne(req, res, next) {
      Artist.findById(req.params.id, (err,data) => {
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
      Artist.find({
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
      let artist = new Artist(req.body);

      artist.save((err, data) => {
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
      Artist.findByIdAndUpdate(req.params.id, req.body, (err,data) => {
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
      Artist.findById(req.params.id, (err, data) => {
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

    return {
        findAll,
        findOne,
        findByTitle,
        create,
        update,
        remove
    };
}
