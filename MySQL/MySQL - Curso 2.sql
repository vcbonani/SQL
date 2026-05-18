#executando uma stored procedure
call alo_mundo;
call lista_clientes;
call lista_hospedagens;

#apagando uma stored procedure
drop procedure alo_mundo;

call tipos_dados;
call data_hora;

############################################################


USE `insight_places`;
DROP procedure IF EXISTS `insight_places`.`novoaluguel_22`;
;

DELIMITER $$
USE `insight_places`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `novoaluguel_22`()
BEGIN
	declare vAluguel varchar(10) default 10001;
    declare vCliente varchar(10) default 1002;
    declare vHospedagem varchar(10) default 8635;
    declare vDataInicio date default '2023-03-01';
    declare vDataFinal date default '2023-03-05';
    declare vPrecoTotal decimal(10, 2) default 550.22;
    INSERT INTO alugueis VALUES (vAluguel, vCliente, vHospedagem, vDataInicio, vDataFinal, vPrecoTotal);
END$$

DELIMITER ;
;

#################################################################

select * from alugueis where aluguel_id = 10001;
CALL novoaluguel_22;

############################################################

USE `insight_places`;
DROP procedure IF EXISTS `insight_places`.`novoaluguel_23`;
;

DELIMITER $$
USE `insight_places`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `novoaluguel_23`
	(vAluguel varchar(10), vCliente varchar(10), vHospedagem varchar(10), vDataInicio date,
     vDataFinal date, vPrecoTotal decimal(10, 2))
BEGIN
    INSERT INTO alugueis VALUES (vAluguel, vCliente, vHospedagem, vDataInicio, vDataFinal, vPrecoTotal);
END$$

DELIMITER ;


############################################################

call novoaluguel_23('10002', '1003', '8636', '2023-03-02', '2023-03-06', 700.51);
call novoaluguel_23('10003', '1004', '8637', '2023-03-03', '2023-03-07', 7950.51);

select * from alugueis where aluguel_id = '10002';
select * from alugueis where aluguel_id = '10003';

############################################################

USE `insight_places`;
DROP procedure IF EXISTS `insight_places`.`novoaluguel_24`;
;

DELIMITER $$
USE `insight_places`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `novoaluguel_24`
	(vAluguel varchar(10), vCliente varchar(10), vHospedagem varchar(10), vDataInicio date,
     vDataFinal date, vPrecoUnitario decimal(10, 2))
BEGIN
	DECLARE vDias INTEGER DEFAULT 0;
    DECLARE vPrecoTotal DECIMAL(10,2);
    SET vDias = (SELECT DATEDIFF (vDataFinal, vDataInicio));
    SET vPrecoTotal = vDias * vPrecoUnitario;
    INSERT INTO alugueis VALUES (vAluguel, vCliente, vHospedagem, vDataInicio, vDataFinal, vPrecoTotal);
END$$

DELIMITER ;


############################################################

call novoaluguel_24('10006', '1005', '8638', '2023-03-04', '2023-03-08', 100.00);
select * from alugueis where aluguel_id = 10006;

############################################################

USE `insight_places`;
DROP procedure IF EXISTS `insight_places`.`novoaluguel_25`;
;

DELIMITER $$
USE `insight_places`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `novoaluguel_25`
	(vAluguel varchar(10), vCliente varchar(10), vHospedagem varchar(10), vDataInicio date,
     vDataFinal date, vPrecoUnitario decimal(10, 2))
