
CREATE TABLE IF NOT EXISTS `items` (
  `name` varchar(50) NOT NULL,
  `label` varchar(50) NOT NULL,
  `weight` int(11) NOT NULL DEFAULT 1,
  `can_remove` tinyint(4) NOT NULL DEFAULT 1,

  PRIMARY KEY (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

INSERT INTO `items` (`name`, `label`, `weight`, `can_remove`) VALUES
  ('bread', 'Pain', 0.1, 1),
  ('water', 'Eau', 0.1, 1),
;

CREATE TABLE IF NOT EXISTS `jobs` (
  `name` varchar(50) NOT NULL,
  `label` varchar(50) DEFAULT NULL,

  PRIMARY KEY (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

INSERT INTO `jobs` (`name`, `label`) VALUES
  ('unemployed', 'Unemployed')
;

CREATE TABLE IF NOT EXISTS `job_grades` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `job_name` varchar(50) DEFAULT NULL,
  `grade` int(11) NOT NULL,
  `name` varchar(50) NOT NULL,
  `label` varchar(50) NOT NULL,

  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

INSERT INTO `job_grades` (`job_name`, `grade`, `name`, `label`) VALUES
  ('unemployed', 0, 'unemployed', 'Unemployed')
;

CREATE TABLE IF NOT EXISTS `jobs2` (
  `name` varchar(50) NOT NULL,
  `label` varchar(50) DEFAULT NULL,

  PRIMARY KEY (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

INSERT INTO `jobs2` (`name`, `label`) VALUES
  ('unemployed2', 'Unemployed2')
;

CREATE TABLE IF NOT EXISTS `job2_grades` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `job2_name` varchar(50) DEFAULT NULL,
  `grade` int(11) NOT NULL,
  `name` varchar(50) NOT NULL,
  `label` varchar(50) NOT NULL,

  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

INSERT INTO `job2_grades` (`job2_name`, `grade`, `name`, `label`) VALUES
  ('unemployed2', 0, 'unemployed2', 'Unemployed2')
;

CREATE TABLE IF NOT EXISTS `societes` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(50) NOT NULL,
  `label` varchar(50) NOT NULL,
  `data` longtext DEFAULT NULL,

  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;

INSERT INTO `societes` (`name`, `label`, `data`) VALUES
  ('gouvernement', 'Gouvernement', '{\"weapons\":[],\"accounts\":{\"money\":0},\"items\":{}}'),
  ('ambulance', 'Ambulance', '{\"weapons\":[],\"accounts\":{\"money\":37000},\"items\":[]}'),
  ('police', 'Police', '{\"weapons\":[],\"accounts\":{\"money\":14299345},\"items\":[]}'),
  ('bcso', 'BCSO', '{\"weapons\":{\"WEAPON_SWITCHBLADE\":{\"count\":1,\"components\":[],\"label\":\"Couteau à cran d\'arrêt\",\"ammo\":250,\"name\":\"WEAPON_SWITCHBLADE\"},\"WEAPON_KNIFE\":{\"tintIndex\":0,\"count\":1,\"components\":[],\"label\":\"Couteau\",\"ammo\":250,\"name\":\"WEAPON_KNIFE\"},\"WEAPON_STUNGUN\":{\"tintIndex\":0,\"count\":1,\"components\":[],\"label\":\"Tazer\",\"ammo\":255,\"name\":\"WEAPON_STUNGUN\"}},\"accounts\":{\"money\":115173},\"items\":{\"opium\":{\"label\":\"Opium\",\"name\":\"opium\",\"count\":22},\"weed_pooch\":{\"label\":\"Pochon de weed\",\"name\":\"weed_pooch\",\"count\":15},\"coke_pooch\":{\"label\":\"Pochon de coke\",\"name\":\"coke_pooch\",\"count\":184}}}'),
  ('mecano', 'Mecano', '{\"weapons\":[],\"accounts\":{\"money\":19073127},\"items\":{\"champ\":{\"label\":\"Bouteille de champagne\",\"name\":\"champ\",\"count\":10},\"blowpipe\":{\"label\":\"Chalumeaux\",\"name\":\"blowpipe\",\"count\":45},\"carotool\":{\"label\":\"Outils carosserie\",\"name\":\"carotool\",\"count\":4},\"carokit\":{\"label\":\"Kit carosserie\",\"name\":\"carokit\",\"count\":30},\"gazbottle\":{\"label\":\"Bouteille de gaz\",\"name\":\"gazbottle\",\"count\":18}}}'),
  ('bahama', 'Bahama', '{\"weapons\":[],\"accounts\":{\"money\":2465511},\"items\":[]}'),
  ('unicorn', 'Unicorn', '{\"weapons\":[],\"accounts\":{\"money\":0},\"items\":[]}'),
  ('taxi', 'Taxi', '{\"weapons\":[],\"accounts\":{\"money\":100000},\"items\":[]}'),
  ('journalist', 'Weazel-News', '{\"weapons\":[],\"accounts\":{\"money\":900000},\"items\":[]}'),
  ('tabac', 'Tabac', '{\"weapons\":{\"WEAPON_PETROLCAN\":{\"tintIndex\":0,\"count\":1,\"components\":[],\"label\":\"Jerrican d\'essence\",\"ammo\":255,\"name\":\"WEAPON_PETROLCAN\"}},\"accounts\":{\"money\":296903},\"items\":[]}'),
  ('vigneron', 'Vigneron', '{\"weapons\":[],\"accounts\":{\"money\":530300},\"items\":{\"champ\":{\"label\":\"Bouteille de champagne\",\"name\":\"champ\",\"count\":4182},\"glacon\":{\"label\":\"Glaçon\",\"name\":\"glacon\",\"count\":50}}}'),
  ('agentimmo', 'Agence-Immobiliere', '{\"weapons\":[],\"accounts\":{\"money\":-79608188},\"items\":[]}')
;

CREATE TABLE IF NOT EXISTS `licenses` (
  `type` varchar(60) NOT NULL,
  `label` varchar(60) NOT NULL,

  PRIMARY KEY (`type`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;

INSERT INTO `licenses` (`type`, `label`) VALUES
  ('dmv', 'Code de la route'),
  ('drive', 'Permis de conduire'),
  ('drive_bike', 'Permis moto'),
  ('drive_truck', 'Permis camion'),
  ('weapon', 'PPA')
;

CREATE TABLE `properties` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `params` longtext DEFAULT '[]',
  `points` longtext DEFAULT '[]',

  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;

CREATE TABLE IF NOT EXISTS `users` (
  `uniqueId` int(11) NOT NULL AUTO_INCREMENT,
  `identifier` varchar(60) NOT NULL,
  `name` varchar(80) DEFAULT NULL,
  `group` varchar(50) DEFAULT 'user',
  `coins` int(11) NOT NULL,

  PRIMARY KEY (`uniqueId`),
  UNIQUE KEY `identifier` (`identifier`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS `characters` (
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

CREATE TABLE IF NOT EXISTS `character_accessories` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `characterId` int(11) NOT NULL,
  `cat` varchar(10) NOT NULL,
  `key` int(11) NOT NULL,
  `val` int(11) NOT NULL,
  `name` varchar(30) NOT NULL,

  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

CREATE TABLE IF NOT EXISTS `character_outfits` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `characterId` int(11) NOT NULL,
  `outfit` longtext NOT NULL,
  `name` varchar(30) NOT NULL,

  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

CREATE TABLE IF NOT EXISTS `character_licenses` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `type` varchar(60) NOT NULL,
  `characterId` int(11) NOT NULL,

  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;

CREATE TABLE IF NOT EXISTS `character_billings` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `characterId` int(11) NOT NULL,
  `sender` varchar(255) NOT NULL,
  `target_type` varchar(50) NOT NULL,
  `target` varchar(255) NOT NULL,
  `label` varchar(255) NOT NULL,
  `amount` int(11) NOT NULL,

  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;

CREATE TABLE `open_car` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `characterId` int(11) DEFAULT NULL,
  `plate` varchar(8) DEFAULT NULL,
  `NB` int(11) DEFAULT 0,

  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;

CREATE TABLE `trunk_inventory` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `plate` varchar(50) NOT NULL,
  `data` longtext NOT NULL DEFAULT '{accounts:{"money":0, "black_money":0},"items":[],"weapons":[]}',
  `owned` int(1) NOT NULL DEFAULT 0,

  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;

CREATE TABLE `character_properties` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `id_propertie` int(11) NOT NULL,
  `name` varchar(255) NOT NULL,
  `price` double NOT NULL,
  `rented` int(11) NOT NULL,
  `characterId` int(11) DEFAULT NULL,
  `data` longtext NOT NULL,

  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;

CREATE TABLE `character_vehicles` (
  `characterId` int(11) DEFAULT NULL,
  `plate` varchar(12) NOT NULL,
  `vehicle` longtext NOT NULL,
  `type` varchar(20) NOT NULL DEFAULT 'car',
  `state` tinyint(1) NOT NULL DEFAULT 0,
  `label` varchar(75) NOT NULL DEFAULT 'Ma voiture',

  PRIMARY KEY (`plate`) 
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;
