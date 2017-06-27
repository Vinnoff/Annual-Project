module.exports = (api) => {
    const Score = api.models.Score;

    function create(user, game) {
        let score = new Score
        score.User = user
        score.Game = game
        score.scoreInGame = 0
        score.save((err, data) => {
            if (err) {
                return res.status(500).send(err);
            }
            return data._id
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

    return {
        create,
        update
    };
}