BEGIN
	DECLARE vDias INTEGER DEFAULT 0;
    DECLARE vPrecoTotal DECIMAL(10,2);
    DECLARE vMensagem VARCHAR(100);
    DECLARE vErro INT;
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
		GET DIAGNOSTICS CONDITION 1 vErro = MYSQL_ERRNO;
        IF vErro = 1452 THEN
			SET vMensagem = 'Problema de chave estrangeira associado a alguma entidade da base.';
        ELSEIF vErro = 1062 THEN
			SET vMensagem = 'Registro já existe na base.';
		ELSE
			SET vMensagem = CONCAT('Erro não mapeado. Código: ', vErro);
		END IF;
        SELECT vMensagem;
	END;
    SET vDias = (SELECT DATEDIFF (vDataFinal, vDataInicio));
    SET vPrecoTotal = vDias * vPrecoUnitario;
    INSERT INTO alugueis VALUES (vAluguel, vCliente, vHospedagem, vDataInicio, vDataFinal, vPrecoTotal);
    SET vMensagem = 'Aluguel incluído com sucesso na base de dados.';
    SELECT vMensagem;
END$$

DELIMITER ;


############################################################

call novoaluguel_25('10008', '1006', '8638', '2023-03-04', '2023-03-08', 100.00);
select * from alugueis where aluguel_id = 10007;

SELECT * FROM clientes WHERE nome = 'Luana Moura';

############################################################

USE `insight_places`;
DROP procedure IF EXISTS `insight_places`.`novoaluguel_31`;
;

DELIMITER $$
USE `insight_places`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `novoaluguel_31`
	(vAluguel varchar(10), vClienteNome varchar(150), vHospedagem varchar(10), vDataInicio date,
     vDataFinal date, vPrecoUnitario decimal(10, 2))
BEGIN
	DECLARE vCliente VARCHAR(10);
    DECLARE vDias INTEGER DEFAULT 0;
    DECLARE vPrecoTotal DECIMAL(10,2);
    DECLARE vMensagem VARCHAR(100);
    DECLARE vErro INT;
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
		GET DIAGNOSTICS CONDITION 1 vErro = MYSQL_ERRNO;
        IF vErro = 1452 THEN
			SET vMensagem = 'Problema de chave estrangeira associado a alguma entidade da base.';
        ELSEIF vErro = 1062 THEN
			SET vMensagem = 'Registro já existe na base.';
		ELSE
			SET vMensagem = CONCAT('Erro não mapeado. Código: ', vErro);
		END IF;
        SELECT vMensagem;
	END;
    SET vDias = (SELECT DATEDIFF (vDataFinal, vDataInicio));
    SET vPrecoTotal = vDias * vPrecoUnitario;
    SELECT cliente_id INTO vCliente FROM clientes WHERE nome = vClienteNome;
    INSERT INTO alugueis VALUES (vAluguel, vCliente, vHospedagem, vDataInicio, vDataFinal, vPrecoTotal);
    SET vMensagem = 'Aluguel incluído com sucesso na base de dados.';
    SELECT vMensagem;
END$$

DELIMITER ;


############################################################

call novoaluguel_31('10009', 'Luana Moura', '8638', '2023-03-05', '2023-03-09', 125.00);
SELECT * FROM alugueis;

call novoaluguel_31('10010', 'Júlia Pires', '8639', '2023-03-06', '2023-03-10', 225.00);
SELECT * FROM clientes WHERE nome = 'Júlia Pires';

############################################################

USE `insight_places`;
DROP procedure IF EXISTS `insight_places`.`novoaluguel_32`;
;

DELIMITER $$
USE `insight_places`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `novoaluguel_32`
	(vAluguel varchar(10), vClienteNome varchar(150), vHospedagem varchar(10), vDataInicio date,
     vDataFinal date, vPrecoUnitario decimal(10, 2))
