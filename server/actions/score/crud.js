module.exports = (api) => {
	const Score = api.models.Score;
	const User = api.models.User;

	function findById(req, res, next) {
		Score.findById(req.params.id, (err, data) => {
			if (err) {
				return res.status(500).send(err);
			}
			if (!data) {
				return res.status(204).send(data);
			}
			return res.send(data);
		});
	}

	function update(req, res, next) {
		Score.findByIdAndUpdate(req.params.id, {
			$inc: {
				scoreInGame: req.body.scoreInGame
			}
		}, {
			new: true
		}, (err, data) => {
			if (err) {
				return res.status(500).send(err);
			}

			if (!data) {
				return res.status(204).send();
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
				return res.status(204).send();
			}

			user.globalScore += scoreData.scoreInGame;
			user.gold += Math.trunc(scoreData.scoreInGame / 100);

			user.save((err, data) => {
				if (err) {
					return res.status(500).send(err);
				}
				return res.send(scoreData);
			})
		})
	}

	return {
		findById,
		update
	};
}
