SELECT * FROM curso-big-query-19140.belleza_verde_vendas.clientes;

SELECT c.nome, COUNT(v.id_venda)
FROM curso-big-query-19140.belleza_verde_vendas.clientes c
JOIN curso-big-query-19140.belleza_verde_vendas.vendas v ON c.id_cliente = v.id_cliente
GROUP BY c.nome;

SELECT nome FROM curso-big-query-19140.belleza_verde_vendas.clientes 
WHERE localizacao = 'Rio de Janeiro' AND id_vendedor = 4;

#usando subquery
SELECT * FROM (
  SELECT *, ROUND((quantidade * preco), 2) AS faturamento FROM curso-big-query-19140.belleza_verde_vendas.vendas
) WHERE faturamento >= 600;

#WITH funciona como uma subquery
WITH vendas_faturamento AS (
  SELECT *, ROUND((quantidade * preco), 2) AS faturamento FROM curso-big-query-19140.belleza_verde_vendas.vendas
)
SELECT * FROM vendas_faturamento WHERE faturamento >= 600;

#Trabalhando com Group By
SELECT id_produto AS produto, id_cliente AS cliente, EXTRACT(YEAR FROM data) AS ano, 
       SUM(quantidade * preco) AS faturamento_total, MAX(quantidade * preco) AS maior_faturamento,
       MIN(quantidade * preco) AS menor_faturamento, AVG(quantidade * preco) AS faturamento_medio,
       COUNT(*) as numero_vendas
FROM curso-big-query-19140.belleza_verde_vendas.vendas GROUP BY produto,cliente, ano;

#Trabalhando com HAVING
SELECT id_produto AS produto, id_cliente AS cliente, EXTRACT(YEAR FROM data) AS ano, 
       SUM(quantidade * preco) AS faturamento_total, MAX(quantidade * preco) AS maior_faturamento,
       MIN(quantidade * preco) AS menor_faturamento, AVG(quantidade * preco) AS faturamento_medio,
       COUNT(*) as numero_vendas
FROM curso-big-query-19140.belleza_verde_vendas.vendas
GROUP BY produto,cliente, ano
HAVING SUM(quantidade * preco) >= 3000 AND MIN(quantidade * preco) <= 60;

#Trabalhando com Array
SELECT produto, cliente, 
       ARRAY_AGG(faturamento_total ORDER BY ano) AS array_faturamento
FROM
(
    SELECT id_produto AS produto, id_cliente AS cliente, EXTRACT(YEAR FROM data) AS ano, 
           SUM(quantidade * preco) AS faturamento_total
    FROM curso-big-query-19140.belleza_verde_vendas.vendas
    WHERE id_produto = 1 AND id_cliente = 1
    GROUP BY produto,cliente, ano
) GROUP BY produto, cliente;

#Trabalhando com STRUCT

--[{
--  "produto": "1",
--  "cliente": "1",
--  "array_faturamento": ["3443.7999999999993", "1562.2299999999998", "776.86"]
--}]

#criando um struct com um formato do JSON
SELECT [
    STRUCT (1 AS produto, 1 AS cliente, [3443.7999999999993, 1562.2299999999998, 776.86] AS array_faturamento)
] AS resultado_consulta;

#obtendo o tamanho do array
SELECT ARRAY_LENGTH(resultado_consulta) FROM
(
    SELECT [
        STRUCT (1 AS produto, 1 AS cliente, [3443.7999999999993, 1562.2299999999998, 776.86] AS array_faturamento)
    ] AS resultado_consulta
);


SELECT produto, cliente, 
       ARRAY_AGG(faturamento_total ORDER BY ano) AS array_faturamento
FROM
(
    SELECT id_produto AS produto, id_cliente AS cliente, EXTRACT(YEAR FROM data) AS ano, 
           SUM(quantidade * preco) AS faturamento_total
    FROM curso-big-query-19140.belleza_verde_vendas.vendas
    WHERE id_produto = 1 AND (id_cliente = 1 OR id_cliente = 2)
    GROUP BY produto,cliente, ano
) GROUP BY produto, cliente;

