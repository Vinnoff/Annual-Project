module.exports = (api) => {
    const Game = api.models.Game;
    const User = api.models.User;
    const Score = api.models.Score;

    function findById(req, res, next) {
        Game.findById(req.params.id, (err, data) => {
            if (err) {
                return res.status(500).send(err);
            }
            if (!data) {
                return res.status(204).send(data);
            }
            return res.send(data);
        });
    }

    function findByUser(req, res, next) {
        Game.find({
            Players: req.params.id
        }, (err, data) => {
            if (err) {
                return res.status(500).send();
            }
            if (!data || data.length == 0) {
                return res.status(204).send(data)
            }
            return res.send(data);
        });
    }

    function findByDifficulty(req, res, next) {
        Game.find({
            dificulty: req.params.difficulty,
            isPublic: true
        }, (err, data) => {
            if (err) {
                return res.status(500).send();
            }
            if (!data || data.length == 0) {
                return res.status(204).send(data)
            }
            return res.send(data);
        }).skip(Number(req.params.start)).limit(Number(req.params.limit));
    }

    function create(req, res, next) {
        let game = new Game(req.body);
        let scores = []
        if (req.body.Players.length >= 2) {
            game.isMultiplayer = true
        }
        req.body.Players.forEach((player) => {
            let id = api.actions.score.create(player, game)
            console.log(id)
        });
        game.Scores = scores
        game.save((err, data) => {
            if (err) {
                return res.status(500).send(err);
            }
            return res.send(data);
        });
    }
    return {
        findById,
        findByUser,
        findByDifficulty,
        create
    };
}
