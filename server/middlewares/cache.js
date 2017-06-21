module.exports = (api) => {

    function get(req, res, next) {
        return (req, res, next) => {
            return next();
        }
    }

    function set(model, data, key) {
        return (req, res, next) => {
            return next();
        }
    }

    function clean(model) {
        return (req, res, next) => {
            return next();
        }
    }

    return {
        get,
        set,
        clean
    };
}
