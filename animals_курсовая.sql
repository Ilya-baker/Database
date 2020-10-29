DROP DATABASE IF EXISTS `animals`;
CREATE DATABASE IF NOT EXISTS `animals` DEFAULT CHARACTER SET utf8 ;
USE `animals`;

DROP TABLE IF EXISTS `owner`;
CREATE TABLE IF NOT EXISTS `owner` (
  `id` INT(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  `firstname` VARCHAR(255) NOT NULL COMMENT 'имя',
  `lastname` VARCHAR(255) NOT NULL COMMENT 'фамилия',
  `created_at` DATETIME NOT NULL DEFAULT NOW() COMMENT 'дата и время регистрации клиента ',
  `address` VARCHAR(255) NULL DEFAULT NULL COMMENT 'адрес',
  `email` VARCHAR(255) NULL DEFAULT NULL COMMENT 'электронный адрес',
  `phone` BIGINT(11) UNSIGNED NULL DEFAULT NULL COMMENT 'телефон',
  `age` INT(3) UNSIGNED NOT NULL COMMENT 'возраст',
  `comments` VARCHAR(255) NULL DEFAULT NULL COMMENT 'комментарии',
  PRIMARY KEY (`id`),
  INDEX `firstname_lastname_ind` (`firstname` ASC, `lastname` ASC) INVISIBLE)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8
COMMENT = 'Владелец животного ';

DROP TABLE IF EXISTS `animal`;
CREATE TABLE IF NOT EXISTS `animal` (
  `id` INT(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  `owner_id` INT(10) UNSIGNED NOT NULL,
  `name` VARCHAR(255) NOT NULL COMMENT 'кличка животного',
  `kind` VARCHAR(255) NOT NULL COMMENT 'вид',
  `breed` VARCHAR(50) NOT NULL COMMENT 'порода',
  `gender` TINYINT(1) UNSIGNED NOT NULL DEFAULT 0 COMMENT 'пол: 0 - жен, 1 - муж, 2 - гермоф ',
  `birthday` DATE NOT NULL COMMENT 'дата рождения',
  `castration` TINYINT(1) UNSIGNED NOT NULL DEFAULT 0 COMMENT 'кастрация: 0 - нет, 1 - да',
  `created_at` DATETIME NOT NULL DEFAULT NOW() COMMENT 'дата и время регистрации питомца',
  `contract_num` INT(10) UNSIGNED NOT NULL COMMENT 'номер договора: на каждого отдельного питомца заводится договор обслуживания с индивидуальным номером ',
  `end` DATE NULL DEFAULT NULL COMMENT 'дата смерти',
  `comments` VARCHAR(255) NULL DEFAULT NULL COMMENT 'комментарии',
  PRIMARY KEY (`id`),
  INDEX `owner_idx` (`owner_id` ASC) VISIBLE,
  UNIQUE INDEX `contract_num_UNIQUE` (`contract_num` ASC) VISIBLE,
  CONSTRAINT `fk_animal_owner`
    FOREIGN KEY (`owner_id`)
    REFERENCES `animals`.`owner` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8
COMMENT = 'животное';

DROP TABLE IF EXISTS `therapy`;
CREATE TABLE IF NOT EXISTS `therapy` (
  `id` INT(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  `animal_id` INT(10) UNSIGNED NOT NULL,
  `created_at` DATETIME DEFAULT NOW() COMMENT 'дата обращения',
  `diagnosis` VARCHAR(255) NOT NULL COMMENT 'диагноз',
  `anamnesis` TEXT NULL DEFAULT NULL COMMENT 'данные о самочувствии  животного за последнее время ',
  `inspection` TEXT NULL DEFAULT NULL COMMENT 'результат осмотра ',
  `manipulation` TEXT NULL DEFAULT NULL COMMENT 'выполненные манипуляции',
  `treatment` TEXT NULL DEFAULT NULL COMMENT 'назначенное лечение ',
  `comments` VARCHAR(255) NULL DEFAULT NULL COMMENT 'комментарии',
  PRIMARY KEY (`id`),
  INDEX `animal_idx` (`animal_id` ASC) VISIBLE,
  CONSTRAINT `fk_therapy_animal`
    FOREIGN KEY (`animal_id`)
    REFERENCES `animals`.`animal` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8
COMMENT = 'терапевтический приём';

DROP TABLE IF EXISTS `surgery`;
CREATE TABLE IF NOT EXISTS `surgery` (
  `id` INT(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  `animal_id` INT(10) UNSIGNED NOT NULL,
  `name` VARCHAR(255) NOT NULL COMMENT 'название операции ',
  `anamnesis` TEXT DEFAULT NULL COMMENT 'данные о самочувсивии животного за последнее время ',
  `work` TEXT DEFAULT NULL COMMENT 'описание проведённой операции ',
  `treatment` TEXT DEFAULT NULL COMMENT 'назначение послеоперационного лечения ',
  `created_at` DATETIME NOT NULL DEFAULT NOW() COMMENT 'дата и время проведения операции ',
  `comments` VARCHAR(255) NULL DEFAULT NULL COMMENT 'комментарии',
  PRIMARY KEY (`id`),
  INDEX `animal_idx` (`animal_id` ASC) VISIBLE,
  CONSTRAINT `fk_surgery_animal`
    FOREIGN KEY (`animal_id`)
    REFERENCES `animals`.`animal` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8
COMMENT = 'хирургия';

DROP TABLE IF EXISTS `research`;
CREATE TABLE IF NOT EXISTS `research` (
  `id` INT(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  `animal_id` INT(10) UNSIGNED NOT NULL,
  `therapy_id` INT(10) UNSIGNED NOT NULL,
  `surgery_id` INT(10) UNSIGNED NOT NULL,
  PRIMARY KEY (`id`),
  INDEX `animal_idx` (`animal_id` ASC) VISIBLE,
  INDEX `therapy_idx` (`therapy_id` ASC) VISIBLE,
  INDEX `surgery_idx` (`surgery_id` ASC) VISIBLE,
  CONSTRAINT `fk_research_animal`
    FOREIGN KEY (`animal_id`)
    REFERENCES `animals`.`animal` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_research_therapy`
    FOREIGN KEY (`therapy_id`)
    REFERENCES `animals`.`therapy` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_research_surgery`
    FOREIGN KEY (`surgery_id`)
    REFERENCES `animals`.`surgery` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8
COMMENT = 'методы специальной и лабораторной диагностики ';

DROP TABLE IF EXISTS `ultrasound`;
CREATE TABLE IF NOT EXISTS `ultrasound` (
  `id` INT(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  `research_id` INT(10) UNSIGNED NOT NULL,
  `name` VARCHAR(255) NOT NULL COMMENT 'область исследования',
  `description` TEXT NOT NULL COMMENT 'описание увиденной картины на момент уз-исследования ',
  `result` TEXT NOT NULL COMMENT 'заключение по уз-исследованию ',
  `created_at` DATETIME NOT NULL DEFAULT NOW() COMMENT 'дата и время проведения уз-исследования',
  `comments` VARCHAR(255) NULL DEFAULT NULL COMMENT 'комментарии',
  PRIMARY KEY (`id`),
  INDEX `research_idx` (`research_id` ASC) VISIBLE,
  CONSTRAINT `fk_ultrasound_research`
    FOREIGN KEY (`research_id`)
    REFERENCES `animals`.`research` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8
COMMENT = 'узи';

DROP TABLE IF EXISTS `x-ray`;
CREATE TABLE IF NOT EXISTS `x-ray` (
  `id` INT(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  `research_id` INT(10) UNSIGNED NOT NULL,
  `name` VARCHAR(255) NOT NULL COMMENT 'область исследования',
  `description` TEXT NOT NULL COMMENT 'описание рентгеновского снимка ',
  `result` TEXT NOT NULL COMMENT 'заключение по рентгеновскому снимку',
  `created_at` DATETIME NOT NULL DEFAULT NOW() COMMENT 'дата и время рентгеновского снимка',
  `comments` VARCHAR(255) NULL DEFAULT NULL COMMENT 'комментарии',
  PRIMARY KEY (`id`),
  INDEX `research_idx` (`research_id` ASC) VISIBLE,
  CONSTRAINT `fk_x-ray_research`
    FOREIGN KEY (`research_id`)
    REFERENCES `animals`.`research` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8
COMMENT = 'рентген ';

DROP TABLE IF EXISTS `blood`;
CREATE TABLE IF NOT EXISTS `blood` (
  `id` INT(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  `research_id` INT(10) UNSIGNED NOT NULL,
  `name` VARCHAR(255) NOT NULL COMMENT 'название анализа крови',
  `result` TEXT NOT NULL COMMENT 'результаты исследования крови',
  `created_at` DATETIME NOT NULL DEFAULT NOW() COMMENT 'дата и время проведения анализов крови',
  `comments` VARCHAR(255) NULL DEFAULT NULL COMMENT 'комментарии',
  PRIMARY KEY (`id`),
  INDEX `research_idx` (`research_id` ASC) VISIBLE,
  CONSTRAINT `fk_blood_research`
    FOREIGN KEY (`research_id`)
    REFERENCES `animals`.`research` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8
COMMENT = 'общий и биохимический анализ крови ';

DROP TABLE IF EXISTS `microscopy`;
CREATE TABLE IF NOT EXISTS `microscopy` (
  `id` INT(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  `research_id` INT(10) UNSIGNED NOT NULL,
  `name` VARCHAR(255) NOT NULL COMMENT 'Наименование микроскопического исследования',
  `result` TEXT NOT NULL COMMENT 'заключение по микроскопическому исследованию ',
  `created_at` DATETIME NOT NULL DEFAULT NOW() COMMENT 'дата и время проведения микроскопии',
  `comments` VARCHAR(255) NULL DEFAULT NULL COMMENT 'комментарии',
  PRIMARY KEY (`id`),
  INDEX `research_idx` (`research_id` ASC) VISIBLE,
  CONSTRAINT `fk_microscopy_research`
    FOREIGN KEY (`research_id`)
    REFERENCES `animals`.`research` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8
COMMENT = 'микроскопическое исследование соскобов';

DROP TABLE IF EXISTS `hospital`;
CREATE TABLE IF NOT EXISTS `hospital` (
  `id` INT(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  `animal_id` INT(10) UNSIGNED NOT NULL,
  `therapy_id` INT(10) UNSIGNED NOT NULL,
  `surgery_id` INT(10) UNSIGNED NOT NULL,
  PRIMARY KEY (`id`),
  INDEX `animal_idx` (`animal_id` ASC) VISIBLE,
  INDEX `therapy_idx` (`therapy_id` ASC) VISIBLE,
  INDEX `surgery_idx` (`surgery_id` ASC) VISIBLE,
  CONSTRAINT `fk_hospital_animal`
    FOREIGN KEY (`animal_id`)
    REFERENCES `animals`.`animal` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_hospital_therapy`
    FOREIGN KEY (`therapy_id`)
    REFERENCES `animals`.`therapy` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_hospital_surgery`
    FOREIGN KEY (`surgery_id`)
    REFERENCES `animals`.`surgery` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8
COMMENT = 'стационар';

DROP TABLE IF EXISTS `zoo_hotel`;
CREATE TABLE IF NOT EXISTS `zoo_hotel` (
  `id` INT(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  `hospital_id` INT(10) UNSIGNED NOT NULL,
  `created_at` DATETIME NOT NULL DEFAULT NOW() COMMENT 'дата и веремя помещения в зоогостиницу ',
  `description` TEXT NULL DEFAULT NULL COMMENT 'описание стационарного содержиния ',
  `comments` VARCHAR(255) NULL DEFAULT NULL COMMENT 'комментарии',
  PRIMARY KEY (`id`),
  INDEX `hospital_idx` (`hospital_id` ASC) VISIBLE,
  CONSTRAINT `fk_zoo_hotel_hospital`
    FOREIGN KEY (`hospital_id`)
    REFERENCES `animals`.`hospital` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8
COMMENT = 'зоогостиница, процедурный стационар ';

DROP TABLE IF EXISTS `infectious_ hospital`;
CREATE TABLE IF NOT EXISTS `infectious_ hospital` (
  `id` INT(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  `hospital_id` INT(10) UNSIGNED NOT NULL,
  `created_at` DATETIME NOT NULL DEFAULT NOW() COMMENT 'дата и время помещения на инфекционный стационар \n',
  `health` TEXT NOT NULL COMMENT 'описание самочувствия питомца ',
  ` manipulation` TEXT NULL DEFAULT NULL COMMENT 'описание проведённых процедур ',
  `comments` VARCHAR(255) NULL DEFAULT NULL COMMENT 'комментарии',
  PRIMARY KEY (`id`),
  INDEX `hospital_idx` (`hospital_id` ASC) VISIBLE,
  CONSTRAINT `fk_infectious_ hospital_hospital`
    FOREIGN KEY (`hospital_id`)
    REFERENCES `animals`.`hospital` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8
COMMENT = 'инфекционный стационар';

DROP TABLE IF EXISTS `postoperative_hospital`;
CREATE TABLE IF NOT EXISTS `postoperative_hospital` (
  `id` INT(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  `hospital_id` INT(10) UNSIGNED NOT NULL,
  `health` TEXT NOT NULL COMMENT 'данные о самочувствии питомца \n',
  `created_at` DATETIME NOT NULL DEFAULT NOW() COMMENT 'дата и время помещения на послеоперационный стационар ',
  `manipulation` TEXT NULL DEFAULT NULL COMMENT 'описание проведённых процедур ',
  `comments` VARCHAR(255) NULL DEFAULT NULL COMMENT 'комментарии',
  `postoperative_hospitalcol` VARCHAR(45) NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  INDEX `hospital_idx` (`hospital_id` ASC) VISIBLE,
  CONSTRAINT `fk_postoperative_hospital_hospital`
    FOREIGN KEY (`hospital_id`)
    REFERENCES `animals`.`hospital` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8
COMMENT = 'послеоперационный стационар';

DROP TABLE IF EXISTS `procedures`;
CREATE TABLE IF NOT EXISTS `procedures` (
  `id` INT(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  `animal_id` INT(10) UNSIGNED NOT NULL,
  `therapy_id` INT(10) UNSIGNED NOT NULL,
  `surgery_id` INT(10) UNSIGNED NOT NULL,
  `hospital_id` INT(10) UNSIGNED NOT NULL,
  `name` VARCHAR(45) NOT NULL COMMENT 'название процедуры',
  `description` TEXT NOT NULL COMMENT 'названия манипуляций, препаратов и их дозировки',
  `status` TEXT NOT NULL COMMENT 'описание состояния пациента ',
  `comments` VARCHAR(255) NULL DEFAULT NULL COMMENT 'комментарии',
  PRIMARY KEY (`id`),
  INDEX `animal_idx` (`animal_id` ASC) VISIBLE,
  INDEX `therapy_idx` (`therapy_id` ASC) VISIBLE,
  INDEX `surgery_idx` (`surgery_id` ASC) VISIBLE,
  INDEX `hospital_idx` (`hospital_id` ASC) VISIBLE,
  CONSTRAINT `fk_procedures_animal`
    FOREIGN KEY (`animal_id`)
    REFERENCES `animals`.`animal` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_procedures_therapy`
    FOREIGN KEY (`therapy_id`)
    REFERENCES `animals`.`therapy` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_procedures_surgery`
    FOREIGN KEY (`surgery_id`)
    REFERENCES `animals`.`surgery` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_procedures_hospital`
    FOREIGN KEY (`hospital_id`)
    REFERENCES `animals`.`hospital` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8
COMMENT = 'выполнение процедур по назначению из текущей клиники или из сторонней клиники ';

DROP TABLE IF EXISTS `media_types`;
CREATE TABLE IF NOT EXISTS `media_types` (
  `id` INT(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(255) NOT NULL COMMENT 'название ',
  `created_at` DATETIME NOT NULL DEFAULT NOW() COMMENT 'дата и время создания ',
  PRIMARY KEY (`id`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8
COMMENT = 'типы медиа файла ';

DROP TABLE IF EXISTS `media`;
CREATE TABLE IF NOT EXISTS `media` (
  `id` INT(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  `media_types_id` INT(10) UNSIGNED NOT NULL,
  `therapy_id` INT(10) UNSIGNED NOT NULL,
  `surgery_id` INT(10) UNSIGNED NOT NULL,
  `procedures_id` INT(10) UNSIGNED NOT NULL,
  `hospital_id` INT(10) UNSIGNED NOT NULL,
  `research_id` INT(10) UNSIGNED NOT NULL,
  `blob` BLOB NOT NULL,
  `size` INT(10) UNSIGNED NOT NULL,
  `created_at` DATETIME NOT NULL DEFAULT NOW(),
  `metadata` JSON NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  INDEX `media_types_idx` (`media_types_id` ASC) VISIBLE,
  INDEX `therapy_idx` (`therapy_id` ASC) VISIBLE,
  INDEX `surgery_idx` (`surgery_id` ASC) VISIBLE,
  INDEX `procedures_idx` (`procedures_id` ASC) INVISIBLE,
  INDEX `hospital_idx` (`hospital_id` ASC) INVISIBLE,
  INDEX `research_idx` (`research_id` ASC) VISIBLE,
  CONSTRAINT `fk_media_media_types`
    FOREIGN KEY (`media_types_id`)
    REFERENCES `animals`.`media_types` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_media_therapy`
    FOREIGN KEY (`therapy_id`)
    REFERENCES `animals`.`therapy` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_media_surgery`
    FOREIGN KEY (`surgery_id`)
    REFERENCES `animals`.`surgery` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_media_procedures`
    FOREIGN KEY (`procedures_id`)
    REFERENCES `animals`.`procedures` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_media_hospital`
    FOREIGN KEY (`hospital_id`)
    REFERENCES `animals`.`hospital` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_media_research`
    FOREIGN KEY (`research_id`)
    REFERENCES `animals`.`research` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8
COMMENT = 'медиа файлы';

DROP TABLE IF EXISTS `barber`;
CREATE TABLE IF NOT EXISTS `barber` (
  `id` INT(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  `animal_id` INT(10) UNSIGNED NOT NULL,
  `name` VARCHAR(255) NOT NULL COMMENT 'перечисление выполненных косметических процедур ',
  `created_at` DATETIME NOT NULL DEFAULT NOW() COMMENT 'дата и время проведения косметических процедур ',
  `comments` VARCHAR(255) NULL DEFAULT NULL COMMENT 'комментарии',
  PRIMARY KEY (`id`),
  INDEX `animal_idx` (`animal_id` ASC) VISIBLE,
  CONSTRAINT `fk_barber_animal`
    FOREIGN KEY (`animal_id`)
    REFERENCES `animals`.`animal` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8
COMMENT = 'груминг (стрижка животных)';

INSERT INTO `owner` 
(firstname, lastname, created_at, address, email, phone, age)
VALUES 
('Cristopher', 'Beahan', '2007-09-21 11:08:46', '78424 Buckridge Ridges\nNew Zoeyberg, AR 20812', 'toney.grady@example.org', '79772716526', 71),
('Ericka', 'Graham', '2018-07-25 20:47:55', '87833 Cole Throughway\nVolkmanberg, NH 67799', 'ajenkins@example.com', '79548516486', 23),
('Lukas', 'Eichmann', '2010-09-12 16:52:38', '299 Bartell Square Suite 302\nRockyberg, IA 72389-5030', 'cordell.ebert@example.net', '79771092814', 30),
('Serenity', 'Cummerata', '2006-07-24 21:14:53', '5259 Garnet Heights Apt. 277\nWest Orlofurt, WY 31798', 'mwelch@example.net', '79993401312', 38),
('Maci', 'Hahn', '2012-03-04 19:40:23', '9570 Dagmar Meadows Apt. 861\nO\'Connellburgh, WI 31405', 'tracy18@example.org', '79101937901', 42),
('Helene', 'Hammes', '2013-12-17 05:16:14', '1019 Harrison Crossing\nEffiemouth, VT 59742', 'maggio.kyla@example.net', '79099802340', 41),
('Myra', 'Powlowski', '2020-05-27 02:22:19', '63004 Bogisich Valley Apt. 178\nSouth Eastonberg, WI 56783-7088', 'andrew18@example.com', '79836225326', 47),
('Janice', 'Gleason', '2020-03-22 21:26:06', '279 McLaughlin Ports\nMullerton, WA 16517-1287', 'salma.fahey@example.com', '79764261919', 51),
('Percy', 'Bartoletti', '2006-07-18 01:45:10', '0379 Cayla Center\nMaceyland, FL 38399-6230', 'anastasia81@example.net', '79849514501', 58),
('Margarett', 'Leannon', '2016-01-13 20:04:10', '45026 Griffin Groves Suite 803\nNorth Xaviertown, VA 07349', 'gbuckridge@example.org', '79316669357', 38),
('Maxine', 'Vandervort', '2012-03-11 03:23:17', '616 Kerluke Squares\nPort Harmony, MN 23469-8465', 'princess.skiles@example.com', '79022228829', 34),
('Lulu', 'Roob', '2017-07-25 20:48:30', '6616 Heather Viaduct Apt. 873\nFletaborough, SD 37308-9527', 'isac10@example.com', '79183887183', 31),
('Myra', 'Boyer', '2016-01-26 13:16:18', '038 Gulgowski Center Apt. 444\nNew Myrtis, KY 14655', 'klarson@example.org', '79448352920', 35),
('Chance', 'Johnston', '2010-05-14 05:57:59', '31475 Wilford Throughway\nRupertville, UT 40405', 'o\'keefe.declan@example.net', '79156941799', 22),
('Damion', 'Moen', '2017-04-30 05:16:20', '632 Marlon Oval Apt. 693\nBuckridgeton, MN 04390-1907', 'koss.elva@example.org', '79070715976', 21),
('Jacklyn', 'McKenzie', '2008-05-10 16:04:30', '0804 Keeling Dam\nEast Peyton, KS 21252', 'ebert.tamia@example.com', '79005245088', 60),
('Annamarie', 'Moen', '2006-07-17 11:24:58', '3926 Jessyca View\nWehnermouth, OK 48730', 'cynthia52@example.com', '79896429108', 18),
('Mallory', 'McCullough', '2019-07-16 20:03:28', '1776 Durward Loop\nWest Abdullah, RI 22622-0941', 'wilkinson.jose@example.net', '79025093966', 25),
('Dashawn', 'Rempel', '2015-02-05 11:10:43', '88155 Marquardt Flats\nWest Ellie, WI 26023', 'schaden.donnie@example.net', '79839545824', 48),
('Scotty', 'Kuhn', '2008-08-17 10:47:55', '109 Bergnaum Camp Apt. 756\nTremblaybury, FL 54313-8246', 'beier.marquis@example.com', '79410095051', 45),
('Elissa', 'Wilderman', '2008-12-31 16:18:29', '262 Sanford Spur\nNew Sheldonbury, ID 08352-1466', 'shields.stevie@example.org', '79730616630', 27),
('Pascale', 'Shanahan', '2016-04-11 19:50:43', '415 Reichert Brook Suite 516\nLake Dakota, HI 01836', 'rhea.dicki@example.org', '79454289041', 56),
('Jeromy', 'Reichert', '2008-03-05 02:25:04', '96043 Langosh Drive Apt. 934\nNew Tremainemouth, WA 70058', 'prosacco.shanie@example.org', '79402179439', 20),
('Jorge', 'Marvin', '2019-03-28 03:37:12', '78039 Franecki Lake Apt. 647\nTodmouth, PA 75490', 'kreichel@example.org', '79997248115', 52),
('Tyson', 'Stark', '2014-11-03 20:53:07', '6284 Brando Motorway Apt. 460\nSouth Adam, NM 89198-5287', 'webster33@example.org', '79037340940', 29),
('Eric', 'Sipes', '2016-03-14 08:10:11', '4832 Orpha Plaza\nNew Olgatown, MS 12754', 'uriel13@example.com', '79074846432', 42),
('Anabel', 'Lindgren', '2009-05-18 08:00:07', '85248 Dicki Harbors Suite 221\nNew Felicia, OR 98735-1093', 'swolff@example.org', '79864791948', 25),
('Angelo', 'Nader', '2007-12-24 01:52:25', '3613 Bauch Neck\nEast Evehaven, NH 24687-9970', 'melissa89@example.com', '79732292266', 32),
('Ora', 'Jacobson', '2008-10-21 03:42:58', '0408 Heaney Gardens\nWalterland, DE 49683-9415', 'kiehn.sabrina@example.net', '79670829882', 18),
('Bonita', 'Rice', '2006-10-30 08:54:29', '298 Felipa Squares\nSouth Karen, MS 71144', 'vborer@example.org', '79511058447', 25),
('Ethyl', 'Mante', '2006-01-10 15:43:25', '71963 Kulas Courts\nDachville, AL 45402', 'adeline21@example.org', '79961672386', 69),
('Prudence', 'Rath', '2013-03-17 07:23:31', '600 Romaguera Course Suite 831\nSouth Ilianaton, WA 74379', 'lowell98@example.org', '79701222257', 32),
('Erick', 'Rowe', '2015-07-17 14:20:38', '2281 Skylar Mills Suite 533\nAldaburgh, CT 80819', 'cwilliamson@example.org', '79101685447', 32),
('Ally', 'Bartoletti', '2015-10-29 10:12:09', '104 Kadin Street Suite 885\nWardberg, DE 54342-5576', 'powlowski.filiberto@example.net', '79728885664', 21),
('Linda', 'Krajcik', '2017-10-22 09:23:25', '850 Corwin Rapid Apt. 531\nToymouth, DC 48719-2065', 'vdeckow@example.net', '79758480757', 73),
('Mariano', 'Veum', '2017-01-08 08:39:43', '1024 Ken Fords\nLueilwitzshire, MT 90000-8235', 'zshanahan@example.org', '79404876859', 29),
('Jaron', 'Borer', '2007-08-19 21:26:52', '78100 Therese Plain\nNew Stephanyhaven, NE 19306', 'fidel91@example.net', '79781285365', 62),
('Winston', 'Schaefer', '2010-04-30 12:32:40', '6415 Buford Parkway Suite 898\nKayleeburgh, VA 30093', 'greta37@example.com', '79721419132', 38),
('Joannie', 'Yost', '2014-01-23 23:15:52', '398 Ferry Glen Apt. 592\nNew Katelin, NJ 68135', 'elangworth@example.net', '79492911030', 48),
('Roderick', 'Padberg', '2014-07-25 12:01:45', '36312 Nelson Turnpike Suite 283\nCassidyside, MD 10468', 'hintz.jordyn@example.com', '79158898684', 35),
('Nelson', 'Herman', '2007-01-23 01:42:51', '4640 Jazmin Spur\nPort Rudy, UT 72716-0315', 'rogahn.houston@example.com', '79987210210', 28),
('Katarina', 'Stracke', '2014-12-06 20:09:43', '2008 Edison Fort\nMertzfort, WV 30942', 'westley48@example.com', '79758648298', 24),
('Sandrine', 'Will', '2007-03-14 08:37:38', '690 Jadyn Meadow\nDustymouth, NM 82478', 'shane.pacocha@example.org', '79889766520', 51),
('Michelle', 'Murazik', '2008-12-11 12:08:03', '3719 Steuber Skyway Suite 281\nNorth Jarrett, UT 70864', 'stella83@example.org', '79299129362', 74),
('Jules', 'Schimmel', '2011-10-06 08:44:09', '3193 Roxanne Circle\nKiehnton, IL 48117', 'sophie84@example.net', '79135114736', 71),
('Rylan', 'Gaylord', '2019-12-26 09:46:47', '9990 Jett Highway Apt. 057\nNorth Elda, RI 54661-1318', 'dubuque.zena@example.org', '79963725887', 64),
('Alverta', 'Pagac', '2011-12-07 04:29:56', '19657 Tad Stream\nJuvenalhaven, MT 29026-3335', 'dvolkman@example.net', '79019770439', 55),
('Vivienne', 'Kihn', '2009-05-16 04:22:22', '6347 Thad Stream\nPaigefort, PA 45322', 'lacey.hyatt@example.com', '79572010420', 69),
('Drake', 'McDermott', '2008-05-16 00:37:54', '189 Mason Course\nWest Thurmantown, VT 87939-8961', 'ggrady@example.org', '79753140072', 64),
('Liza', 'Kunze', '2018-12-09 13:39:09', '30749 Cristina Neck\nZariachester, VT 21364-6770', 'nledner@example.net', '79588962580', 55),
('Dallas', 'Carroll', '2010-01-30 09:36:21', '375 Gabriella Plains Apt. 853\nDestinihaven, NH 33001', 'rhoda.jenkins@example.com', '79293745889', 54),
('Adah', 'Durgan', '2020-02-26 00:54:35', '77362 Lance Dam Apt. 877\nRicehaven, WI 95346-0821', 'eliseo34@example.org', '79705945836', 74),
('Mellie', 'Reichert', '2020-06-23 14:00:37', '7301 Zion Branch Suite 750\nSouth Hudson, NV 71903', 'qsipes@example.org', '79940171383', 19),
('Claire', 'Hudson', '2015-01-21 21:54:48', '38158 Issac Prairie Suite 049\nWest Serenityborough, FL 90417-8061', 'keaton74@example.com', '79694971803', 51),
('Jazmyne', 'Turcotte', '2006-07-31 11:59:45', '2037 Miller Wells Apt. 601\nLake Margarettside, RI 80627', 'mpurdy@example.org', '79530035570', 75),
('Jaime', 'Schinner', '2006-04-28 20:47:19', '02577 Michel Glen Suite 484\nNew Edgarville, GA 68068', 'eleanore.goodwin@example.com', '79844499586', 33),
('Jayne', 'Mante', '2007-06-14 04:57:21', '8341 Curt Camp Apt. 828\nMckennabury, MT 71700-1356', 'yundt.etha@example.net', '79172503953', 44),
('Josh', 'Schiller', '2009-07-25 23:11:05', '6583 Frederique Valley\nSibylberg, AL 83021', 'ernest79@example.org', '79850182566', 70),
('Saul', 'Jacobs', '2015-03-23 18:04:10', '1222 VonRueden Radial\nGriffinfurt, MD 90323-2572', 'stanley.sawayn@example.org', '79856172431', 71),
('Casimer', 'Kreiger', '2009-04-15 01:21:34', '0558 O\'Hara Orchard Apt. 407\nNorth Dawn, MI 81918-1264', 'metz.moriah@example.com', '79565394188', 43),
('Joy', 'Kunze', '2008-06-24 17:29:51', '903 Christ Prairie Suite 430\nNorth Leonor, WY 29793-9244', 'zakary.hilpert@example.com', '79744166036', 49),
('Marilou', 'Raynor', '2015-03-14 17:07:37', '592 Aufderhar Branch\nSouth Cheyenneborough, VT 08592-2032', 'wintheiser.selina@example.com', '79290131268', 57),
('Wiley', 'Stokes', '2009-03-27 04:05:39', '0197 Schroeder Islands Suite 106\nRippinchester, MN 51415-8920', 'ethel.o\'conner@example.com', '79670901460', 66),
('Daryl', 'Wunsch', '2013-07-07 13:35:53', '8990 Tanya Trafficway Suite 412\nNorth Quinnland, UT 64154-5840', 'afarrell@example.com', '79989074592', 38),
('Dejuan', 'Jaskolski', '2008-04-28 00:35:51', '11682 Bednar Springs\nNew Will, NJ 72076', 'nelda.wiza@example.net', '79366033121', 27),
('Verna', 'Lehner', '2017-12-18 03:33:33', '46278 Romaguera Plaza\nSouth Joannie, MS 40138-1710', 'lloyd.crooks@example.org', '79415610663', 37),
('Cassie', 'Ullrich', '2018-01-31 09:29:24', '49645 Stiedemann Course\nEmmerichside, CT 84493-4812', 'white.quinn@example.org', '79197467498', 23),
('Javon', 'Schmeler', '2010-06-27 16:57:13', '7374 Gaylord Corner\nWest Evalyn, TN 45722', 'macejkovic.benny@example.org', '79275385374', 43),
('Eldon', 'Schneider', '2011-11-21 11:31:23', '37111 Cummerata River Apt. 703\nVonRuedenfort, AR 80476-4174', 'ford.vonrueden@example.com', '79247652836', 21),
('Janet', 'Morissette', '2012-05-29 08:36:28', '139 Kling Bridge\nBernhardhaven, VT 46061-5715', 'pkoelpin@example.org', '79350258025', 24),
('Sabina', 'Reichel', '2016-10-31 15:52:33', '1016 Gerlach Overpass\nNorth Lavina, MO 06163-8228', 'kailee.farrell@example.com', '79545683725', 34),
('Keaton', 'Denesik', '2008-06-28 01:51:11', '21968 Amira Ville Suite 052\nNew Princess, MN 13503', 'carmella.pacocha@example.com', '79904231897', 72),
('Orion', 'Gottlieb', '2011-05-29 07:39:16', '022 Jett Cliff Apt. 921\nEast Kayleyfort, OH 47107', 'candice40@example.org', '79254489986', 47),
('Minnie', 'Steuber', '2009-08-17 07:17:31', '859 Mariam Court Apt. 149\nEast Arnold, MI 47734', 'alessandra79@example.net', '79267293122', 39),
('Edgardo', 'Pfeffer', '2018-04-25 08:06:55', '47626 Dana Meadows Suite 461\nRitchiemouth, WA 24481-8443', 'mraz.constantin@example.com', '79254712430', 52),
('Heather', 'Altenwerth', '2017-08-30 22:17:58', '233 Ashly Land Apt. 954\nLeannonton, UT 50351-4254', 'haley.maria@example.net', '79159221649', 56),
('Selmer', 'Mosciski', '2016-09-10 07:50:15', '012 Jayson Garden\nCristton, NY 10380-7187', 'nora50@example.com', '79613408442', 67),
('Estel', 'Hintz', '2010-01-24 08:24:58', '65041 Gorczany Oval\nChaneltown, CT 77387', 'ofritsch@example.org', '79943972134', 36),
('Layla', 'Ledner', '2009-11-25 12:21:06', '84758 O\'Keefe Park\nMayerchester, UT 33629', 'houston65@example.org', '79667844557', 39),
('Kasandra', 'Yundt', '2010-05-29 22:54:29', '92440 Volkman Stravenue\nWest Shermanfurt, SD 44484', 'ward.ole@example.com', '79047356656', 73),
('Emilio', 'Mills', '2010-01-12 22:28:51', '842 Bradley Pass\nRunolfssonport, NJ 11108-6857', 'yvette11@example.com', '79028702761', 48),
('Jovan', 'Spencer', '2009-12-31 01:53:17', '89222 Kunde Ridge Apt. 527\nFriedabury, WA 28997', 'dock98@example.org', '79325301837', 62),
('Felix', 'Kuhn', '2013-08-11 04:44:43', '3602 Boyd Villages Apt. 336\nRoderickton, TX 50455', 'daugherty.ludie@example.com', '79779393694', 46),
('Kaylie', 'McCullough', '2007-08-07 08:52:55', '084 Bayer Extensions\nErlingmouth, MI 29892', 'abdul.dickens@example.net', '79371286338', 51),
('Joyce', 'Oberbrunner', '2012-05-14 07:02:46', '650 Melany Dale Apt. 820\nMarisolchester, RI 47567', 'glover.madison@example.net', '79120911479', 59),
('Rory', 'Abshire', '2006-07-20 19:56:46', '9211 Bailey Station Apt. 292\nFeeneyland, MN 99203-2141', 'alfonzo.schaefer@example.net', '79194010300', 30),
('Georgette', 'Connelly', '2010-08-22 08:20:01', '80765 Grady Locks\nWademouth, KS 67568-5516', 'cheyanne.koss@example.net', '79585759728', 39),
('Onie', 'Reynolds', '2016-11-11 22:55:47', '5091 Casper Villages Suite 390\nDeckowview, MD 11358-8154', 'monserrat.ferry@example.net', '79395667578', 65),
('Allison', 'Graham', '2015-12-08 13:21:56', '30738 Grant Ports\nSouth Pierce, IN 18190', 'romaguera.aric@example.com', '79023372857', 34),
('Jettie', 'Wilderman', '2006-05-03 06:05:37', '010 Medhurst Grove\nLake Gertrude, LA 87548-1831', 'carroll68@example.com', '79499484946', 47),
('Blaze', 'Jaskolski', '2006-08-30 13:11:17', '49310 Larry Trafficway\nWest Tomasahaven, PA 60062-6416', 'monahan.ola@example.com', '79646841807', 57),
('Kaela', 'Gulgowski', '2014-02-19 20:25:02', '0591 Denesik Hills Suite 018\nKohlerhaven, NY 98848', 'newell.ankunding@example.com', '79621518560', 50),
('Ethel', 'Rowe', '2009-12-22 19:08:20', '392 Schiller Lodge\nEast Dorothy, FL 02037', 'gthompson@example.org', '79141104359', 29),
('Mckenna', 'Gleason', '2018-12-25 17:15:28', '2509 Sigmund Rest Apt. 564\nBoehmport, AL 17410', 'franecki.myrtle@example.net', '79960078215', 32),
('Darius', 'Lind', '2017-05-05 08:35:31', '7009 Danika Loop Apt. 881\nBayerland, DC 05317-5380', 'vsenger@example.com', '79222117885', 35),
('Eloy', 'Hickle', '2009-12-09 23:51:07', '7132 Heller Garden Apt. 300\nBlandaview, FL 43113', 'mallory61@example.com', '79609779324', 75),
('Percival', 'Bailey', '2013-04-18 12:35:28', '68970 Caroline Way\nNew Hilbert, AR 42670-2544', 'xkunde@example.net', '79495154630', 42),
('Myrna', 'Senger', '2013-10-23 00:12:23', '84468 Virginie Street Suite 291\nZoietown, TN 51567-4143', 'derick.kling@example.org', '79375062046', 37),
('Myrtie', 'Littel', '2008-10-15 15:54:52', '44493 Derek Street\nOpheliahaven, DE 44784', 'abagail08@example.com', '79334562540', 49),
('Kaleta', 'Galgawski', '2012-02-24 21:25:02', '0591 Denesik Hills Suite 114\nKohlerhaven, NY 98848', 'kaleta.galgawski@example.com', '79621518460', 38);

INSERT INTO `animal` 
(owner_id, name, kind, breed, gender, birthday, castration, created_at, contract_num)
VALUES 
('39','Ivory','кош','сиамская ','0','1970-12-08','0','2020-01-12 13:51:34','132547'),
('22','Charity','кош','сфинкс','0','1985-03-11','1','2017-11-18 20:45:57','179809'),
('42','Piper','кош','сиамская ','0','1995-06-10','0','2017-06-04 11:42:05','271709'),
('63','Desiree','кош','метис','0','1982-07-12','0','2014-04-24 21:51:45','197987'),
('2','Kenya','кош','тайская','0','1987-11-16','1','2010-10-21 17:54:41','182167'),
('82','Jacky','кош','тайская','0','1991-08-05','1','2018-03-21 23:05:22','244014'),
('64','Vernice','кош','сфинкс','0','1998-11-03','1','2017-09-26 08:06:16','126625'),
('46','Oma','кош','тайская','0','1992-07-09','0','2014-07-14 10:11:18','121253'),
('90','Nora','кош','сиамская ','0','1974-12-13','1','2014-09-25 06:01:09','174951'),
('61','Jazmyne','кош','сиамская ','0','1991-01-26','1','2012-02-07 08:42:00','175956'),
('31','Christiana','кош','британская','0','1998-08-08','1','2015-09-08 05:32:44','164194'),
('1','Dakota','кош','сфинкс','0','1985-09-05','1','2013-08-27 07:36:54','228980'),
('59','Rosie','кош','сфинкс','0','1980-01-24','1','2013-01-12 06:10:46','141692'),
('59','Mathilde','кош','метис','0','1991-05-24','1','2020-03-29 21:33:30','128136'),
('42','Lorine','кош','британская','0','1988-06-15','0','2014-02-18 15:52:20','156466'),
('73','Antonina','кош','сибирская','0','1976-06-23','0','2011-05-22 18:21:47','252170'),
('20','Jena','кош','сиамская ','0','1985-04-29','1','2014-05-07 22:14:07','287694'),
('78','Dorothea','кош','сибирская','2','1977-11-08','1','2011-02-27 09:09:00','225543'),
('4','Shayna','кош','сиамская ','0','1981-05-02','0','2015-06-25 17:35:54','115588'),
('90','Keely','кош','сиамская ','0','1981-03-19','0','2011-10-07 12:57:51','204240'),
('95','Deborah','кош','британская','0','1993-06-08','0','2012-08-03 21:50:58','248038'),
('4','Emelia','кош','тайская','0','1987-09-13','1','2012-05-28 14:36:33','298468'),
('79','Juliana','кош','сиамская ','0','1990-05-03','0','2018-11-28 00:51:48','168482'),
('37','Mikayla','кош','сиамская ','0','1971-12-17','0','2014-04-13 01:35:46','231163'),
('36','Kaelyn','кош','британская','0','1975-02-17','0','2017-12-27 03:37:28','125168'),
('1','Ova','кош','тайская','0','1995-03-20','0','2015-10-13 14:04:49','159125'),
('22','Addison','кош','сиамская ','0','1974-08-24','1','2011-07-11 20:41:35','254792'),
('82','Kaelyn','кош','сибирская','0','1979-09-08','0','2010-12-03 13:00:35','196467'),
('39','Myah','кош','сфинкс','0','1987-07-13','1','2018-09-19 07:09:04','199050'),
('34','Felipa','кош','метис','0','1983-07-31','1','2018-11-27 17:05:57','218947'),
('77','Liliane','кош','сфинкс','0','1980-10-01','0','2017-03-25 16:27:53','232911'),
('15','Gracie','кош','сиамская ','0','1986-06-12','1','2015-03-20 22:02:36','180524'),
('42','Myrna','кош','сибирская','0','1988-11-21','0','2017-12-27 21:27:24','253327'),
('84','Elva','кош','сфинкс','0','1975-02-28','1','2020-05-08 03:43:25','238470'),
('2','Asia','кош','тайская','0','1982-04-28','0','2014-10-06 04:51:54','116352'),
('11','Stacy','кош','сиамская ','0','1986-05-08','0','2016-02-01 00:39:50','244929'),
('77','Araceli','кош','метис','0','1989-04-18','1','2018-04-05 06:57:24','252954'),
('50','Alison','кош','тайская','0','1981-03-20','0','2014-12-21 04:51:59','166769'),
('11','Maida','кош','сибирская','0','1981-10-19','0','2013-11-24 07:30:30','100823'),
('89','Jade','кош','метис','0','1995-01-12','1','2015-02-11 00:04:55','108317'),
('48','Dianna','кош','сибирская','0','1976-04-19','1','2019-08-04 09:03:39','227685'),
('53','Jana','кош','сибирская','0','1971-08-10','0','2015-09-20 06:11:42','278991'),
('71','Prudence','кош','сиамская ','0','1985-08-30','0','2018-11-29 22:00:36','201249'),
('84','Fiona','кош','тайская','0','1976-04-22','0','2014-07-03 14:19:24','114791'),
('38','Amber','кош','сиамская ','0','1971-04-01','1','2020-06-28 15:44:53','252160'),
('60','Vicky','кош','британская','0','1970-01-17','1','2016-01-14 11:36:35','235959'),
('78','Aglae','кош','сибирская','2','1970-03-26','0','2018-12-23 02:38:32','253498'),
('66','Maudie','кош','сфинкс','0','1980-10-04','0','2016-10-18 04:11:57','240858'),
('6','Lyda','кош','британская','0','1984-07-07','0','2020-07-27 05:04:32','156580'),
('24','Betsy','кош','сфинкс','0','1997-06-19','0','2012-08-08 16:20:07','288381'), 
('52','Francisco','кош','сфинкс','1','1982-01-08','1','2020-03-10 08:16:34','496895'),
('94','Bernhard','кош','сфинкс','1','1978-06-27','1','2015-03-24 02:25:08','360588'),
('82','Trey','кош','метис','1','1977-09-13','0','2020-04-07 16:00:55','416653'),
('68','Reymundo','кош','метис','1','1983-04-29','1','2017-10-03 05:57:16','389405'),
('13','Emerson','кош','тайская','1','1996-10-31','0','2016-04-27 06:12:49','443105'),
('77','Randal','кош','сфинкс','1','1978-11-22','0','2016-10-02 15:02:54','486670'),
('80','Madyson','кош','сиамская ','1','1984-09-03','1','2014-08-28 13:03:46','493651'),
('84','Norwood','кош','сибирская','1','1994-12-06','0','2018-10-23 02:32:02','350154'),
('59','Craig','кош','сибирская','1','1995-07-29','1','2019-07-22 09:37:31','494075'),
('49','Wade','кош','сибирская','1','1972-10-21','1','2015-03-30 07:37:22','339474'),
('91','Linwood','кош','сибирская','1','1989-05-19','0','2015-09-12 13:34:09','355562'),
('49','Nathen','кош','сфинкс','1','1979-01-27','1','2016-06-01 03:06:52','363794'),
('28','Willy','кош','тайская','1','1973-11-23','0','2016-03-29 23:12:30','438198'),
('9','Sheldon','кош','британская','1','1979-10-19','0','2016-01-13 07:04:16','311798'),
('38','Brock','кош','британская','1','1973-05-20','1','2013-05-16 11:46:23','323148'),
('84','Rhiannon','кош','сибирская','1','1993-05-26','1','2017-09-30 15:49:20','481354'),
('44','Cornelius','кош','тайская','1','1994-01-21','0','2011-06-30 15:08:05','457905'),
('60','Jaleel','кош','сфинкс','1','1996-09-08','0','2015-09-05 17:25:48','411596'),
('40','Arnoldo','кош','тайская','2','1990-12-08','1','2017-12-06 18:38:17','416718'),
('64','Tyson','кош','сибирская','1','1993-08-10','1','2016-12-31 00:23:12','434392'),
('33','Tremayne','кош','сибирская','1','1994-05-15','0','2018-01-11 19:59:23','483799'),
('92','Jaylon','кош','метис','1','1996-01-18','1','2011-06-28 09:02:28','335869'),
('19','Bailey','кош','тайская','1','1975-07-17','1','2012-07-30 05:29:20','362955'),
('41','Frankie','кош','сфинкс','1','1977-11-12','1','2015-05-31 14:12:46','368986'),
('97','Norval','кош','сибирская','1','1979-05-18','1','2011-10-05 00:16:02','396236'),
('69','Spencer','кош','британская','1','1973-10-04','1','2019-01-10 01:36:12','312003'),
('94','Wellington','кош','метис','1','1979-08-06','0','2018-05-31 23:50:17','382000'),
('40','Aiden','кош','сибирская','1','1998-04-23','1','2018-03-08 16:35:22','471720'),
('38','Leo','кош','сиамская ','1','1971-05-02','0','2020-05-09 07:00:31','434839'),
('45','Marques','кош','сиамская ','1','1983-09-26','0','2016-01-30 21:50:26','330150'),
('29','Johann','кош','тайская','1','1978-06-16','1','2019-08-25 19:26:30','414892'),
('80','Rashad','кош','тайская','1','1981-08-01','0','2016-09-15 15:01:13','425489'),
('28','Jacques','кош','сиамская ','1','1970-03-22','1','2020-05-13 09:06:47','449105'),
('29','Waino','кош','метис','1','1997-09-08','1','2017-10-13 14:14:39','420046'),
('63','Tyrique','кош','метис','1','1986-03-25','0','2017-10-13 22:03:00','402041'),
('70','Everett','кош','сфинкс','1','1991-08-31','1','2014-03-21 10:38:58','411659'),
('50','Green','кош','британская','1','1993-05-09','1','2018-08-16 03:20:06','440187'),
('43','Ryley','кош','сиамская ','1','1975-07-21','0','2012-01-30 17:14:06','331460'),
('17','Kieran','кош','метис','1','1975-01-07','0','2013-09-25 06:47:41','302272'),
('35','Jennings','кош','британская','1','1994-06-05','0','2014-03-18 13:06:11','471897'),
('68','Cedrick','кош','сфинкс','1','1996-09-15','0','2017-09-06 10:28:34','403334'),
('79','Brycen','кош','метис','1','1980-11-21','1','2018-04-12 01:44:56','403013'),
('60','Tristian','кош','тайская','1','1991-01-04','0','2011-10-09 20:33:22','360254'),
('100','Evan','кош','сибирская','1','1993-10-01','1','2011-12-05 23:43:25','472868'),
('53','Coty','кош','британская','1','1985-02-08','1','2012-02-23 23:43:41','384573'),
('57','Alfred','кош','метис','1','1976-03-14','1','2015-11-30 10:59:38','353125'),
('36','Emil','кош','тайская','1','1972-10-07','1','2015-03-05 08:46:28','302284'),
('55','John','кош','британская','1','1989-01-28','1','2018-04-03 00:37:20','479111'),
('5','Isaias','кош','сибирская','1','1990-09-23','1','2011-05-04 22:17:11','337363'),
('12','Sven','кош','сиамская ','1','1975-03-17','0','2012-10-30 20:04:46','329538'),
('35','Kaela','соб','немецкая овчарка','0','1992-04-04','0','2013-08-02 19:11:25','623327'),
('37','Madge','соб','французский бульдог ','0','1995-02-12','0','2015-11-04 11:55:40','672268'),
('92','Vanessa','соб','метис','0','1971-12-27','1','2020-10-07 01:53:34','648609'),
('17','Vada','соб','йорк','0','1975-05-31','1','2015-08-29 08:04:15','575976'),
('43','Burnice','соб','чихуа','0','1990-08-11','1','2017-12-29 14:19:24','598264'),
('43','Bernice','соб','немецкая овчарка','0','1995-11-15','0','2020-05-19 19:06:29','505684'),
('56','Euna','соб','французский бульдог ','0','1971-10-30','0','2018-04-14 15:47:58','690972'),
('90','Yazmin','соб','метис','0','1993-01-17','1','2013-06-06 19:09:54','520961'),
('11','Isabelle','соб','французский бульдог ','0','1988-04-06','0','2013-06-21 23:07:30','589817'),
('6','Ella','соб','немецкая овчарка','0','1996-10-15','0','2014-01-14 13:35:16','691800'),
('100','Bridie','соб','метис','0','1971-12-23','0','2019-02-19 03:38:36','586873'),
('63','Pascale','соб','чихуа','0','1989-06-17','0','2018-08-05 03:47:08','567753'),
('3','Loyce','соб','немецкая овчарка','0','1970-07-14','0','2018-09-18 20:57:32','584390'),
('54','Rosella','соб','французский бульдог ','0','1970-09-06','1','2011-10-03 08:22:24','633431'),
('7','Malika','соб','чихуа','0','1990-06-15','1','2012-10-24 18:18:59','597172'),
('64','Julianne','соб','немецкая овчарка','0','1989-03-28','1','2020-04-16 00:51:48','556695'),
('50','Shanie','соб','французский бульдог ','0','1982-09-27','0','2011-10-24 17:08:32','675809'),
('65','Beth','соб','немецкая овчарка','0','1995-03-01','0','2017-08-31 18:54:07','624478'),
('47','Alana','соб','бигль','0','1996-05-23','0','2019-12-14 22:51:40','561747'),
('78','Charlene','соб','йорк','0','1979-04-24','0','2014-09-23 13:39:27','572570'),
('70','Elissa','соб','далматин','0','1983-01-29','0','2018-04-29 22:05:00','518507'),
('74','Larissa','соб','немецкая овчарка','0','1980-02-18','0','2012-07-18 21:51:51','539651'),
('77','Kara','соб','далматин','0','1996-03-17','0','2013-01-30 20:20:13','570841'),
('8','Rosemarie','соб','далматин','0','1985-07-29','0','2014-01-18 20:06:49','546154'),
('26','Pamela','соб','бигль','2','1993-12-08','1','2015-07-29 18:57:58','639229'),
('77','Isabella','соб','далматин','0','1990-04-25','1','2014-05-09 11:36:08','573613'),
('54','Ada','соб','чихуа','0','1996-08-01','0','2020-09-30 00:58:44','670565'),
('54','Name','соб','бигль','0','1971-10-01','0','2015-06-10 15:04:33','665169'),
('22','Elvera','соб','бигль','0','1976-04-27','0','2019-04-16 16:03:07','678596'),
('79','Flossie','соб','немецкая овчарка','0','1997-09-13','0','2020-09-03 11:49:19','555526'),
('29','Effie','соб','йорк','0','1971-07-07','1','2015-02-26 02:51:21','552630'),
('23','Carolanne','соб','йорк','0','1990-08-08','0','2014-07-17 11:07:28','530427'),
('87','Maye','соб','немецкая овчарка','0','1988-10-19','1','2019-08-02 09:05:42','607302'),
('61','Aiyana','соб','немецкая овчарка','0','1988-05-24','0','2019-01-03 05:45:35','529910'),
('26','Hertha','соб','далматин','0','1979-04-20','0','2017-10-29 22:45:19','556723'),
('26','Maya','соб','далматин','0','1976-10-03','1','2014-08-18 16:17:40','532683'),
('79','Daphnee','соб','далматин','0','1993-02-18','1','2015-03-23 12:25:50','557440'),
('57','Kelli','соб','французский бульдог ','0','1973-03-12','1','2016-12-06 00:21:12','509763'),
('74','Rachael','соб','метис','0','1990-03-22','0','2014-08-03 11:44:30','689514'),
('67','Annabelle','соб','далматин','0','1980-10-12','1','2018-12-16 11:14:57','652256'),
('87','Greta','соб','метис','0','1992-12-31','1','2016-04-05 18:18:10','502092'),
('56','Myrtie','соб','французский бульдог ','0','1976-05-17','1','2016-08-28 02:25:05','636799'),
('11','Lorine','соб','бигль','0','1975-06-03','0','2018-10-08 00:27:07','618497'),
('42','Pearl','соб','немецкая овчарка','0','1996-06-09','1','2010-11-08 18:53:55','660234'),
('65','Sallie','соб','метис','0','1997-08-17','0','2018-12-22 07:15:51','550889'),
('99','Rosetta','соб','метис','0','1971-03-19','0','2018-07-03 15:52:37','536243'),
('99','Elenor','соб','далматин','0','1996-09-29','0','2015-09-30 10:49:01','643091'),
('76','Halie','соб','немецкая овчарка','0','1994-09-01','0','2019-09-14 03:42:21','603190'),
('100','Angie','соб','чихуа','0','1995-08-28','1','2012-11-09 23:58:25','698096'),
('43','Dakota','соб','чихуа','0','1985-06-12','1','2011-11-04 23:24:46','602660'),
('77','Adrain','соб','йорк','1','1975-11-08','0','2011-11-05 05:02:36','825988'),
('95','Osborne','соб','немецкая овчарка','1','1989-03-09','1','2019-05-28 09:34:46','753108'),
('76','Doyle','соб','чихуа','1','1997-07-03','1','2018-08-25 23:37:29','707880'),
('48','Easton','соб','французский бульдог ','1','1975-08-06','0','2011-11-13 04:21:58','887926'),
('37','Jasmin','соб','метис','1','1990-05-01','1','2014-07-01 02:09:27','850868'),
('57','Abner','соб','немецкая овчарка','1','1997-01-27','1','2016-01-20 12:38:02','816782'),
('4','Douglas','соб','бигль','1','1981-08-08','1','2010-11-14 16:34:04','978945'),
('27','Demarcus','соб','йорк','1','1991-10-12','1','2010-10-28 23:38:55','732484'),
('53','Emerson','соб','далматин','1','1991-01-13','1','2012-02-18 08:36:45','701851'),
('61','Zack','соб','немецкая овчарка','1','1993-08-17','1','2015-02-27 17:20:51','801078'),
('90','Abdullah','соб','французский бульдог ','1','1972-04-11','1','2016-08-08 05:14:44','883024'),
('96','Ansel','соб','йорк','1','1979-12-14','1','2018-01-06 18:37:00','982351'),
('18','Izaiah','соб','далматин','1','1973-06-07','1','2016-07-07 12:16:31','948940'),
('87','Elvis','соб','далматин','1','1990-05-21','0','2017-05-17 21:27:57','765628'),
('57','Randal','соб','чихуа','1','1989-10-11','1','2018-07-19 16:22:39','837947'),
('25','Dejuan','соб','бигль','1','1979-07-20','0','2020-08-07 20:03:47','721838'),
('89','Mitchell','соб','метис','1','1985-06-12','0','2017-08-29 06:12:00','795009'),
('76','Sydney','соб','немецкая овчарка','1','1997-11-14','0','2013-12-11 12:54:06','959829'),
('35','Joseph','соб','метис','1','1978-09-15','1','2020-09-21 15:29:14','864175'),
('40','Hugh','соб','чихуа','1','1977-02-13','0','2011-05-27 17:14:54','719779'),
('54','Laverne','соб','метис','1','1980-02-03','1','2016-10-11 17:03:58','923306'),
('65','Irwin','соб','йорк','1','1988-01-11','0','2019-08-26 07:30:44','799315'),
('70','Ken','соб','метис','1','1997-09-15','1','2016-05-25 03:05:53','818747'),
('11','Merl','соб','немецкая овчарка','1','1971-03-26','1','2019-08-24 06:02:03','865570'),
('48','Raheem','соб','французский бульдог ','1','1974-12-15','1','2012-03-07 08:03:33','781427'),
('34','Tristin','соб','чихуа','1','1989-10-10','1','2016-06-15 04:47:01','759022'),
('97','Urban','соб','метис','1','1979-03-03','1','2014-09-04 02:52:23','947809'),
('41','Ellsworth','соб','йорк','1','1973-04-26','0','2013-11-21 18:23:28','818832'),
('68','Nico','соб','чихуа','1','1978-06-26','0','2013-04-09 04:15:23','726394'),
('74','Jonathan','соб','далматин','1','1995-04-19','1','2012-04-08 22:32:38','781110'),
('13','Edgardo','соб','чихуа','1','1972-01-01','0','2011-07-05 20:27:17','737900'),
('62','Cole','соб','йорк','1','1985-02-10','0','2013-03-14 00:53:43','754904'),
('39','Cletus','соб','далматин','1','1971-10-01','1','2014-10-23 09:52:11','965394'),
('14','Karson','соб','немецкая овчарка','1','1981-04-03','0','2011-11-16 16:44:47','825150'),
('76','Harrison','соб','йорк','1','1976-06-27','0','2017-09-08 15:11:12','911392'),
('17','Gabriel','соб','метис','1','1976-12-07','0','2015-03-23 02:16:27','868865'),
('25','Zechariah','соб','йорк','1','1981-03-14','0','2012-04-15 23:34:21','917981'),
('78','Jordon','соб','метис','1','1986-04-26','0','2014-06-23 02:42:26','912580'),
('69','Julien','соб','французский бульдог ','1','1973-09-06','1','2013-02-01 19:55:13','846180'),
('94','Vincent','соб','бигль','2','1985-12-18','1','2016-12-05 15:59:33','890046'),
('46','Clinton','соб','метис','1','1981-04-09','0','2015-08-20 13:21:04','771702'),
('47','Tremayne','соб','французский бульдог ','1','1983-01-21','1','2014-11-22 12:33:21','854733'),
('26','August','соб','метис','1','1990-02-10','1','2019-09-18 17:33:59','951573'),
('93','Chelsey','соб','бигль','1','1990-04-08','1','2018-01-06 04:32:37','757203'),
('60','Nathanial','соб','далматин','1','1990-10-25','0','2017-06-05 22:27:55','982616'),
('28','Peyton','соб','чихуа','2','1986-07-16','1','2015-08-11 14:19:52','708241'),
('16','Rick','соб','далматин','1','1991-08-10','0','2010-11-29 09:58:39','962448'),
('66','Orland','соб','йорк','1','1975-09-28','0','2011-07-23 21:47:45','798141'),
('65','Christian','соб','немецкая овчарка','1','1992-12-16','1','2016-05-08 22:03:42','962870'),
('13','Timmothy','соб','далматин','1','1976-12-20','1','2012-06-03 11:14:46','709278'); 

INSERT INTO `barber` 
(animal_id, name, created_at)
VALUES  
('179','удаление секрета параанальных желёз','2008-02-04 20:00:08'),
('99','вычёсывание колтунов','2019-06-24 18:50:45'),
('61','модельная стрижка','2008-11-14 14:39:46'),
('194','стрижка когтей','2019-09-14 05:53:13'),
('189','удаление секрета параанальных желёз','2016-09-23 19:15:27'),
('5','гигиеническая стрижка','2008-08-03 14:47:12'),
('182','удаление секрета параанальных желёз','2009-01-06 17:01:54'),
('132','вычёсывание колтунов','2018-11-01 21:19:13'),
('27','удаление зубного камня','2012-07-19 19:11:02'),
('144','удаление зубного камня','2017-05-29 17:18:37'),
('78','удаление секрета параанальных желёз','2014-06-16 04:45:00'),
('128','удаление секрета параанальных желёз','2017-12-25 20:21:21'),
('30','стрижка когтей','2011-12-02 01:21:35'),
('17','модельная стрижка','2010-06-10 23:02:08'),
('89','удаление секрета параанальных желёз','2020-08-22 11:31:46'),
('8','гигиеническая стрижка','2020-01-15 04:42:53'),
('111','удаление секрета параанальных желёз','2007-05-30 04:52:40'),
('85','модельная стрижка','2008-09-07 11:31:55'),
('169','модельная стрижка','2014-09-07 06:17:40'),
('138','удаление секрета параанальных желёз','2013-12-29 09:18:33'),
('174','стрижка когтей','2018-11-16 00:36:28'),
('75','удаление зубного камня','2016-04-22 09:06:15'),
('172','гигиеническая стрижка','2020-01-14 20:21:21'),
('82','удаление зубного камня','2010-05-30 19:33:14'),
('106','стрижка когтей','2011-10-07 02:26:06'),
('107','гигиеническая стрижка','2006-02-09 08:34:22'),
('14','вычёсывание колтунов','2010-02-11 22:03:48'),
('105','удаление зубного камня','2013-12-26 19:19:19'),
('52','стрижка когтей','2007-06-04 22:54:34'),
('112','удаление секрета параанальных желёз','2019-12-25 09:41:29'),
('10','модельная стрижка','2010-06-10 18:21:21'),
('155','модельная стрижка','2008-02-06 09:36:40'),
('37','стрижка когтей','2016-05-18 21:17:45'),
('31','вычёсывание колтунов','2012-04-16 21:33:36'),
('83','вычёсывание колтунов','2012-07-06 06:06:09'),
('197','модельная стрижка','2016-06-01 20:35:50'),
('181','модельная стрижка','2010-03-15 01:52:26'),
('176','удаление секрета параанальных желёз','2019-06-30 14:38:01'),
('25','вычёсывание колтунов','2010-09-30 17:43:45'),
('134','удаление зубного камня','2018-08-13 04:43:09'),
('162','гигиеническая стрижка','2016-07-20 11:28:02'),
('147','удаление зубного камня','2014-10-10 22:40:26'),
('36','вычёсывание колтунов','2017-11-20 04:25:10'),
('114','удаление зубного камня','2019-12-30 21:14:17'),
('117','гигиеническая стрижка','2014-02-11 15:14:28'),
('57','удаление секрета параанальных желёз','2014-10-18 18:11:46'),
('193','гигиеническая стрижка','2007-01-22 19:13:01'),
('51','вычёсывание колтунов','2018-04-05 07:02:35'),
('196','стрижка когтей','2018-03-29 17:59:30'),
('177','гигиеническая стрижка','2017-02-03 14:00:55'),
('46','удаление секрета параанальных желёз','2011-02-17 23:26:12'),
('135','удаление секрета параанальных желёз','2018-09-14 14:42:11'),
('133','удаление зубного камня','2008-05-29 23:56:42'),
('74','стрижка когтей','2015-02-19 17:15:48'),
('22','стрижка когтей','2014-11-05 18:56:28'),
('13','стрижка когтей','2009-05-28 10:10:23'),
('168','модельная стрижка','2013-03-20 19:33:20'),
('42','гигиеническая стрижка','2019-03-03 06:36:31'),
('157','удаление зубного камня','2007-01-08 20:17:02'),
('66','вычёсывание колтунов','2016-02-21 22:49:06'),
('92','вычёсывание колтунов','2020-04-25 01:12:13'),
('186','стрижка когтей','2006-07-09 12:36:31'),
('96','вычёсывание колтунов','2012-09-18 00:44:15'),
('20','модельная стрижка','2017-06-04 15:43:20'),
('104','удаление секрета параанальных желёз','2020-04-13 13:55:29'),
('40','удаление секрета параанальных желёз','2011-05-27 18:20:51'),
('11','модельная стрижка','2009-01-28 01:37:34'),
('121','модельная стрижка','2017-11-14 08:16:51'),
('109','гигиеническая стрижка','2009-01-31 15:48:50'),
('76','вычёсывание колтунов','2008-11-05 14:54:37'),
('1','стрижка когтей','2013-11-30 04:28:45'),
('69','гигиеническая стрижка','2012-03-13 20:42:52'),
('143','удаление секрета параанальных желёз','2019-06-17 12:27:59'),
('140','вычёсывание колтунов','2019-02-23 10:44:02'),
('71','стрижка когтей','2019-11-16 07:14:55'),
('148','удаление секрета параанальных желёз','2016-11-29 02:41:20'),
('108','удаление зубного камня','2020-07-19 04:00:57'),
('72','гигиеническая стрижка','2016-01-25 03:13:44'),
('158','гигиеническая стрижка','2006-10-16 13:35:03'),
('55','стрижка когтей','2009-06-25 22:07:44'),
('200','удаление зубного камня','2019-11-25 00:37:09'),
('44','вычёсывание колтунов','2009-09-11 14:46:35'),
('23','модельная стрижка','2009-08-29 07:20:21'),
('100','гигиеническая стрижка','2008-05-19 08:35:33'),
('183','стрижка когтей','2017-02-07 21:00:41'),
('24','удаление секрета параанальных желёз','2008-12-05 21:01:42'),
('87','вычёсывание колтунов','2006-03-16 03:57:00'),
('178','удаление секрета параанальных желёз','2018-02-08 14:07:56'),
('175','удаление секрета параанальных желёз','2011-01-11 03:25:26'),
('90','модельная стрижка','2006-05-30 07:23:11'),
('141','удаление секрета параанальных желёз','2012-12-22 16:41:38'),
('166','удаление секрета параанальных желёз','2010-01-11 08:35:51'),
('35','модельная стрижка','2014-05-13 10:20:33'),
('187','вычёсывание колтунов','2006-02-22 18:09:07'),
('160','удаление секрета параанальных желёз','2019-01-16 02:38:45'),
('29','удаление зубного камня','2016-12-10 08:24:41'),
('161','вычёсывание колтунов','2008-12-19 10:09:55'),
('145','удаление секрета параанальных желёз','2016-06-06 06:56:26'),
('153','удаление секрета параанальных желёз','2017-04-26 05:06:24'),
('2','гигиеническая стрижка','2014-09-25 20:08:11'),
('45','гигиеническая стрижка','2006-01-27 22:30:44'),
('129','стрижка когтей','2017-06-24 22:16:55'),
('80','вычёсывание колтунов','2007-03-11 13:05:15'),
('199','вычёсывание колтунов','2016-08-23 19:51:51'),
('113','удаление секрета параанальных желёз','2020-07-12 01:11:56'),
('63','удаление секрета параанальных желёз','2009-04-01 18:39:22'),
('120','удаление секрета параанальных желёз','2006-12-27 06:49:43'),
('184','стрижка когтей','2008-05-14 11:44:33'),
('81','удаление зубного камня','2018-09-18 20:11:29'),
('79','стрижка когтей','2020-07-13 23:32:03'),
('47','модельная стрижка','2008-05-18 14:43:52'),
('73','гигиеническая стрижка','2017-01-29 23:58:07'),
('164','удаление секрета параанальных желёз','2008-07-28 09:43:41'),
('48','гигиеническая стрижка','2013-06-02 03:24:13'),
('53','вычёсывание колтунов','2013-10-02 13:41:49'),
('39','стрижка когтей','2014-08-13 02:38:40'),
('159','стрижка когтей','2006-01-13 19:16:22'),
('192','модельная стрижка','2018-11-18 01:41:29'),
('77','вычёсывание колтунов','2006-03-22 19:39:51'),
('123','удаление секрета параанальных желёз','2013-10-27 10:50:42'),
('6','вычёсывание колтунов','2012-09-29 14:25:58'),
('125','вычёсывание колтунов','2015-12-04 03:57:46'),
('152','модельная стрижка','2010-08-05 12:42:19'),
('38','вычёсывание колтунов','2016-02-19 22:55:44'),
('16','удаление зубного камня','2014-11-30 23:11:21'),
('180','удаление зубного камня','2012-01-29 03:00:54'),
('118','удаление зубного камня','2011-04-17 02:07:15'),
('130','вычёсывание колтунов','2014-02-01 11:48:03'),
('84','удаление зубного камня','2014-07-24 06:44:45'),
('142','модельная стрижка','2019-06-15 03:46:53'),
('115','удаление зубного камня','2006-09-17 18:40:18'),
('62','гигиеническая стрижка','2006-10-01 02:49:36'),
('50','удаление зубного камня','2006-05-14 23:44:38'),
('34','гигиеническая стрижка','2019-10-31 14:37:13'),
('88','гигиеническая стрижка','2019-06-14 17:58:15'),
('110','удаление зубного камня','2017-06-17 01:56:26'),
('173','модельная стрижка','2010-06-04 18:00:23'),
('64','удаление секрета параанальных желёз','2009-02-16 07:21:03'),
('195','удаление зубного камня','2006-02-21 08:50:57'),
('137','удаление зубного камня','2012-02-21 16:34:12'),
('70','вычёсывание колтунов','2011-11-14 20:31:07'),
('127','стрижка когтей','2011-03-01 02:42:26'),
('170','удаление зубного камня','2013-03-09 05:28:31'),
('191','удаление зубного камня','2005-11-01 20:14:34'),
('58','удаление секрета параанальных желёз','2013-03-15 01:28:44'),
('86','удаление секрета параанальных желёз','2014-07-28 17:45:59'),
('65','вычёсывание колтунов','2012-03-04 23:36:53'),
('60','гигиеническая стрижка','2014-02-12 12:24:26'),
('12','гигиеническая стрижка','2010-03-22 02:31:30'),
('97','вычёсывание колтунов','2008-04-16 03:55:47'),
('154','модельная стрижка','2018-12-16 17:12:50'),
('32','модельная стрижка','2019-01-11 08:21:42'),
('49','модельная стрижка','2008-06-19 13:11:39'),
('67','удаление зубного камня','2017-07-09 15:45:20'),
('93','вычёсывание колтунов','2005-11-26 19:45:54'),
('41','удаление секрета параанальных желёз','2010-11-27 07:26:27'),
('101','гигиеническая стрижка','2012-12-08 11:47:46'),
('21','гигиеническая стрижка','2016-04-29 02:23:38'),
('146','стрижка когтей','2008-06-10 02:08:39'),
('98','гигиеническая стрижка','2010-02-18 03:00:24'),
('33','вычёсывание колтунов','2009-08-03 16:52:11'),
('119','вычёсывание колтунов','2006-08-07 19:44:44'),
('26','удаление секрета параанальных желёз','2019-03-21 06:13:07'),
('94','стрижка когтей','2014-06-25 02:03:47'),
('126','модельная стрижка','2006-08-21 12:17:20'),
('167','удаление зубного камня','2020-01-03 00:21:34'),
('15','модельная стрижка','2017-06-07 03:14:27'),
('7','удаление секрета параанальных желёз','2005-12-16 00:54:37'),
('103','гигиеническая стрижка','2006-09-04 07:20:52'),
('136','удаление зубного камня','2013-01-26 19:32:11'),
('43','удаление зубного камня','2014-01-21 12:54:44'),
('3','удаление секрета параанальных желёз','2017-12-15 23:33:29'),
('9','вычёсывание колтунов','2006-03-30 21:27:33'),
('188','модельная стрижка','2018-04-15 20:50:51'),
('122','удаление секрета параанальных желёз','2007-12-19 04:51:36'),
('18','вычёсывание колтунов','2013-02-22 06:26:14'),
('185','гигиеническая стрижка','2014-09-11 03:53:41'),
('156','гигиеническая стрижка','2007-05-30 11:56:06'),
('150','удаление зубного камня','2014-08-31 23:26:54'),
('171','стрижка когтей','2008-05-06 18:03:26'),
('149','модельная стрижка','2007-08-05 05:16:12'),
('116','гигиеническая стрижка','2009-05-29 18:33:42'),
('131','удаление зубного камня','2010-04-15 16:48:03'),
('190','удаление зубного камня','2016-10-03 15:42:11'),
('124','удаление секрета параанальных желёз','2008-05-23 00:31:34'),
('91','стрижка когтей','2013-12-16 04:43:59'),
('54','модельная стрижка','2015-10-10 22:12:59'),
('68','удаление зубного камня','2013-05-28 22:00:33'),
('151','удаление зубного камня','2011-08-26 04:36:20'),
('95','стрижка когтей','2017-11-21 08:53:48'),
('139','удаление секрета параанальных желёз','2012-03-29 13:09:24'),
('59','модельная стрижка','2017-04-27 07:02:37'),
('102','вычёсывание колтунов','2016-10-08 14:56:06'),
('56','удаление зубного камня','2020-02-26 21:37:44'),
('4','модельная стрижка','2010-05-19 19:55:01'),
('28','гигиеническая стрижка','2020-07-16 01:04:09'),
('165','удаление зубного камня','2007-01-27 23:15:17'),
('198','гигиеническая стрижка','2019-03-08 08:40:46'),
('163','удаление секрета параанальных желёз','2013-06-01 07:18:14'),
('19','модельная стрижка','2006-09-05 14:43:32'); 

INSERT INTO `therapy` 
(animal_id, created_at, diagnosis)
VALUES 
('56','2011-10-28 06:54:01','блошиный дерматит'),
('194','2019-01-12 12:15:13','конъюнктивит'),
('101','2016-10-05 00:27:34','трахеит'),
('178','2012-07-27 23:42:50','гепатопатия'),
('41','2017-01-07 06:24:09','конъюнктивит'),
('199','2013-11-12 16:50:50','инфекция'),
('167','2019-08-22 16:59:10','почечная недостаточность'),
('54','2009-08-18 19:40:25','гастрит'),
('158','2020-04-09 23:40:48','гепатопатия'),
('105','2014-08-19 18:55:39','гастрит'),
('175','2009-07-16 16:02:29','отравление'),
('95','2011-12-25 02:31:24','гепатопатия'),
('45','2010-01-15 03:57:08','энтерит'),
('113','2014-05-10 14:06:20','почечная недостаточность'),
('81','2018-02-20 23:05:36','гастрит'),
('128','2014-06-08 19:11:42','конъюнктивит'),
('86','2010-08-01 15:03:37','отит'),
('76','2015-08-29 13:54:15','трахеит'),
('114','2012-08-09 05:32:36','почечная недостаточность'),
('62','2018-02-21 10:56:27','отравление'),
('164','2019-12-04 19:54:18','отит'),
('131','2008-05-06 11:26:50','почечная недостаточность'),
('64','2006-10-05 04:04:56','блошиный дерматит'),
('47','2006-02-22 21:31:42','дуоденит'),
('26','2015-10-01 11:10:57','инфекция'),
('173','2013-02-13 20:28:05','отит'),
('46','2014-01-25 02:32:55','инфекция'),
('84','2010-03-19 11:09:34','почечная недостаточность'),
('140','2013-07-08 11:31:07','гастрит'),
('147','2013-09-16 03:25:58','инфекция'),
('148','2006-09-28 01:39:59','конъюнктивит'),
('120','2014-03-12 19:59:52','кардиомиопатия'),
('22','2020-07-23 19:56:33','отравление'),
('169','2016-09-28 20:53:43','отит'),
('14','2013-05-06 06:39:30','конъюнктивит'),
('66','2010-11-14 15:57:17','гастрит'),
('9','2010-07-20 01:49:31','отравление'),
('79','2009-09-13 20:58:34','конъюнктивит'),
('23','2009-05-14 01:41:23','дуоденит'),
('154','2005-12-31 01:08:14','блошиный дерматит'),
('109','2006-12-15 17:19:23','энтерит'),
('107','2009-08-18 00:12:25','инфекция'),
('116','2006-07-11 22:14:07','гастрит'),
('16','2012-05-04 10:42:47','трахеит'),
('50','2011-02-09 14:25:47','отит'),
('17','2008-11-12 18:26:37','трахеит'),
('57','2016-07-03 20:49:02','блошиный дерматит'),
('7','2010-01-24 13:49:23','кардиомиопатия'),
('168','2016-09-20 05:38:12','энтерит'),
('134','2008-12-08 06:50:42','трахеит'),
('8','2018-07-25 22:55:06','кардиомиопатия'),
('198','2017-02-20 14:40:54','инфекция'),
('40','2010-05-29 23:14:08','дуоденит'),
('152','2006-03-07 17:25:56','блошиный дерматит'),
('24','2019-11-09 03:42:54','гастрит'),
('72','2012-10-16 06:33:28','инфекция'),
('155','2012-02-06 14:47:08','инфекция'),
('133','2016-05-29 19:06:02','энтерит'),
('139','2011-07-20 23:26:28','блошиный дерматит'),
('49','2006-06-15 11:24:58','инфекция'),
('186','2020-09-04 09:34:29','почечная недостаточность'),
('36','2020-05-18 12:18:44','почечная недостаточность'),
('141','2019-09-11 14:46:12','инфекция'),
('20','2005-11-14 07:10:28','почечная недостаточность'),
('119','2018-12-12 02:39:48','почечная недостаточность'),
('61','2013-01-17 08:03:57','почечная недостаточность'),
('52','2011-01-28 19:43:54','дуоденит'),
('77','2012-05-24 02:24:06','гепатопатия'),
('180','2006-12-22 19:45:44','отравление'),
('108','2015-05-08 19:05:16','отит'),
('5','2007-11-30 11:18:55','гастрит'),
('188','2020-04-30 15:40:13','аллергическая реакция'),
('103','2011-07-11 15:47:42','конъюнктивит'),
('151','2011-10-11 08:58:03','гепатопатия'),
('71','2011-05-15 20:04:53','отит'),
('33','2014-02-25 08:48:41','блошиный дерматит'),
('174','2017-07-28 23:06:22','трахеит'),
('125','2020-10-21 05:25:58','отит'),
('192','2011-06-13 12:53:33','дуоденит'),
('25','2012-10-15 21:22:25','блошиный дерматит'),
('80','2014-11-28 22:33:01','дуоденит'),
('122','2014-04-10 22:35:34','отит'),
('69','2011-05-08 04:11:13','кардиомиопатия'),
('137','2007-09-07 22:08:50','энтерит'),
('10','2017-11-16 18:55:47','отит'),
('55','2013-10-28 21:29:01','гепатопатия'),
('15','2016-11-24 17:09:57','гастрит'),
('153','2016-06-02 02:47:43','энтерит'),
('191','2009-09-12 18:29:26','почечная недостаточность'),
('181','2008-03-30 14:21:12','кардиомиопатия'),
('183','2007-04-16 12:35:43','дуоденит'),
('2','2010-09-14 10:45:36','конъюнктивит'),
('67','2019-11-13 07:15:55','инфекция'),
('78','2017-01-30 13:07:28','отравление'),
('28','2007-10-30 05:36:18','инфекция'),
('92','2015-10-27 12:44:57','блошиный дерматит'),
('170','2008-03-11 23:20:02','трахеит'),
('124','2006-08-15 12:42:55','инфекция'),
('145','2012-10-26 13:02:19','почечная недостаточность'),
('43','2015-03-04 00:51:46','конъюнктивит'),
('195','2009-11-27 19:05:54','энтерит'),
('156','2007-03-18 23:12:22','инфекция'),
('90','2008-08-29 20:24:50','почечная недостаточность'),
('31','2012-06-12 04:49:58','отравление'),
('70','2008-10-27 06:32:17','дуоденит'),
('12','2010-02-13 11:11:14','блошиный дерматит'),
('85','2013-02-11 11:48:36','отравление'),
('129','2011-06-13 03:07:54','гастрит'),
('135','2016-03-22 09:57:26','отит'),
('177','2007-06-01 01:45:05','энтерит'),
('42','2011-01-16 00:24:04','кардиомиопатия'),
('117','2018-01-15 03:19:50','инфекция'),
('127','2007-02-03 16:46:03','блошиный дерматит'),
('93','2016-03-09 07:04:52','отит'),
('179','2008-10-23 21:01:29','конъюнктивит'),
('143','2005-11-26 14:40:40','гепатопатия'),
('190','2015-10-30 00:23:48','почечная недостаточность'),
('110','2016-02-16 10:27:42','отит'),
('106','2006-01-13 20:53:58','отит'),
('29','2015-10-15 19:12:25','гастрит'),
('142','2017-10-08 01:32:56','инфекция'),
('96','2016-02-10 15:55:03','отит'),
('166','2008-02-20 17:09:13','почечная недостаточность'),
('89','2010-04-28 18:18:57','отравление'),
('132','2016-05-28 00:57:57','гепатопатия'),
('126','2007-05-28 23:15:54','отит'),
('162','2008-11-23 09:29:51','конъюнктивит'),
('59','2010-10-21 04:52:05','трахеит'),
('115','2010-06-15 11:20:38','дуоденит'),
('144','2006-06-05 14:01:46','гепатопатия'),
('4','2008-12-14 14:22:31','энтерит'),
('94','2018-03-23 00:44:30','конъюнктивит'),
('63','2016-12-04 19:59:01','гепатопатия'),
('112','2015-01-06 04:13:47','гастрит'),
('163','2019-09-21 04:02:34','почечная недостаточность'),
('32','2006-04-01 09:13:48','гепатопатия'),
('146','2013-05-21 00:54:12','трахеит'),
('34','2005-11-25 03:16:33','гепатопатия'),
('53','2019-08-11 18:17:03','почечная недостаточность'),
('48','2011-01-11 01:56:49','почечная недостаточность'),
('136','2006-03-17 13:50:09','отит'),
('27','2010-11-09 19:26:29','конъюнктивит'),
('121','2017-02-23 04:14:24','трахеит'),
('83','2014-12-11 21:31:55','отит'),
('82','2015-12-09 07:07:38','конъюнктивит'),
('13','2017-03-17 09:15:37','гастрит'),
('123','2009-01-25 00:14:47','трахеит'),
('138','2013-05-17 01:55:28','гастрит'),
('182','2020-03-17 11:02:17','дуоденит'),
('165','2007-09-18 07:16:25','почечная недостаточность'),
('91','2010-06-18 01:25:47','конъюнктивит'),
('184','2009-11-26 15:49:15','гепатопатия'),
('68','2013-09-04 22:12:42','блошиный дерматит'),
('75','2006-03-29 12:41:29','гепатопатия'),
('149','2007-06-23 02:43:36','почечная недостаточность'),
('1','2019-06-08 09:14:00','трахеит'),
('176','2015-10-01 20:15:12','трахеит'),
('87','2017-06-14 05:08:44','блошиный дерматит'),
('51','2014-02-04 22:09:54','гепатопатия'),
('73','2017-04-10 22:10:58','конъюнктивит'),
('58','2013-10-12 23:45:52','гастрит'),
('171','2010-01-10 20:08:46','гастрит'),
('130','2006-06-30 04:04:51','отравление'),
('160','2013-08-08 13:19:07','энтерит'),
('104','2013-08-13 10:31:54','конъюнктивит'),
('118','2018-04-16 11:16:35','дуоденит'),
('21','2019-08-27 05:52:41','отит'),
('157','2013-02-15 06:23:16','гепатопатия'),
('185','2011-01-29 08:26:44','блошиный дерматит'),
('172','2007-01-07 06:42:00','конъюнктивит'),
('97','2015-12-26 01:47:44','конъюнктивит'),
('159','2019-09-22 20:26:52','трахеит'),
('6','2019-12-12 17:29:30','гастрит'),
('44','2007-02-21 15:10:59','аллергическая реакция'),
('30','2015-07-13 22:26:52','кардиомиопатия'),
('98','2020-05-07 12:58:28','почечная недостаточность'),
('35','2013-01-04 19:42:34','гепатопатия'),
('88','2007-12-08 22:30:46','дуоденит'),
('65','2015-05-14 03:47:08','дуоденит'),
('111','2007-11-19 11:10:28','энтерит'),
('11','2018-05-05 06:58:01','трахеит'),
('3','2016-12-20 20:11:02','кардиомиопатия'),
('150','2015-03-15 19:58:49','инфекция'),
('196','2010-07-12 14:32:58','энтерит'),
('99','2018-02-03 22:24:10','гепатопатия'),
('39','2016-02-07 03:02:20','блошиный дерматит'),
('100','2017-06-01 03:38:26','аллергическая реакция'),
('161','2014-05-16 04:03:08','дуоденит'),
('197','2009-07-13 06:41:12','инфекция'),
('74','2006-03-12 13:15:56','блошиный дерматит'),
('193','2011-06-23 17:53:00','инфекция'),
('38','2016-06-02 06:08:17','гепатопатия'),
('102','2012-12-19 07:29:56','почечная недостаточность'),
('18','2016-05-09 01:14:32','почечная недостаточность'),
('37','2016-04-20 16:38:17','дуоденит'),
('187','2008-07-09 23:50:42','дуоденит'),
('189','2014-10-26 20:20:21','отравление'),
('60','2019-07-22 13:29:58','кардиомиопатия'),
('19','2019-01-12 07:43:06','конъюнктивит'),
('200','2009-12-11 11:09:35','гастрит'); 

INSERT INTO `surgery` 
(animal_id, name, created_at)
VALUES  
('144','резекция головки ТБС','2012-12-25 23:34:52'),
('20','ушивание раны','2019-05-12 17:13:28'),
('65','снятие швов','2016-11-15 19:31:40'),
('109','снятие швов','2020-02-25 04:58:52'),
('180','резекция головки ТБС','2012-09-20 15:57:23'),
('200','ушивание раны','2016-05-18 13:54:31'),
('150','удаление моляра','2008-03-01 23:54:35'),
('29','удаление моляра','2012-08-09 22:34:17'),
('80','удаление глаза','2018-05-18 02:14:10'),
('123','резекция головки ТБС','2010-08-20 00:34:56'),
('149','удаление моляра','2008-05-29 11:18:40'),
('64','ушивание раны','2013-12-26 15:13:11'),
('108','удаление моляра','2016-08-20 03:16:45'),
('169','вскрытие абсцесса','2011-01-09 00:51:51'),
('2','мастектомия','2013-01-08 18:14:13'),
('61','санация ротовой полости','2010-10-29 22:49:53'),
('36','снятие швов','2016-07-16 20:42:36'),
('136','удаление моляра','2015-08-30 18:06:46'),
('126','санация ротовой полости','2015-08-03 05:26:16'),
('99','ушивание раны','2007-09-04 19:25:17'),
('32','резекция головки ТБС','2015-04-16 14:57:41'),
('41','удаление слухового прохода','2015-11-13 14:25:31'),
('162','санация ротовой полости','2005-11-14 17:54:06'),
('13','санация ротовой полости','2012-07-16 03:16:10'),
('14','резекция головки ТБС','2010-06-01 22:23:48'),
('165','снятие швов','2009-05-21 11:11:09'),
('90','удаление новообразования','2014-02-27 07:21:26'),
('176','ушивание раны','2011-03-05 18:17:29'),
('55','ушивание раны','2008-12-09 09:01:04'),
('19','ушивание раны','2012-02-11 07:15:13'),
('125','удаление слухового прохода','2012-10-26 02:05:46'),
('10','резекция головки ТБС','2013-10-09 15:04:59'),
('9','снятие швов','2013-02-03 17:55:38'),
('4','удаление клыка','2008-04-04 10:32:32'),
('107','мастектомия','2012-01-21 05:01:05'),
('121','снятие швов','2009-08-02 19:43:08'),
('8','удаление слухового прохода','2009-06-26 04:31:49'),
('128','мастектомия','2009-01-16 11:03:31'),
('113','снятие швов','2018-05-04 13:47:37'),
('59','санация ротовой полости','2015-11-10 00:41:49'),
('92','удаление клыка','2015-03-15 19:08:39'),
('81','резекция головки ТБС','2007-02-27 01:23:53'),
('33','резекция головки ТБС','2018-08-05 00:23:06'),
('116','мастектомия','2017-03-24 07:29:58'),
('79','резекция головки ТБС','2012-03-22 12:49:42'),
('191','снятие швов','2018-07-14 01:49:21'),
('82','санация ротовой полости','2006-01-06 14:29:22'),
('114','пластика век','2013-03-02 14:16:30'),
('170','снятие швов','2020-03-24 16:00:40'),
('22','пластика век','2011-04-03 13:33:36'),
('183','удаление новообразования','2016-04-28 15:22:06'),
('124','ушивание раны','2006-06-01 02:43:09'),
('105','удаление клыка','2008-04-29 23:38:01'),
('46','ушивание раны','2009-02-09 03:29:04'),
('135','удаление новообразования','2008-11-02 12:40:59'),
('164','удаление глаза','2016-12-10 06:23:16'),
('189','удаление моляра','2006-07-03 02:24:20'),
('70','удаление глаза','2007-07-29 15:26:53'),
('60','удаление слухового прохода','2020-05-07 17:08:21'),
('152','удаление глаза','2013-11-25 23:05:14'),
('85','резекция головки ТБС','2010-06-07 20:13:43'),
('44','мастектомия','2006-10-12 20:53:50'),
('199','пластика век','2016-01-11 01:20:37'),
('117','пластика век','2012-11-23 19:29:24'),
('111','вскрытие абсцесса','2006-07-12 14:34:36'),
('94','удаление новообразования','2019-05-26 23:02:57'),
('52','снятие швов','2009-01-12 22:03:02'),
('133','удаление моляра','2014-02-19 12:00:14'),
('112','ушивание раны','2007-02-14 03:15:07'),
('100','ушивание раны','2012-05-19 02:32:46'),
('141','мастектомия','2014-01-16 19:08:58'),
('18','удаление слухового прохода','2013-06-12 00:13:03'),
('102','удаление клыка','2008-12-03 04:33:44'),
('30','удаление глаза','2016-10-05 01:50:03'),
('127','удаление глаза','2014-04-24 14:03:03'),
('35','удаление клыка','2012-05-14 01:19:33'),
('156','удаление глаза','2015-09-14 15:07:39'),
('89','удаление новообразования','2017-05-10 21:35:02'),
('3','удаление слухового прохода','2014-05-22 06:33:52'),
('56','вскрытие абсцесса','2019-07-29 10:58:33'),
('77','мастектомия','2018-07-27 20:04:48'),
('27','удаление новообразования','2012-04-08 10:40:10'),
('129','санация ротовой полости','2016-09-06 15:41:06'),
('23','ушивание раны','2006-12-04 09:12:04'),
('140','удаление глаза','2013-02-03 20:21:12'),
('147','удаление новообразования','2020-10-10 11:52:05'),
('75','ушивание раны','2011-02-12 15:06:20'),
('192','удаление моляра','2016-02-29 21:44:30'),
('168','ушивание раны','2006-12-14 23:43:11'),
('54','мастектомия','2020-10-06 08:48:59'),
('142','удаление клыка','2009-10-20 21:16:23'),
('155','удаление новообразования','2008-02-06 07:23:06'),
('185','удаление клыка','2013-02-08 14:31:08'),
('119','санация ротовой полости','2007-04-19 12:51:38'),
('101','вскрытие абсцесса','2008-11-29 04:32:32'),
('190','удаление новообразования','2009-04-07 15:16:17'),
('73','мастектомия','2016-05-09 15:11:38'),
('53','ушивание раны','2009-01-05 23:45:42'),
('76','резекция головки ТБС','2019-06-24 14:12:58'),
('161','пластика век','2014-02-15 23:09:34'),
('45','удаление слухового прохода','2009-04-04 16:07:46'),
('172','резекция головки ТБС','2011-10-04 03:16:46'),
('31','удаление глаза','2011-07-18 05:32:57'),
('175','мастектомия','2008-08-05 03:43:49'),
('84','вскрытие абсцесса','2008-02-18 02:31:04'),
('137','снятие швов','2007-12-27 07:55:48'),
('196','снятие швов','2018-09-26 07:39:15'),
('179','удаление новообразования','2017-02-11 11:02:44'),
('15','резекция головки ТБС','2019-03-09 14:54:58'),
('48','удаление слухового прохода','2012-01-15 23:50:26'),
('69','удаление новообразования','2014-03-30 08:04:03'),
('12','снятие швов','2012-06-13 06:54:50'),
('16','резекция головки ТБС','2017-10-17 05:52:40'),
('66','пластика век','2006-09-16 10:09:04'),
('17','снятие швов','2014-05-07 15:36:46'),
('58','ушивание раны','2010-05-30 11:42:18'),
('87','вскрытие абсцесса','2009-02-19 04:51:39'),
('91','снятие швов','2013-06-04 15:14:57'),
('49','мастектомия','2012-10-27 23:49:53'),
('88','санация ротовой полости','2020-01-12 11:02:25'),
('11','удаление моляра','2019-09-10 20:56:49'),
('51','пластика век','2020-07-20 05:37:32'),
('184','удаление новообразования','2006-09-21 11:05:56'),
('198','мастектомия','2010-02-21 20:15:08'),
('166','удаление глаза','2019-03-22 17:19:50'),
('178','удаление новообразования','2018-09-23 01:11:27'),
('157','удаление новообразования','2013-02-27 22:00:30'),
('96','санация ротовой полости','2014-01-18 14:43:31'),
('50','снятие швов','2019-12-01 04:03:41'),
('174','удаление моляра','2005-12-23 02:39:35'),
('173','удаление моляра','2013-06-11 20:07:32'),
('182','снятие швов','2014-12-13 14:22:18'),
('95','вскрытие абсцесса','2007-05-14 09:24:07'),
('186','удаление моляра','2015-07-12 16:41:35'),
('148','санация ротовой полости','2009-05-24 17:03:23'),
('151','удаление слухового прохода','2013-04-17 21:04:18'),
('86','удаление моляра','2012-02-07 21:59:39'),
('118','ушивание раны','2006-07-10 18:38:15'),
('167','санация ротовой полости','2010-10-03 12:25:42'),
('74','мастектомия','2009-01-19 10:38:04'),
('163','ушивание раны','2010-12-24 09:49:29'),
('177','удаление глаза','2009-05-21 20:56:08'),
('153','пластика век','2017-11-21 19:51:17'),
('130','резекция головки ТБС','2013-03-03 09:08:37'),
('78','снятие швов','2011-09-19 03:08:08'),
('93','удаление новообразования','2010-11-18 22:24:58'),
('143','удаление моляра','2018-05-13 17:45:36'),
('159','удаление новообразования','2008-12-06 15:40:13'),
('40','пластика век','2020-04-30 00:57:45'),
('145','вскрытие абсцесса','2019-08-10 06:25:32'),
('188','мастектомия','2010-05-15 03:58:33'),
('21','резекция головки ТБС','2017-12-28 10:33:06'),
('193','удаление слухового прохода','2020-08-22 12:50:50'),
('43','удаление моляра','2008-05-24 05:39:59'),
('154','мастектомия','2013-07-31 00:42:19'),
('68','удаление глаза','2020-08-23 23:04:04'),
('57','удаление новообразования','2013-09-06 01:36:35'),
('146','удаление новообразования','2009-11-17 16:16:27'),
('26','ушивание раны','2014-10-04 06:41:33'),
('195','вскрытие абсцесса','2009-11-05 07:09:41'),
('7','вскрытие абсцесса','2012-03-07 23:16:52'),
('71','мастектомия','2011-01-20 11:18:50'),
('197','удаление моляра','2008-11-13 18:06:29'),
('110','ушивание раны','2013-07-15 01:40:10'),
('138','удаление новообразования','2005-12-19 01:48:05'),
('97','удаление моляра','2007-12-24 12:44:45'),
('98','резекция головки ТБС','2017-10-16 05:24:31'),
('194','удаление слухового прохода','2007-05-25 19:05:48'),
('120','снятие швов','2006-08-30 21:59:36'),
('187','снятие швов','2017-02-02 03:27:19'),
('67','резекция головки ТБС','2008-02-23 02:35:53'),
('158','санация ротовой полости','2011-01-30 19:26:42'),
('115','удаление моляра','2019-06-23 00:23:10'),
('34','резекция головки ТБС','2015-09-14 10:59:34'),
('6','резекция головки ТБС','2018-11-27 08:36:41'),
('37','пластика век','2016-11-20 09:03:34'),
('131','вскрытие абсцесса','2015-05-12 01:54:16'),
('5','ушивание раны','2014-07-26 19:57:48'),
('72','удаление клыка','2017-09-29 21:35:11'),
('106','удаление моляра','2010-06-13 09:23:38'),
('122','санация ротовой полости','2013-08-05 10:14:25'),
('28','удаление моляра','2017-09-23 02:01:12'),
('103','удаление слухового прохода','2020-10-10 18:58:51'),
('132','удаление клыка','2014-03-03 21:18:23'),
('24','мастектомия','2006-05-03 13:07:06'),
('25','резекция головки ТБС','2013-04-19 02:44:44'),
('83','удаление глаза','2011-12-31 19:02:02'),
('181','вскрытие абсцесса','2016-12-27 10:25:19'),
('39','пластика век','2010-03-08 05:56:56'),
('63','пластика век','2008-06-01 10:29:08'),
('42','мастектомия','2014-03-29 13:32:22'),
('47','мастектомия','2020-07-28 12:51:42'),
('38','удаление слухового прохода','2006-06-22 16:39:38'),
('134','удаление клыка','2018-08-29 13:31:02'),
('160','мастектомия','2010-05-20 23:00:26'),
('1','удаление клыка','2007-11-18 02:17:24'),
('171','мастектомия','2007-11-21 10:00:14'),
('139','удаление новообразования','2008-10-14 23:21:47'),
('62','удаление клыка','2014-03-06 12:13:02'),
('104','удаление моляра','2015-04-25 11:06:16'); 

-- Показывает кто является владельцем животного по id питомца
USE `animals`;
DROP procedure IF EXISTS `animal_owner`;
DELIMITER $$
USE `animals`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `animal_owner`(animal_num int)
BEGIN
SELECT 
owner.firstname, owner.lastname, animal.id, name, kind, breed  
FROM animal
JOIN  owner ON animal.owner_id = owner.id
WHERE animal.id = animal_num;
END$$
DELIMITER ;

-- Внести в базу нового владельца
USE `animals`;
DROP procedure IF EXISTS `new_owner`;
DELIMITER $$
USE `animals`$$
CREATE PROCEDURE `new_owner` (f VARCHAR(255), l VARCHAR(255), a VARCHAR(255), e VARCHAR(255), p BIGINT(11), age INT(3))
BEGIN
INSERT INTO 
	owner (firstname, lastname, address, email, phone, age)
	VALUE (f, l, a, e, p, age);		
END$$
DELIMITER ;

-- Внести в базу новое животное
USE `animals`;
DROP procedure IF EXISTS `new_animal`;
DELIMITER $$
USE `animals`$$
CREATE PROCEDURE `new_animal` (o INT(10), n VARCHAR(255), k VARCHAR(255), bre VARCHAR(50), g TINYINT(1), bir DATE, cas TINYINT(1), cont INT(10))
BEGIN
INSERT INTO
	animal (owner_id, name, kind, breed, gender, birthday, castration, contract_num)
	VALUE (o, n, k, bre, g, bir, cas, cont);		
END$$
DELIMITER ;

-- Ввести дату смерти животного
USE `animals`;
DROP procedure IF EXISTS `end_animal`;
DELIMITER $$
USE `animals`$$
CREATE PROCEDURE `end_animal` (id_animal INT, end_ DATE)
BEGIN
UPDATE animal SET end = end_ 
WHERE animal.id = id_animal;
END$$
DELIMITER ;

-- Тригер: запрет на регистрацию и заключения договора с несовершеннолетним гражданином
DROP TRIGGER IF EXISTS `animals`.`owner_BEFORE_INSERT`;
DELIMITER $$
USE `animals`$$
CREATE DEFINER=`root`@`localhost` TRIGGER `owner_BEFORE_INSERT` BEFORE INSERT ON `owner` FOR EACH ROW BEGIN
IF NEW.age < 18 THEN
SIGNAL SQLSTATE '47000'
SET MESSAGE_TEXT = 'Запрещена регистрация несовершеннолетнего гражданина';
END IF;
END$$
DELIMITER ;

-- Показать данные всех владельцев с зарегистрированными на них животными и данные этих животных 
CREATE 
    ALGORITHM = UNDEFINED 
    DEFINER = `root`@`localhost` 
    SQL SECURITY DEFINER
VIEW `animals`.`owner_animal_info` AS
    SELECT 
        `animals`.`owner`.`id` AS `id_owner`,
        `animals`.`owner`.`firstname` AS `firstname`,
        `animals`.`owner`.`lastname` AS `lastname`,
        `animals`.`owner`.`created_at` AS `created_at`,
        `animals`.`owner`.`address` AS `address`,
        `animals`.`owner`.`email` AS `email`,
        `animals`.`owner`.`phone` AS `phone`,
        `animals`.`owner`.`age` AS `age_owner`,
        `animals`.`animal`.`id` AS `id_animal`,
        `animals`.`animal`.`name` AS `name`,
        `animals`.`animal`.`kind` AS `kind`,
        `animals`.`animal`.`breed` AS `breed`,
        IF((`animals`.`animal`.`gender` = 0),
            'жен',
            'муж') AS `gender`,
        `animals`.`animal`.`birthday` AS `birthday_animal`,
        IF((`animals`.`animal`.`castration` = 1),
            'стер',
            'не стер') AS `castration`
    FROM
        (`animals`.`animal`
        JOIN `animals`.`owner` ON ((`animals`.`owner`.`id` = `animals`.`animal`.`owner_id`)))