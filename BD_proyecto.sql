SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema mydb
-- -----------------------------------------------------

CREATE SCHEMA IF NOT EXISTS `mydb` DEFAULT CHARACTER SET utf8 ;
USE `mydb` ;

-- -----------------------------------------------------
-- Table `mydb`.`Dispositivo`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`Dispositivo` (
  `dispositivo_id` INT NOT NULL,
  `estado` VARCHAR(45) NOT NULL,
  `ubicacion` VARCHAR(45) NOT NULL,
  `tipo_dispositivo` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`dispositivo_id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`Vehiculo`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`Vehiculo` (
  `vehiculo_id` INT NOT NULL,
  `color` VARCHAR(45) NOT NULL,
  `tipo_vehiculo` VARCHAR(45) NOT NULL,
  `dispositivo_id` INT NOT NULL,
  PRIMARY KEY (`vehiculo_id`, `dispositivo_id`),
  INDEX `fk_Vehiculo_Dispositivo1_idx` (`dispositivo_id` ASC) VISIBLE,
  CONSTRAINT `fk_Vehiculo_Dispositivo1`
    FOREIGN KEY (`dispositivo_id`)
    REFERENCES `mydb`.`Dispositivo` (`dispositivo_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`Semaforo`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`Semaforo` (
  `semaforo_id` INT NOT NULL,
  `ubicacion` VARCHAR(45) NOT NULL,
  `estado` VARCHAR(45) NOT NULL,
  `tiempo_rojo` INT NULL,
  `tiempo_amarillo` INT NULL,
  `tiempo_verde` INT NULL,
  `dispositivo_id` INT NOT NULL,
  PRIMARY KEY (`semaforo_id`, `dispositivo_id`),
  INDEX `fk_Semaforo_Dispositivo1_idx` (`dispositivo_id` ASC) VISIBLE,
  CONSTRAINT `fk_Semaforo_Dispositivo1`
    FOREIGN KEY (`dispositivo_id`)
    REFERENCES `mydb`.`Dispositivo` (`dispositivo_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`Reporte`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`Reporte` (
  `reporte_id` INT NOT NULL,
  `fecha` VARCHAR(45) NOT NULL,
  `descripcion` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`reporte_id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`Rol`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`Rol` (
  `rol_id` INT NOT NULL,
  `descripcion` VARCHAR(45) NOT NULL,
  `nombre_rol` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`rol_id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`Usuario`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`Usuario` (
  `usuario_id` INT NOT NULL,
  `estado` TINYINT NOT NULL,
  `nombre` VARCHAR(45) NOT NULL,
  `contrasena` VARCHAR(45) NOT NULL,
  `correo` VARCHAR(45) NOT NULL,
  `token` VARCHAR(45) NOT NULL,
  `rol_id` INT NOT NULL,
  PRIMARY KEY (`usuario_id`, `rol_id`),
  INDEX `fk_Usuario_Rol1_idx` (`rol_id` ASC) VISIBLE,
  CONSTRAINT `fk_Usuario_Rol1`
    FOREIGN KEY (`rol_id`)
    REFERENCES `mydb`.`Rol` (`rol_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`IA_Procesamiento`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`IA_Procesamiento` (
  `IA_Procesamiento_id` INT NOT NULL,
  `numero_video` INT NOT NULL,
  `duracion_video` INT NOT NULL,
  `dispositivo_id` INT NOT NULL,
  PRIMARY KEY (`IA_Procesamiento_id`, `dispositivo_id`),
  INDEX `fk_IA_Procesamiento_Dispositivo1_idx` (`dispositivo_id` ASC) VISIBLE,
  CONSTRAINT `fk_IA_Procesamiento_Dispositivo1`
    FOREIGN KEY (`dispositivo_id`)
    REFERENCES `mydb`.`Dispositivo` (`dispositivo_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`Alarma`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`Alarma` (
  `alarma_id` INT NOT NULL,
  `descripcion` VARCHAR(45) NOT NULL,
  `tipo_notificacion` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`alarma_id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`Consulta`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`Consulta` (
  `consulta_id` INT NOT NULL,
  `fecha` VARCHAR(45) NOT NULL,
  `tipo_consulta` VARCHAR(45) NOT NULL,
  `usuario_id` INT NOT NULL,
  `rol_id` INT NOT NULL,
  PRIMARY KEY (`consulta_id`, `usuario_id`, `rol_id`),
  INDEX `fk_Consulta_conteo_Usuario1_idx` (`usuario_id` ASC, `rol_id` ASC) VISIBLE,
  CONSTRAINT `fk_Consulta_conteo_Usuario1`
    FOREIGN KEY (`usuario_id` , `rol_id`)
    REFERENCES `mydb`.`Usuario` (`usuario_id` , `rol_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`Incidente_Trafico`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`Incidente_Trafico` (
  `incidente_id` INT NOT NULL,
  `tipo_incidente` VARCHAR(45) NOT NULL,
  `fecha` VARCHAR(45) NOT NULL,
  `cantidad_vehiculos` INT NOT NULL,
  `estado` VARCHAR(45) NOT NULL,
  `ubicacion` VARCHAR(45) NOT NULL,
  `IA_procesamiento_id` INT NOT NULL,
  `dispositivo_id` INT NOT NULL,
  `reporte_id` INT NOT NULL,
  `alarma_id` INT NOT NULL,
  `consulta_id` INT NOT NULL,
  `usuario_id` INT NOT NULL,
  `rol_id` INT NOT NULL,
  PRIMARY KEY (`incidente_id`, `IA_procesamiento_id`, `dispositivo_id`, `reporte_id`, `alarma_id`, `consulta_id`, `usuario_id`, `rol_id`),
  INDEX `fk_Incidente_Trafico_IA_Procesamiento1_idx` (`IA_procesamiento_id` ASC, `dispositivo_id` ASC) VISIBLE,
  INDEX `fk_Incidente_Trafico_Reporte1_idx` (`reporte_id` ASC) VISIBLE,
  INDEX `fk_Incidente_Trafico_Alarma1_idx` (`alarma_id` ASC) VISIBLE,
  INDEX `fk_Incidente_Trafico_Consulta1_idx` (`consulta_id` ASC, `usuario_id` ASC, `rol_id` ASC) VISIBLE,
  CONSTRAINT `fk_Incidente_Trafico_IA_Procesamiento1`
    FOREIGN KEY (`IA_procesamiento_id` , `dispositivo_id`)
    REFERENCES `mydb`.`IA_Procesamiento` (`IA_Procesamiento_id` , `dispositivo_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Incidente_Trafico_Reporte1`
    FOREIGN KEY (`reporte_id`)
    REFERENCES `mydb`.`Reporte` (`reporte_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Incidente_Trafico_Alarma1`
    FOREIGN KEY (`alarma_id`)
    REFERENCES `mydb`.`Alarma` (`alarma_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Incidente_Trafico_Consulta1`
    FOREIGN KEY (`consulta_id` , `usuario_id` , `rol_id`)
    REFERENCES `mydb`.`Consulta` (`consulta_id` , `usuario_id` , `rol_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`Conteo_Vehicular`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`Conteo_Vehicular` (
  `conteo_vehicular_id` INT NOT NULL,
  `fecha` VARCHAR(45) NOT NULL,
  `hora` VARCHAR(45) NOT NULL,
  `cantidad` INT NOT NULL,
  `tipo_vehiculo` VARCHAR(45) NOT NULL,
  `dispositivo_id` INT NOT NULL,
  `consulta_id` INT NOT NULL,
  `usuario_id` INT NOT NULL,
  `rol_id` INT NOT NULL,
  PRIMARY KEY (`conteo_vehicular_id`, `dispositivo_id`, `consulta_id`, `usuario_id`, `rol_id`),
  INDEX `fk_Conteo_Vehicular_Dispositivo1_idx` (`dispositivo_id` ASC) VISIBLE,
  INDEX `fk_Conteo_Vehicular_Consulta1_idx` (`consulta_id` ASC, `usuario_id` ASC, `rol_id` ASC) VISIBLE,
  CONSTRAINT `fk_Conteo_Vehicular_Dispositivo1`
    FOREIGN KEY (`dispositivo_id`)
    REFERENCES `mydb`.`Dispositivo` (`dispositivo_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Conteo_Vehicular_Consulta1`
    FOREIGN KEY (`consulta_id` , `usuario_id` , `rol_id`)
    REFERENCES `mydb`.`Consulta` (`consulta_id` , `usuario_id` , `rol_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`Evento_Log`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`Evento_Log` (
  `evento_id` INT NOT NULL,
  `tipo_evento` VARCHAR(45) NOT NULL,
  `nombre_tabla_evento` VARCHAR(45) NOT NULL,
  `direccion_ip_evento` VARCHAR(45) NOT NULL,
  `fecha_hora_evento` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `usuario_id` INT NOT NULL,
  `usuario_rol_id` INT NOT NULL,
  PRIMARY KEY (`evento_id`, `usuario_id`, `usuario_rol_id`),
  INDEX `fk_Evento_Log_Usuario1_idx` (`usuario_id` ASC, `usuario_rol_id` ASC) VISIBLE,
  CONSTRAINT `fk_Evento_Log_Usuario1`
    FOREIGN KEY (`usuario_id` , `usuario_rol_id`)
    REFERENCES `mydb`.`Usuario` (`usuario_id` , `rol_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`Tipo_Permisos`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`Tipo_Permisos` (
  `tipo_permiso_id` INT NOT NULL,
  `nombre_tipo_permiso` VARCHAR(45) NOT NULL,
  `descripcion_tipo_permiso` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`tipo_permiso_id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`Permisos`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`Permisos` (
  `permiso_id` INT NOT NULL,
  `fecha_asignacion_permisos` DATE NOT NULL,
  `tipo_permiso_id` INT NOT NULL,
  `usuario_id` INT NOT NULL,
  `usuario_rol_id` INT NOT NULL,
  PRIMARY KEY (`permiso_id`, `tipo_permiso_id`, `usuario_id`, `usuario_rol_id`),
  INDEX `fk_Permisos_Tipo_Permisos1_idx` (`tipo_permiso_id` ASC) VISIBLE,
  INDEX `fk_Permisos_Usuario1_idx` (`usuario_id` ASC, `usuario_rol_id` ASC) VISIBLE,
  CONSTRAINT `fk_Permisos_Tipo_Permisos1`
    FOREIGN KEY (`tipo_permiso_id`)
    REFERENCES `mydb`.`Tipo_Permisos` (`tipo_permiso_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Permisos_Usuario1`
    FOREIGN KEY (`usuario_id` , `usuario_rol_id`)
    REFERENCES `mydb`.`Usuario` (`usuario_id` , `rol_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
