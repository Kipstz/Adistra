
CREATE TABLE `characters` (
  `characterId` int(11) NOT NULL AUTO_INCREMENT,
  `identifier` varchar(60) NOT NULL,
  `identity` longtext NOT NULL,
  `skin` longtext NOT NULL,
  `jobs` longtext NOT NULL,
  `accounts` longtext NOT NULL,
  `inventory` longtext NOT NULL,
  `loadout` longtext NOT NULL,
  `position` varchar(255) NOT NULL,
  `status` longtext NOT NULL,
  `phone_number` varchar(10) NOT NULL,

  PRIMARY KEY (`characterId`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;