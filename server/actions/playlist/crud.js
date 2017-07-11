module.exports = (api) => {
    const Playlist = api.models.Playlist;

    function findAll(req, res, next) {
      Playlist.find((err,data) => {
        if (err) {
          return res.status(500).send(err);
        }

        if (!data || data.lenght == 0) {
          return res.status(204).send(data);
        }

        api.middlewares.cache.set('Playlist', data, req.originalUrl);
        return res.send(data);
      })
    }

    function findAllFromUser(req, res, next) {
      Playlist.find({
        Creator: req.params.id,
      }, (err,data) => {
        if (err) {
          return res.status(500).send(err);
        }

        if (!data || data.lenght == 0) {
          return res.status(204).send(data);
        }

        return res.send(data);
      })
    }

    function findOne(req, res, next) {
      Playlist.findById(req.params.id, (err, data) => {
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
      Playlist.find({
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
      let playlist = new Playlist(req.body);

      playlist.save((err, data) => {
          if (err) {
              return res.status(500).send(err);
          }

          return res.send(data);
      });
    }

    function update(req, res, next) {
      Playlist.findByIdAndUpdate(req.params.id, req.body, (err, data) => {
            if (err) {
                return res.status(500).send(err);
            }

            if (!data) {
                return res.status(204).send()
            }

            return res.send(data);
        });
    }

    function remove(req, res, next) {
      Playlist.findById(req.params.id, (err, data) => {
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

    function getAllSongs(req, res, next) {
      Playlist.findById(req.params.id).populate('Songs').exec((err, data) => {
          if (err) {
            return res.status(500).send(err)
          }

          if (!data) {
            return res.status(204).send();
          }

          return res.send(data);
      })
    }

    function putSong(req, res, next) {
      Playlist.findById(req.params.id, (err,data) => {
        if (err) {
          return res.status(500).send(err)
        }

        if (!data) {
          return res.status(204).send();
        }

        let song = new Song(req.body);

        data.Songs.push(song);

        data.save((err,data) => {
          if (err) {
            return res.status(500).send(err)
          }

          if (!data) {
            return res.status(204).send();
          }

          return res.send(data);
        })

      })
    }

    function delSong(req, res, next) {
      Playlist.findByIdAndUpdate(req.params.id, {$pull : { Songs : req.body.song}}, (err,data) => {
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
        findAllFromUser,
        findByTitle,
        create,
        update,
        getAllSongs,
        putSong,
        delSong,
        remove
    };
}
