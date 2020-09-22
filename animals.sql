-- MySQL Script generated by MySQL Workbench
-- Wed Sep 23 02:00:59 2020
-- Model: New Model    Version: 1.0
-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema mydb
-- -----------------------------------------------------

-- -----------------------------------------------------
-- Schema mydb
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `mydb` DEFAULT CHARACTER SET utf8 ;
DROP DATABASE IF EXISTS `mydb`;
CREATE DATABASE IF NOT EXISTS `mydb`;
USE `mydb` ;

-- -----------------------------------------------------
-- Table `mydb`.`owner`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`owner` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `firstname` VARCHAR(255) NOT NULL COMMENT 'имя',
  `lastname` VARCHAR(255) NOT NULL COMMENT 'фамилия',
  `created_et` DATETIME NOT NULL DEFAULT NOW() COMMENT 'дата и время регистрацйии клиента ',
  `address` VARCHAR(255) NULL DEFAULT NULL COMMENT 'адрес',
  `email` VARCHAR(255) NULL DEFAULT NULL COMMENT 'электронный адрес',
  `phone` BIGINT(11) UNSIGNED NULL DEFAULT NULL COMMENT 'телефон',
  `birthday` DATE NULL DEFAULT NULL COMMENT 'день рождения',
  `comments` VARCHAR(255) NULL DEFAULT NULL COMMENT 'комментарии',
  PRIMARY KEY (`id`),
  INDEX `firstname_lastname_ind` (`firstname` ASC, `lastname` ASC) INVISIBLE)
ENGINE = InnoDB
COMMENT = 'Владелец животного ';


-- -----------------------------------------------------
-- Table `mydb`.`animal`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`animal` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `owner_id` INT UNSIGNED NOT NULL,
  `name` VARCHAR(255) NOT NULL COMMENT 'кличка животного',
  `kind` VARCHAR(255) NOT NULL COMMENT 'вид',
  `breed` VARCHAR(50) NOT NULL COMMENT 'порода',
  `gender` TINYINT(1) UNSIGNED NOT NULL DEFAULT 0 COMMENT 'пол: 0 - жен, 1 - муж, 2 - гермоф ',
  `birthday` DATE NOT NULL COMMENT 'дата рождения',
  `castration` TINYINT(1) UNSIGNED NOT NULL DEFAULT 0 COMMENT 'кастрация: 0 - нет, 1 - да',
  `created_at` DATETIME NOT NULL DEFAULT NOW() COMMENT 'дата и время регистрации питомца',
  `contract_num` INT UNSIGNED NOT NULL COMMENT 'номер договора: на каждого отдельного питомца заводится договор обслуживания с индивидуальным номером ',
  `end` DATETIME NULL DEFAULT NULL COMMENT 'дата смерти',
  `comments` VARCHAR(255) NULL DEFAULT NULL COMMENT 'комментарии',
  PRIMARY KEY (`id`),
  INDEX `owner_idx` (`owner_id` ASC) VISIBLE,
  UNIQUE INDEX `contract_num_UNIQUE` (`contract_num` ASC) VISIBLE,
  CONSTRAINT `fk_animal_owner`
    FOREIGN KEY (`owner_id`)
    REFERENCES `mydb`.`owner` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
COMMENT = 'животное';


-- -----------------------------------------------------
-- Table `mydb`.`therapy`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`therapy` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `animal_id` INT UNSIGNED NOT NULL,
  `created_et` DATETIME NOT NULL DEFAULT NOW() COMMENT 'дата обращения',
  `diagnosis` VARCHAR(255) NOT NULL COMMENT 'диагноз',
  `anamnesis` TEXT NOT NULL COMMENT 'данные о самочувсивии животного за последнее время ',
  `inspection` TEXT NOT NULL COMMENT 'результат осмотра ',
  `manipulation` TEXT NULL DEFAULT NULL COMMENT 'выполненные манипуляции',
  `treatment` TEXT NULL DEFAULT NULL COMMENT 'назначенное лечение ',
  `comments` VARCHAR(255) NULL DEFAULT NULL COMMENT 'комментарии',
  PRIMARY KEY (`id`),
  INDEX `animal_idx` (`animal_id` ASC) VISIBLE,
  CONSTRAINT `fk_therapy_animal`
    FOREIGN KEY (`animal_id`)
    REFERENCES `mydb`.`animal` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
