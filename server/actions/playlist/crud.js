module.exports = (api) => {
    const Playlist = api.models.Playlist;
    const Song = api.models.Song;
    const Artist = api.models.Artist;

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

          if (!data) {
            return res.status(204).send();
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

        let song = new Song(req.body.Song);
        let artist = new Artist(req.body.Artist);

        Artist.findOne({
          title: artist.title,
        }, (err, art) => {
          if (err) {
            return res.status(500).send(err)
          }

          if (!art) {
            artist.save((err, saved) => {
              if (err) {
                return res.status(500).send(err)
              }

              if (!saved) {
                return res.status(204).send();
              }

              song.Artists.push(saved);
              data.Songs.push(songd);
            })
          } else {
            song.Artists.push(art);
            data.Songs.push(song);
          }

          song.save((err,songd) => {
            if (err) {
              return res.status(500).send(err)
            }

            if (!songd) {
              return res.status(204).send();
            }
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
        })
      })
    }

    function delSong(req, res, next) {
      Playlist.findByIdAndUpdate(req.params.id, {$pull : { Songs : req.params.id2}}, (err,data) => {
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
