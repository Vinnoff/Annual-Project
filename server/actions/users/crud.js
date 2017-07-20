const sha1 = require('sha1');

module.exports = (api) => {
	const User = api.models.User;
	const Rank = api.models.Rank;
	const Score = api.models.Score;
	const Playlist = api.models.Playlist;
	const Preferences = api.models.Preferences;

	function findAll(req, res, next) {
		User.find((err, data) => {
			if (err) {
				return res.status(500).send(err);
			}
			if (!data || data.length == 0) {
				return res.status(204).send("no.users")
			}
			api.middlewares.cache.set('User', data, req.originalUrl);
			return res.send(data);
		});
	}

	function findSorted(req, res, next) {
		User.find((err, data) => {
			if (err) {
				return res.status(500).send();
			}
			if (!data || data.length == 0) {
				return res.status(204).send("no.users")
			}
			return res.send(data)
		}).sort({
			globalScore: -1
		}).skip(Number(req.params.start)).limit(Number(req.params.limit));
	}

	function findById(req, res, next) {
		User.findById(req.params.id)
			.populate('Rank', 'nb title')
			.populate('Preferences',
				'Genres Artists Albums Songs')
			.exec((err, data) => {
				if (err) {
					return res.status(500).send(err);
				}
				if (!data) {
					return res.status(404).send("user.not.found");
				}
				return res.send(data);
			});
	}

	function findByUserName(req, res, next) {
		User
			.findOne({
				userName: req.params.userName
			})
			.populate('Rank', 'nb title')
			.populate('Preferences',
				'Genres Artists Albums Songs')
			.exec((err, data) => {
				if (err) {
					return res.status(500).send();
				}
				if (!data || data.length == 0) {
					return res.status(404).send("user.not.found");
				}
				return res.send(data);
			})
	}

	function findByAproximateUserName(req, res, next) {
		User
			.find({
				userName: {
					$regex: ".*" + req.params.userName + ".*"
				}
			})
			.sort({
				userName: 1
			})
			.exec((err, data) => {
				if (err) {
					return res.status(500).send();
				}
				if (!data || data.length == 0) {
					return res.status(204).send("no.users");
				}
				return res.send(data);
			})
	}

	function create(req, res, next) {
		let user = new User(req.body);
		User.findOne({
			userName: user.userName
		}, (err, found) => {
			if (err) {
				return res.status(500).send(err)
			}
			if (found) {
				return res.status(401).send('username.already.taken')
			}
			new Preferences().save((err, prefData) => {
				if (err) {
					return res.status(500).send(err);
				}
				user.Preferences = prefData.id;
				user.Rank = "594fb1c9ab2572510210f8dd"

				if (user.isAdmin == true) {
					if (!req.body.password) {
						return res.status(401).send('no.password')
					} else {
						user.password = sha1(user.password);
					}
				}

				user.save((err, userData) => {
					if (err) {
						return res.status(500).send(err);
					}
					return res.send(userData);
				})
			})
		});
	}

	function update(req, res, next) {
		if (req.userId != req.params.id) {
			return res.status(401).send('cant.modify.another.user.account');
		}
		if (req.body.password) {
			req.body.password = sha1(req.body.password)
		}
		User.findByIdAndUpdate(req.params.id, req.body, {
			new: true
		}, (err, data) => {
			if (err) {
				return res.status(500).send(err);
			}

			if (!data) {
				return res.status(404).send("user.not.found");
			}
			return res.send(data);
		});
	}

	function addFriends(req, res, next) {
		if (req.params.firstId === req.params.secondId) {
			return res.status(401).send("same.ids")
		}

		User.findById(req.params.firstId, (err, data) => {
			if (err) {
				return res.status(500).send(err)
			}
			if (!data) {
				return res.status(404).send("user.not.found");
			}
			let alreadyFriends = false
			data.Friends.some(function (friend) {
				if (JSON.stringify(req.params.secondId) === JSON.stringify(friend)) {
					alreadyFriends = true
					return true
				}

			})
			if (alreadyFriends) {
				return res.status(401).send('users.already.friends')

			} else {
				User.findByIdAndUpdate(req.params.secondId, {
					$push: {
						Friends: req.params.firstId
					}
				}, {
					new: true
				}, (err, data) => {
					if (err) {
						return res.status(500).send(err);
					}
					User.findByIdAndUpdate(req.params.firstId, {
						$push: {
							Friends: req.params.secondId
						}
					}, {
						new: true
					}, (err, data) => {
						if (err) {
							return res.status(500).send(err);
						}
						return res.send(data);
					})
				});
			}
		})
	}

	function delFriends(req, res, next) {
		if (req.params.firstId === req.params.secondId) {
			return res.status(401).send("same.ids")
		}

		User.findById(req.params.firstId, (err, data) => {
			if (err) {
				return res.status(500).send(err)
			}
			if (!data) {
				return res.status(404).send("user.not.found");
			}
			let areFriends = false
			data.Friends.some(function (friend) {
				if (JSON.stringify(req.params.secondId) === JSON.stringify(friend)) {
					areFriends = true
					return true
				}
			})
			if (!areFriends) {
				return res.status(401).send('users.not.friends')
			} else {
				User.findByIdAndUpdate(req.params.secondId, {
					$pull: {
						Friends: req.params.firstId
					}
				}, {
					new: true
				}, (err, data) => {
					if (err) {
						return res.status(500).send(err);
					}
					User.findByIdAndUpdate(req.params.firstId, {
						$pull: {
							Friends: req.params.secondId
						}
					}, {
						new: true
					}, (err, data) => {
						if (err) {
							return res.status(500).send(err);
						}
						return res.send(data);
					})
				});
			}
		})
	}

	function remove(req, res, next) {
		if (req.userId != req.params.id) {
			return res.status(401).send('cant.delete.another.user.account');
		}
		User.update({
			Friends: {
				$in: [req.params.id]
			}
		}, {
			$pull: {
				Friends: req.params.id
			}
		}, (err, data) => {
			if (err) {
				return res.status(500).send(err);
			}
			User.findByIdAndRemove(req.params.id, (err, data) => {
				if (err) {
					return res.status(500).send(err);
				}
				if (!data) {
					return res.status(404).send('user.not.found');
				}
				Preferences.findByIdAndRemove(data.Preferences, (err, prefData) => {
					if (err) {
						return res.status(500).send();
					}
				})
				return res.send(data);
			});
		});
	}

	return {
		findAll,
		findSorted,
		findById,
		findByUserName,
		findByAproximateUserName,
		create,
		update,
		addFriends,
		delFriends,
		remove
	};
}
