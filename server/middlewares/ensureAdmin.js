module.exports = (api) => {
	const User = api.models.User;
	return (req, res, next) => {
		User.findById(req.userId, (err, data) => {
			if (err) {
				return res.status(500).send();
			}

			if (!data) {
				return res.status(404).send('user.not.found');
			}

			if (data.isAdmin == false) {
				return res.status(401).send('not.admin');

			}

			return next();
		})
	}
}
