-- phpMyAdmin SQL Dump
-- version 5.0.2
-- https://www.phpmyadmin.net/
--
-- Servidor: 127.0.0.1
-- Tiempo de generación: 28-11-2020 a las 03:41:28
-- Versión del servidor: 10.4.14-MariaDB
-- Versión de PHP: 7.2.33

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Base de datos: `proyecto3`
--

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `pedidos`
--

CREATE TABLE `pedidos` (
  `id` int(11) NOT NULL,
  `fechaCreado` timestamp NOT NULL DEFAULT current_timestamp(),
  `fechaActualizado` timestamp NULL DEFAULT NULL ON UPDATE current_timestamp(),
  `estado` enum('nuevo','confirmado','preparando','enviando','entregando','cancelado','finalizado') NOT NULL DEFAULT 'nuevo',
  `idProducto` int(11) NOT NULL,
  `cantidad` int(2) NOT NULL,
  `formadePago` enum('efectivo','tarjeta','','') NOT NULL,
  `usuario` varchar(250) NOT NULL,
  `direccion_de_envio` varchar(250) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Volcado de datos para la tabla `pedidos`
--

INSERT INTO `pedidos` (`id`, `fechaCreado`, `fechaActualizado`, `estado`, `idProducto`, `cantidad`, `formadePago`, `usuario`, `direccion_de_envio`) VALUES
(11, '2020-10-26 14:33:31', '2020-10-26 18:01:04', 'nuevo', 8, 1, 'efectivo', 'emich', ''),
(12, '2020-10-26 15:00:46', '2020-10-26 18:00:40', 'preparando', 6, 1, 'efectivo', 'emich', 'cipolletti'),
(13, '2020-10-26 15:45:23', '2020-10-26 18:01:55', 'confirmado', 6, 1, 'efectivo', 'Yoli06', 'cipo casa 66'),
(14, '2020-11-01 00:49:11', NULL, 'nuevo', 30, 1, 'efectivo', 'emich', 'cipolletti'),
(15, '2020-11-02 00:49:11', NULL, 'nuevo', 50, 1, 'efectivo', 'emich', 'cipolletti'),
(16, '2020-11-02 00:52:35', NULL, 'nuevo', 2, 1, 'efectivo', 'emich', 'cipolletti'),
(17, '2020-11-02 01:04:55', NULL, 'nuevo', 12, 1, 'efectivo', 'emich', 'cipolletti'),
(18, '2020-11-02 01:16:59', NULL, 'nuevo', 13, 1, 'efectivo', 'emich', 'cipolletti'),
(19, '2020-11-03 22:06:07', NULL, 'finalizado', 8, 1, 'tarjeta', 'emich', 'cipolletti'),
(20, '2020-11-03 22:06:07', '2020-11-03 22:11:39', 'entregando', 9, 1, 'tarjeta', 'emich', 'cipolletti'),
(21, '2020-11-11 19:11:05', NULL, 'nuevo', 8, 1, 'efectivo', 'Milu_gar', 'Leopolodo Lugones'),
(22, '2020-11-11 19:12:06', NULL, 'nuevo', 20, 1, 'efectivo', 'Milu_gar', 'Leopolodo Lugones'),
(23, '2020-11-11 19:12:06', NULL, 'nuevo', 20, 1, 'efectivo', 'Milu_gar', 'Leopolodo Lugones'),
(24, '2020-11-11 19:12:06', NULL, 'nuevo', 8, 1, 'efectivo', 'Milu_gar', 'Leopolodo Lugones'),
(25, '2020-11-27 16:09:14', NULL, 'nuevo', 4, 1, 'tarjeta', 'emich', 'cipolletti'),
(26, '2020-11-27 16:12:35', NULL, 'nuevo', 5, 2, 'efectivo', 'emich', 'cipolletti'),
(27, '2020-11-27 16:12:35', NULL, 'nuevo', 10, 2, 'efectivo', 'emich', 'cipolletti'),
(28, '2020-11-27 16:13:07', NULL, 'nuevo', 10, 2, 'efectivo', 'emich', 'cipolletti'),
(29, '2020-11-27 16:13:07', NULL, 'nuevo', 10, 2, 'efectivo', 'emich', 'cipolletti'),
(30, '2020-11-27 16:13:07', NULL, 'nuevo', 10, 2, 'efectivo', 'emich', 'cipolletti');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `productos`
--

CREATE TABLE `productos` (
  `id` int(11) NOT NULL,
  `codigo_interno` int(11) NOT NULL,
  `nombre` varchar(250) COLLATE utf8_unicode_ci NOT NULL,
  `descripcion` varchar(250) COLLATE utf8_unicode_ci NOT NULL,
  `precio` int(4) NOT NULL,
  `foto` varchar(250) COLLATE utf8_unicode_ci NOT NULL,
  `stock` int(11) DEFAULT 1,
  `fechaCreado` timestamp NOT NULL DEFAULT current_timestamp(),
  `fechaActualizado` timestamp NULL DEFAULT NULL ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

--
-- Volcado de datos para la tabla `productos`
--

INSERT INTO `productos` (`id`, `codigo_interno`, `nombre`, `descripcion`, `precio`, `foto`, `stock`, `fechaCreado`, `fechaActualizado`) VALUES
(4, 8, 'canelones', '', 421, '', 5, '2020-10-13 14:07:23', '2020-11-02 01:23:28'),
(7, 20, 'camarones', '', 200, '1', 12, '2020-10-20 23:51:07', '2020-11-08 22:19:20'),
(11, 9, 'bondiola', '', 500, '', 10, '2020-10-26 18:44:35', NULL);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `usuarios`
--

CREATE TABLE `usuarios` (
  `id` int(11) NOT NULL,
  `usuario` varchar(250) COLLATE utf8_unicode_ci NOT NULL,
  `nombre` varchar(250) COLLATE utf8_unicode_ci NOT NULL,
  `apellido` varchar(250) COLLATE utf8_unicode_ci NOT NULL,
  `correo` varchar(250) COLLATE utf8_unicode_ci NOT NULL,
  `telefono` int(10) NOT NULL COMMENT 'sin 0 ni 15',
  `direccion_de_envio` varchar(250) COLLATE utf8_unicode_ci NOT NULL,
  `pass` varchar(15) COLLATE utf8_unicode_ci NOT NULL,
  `rol` varchar(250) COLLATE utf8_unicode_ci NOT NULL DEFAULT 'user',
  `fechaCreado` timestamp NOT NULL DEFAULT current_timestamp(),
  `fechaActualizado` timestamp NULL DEFAULT NULL ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

--
-- Volcado de datos para la tabla `usuarios`
--

INSERT INTO `usuarios` (`id`, `usuario`, `nombre`, `apellido`, `correo`, `telefono`, `direccion_de_envio`, `pass`, `rol`, `fechaCreado`, `fechaActualizado`) VALUES
(1, 'emich', 'emilio', 'chiara', 'chiara@gmail.com', 3515, 'cipolletti', '123465', 'admin', '2020-10-05 22:26:49', NULL),
(2, 'Yoli06', 'Yolanda', 'Lorenzo', 'yoli@correo.com', 1326, 'cipo casa 66', '45679', 'user', '2020-10-13 19:25:30', NULL),
(4, 'vir_luna', 'vir', 'Luna', 'vir@gmail.com', 351554488, 'San Lorenzo 291', 'hola', 'user', '2020-10-26 19:00:50', NULL),
(19, 'Miguelito', 'Migue', 'Chiara', 'chiara@miguel.com', 299123456, 'Casa 66', 'elrojo', 'user', '2020-11-08 20:08:18', NULL),
(22, 'Milu_gar', 'Milu', 'Chiara', 'chiara@milu123.com', 299123555, 'Leopolodo Lugones', 'elrojo', 'user', '2020-11-08 20:13:02', NULL),
(24, 'zarucito', 'Zarú', 'Luna', 'zaru@perro', 2165464, 'cba', '1346', 'user', '2020-11-18 12:32:37', NULL);

--
-- Índices para tablas volcadas
--

--
-- Indices de la tabla `pedidos`
--
ALTER TABLE `pedidos`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idProducto` (`idProducto`);

--
-- Indices de la tabla `productos`
--
ALTER TABLE `productos`
  ADD PRIMARY KEY (`id`);

--
-- Indices de la tabla `usuarios`
--
ALTER TABLE `usuarios`
  ADD PRIMARY KEY (`id`);

--
-- AUTO_INCREMENT de las tablas volcadas
--

--
-- AUTO_INCREMENT de la tabla `pedidos`
--
ALTER TABLE `pedidos`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=31;

--
-- AUTO_INCREMENT de la tabla `productos`
--
ALTER TABLE `productos`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=34;

--
-- AUTO_INCREMENT de la tabla `usuarios`
--
ALTER TABLE `usuarios`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=25;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
