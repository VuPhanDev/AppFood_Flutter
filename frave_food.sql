-- phpMyAdmin SQL Dump
-- version 5.1.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Aug 09, 2022 at 11:31 AM
-- Server version: 10.4.21-MariaDB
-- PHP Version: 8.0.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `frave_food`
--

DELIMITER $$
--
-- Procedures
--
CREATE DEFINER=`root`@`localhost` PROCEDURE `SP_ADD_CATEGORY` (IN `category` VARCHAR(50), IN `description` VARCHAR(100))  BEGIN
	INSERT INTO categories (category, description) VALUE (category, description);
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `SP_ALL_CLIENT` ()  BEGIN
	SELECT p.uid AS person_id, CONCAT(p.firstName, ' ', p.lastName) AS nameClient, p.phone, p.image, u.notification_token FROM person p
	INNER JOIN users u ON p.uid = u.persona_id
	WHERE u.rol_id = 2 AND p.state = 1;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `SP_ALL_DELIVERYS` ()  BEGIN
	SELECT p.uid AS person_id, CONCAT(p.firstName, ' ', p.lastName) AS nameDelivery, p.phone, p.image, u.notification_token FROM person p
	INNER JOIN users u ON p.uid = u.persona_id
	WHERE u.rol_id = 3 AND p.state = 1;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `SP_ALL_ORDERS_STATUS` (IN `statuss` VARCHAR(30))  BEGIN
	SELECT o.id AS order_id, o.delivery_id, CONCAT(pe.firstName, " ", pe.lastName) AS delivery, pe.image AS deliveryImage, o.client_id, CONCAT(p.firstName, " ", p.lastName) AS cliente, p.image AS clientImage, p.phone AS clientPhone, o.address_id, a.street, a.reference, a.Latitude, a.Longitude, o.status, o.pay_type, o.amount, o.currentDate
	FROM orders o
	INNER JOIN person p ON o.client_id = p.uid
	INNER JOIN addresses a ON o.address_id = a.id
	LEFT JOIN person pe ON o.delivery_id = pe.uid
	WHERE o.`status` = statuss;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `SP_GET_PRODUCTS_TOP` ()  BEGIN
	SELECT pro.id, pro.nameProduct, pro.description, pro.price, pro.status, ip.picture, c.category, c.id AS category_id FROM products pro
	INNER JOIN categories c ON pro.category_id = c.id
	INNER JOIN imageProduct ip ON pro.id = ip.product_id
	INNER JOIN ( SELECT product_id, MIN(id) AS id_image FROM imageProduct GROUP BY product_id) p3 ON ip.product_id = p3.product_id AND ip.id = p3.id_image
	LIMIT 10;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `SP_LIST_PRODUCTS_ADMIN` ()  BEGIN
	SELECT pro.id, pro.nameProduct, pro.description, pro.price, pro.status, ip.picture, c.category, c.id AS category_id FROM products pro
	INNER JOIN categories c ON pro.category_id = c.id
	INNER JOIN imageProduct ip ON pro.id = ip.product_id
	INNER JOIN ( SELECT product_id, MIN(id) AS id_image FROM imageProduct GROUP BY product_id) p3 ON ip.product_id = p3.product_id AND ip.id = p3.id_image;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `SP_LOGIN` (IN `email` VARCHAR(100))  BEGIN
	SELECT p.uid, p.firstName, p.lastName, p.image, u.email, u.passwordd, u.rol_id, u.notification_token FROM person p
	INNER JOIN users u ON p.uid = u.persona_id
	WHERE u.email = email AND p.state = TRUE;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `SP_ORDERS_BY_DELIVERY` (IN `ID` INT, IN `statuss` VARCHAR(30))  BEGIN
	SELECT o.id AS order_id, o.delivery_id, o.client_id, CONCAT(p.firstName, " ", p.lastName) AS cliente, p.image AS clientImage, p.phone AS clientPhone, o.address_id, a.street, a.reference, a.Latitude, a.Longitude, o.status, o.pay_type, o.amount, o.currentDate
	FROM orders o
	INNER JOIN person p ON o.client_id = p.uid
	INNER JOIN addresses a ON o.address_id = a.id
	WHERE o.status = statuss AND o.delivery_id = ID;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `SP_ORDERS_FOR_CLIENT` (IN `ID` INT)  BEGIN
	SELECT o.id, o.client_id, o.delivery_id, ad.reference, ad.Latitude AS latClient, ad.Longitude AS lngClient ,CONCAT(p.firstName, ' ', p.lastName)AS delivery, p.phone AS deliveryPhone, p.image AS imageDelivery, o.address_id, o.latitude, o.longitude, o.`status`, o.amount, o.pay_type, o.currentDate 
	FROM orders o
	LEFT JOIN person p ON p.uid = o.delivery_id
	INNER JOIN addresses ad ON o.address_id = ad.id 
	WHERE o.client_id = ID
	ORDER BY o.id DESC;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `SP_ORDER_DETAILS` (IN `IDORDER` INT)  BEGIN
	SELECT od.id, od.order_id, od.product_id, p.nameProduct, ip.picture, od.quantity, od.price AS total
	FROM orderdetails od
	INNER JOIN products p ON od.product_id = p.id
	INNER JOIN imageProduct ip ON p.id = ip.product_id
	INNER JOIN ( SELECT product_id, MIN(id) AS id_image FROM imageProduct GROUP BY product_id) p3 ON ip.product_id = p3.product_id AND ip.id = p3.id_image
	WHERE od.order_id = IDORDER;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `SP_REGISTER` (IN `firstName` VARCHAR(50), IN `lastName` VARCHAR(50), IN `phone` VARCHAR(11), IN `image` VARCHAR(250), IN `email` VARCHAR(100), IN `pass` VARCHAR(100), IN `rol` INT, IN `nToken` VARCHAR(255))  BEGIN
	INSERT INTO Person (firstName, lastName, phone, image) VALUE (firstName, lastName, phone, image);
	
	INSERT INTO users (users, email, passwordd, persona_id, rol_id, notification_token) VALUE (firstName, email, pass, LAST_INSERT_ID(), rol, nToken);
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `SP_RENEWTOKENLOGIN` (IN `uid` INT)  BEGIN
	SELECT p.uid, p.firstName, p.lastName, p.image, p.phone, u.email, u.rol_id, u.notification_token FROM person p
	INNER JOIN users u ON p.uid = u.persona_id
	WHERE p.uid = uid AND p.state = TRUE;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `SP_SEARCH_FOR_CATEGORY` (IN `IDCATEGORY` INT)  BEGIN
	SELECT pro.id, pro.nameProduct, pro.description, pro.price, pro.status, ip.picture, c.category, c.id AS category_id FROM products pro
	INNER JOIN categories c ON pro.category_id = c.id
	INNER JOIN imageProduct ip ON pro.id = ip.product_id
	INNER JOIN ( SELECT product_id, MIN(id) AS id_image FROM imageProduct GROUP BY product_id) p3 ON ip.product_id = p3.product_id AND ip.id = p3.id_image
	WHERE pro.category_id = IDCATEGORY;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `SP_SEARCH_PRODUCT` (IN `nameProduct` VARCHAR(100))  BEGIN
	SELECT pro.id, pro.nameProduct, pro.description, pro.price, pro.status, ip.picture, c.category, c.id AS category_id FROM products pro
	INNER JOIN categories c ON pro.category_id = c.id
	INNER JOIN imageProduct ip ON pro.id = ip.product_id
	INNER JOIN ( SELECT product_id, MIN(id) AS id_image FROM imageProduct GROUP BY product_id) p3 ON ip.product_id = p3.product_id AND ip.id = p3.id_image
	WHERE pro.nameProduct LIKE CONCAT('%', nameProduct , '%');
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `SP_UPDATE_PROFILE` (IN `ID` INT, IN `firstName` VARCHAR(50), IN `lastName` VARCHAR(50), IN `phone` VARCHAR(11))  BEGIN
	UPDATE person
		SET firstName = firstName,
			 lastName = lastName,
			 phone = phone
	WHERE person.uid = ID;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `SP_USER_BY_ID` (IN `ID` INT)  BEGIN
	SELECT p.uid, p.firstName, p.lastName, p.phone, p.image, u.email, u.rol_id, u.notification_token FROM person p
	INNER JOIN users u ON p.uid = u.persona_id
	WHERE p.uid = 1 AND p.state = TRUE;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `SP_USER_UPDATED` (IN `ID` INT)  BEGIN
	SELECT p.firstName, p.lastName, p.image, u.email, u.rol_id FROM person p
	INNER JOIN users u ON p.uid = u.persona_id
	WHERE p.uid = 2 AND p.state = TRUE;