BEGIN
	DECLARE vCliente VARCHAR(10);
    DECLARE vDias INTEGER DEFAULT 0;
    DECLARE vNumCliente INTEGER;
    DECLARE vPrecoTotal DECIMAL(10,2);
    DECLARE vMensagem VARCHAR(100);
    DECLARE vErro INT;
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
		GET DIAGNOSTICS CONDITION 1 vErro = MYSQL_ERRNO;
        IF vErro = 1452 THEN
			SET vMensagem = 'Problema de chave estrangeira associado a alguma entidade da base.';
        ELSEIF vErro = 1062 THEN
			SET vMensagem = 'Registro já existe na base.';
		ELSE
			SET vMensagem = CONCAT('Erro não mapeado. Código: ', vErro);
		END IF;
        SELECT vMensagem;
	END;
    
    SET vNumCliente = (SELECT COUNT(*) FROM clientes WHERE nome = vClienteNome);
    IF vNumCliente > 1 THEN
		SET vMensagem = 'Este cliente não pode ser usado para incluir o aluguel pelo nome.';
        SELECT vMensagem;
    ELSE
		SET vDias = (SELECT DATEDIFF (vDataFinal, vDataInicio));
		SET vPrecoTotal = vDias * vPrecoUnitario;
		SELECT cliente_id INTO vCliente FROM clientes WHERE nome = vClienteNome;
		INSERT INTO alugueis VALUES (vAluguel, vCliente, vHospedagem, vDataInicio, vDataFinal, vPrecoTotal);
		SET vMensagem = 'Aluguel incluído com sucesso na base de dados.';
		SELECT vMensagem;
    END IF;
END$$

DELIMITER ;


############################################################

CALL novoaluguel_32('10010', 'Júlia Pires', '8639', '2023-03-06', '2023-03-10', 225.00);
CALL novoaluguel_32('10011', 'Victorino Vila', '8639', '2023-03-06', '2023-03-10', 225.00);
SELECT * FROM alugueis;
DELETE FROM alugueis WHERE aluguel_id = 10011;

############################################################

USE `insight_places`;
DROP procedure IF EXISTS `insight_places`.`novoaluguel_33`;
;

DELIMITER $$
USE `insight_places`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `novoaluguel_33`
	(vAluguel varchar(10), vClienteNome varchar(150), vHospedagem varchar(10), vDataInicio date,
     vDataFinal date, vPrecoUnitario decimal(10, 2))
BEGIN
	DECLARE vCliente VARCHAR(10);
    DECLARE vDias INTEGER DEFAULT 0;
    DECLARE vNumCliente INTEGER;
    DECLARE vPrecoTotal DECIMAL(10,2);
    DECLARE vMensagem VARCHAR(100);
    DECLARE vErro INT;
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
		GET DIAGNOSTICS CONDITION 1 vErro = MYSQL_ERRNO;
        IF vErro = 1452 THEN
			SET vMensagem = 'Problema de chave estrangeira associado a alguma entidade da base.';
        ELSEIF vErro = 1062 THEN
			SET vMensagem = 'Registro já existe na base.';
		ELSE
			SET vMensagem = CONCAT('Erro não mapeado. Código: ', vErro);
		END IF;
        SELECT vMensagem;
	END;
    
    SET vNumCliente = (SELECT COUNT(*) FROM clientes WHERE nome = vClienteNome);
    IF vNumCliente > 1 THEN
		SET vMensagem = 'Este cliente não pode ser usado para incluir o aluguel pelo nome.';
	ELSEIF vNumCliente = 0 THEN
		SET vMensagem = 'Este cliente não está cadastrado na base de dados';
    ELSE
		SET vDias = (SELECT DATEDIFF (vDataFinal, vDataInicio));
		SET vPrecoTotal = vDias * vPrecoUnitario;
		SELECT cliente_id INTO vCliente FROM clientes WHERE nome = vClienteNome;
		INSERT INTO alugueis VALUES (vAluguel, vCliente, vHospedagem, vDataInicio, vDataFinal, vPrecoTotal);
		SET vMensagem = 'Aluguel incluído com sucesso na base de dados.';
    END IF;
    SELECT vMensagem;
END$$

DELIMITER ;

############################################################

CALL novoaluguel_33('10011', 'Luana Moura', '88639', '2023-03-06', '2023-03-10', 225.00);

############################################################

USE `insight_places`;
DROP procedure IF EXISTS `insight_places`.`novoaluguel_34`;
;

DELIMITER $$
USE `insight_places`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `novoaluguel_34`
	(vAluguel varchar(10), vClienteNome varchar(150), vHospedagem varchar(10), vDataInicio date,
     vDataFinal date, vPrecoUnitario decimal(10, 2))
