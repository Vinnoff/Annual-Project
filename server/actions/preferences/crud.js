module.exports = (api) => {
	const Preferences = api.models.Preferences;

	function findById(req, res, next) {
		Preferences.findById(req.params.id, (err, data) => {
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
		Preferences.findByIdAndUpdate(req.params.id, {
			$push: req.body
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
