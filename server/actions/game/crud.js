const async = require('async');
module.exports = (api) => {
	const Game = api.models.Game;
	const User = api.models.User;
	const Score = api.models.Score;

	function findAll(req, res, next) {
		Game.find((err, data) => {
			if (err) {
				return res.status(500).send();
			}
			if (!data || data.length == 0) {
				return res.status(204).send("no.games")
			}
			return res.send(data)
		})
	}

	function findInRange(req, res, next) {
		Game.find((err, data) => {
			if (err) {
				return res.status(500).send();
			}
			if (!data || data.length == 0) {
				return res.status(204).send("no.games")
			}
			return res.send(data)
		}).skip(Number(req.params.start)).limit(Number(req.params.limit));
	}

	function findById(req, res, next) {
		Game.findById(req.params.id).populate('Scores Songs').exec((err, data) => {
			if (err) {
				return res.status(500).send(err);
			}
			if (!data) {
				return res.status(404).send("game.not.found")
			}
			return res.send(data)
		})
	}

	function findByUser(req, res, next) {
		Game.find({
			"Scores.Player": req.params.id
		}).populate('Scores Songs').exec((err, data) => {
			if (err) {
				return res.status(500).send();
			}
			if (!data || data.length == 0) {
				return res.status(204).send("no.games")
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
				return res.status(204).send("no.games")
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
				Game.populate(game, {
					path: "Songs"
				}, function (err, data) {
					game.save((err, data) => {
						if (err) {
							return res.status(500).send(err);
						}
						let problem = false
						req.body.Players.some(function (player) {
							if (problem == true) {
								return true
							}
							User.findById(player, function (err, user) {
								if (err) {
									problem = true
									return res.status(500).send(err)
								}
								if (!user) {
									problem = true
									return res.status(404).send("user.not.found")
								} else {
									user.Games.push(data.id);
									user.save(function (err) {
										if (err) {
											problem = true
											return res.status(500).send(err)
										}
										if (problem == false) {
											return res.send(data)
										}
									});
								}
							});
						});
					});
				});
			}
		);
	};

	return {
		findAll,
		findInRange,
		findById,
		findByUser,
		findByDifficulty,
		create
	};
}