BEGIN
	DECLARE vCliente VARCHAR(10);
    DECLARE vDias INTEGER DEFAULT 0;
    DECLARE vNumCliente INTEGER;
    DECLARE vPrecoTotal DECIMAL(10,2);
    DECLARE vMensagem VARCHAR(100);
    DECLARE vErro INT;
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
		GET DIAGNOSTICS CONDITION 1 vErro = MYSQL_ERRNO;
        IF vErro = 1452 THEN
			SET vMensagem = 'Problema de chave estrangeira associado a alguma entidade da base.';
        ELSEIF vErro = 1062 THEN
			SET vMensagem = 'Registro já existe na base.';
		ELSE
			SET vMensagem = CONCAT('Erro não mapeado. Código: ', vErro);
		END IF;
        SELECT vMensagem;
	END;
    
    SET vNumCliente = (SELECT COUNT(*) FROM clientes WHERE nome = vClienteNome);
    CASE vNumCliente
		WHEN 0 THEN
			SET vMensagem = 'Este cliente não está cadastrado na base de dados';
		WHEN 1 THEN
			SET vDias = (SELECT DATEDIFF (vDataFinal, vDataInicio));
			SET vPrecoTotal = vDias * vPrecoUnitario;
			SELECT cliente_id INTO vCliente FROM clientes WHERE nome = vClienteNome;
			INSERT INTO alugueis VALUES (vAluguel, vCliente, vHospedagem, vDataInicio, vDataFinal, vPrecoTotal);
			SET vMensagem = 'Aluguel incluído com sucesso na base de dados.';
		ELSE
			SET vMensagem = 'Este cliente não pode ser usado para incluir o aluguel pelo nome.';
	END CASE;
    SELECT vMensagem;
END$$

DELIMITER ;

############################################################

CALL novoaluguel_34('10012', 'Luana Moura', '1639', '2023-02-06', '2023-03-10', 225.00);
SELECT * FROM alugueis;

############################################################

USE `insight_places`;
DROP procedure IF EXISTS `insight_places`.`novoaluguel_35`;
;

DELIMITER $$
USE `insight_places`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `novoaluguel_35`
	(vAluguel varchar(10), vClienteNome varchar(150), vHospedagem varchar(10), vDataInicio date,
     vDataFinal date, vPrecoUnitario decimal(10, 2))
BEGIN
	DECLARE vCliente VARCHAR(10);
    DECLARE vDias INTEGER DEFAULT 0;
    DECLARE vNumCliente INTEGER;
    DECLARE vPrecoTotal DECIMAL(10,2);
    DECLARE vMensagem VARCHAR(100);
    DECLARE vErro INT;
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
		GET DIAGNOSTICS CONDITION 1 vErro = MYSQL_ERRNO;
        IF vErro = 1452 THEN
			SET vMensagem = 'Problema de chave estrangeira associado a alguma entidade da base.';
        ELSEIF vErro = 1062 THEN
			SET vMensagem = 'Registro já existe na base.';
		ELSE
			SET vMensagem = CONCAT('Erro não mapeado. Código: ', vErro);
		END IF;
        SELECT vMensagem;
	END;
    
    SET vNumCliente = (SELECT COUNT(*) FROM clientes WHERE nome = vClienteNome);
    CASE
		WHEN vNumCliente = 0 THEN
			SET vMensagem = 'Este cliente não está cadastrado na base de dados';
		WHEN vNumCliente = 1 THEN
			SET vDias = (SELECT DATEDIFF (vDataFinal, vDataInicio));
			SET vPrecoTotal = vDias * vPrecoUnitario;
			SELECT cliente_id INTO vCliente FROM clientes WHERE nome = vClienteNome;
			INSERT INTO alugueis VALUES (vAluguel, vCliente, vHospedagem, vDataInicio, vDataFinal, vPrecoTotal);
			SET vMensagem = 'Aluguel incluído com sucesso na base de dados.';
		WHEN vNumCliente > 1 THEN
			SET vMensagem = 'Este cliente não pode ser usado para incluir o aluguel pelo nome.';
	END CASE;
    SELECT vMensagem;
