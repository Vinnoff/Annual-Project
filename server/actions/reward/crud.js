module.exports = (api) => {
	const Reward = api.models.Reward;
	const User = api.models.User;

	function findSortedByScore(req, res, next) {
		Reward.find((err, data) => {
			if (err) {
				return res.status(500).send(err);
			}
			if (!data || data.length == 0) {
				return res.status(204).send("no.rewards")
			}
			return res.send(data);
		}).sort({
			goldToAccess: 1
		});
	}

	function findInRange(req, res, next) {
		Reward.find({
			goldToAccess: {
				$gt: Number(req.params.min) - 1,
				$lt: Number(req.params.max) + 1
			}
		}, (err, data) => {
			if (err) {
				return res.status(500).send(err);
			}
			if (!data || data.length == 0) {
				return res.status(204).send("no.rewards")
			}
			return res.send(data);
		}).sort({
			goldToAccess: 1
		});
	}

	function findById(req, res, next) {
		Reward.findById(req.params.id, (err, data) => {
			if (err) {
				return res.status(500).send(err);
			}
			if (!data || data.length == 0) {
				return res.status(404).send("reward.not.found")
			}
			return res.send(data);
		})
	}

	function create(req, res, next) {
		let reward = new Reward(req.body);
		Reward.findOne({
			title: reward.title
		}, (err, found) => {
			if (err) {
				return res.status(500).send(err)
			}
			if (found) {
				return res.status(401).send('reward.already.exists')
			} else {
				reward.save((err, data) => {
					if (err) {
						return res.status(500).send(err);
					}
					return res.send(data);
				})
			}
		});
	}

	function update(req, res, next) {
		Reward.findByIdAndUpdate(req.params.id, req.body, {
			new: true
		}, (err, data) => {
			if (err) {
				return res.status(500).send(err);
			}

			if (!data) {
				return res.status(404).send("reward.not.found")
			}
			return res.send(data);
		});
	}

	function remove(req, res, next) {
		User.update({
			Rewards: {
				$in: [req.params.id]
			}
		}, {
			$pull: {
				Rewards: req.params.id
			}
		}, (err, data) => {
			if (err) {
				return res.status(500).send(err);
			}
			Reward.findByIdAndRemove(req.params.id, (err, data) => {
				if (err) {
					return res.status(500).send(err);
				}
				if (!data) {
					return res.status(404).send('reward.not.found');
				}
				return res.send(data);
			});
		});
	}

	function affectToUser(req, res, next) {
		User.findById(req.params.idUser, (err, dataUser) => {
			if (err) {
				return res.status(500).send(err);
			}
			if (!dataUser) {
				return res.status(404).send("user.dont.exist")
			}
			Reward.findById(req.params.idReward, (err, dataReward) => {
				if (err) {
					return res.status(500).send(err);
				}
				if (!dataReward) {
					return res.status(404).send("reward.dont.exist")
				}
				if (dataUser.gold < dataReward.goldToAccess) {
					return res.status(401).send('not.enought.gold');
				} else {
					dataUser.gold -= dataReward.goldToAccess
					dataUser.Rewards.push(req.params.idReward)
					dataUser.save((err, data) => {
						if (err) {
							return res.status(500).send(err);
						}
						return res.send(data);
					})
				}
			})
		})
	}

	return {
		findSortedByScore,
		findInRange,
		findById,
		create,
		update,
		remove,
		affectToUser
	};
}
