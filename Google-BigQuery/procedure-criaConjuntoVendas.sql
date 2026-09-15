CREATE OR REPLACE PROCEDURE `project-3683e6cb-e8ee-4b8e-8b5.belleza_verde_lib.criaConjuntoVendas`(minQuantidade INT64, maxQuantidade INT64, minVendasDia INT64, maxVendasDia INT64, margemLucro FLOAT64)
BEGIN

    DECLARE dataVenda DATE;
    DECLARE quantidade INT64;
    DECLARE dataInicial DATE;
    DECLARE dataFinal DATE;
    DECLARE numVendasDia INT64;

    SET dataInicial = DATE_SUB(CURRENT_DATE(), INTERVAL 2 DAY);
    SET dataFinal = CURRENT_DATE();

    FOR dataCorrente IN (SELECT dia FROM UNNEST (GENERATE_DATE_ARRAY(dataInicial, dataFinal)) AS dia)
    DO
        BEGIN
            SET dataVenda = dataCorrente.dia;
            SET numVendasDia = (SELECT `project-3683e6cb-e8ee-4b8e-8b5.belleza_verde_lib.aleatorio`(minVendasDia, maxVendasDia));
            FOR i IN (SELECT num FROM UNNEST (GENERATE_ARRAY(1, numVendasDia)) AS num)
            DO
                BEGIN
                    SET quantidade = (SELECT `project-3683e6cb-e8ee-4b8e-8b5.belleza_verde_lib.aleatorio`(minQuantidade, maxQuantidade));
                    CALL `project-3683e6cb-e8ee-4b8e-8b5.belleza_verde_lib.incluirVendaPrincipal` (dataVenda, quantidade, margemLucro);
                END;
            END FOR;
        END;
    END FOR;

END;