END$$

DELIMITER ;

############################################################

CALL novoaluguel_34('10013', 'Luana Moura', '1639', '2023-02-06', '2023-03-10', 225.00);
CALL novoaluguel_34('10013', 'Vini', '1639', '2023-02-06', '2023-03-10', 225.00);
CALL novoaluguel_34('10014', 'Júlia Pires', '16390', '2023-02-06', '2023-03-10', 225.00);
CALL novoaluguel_34('10014', 'Luana Moura', '16390', '2023-02-06', '2023-03-10', 225.00);

SELECT '2023-01-31' + INTERVAL 5 DAY;

############################################################

USE `insight_places`;
DROP procedure IF EXISTS `insight_places`.`novoaluguel_41`;
;

DELIMITER $$
USE `insight_places`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `novoaluguel_41`
	(vAluguel varchar(10), vClienteNome varchar(150), vHospedagem varchar(10), vDataInicio date,
     vDias INTEGER, vPrecoUnitario decimal(10, 2))
BEGIN
	DECLARE vCliente VARCHAR(10);
    DECLARE vDataFinal DATE;
    DECLARE vNumCliente INTEGER;
    DECLARE vPrecoTotal DECIMAL(10,2);
    DECLARE vMensagem VARCHAR(100);
    DECLARE vErro INT;
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
		GET DIAGNOSTICS CONDITION 1 vErro = MYSQL_ERRNO;
        IF vErro = 1452 THEN
			SET vMensagem = 'Problema de chave estrangeira associado a alguma entidade da base.';
        ELSEIF vErro = 1062 THEN
			SET vMensagem = 'Registro já existe na base.';
		ELSE
			SET vMensagem = CONCAT('Erro não mapeado. Código: ', vErro);
		END IF;
        SELECT vMensagem;
	END;
    
    SET vNumCliente = (SELECT COUNT(*) FROM clientes WHERE nome = vClienteNome);
    CASE
		WHEN vNumCliente = 0 THEN
			SET vMensagem = 'Este cliente não está cadastrado na base de dados';
		WHEN vNumCliente = 1 THEN
			SET vPrecoTotal = vDias * vPrecoUnitario;
            SET vDataFinal = (SELECT vDataInicio + INTERVAL vDias DAY);
			SELECT cliente_id INTO vCliente FROM clientes WHERE nome = vClienteNome;
			INSERT INTO alugueis VALUES (vAluguel, vCliente, vHospedagem, vDataInicio, vDataFinal, vPrecoTotal);
			SET vMensagem = 'Aluguel incluído com sucesso na base de dados.';
		WHEN vNumCliente > 1 THEN
			SET vMensagem = 'Este cliente não pode ser usado para incluir o aluguel pelo nome.';
	END CASE;
    SELECT vMensagem;
END$$

DELIMITER ;

############################################################

CALL novoaluguel_41('10014', 'Rafael Peixoto', '1390', '2023-02-06', 10, 25.00);
SELECT * FROM alugueis;

#obtendo o dia da semana com o DAYOFWEEK
SELECT DAYOFWEEK(STR_TO_DATE('2026-03-06', '%Y-%m-%d'));

############################################################

USE `insight_places`;
DROP procedure IF EXISTS `insight_places`.`novoaluguel_42`;
;

DELIMITER $$
USE `insight_places`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `novoaluguel_42`
	(vAluguel varchar(10), vClienteNome varchar(150), vHospedagem varchar(10), vDataInicio date,
     vDias INTEGER, vPrecoUnitario decimal(10, 2))
