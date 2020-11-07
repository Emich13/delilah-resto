const Sequelize = require('sequelize');
const path = 'mysql://root@localhost:3306/proyecto3';
const sequelize = new Sequelize(path);

sequelize.authenticate().then(() => {
    console.log('conectado');
}).catch (err=> {
    console.error('Error de conexion:', err);
})

module.exports = sequelize;