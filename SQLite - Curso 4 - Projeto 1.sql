--01 - Qual é o número de Clientes que existem na base de dados ?
select count(*) from clientes;

--02 - Quantos produtos foram vendidos no ano de 2022 ?
select count(iv.produto_id) as qtd_produtos_2022
from itens_venda iv
join vendas v on iv.venda_id = v.id_venda
where strftime('%Y', v.data_venda) = '2022'

--03 - Qual a categoria que mais vendeu em 2022 ?
Select nome_categoria, MAX(vendas_categoria) as top_categoria_2022
FROM(
  select c.nome_categoria, COUNT(c.nome_categoria) as vendas_categoria
  from categorias c
  join produtos p on c.id_categoria = p.categoria_id
  join itens_venda iv on p.id_produto = iv.produto_id
  join vendas v on iv.venda_id = v.id_venda
  where strftime('%Y', v.data_venda) = '2022'
  group by c.nome_categoria)

--04 - Qual o primeiro ano disponível na base ?
select strftime('%Y', data_venda) as ano from vendas group by ano order by ano limit 1

--05 - Qual o nome do fornecedor que mais vendeu no primeiro ano disponível na base ?
--06 - Quanto ele vendeu no primeiro ano disponível na base de dados ?
select nome_fornecedor, MAX(vendas_fornecedor) as total_vendas from(
  select f.nome as nome_fornecedor, count(iv.produto_id) as vendas_fornecedor
  from fornecedores f
  join produtos p on f.id_fornecedor = p.fornecedor_id
  join itens_venda iv on p.id_produto = iv.produto_id
  join vendas v on iv.venda_id = v.id_venda
  where strftime('%Y', v.data_venda) = (select strftime('%Y', data_venda) as ano from vendas group by ano order by ano limit 1)
  group by f.nome
  order by vendas_fornecedor desc)

--07 - Quais as duas categorias que mais venderam no total de todos os anos ?
select c.nome_categoria, count(iv.produto_id) as qtd_vendas
from itens_venda iv
join vendas v on iv.venda_id = v.id_venda
join produtos p on iv.produto_id = p.id_produto
join categorias c on c.id_categoria = p.categoria_id
group by c.nome_categoria
order by qtd_vendas desc limit 2

--08 - Crie uma tabela comparando as vendas ao longo do tempo das duas categorias que mais
--venderam no total de todos os anos.
select nome_categoria,
sum(case when ano == '2020' then qtd_vendas else 0 end) as '2020',
sum(case when ano == '2021' then qtd_vendas else 0 end) as '2021',
sum(case when ano == '2022' then qtd_vendas else 0 end) as '2022',
sum(case when ano == '2023' then qtd_vendas else 0 end) as '2023'
from(
  select c.nome_categoria, strftime('%Y', v.data_venda) as ano, count(iv.produto_id) as qtd_vendas
  from itens_venda iv
  join vendas v on iv.venda_id = v.id_venda
  join produtos p on iv.produto_id = p.id_produto
  join categorias c on c.id_categoria = p.categoria_id
  where c.nome_categoria == 'Eletrônicos' or c.nome_categoria == 'Vestuário'
  group by c.nome_categoria, ano
  order by ano, c.nome_categoria) group by nome_categoria

--09 - Calcule a porcentagem de vendas por categorias no ano de 2022.

select c.nome_categoria, count(iv.produto_id) as qtd_vendas,
  round(100.0 * count(iv.produto_id) / (
      select count(*) from itens_venda iv
      join vendas v on v.id_venda = iv.venda_id
      where strftime('%Y', v.data_venda) == '2022'
  ), 2) || '%' as percentual_total
from itens_venda iv
join vendas v on v.id_venda = iv.venda_id
join produtos p on p.id_produto = iv.produto_id
join categorias c on c.id_categoria = p.categoria_id
where strftime('%Y', v.data_venda) == '2022'
group by c.nome_categoria

--10 - Crie uma métrica mostrando a porcentagem de vendas a mais que a melhor categoria
--tem em relação a pior no ano de 2022.
select max(qtd_vendas) as mais_vendas, min(qtd_vendas) as menos_vendas,
  round(((max(qtd_vendas) - min(qtd_vendas)) / min(qtd_vendas)) * 100.0, 2) || '%' as percentual_vendas_a_mais
from
  (select c.nome_categoria, count(iv.produto_id) as qtd_vendas
  from itens_venda iv
  join vendas v on iv.venda_id = v.id_venda
  join produtos p on iv.produto_id = p.id_produto
  join categorias c on c.id_categoria = p.categoria_id
  where strftime('%Y', v.data_venda) == '2022'
  group by c.nome_categoria
  order by qtd_vendas)