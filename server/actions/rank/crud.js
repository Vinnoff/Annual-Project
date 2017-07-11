module.exports = (api) => {
	const Rank = api.models.Rank;
	const User = api.models.User;

	function findAll(req, res, next) {
		Rank.find((err, data) => {
			if (err) {
				return res.status(500).send(err);
			}
			if (!data || data.length == 0) {
				return res.status(204).send(data)
			}
			return res.send(data);
		}).sort({
			nb: 1
		});
	}

	function findById(req, res, next) {
		Rank.findById(req.params.id, (err, data) => {
			if (err) {
				return res.status(500).send(err);
			}
			if (!data) {
				return res.status(204).send(data);
			}
			return res.send(data);
		});
	}

	function findByNumber(number, next) {
		Rank.find({
			nb: number
		}, (err, data) => {
			if (err) {
				return res.status(500).send(err);
			}
			if (!data) {
				return res.status(204).send(data);
			}
			return data;
			next();
		});
	}

	function create(req, res, next) {
		let newRank = new Rank(req.body);

		Rank.find().sort('-nb').exec((err, ranks) => {
			if (err) {
				return res.status(500).send();
			}
			if (!ranks) {
				newRank.nb = 1;
				newRank.save((err, data) => {
					if (err) {
						return res.status(500).send(err);
					}
					return res.send(data);
				})
			} else {
				let isCreated = false
				ranks.forEach((rank) => {
					if (req.body.title == rank.title) {
						isCreated = true
					}
				})
				if (isCreated) {
					return res.status(401).send('rank.already.created')
				} else {
					newRank.nb = ranks[0].nb + 1;
					newRank.save((err, data) => {
						if (err) {
							return res.status(500).send(err);
						}
						return res.send(data);
					})
				}
			}
		});
	}

	function update(req, res, next) {
		Rank.findOne({
			title: req.body.title
		}, (err, data) => {
			if (err) {
				return res.status(500).send(err);
			}
			if (data) {
				if (data.id == req.params.id) {
					return res.status(401).send('same.title')
				}
				return res.status(401).send('rank.already.created')

			} else {
				Rank.findById(req.params.id, (err, data) => {
					if (err) {
						return res.status(500).send(err)
					}
					data.title = req.body.title;
					data.save(function (err, data) {
						if (err) {
							return res.status(500).send(err)
						}
						return res.send(data)
					})
				});
			}
		});
	}

	function remove(req, res, next) {
		Rank.find().sort('-nb').exec((err, rank) => {
			if (err) {
				return res.status(500).send();
			}
			if (!rank) {
				return res.status(204).send();
			}
			if (rank[0].id != req.params.id) {
				return res.status(401).send('not.highest.rank');
			} else {
				User.find({
					Rank: rank[0].id
				}, (err, data) => {
					data.forEach(function (user) {
						user.Rank = rank[1].id;
						user.save(function (err) {
							if (err) {
								return res.status(500).send(err)
							}
						});
					});
				});
			}
			Rank.findByIdAndRemove(req.params.id, (err, data) => {
				if (err) {
					return res.status(500).send();
				}
				if (!data) {
					return res.status(204).send();
				}
				return res.send(data);
			});
		});
	}

	return {
		findAll,
		findById,
		create,
		update,
		remove
	};
}