COMMENT = 'терапевтический приём';


-- -----------------------------------------------------
-- Table `mydb`.`surgery`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`surgery` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `animal_id` INT UNSIGNED NOT NULL,
  `diagnosis` VARCHAR(255) NOT NULL COMMENT 'диагноз',
  `name` VARCHAR(255) NOT NULL COMMENT 'название операции ',
  `anamnesis` TEXT NOT NULL COMMENT 'данные о самочувсивии животного за последнее время ',
  `work` TEXT NOT NULL COMMENT 'описание проведённой операции ',
  `treatment` TEXT NOT NULL COMMENT 'назначение послеоперационного лечения ',
  `created_at` DATETIME NOT NULL DEFAULT NOW() COMMENT 'дата и время проведения операции ',
  `comments` VARCHAR(255) NULL DEFAULT NULL COMMENT 'комментарии',
  PRIMARY KEY (`id`),
  INDEX `animal_idx` (`animal_id` ASC) VISIBLE,
  CONSTRAINT `fk_surgery_animal`
    FOREIGN KEY (`animal_id`)
    REFERENCES `mydb`.`animal` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
COMMENT = 'хирургия';


-- -----------------------------------------------------
-- Table `mydb`.`research`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`research` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `animal_id` INT UNSIGNED NOT NULL,
  `therapy_id` INT UNSIGNED NOT NULL,
  `surgery_id` INT UNSIGNED NOT NULL,
  PRIMARY KEY (`id`),
  INDEX `animal_idx` (`animal_id` ASC) VISIBLE,
  INDEX `therapy_idx` (`therapy_id` ASC) VISIBLE,
  INDEX `surgery_idx` (`surgery_id` ASC) VISIBLE,
  CONSTRAINT `fk_research_animal`
    FOREIGN KEY (`animal_id`)
    REFERENCES `mydb`.`animal` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_research_therapy`
    FOREIGN KEY (`therapy_id`)
    REFERENCES `mydb`.`therapy` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_research_surgery`
    FOREIGN KEY (`surgery_id`)
    REFERENCES `mydb`.`surgery` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
COMMENT = 'методы специальной и лабораторной диагностики ';


-- -----------------------------------------------------
-- Table `mydb`.`ultrasound`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`ultrasound` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `research_id` INT UNSIGNED NOT NULL,
  `name` VARCHAR(255) NOT NULL COMMENT 'область исследования',
  `description` TEXT NOT NULL COMMENT 'описание увиденной картины на момент уз-исследования ',
  `result` TEXT NOT NULL COMMENT 'заключение по уз-исследованию ',
  `created_at` DATETIME NOT NULL DEFAULT NOW() COMMENT 'дата и время проведения уз-исследования',
  `comments` VARCHAR(255) NULL DEFAULT NULL COMMENT 'комментарии',
  PRIMARY KEY (`id`),
  INDEX `research_idx` (`research_id` ASC) VISIBLE,
  CONSTRAINT `fk_ultrasound_research`
    FOREIGN KEY (`research_id`)
    REFERENCES `mydb`.`research` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
COMMENT = 'узи';


-- -----------------------------------------------------
-- Table `mydb`.`x-ray`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`x-ray` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `research_id` INT UNSIGNED NOT NULL,
  `name` VARCHAR(255) NOT NULL COMMENT 'область исследования',
  `description` TEXT NOT NULL COMMENT 'описание рентгеновского снимка ',
  `result` TEXT NOT NULL COMMENT 'заключение по рентгеновскому снимку',
  `created_at` DATETIME NOT NULL DEFAULT NOW() COMMENT 'дата и время рентгеновского снимка',
  `comments` VARCHAR(255) NULL DEFAULT NULL COMMENT 'комментарии',
  PRIMARY KEY (`id`),
  INDEX `research_idx` (`research_id` ASC) VISIBLE,
  CONSTRAINT `fk_x-ray_research`
    FOREIGN KEY (`research_id`)
    REFERENCES `mydb`.`research` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
COMMENT = 'рентген ';


