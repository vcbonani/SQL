CREATE OR REPLACE PROCEDURE `project-3683e6cb-e8ee-4b8e-8b5.belleza_verde_lib.incluiVenda`
    (idProduto INT64, idCliente INT64, dataVenda DATE, quantVenda INT64, margem FLOAT64, 
     OUT idRetornoProduto int64, OUT idRetornoCliente int64)
begin #abre bloco de código
    declare idVenda INT64;
    declare produtoExiste bool default false;
    declare clienteExiste bool default false;
    DECLARE precVenda FLOAT64;
    DECLARE precVendaMP FLOAT64;
    DECLARE precVendaTB FLOAT64;

    #testa se produto, cliente passado no parâmetro existe
    set produtoExiste = (select exists(select 1 from `belleza_verde_vendas.produtos` where id_produto = idProduto));
    set clienteExiste = (select exists(select 1 from `belleza_verde_vendas.clientes` where id_cliente = idCliente));

    if produtoExiste and clienteExiste then
        begin
            #automatiza o id do registro da venda
            set idVenda = (select ifnull(max(id_venda), 0) + 1 from `belleza_verde_vendas.vendas`);
            
            #automatiza a busca do preço do produto
            #busca primeira o preço do produto da tabela
            SET precVendaTB = (SELECT preco FROM `belleza_verde_vendas.produtos` WHERE id_produto = idProduto);
            #calcula o preço a partir do custo da matéria prima
            SET precVendaMP = (select mp.custo
                               from `belleza_verde_vendas.produtos` p
                               join `belleza_verde_vendas.materiasprimas` mp on p.id_materia = mp.id_materia
                               where p.id_produto = idProduto);

            #aplica uma margem no preço de matéria prima a partir da matéria prima
            SET precVendaMP = precVendaMP + margem;

            #valida qual preço é maior (tabela ou matéria prima) e considera o maior
            IF precVendaMP >= precVendaTB THEN
                SET precVenda = precVendaMP;
            ELSE
                SET precVenda = precVendaTB;
            END IF;

            insert into `belleza_verde_vendas.vendas`
                (id_venda, id_produto, id_cliente, data, quantidade, preco)
                values
                (idVenda, idProduto, idCliente, dataVenda, quantVenda, precVenda); #os valores são os parâmetros

            set idRetornoProduto = 1;
            set idRetornoCliente = 1;
        end;
    else
        begin
            set idRetornoProduto = if(produtoExiste, 1, 0);
            set idRetornoCliente = if(ClienteExiste, 1, 0);
        end;
    end if;
    select idRetornoProduto as Produto_Existente, idRetornoCliente as Cliente_Existente;
end;

CREATE OR REPLACE PROCEDURE `project-3683e6cb-e8ee-4b8e-8b5.belleza_verde_lib.incluirVendaPrincipal`
    (dataVenda DATE, quantidade INT64, margemLucro FLOAT64)
BEGIN
    DECLARE idRetornoProduto INT64;
    DECLARE idRetornoCliente INT64;
    DECLARE minimo INT64;
    DECLARE maximo INT64;
    DECLARE idProduto INT64;
    DECLARE idCliente INT64;

    SET minimo = (SELECT MIN(id_produto) FROM `belleza_verde_vendas.produtos`);
    SET maximo = (SELECT MAX(id_produto) FROM `belleza_verde_vendas.produtos`);
    SET idProduto = (SELECT `project-3683e6cb-e8ee-4b8e-8b5.belleza_verde_lib.aleatorio`(minimo, maximo));

    SET minimo = (SELECT MIN(id_cliente) FROM `belleza_verde_vendas.clientes`);
    SET maximo = (SELECT MAX(id_cliente) FROM `belleza_verde_vendas.clientes`);
    SET idCliente = (SELECT `project-3683e6cb-e8ee-4b8e-8b5.belleza_verde_lib.aleatorio`(minimo, maximo));

    call `project-3683e6cb-e8ee-4b8e-8b5.belleza_verde_lib.incluiVenda`(idProduto, idCliente, dataVenda, quantidade, margemLucro, idRetornoProduto, idRetornoCliente);

    IF idRetornoProduto = 0 AND idRetornoCliente = 0 THEN
        SELECT 'Identificador do PRODUTO e do CLIENTE inválidos' AS Mensagem;
    ELSEIF idRetornoProduto = 1 AND idRetornoCliente = 0 THEN
        SELECT 'Identificador do CLIENTE inválido' AS Mensagem;
    ELSEIF idRetornoProduto = 0 AND idRetornoCliente = 1 THEN
        SELECT 'Identificador do PRODUTO inválido' AS Mensagem;
    ELSE
        SELECT 'Venda incluída com sucesso!' AS Mensagem;
    END IF;

