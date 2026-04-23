#análise de Pareto

WITH cte_faturamento AS (
  SELECT cl.nome AS cliente, ROUND(SUM(ve.quantidade * ve.preco), 2) AS faturamento
  FROM curso-big-query-19140.belleza_verde_vendas.vendas ve
  INNER JOIN curso-big-query-19140.belleza_verde_vendas.clientes cl ON ve.id_cliente = cl.id_cliente
  WHERE EXTRACT(YEAR FROM ve.data) = 2021 GROUP BY cl.nome
),
faturamento_ranking AS(
  SELECT RANK() OVER(ORDER BY faturamento DESC) AS ranking, *,
         CONCAT(ROUND((faturamento / (SUM(faturamento) OVER())) * 100, 2), '%') AS percentual_participacao
  FROM cte_faturamento
),
dist_cumulativa AS(
  SELECT *, 
         CONCAT(ROUND((SUM(faturamento) OVER(ORDER BY ranking ASC ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) / (SUM(faturamento) OVER())) * 100, 2), '%') AS distribuicao_faturamento,
         CONCAT(ROUND((ranking / COUNT (*) OVER()) * 100, 2), '%') AS distribuicao_produtos
  FROM faturamento_ranking
)
SELECT * FROM dist_cumulativa;