-- -----------------------------------------------------
-- Table `mydb`.`blood`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`blood` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `research_id` INT UNSIGNED NOT NULL,
  `name` VARCHAR(255) NOT NULL COMMENT 'название анализа крови',
  `result` TEXT NOT NULL COMMENT 'результаты исследования крови',
  `created_at` DATETIME NOT NULL DEFAULT NOW() COMMENT 'дата и время проведения анализов крови',
  `comments` VARCHAR(255) NULL DEFAULT NULL COMMENT 'комментарии',
  PRIMARY KEY (`id`),
  INDEX `research_idx` (`research_id` ASC) VISIBLE,
  CONSTRAINT `fk_blood_research`
    FOREIGN KEY (`research_id`)
    REFERENCES `mydb`.`research` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
COMMENT = 'общий и биохимический анализ крови ';


-- -----------------------------------------------------
-- Table `mydb`.`microscopy`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`microscopy` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `research_id` INT UNSIGNED NOT NULL,
  `name` VARCHAR(255) NOT NULL COMMENT 'Наименование микроскопического исследования',
  `result` TEXT NOT NULL COMMENT 'заключение по микроскопическому исследованию ',
  `created_et` DATETIME NOT NULL DEFAULT NOW() COMMENT 'дата и время проведения микроскопии',
  `comments` VARCHAR(255) NULL DEFAULT NULL COMMENT 'комментарии',
  PRIMARY KEY (`id`),
  INDEX `research_idx` (`research_id` ASC) VISIBLE,
  CONSTRAINT `fk_microscopy_research`
    FOREIGN KEY (`research_id`)
    REFERENCES `mydb`.`research` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
COMMENT = 'микроскопическое исследование соскобов';


-- -----------------------------------------------------
-- Table `mydb`.`hospital`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`hospital` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `animal_id` INT UNSIGNED NOT NULL,
  `therapy_id` INT UNSIGNED NOT NULL,
  `surgery_id` INT UNSIGNED NOT NULL,
  PRIMARY KEY (`id`),
  INDEX `animal_idx` (`animal_id` ASC) VISIBLE,
  INDEX `therapy_idx` (`therapy_id` ASC) VISIBLE,
  INDEX `surgery_idx` (`surgery_id` ASC) VISIBLE,
  CONSTRAINT `fk_hospital_animal`
    FOREIGN KEY (`animal_id`)
    REFERENCES `mydb`.`animal` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_hospital_therapy`
    FOREIGN KEY (`therapy_id`)
    REFERENCES `mydb`.`therapy` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_hospital_surgery`
    FOREIGN KEY (`surgery_id`)
    REFERENCES `mydb`.`surgery` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
COMMENT = 'стационар';


-- -----------------------------------------------------
-- Table `mydb`.`zoo_hotel`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`zoo_hotel` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `hospital_id` INT UNSIGNED NOT NULL,
  `created_at` DATETIME NOT NULL DEFAULT NOW() COMMENT 'дата и веремя помещения в зоогостиницу ',
  `description` TEXT NULL COMMENT 'описание стационарного содержиния ',
  `comments` VARCHAR(255) NULL DEFAULT NULL COMMENT 'комментарии',
  PRIMARY KEY (`id`),
  INDEX `hospital_idx` (`hospital_id` ASC) VISIBLE,
  CONSTRAINT `fk_zoo_hotel_hospital`
    FOREIGN KEY (`hospital_id`)
    REFERENCES `mydb`.`hospital` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
COMMENT = 'зоогостиница, процедурный стационар ';


-- -----------------------------------------------------
-- Table `mydb`.`infectious_ hospital`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`infectious_ hospital` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `hospital_id` INT UNSIGNED NOT NULL,
  `created_at` DATETIME NOT NULL DEFAULT NOW() COMMENT 'дата и время помещения на инфекционный стационар \n',
  `health` TEXT NOT NULL COMMENT 'описание самочувствия питомца ',
  ` manipulation` TEXT NULL DEFAULT NULL COMMENT 'описание проведённых процедур ',
  `comments` VARCHAR(255) NULL DEFAULT NULL COMMENT 'комментарии',
  PRIMARY KEY (`id`),
  INDEX `hospital_idx` (`hospital_id` ASC) VISIBLE,
  CONSTRAINT `fk_infectious_ hospital_hospital`
    FOREIGN KEY (`hospital_id`)
    REFERENCES `mydb`.`hospital` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
COMMENT = 'инфекционный стационар';