BEGIN
	DECLARE vCliente VARCHAR(10);
    DECLARE vContador INTEGER;
    DECLARE vDiaSemana INTEGER;
    DECLARE vDataFinal DATE;
    DECLARE vNumCliente INTEGER;
    DECLARE vPrecoTotal DECIMAL(10,2);
    DECLARE vMensagem VARCHAR(100);
    DECLARE vErro INT;
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
		GET DIAGNOSTICS CONDITION 1 vErro = MYSQL_ERRNO;
        IF vErro = 1452 THEN
			SET vMensagem = 'Problema de chave estrangeira associado a alguma entidade da base.';
        ELSEIF vErro = 1062 THEN
			SET vMensagem = 'Registro já existe na base.';
		ELSE
			SET vMensagem = CONCAT('Erro não mapeado. Código: ', vErro);
		END IF;
        SELECT vMensagem;
	END;
    
    SET vNumCliente = (SELECT COUNT(*) FROM clientes WHERE nome = vClienteNome);
    CASE
		WHEN vNumCliente = 0 THEN
			SET vMensagem = 'Este cliente não está cadastrado na base de dados';
		WHEN vNumCliente = 1 THEN
			SET vContador = 1;
            SET vDataFinal = vDataInicio;
            WHILE vContador < vDias
			DO
				SET vDiaSemana = (SELECT DAYOFWEEK(STR_TO_DATE(vDataFinal, '%Y-%m-%d')));
                IF (vDiaSemana <> 7 AND vDiaSemana <> 1) THEN
					SET vContador = vContador + 1;
                END IF;
                SET vDataFinal = (SELECT vDataFinal + INTERVAL 1 DAY);
            END WHILE;
			SET vPrecoTotal = vDias * vPrecoUnitario;
            
			SELECT cliente_id INTO vCliente FROM clientes WHERE nome = vClienteNome;
			INSERT INTO alugueis VALUES (vAluguel, vCliente, vHospedagem, vDataInicio, vDataFinal, vPrecoTotal);
			SET vMensagem = 'Aluguel incluído com sucesso na base de dados.';
		WHEN vNumCliente > 1 THEN
			SET vMensagem = 'Este cliente não pode ser usado para incluir o aluguel pelo nome.';
	END CASE;
    SELECT vMensagem;
END$$

DELIMITER ;

############################################################

SELECT DAYOFWEEK(STR_TO_DATE('2023-02-10', '%Y-%m-%d'));
CALL novoaluguel_42('10015', 'Gabriela Pires', '1391', '2023-02-10', 10, 25.00);
SELECT * FROM alugueis;

############################################################

USE `insight_places`;
DROP procedure IF EXISTS `insight_places`.`novoaluguel_43`;
;

DELIMITER $$
USE `insight_places`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `novoaluguel_43`
	(vAluguel varchar(10), vClienteNome varchar(150), vHospedagem varchar(10), vDataInicio date,
     vDias INTEGER, vPrecoUnitario decimal(10, 2))
BEGIN
	DECLARE vCliente VARCHAR(10);
    DECLARE vDataFinal DATE;
    DECLARE vNumCliente INTEGER;
    DECLARE vPrecoTotal DECIMAL(10,2);
    DECLARE vMensagem VARCHAR(100);
    DECLARE vErro INT;
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
		GET DIAGNOSTICS CONDITION 1 vErro = MYSQL_ERRNO;
        IF vErro = 1452 THEN
			SET vMensagem = 'Problema de chave estrangeira associado a alguma entidade da base.';
        ELSEIF vErro = 1062 THEN
			SET vMensagem = 'Registro já existe na base.';
		ELSE
			SET vMensagem = CONCAT('Erro não mapeado. Código: ', vErro);
		END IF;
        SELECT vMensagem;
	END;
    
    SET vNumCliente = (SELECT COUNT(*) FROM clientes WHERE nome = vClienteNome);
    CASE
		WHEN vNumCliente = 0 THEN
			SET vMensagem = 'Este cliente não está cadastrado na base de dados';
		WHEN vNumCliente = 1 THEN
			CALL calcula_data_final_43(vDataInicio, vDataFinal, vDias);
			SET vPrecoTotal = vDias * vPrecoUnitario;
			SELECT cliente_id INTO vCliente FROM clientes WHERE nome = vClienteNome;
			INSERT INTO alugueis VALUES (vAluguel, vCliente, vHospedagem, vDataInicio, vDataFinal, vPrecoTotal);
			SET vMensagem = 'Aluguel incluído com sucesso na base de dados.';
		WHEN vNumCliente > 1 THEN
			SET vMensagem = 'Este cliente não pode ser usado para incluir o aluguel pelo nome.';
	END CASE;
    SELECT vMensagem;
