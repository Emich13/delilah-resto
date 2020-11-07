const jwt = require('jsonwebtoken');
const config = require('./config');



const validarUsuario = (req, res, next) => {

    const token_decoded = req.headers.authorization.split(' ')[1]
    const decodificado = jwt.verify(token_decoded, config.jwtClave);
    req.usuario = decodificado
   
    if (!req.usuario) {
        res.status(403).json({ error: "no estas autorizado" });
    } else {
        console.log("llega")
        next();
    }
}

const esAdmin = (req, res, next) => {
    if (req.usuario.rol === "admin") {
        next();
    } else {
        res.status(403).json({ error: "no estas autorizado" });
        return;
    }

}

module.exports = { validarUsuario, esAdmin };