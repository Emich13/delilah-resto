//Vínculos

const sequelize = require('./conexion.js');
require('dotenv').config()
const { validarUsuario, esAdmin } = require('./authorization.js');
const config = require('./config')


//npm install express
var express = require('express');
var app = express();
app.use(express.static('publica'));

//npm install body-parser
var bodyParser = require('body-parser');
app.use(bodyParser.json());
app.use(bodyParser.urlencoded({ extended: false }));

//Cors
const cors = require('cors');
app.use(cors());

//Helmet
const helmet = require('helmet')
app.use(helmet())
//const rateLimit = require("express-rate-limit");

//npm install jsonwebtoken
var jwt = require('jsonwebtoken');

//npm install express-jwt
var expressJwt = require('express-jwt');

//Protegemos todo menos el /login
app.use(expressJwt({ secret: process.env.jwtClave, algorithms: ['HS256'] }).unless({ path: ["/login", "/registro"] }));

 //-------------------------------------Usuarios-----------------------------------//

    //Endpoints//

    app.post('/registro', registro) //Registrar nuevo usuario
    app.post('/login', login) //Login usuario existente
    app.put('/user/:id', validarUsuario, editarUsuario) //Modificar datos usuario
    app.delete('/user/:id', validarUsuario, esAdmin, eliminarUsuario) //Eliminar usuario 

    //Queries usuarios
    function registro(req, res) {
        var data = req.body;
        sequelize.query('INSERT INTO usuarios (usuario, nombre, apellido, correo, telefono, direccion_de_envio, pass) VALUES (?,?,?,?,?,?,?)',
            { replacements: [data.usuario, data.nombre, data.apellido, data.correo, data.telefono, data.direccion_de_envio, data.pass] })
            .then(function () {
                res.status(200).send("Usuario creado con exito!")
            }).catch(function () {
                res.status(400).send("Ha ocurrido un error, intentalo nuevamente")
            });
    }

    async function login(req, res) {
        var data = req.body;
        await sequelize.query('SELECT * FROM usuarios WHERE usuario=? AND pass=?',
            { replacements: [data.usuario, data.pass], type: sequelize.QueryTypes.SELECT })
            .then(function (resultado) {
                if (data.usuario == resultado[0].usuario || data.pass == resultado[0].pass) {

                    var token = jwt.sign({
                        usuario: data.usuario,
                        rol: resultado[0].rol,
                        direccion: resultado[0].direccion_de_envio
                    }, process.env.jwtClave);

                    res.status(200).send(token)
                    return
                }
            }).catch(function () {
                res.status(400).send("Usuario y/o pass son incorrectos. Si no tiene una cuenta debe registrarse")
            })
    }

    function editarUsuario(req, res) {
        var data = req.body
        if (data.correo !== "" && data.telefono !== "" && data.direccion_de_envio !== "" && data.pass !== "" && req.params.id !== "") {
            sequelize.query('UPDATE usuarios SET correo=?, telefono=?, direccion_de_envio=?, pass=? WHERE id =?',
                { replacements: [data.correo, data.telefono, data.direccion_de_envio, data.pass, req.params.id] })
                .then(function () {
                    res.send("Usuario editado con éxito");
                }).catch(function () {
                    res.status(400).send("Ha ocurrido un error, intentalo nuevamente")
                });
        } else {
            res.status(400).send("Debes actualizar todos tus datos")
        }

    }

    function eliminarUsuario(req, res) {
        sequelize.query('DELETE FROM usuarios WHERE id = ?',
            { replacements: [req.params.id] })
            .then(function () {
                res.status(200).send('El usuario ha sido eliminado');
            }).catch(function () {
                res.status(400).send('Realiza nuevamente el login');
            });
    }

//--------------------------------Productos--------------------------------//

//Endpoints//
app.get('/productos', validarUsuario, verProductos) //Ver todos los productos
app.get('/productos/:id', validarUsuario, verProductoId) //Visualizar solo un producto
app.delete('/productos/:id', validarUsuario, esAdmin, eliminarProducto) //Eliminar un producto (Admin)
app.post('/productos', validarUsuario, esAdmin, cargarProducto) //Crear un nuevo producto (Admin)
app.put('/productos/:id', validarUsuario, esAdmin, editarProducto) //Modificar un producto (Admin)

//Queries productos

