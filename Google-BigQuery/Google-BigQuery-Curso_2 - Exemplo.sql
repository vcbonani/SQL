WITH
  VENDAS_ANUAIS AS (
  SELECT
    VENDEDORES.id_vendedor,
    VENDEDORES.nome AS nome_vendedor,
    PRODUTOS.id_produto,
    PRODUTOS.nome AS nome_produto,
    EXTRACT(YEAR
    FROM
      VENDAS.data) AS ano,
    SUM(VENDAS.quantidade) AS total_vendas
  FROM
    curso-big-query-19140.belleza_verde_vendas.vendas VENDAS
  INNER JOIN
    curso-big-query-19140.belleza_verde_vendas.produtos PRODUTOS
  ON
    VENDAS.id_produto = PRODUTOS.id_produto
  INNER JOIN
    curso-big-query-19140.belleza_verde_vendas.clientes CLIENTES
  ON
    VENDAS.id_cliente = CLIENTES.id_cliente
  INNER JOIN
    curso-big-query-19140.belleza_verde_vendas.vendedores VENDEDORES
  ON
    CLIENTES.id_vendedor = VENDEDORES.id_vendedor
  GROUP BY
    VENDEDORES.id_vendedor,
    VENDEDORES.nome,
    PRODUTOS.id_produto,
    PRODUTOS.nome,
    EXTRACT(YEAR
    FROM
      VENDAS.data)),
  VENDAS_TODOS_OS_ANOS AS (
  SELECT
    VENDEDORES.id_vendedor,
    VENDEDORES.nome AS nome_vendedor,
    PRODUTOS.id_produto,
    PRODUTOS.nome AS nome_produto,
    SUM(VENDAS.quantidade) AS total_vendas
  FROM
    curso-big-query-19140.belleza_verde_vendas.vendas VENDAS
  INNER JOIN
    curso-big-query-19140.belleza_verde_vendas.produtos PRODUTOS
  ON
    VENDAS.id_produto = PRODUTOS.id_produto
  INNER JOIN
    curso-big-query-19140.belleza_verde_vendas.clientes CLIENTES
  ON
    VENDAS.id_cliente = CLIENTES.id_cliente
  INNER JOIN
    curso-big-query-19140.belleza_verde_vendas.vendedores VENDEDORES
  ON
    CLIENTES.id_vendedor = VENDEDORES.id_vendedor
  GROUP BY
    VENDEDORES.id_vendedor,
    VENDEDORES.nome,
    PRODUTOS.id_produto,
    PRODUTOS.nome)
SELECT
  VENDAS_ANUAIS.nome_vendedor,
  replace(replace(replace(trim(VENDAS_ANUAIS.nome_produto), '-', ''),'Ã£', 'ã'), 'Ã“', 'Ó'),
  VENDAS_ANUAIS.ano,
  VENDAS_ANUAIS.total_vendas,
  concat(format("%'.*F", 2,  ((VENDAS_ANUAIS.total_vendas / VENDAS_TODOS_OS_ANOS.total_vendas) * 100)), '%') AS distribuicao_vendas,
  METAS.quantidade_meta,
  concat('O desempenho do vendedor ', VENDAS_ANUAIS.nome_vendedor, ' para o produto ', replace(replace(replace(trim(VENDAS_ANUAIS.nome_produto), '-', ''),'Ã£', 'ã'), 'Ã“', 'Ó'), ' foi ',
  CASE
    WHEN VENDAS_ANUAIS.total_vendas >= METAS.quantidade_meta THEN 'BOM'
  ELSE
  'RUIM'
END)
  AS status_meta,
  concat(format("%'.*F", 2, ((VENDAS_ANUAIS.total_vendas/METAS.quantidade_meta) - 1) * 100), '%') AS performance
FROM
  VENDAS_ANUAIS
INNER JOIN
  curso-big-query-19140.belleza_verde_vendas.metas METAS
ON
  VENDAS_ANUAIS.id_produto = METAS.id_produto
  AND VENDAS_ANUAIS.id_vendedor = METAS.id_vendedor
  AND VENDAS_ANUAIS.ano = METAS.ano
INNER JOIN
  VENDAS_TODOS_OS_ANOS
ON
  VENDAS_ANUAIS.id_produto = VENDAS_TODOS_OS_ANOS.id_produto
  AND VENDAS_ANUAIS.id_vendedor = VENDAS_TODOS_OS_ANOS.id_vendedor;