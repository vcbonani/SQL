CREATE OR REPLACE PROCEDURE `project-3683e6cb-e8ee-4b8e-8b5.belleza_verde_lib.incluiVenda`(idProduto INT64, idCliente INT64, dataVenda DATE, quantVenda INT64, margem FLOAT64, OUT idRetornoProduto INT64, OUT idRetornoCliente INT64)
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