async function verProductos(req, res) {
    if (req.usuario.rol === 'admin') {
        await sequelize.query('SELECT * FROM productos', { type: sequelize.QueryTypes.SELECT })
            .then(function (productos) {

                res.status(200).send(productos);
            })
    } else {
        sequelize.query('SELECT nombre, descripcion, precio, foto, codigo_interno FROM `productos` WHERE stock > 0 GROUP BY nombre',
            { type: sequelize.QueryTypes.SELECT })
            .then(function (productos) {
                res.status(200).send(productos)
            }).catch(function () {
                res.status(400).send('Realiza nuevamente el login');
            })




    }
}
    async function verProductoId(req, res) {
        const producto = await sequelize.query('SELECT * FROM productos WHERE codigo_interno = ?',
            { replacements: [req.params.id], type: sequelize.QueryTypes.SELECT })
            .then(function (producto) {
                res.status(200).send(producto);
            });
    }

    async function eliminarProducto(req, res) {
        await sequelize.query('DELETE FROM productos WHERE id = ?',
            { replacements: [req.params.id] })
            .then(function () {
                res.status(200).send('El producto ha sido eliminado');
            }).catch(function () {
                res.status(400).send('Realiza nuevamente el login');
            });

    }

    function cargarProducto(req, res) {
        var data = req.body;
        sequelize.query('INSERT INTO productos (codigo_interno, nombre, precio, stock, foto) VALUES (?,?,?,?,?)',
            { replacements: [data.codigo_interno, data.nombre, data.precio, data.stock, data.foto] })
            .then(function () {
                res.status(200).send("Producto creado con éxito")
            }).catch(function () {
                res.status(400).send("Ha ocurrido un error, intentalo nuevamente")
            })

    }

    async function editarProducto(req, res) {
        var data = req.body
        await sequelize.query('UPDATE productos SET codigo_interno=?,nombre=?,precio=?, stock=?, foto=? WHERE id =?',
            { replacements: [data.codigo_interno, data.nombre, data.precio, data.stock, data.foto, req.params.id] })
            .then(function () {
                res.send("Producto editado con éxito");
            }).catch(function () {
                res.status(400).send("Ha ocurrido un error, intentalo nuevamente")
            });
    }

   

    //--------------------------------Pedidos--------------------------------//

    //Endpoints//
    app.get('/pedidos', validarUsuario, verPedidos) //Ver todos los pedidos realizados
    app.post('/pedidos/carrito', validarUsuario, agregaraCarrito) //Ver todos los pedidos realizados
    app.post('/pedidos/enviar', validarUsuario, enviarPedido) // Registra pedido en la base
    app.put('/pedidos/:id', validarUsuario, esAdmin, modificarEstado) //Modificar estado (Admin)
    app.get('/pedidos/seguir', validarUsuario, seguirPedido) //Ver todos los pedidos realizados



    //Queries pedidos
    var carrito = []

    function verPedidos(req, res) {
        console.log(req.usuario)
        if (req.usuario.rol === 'admin') {
            sequelize.query('SELECT * FROM pedidos INNER JOIN productos ON pedidos.idProducto = productos.codigo_interno',
                { type: sequelize.QueryTypes.SELECT })
                .then(function (pedidos) {
                    res.status(200).send(pedidos)
                })
        } else {
            sequelize.query('SELECT * FROM pedidos WHERE usuario = ?',
                { replacements: [req.usuario.usuario], type: sequelize.QueryTypes.SELECT })
                .then(function (pedidos) {
                    res.status(200).send(pedidos)
                }).catch(function () {
                    res.status(400).send("No has realizado pedidos hasta el momento")
                })
        }

    }

    function agregaraCarrito(req, res) {
        var data = req.body;

        var pedido = {
            idProducto: data.idProducto,
            cantidad: data.cantidad,
            formadePago: data.formadePago,
            usuario: req.usuario.usuario,
            direccion_de_envio: req.usuario.direccion
        }

        carrito.push(pedido)

        res.status(200).send(carrito)
        return carrito

    }

    function enviarPedido(req, res) {

        for (let index = 0; index < carrito.length; index++) {
            sequelize.query('INSERT INTO pedidos (idProducto, cantidad, formadePago, usuario, direccion_de_envio) VALUES (?,?,?,?,?)',
                { replacements: [carrito[index].idProducto, carrito[index].cantidad, carrito[index].formadePago, req.usuario.usuario, req.usuario.direccion] })
        }
        carrito = []
        res.status(200).send('Se registró su pedido con éxito!')
    }

    function modificarEstado(req, res) {
        var data = req.body
        sequelize.query('UPDATE pedidos SET estado=? WHERE id=?',
            { replacements: [data.estado, req.params.id] })
            .then(function () {
                res.send("Estado modificado con éxito");
            });
    }

   async function seguirPedido(req, res) {
        console.log(req.usuario)
        
    
            sequelize.query(
            `SELECT productos.nombre, productos.precio, estado, formadePago, direccion_de_envio, pedidos.fechaCreado FROM pedidos 
            INNER JOIN productos 
            ON pedidos.idProducto = productos.codigo_interno WHERE usuario = ? 
            AND pedidos.fechaCreado > DATE_SUB(CURRENT_DATE(), INTERVAL 12 HOUR)`,
                {replacements: [req.usuario.usuario], type: sequelize.QueryTypes.SELECT })
                .then(function (pedidos) {
                    res.status(200).send(pedidos)
                })
         
        }

    


    //------------------------------Conexión al servidor---------------------------//
    app.listen(3000, function () {
        console.log('El servidor express corre en el puerto 3000');
    });