END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `addresses`
--

CREATE TABLE `addresses` (
  `id` int(11) NOT NULL,
  `street` varchar(100) DEFAULT NULL,
  `reference` varchar(100) DEFAULT NULL,
  `Latitude` varchar(50) DEFAULT NULL,
  `Longitude` varchar(50) DEFAULT NULL,
  `persona_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `addresses`
--

INSERT INTO `addresses` (`id`, `street`, `reference`, `Latitude`, `Longitude`, `persona_id`) VALUES
(11, 'dương liên ấp', 'Đường Liên Ấp, #, ', '10.718347119687019', '106.66707213968039', 8),
(12, 'đường cao lỗ', 'Đường Cao Lỗ, #Lo J, ', '10.738440161054456', '106.67749755084515', 9),
(14, 'Trần Thị ngôi', 'Trần Thị Ngôi, #104-1, ', '10.735462656624332', '106.67779292911291', 10),
(15, 'Tran Thi Noi', 'Trần Thị Nơi, #164, ', '10.738312351974809', '106.6741756349802', 11),
(16, 'Cao Lo', '270 Cao Lỗ, #102, ', '10.736370503765897', '106.67701374739408', 12);

-- --------------------------------------------------------

--
-- Table structure for table `categories`
--

CREATE TABLE `categories` (
  `id` int(11) NOT NULL,
  `category` varchar(50) NOT NULL,
  `description` varchar(100) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `categories`
--

INSERT INTO `categories` (`id`, `category`, `description`) VALUES
(1, 'Drinks', 'Description Drinks'),
(2, 'Fast Food', 'Fast Food Description'),
(3, 'Soda', 'Soda Description'),
(4, 'Juices', 'Jucies description'),
(5, 'Pizza', 'pizza description'),
(6, 'Snacks', 'Snacks Description'),
(7, 'Salad', 'Salad Description'),
(8, 'Ice Cream', 'Ice Cream description'),
(9, 'beef', 'beef description'),
(10, 'beef', 'description'),
(11, 'them loai moi', 'kakaka');

-- --------------------------------------------------------

--
-- Table structure for table `imageproduct`
--

CREATE TABLE `imageproduct` (
  `id` int(11) NOT NULL,
  `picture` varchar(255) DEFAULT NULL,
  `product_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `imageproduct`
--

INSERT INTO `imageproduct` (`id`, `picture`, `product_id`) VALUES
(4, 'image-1629870138818.jpg', 2),
(5, 'image-1629870138832.jpg', 2),
(6, 'image-1629870138806.jpg', 2),
(7, 'image-1629870179686.jpg', 3),
(8, 'image-1629870179668.jpg', 3),
(9, 'image-1629870179673.jpg', 3),
(10, 'image-1629870261732.jpg', 4),
(11, 'image-1629870261705.jpg', 4),
(12, 'image-1629870261720.jpg', 4),
(13, 'image-1629870352886.jpg', 5),
(14, 'image-1629870352860.jpg', 5),
(15, 'image-1629870352878.jpg', 5),
(16, 'image-1629870430590.jpg', 6),
(17, 'image-1629870430603.jpg', 6),
(18, 'image-1629870531978.jpg', 7),
(19, 'image-1629870531950.jpg', 7),
(20, 'image-1629870531968.jpg', 7),
(21, 'image-1629870638120.jpg', 8),
(22, 'image-1629870638087.jpg', 8),
(23, 'image-1629870638103.jpg', 8),
(24, 'image-1629870722161.jpg', 9),
(25, 'image-1629870722097.jpg', 9),
(26, 'image-1629870722142.jpg', 9),
(27, 'image-1629870861994.jpg', 10),
(28, 'image-1629870861987.jpg', 10),
(29, 'image-1629870861988.jpg', 10),
(30, 'image-1629870963896.jpg', 11),
(31, 'image-1629870963870.jpg', 11),
(32, 'image-1629870963885.jpg', 11),
(33, 'image-1629871015906.jpg', 12),
(34, 'image-1629871015857.jpg', 12),
(35, 'image-1629871015882.jpg', 12),
(36, 'image-1629871040235.jpg', 13),
(37, 'image-1629871040124.jpg', 13),
(38, 'image-1629871040218.jpg', 13),
(39, 'image-1629871070308.jpg', 14),
(40, 'image-1629871070269.jpg', 14),
(41, 'image-1629871070286.jpg', 14),
(42, 'image-1629871097936.jpg', 15),
(43, 'image-1629871097906.jpg', 15),
(44, 'image-1629871097926.jpg', 15),
(45, 'image-1629871137001.jpg', 16),
(46, 'image-1629871136311.jpg', 16),
(47, 'image-1629871136326.jpg', 16),
(48, 'image-1655885930922.jpg', 17),
(49, 'image-1655886141057.jpg', 18),
(50, 'image-1655886146603.jpg', 19);

-- --------------------------------------------------------

--
-- Table structure for table `orderdetails`
--

CREATE TABLE `orderdetails` (
  `id` int(11) NOT NULL,
  `order_id` int(11) NOT NULL,
  `product_id` int(11) NOT NULL,
  `quantity` int(11) NOT NULL,
  `price` double(11,2) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `orderdetails`
--

INSERT INTO `orderdetails` (`id`, `order_id`, `product_id`, `quantity`, `price`) VALUES
(16, 38, 2, 1, 16.00),
(17, 38, 3, 1, 5.00),
(18, 38, 4, 1, 7.00),
(32, 44, 2, 1, 16.00),
(33, 44, 3, 1, 5.00),
(34, 44, 7, 1, 9.00),
(35, 45, 7, 3, 27.00),
(36, 45, 2, 5, 80.00),
(37, 45, 3, 4, 20.00),
(38, 46, 2, 10, 160.00),
(39, 47, 17, 2, 300000.00),
(40, 47, 16, 1, 59.00),
(41, 47, 19, 1, 150000.00),
(42, 48, 4, 4, 28.00),
(43, 49, 7, 4, 36.00),
(44, 50, 2, 5, 80.00),
(45, 51, 2, 1, 16.00),
(46, 52, 3, 1, 5.00),
(47, 53, 3, 5, 25.00),
(48, 54, 2, 1, 16.00),
(49, 55, 2, 1, 16.00),
(50, 56, 2, 1, 16.00);

-- --------------------------------------------------------

--
-- Table structure for table `orders`
--

CREATE TABLE `orders` (
  `id` int(11) NOT NULL,
  `client_id` int(11) NOT NULL,
  `delivery_id` int(11) DEFAULT NULL,
  `address_id` int(11) NOT NULL,
  `latitude` varchar(50) DEFAULT NULL,
  `longitude` varchar(50) DEFAULT NULL,
  `status` varchar(50) DEFAULT 'PAID OUT',
  `receipt` varchar(100) DEFAULT NULL,
  `amount` double(11,2) DEFAULT NULL,
  `pay_type` varchar(50) NOT NULL,
  `currentDate` datetime DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `orders`
--

INSERT INTO `orders` (`id`, `client_id`, `delivery_id`, `address_id`, `latitude`, `longitude`, `status`, `receipt`, `amount`, `pay_type`, `currentDate`) VALUES
(38, 9, 7, 12, '10.7379385', '106.6776424', 'ON WAY', NULL, 28.00, 'CREDIT CARD', '2022-07-01 12:24:18'),
(44, 8, 7, 12, '10.738440161054456', '106.67749755084515', 'DISPATCHED', NULL, 30.00, 'CREDIT CARD', '2022-07-03 17:51:38'),
(45, 9, 7, 12, '10.73784', '106.67768', 'ON WAY', NULL, 127.00, 'CREDIT CARD', '2022-07-03 17:55:56'),
(46, 9, 7, 12, '10.7379568', '106.6776443', 'ON WAY', NULL, 160.00, 'CREDIT CARD', '2022-07-03 18:24:09'),
(47, 9, 7, 12, '10.73629', '106.6799167', 'DELIVERED', NULL, 450059.00, 'CREDIT CARD', '2022-07-04 12:27:09'),
(48, 9, NULL, 12, '10.738440161054456', '106.67749755084515', 'PAID OUT', NULL, 28.00, 'PAYPAL', '2022-07-11 18:37:52'),
(49, 9, 7, 12, '10.73803', '106.6778033', 'ON WAY', NULL, 36.00, 'GOOGLE PAY', '2022-07-11 18:39:05'),
(50, 11, 7, 15, '10.73803', '106.6778033', 'DELIVERED', NULL, 80.00, 'CASH PAYMENT', '2022-07-11 18:48:03'),
(51, 9, NULL, 12, '10.738440161054456', '106.67749755084515', 'PAID OUT', NULL, 16.00, 'CREDIT CARD', '2022-07-13 16:45:24'),
(52, 9, NULL, 12, '10.738440161054456', '106.67749755084515', 'PAID OUT', NULL, 5.00, 'CREDIT CARD', '2022-07-15 22:27:29'),
(53, 8, NULL, 11, '10.718347119687019', '106.66707213968039', 'PAID OUT', NULL, 25.00, 'CREDIT CARD', '2022-07-18 11:12:12'),
(54, 8, NULL, 11, '10.718347119687019', '106.66707213968039', 'PAID OUT', NULL, 16.00, 'PAYPAL', '2022-07-18 12:09:33'),
(55, 8, NULL, 11, '10.718347119687019', '106.66707213968039', 'PAID OUT', NULL, 16.00, 'PAYPAL', '2022-07-18 12:11:22'),
(56, 9, 7, 12, '10.73784', '106.67768', 'ON WAY', NULL, 16.00, 'CREDIT CARD', '2022-07-21 14:09:10');

-- --------------------------------------------------------

--
-- Table structure for table `person`
--

CREATE TABLE `person` (
  `uid` int(11) NOT NULL,
  `firstName` varchar(50) DEFAULT NULL,
  `lastName` varchar(50) DEFAULT NULL,
  `phone` varchar(11) DEFAULT NULL,
  `image` varchar(250) DEFAULT NULL,
  `state` tinyint(1) DEFAULT 1,
  `created` datetime DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `person`
--

INSERT INTO `person` (`uid`, `firstName`, `lastName`, `phone`, `image`, `state`, `created`) VALUES
(7, 'Nhat', 'Hao', '0966866766', 'image-1656478419948.jpg', 1, '2022-06-29 11:53:40'),
(8, 'thien', 'vu', '03363393353', 'image-1656514516269.jpg', 1, '2022-06-29 21:55:16'),
(9, 'quynh', 'dang', '0388299566', 'image-1656568782222.jpg', 1, '2022-06-30 12:59:42'),
(10, 'nhat', 'phi', '0933633533', 'image-1656607614233.jpg', 1, '2022-06-30 23:46:54'),
(11, 'trinhduc', 'thay', '0123456789', 'image-1657539818905.jpg', 1, '2022-07-11 18:43:38'),
(12, 'hihi', 'haha', '0966566466', 'image-1657784577082.jpg', 1, '2022-07-14 14:42:57'),
(13, 'dat', 'Quoc', '06655443', 'image-1658114123899.jpg', 1, '2022-07-18 10:15:23'),
(14, 'ngan', 'le', '0588488699', 'image-1658114293377.jpg', 1, '2022-07-18 10:18:13');

-- --------------------------------------------------------

--
-- Table structure for table `products`
--

CREATE TABLE `products` (
  `id` int(11) NOT NULL,
  `nameProduct` varchar(50) NOT NULL,
  `description` varchar(200) DEFAULT NULL,
  `price` double(11,2) NOT NULL,
  `status` tinyint(1) DEFAULT 1,
  `category_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `products`
--

INSERT INTO `products` (`id`, `nameProduct`, `description`, `price`, `status`, `category_id`) VALUES
(2, 'Corona', 'Corona description', 16.00, 1, 1),
(3, 'Coca Cola', 'Coca Cola description', 5.00, 1, 3),
(4, 'Pepsi', 'Pepsi description', 7.00, 1, 3),
(5, 'Sprite', 'Sprite Description', 7.00, 1, 3),
(6, 'Fanta', 'Fanta Description', 6.00, 1, 3),
(7, 'Inka cola', 'Inka Cola Description', 9.00, 1, 3),
(8, 'Hamburguesas', 'Hamburguesas description', 23.00, 1, 2),
(9, 'Pizza', 'Pizza description', 8.50, 1, 2),
(10, 'Fast food', 'Fast food description', 35.00, 0, 2),
(11, 'Salad 1', 'Salad 1 description', 45.00, 0, 7),
(12, 'Salad 2', 'Salad 2 description', 38.00, 1, 7),
(13, 'Salad 3', 'Salad 3 description', 28.00, 0, 7),
(14, 'Salad 4', 'Salad 4 description', 39.00, 1, 7),
(15, 'Salad 5', 'Salad 5 description', 59.00, 1, 7),
(16, 'Pizza two', 'Pizza two description', 59.00, 1, 2),
(17, 'pizza', '27cm', 150000.00, 1, 2),
(18, 'pizza', '27cm', 150000.00, 1, 2),
(19, 'pizza', '27cm', 150000.00, 1, 2),
(20, 'banh', 'banh oxi', 5000.00, 1, 6),
(21, 'pizza', '27cm', 150000.00, 1, 2);

-- --------------------------------------------------------

--
-- Table structure for table `roles`
--

CREATE TABLE `roles` (
  `id` int(11) NOT NULL,
  `rol` varchar(50) NOT NULL,
  `description` varchar(100) NOT NULL,
  `state` tinyint(1) DEFAULT 1
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `roles`
--

INSERT INTO `roles` (`id`, `rol`, `description`, `state`) VALUES
(1, 'Admin', 'Admin', 1),
(2, 'Client', 'Client', 1),
(3, 'Delivery', 'Delivery', 1);

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

CREATE TABLE `users` (
  `id` int(11) NOT NULL,
  `users` varchar(50) NOT NULL,
  `email` varchar(100) NOT NULL,
  `passwordd` varchar(100) NOT NULL,
  `persona_id` int(11) NOT NULL,
  `rol_id` int(11) NOT NULL,
  `notification_token` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `users`
--

INSERT INTO `users` (`id`, `users`, `email`, `passwordd`, `persona_id`, `rol_id`, `notification_token`) VALUES
(7, 'Nhat', 'nhathao@gmail.com', '$2b$10$1VjK/g6VnaUhK0A/bVMkee4Aem4NvZWHJgonnh7/h25ybR3RIz60.', 7, 3, 'ePh9lbSYSXugQmfozRQRgY:APA91bHBKyDrTZOXBY_U77DPTT01W974DMktYSzapn6G6tXeYMe12oUa9r9XqjQ7WgXNTV3vloSjlNFY49UDUNYJmsYv2DT2jvzsTAHDrTxZomu8-ihlTv-HwNZzsupFqvJ1Iq9frArY'),
(8, 'thien', 'thienvu@gmail.com', '$2b$10$FX0oU6g8kQyRvGBOMDV4XOHsWvOdOlhslgK/XDO8vaM4QSyotyNwu', 8, 1, 'ePh9lbSYSXugQmfozRQRgY:APA91bHBKyDrTZOXBY_U77DPTT01W974DMktYSzapn6G6tXeYMe12oUa9r9XqjQ7WgXNTV3vloSjlNFY49UDUNYJmsYv2DT2jvzsTAHDrTxZomu8-ihlTv-HwNZzsupFqvJ1Iq9frArY'),
(9, 'quynh', 'quynhdang@gmail.com', '$2b$10$8F6dS1SXQbWsgtsxYDc.MulzqvDiixw7Hwr41ZrF4Cnd53lNRNVYW', 9, 2, 'ePh9lbSYSXugQmfozRQRgY:APA91bHBKyDrTZOXBY_U77DPTT01W974DMktYSzapn6G6tXeYMe12oUa9r9XqjQ7WgXNTV3vloSjlNFY49UDUNYJmsYv2DT2jvzsTAHDrTxZomu8-ihlTv-HwNZzsupFqvJ1Iq9frArY'),
(10, 'nhat', 'nhatphi@gmail.com', '$2b$10$2pkkIJzKz/QYhabWN9rzku82Ot6Uv6.GSo39jqgSjP2ZA5fO8EFOm', 10, 2, 'ePh9lbSYSXugQmfozRQRgY:APA91bHBKyDrTZOXBY_U77DPTT01W974DMktYSzapn6G6tXeYMe12oUa9r9XqjQ7WgXNTV3vloSjlNFY49UDUNYJmsYv2DT2jvzsTAHDrTxZomu8-ihlTv-HwNZzsupFqvJ1Iq9frArY'),
(11, 'trinhduc', 'trinhduc@gmail.com', '$2b$10$zuj8fTQOxq/1H78fnliRB.OueUC2RkrryRLb.G9GviCAKh83kEDDe', 11, 2, 'ePh9lbSYSXugQmfozRQRgY:APA91bHBKyDrTZOXBY_U77DPTT01W974DMktYSzapn6G6tXeYMe12oUa9r9XqjQ7WgXNTV3vloSjlNFY49UDUNYJmsYv2DT2jvzsTAHDrTxZomu8-ihlTv-HwNZzsupFqvJ1Iq9frArY'),
(12, 'hihi', 'hihihaha@gmail.com', '$2b$10$oSSg.55wOYtW9w.o8iMMYONeFHsO.fSZX0gUysA0l2JId83Wrf3yS', 12, 2, 'ePh9lbSYSXugQmfozRQRgY:APA91bHBKyDrTZOXBY_U77DPTT01W974DMktYSzapn6G6tXeYMe12oUa9r9XqjQ7WgXNTV3vloSjlNFY49UDUNYJmsYv2DT2jvzsTAHDrTxZomu8-ihlTv-HwNZzsupFqvJ1Iq9frArY'),
(13, 'dat', 'quocdat@gmail.com', '$2b$10$DarEbrWWYTVfypV0ksYjveE.zkV6Yl1tu5Klom.biPGn9jaJypijq', 13, 3, 'd1upOUdKRd6SXwD_w65q5M:APA91bFXxDmkkOjSa7Ky5zukmUwBIxQkJryiuIfLE1btzLIH18oIKTpKHfWHk9fueb0vTpTcq5ru2MDqUW6IlaqWxCd2zFJGhitRsYq5WULKIsPeKd10Dj1aNfkY9kxLrAld5eEjMIEO'),
(14, 'ngan', 'lengan@gmail.com', '$2b$10$lOJsyePsNU8TIySJAmgke.pTe3eGgG.Dv30BWZMpVbmTYOvIAup9y', 14, 3, 'd1upOUdKRd6SXwD_w65q5M:APA91bFXxDmkkOjSa7Ky5zukmUwBIxQkJryiuIfLE1btzLIH18oIKTpKHfWHk9fueb0vTpTcq5ru2MDqUW6IlaqWxCd2zFJGhitRsYq5WULKIsPeKd10Dj1aNfkY9kxLrAld5eEjMIEO');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `addresses`
--
ALTER TABLE `addresses`
  ADD PRIMARY KEY (`id`),
  ADD KEY `persona_id` (`persona_id`);

--
-- Indexes for table `categories`
--
ALTER TABLE `categories`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `imageproduct`
--
ALTER TABLE `imageproduct`
  ADD PRIMARY KEY (`id`),
  ADD KEY `product_id` (`product_id`);

--
-- Indexes for table `orderdetails`
--
ALTER TABLE `orderdetails`
  ADD PRIMARY KEY (`id`),
  ADD KEY `order_id` (`order_id`),
  ADD KEY `product_id` (`product_id`);

--
-- Indexes for table `orders`
--
ALTER TABLE `orders`
  ADD PRIMARY KEY (`id`),
  ADD KEY `client_id` (`client_id`),
  ADD KEY `delivery_id` (`delivery_id`),
  ADD KEY `address_id` (`address_id`);

--
-- Indexes for table `person`
--
ALTER TABLE `person`
  ADD PRIMARY KEY (`uid`);

--
-- Indexes for table `products`
--
ALTER TABLE `products`
  ADD PRIMARY KEY (`id`),
  ADD KEY `category_id` (`category_id`);

--
-- Indexes for table `roles`
--
ALTER TABLE `roles`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `email` (`email`),
  ADD KEY `persona_id` (`persona_id`),
  ADD KEY `rol_id` (`rol_id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `addresses`
--
ALTER TABLE `addresses`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=17;

--
-- AUTO_INCREMENT for table `categories`
--
ALTER TABLE `categories`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=12;

--
-- AUTO_INCREMENT for table `imageproduct`
--
ALTER TABLE `imageproduct`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=51;

--
-- AUTO_INCREMENT for table `orderdetails`
--
ALTER TABLE `orderdetails`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=51;

--
-- AUTO_INCREMENT for table `orders`
--
ALTER TABLE `orders`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=57;

--
-- AUTO_INCREMENT for table `person`
--
ALTER TABLE `person`
  MODIFY `uid` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=15;

--
-- AUTO_INCREMENT for table `products`
--
ALTER TABLE `products`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=22;

--
-- AUTO_INCREMENT for table `roles`
--
ALTER TABLE `roles`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `users`
--
ALTER TABLE `users`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=15;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `addresses`
--
ALTER TABLE `addresses`
  ADD CONSTRAINT `addresses_ibfk_1` FOREIGN KEY (`persona_id`) REFERENCES `person` (`uid`);

--
-- Constraints for table `imageproduct`
--
ALTER TABLE `imageproduct`
  ADD CONSTRAINT `imageproduct_ibfk_1` FOREIGN KEY (`product_id`) REFERENCES `products` (`id`);

--
-- Constraints for table `orderdetails`
--
ALTER TABLE `orderdetails`
  ADD CONSTRAINT `orderdetails_ibfk_1` FOREIGN KEY (`order_id`) REFERENCES `orders` (`id`),
  ADD CONSTRAINT `orderdetails_ibfk_2` FOREIGN KEY (`product_id`) REFERENCES `products` (`id`);

--
-- Constraints for table `orders`
--
ALTER TABLE `orders`
  ADD CONSTRAINT `orders_ibfk_1` FOREIGN KEY (`client_id`) REFERENCES `person` (`uid`),
  ADD CONSTRAINT `orders_ibfk_2` FOREIGN KEY (`delivery_id`) REFERENCES `person` (`uid`),
  ADD CONSTRAINT `orders_ibfk_3` FOREIGN KEY (`address_id`) REFERENCES `addresses` (`id`);

--
-- Constraints for table `products`
--
ALTER TABLE `products`
  ADD CONSTRAINT `products_ibfk_1` FOREIGN KEY (`category_id`) REFERENCES `categories` (`id`);

--
-- Constraints for table `users`
--
ALTER TABLE `users`
  ADD CONSTRAINT `users_ibfk_1` FOREIGN KEY (`persona_id`) REFERENCES `person` (`uid`),
  ADD CONSTRAINT `users_ibfk_2` FOREIGN KEY (`rol_id`) REFERENCES `roles` (`id`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