#obtendo o tamanho do array
--  "array_faturamento": ["3855.0000000000005", "2316.4099999999994", "1331.76"]
SELECT ARRAY_LENGTH(resultado_consulta) FROM
(
    SELECT [
        STRUCT (1 AS produto, 1 AS cliente, [3443.7999999999993, 1562.2299999999998, 776.86] AS array_faturamento),
        STRUCT (1 AS produto, 2 AS cliente, [3855.0000000000005, 2316.4099999999994, 1331.76] AS array_faturamento)
    ] AS resultado_consulta
);

#Array sem agregação de valor
SELECT localizacao, ARRAY_AGG(nome) AS nomes
FROM curso-big-query-19140.belleza_verde_vendas.clientes
GROUP BY localizacao;

SELECT localizacao, ARRAY_LENGTH(ARRAY_AGG(nome)) AS qtd_nomes
FROM curso-big-query-19140.belleza_verde_vendas.clientes
GROUP BY localizacao;


#Extraindo elementos do array de struct
#Usa-se resultado_consulta primeiro, coloca-se o OFFSET(N) para indicar de qual linha obter os campos e depois indica o campo
SELECT resultado_consulta[OFFSET(0)].cliente AS cliente_1, resultado_consulta[OFFSET(1)].cliente AS cliente_2,
       resultado_consulta[OFFSET(0)].array_faturamento[OFFSET(0)] as faturamento_2021_linha_1,
       resultado_consulta[OFFSET(0)].array_faturamento[OFFSET(1)] as faturamento_2021_linha_2
FROM
(
    SELECT [
        STRUCT (1 AS produto, 1 AS cliente, [3443.7999999999993, 1562.2299999999998, 776.86] AS array_faturamento),
        STRUCT (1 AS produto, 2 AS cliente, [3855.0000000000005, 2316.4099999999994, 1331.76] AS array_faturamento)
    ] AS resultado_consulta
);

#Consulta com ARRAY STRUCT
SELECT ARRAY_LENGTH(bikerides), bikerides[OFFSET(2)].numtrips[OFFSET(2)] AS fist_gender FROM
(    SELECT [
         STRUCT('MALE' AS gender, [9306602, 3955871, 11] AS numtrips),
         STRUCT('FEMALE' AS gender, [3236735, 1260893, 23] AS numtrips),
         STRUCT('OUTROS' AS gender, [323673, 160893, 13] AS numtrips)
     ] AS bikerides);

#MANIPULANDO ARRAYS

#UNNEST transforma cada a coluna array em linhas separadas

WITH estrutura_array AS (
SELECT * FROM UNNEST (
[STRUCT (1 AS produto, 1 AS cliente, [3443.7999999999993, 1562.2299999999998, 776.86] AS array_faturamento),
 STRUCT (1 AS produto, 2 AS cliente, [3855.0000000000005, 2316.4099999999994, 1331.76] AS array_faturamento)]
))
SELECT produto, cliente, faturamento,
FROM estrutura_array, UNNEST(array_faturamento) AS faturamento;

WITH estrutura_array AS (
SELECT * FROM UNNEST (
[STRUCT (1 AS produto, 1 AS cliente, [3443.7999999999993, 1562.2299999999998, 776.86] AS array_faturamento),
 STRUCT (1 AS produto, 2 AS cliente, [3855.0000000000005, 2316.4099999999994, 1331.76] AS array_faturamento)]
))
SELECT produto, cliente, SUM(faturamento) as soma_faturamento, MAX(faturamento) AS maior_faturamento,
       MIN(faturamento) AS menor_faturamento, AVG(faturamento) AS media_faturamento,
       COUNT(faturamento) AS qtd_faturamento
FROM estrutura_array, UNNEST(array_faturamento) AS faturamento
GROUP BY produto, cliente;

SELECT * FROM UNNEST ([3443.7999999999993, 1562.2299999999998, 776.86]);

#Retorno da seleção UNNEST

SELECT (
    [STRUCT ('MALE' AS gender, [9306602, 3955871] AS numtrips),
     STRUCT ('FEMALE' AS gender, [3236735, 1260893] AS numtrips)]
);

SELECT gender, numtrips[OFFSET(0)] AS first_element FROM UNNEST(
    [
        STRUCT ('MALE' AS gender, [9306602, 3955871] AS numtrips),
        STRUCT ('FEMALE' AS gender, [3236735, 1260893] AS numtrips)
    ]
);

#Exemplo prático do UNNEST

SELECT * FROM curso-big-query-19140.belleza_verde_vendas.produtos;

