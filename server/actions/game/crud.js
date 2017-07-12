const async = require('async');
module.exports = (api) => {
	const Game = api.models.Game;
	const User = api.models.User;
	const Score = api.models.Score;

	function findById(req, res, next) {
		Game.findById(req.params.id).populate('Scores').exec((err, data) => {
			if (err) {
				return res.status(500).send(err);
			}
			if (!data) {
				return res.status(204).send(data);
			}
			return res.send(data)
		})
	}

	function findByUser(req, res, next) {



		Game.find({
			"Scores.Player": req.params.id
		}).populate('Scores').exec((err, data) => {
			if (err) {
				return res.status(500).send();
			}
			if (!data || data.length == 0) {
				return res.status(204).send(data)
			}
			return res.send(data)
		});
	}

	function findByDifficulty(req, res, next) {
		Game.find({
			difficulty: {
				$gt: Number(req.params.difficulty) - 11,
				$lt: Number(req.params.difficulty) + 11
			}
		}, (err, data) => {
			if (err) {
				return res.status(500).send();
			}
			if (!data || data.length == 0) {
				return res.status(204).send(data)
			}

			return res.send(data)
		}).skip(Number(req.params.start)).limit(Number(req.params.limit));
	}

	function create(req, res, next) {
		let game = new Game(req.body);
		let scores = []
		if (req.body.Players.length >= 2) {
			game.isMultiplayer = true
		}
		let i = 0

		//      FACON STOCKAGE OBJETS SCORE        

		async.eachSeries(
			req.body.Players,
			function (player, next) {
				let score = new Score()
				score.User = player
				score.Game = game
				score.scoreInGame = 0
				score.save((err, data) => {
					if (err) {
						return res.status(500).send(err);
					}
					scores.push({
						Score: data.id,
						Player: player
					})
					next()
				});
			},
			function (err) {
				game.Scores = scores
				game.save((err, data) => {
					if (err) {
						return res.status(500).send(err);
					}
					req.body.Players.forEach(function (player) {
						User.findById(player, function (err, user) {
							if (err) {
								return res.status(500).send(err)
							} else {
								user.Games.push(data.id);
								user.save(function (err) {
									if (err) {
										return res.status(500).send(err)
									}
								});
							}
						});
					});
					return res.send(data)
				});
			}
		);
	};

	return {
		findById,
		findByUser,
		findByDifficulty,
		create
	};
}