-- -----------------------------------------------------
-- Table `mydb`.`postoperative_hospital`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`postoperative_hospital` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `hospital_id` INT UNSIGNED NOT NULL,
  `health` TEXT NOT NULL COMMENT 'данные о самочувствии питомца \n',
  `created_at` DATETIME NOT NULL DEFAULT NOW() COMMENT 'дата и время помещения на послеоперационный стационар ',
  `manipulation` TEXT NULL COMMENT 'описание проведённых процедур ',
  `comments` VARCHAR(255) NULL DEFAULT NULL COMMENT 'комментарии',
  `postoperative_hospitalcol` VARCHAR(45) NULL,
  PRIMARY KEY (`id`),
  INDEX `hospital_idx` (`hospital_id` ASC) VISIBLE,
  CONSTRAINT `fk_postoperative_hospital_hospital`
    FOREIGN KEY (`hospital_id`)
    REFERENCES `mydb`.`hospital` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
COMMENT = 'послеоперационный стационар';


-- -----------------------------------------------------
-- Table `mydb`.`procedures`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`procedures` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `animal_id` INT UNSIGNED NOT NULL,
  `therapy_id` INT UNSIGNED NOT NULL,
  `surgery_id` INT UNSIGNED NOT NULL,
  `hospital_id` INT UNSIGNED NOT NULL,
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
    REFERENCES `mydb`.`animal` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_procedures_therapy`
    FOREIGN KEY (`therapy_id`)
    REFERENCES `mydb`.`therapy` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_procedures_surgery`
    FOREIGN KEY (`surgery_id`)
    REFERENCES `mydb`.`surgery` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_procedures_hospital`
    FOREIGN KEY (`hospital_id`)
    REFERENCES `mydb`.`hospital` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
COMMENT = 'выполнение процедур по назначению из текущей клиники или из сторонней клиники ';


-- -----------------------------------------------------
-- Table `mydb`.`media_types`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`media_types` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(255) NOT NULL COMMENT 'название ',
  `created_et` DATETIME NOT NULL DEFAULT NOW() COMMENT 'дата и время создания ',
  PRIMARY KEY (`id`))
ENGINE = InnoDB
COMMENT = 'типы медиа файла ';


-- -----------------------------------------------------
-- Table `mydb`.`media`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`media` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `media_types_id` INT UNSIGNED NOT NULL,
  `therapy_id` INT UNSIGNED NOT NULL,
  `surgery_id` INT UNSIGNED NOT NULL,
  `procedures_id` INT UNSIGNED NOT NULL,
  `hospital_id` INT UNSIGNED NOT NULL,
  `research_id` INT UNSIGNED NOT NULL,
  `blob` BLOB NOT NULL,
  `size` INT UNSIGNED NOT NULL,
  `created_et` DATETIME NOT NULL DEFAULT NOW(),
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
    REFERENCES `mydb`.`media_types` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_media_therapy`
    FOREIGN KEY (`therapy_id`)
    REFERENCES `mydb`.`therapy` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_media_surgery`
    FOREIGN KEY (`surgery_id`)
    REFERENCES `mydb`.`surgery` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_media_procedures`
    FOREIGN KEY (`procedures_id`)
    REFERENCES `mydb`.`procedures` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_media_hospital`
    FOREIGN KEY (`hospital_id`)
    REFERENCES `mydb`.`hospital` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_media_research`
    FOREIGN KEY (`research_id`)
    REFERENCES `mydb`.`research` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
COMMENT = 'медиа файлы';


-- -----------------------------------------------------
-- Table `mydb`.`barber`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`barber` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `animal_id` INT UNSIGNED NOT NULL,
  `name` VARCHAR(255) NOT NULL COMMENT 'перечисление выполненных косметических процедур ',
  `created_et` DATETIME NOT NULL DEFAULT NOW() COMMENT 'дата и время проведения косметических процедур ',
  `comments` VARCHAR(255) NULL DEFAULT NULL COMMENT 'комментарии',
  PRIMARY KEY (`id`),
  INDEX `animal_idx` (`animal_id` ASC) VISIBLE,
  CONSTRAINT `fk_barber_animal`
    FOREIGN KEY (`animal_id`)
    REFERENCES `mydb`.`animal` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
COMMENT = 'груминг (стрижка животных) ';


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;