END$$

DELIMITER ;

############################################################

CALL novoaluguel_43('10017', 'Lívia Fogaça', '1392', '2023-02-11', 8, 30.00);
SELECT * FROM alugueis;

############################################################

USE `insight_places`;
DROP procedure IF EXISTS `insight_places`.`novoaluguel_43_desafio`;
;

DELIMITER $$
USE `insight_places`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `novoaluguel_43_desafio`
	(vAluguel varchar(10), vClienteNome varchar(150), vHospedagem varchar(10), vDataInicio date,
     vDias INTEGER, vPrecoUnitario decimal(10, 2))
BEGIN
	DECLARE vCliente VARCHAR(10);
    DECLARE vDataFinal DATE;
    DECLARE vNumCliente INTEGER;
    DECLARE vPrecoTotal DECIMAL(10,2);
    DECLARE vMensagem VARCHAR(100);
    DECLARE vErro INT;
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
		GET DIAGNOSTICS CONDITION 1 vErro = MYSQL_ERRNO;
        IF vErro = 1452 THEN
			SET vMensagem = 'Problema de chave estrangeira associado a alguma entidade da base.';
        ELSEIF vErro = 1062 THEN
			SET vMensagem = 'Registro já existe na base.';
		ELSE
			SET vMensagem = CONCAT('Erro não mapeado. Código: ', vErro);
		END IF;
        SELECT vMensagem;
	END;
    
    SET vNumCliente = (SELECT COUNT(*) FROM clientes WHERE nome = vClienteNome);
    CASE
		WHEN vNumCliente = 0 THEN
			SET vMensagem = 'Este cliente não está cadastrado na base de dados';
		WHEN vNumCliente = 1 THEN
			CALL calcula_data_final_43(vDataInicio, vDataFinal, vDias);
			CALL inclusao_cliente_43(vAluguel, vClienteNome, vHospedagem, vDataInicio, vDataFinal, vDias, vPrecoUnitario);
            SET vMensagem = 'Aluguel incluído com sucesso na base de dados.';
		WHEN vNumCliente > 1 THEN
			SET vMensagem = 'Este cliente não pode ser usado para incluir o aluguel pelo nome.';
	END CASE;
    SELECT vMensagem;
END$$

DELIMITER ;

############################################################

CALL novoaluguel_43('10018', 'Lívia Fogaça', '1322', '2023-02-12', 5, 100.00);
SELECT * FROM alugueis;

#aluguel_id é originalmente VARCHAR
#o CAST converte o tipo da coluna
SELECT MAX(aluguel_id), MAX(CAST(aluguel_id AS UNSIGNED)) FROM alugueis;

############################################################

USE `insight_places`;
DROP procedure IF EXISTS `insight_places`.`novoaluguel_43_desafio`;
;

DELIMITER $$
USE `insight_places`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `novoaluguel_44`
	(vClienteNome VARCHAR(150), vHospedagem VARCHAR(10), vDataInicio DATE,
     vDias INTEGER, vPrecoUnitario DECIMAL(10, 2))
