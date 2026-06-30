# números: arredondar, truncar, buscar parte inteira

WITH VENDAS_ARRENDONDADAS AS (
  WITH VENDAS_COMPARATIVAS AS (
    SELECT PROD.nome, SUM(VEN.quantidade * VEN.preco) as faturamento,
    SUM(VEN.quantidade * PROD.preco) AS faturamento_tabela FROM curso-big-query-19140.belleza_verde_vendas.vendas VEN
    inner join curso-big-query-19140.belleza_verde_vendas.produtos PROD on VEN.id_produto = PROD.id_produto
    WHERE EXTRACT(YEAR FROM VEN.data) = 2022
    and VEN.id_produto = 11 and VEN.id_produto NOT IN (12, 13, 14)
    GROUP BY PROD.nome)
  SELECT nome, (((ieee_divide(faturamento, faturamento_tabela)) -1)* 100) as percentual FROM VENDAS_COMPARATIVAS)
SELECT nome, percentual, round(percentual,2) as percentual_round,
  trunc(percentual, 2) as percentual_trunc, floor(percentual) as percentual_inteiro,
  ceil(percentual) as percentual_acima, round(percentual, 0) as percentual_round_0
FROM VENDAS_ARRENDONDADAS;

select * from `belleza_verde_vendas.vendas` where id_produto = 11;
select * from `belleza_verde_vendas.produtos` where id_produto = 11;

#usando safe

select safe.sqrt(-144);

#usando safe para arrays

select id_produto, nome, materiasprimas, materiasprimas[safe_offset(0)] as primeira_materiaprima, 
       materiasprimas[safe_offset(1)] as segunda_materiaprima, materiasprimas[safe_offset(2)] as terceira_materiaprima, array_length(materiasprimas) as tamanho
from `belleza_verde_vendas.produtos`;


#Aplicando precisão numérica no cálculo

SELECT FaturamentoN, FaturamentoF from `belleza_verde_vendas.vendas` where id_produto not in (11, 12, 13, 14);

SELECT EXTRACT(YEAR FROM data) AS ANO, EXTRACT(MONTH FROM data) AS MES, SUM(FaturamentoN) AS FatN, SUM(FaturamentoF) AS FatF
FROM `belleza_verde_vendas.vendas` WHERE id_produto NOT IN(11, 12, 13, 14) GROUP BY ANO, MES;

SELECT EXTRACT(YEAR FROM data) AS ANO, EXTRACT(MONTH FROM data) AS MES, SUM(FaturamentoN) AS FatN, SUM(FaturamentoF) AS FatF,
       AVG(FaturamentoN) AS Media_FatN, AVG(FaturamentoF) AS Media_FatF
FROM `belleza_verde_vendas.vendas` WHERE id_produto NOT IN(11, 12, 13, 14) GROUP BY ANO, MES;

#Exercício de demonstração

SELECT 
  (1000.00) + (NUMERIC '10.00' / NUMERIC '3.00' * NUMERIC '3.00') AS saldoe_numeric,
  (1000.00) + (CAST(10.00 AS FLOAT64) / CAST(3.00 AS FLOAT64) * CAST(3.00 AS FLOAT64)) AS saldo_float;

#Obtendo o sinal de um número

#A função SIGN no BigQuery é usada para determinar o sinal de um número, indicando se o número é positivo, negativo ou zero. Essa função pode ser aplicada a valores numéricos, incluindo inteiros, floats e números decimais.


SELECT SIGN(-10) AS ResultadoNegativo, -- Retorna -1
       SIGN(0) AS ResultadoZero,      -- Retorna 0
       SIGN(15.5) AS ResultadoPositivo; -- Retorna 1

#Buscando um número aleatório

SELECT RAND(), RAND(), RAND();

#Usando RAND como um critério de busca aleatório de uma amostra de dados
#No exemplo abaixo, traz até 10% de registros aleatórios do total da base
SELECT * FROM `belleza_verde_vendas.vendas`
WHERE RAND() <= 0.1;

#Usando RAND para ordenar os registros de forma aleatória
SELECT * FROM `belleza_verde_vendas.vendas` ORDER BY RAND();

#Testando outras funções matemáticas

#Elevado a Potência
SELECT POW(2, 4);

#Geométrico: SIN, COS, TAN, ASIN, ACOS, ATAN, RADIANS, DEGREES

SELECT SIN(30) AS SENO, COS(30) AS COSENO, TAN(30) AS TANGENTE;

#Logaritmo: LN, LOG - não pode calcular para número negativo

SELECT LN(30) AS LOG_EULER, LOG(30) AS LOG_BASE10, LOG(30, 2) AS LOG_NORMAL;
SELECT SAFE.LOG(-1);

#Retorna o maior e menor número
SELECT GREATEST(10, 1, 3, 5, 8), LEAST(10, 1, 3, 5, 8);

#Overflow - como tratar
#isso dá overflow
SELECT SUM(quantidade) * SUM(quantidade) * SUM(quantidade) * SUM(quantidade) * SUM(quantidade)  FROM `belleza_verde_vendas.vendas`;

#O safe_multiply evita overflow e exibe null
SELECT SAFE_MULTIPLY(SUM(quantidade), SAFE_MULTIPLY(SUM(quantidade), SAFE_MULTIPLY(SUM(quantidade), SAFE_MULTIPLY(SUM(quantidade), SUM(quantidade)))))
FROM `belleza_verde_vendas.vendas`;

#MOD - obtém o resto de uma divisão -> pode ser usado para testar se um número é par ou ímpar

#EXEMPLO: somando 100 dias a frente e descobrir qual será o dia da semana
SELECT MOD((1 + 100), 7);

