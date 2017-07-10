module.exports = (api) => {
    const Kind = api.models.Kind;

    function findAll(req, res, next) {
      Kind.find((err,data) => {
        if (err) {
          return res.status(500).send(err);
        }

        if (!data || data.lenght == 0) {
          return res.status(204).send(data);
        }

        api.middlewares.cache.set('Kind', data, req.originalUrl);
        return res.send(data);
      })
    }

    function findOne(req, res, next) {
      Kind.findById(req.params.id, (err,data) => {
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
      let kind = new Kind(req.body);

      kind.save((err, data) => {
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
      Kind.findByIdAndUpdate(req.params.id, req.body, (err,data) => {
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
      Kind.findById(req.params.id, (err, data) => {
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

    function getAllAlbums(req, res, next) {
      Kind.findById(req.params.id).populate('Albums').exec((err, data) => {
          if (err) {
            return res.status(500).send(err)
          }

          if (!data) {
            return res.status(204).send();
          }

          return res.send(data);
      })
    }

    function putAlbum(req, res, next) {
      Kind.findByIdAndUpdate(req.params.id, {$push : { Artists : req.body.album}}, (err,data) => {
        if (err) {
          return res.status(500).send(err)
        }

        if (!data) {
          return res.status(204).send();
        }

        return res.send(data);
      })
    }

    function delAlbum(req, res, next) {
      Kind.findByIdAndUpdate(req.params.id, {$pull : { Albums : req.body.album}}, (err,data) => {
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
        getAllAlbums,
        putAlbum,
        delAlbum,
        remove
    };
}
