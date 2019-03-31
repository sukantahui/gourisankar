-- phpMyAdmin SQL Dump
-- version 4.7.3
-- https://www.phpmyadmin.net/
--
-- Host: localhost:3306
-- Generation Time: Mar 30, 2019 at 11:42 PM
-- Server version: 5.7.19
-- PHP Version: 7.1.8

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET AUTOCOMMIT = 0;
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `gourisankar_db`
--

DELIMITER $$
--
-- Functions
--
CREATE DEFINER=`root`@`%` FUNCTION `getTotalAppointmentSinceFirstUnlockedNote` (`scEmpId` INT(11), `firstUnlockDate` DATETIME) RETURNS INT(11) BEGIN
DECLARE total_appointment INT(11);
SELECT count(*) into total_appointment FROM `cronCreatedForCacheUsedByEventsReport` WHERE `eventTypeName` = 'Appointment' and eventStatusName = 'Step 4: Approved by doc' and scEmployeeUID=scEmpId and eventEndDateTime>=firstUnlockDate;

RETURN total_appointment;
END$$

CREATE DEFINER=`root`@`localhost` FUNCTION `get_moil_production` (`opening_date` DATE) RETURNS DOUBLE BEGIN
	DECLARE moil DOUBLE;
  select sum(inward) into moil
from stock_production_details where stock_production_master_id in 
(select stock_production_master_id from stock_transaction where product_id=1 and date(transaction_date)=opening_date and outward>0)
and product_id=3 group by product_id;

IF moil is not null then
    RETURN moil;
 else
    RETURN 0;
  end if;
	
END$$

CREATE DEFINER=`root`@`localhost` FUNCTION `get_oil_cake_production` (`opening_date` DATE) RETURNS DOUBLE BEGIN
	DECLARE cake DOUBLE;
  
  select sum(inward) into cake
from stock_production_details where stock_production_master_id in 
(select stock_production_master_id from stock_transaction where product_id=1 and date(transaction_date)=opening_date and outward>0)
and product_id=2 group by product_id;
  IF cake is not null then
    RETURN cake;
   else
    RETURN 0;
  end if;


END$$

CREATE DEFINER=`root`@`localhost` FUNCTION `get_opening_stock` (`p_id` INT, `opening_date` DATE) RETURNS DOUBLE BEGIN
	DECLARE op_balance DOUBLE;
  select (select opening_balance from product where product.product_id = p_id)+sum(inward)
-sum(outward) into op_balance
from stock_transaction
where stock_transaction.product_id=p_id and date(transaction_date)<opening_date; 

  IF op_balance is not null then
    RETURN op_balance;
 else
    RETURN 0;
  end if;
END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `districts`
--

