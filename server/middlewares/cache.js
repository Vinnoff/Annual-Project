module.exports = (api) => {


    function get(req, res, next) {

        next()
    }

    function set(model, data, key) {

    }

    function clean(model) {
        return (req, res, next) => {
            next();
        }
    }

    return {
        get,
        set,
        clean
    }
}
