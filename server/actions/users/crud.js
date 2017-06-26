const sha1 = require('sha1');

module.exports = (api) => {
    const User = api.models.User;
    const Rank = api.models.Rank;
    const Score = api.models.Score;
    const Playlist = api.models.Playlist;

    function findAll(req, res, next) {
        setTimeout(function () {
            User.find((err, data) => {
                if (err) {
                    return res.status(500).send(err);
                }
                if (!data || data.length == 0) {
                    return res.status(204).send(data)
                }
                api.middlewares.cache.set('User', data, req.url);
                return res.send(data);
            });
        }, 2000);
    }

    function findById(req, res, next) {
        User.findById(req.params.id, (err, data) => {
            if (err) {
                return res.status(500).send(err);
            }
            if (!data) {
                return res.status(204).send(data);
            }
            return res.send(data);
        });
    }

    function findByUserName(req, res, next) {
        User.findOne({
            userName: req.params.userName,
        }, (err, data) => {
            if (err) {
                return res.sendStatus(500).send();
            }
            if (!data || data.length == 0) {
                return res.sendStatus(204).send(data)
            }
            return res.send(data);
        });
    }

    function create(req, res, next) {
        let user = new User(req.body);
        user.password = sha1(user.password);
        User.findOne({
            userName: user.userName
        }, (err, found) => {
            if (err) {
                return res.status(500).send(err)
            }
            if (found) {
                return res.status(401).send('username.already.taken')
            }
            User.findOne({
                mail: user.mail
            }, (err, found) => {
                if (err) {
                    return res.status(500).send(err)
                }
                if (found) {
                    return res.status(401).send('mail.already.taken')
                }
                user.Rank = "594fb1c9ab2572510210f8dd"
                user.birthdate = new Date(user.birthDate);
                user.save((err, data) => {
                    if (err) {
                        return res.status(500).send(err);
                    }
                    return res.send(data);
                })
            });
        });
    }

    function update(req, res, next) {
        if (req.userId != req.params.id) {
            console.log(req.userId + " " + req.params.id)
            return res.status(401).send('cant.modify.another.user.account');
        }
        if (req.body.password) {
            req.body.password = sha1(req.body.password);
        }
        User.findByIdAndUpdate(req.params.id, req.body, (err, data) => {
            if (err) {
                return res.status(500).send(err);
            }

            if (!data) {
                return res.status(204).send();
            }
            return res.send(data);
        });
    }

    function remove(req, res, next) {
        if (req.userId != req.params.id) {
            return res.status(401).send('cant.delete.another.user.account');
        }

        User.findById(req.params.id, (err, data) => {
            if (err) {
                return res.status(500).send(err);
            }
            if (!data) {
                return res.status(204).send(data);
            }
        })

        User.findByIdAndRemove(req.params.id, (err, data) => {
            if (err) {
                return res.status(500).send();
            }
            if (!data) {
                return res.status(204).send();
            }

            return res.send(data);
        });
    }

    return {
        findAll,
        findById,
        findByUserName,
        create,
        update,
        remove
    };
}