SELECT id_produto, nome, categoria, preco, id_materiaprima, CONCAT((percent_distribuicao) * 100, '%') AS distribuicao
FROM curso-big-query-19140.belleza_verde_vendas.produtos, 
UNNEST(materiasprimas) AS id_materiaprima, UNNEST(distribuicao) AS percent_distribuicao;

#Mão na massa - Usando ARRAY_LENGTH

SELECT p.*, mp.nome AS nome_ultima_materiaprima
FROM (
SELECT nome, categoria, preco, ARRAY_LENGTH(materiasprimas) AS qtd_materiasprimas,
       CAST(materiasprimas[OFFSET(ARRAY_LENGTH(materiasprimas) - 1)] AS INT64) AS ultima_materiaprima,
       distribuicao[OFFSET(ARRAY_LENGTH(distribuicao) - 1)] as ultima_distribuicao
FROM curso-big-query-19140.belleza_verde_vendas.produtos
) p
JOIN curso-big-query-19140.belleza_verde_vendas.materiasprimas mp ON p.ultima_materiaprima = mp.id_materia;

#Usando UNNEST em múltiplos Arrays

SELECT id_produto, nome, preco, 
       ROW_NUMBER() OVER () as indice
FROM curso-big-query-19140.belleza_verde_vendas.produtos;

SELECT AS STRUCT mp, ROW_NUMBER() OVER () as indice
FROM curso-big-query-19140.belleza_verde_vendas.produtos,
UNNEST(materiasprimas) AS mp;

SELECT id_produto, nome, preco,
    ARRAY (SELECT AS STRUCT mp, ROW_NUMBER() OVER () as indice
    FROM UNNEST(materiasprimas) AS mp) AS mp_indice,
    ARRAY (SELECT AS STRUCT d, ROW_NUMBER() OVER () as indice
    FROM UNNEST(distribuicao) AS d) AS distribuicao_indice
FROM curso-big-query-19140.belleza_verde_vendas.produtos;

WITH indice_produtos AS (
    SELECT id_produto, nome, categoria, preco,
        ARRAY (SELECT AS STRUCT mp, ROW_NUMBER() OVER () as indice
        FROM UNNEST(materiasprimas) AS mp) AS mp_indice,
        ARRAY (SELECT AS STRUCT d, ROW_NUMBER() OVER () as indice
        FROM UNNEST(distribuicao) AS d) AS distribuicao_indice
    FROM curso-big-query-19140.belleza_verde_vendas.produtos)
SELECT ip.id_produto, ip.nome, ip.categoria, ip.preco, 
       mpUN.mp as materia_prima, CONCAT(dUN.d * 100, '%') AS percentual_distribuicao
FROM indice_produtos ip
CROSS JOIN UNNEST (ip.mp_indice) AS mpUN
CROSS JOIN UNNEST (ip.distribuicao_indice) AS dUN
ON mpUN.indice = dUN.indice;

#Relacionamentos, junções, JOINs

#Testando tipos de junções
WITH CIDADES AS (
    SELECT 'RECIFE' AS CIDADE, 'PE' AS ESTADO
    UNION ALL SELECT 'SÃO PAULO' AS CIDADE, 'SP' AS ESTADO
    UNION ALL SELECT 'SANTOS' AS CIDADE, 'SP' AS ESTADO
    UNION ALL SELECT 'PORTO ALEGRE' AS CIDADE, 'RS' AS ESTADO
    UNION ALL SELECT 'BELÉM' AS CIDADE, 'PA' AS ESTADO),
REGIOES AS(
    SELECT 'SP' AS ESTADO, 'SUDESTE' AS REGIAO
    UNION ALL SELECT 'PE' AS ESTADO, 'NORDESTE' AS REGIAO
    UNION ALL SELECT 'MT' AS ESTADO, 'CENTRO-OESTE' AS REGIAO
    UNION ALL SELECT 'AM' AS ESTADO, 'NORTE' AS REGIAO
    UNION ALL SELECT 'RJ' AS ESTADO, 'SUDESTE' AS REGIAO
)
SELECT C.*, R.*
FROM CIDADES C
--INNER JOIN REGIOES R ON C.ESTADO = R.ESTADO;
--LEFT JOIN REGIOES R ON C.ESTADO = R.ESTADO;
--RIGHT JOIN REGIOES R ON C.ESTADO = R.ESTADO;
FULL JOIN REGIOES R ON C.ESTADO = R.ESTADO;
--CROSS JOIN REGIOES R;