BEGIN
	DECLARE vAluguel VARCHAR(10);
    DECLARE vCliente VARCHAR(10);
    DECLARE vDataFinal DATE;
    DECLARE vNumCliente INTEGER;
    DECLARE vPrecoTotal DECIMAL(10,2);
    DECLARE vMensagem VARCHAR(100);
    DECLARE vErro INT;
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
		GET DIAGNOSTICS CONDITION 1 vErro = MYSQL_ERRNO;
        IF vErro = 1452 THEN
			SET vMensagem = 'Problema de chave estrangeira associado a alguma entidade da base.';
        ELSEIF vErro = 1062 THEN
			SET vMensagem = 'Registro já existe na base.';
		ELSE
			SET vMensagem = CONCAT('Erro não mapeado. Código: ', vErro);
		END IF;
        SELECT vMensagem;
	END;
    
    SET vNumCliente = (SELECT COUNT(*) FROM clientes WHERE nome = vClienteNome);
    CASE
		WHEN vNumCliente = 0 THEN
			SET vMensagem = 'Este cliente não está cadastrado na base de dados';
		WHEN vNumCliente = 1 THEN
			#gerando um id automático a partir de uma coluna tipo varchar
            SELECT CAST(MAX(CAST(aluguel_id AS UNSIGNED)) + 1 AS CHAR) INTO vAluguel FROM alugueis;
            CALL calcula_data_final_43(vDataInicio, vDataFinal, vDias);
			CALL inclusao_cliente_43(vAluguel, vClienteNome, vHospedagem, vDataInicio, vDataFinal, vDias, vPrecoUnitario);
            SET vMensagem = CONCAT('Aluguel incluído com sucesso na base de dados. - ID: ', vAluguel);
		WHEN vNumCliente > 1 THEN
			SET vMensagem = 'Este cliente não pode ser usado para incluir o aluguel pelo nome.';
	END CASE;
    SELECT vMensagem;
END$$

DELIMITER ;

############################################################

CALL novoaluguel_44('Lívia Fogaça', '1323', '2023-03-30', 15, 70.00);
SELECT * FROM alugueis;


-- tabela temporária

-- temp_nomes (nome)
DROP TEMPORARY TABLE IF EXISTS temp_nomes;
CREATE TEMPORARY TABLE temp_nomes (nome VARCHAR(255), email VARCHAR(255));
CALL inclui_usuarios_lista_52('Paulo, Vini, Carla, Ka, Joana, Marcio, Hira');
CALL inclui_usuarios_lista_52_teste('Paulo, Vini, Carla, Ka, Joana, Marcio, Hira');
SELECT * FROM temp_nomes;

CALL looping_cursor_54;
CALL looping_cursor_54_teste;

########################################################################

USE `insight_places`;
DROP procedure IF EXISTS `insight_places`.`novosAlugueis_55`;
;

DELIMITER $$
USE `insight_places`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `novosAlugueis_55`(lista VARCHAR(255), vHospedagem VARCHAR(10), vDataInicio DATE,
     vDias INTEGER, vPrecoUnitario DECIMAL(10, 2))
BEGIN
	DECLARE vClienteNome VARCHAR(255);
    DECLARE fimCursor INTEGER DEFAULT 0;
    DECLARE vNome VARCHAR(254);
    DECLARE cursor1 CURSOR FOR SELECT nome from temp_nomes;
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET fimCursor = 1;
    
    DROP TEMPORARY TABLE IF EXISTS temp_nomes;
	CREATE TEMPORARY TABLE temp_nomes (nome VARCHAR(255));
	CALL inclui_usuarios_lista_52(lista);

    OPEN cursor1;
	FETCH cursor1 INTO vNome;
    WHILE fimCursor = 0 DO
        SET vClienteNome = vNome;
        CALL novoAluguel_44(vClienteNome, vHospedagem, vDataInicio, vDias, vPrecoUnitario);
        FETCH cursor1 INTO vNome;
    END WHILE;
    CLOSE cursor1;
	DROP TEMPORARY TABLE IF EXISTS temp_nomes;

END$$

DELIMITER ;

#####################################################################

CALL novosAlugueis_55('Gabriel Carvalho, Erick Oliveira, Catarina Correia, Lorena Jesus', '1324', '2023-04-01', 10, 20.00);
SELECT * FROM alugueis;