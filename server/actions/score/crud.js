module.exports = (api) => {
	const Rank = api.models.Rank;
	const Score = api.models.Score;
	const User = api.models.User;

	function findAll(req, res, next) {
		Score.find((err, data) => {
			if (err) {
				return res.status(500).send(err);
			}
			if (!data || data.length == 0) {
				return res.status(404).send("score.not.found")
			}
			return res.send(data);
		})
	}

	function findById(req, res, next) {
		Score.findById(req.params.id, (err, data) => {
			if (err) {
				return res.status(500).send(err);
			}
			if (!data) {
				return res.status(404).send("score.not.found")
			}
			return res.send(data);
		});
	}

	function update(req, res, next) {
		Score.findByIdAndUpdate(req.params.id, {
			$inc: {
				scoreInGame: req.body.scoreInGame
			},
			isFinished: req.body.isFinished
		}, {
			new: true
		}, (err, data) => {
			if (err) {
				return res.status(500).send(err);
			}

			if (!data) {
				return res.status(404).send("score.not.found")
			}
			if (req.body.isFinished == true) {
				updateScoreAndGold(data, res, next);
			} else {
				return res.send(data);
			}
		})
	}

	function updateScoreAndGold(scoreData, res, next) {
		User.findById(scoreData.User, (err, user) => {
			if (err) {
				return res.status(500).send(err);
			}
			if (!user) {
				return res.status(404).send("user.not.found");
			}

			user.globalScore += scoreData.scoreInGame;
			user.gold += Math.round(scoreData.scoreInGame / 100);
			Rank.find({
				scoreToAccess: {
					$lte: user.globalScore
				}
			}).sort({
				scoreToAccess: -1
			}).exec((err, data) => {
				console.log(data)
				user.Rank = data[0].id
				user.save((err, data) => {
					if (err) {
						return res.status(500).send(err);
					}
					return res.send(scoreData);
				})
			});
		})
	}

	return {
		findAll,
		findById,
		update
	};
}
