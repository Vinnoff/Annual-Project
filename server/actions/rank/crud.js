module.exports = (api) => {
    const Rank = api.models.Rank;
    const User = api.models.User;

    function findAll(req, res, next) {
        setTimeout(function () {
            Rank.find((err, data) => {
                if (err) {
                    return res.status(500).send(err);
                }
                if (!data || data.length == 0) {
                    return res.status(204).send(data)
                }
                return res.send(data);
            }).sort({
                nb: 1
            });
        }, 2000);
    }

    function findOne(req, res, next) {
        Rank.findById(req.params.id, (err, data) => {
            if (err) {
                return res.status(500).send(err);
            }
            if (!data) {
                return res.status(204).send(data);
            }
            return res.send(data);
        });
    }

    function create(req, res, next) {
        let rank = new Rank(req.body);
        Rank.findOne({
            nb: rank.nb
        }, (err, found) => {
            if (err) {
                return res.status(500).send(err)
            }
            if (found) {
                return res.status(401).send('rank.already.created')
            }
            Rank.findOne({
                title: rank.title
            }, (err, found) => {
                if (err) {
                    return res.status(500).send(err)
                }
                if (found) {
                    return res.status(401).send('rank.already.created')
                }
                rank.save((err, data) => {
                    if (err) {
                        return res.status(500).send(err);
                    }
                    return res.send(data);
                })
            });
        });
    }

    function update(req, res, next) {
        Rank.findByIdAndUpdate(req.params.id, req.body, (err, data) => {
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
        Rank.findByIdAndRemove(req.params.id, (err, data) => {
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
        findOne,
        create,
        update,
        remove
    };
}
