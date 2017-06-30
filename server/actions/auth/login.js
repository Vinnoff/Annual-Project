const sha1 = require('sha1');
const jwt = require('jsonwebtoken');

module.exports = (api) => {
    const User = api.models.User;
    const Token = api.models.Token;

    return function login(req, res, next) {
        if ((!req.body.mail && !req.body.userName) || !req.body.password) {
            return res.status(500).send('no.credentials');
        }
        if (req.body.userName) {
            User.findOne({
                userName: req.body.userName,
                password: sha1(req.body.password)
            }, (err, user) => {
                if (err) {
                    return res.status(500).send(err);
                }

                if (!user) {
                    return res.status(401).send('invalid.credentials');
                }

                var token = new Token();
                token.userId = user._id.toString();

                token.save((err, token) => {
                    if (err) {
                        return res.status(500).send(err);
                    }

                    jwt.sign({
                            exp: Math.floor(Date.now() / 1000) + (60 * 60),
                            tokenId: token._id.toString()
                        },
                        api.settings.security.salt, {}, (err, encryptedToken) => {
                            if (err) {
                                return res.status(500).send(err);
                            }

                            return res.send(encryptedToken);
                        }
                    );
                });
            });
        } else {
            User.findOne({
                mail: req.body.mail,
                password: sha1(req.body.password)
            }, (err, user) => {
                if (err) {
                    return res.status(500).send(err);
                }

                if (!user) {
                    return res.status(401).send('invalid.credentials');
                }

                var token = new Token();
                token.userId = user._id.toString();

                token.save((err, token) => {
                    if (err) {
                        return res.status(500).send(err);
                    }

                    jwt.sign({
                            exp: Math.floor(Date.now() / 1000) + (60 * 60),
                            tokenId: token._id.toString()
                        },
                        api.settings.security.salt, {}, (err, encryptedToken) => {
                            if (err) {
                                return res.status(500).send(err);
                            }

                            return res.send(encryptedToken);
                        }
                    );
                });
            });
        }
    }
};
