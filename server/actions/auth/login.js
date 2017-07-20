const sha1 = require('sha1');
const jwt = require('jsonwebtoken');

module.exports = (api) => {
	const User = api.models.User;
	const Token = api.models.Token;

	function iOs(req, res, next) {
		if (!req.params.id) {
			return res.status(401).send('id.required');
		}
		User.findById(req.params.id, (err, user) => {
			if (err) {
				return res.status(500).send(err);
			}

			if (!user) {
				return res.status(401).send('invalid.id');
			}

			createToken(user, res, next);
		});
	}

	function adminSys(req, res, next) {
		if (!req.body.userName || !req.body.password) {
			return res.status(401).send('no.credentials');
		}
		User.findOne({
			userName: req.body.userName,
			password: sha1(req.body.password),
			isAdmin: true
		}, (err, user) => {
			if (err) {
				return res.status(500).send(err);
			}

			if (!user) {
				return res.status(401).send('invalid.credentials');
			}

			createToken(user, res, next);
		});
	}

	function createToken(user, res, next) {
		var token = new Token();
		token.userId = user.id.toString();
		token.save((err, token) => {
			if (err) {
				return res.status(500).send(err);
			}

			jwt.sign({
					exp: Math.floor(Date.now() / 1000) + (60 * 60),
					tokenId: token.id.toString()
				},
				api.settings.security.salt, {}, (err, encryptedToken) => {
					if (err) {
						return res.status(500).send(err);
					}
					return res.send(encryptedToken);
				}
			);
		});
	}

	return {
		iOs,
		adminSys
	};
};