#Usando Range_Bucket para classificar faixas numéricas

SELECT MIN(FaturamentoF), MAX(FaturamentoF), AVG(FaturamentoF) FROM `belleza_verde_vendas.vendas`
WHERE id_produto NOT IN(11, 12, 13, 14);

#faixas de faturamento: 0 a 50, 50 a 100, 100 a 300, 300 a 500, 500 a 1000

WITH LIST_VENDA AS (
  SELECT id_venda, FaturamentoF FROM `belleza_verde_vendas.vendas`
  WHERE id_produto NOT IN(11, 12, 13, 14)
)
SELECT LIST_VENDA.id_venda, LIST_VENDA.FaturamentoF,
       RANGE_BUCKET(LIST_VENDA.FaturamentoF, [50.0, 100, 300.0, 500.0, 1000.0])
FROM LIST_VENDA;

WITH LIST_VENDA AS (
  SELECT id_venda, FaturamentoF FROM `belleza_verde_vendas.vendas`
  WHERE id_produto NOT IN(11, 12, 13, 14)
)
SELECT RANGE_BUCKET(LIST_VENDA.FaturamentoF, [50.0, 100, 300.0, 500.0, 1000.0]), COUNT(*)
FROM LIST_VENDA GROUP BY RANGE_BUCKET(LIST_VENDA.FaturamentoF, [50.0, 100, 300.0, 500.0, 1000.0]);

#Trabalhando com operadores lógicos

SELECT * FROM `belleza_verde_vendas.vendas` 
WHERE venda_vista != FALSE AND EXTRACT(YEAR FROM data) = 2022 AND id_produto = 1;

SELECT * FROM `belleza_verde_vendas.vendas` 
WHERE venda_vista = TRUE AND EXTRACT(YEAR FROM data) = 2022 AND id_produto = 1;

SELECT * FROM `belleza_verde_vendas.vendas` 
WHERE venda_vista AND EXTRACT(YEAR FROM data) = 2022 AND id_produto = 1;

SELECT * FROM `belleza_verde_vendas.vendas` 
WHERE (venda_vista AND EXTRACT(YEAR FROM data) = 2022 AND id_produto = 1) = TRUE;

SELECT id_venda, (venda_vista AND EXTRACT(YEAR FROM data) = 2022 AND id_produto = 1) AS expr_logica
FROM `belleza_verde_vendas.vendas` ;

with consulta as (
  SELECT id_venda, (venda_vista AND EXTRACT(YEAR FROM data) = 2022 AND id_produto = 1) AS expr_logica
  FROM `belleza_verde_vendas.vendas` 
)
select consulta.id_venda from consulta where consulta.expr_logica = TRUE;

#Usando expressões condicionais

#quando quantidade for nula é 1, quando preço for nulo é 5
SELECT id_venda, quantidade, preco, 
       (IF(quantidade IS NULL, 1, quantidade) * IF(preco IS NULL, 5, preco)) as faturamento
FROM `belleza_verde_vendas.vendas`
WHERE id_produto = 12;

#Conhecendo a função COALESCE
#Retorna o primeiro valor diferente de nulo de uma lista

SELECT COALESCE(1, 2, 3, 4);
SELECT COALESCE(NULL, 2, 3, 4);
SELECT COALESCE(NULL, NULL, 3, 4);

SELECT id_venda, quantidade, preco, 
       (preco * quantidade) as faturamento_original,
       (IF(quantidade IS NULL, 1, quantidade) * IF(preco IS NULL, 5, preco)) as faturamento_if,
       COALESCE(quantidade * preco, 1 * preco, quantidade * 5.0, 1 * 5.0) AS faturamento_coalesce
FROM `belleza_verde_vendas.vendas`
WHERE id_produto = 12;

#Trabalhando com conversão (CAST)

WITH VENDAS_ARREDONDADAS AS (
WITH VENDAS_COMPARATIVAS AS (
    SELECT PROD.nome, SUM(VEN.quantidade * VEN.preco) as faturamento,
    SUM(VEN.quantidade * PROD.preco) AS faturamento_tabela FROM
    `belleza_verde_vendas.vendas` VEN
    inner join
    `belleza_verde_vendas.produtos` PROD
    on VEN.id_produto = PROD.id_produto
    WHERE EXTRACT(YEAR FROM VEN.data) = 2022
    AND (VEN.id_produto = 2)
    GROUP BY PROD.nome
)
SELECT nome, ((IEEE_DIVIDE(faturamento, faturamento_tabela) -1)* 100)
as percentual FROM VENDAS_COMPARATIVAS)
SELECT nome, percentual FROM VENDAS_ARREDONDADAS;

SELECT * FROM `belleza_verde_vendas.produtos`;

WITH VENDAS_ARREDONDADAS AS (
WITH VENDAS_COMPARATIVAS AS (
    SELECT PROD.nome, SUM(VEN.quantidade * VEN.preco) as faturamento,
    SUM(VEN.quantidade * SAFE_CAST(PROD.precos AS FLOAT64)) AS faturamento_tabela FROM
    `belleza_verde_vendas.vendas` VEN
    inner join
    `belleza_verde_vendas.produtos` PROD
    on VEN.id_produto = PROD.id_produto
    WHERE EXTRACT(YEAR FROM VEN.data) = 2022
    AND (VEN.id_produto IN (1, 2))
    GROUP BY PROD.nome
)
SELECT nome, ((IEEE_DIVIDE(faturamento, faturamento_tabela) -1)* 100)
as percentual FROM VENDAS_COMPARATIVAS)
SELECT nome, percentual FROM VENDAS_ARREDONDADAS;


