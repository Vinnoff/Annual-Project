module.exports = (api) => {
	const Score = api.models.Score;

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
			return res.send(data);
		})
	}

	return {
		findById,
		update
	};
}