SELECT VENDAS.id_produto, PRODUTOS.nome AS nome_produto, VENDAS.id_cliente, CLIENTES.nome AS nome_cliente,
    VENDAS.data, VENDAS.quantidade
FROM curso-big-query-19140.belleza_verde_vendas.vendas VENDAS
INNER JOIN curso-big-query-19140.belleza_verde_vendas.produtos PRODUTOS ON VENDAS.id_produto = PRODUTOS.id_produto
INNER JOIN curso-big-query-19140.belleza_verde_vendas.clientes CLIENTES ON VENDAS.id_cliente = CLIENTES.id_cliente
LIMIT 10;

WITH resultado_produto AS (
WITH indice_produtos AS (
    SELECT id_produto, nome, categoria, preco,
        ARRAY (SELECT AS STRUCT mp, ROW_NUMBER() OVER () as indice
        FROM UNNEST(materiasprimas) AS mp) AS mp_indice,
        ARRAY (SELECT AS STRUCT d, ROW_NUMBER() OVER () as indice
        FROM UNNEST(distribuicao) AS d) AS distribuicao_indice
    FROM curso-big-query-19140.belleza_verde_vendas.produtos)
SELECT ip.id_produto, ip.nome, ip.categoria, ip.preco, 
       mpUN.mp as materia_prima, CONCAT(dUN.d * 100, '%') AS percentual_distribuicao
FROM indice_produtos ip
CROSS JOIN UNNEST (ip.mp_indice) AS mpUN
CROSS JOIN UNNEST (ip.distribuicao_indice) AS dUN
ON mpUN.indice = dUN.indice)
SELECT rp.id_produto, rp.nome, rp.categoria, rp.preco, rp.materia_prima, mp.nome AS nome_materia
FROM resultado_produto rp
INNER JOIN curso-big-query-19140.belleza_verde_vendas.materiasprimas mp ON CAST(rp.materia_prima AS INT64) = mp.id_materia;

#VENDAS ANUAIS POR VENDEDORES

SELECT ve.nome AS vendedor, pr.nome AS produto, EXTRACT(YEAR FROM va.data) as ano,
       SUM(va.quantidade) AS total_vendas
FROM curso-big-query-19140.belleza_verde_vendas.vendas va
INNER JOIN curso-big-query-19140.belleza_verde_vendas.produtos pr ON va.id_produto = pr.id_produto
INNER JOIN curso-big-query-19140.belleza_verde_vendas.clientes cl ON va.id_cliente = cl.id_cliente
INNER JOIN curso-big-query-19140.belleza_verde_vendas.vendedores ve ON cl.id_vendedor = ve.id_vendedor
GROUP BY vendedor, produto, ano ORDER BY vendedor, produto, ano;

# Comparando as vendas com as metas

SELECT * FROM curso-big-query-19140.belleza_verde_vendas.metas;

WITH vendas_anuais AS (
SELECT ve.id_vendedor, ve.nome AS vendedor, pr.id_produto, pr.nome AS produto, EXTRACT(YEAR FROM va.data) as ano,
       SUM(va.quantidade) AS total_vendas
FROM curso-big-query-19140.belleza_verde_vendas.vendas va
INNER JOIN curso-big-query-19140.belleza_verde_vendas.produtos pr ON va.id_produto = pr.id_produto
INNER JOIN curso-big-query-19140.belleza_verde_vendas.clientes cl ON va.id_cliente = cl.id_cliente
INNER JOIN curso-big-query-19140.belleza_verde_vendas.vendedores ve ON cl.id_vendedor = ve.id_vendedor
GROUP BY vendedor, produto, ano, ve.id_vendedor, pr.id_produto ORDER BY vendedor, produto, ano
)
SELECT va.vendedor, va.produto, va.ano, va.total_vendas, me.quantidade_meta, 
       CONCAT(ROUND((va.total_vendas / me.quantidade_meta) * 100, 2), '%') AS meta_atingida
FROM vendas_anuais va
INNER JOIN curso-big-query-19140.belleza_verde_vendas.metas me ON va.id_produto = me.id_produto
                                                              AND va.id_vendedor = me.id_vendedor
                                                              AND va.ano = me.ano;

