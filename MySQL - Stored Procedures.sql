-- MySQL dump 10.13  Distrib 8.0.44, for Win64 (x86_64)
--
-- Host: localhost    Database: insight_places
-- ------------------------------------------------------
-- Server version	8.0.44

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Dumping routines for database 'insight_places'
--
/*!50003 DROP FUNCTION IF EXISTS `CalculaDuracaoMediaEstadias` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` FUNCTION `CalculaDuracaoMediaEstadias`() RETURNS int
    DETERMINISTIC
begin
	declare media_estadia int;
    select ceil(avg(datediff(data_fim, data_inicio))) into media_estadia from alugueis;
    return media_estadia;
end ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP FUNCTION IF EXISTS `calcularvalorfinalcomdesconto` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` FUNCTION `calcularvalorfinalcomdesconto`(id_aluguel int) RETURNS decimal(10,2)
    DETERMINISTIC
begin
	declare valor_total decimal(10, 2);
    declare desconto int;
    declare preco_com_desconto decimal(10, 2);
    
    select preco_total into valor_total from alugueis where aluguel_id = id_aluguel;
    select calcula_desconto_por_dias(id_aluguel) into desconto;
    
    set preco_com_desconto = valor_total * ((100 - desconto) / 100);
    return preco_com_desconto;
end ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP FUNCTION IF EXISTS `calcula_desconto_por_dias` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` FUNCTION `calcula_desconto_por_dias`(id_aluguel INT) RETURNS int
    DETERMINISTIC
BEGIN
	DECLARE desconto INT;
	SELECT CASE
			WHEN DATEDIFF(data_fim, data_inicio) >= 10 THEN 15
			WHEN DATEDIFF(data_fim, data_inicio) BETWEEN 7 AND 9 THEN 10
			WHEN DATEDIFF(data_fim, data_inicio) BETWEEN 4 AND 6 THEN 5
			ELSE 0
		END INTO desconto
	FROM alugueis
    WHERE aluguel_id = id_aluguel;
    RETURN desconto;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP FUNCTION IF EXISTS `hospedagens_disponiveis` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` FUNCTION `hospedagens_disponiveis`(p_tipo VARCHAR(50)) RETURNS varchar(255) CHARSET utf8mb3 COLLATE utf8mb3_unicode_ci
    DETERMINISTIC
BEGIN
	DECLARE qtd_hospedagens INTEGER;
    SELECT COUNT(*) INTO qtd_hospedagens FROM hospedagens WHERE tipo = p_tipo;
    RETURN CONCAT('A quantidade de hospedagens disponíveis do tipo ', p_tipo, ' é: ', qtd_hospedagens, '.');
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP FUNCTION IF EXISTS `info_diaria` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` FUNCTION `info_diaria`(p_id_aluguel INT) RETURNS varchar(255) CHARSET utf8mb3 COLLATE utf8mb3_unicode_ci
    DETERMINISTIC
BEGIN
	DECLARE v_valor_diaria DECIMAL(10,2);
    DECLARE v_nome_cliente VARCHAR(255);
	SELECT c.nome, (a.preco_total / DATEDIFF(a.data_fim, a.data_inicio)) INTO v_nome_cliente, v_valor_diaria
	FROM alugueis a JOIN clientes c ON a.cliente_id = c.cliente_id WHERE a.aluguel_id = p_id_aluguel;
    IF v_valor_diaria IS NULL OR v_valor_diaria <= 0 THEN
		RETURN 'Aluguel não encontrado na base de dados';
    ELSE
		RETURN CONCAT('O cliente ', v_nome_cliente, ' pagou diárias de R$', FORMAT(v_valor_diaria, 2));
	END IF;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP FUNCTION IF EXISTS `media_avaliacoes` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` FUNCTION `media_avaliacoes`() RETURNS decimal(10,2)
    DETERMINISTIC
BEGIN
		DECLARE media_notas DECIMAL(10, 2);
        SET media_notas = (SELECT ROUND(AVG(nota), 2) FROM avaliacoes);
        RETURN media_notas;
    END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP FUNCTION IF EXISTS `ocupacao_media` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` FUNCTION `ocupacao_media`() RETURNS decimal(10,2)
    DETERMINISTIC
BEGIN
	DECLARE media_ocupacao DECIMAL(10,2);
    DECLARE total_ocupacao INTEGER;
    DECLARE total_hospedagens INTEGER;
    SET total_ocupacao = (SELECT COUNT(*)FROM alugueis);
    SET total_hospedagens = (SELECT COUNT(*) FROM hospedagens);
    SET media_ocupacao = (total_ocupacao / total_hospedagens);
	RETURN media_ocupacao;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP FUNCTION IF EXISTS `tres_primeiros_digitos` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` FUNCTION `tres_primeiros_digitos`(nome_parametro VARCHAR(255)) RETURNS varchar(5) CHARSET utf8mb3 COLLATE utf8mb3_unicode_ci
    DETERMINISTIC
BEGIN
	DECLARE tres_digitos VARCHAR(5);
    SET tres_digitos = (SELECT SUBSTRING(cpf, 1, 3) FROM clientes WHERE nome = nome_parametro);
    RETURN tres_digitos;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `calcula_data_final_43` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `calcula_data_final_43`(vDataInicio DATE, INOUT vDataFinal DATE, vDias INTEGER)
BEGIN

	DECLARE vContador INTEGER;
    DECLARE vDiaSemana INTEGER;
    
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

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `calcula_taxa_ocupacao` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `calcula_taxa_ocupacao`(id varchar(255))
begin
	SELECT p.nome AS Proprietario, MIN(primeira_data) AS primeira_data, SUM(total_dias) AS total_dias, SUM(dias_ocupados) AS dias_ocupados,
		ROUND((SUM(dias_ocupados) / SUM(total_dias)) * 100) AS taxa_ocupacao
	FROM(
		SELECT  hospedagem_id,
			MIN(data_inicio) AS primeira_data,
			SUM(DATEDIFF(data_fim, data_inicio)) AS dias_ocupados,
			DATEDIFF(MAX(data_fim), MIN(data_inicio)) AS total_dias
		FROM alugueis
		GROUP BY hospedagem_id
		) tabela_taxa_ocupacao
	JOIN hospedagens h ON tabela_taxa_ocupacao.hospedagem_id = h.hospedagem_id
	JOIN proprietarios p ON h.proprietario_id = p.proprietario_id
    where p.proprietario_id = id
	GROUP BY p.proprietario_id
	ORDER BY total_dias DESC;
end ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `data_hora` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `data_hora`()
BEGIN
	DECLARE vDataHora DATETIME DEFAULT localtimestamp();
    SELECT vDataHora;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `inclui_regioes_estados` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `inclui_regioes_estados`()
BEGIN
	insert into regioes_geograficas (id, estado, regiao)
		select
			(select max(id) from regioes_geograficas) + ROW_NUMBER() over (order by e.estado),
			e.estado,
            case
				WHEN e.estado IN ('SP','RJ','MG','ES') THEN 'SUDESTE'
				WHEN e.estado IN ('PR','SC','RS') THEN 'SUL'
				WHEN e.estado IN ('BA','PE','CE','RN','PB','AL','SE','MA','PI') THEN 'NORDESTE'
				WHEN e.estado IN ('MT','MS','GO','DF') THEN 'CENTRO-OESTE'
				ELSE 'NORTE'
			end
		from regioes_geograficas r
		right join enderecos e on r.estado = e.estado
		where r.estado is null
		group by e.estado;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `inclui_usuarios_lista_52` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `inclui_usuarios_lista_52`(lista VARCHAR(255))
BEGIN
	DECLARE nome VARCHAR(255);
    DECLARE restante VARCHAR(255);
    DECLARE pos INTEGER;
    
    SET restante = lista;
    
    WHILE INSTR(restante, ',') > 0
    DO
		SET pos = INSTR(restante, ',');
        SET nome = TRIM(LEFT(restante, pos - 1));
        INSERT INTO temp_nomes VALUES (nome);
        SET restante = substring(restante, pos + 1);
    END WHILE;
    
    IF TRIM(restante) <> '' THEN
		INSERT INTO temp_nomes VALUES (TRIM(restante));
    END IF;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `inclui_usuarios_lista_52_teste` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `inclui_usuarios_lista_52_teste`(lista VARCHAR(255))
BEGIN
	DECLARE nome VARCHAR(255);
    DECLARE restante VARCHAR(255);
    DECLARE pos INTEGER;
    
    SET restante = lista;
    
    WHILE INSTR(restante, ',') > 0
    DO
		SET pos = INSTR(restante, ',');
        SET nome = TRIM(LEFT(restante, pos - 1));
        INSERT INTO temp_nomes VALUES (nome, CONCAT(nome, '@email.com'));
        SET restante = substring(restante, pos + 1);
    END WHILE;
    
    IF TRIM(restante) <> '' THEN
		INSERT INTO temp_nomes VALUES (TRIM(restante), CONCAT(TRIM(restante), '@email.com'));
    END IF;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `inclusao_cliente_43` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `inclusao_cliente_43`(vAluguel VARCHAR(10), vClienteNome VARCHAR(150), vHospedagem VARCHAR(10), 
     vDataInicio DATE, vDataFinal DATE, vDias INTEGER, vPrecoUnitario DECIMAL(10, 2))
BEGIN
	DECLARE vPrecoTotal DECIMAL(10,2);
    DECLARE vCliente VARCHAR(10);
    
    SET vPrecoTotal = vDias * vPrecoUnitario;
    SELECT cliente_id INTO vCliente FROM clientes WHERE nome = vClienteNome;
	INSERT INTO alugueis VALUES (vAluguel, vCliente, vHospedagem, vDataInicio, vDataFinal, vPrecoTotal);
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `lista_clientes` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `lista_clientes`()
BEGIN
	select * from clientes;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `lista_hospedagens` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `lista_hospedagens`()
BEGIN
	select * from hospedagens where tipo = 'casa';
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `looping_cursor_54` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `looping_cursor_54`()
BEGIN
	DECLARE fimCursor INTEGER DEFAULT 0;
    DECLARE vNome VARCHAR(255);
    DECLARE cursor1 CURSOR FOR SELECT nome from temp_nomes;
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET fimCursor = 1;
    
    OPEN cursor1;
	FETCH cursor1 INTO vNome;
    WHILE fimCursor = 0 DO
        SELECT vNome;
        FETCH cursor1 INTO vNome;
    END WHILE;
    CLOSE cursor1;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `looping_cursor_54_teste` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `looping_cursor_54_teste`()
BEGIN
	DECLARE fimCursor INTEGER DEFAULT 0;
    DECLARE vNome VARCHAR(255);
    DECLARE vEmail VARCHAR(255);
    DECLARE cursor1 CURSOR FOR SELECT nome, email from temp_nomes;
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET fimCursor = 1;
    
    OPEN cursor1;
	FETCH cursor1 INTO vNome, vEmail;
    WHILE fimCursor = 0 DO
        SELECT vNome, vEmail;
        FETCH cursor1 INTO vNome, vEmail;
    END WHILE;
    CLOSE cursor1;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `looping_cursor_55` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `looping_cursor_55`()
BEGIN
	DECLARE fimCursor INTEGER DEFAULT 0;
    DECLARE vNome VARCHAR(255);
    DECLARE cursor1 CURSOR FOR SELECT nome from temp_nomes;
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET fimCursor = 1;
    
    OPEN cursor1;
	FETCH cursor1 INTO vNome;
    WHILE fimCursor = 0 DO
        SELECT vNome;
        FETCH cursor1 INTO vNome;
    END WHILE;
    CLOSE cursor1;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `novoaluguel_21` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `novoaluguel_21`()
BEGIN
	declare vAluguel varchar(10) default 10001;
    declare vCliente varchar(10) default 1002;
    declare vHospedagem varchar(10) default 8635;
    declare vDataInicio date default '2023-03-01';
    declare vDataFinal date default '2023-03-05';
    declare vPrecoTotal decimal(10, 2) default 550.22;
    select vAluguel, vCliente, vHospedagem, vDataInicio, vDataFinal, vPrecoTotal;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `novoaluguel_22` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `novoaluguel_22`()
BEGIN
	declare vAluguel varchar(10) default 10001;
    declare vCliente varchar(10) default 1002;
    declare vHospedagem varchar(10) default 8635;
    declare vDataInicio date default '2023-03-01';
    declare vDataFinal date default '2023-03-05';
    declare vPrecoTotal decimal(10, 2) default 550.22;
    INSERT INTO alugueis VALUES (vAluguel, vCliente, vHospedagem, vDataInicio, vDataFinal, vPrecoTotal);
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `novoaluguel_23` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `novoaluguel_23`(vAluguel varchar(10), vCliente varchar(10), vHospedagem varchar(10), vDataInicio date,
     vDataFinal date, vPrecoTotal decimal(10, 2))
BEGIN
    INSERT INTO alugueis VALUES (vAluguel, vCliente, vHospedagem, vDataInicio, vDataFinal, vPrecoTotal);
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `novoaluguel_24` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `novoaluguel_24`(vAluguel varchar(10), vCliente varchar(10), vHospedagem varchar(10), vDataInicio date,
     vDataFinal date, vPrecoUnitario decimal(10, 2))
BEGIN
	DECLARE vDias INTEGER DEFAULT 0;
    DECLARE vPrecoTotal DECIMAL(10,2);
    SET vDias = (SELECT DATEDIFF (vDataFinal, vDataInicio));
    SET vPrecoTotal = vDias * vPrecoUnitario;
    INSERT INTO alugueis VALUES (vAluguel, vCliente, vHospedagem, vDataInicio, vDataFinal, vPrecoTotal);
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `novoaluguel_25` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `novoaluguel_25`(vAluguel varchar(10), vCliente varchar(10), vHospedagem varchar(10), vDataInicio date,
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
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `novoaluguel_31` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `novoaluguel_31`(vAluguel varchar(10), vClienteNome varchar(150), vHospedagem varchar(10), vDataInicio date,
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
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `novoaluguel_32` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `novoaluguel_32`(vAluguel varchar(10), vClienteNome varchar(150), vHospedagem varchar(10), vDataInicio date,
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
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `novoaluguel_33` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `novoaluguel_33`(vAluguel varchar(10), vClienteNome varchar(150), vHospedagem varchar(10), vDataInicio date,
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
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `novoaluguel_34` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `novoaluguel_34`(vAluguel varchar(10), vClienteNome varchar(150), vHospedagem varchar(10), vDataInicio date,
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
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `novoaluguel_35` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `novoaluguel_35`(vAluguel varchar(10), vClienteNome varchar(150), vHospedagem varchar(10), vDataInicio date,
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
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `novoaluguel_41` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `novoaluguel_41`(vAluguel varchar(10), vClienteNome varchar(150), vHospedagem varchar(10), vDataInicio date,
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
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `novoaluguel_42` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `novoaluguel_42`(vAluguel varchar(10), vClienteNome varchar(150), vHospedagem varchar(10), vDataInicio date,
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
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `novoaluguel_43` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `novoaluguel_43`(vAluguel varchar(10), vClienteNome varchar(150), vHospedagem varchar(10), vDataInicio date,
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
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `novoaluguel_43_desafio` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `novoaluguel_43_desafio`(vAluguel varchar(10), vClienteNome varchar(150), vHospedagem varchar(10), vDataInicio date,
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
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `novoaluguel_44` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `novoaluguel_44`(vClienteNome VARCHAR(150), vHospedagem VARCHAR(10), vDataInicio DATE,
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
			SELECT CAST(MAX(CAST(aluguel_id AS UNSIGNED)) + 1 AS CHAR) INTO vAluguel FROM alugueis;
            CALL calcula_data_final_43(vDataInicio, vDataFinal, vDias);
			CALL inclusao_cliente_43(vAluguel, vClienteNome, vHospedagem, vDataInicio, vDataFinal, vDias, vPrecoUnitario);
            SET vMensagem = CONCAT('Aluguel incluído com sucesso na base de dados. - ID: ', vAluguel);
		WHEN vNumCliente > 1 THEN
			SET vMensagem = 'Este cliente não pode ser usado para incluir o aluguel pelo nome.';
	END CASE;
    SELECT vMensagem;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `novosAlugueis_55` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
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

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `obtem_dados_regiao` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `obtem_dados_regiao`(regiao_nome varchar(255))
begin
	select year(data_inicio) as ano, month(data_inicio) as mes, count(*) as total_alugueis
	from alugueis a
	join hospedagens h on a.hospedagem_id = h.hospedagem_id
	join enderecos e on h.endereco_id = e.endereco_id
	join regioes_geograficas r on e.estado = r.estado
	where r.regiao = regiao_nome
	group by ano, mes
	order by ano, mes;
end ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `tipos_dados` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `tipos_dados`()
BEGIN
	declare vAluguel varchar(10) default 10001;
    declare vCliente varchar(10) default 1002;
    declare vHospedagem varchar(10) default 8635;
    declare vDataInicio date default '2023-03-01';
    declare vDataFinal date default '2023-03-05';
    declare vPrecoTotal decimal(10, 2) default 550.22;
    select vAluguel, vCliente, vHospedagem, vDataInicio, vDataFinal, vPrecoTotal;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `tipo_dados` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `tipo_dados`()
BEGIN
	declare vAluguel varchar(10) default 10001;
    declare vCliente varchar(10) default 1002;
    declare vHospedagem varchar(10) default 8635;
    declare vDataInicio date default '2023-03-01';
    declare vDataFinal date default '2023-03-05';
    declare vPrecoTotal decimal(10, 2) default 550.22;
    select vAluguel, vCliente, vHospedagem, vDataInicio, vDataFinal, vPrecoTotal;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-04-13 17:15:03
