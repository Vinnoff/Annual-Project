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

        api.middlewares.cache.set('Produit', data, req.originalUrl);
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
        title: req.params.cat,
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

      Song.findOne(req.userId, (err, user) => {
        if (err) {
          return res.status(500).send();
        }

        user.isVendor = true;
        user.save((err, user) => {
          produit.vendeur = userId;
          produit.datemisenvente = Date.now();

          produit.save((err, data) => {
              if (err) {
                  return res.status(500).send(err);
              }

              return res.send(data);
          });
        })
      });
    }

    function update(req, res, next) {

    }

    function remove(req, res, next) {

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