END;

CALL `project-3683e6cb-e8ee-4b8e-8b5.belleza_verde_lib.incluirVendaPrincipal` ('2024-01-05', 10, 10);

SELECT * FROM `belleza_verde_vendas.vendas` ORDER BY id_venda DESC LIMIT 10;

#criar função udf para retornar um id de cliente e produto randômico -> RAND()
SELECT RAND();
SELECT CAST(FLOOR((RAND() * (20 - 1 + 1))) AS INT64) + 1;

CREATE OR REPLACE FUNCTION `project-3683e6cb-e8ee-4b8e-8b5.belleza_verde_lib.aleatorio`
    (minimo INT64, maximo INT64)
    RETURNS INT64 AS(
        CAST(FLOOR((RAND() * (maximo - minimo + 1))) AS INT64) + minimo
    );

SELECT `project-3683e6cb-e8ee-4b8e-8b5.belleza_verde_lib.aleatorio`(10, 20) AS numero_aleatorio;

#Mão na massa: desenvolvimento de funções UDF para formatar datas
CREATE OR REPLACE FUNCTION `project-3683e6cb-e8ee-4b8e-8b5.belleza_verde_lib.formata_data`
    (data_usuario DATE)
    RETURNS STRING AS(
        FORMAT('%02d/%02d/%04d',
            EXTRACT(DAY FROM data_usuario),
            EXTRACT(MONTH FROM data_usuario),
            EXTRACT(YEAR FROM data_usuario))
    );

SELECT `project-3683e6cb-e8ee-4b8e-8b5.belleza_verde_lib.formata_data`(CURRENT_DATE());

### ALTERAÇÃO NO MODELO

ALTER TABLE `project-3683e6cb-e8ee-4b8e-8b5.belleza_verde_vendas.materiasprimas` ADD COLUMN custo FLOAT64;

UPDATE `project-3683e6cb-e8ee-4b8e-8b5.belleza_verde_vendas.materiasprimas` SET custo = 3.2 WHERE id_materia = 1;
UPDATE `project-3683e6cb-e8ee-4b8e-8b5.belleza_verde_vendas.materiasprimas` SET custo = 2.1 WHERE id_materia = 2;
UPDATE `project-3683e6cb-e8ee-4b8e-8b5.belleza_verde_vendas.materiasprimas` SET custo = 2.3 WHERE id_materia = 3;
UPDATE `project-3683e6cb-e8ee-4b8e-8b5.belleza_verde_vendas.materiasprimas` SET custo = 2.7 WHERE id_materia = 4;
UPDATE `project-3683e6cb-e8ee-4b8e-8b5.belleza_verde_vendas.materiasprimas` SET custo = 2.2 WHERE id_materia = 5;
UPDATE `project-3683e6cb-e8ee-4b8e-8b5.belleza_verde_vendas.materiasprimas` SET custo = 4.1 WHERE id_materia = 6;
UPDATE `project-3683e6cb-e8ee-4b8e-8b5.belleza_verde_vendas.materiasprimas` SET custo = 4.4 WHERE id_materia = 7;
UPDATE `project-3683e6cb-e8ee-4b8e-8b5.belleza_verde_vendas.materiasprimas` SET custo = 5.2 WHERE id_materia = 8;
UPDATE `project-3683e6cb-e8ee-4b8e-8b5.belleza_verde_vendas.materiasprimas` SET custo = 3.7 WHERE id_materia = 9;
UPDATE `project-3683e6cb-e8ee-4b8e-8b5.belleza_verde_vendas.materiasprimas` SET custo = 3 WHERE id_materia = 10;

###calculando preco do produto a partir do custo da materia prima
select p.id_produto, p.id_materia, p.preco, mp.custo
from `belleza_verde_vendas.produtos` p
join `belleza_verde_vendas.materiasprimas` mp on p.id_materia = mp.id_materia;

#melhorando a procedure

CREATE OR REPLACE PROCEDURE  `project-3683e6cb-e8ee-4b8e-8b5.belleza_verde_lib.criaConjuntoVendas`
(minQuantidade INT64, maxQuantidade INT64, minVendasDia INT64, maxVendasDia INT64, margemLucro FLOAT64)
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

CALL `project-3683e6cb-e8ee-4b8e-8b5.belleza_verde_lib.criaConjuntoVendas` (5, 15, 2, 6, 2);

SELECT * FROM `belleza_verde_vendas.vendas` ORDER BY id_venda DESC LIMIT 50;