CREATE TABLE `districts` (
  `district_id` int(11) NOT NULL,
  `district_name` varchar(50) DEFAULT NULL,
  `state_id` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `districts`
--

INSERT INTO `districts` (`district_id`, `district_name`, `state_id`) VALUES
(1, 'Alipurduar', 19),
(2, 'Bankura', 19),
(3, 'Birbhum', 19),
(4, 'Burdwan (Bardhaman)', 19),
(5, 'Cooch Behar', 19),
(6, 'Dakshin Dinajpur (South Dinajpur)', 19),
(7, 'Darjeeling', 19),
(8, 'Hooghly', 19),
(9, 'Howrah', 19),
(10, 'Jalpaiguri', 19),
(11, 'Kalimpong', 19),
(12, 'Kolkata', 19),
(13, 'Malda', 19),
(14, 'Murshidabad', 19),
(15, 'Nadia', 19),
(16, 'North 24 Parganas', 19),
(17, 'Paschim Medinipur (West Medinipur)', 19),
(18, 'Purba Medinipur (East Medinipur)', 19),
(19, 'Purulia', 19),
(20, 'South 24 Parganas', 19),
(21, 'Uttar Dinajpur (North Dinajpur)', 19),
(22, 'Araria', 10),
(23, 'Arwal', 10),
(24, 'Aurangabad', 10),
(25, 'Banka', 10),
(26, 'Begusarai', 10),
(27, 'Bhagalpur', 10),
(28, 'Bhojpur', 10),
(29, 'Buxar', 10),
(30, 'Darbhanga', 10),
(31, 'East Champaran', 10),
(32, 'Gaya', 10),
(33, 'Gopalganj', 10),
(34, 'Jamui', 10),
(35, 'Jehanabad', 10),
(36, 'Khagaria', 10),
(37, 'Kishanganj', 10),
(38, 'Kaimur', 10),
(39, 'Katihar', 10),
(40, 'Lakhisarai', 10),
(41, 'Madhubani', 10),
(42, 'Munger', 10),
(43, 'Madhepura', 10),
(44, 'Muzaffarpur', 10),
(45, 'Nalanda', 10),
(46, 'Nawada', 10),
(47, 'Patna', 10),
(48, 'Purnia', 10),
(49, 'Rohtas', 10),
(50, 'Saharsa', 10),
(51, 'Samastipur', 10),
(52, 'Sheohar', 10),
(53, 'Sheikhpura', 10),
(54, 'Saran', 10),
(55, 'Sitamarhi', 10),
(56, 'Supaul', 10),
(57, 'Siwan', 10),
(58, 'Vaishali', 10),
(59, 'West Champaran', 10),
(60, ' Garhwa', 20),
(61, ' Palamu', 20),
(62, ' Latehar', 20),
(63, ' Chatra', 20),
(64, ' Hazaribagh', 20),
(65, ' Koderma', 20),
(66, ' Giridih', 20),
(67, ' Ramgarh', 20),
(68, ' Bokaro', 20),
(69, ' Dhanbad district', 20),
(70, ' Lohardaga', 20),
(71, ' Gumla', 20),
(72, ' Simdega', 20),
(73, ' Ranchi', 20),
(74, ' Khunti', 20),
(75, ' West Singhbhum', 20),
(76, ' Saraikela Kharsawan', 20),
(77, ' East Singhbhum', 20),
(78, ' Jamtara', 20),
(79, ' Deoghar', 20),
(80, ' Dumka', 20),
(81, ' Pakur', 20),
(82, ' Godda', 20),
(83, ' Sahebganj', 20),
(84, 'Angul', 21),
(85, 'Boudh (Baudh)', 21),
(86, 'Balangir', 21),
(87, 'Bargarh (Baragarh)', 21),
(88, 'Balasore (Baleswar)', 21),
(89, 'Bhadrak', 21),
(90, 'Cuttack', 21),
(91, 'Debagarh (Deogarh)', 21),
(92, 'Dhenkanal', 21),
(93, 'Ganjam', 21),
(94, 'Gajapati', 21),
(95, 'Jharsuguda', 21),
(96, 'Jajpur', 21),
(97, 'Jagatsinghapur', 21),
(98, 'Khordha', 21),
(99, 'Kendujhar (Keonjhar)', 21),
(100, 'Kalahandi', 21),
(101, 'Kandhamal', 21),
(102, 'Koraput', 21),
(103, 'Kendrapara', 21),
(104, 'Malkangiri', 21),
(105, 'Mayurbhanj', 21),
(106, 'Nabarangpur', 21),
(107, 'Nuapada', 21),
(108, 'Nayagarh', 21),
(109, 'Puri', 21),
(110, 'Rayagada', 21),
(111, 'Sambalpur', 21),
(112, 'Subarnapur (Sonepur)', 21),
(113, 'Sundergarh', 21),
(114, 'Barpeta', 18),
(115, 'Biswanath ', 18),
(116, 'Bongaigaon', 18),
(117, 'Cachar', 18),
(118, 'Charaideo', 18),
(119, 'Chirang#', 18),
(120, 'Darrang', 18),
(121, 'Dhemaji', 18),
(122, 'Dhubri', 18),
(123, 'Dibrugarh', 18),
(124, 'Goalpara', 18),
(125, 'Golaghat', 18),
(126, 'Hailakandi', 18),
(127, 'Hojai[4]', 18),
(128, 'Jorhat', 18),
(129, 'Kamrup Metropolitan', 18),
(130, 'Kamrup', 18),
(131, 'Karbi Anglong', 18),
(132, 'Karimganj', 18),
(133, 'Kokrajhar#', 18),
(134, 'Lakhimpur', 18),
(135, 'Majuli', 18),
(136, 'Morigaon', 18),
(137, 'Nagaon', 18),
(138, 'Nalbari', 18),
(139, 'Dima Hasao', 18),
(140, 'Sivasagar', 18),
(141, 'Sonitpur', 18),
(142, 'South Salmara-Mankachar', 18);

-- --------------------------------------------------------

--
-- Table structure for table `hsn_table`
--

CREATE TABLE `hsn_table` (
  `hsn_serial_no` int(11) NOT NULL,
  `hsn_code` varchar(20) DEFAULT NULL,
  `gst_rate` double DEFAULT NULL,
  `inforce` int(11) DEFAULT '1'
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `hsn_table`
--

INSERT INTO `hsn_table` (`hsn_serial_no`, `hsn_code`, `gst_rate`, `inforce`) VALUES
(14, '101', 5, 1),
(15, '103', 14, 1),
(16, '2306', 0, 1),
(17, '1514', 5, 1),
(18, '2018', 0, 1),
(19, '105', 14, 1);

-- --------------------------------------------------------

--
-- Table structure for table `maxtable`
--

CREATE TABLE `maxtable` (
  `id` int(11) NOT NULL,
  `subject_name` varchar(50) DEFAULT NULL,
  `current_value` int(5) UNSIGNED ZEROFILL DEFAULT '00000',
  `prefix` varchar(10) DEFAULT NULL,
  `sufix` varchar(10) DEFAULT NULL,
  `financial_year` int(4) DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `maxtable`
--

INSERT INTO `maxtable` (`id`, `subject_name`, `current_value`, `prefix`, `sufix`, `financial_year`) VALUES
(10, 'person', 00000, 'CR', NULL, 1718),
(11, 'person', 00007, 'C', NULL, 1819),
(24, 'purchase', 00002, 'PUR', NULL, 1819),
(30, 'seed_oil_convert', 00000, 'SOC', NULL, 1819),
(40, 'sale mustard oil', 00000, 'SMO', NULL, 1819);

-- --------------------------------------------------------

--
-- Table structure for table `person`
--

CREATE TABLE `person` (
  `person_id` varchar(20) NOT NULL DEFAULT '',
  `person_cat_id` int(11) DEFAULT NULL,
  `company_name` varchar(255) DEFAULT NULL,
  `person_name` varchar(255) DEFAULT NULL,
  `mobile_no` varchar(12) DEFAULT NULL,
  `email` varchar(255) DEFAULT NULL,
  `user_id` varchar(255) DEFAULT NULL,
  `user_password` varchar(255) DEFAULT NULL,
  `address` varchar(255) DEFAULT NULL,
  `city` varchar(255) DEFAULT NULL,
  `district_id` int(11) DEFAULT NULL,
  `post_office` varchar(255) DEFAULT NULL,
  `pin` varchar(12) DEFAULT NULL,
  `aadhar_no` varchar(50) DEFAULT NULL,
  `pan_no` varchar(50) DEFAULT NULL,
  `gst_number` varchar(16) DEFAULT NULL,
  `inforce` int(11) DEFAULT '1',
  `state_id` int(11) DEFAULT NULL,
  `bank_name` varchar(50) DEFAULT NULL,
  `branch` varchar(50) DEFAULT NULL,
  `ifsc_code` varchar(50) DEFAULT NULL,
  `micr_code` varchar(50) DEFAULT NULL,
  `account_number` varchar(3) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `person`
--

INSERT INTO `person` (`person_id`, `person_cat_id`, `company_name`, `person_name`, `mobile_no`, `email`, `user_id`, `user_password`, `address`, `city`, `district_id`, `post_office`, `pin`, `aadhar_no`, `pan_no`, `gst_number`, `inforce`, `state_id`, `bank_name`, `branch`, `ifsc_code`, `micr_code`, `account_number`) VALUES
('C-00005-1819', 5, 'Gourisankar Oil Mill', 'Debojyoti Saha', '9850256520', 'gourisankar@gmail.co', NULL, NULL, 'bethua', 'bethua', 1, '7010128', 'no', 'gjghjk657465', '1258', '70094', 1, 19, 'boi', 'nodia', '100', '100200', '231'),
('C-00006-1819', 4, NULL, 'Robin', '785785898', 'gourisankar@gmail.co', NULL, NULL, 'kolkata', 'bkp', 1, '122255', '700122', 'bjkgh565656', '4565467', '576578', 1, 19, NULL, NULL, NULL, NULL, NULL),
('C-00007-1819', 4, NULL, 'Tanmoy Hajra', '6755', 'gourisankar@gmail.co', NULL, NULL, 'gvhjgh', '', 10, 'jhghj', 'jhghj', 'fvhvh', 'vfvfhg', 'jhghgh', 1, 19, NULL, NULL, NULL, NULL, NULL),
('C-00062-1718', 3, 'Ramu Saha', 'Ramu Saha', '7551869160', NULL, 'ramu', '58ecfdc7967e35bac8738978c0070a2c', 'BETHUADAHARI SIBTOLA PARA', 'Bethuadahari', 15, 'beathuadahari', '741126', '', '', '', 1, 19, NULL, NULL, NULL, NULL, NULL);

-- --------------------------------------------------------

--
-- Table structure for table `person_category`
--

CREATE TABLE `person_category` (
  `person_cat_id` int(11) NOT NULL,
  `person_cat_name` varchar(255) DEFAULT NULL,
  `inforce` int(11) DEFAULT '1'
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `person_category`
--

INSERT INTO `person_category` (`person_cat_id`, `person_cat_name`, `inforce`) VALUES
(1, 'Admin', 1),
(2, 'Developer', 1),
(3, 'Stuff', 1),
(4, 'Customer', 1),
(5, 'Vendor', 1);

-- --------------------------------------------------------

--
-- Table structure for table `product`
--

CREATE TABLE `product` (
  `product_id` int(11) NOT NULL,
  `hsn_serial_no` int(11) DEFAULT NULL,
  `product_name` varchar(255) DEFAULT NULL,
  `inforce` int(11) DEFAULT '1',
  `default_unit_id` int(11) DEFAULT NULL,
  `opening_balance` decimal(10,0) DEFAULT NULL,
  `is_purchaseable` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `product`
--

INSERT INTO `product` (`product_id`, `hsn_serial_no`, `product_name`, `inforce`, `default_unit_id`, `opening_balance`, `is_purchaseable`) VALUES
(1, 14, 'Mustard Seed', 1, 1, '1500', 1),
(2, 16, 'Oil Cake', 1, 1, '2500', 0),
(3, 17, 'Mustard Oil', 1, 1, '120', 0),
(4, 15, '15 Kg Blank Tin', 1, 3, '100', 1),
(5, 18, 'Packets', 1, 3, '2500', 1),
(6, 19, '15 Kg Oil Tin', 1, 3, '200', 0);

-- --------------------------------------------------------

--
-- Table structure for table `purchase_details`
--

CREATE TABLE `purchase_details` (
  `purchase_datails_id` varchar(20) NOT NULL DEFAULT '',
  `purchase_master_id` varchar(20) DEFAULT NULL,
  `product_id` int(11) DEFAULT NULL,
  `unit_id` int(11) DEFAULT NULL,
  `quantity` double DEFAULT NULL,
  `rate` double DEFAULT NULL,
  `sgst_rate` double DEFAULT NULL,
  `cgst_rate` double DEFAULT NULL,
  `igst_rate` double DEFAULT NULL,
  `discount` double DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `purchase_details`
--

INSERT INTO `purchase_details` (`purchase_datails_id`, `purchase_master_id`, `product_id`, `unit_id`, `quantity`, `rate`, `sgst_rate`, `cgst_rate`, `igst_rate`, `discount`) VALUES
('PUR-00001-1819-1', 'PUR-00001-1819', 1, 1, 12, 100, 0.025, 0.025, 0, 0),
('PUR-00002-1819-1', 'PUR-00002-1819', 1, 1, 2, 25, 0.025, 0.025, 0, 0);

-- --------------------------------------------------------

--
-- Table structure for table `purchase_master`
--

CREATE TABLE `purchase_master` (
  `purchase_master_id` varchar(20) NOT NULL DEFAULT '0',
  `vendor_id` varchar(20) DEFAULT NULL,
  `employee_id` varchar(20) DEFAULT NULL,
  `invoice_no` varchar(20) DEFAULT NULL,
  `purchase_date` date NOT NULL,
  `eway_bill_no` varchar(20) DEFAULT NULL,
  `eway_bill_date` date DEFAULT NULL,
  `vehicle_fare` double DEFAULT NULL,
  `truck_no` varchar(20) DEFAULT NULL,
  `bilty_no` varchar(20) DEFAULT NULL,
  `licence_no` varchar(20) DEFAULT NULL,
  `transport_name` varchar(50) DEFAULT NULL,
  `transport_mobile` varchar(13) DEFAULT NULL,
  `roundedOff` decimal(10,2) DEFAULT NULL,
  `grand_total` double DEFAULT NULL,
  `record_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `valid_from` date DEFAULT NULL,
  `valid_to` date DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `purchase_master`
--

INSERT INTO `purchase_master` (`purchase_master_id`, `vendor_id`, `employee_id`, `invoice_no`, `purchase_date`, `eway_bill_no`, `eway_bill_date`, `vehicle_fare`, `truck_no`, `bilty_no`, `licence_no`, `transport_name`, `transport_mobile`, `roundedOff`, `grand_total`, `record_time`, `valid_from`, `valid_to`) VALUES
('PUR-00001-1819', 'C-00005-1819', 'C-00062-1718', '', '2019-03-30', '', '2019-03-30', 0, '', '', '', '', '', '0.00', 1200, '2019-03-30 07:41:34', '2019-03-30', '2019-03-30'),
('PUR-00002-1819', 'C-00005-1819', 'C-00062-1718', '', '2019-03-29', '', '2019-04-01', 0, '', '', '', '', '', '0.00', 50, '2019-03-30 08:51:16', '2019-03-13', '2019-03-28');

-- --------------------------------------------------------

--
-- Table structure for table `sale_details`
--

CREATE TABLE `sale_details` (
  `sale_details_id` varchar(20) NOT NULL,
  `sale_master_id` varchar(15) NOT NULL,
  `product_id` int(11) NOT NULL,
  `quantity` int(11) DEFAULT '0',
  `tin_to_quintal` decimal(10,2) DEFAULT NULL,
  `packet_to_quintal` decimal(10,2) DEFAULT NULL,
  `rate` double DEFAULT '0',
  `sgst_rate` double DEFAULT '0',
  `cgst_rate` double DEFAULT '0',
  `igst_rate` double DEFAULT '0',
  `sgst` double DEFAULT '0',
  `cgst` double DEFAULT '0',
  `igst` double DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `sale_master`
--

CREATE TABLE `sale_master` (
  `sale_master_id` varchar(20) NOT NULL,
  `memo_number` varchar(20) DEFAULT NULL,
  `customer_id` varchar(20) DEFAULT NULL,
  `employee_id` varchar(20) DEFAULT NULL,
  `sale_date` date DEFAULT NULL,
  `roundedOff` decimal(10,2) DEFAULT NULL,
  `grand_total` double DEFAULT NULL,
  `inforce` int(11) DEFAULT '1',
  `record_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `bill_type` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `states`
--

CREATE TABLE `states` (
  `state_id` int(11) NOT NULL DEFAULT '0',
  `state_name` varchar(30) DEFAULT NULL,
  `state_gst_code` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `states`
--

INSERT INTO `states` (`state_id`, `state_name`, `state_gst_code`) VALUES
(1, 'Jammu & Kashmir', 1),
(2, 'Himachal Pradesh', 2),
(3, 'Punjab', 3),
(4, 'Chandigarh', 4),
(5, 'Uttranchal', 5),
(6, 'Haryana', 6),
(7, 'Delhi', 7),
(8, 'Rajasthan', 8),
(9, 'Uttar Pradesh', 9),
(10, 'Bihar', 10),
(11, 'Sikkim', 11),
(12, 'Arunachal Pradesh', 12),
(13, 'Nagaland', 13),
(14, 'Manipur', 14),
(15, 'Mizoram', 15),
(16, 'Tripura', 16),
(17, 'Meghalaya', 17),
(18, 'Assam', 18),
(19, 'West Bengal', 19),
(20, 'Jharkhand', 20),
(21, 'Odisha (Formerly Orissa', 21),
(22, 'Chhattisgarh', 22),
(23, 'Madhya Pradesh', 23),
(24, 'Gujarat', 24),
(25, 'Daman & Diu', 25),
(26, 'Dadra & Nagar Haveli', 26),
(27, 'Maharashtra', 27),
(28, 'Andhra Pradesh', 28),
(29, 'Karnataka', 29),
(30, 'Goa', 30),
(31, 'Lakshdweep', 31),
(32, 'Kerala', 32),
(33, 'Tamil Nadu', 33),
(34, 'Pondicherry', 34),
(35, 'Andaman & Nicobar Islands', 35),
(36, 'Telangana', 36);

-- --------------------------------------------------------

--
-- Table structure for table `stock_production_details`
--

CREATE TABLE `stock_production_details` (
  `stock_production_details_id` varchar(20) NOT NULL DEFAULT '',
  `stock_production_master_id` varchar(15) DEFAULT NULL,
  `product_id` int(11) DEFAULT NULL,
  `inward` double DEFAULT NULL,
  `outward` double DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `stock_production_master`
--

CREATE TABLE `stock_production_master` (
  `stock_production_master_id` varchar(15) NOT NULL,
  `employee_id` varchar(20) DEFAULT NULL,
  `production_date` date DEFAULT NULL,
  `record_date` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `stock_transaction`
--

CREATE TABLE `stock_transaction` (
  `stock_transaction_id` varchar(20) NOT NULL DEFAULT '0',
  `purchase_master_id` varchar(20) DEFAULT NULL,
  `sale_master_id` varchar(20) DEFAULT NULL,
  `stock_production_master_id` varchar(15) DEFAULT NULL,
  `product_id` int(11) DEFAULT NULL,
  `inward` double DEFAULT NULL,
  `outward` double DEFAULT NULL,
  `transaction_date` date DEFAULT NULL,
  `record_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `memo_number` varchar(20) DEFAULT NULL,
  `transaction_type_id` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `stock_transaction`
--

INSERT INTO `stock_transaction` (`stock_transaction_id`, `purchase_master_id`, `sale_master_id`, `stock_production_master_id`, `product_id`, `inward`, `outward`, `transaction_date`, `record_time`, `memo_number`, `transaction_type_id`) VALUES
('ST-PUR-00001-1819-1', 'PUR-00001-1819', NULL, NULL, 1, 12, 0, '2019-03-30', '2019-03-30 07:41:34', '', 2),
('ST-PUR-00002-1819-1', 'PUR-00002-1819', NULL, NULL, 1, 2, 0, '2019-03-29', '2019-03-30 08:51:16', '', 2);

-- --------------------------------------------------------

--
-- Table structure for table `transaction_type`
--

CREATE TABLE `transaction_type` (
  `transaction_type_id` int(11) DEFAULT NULL,
  `transaction_type` varchar(20) DEFAULT NULL,
  `inforce` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `transaction_type`
--

INSERT INTO `transaction_type` (`transaction_type_id`, `transaction_type`, `inforce`) VALUES
(1, 'sale', 1),
(2, 'purchase', 1),
(3, 'wastage', 1),
(4, 'opening balance', 1),
(5, 'production', 1);

-- --------------------------------------------------------

--
-- Table structure for table `units`
--

CREATE TABLE `units` (
  `unit_id` int(11) NOT NULL DEFAULT '0',
  `unit_name` varchar(20) DEFAULT NULL,
  `inforce` int(11) DEFAULT '1'
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `units`
--

INSERT INTO `units` (`unit_id`, `unit_name`, `inforce`) VALUES
(1, 'Quintal', 1),
(2, 'Kg ', 1),
(3, 'Pieces', 1);

--
-- Indexes for dumped tables
--

--
-- Indexes for table `districts`
--
ALTER TABLE `districts`
  ADD PRIMARY KEY (`district_id`);

--
-- Indexes for table `hsn_table`
--
ALTER TABLE `hsn_table`
  ADD PRIMARY KEY (`hsn_serial_no`);

--
-- Indexes for table `maxtable`
--
ALTER TABLE `maxtable`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `subject_name` (`subject_name`,`financial_year`);

--
-- Indexes for table `person`
--
ALTER TABLE `person`
  ADD PRIMARY KEY (`person_id`),
  ADD UNIQUE KEY `person_name` (`person_name`),
  ADD KEY `person_cat_id` (`person_cat_id`);

--
-- Indexes for table `person_category`
--
ALTER TABLE `person_category`
  ADD PRIMARY KEY (`person_cat_id`);

--
-- Indexes for table `product`
--
ALTER TABLE `product`
  ADD PRIMARY KEY (`product_id`),
  ADD KEY `default_unit_id` (`default_unit_id`),
  ADD KEY `hsn_serial_no` (`hsn_serial_no`);

--
-- Indexes for table `purchase_details`
--
ALTER TABLE `purchase_details`
  ADD PRIMARY KEY (`purchase_datails_id`),
  ADD KEY `purchase_master_id` (`purchase_master_id`),
  ADD KEY `unit_id` (`unit_id`),
  ADD KEY `purchase_master_id_2` (`purchase_master_id`),
  ADD KEY `purchase_master_id_3` (`purchase_master_id`),
  ADD KEY `product_id` (`product_id`);

--
-- Indexes for table `purchase_master`
--
ALTER TABLE `purchase_master`
  ADD PRIMARY KEY (`purchase_master_id`),
  ADD KEY `employee_id` (`employee_id`),
  ADD KEY `vendor_id` (`vendor_id`);

--
-- Indexes for table `sale_details`
--
ALTER TABLE `sale_details`
  ADD PRIMARY KEY (`sale_details_id`),
  ADD KEY `sale_master_id` (`sale_master_id`),
  ADD KEY `product_id` (`product_id`);

--
-- Indexes for table `sale_master`
--
ALTER TABLE `sale_master`
  ADD PRIMARY KEY (`sale_master_id`);

--
-- Indexes for table `states`
--
ALTER TABLE `states`
  ADD PRIMARY KEY (`state_id`);

--
-- Indexes for table `stock_production_details`
--
ALTER TABLE `stock_production_details`
  ADD PRIMARY KEY (`stock_production_details_id`),
  ADD KEY `stock_production_master_id` (`stock_production_master_id`),
  ADD KEY `stock_production_master_id_2` (`stock_production_master_id`),
  ADD KEY `product_id` (`product_id`);

--
-- Indexes for table `stock_production_master`
--
ALTER TABLE `stock_production_master`
  ADD PRIMARY KEY (`stock_production_master_id`);

--
-- Indexes for table `stock_transaction`
--
ALTER TABLE `stock_transaction`
  ADD PRIMARY KEY (`stock_transaction_id`),
  ADD KEY `stock_production_master_id` (`stock_production_master_id`),
  ADD KEY `purchase_master_id` (`purchase_master_id`),
  ADD KEY `product_id` (`product_id`),
  ADD KEY `sale_master_id` (`sale_master_id`),
  ADD KEY `sale_master_id_2` (`sale_master_id`);

--
-- Indexes for table `units`
--
ALTER TABLE `units`
  ADD PRIMARY KEY (`unit_id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `districts`
--
ALTER TABLE `districts`
  MODIFY `district_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=143;
--
-- AUTO_INCREMENT for table `hsn_table`
--
ALTER TABLE `hsn_table`
  MODIFY `hsn_serial_no` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=20;
--
-- AUTO_INCREMENT for table `maxtable`
--
ALTER TABLE `maxtable`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=65;
--
-- Constraints for dumped tables
--

--
-- Constraints for table `product`
--
ALTER TABLE `product`
  ADD CONSTRAINT `product_ibfk_1` FOREIGN KEY (`hsn_serial_no`) REFERENCES `hsn_table` (`hsn_serial_no`) ON UPDATE CASCADE;

--
-- Constraints for table `purchase_details`
--
ALTER TABLE `purchase_details`
  ADD CONSTRAINT `purchase_details_ibfk_1` FOREIGN KEY (`purchase_master_id`) REFERENCES `purchase_master` (`purchase_master_id`),
  ADD CONSTRAINT `purchase_details_ibfk_2` FOREIGN KEY (`unit_id`) REFERENCES `units` (`unit_id`),
  ADD CONSTRAINT `purchase_details_ibfk_3` FOREIGN KEY (`product_id`) REFERENCES `product` (`product_id`) ON UPDATE CASCADE;

--
-- Constraints for table `sale_details`
--
ALTER TABLE `sale_details`
  ADD CONSTRAINT `sale_details_ibfk_1` FOREIGN KEY (`sale_master_id`) REFERENCES `sale_master` (`sale_master_id`) ON UPDATE CASCADE,
  ADD CONSTRAINT `sale_details_ibfk_2` FOREIGN KEY (`product_id`) REFERENCES `product` (`product_id`);

--
-- Constraints for table `stock_production_details`
--
ALTER TABLE `stock_production_details`
  ADD CONSTRAINT `stock_production_details_ibfk_1` FOREIGN KEY (`stock_production_master_id`) REFERENCES `stock_production_master` (`stock_production_master_id`) ON UPDATE CASCADE,
  ADD CONSTRAINT `stock_production_details_ibfk_2` FOREIGN KEY (`product_id`) REFERENCES `product` (`product_id`) ON UPDATE CASCADE;

--
-- Constraints for table `stock_transaction`
--
ALTER TABLE `stock_transaction`
  ADD CONSTRAINT `stock_transaction_ibfk_1` FOREIGN KEY (`stock_production_master_id`) REFERENCES `stock_production_master` (`stock_production_master_id`) ON UPDATE CASCADE,
  ADD CONSTRAINT `stock_transaction_ibfk_2` FOREIGN KEY (`purchase_master_id`) REFERENCES `purchase_master` (`purchase_master_id`) ON UPDATE CASCADE,
  ADD CONSTRAINT `stock_transaction_ibfk_3` FOREIGN KEY (`product_id`) REFERENCES `product` (`product_id`) ON UPDATE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