#apurando a performance dos vendedores

WITH vendas_anuais AS (
SELECT ve.id_vendedor, ve.nome AS vendedor, pr.id_produto, pr.nome AS produto, EXTRACT(YEAR FROM va.data) as ano,
       SUM(va.quantidade) AS total_vendas
FROM curso-big-query-19140.belleza_verde_vendas.vendas va
INNER JOIN curso-big-query-19140.belleza_verde_vendas.produtos pr ON va.id_produto = pr.id_produto
INNER JOIN curso-big-query-19140.belleza_verde_vendas.clientes cl ON va.id_cliente = cl.id_cliente
INNER JOIN curso-big-query-19140.belleza_verde_vendas.vendedores ve ON cl.id_vendedor = ve.id_vendedor
GROUP BY vendedor, produto, ano, ve.id_vendedor, pr.id_produto ORDER BY vendedor, produto, ano
)
SELECT va.vendedor, va.produto, va.ano, va.total_vendas, me.quantidade_meta, 
       CONCAT(ROUND((va.total_vendas / me.quantidade_meta) * 100, 2), '%') AS meta_atingida,
       CASE 
           WHEN va.total_vendas > me.quantidade_meta THEN 'Superou a meta'
           WHEN va.total_vendas = me.quantidade_meta THEN 'Atingiu a meta'
           ELSE 'Abaixo da meta' END AS status_meta
FROM vendas_anuais va
INNER JOIN curso-big-query-19140.belleza_verde_vendas.metas me ON va.id_produto = me.id_produto
                                                              AND va.id_vendedor = me.id_vendedor
                                                              AND va.ano = me.ano;

## Distribuição de vendas por ano


WITH vendas_anuais AS (
    SELECT ve.id_vendedor, ve.nome AS vendedor, pr.id_produto, pr.nome AS produto, EXTRACT(YEAR FROM va.data) as ano,
        SUM(va.quantidade) AS total_vendas
    FROM curso-big-query-19140.belleza_verde_vendas.vendas va
    INNER JOIN curso-big-query-19140.belleza_verde_vendas.produtos pr ON va.id_produto = pr.id_produto
    INNER JOIN curso-big-query-19140.belleza_verde_vendas.clientes cl ON va.id_cliente = cl.id_cliente
    INNER JOIN curso-big-query-19140.belleza_verde_vendas.vendedores ve ON cl.id_vendedor = ve.id_vendedor
    GROUP BY vendedor, produto, ano, ve.id_vendedor, pr.id_produto ORDER BY vendedor, produto, ano
), vendas_vendedor_produto AS(
    SELECT ve.id_vendedor, ve.nome AS vendedor, pr.id_produto, pr.nome AS produto, SUM(va.quantidade) AS total_vendas
    FROM curso-big-query-19140.belleza_verde_vendas.vendas va
    INNER JOIN curso-big-query-19140.belleza_verde_vendas.produtos pr ON va.id_produto = pr.id_produto
    INNER JOIN curso-big-query-19140.belleza_verde_vendas.clientes cl ON va.id_cliente = cl.id_cliente
    INNER JOIN curso-big-query-19140.belleza_verde_vendas.vendedores ve ON cl.id_vendedor = ve.id_vendedor
    GROUP BY vendedor, produto, ve.id_vendedor, pr.id_produto ORDER BY vendedor, produto)
SELECT va.vendedor, va.produto, va.ano, va.total_vendas, ROUND((va.total_vendas / vvp.total_vendas) * 100, 2) as distribuicao_vendas,
       me.quantidade_meta, CONCAT(ROUND((va.total_vendas / me.quantidade_meta) * 100, 2), '%') AS meta_atingida,
       CASE 
           WHEN va.total_vendas > me.quantidade_meta THEN 'Superou a meta'
           WHEN va.total_vendas = me.quantidade_meta THEN 'Atingiu a meta'
           ELSE 'Abaixo da meta' END AS status_meta
FROM vendas_anuais va
INNER JOIN curso-big-query-19140.belleza_verde_vendas.metas me ON va.id_produto = me.id_produto
                                                              AND va.id_vendedor = me.id_vendedor
                                                              AND va.ano = me.ano
INNER JOIN vendas_vendedor_produto vvp ON vvp.id_produto = va.id_produto
                                      AND vvp.id_vendedor = va.id_vendedor;














