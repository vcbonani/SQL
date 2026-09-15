CREATE OR REPLACE PROCEDURE `project-3683e6cb-e8ee-4b8e-8b5.belleza_verde_lib.incluirVendaPrincipal`(dataVenda DATE, quantidade INT64, margemLucro FLOAT64)
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