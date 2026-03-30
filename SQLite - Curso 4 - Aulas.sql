select * from categorias;
select * from produtos;

--obter a quantidade de registros de produtos
select count(*) from produtos;

--obter a quantidade de registros de vendas
select count(*) as Total, 'Vendas' from vendas;

--desafio: gerar os totais de registros de cada tabela
select count(*) as Total, 'Categorias' from categorias
union all
select count(*) as Total, 'Clientes' from clientes
union all
SELECT count(*) as Total, 'Fornecedores' from fornecedores
union all
select count(*) as Total, 'Itens_Venda' from itens_venda
union all
select count(*) as Total, 'Marcas' from marcas
union all
select count(*) as Total, 'Produtos' from produtos
union all
select count(*) as Total, 'Vendas' from vendas

--Desafio: ajuste de valores em bases de produtos
select * from produtos where nome_produto = 'Bola de Futebol' and (preco <20 or preco > 100)
update produtos set preco = abs(random()) % 80 + 20 where nome_produto = 'Bola de Futebol' and (preco < 20 or preco > 100)

select * from produtos where nome_produto = 'Chocolate' and (preco <10 or preco > 50)
update produtos set preco = abs(random()) % 40 + 10 where nome_produto = 'Chocolate' and (preco <10 or preco > 50)

select * from produtos where nome_produto = 'Celular' and (preco < 80 or preco > 5000)
update produtos set preco = abs(random()) % 4920 + 80 where nome_produto = 'Celular' and (preco < 80 or preco > 5000)

select * from produtos where nome_produto = 'Livro de Ficção' and (preco < 10 or preco > 200)
update produtos set preco = abs(random()) % 190 + 10 where nome_produto = 'Livro de Ficção' and (preco < 10 or preco > 200)

select * from produtos where nome_produto = 'Camisa' and (preco < 80 or preco > 200)
update produtos set preco = abs(random()) % 120 + 80 where nome_produto = 'Camisa' and (preco < 80 or preco > 200)

select * from categorias;
select * from fornecedores;
select * from marcas;

select count(*) from produtos;
select count(*) as vendas_totais from vendas;

select * from vendas limit 100;

select distinct data_venda from vendas order by data_venda;
select DISTINCT strftime('%Y', data_venda) as ano from vendas order by ano;

--somando as vendas por ano
select strftime('%Y', data_venda) as ano, strftime('%m', data_venda) as mes,
count(id_venda) as total_vendas from vendas group by ano, mes order by ano;

--filtrando as vendas para trazer somente os meses de janeiro, novembro e dezembro
select strftime('%Y', data_venda) as ano, strftime('%m', data_venda) as mes, count(id_venda) as total_vendas 
from vendas where mes = '01' or mes = '12' or mes = '11'
group by ano, mes order by ano;

--demandas para análise:
--papel do fornecedores na black friday
select strftime('%Y/%m', v.data_venda) as dt_venda, f.nome as nome_fornecedor, count(iv.produto_id) as qtd_vendas
from itens_venda iv
join vendas v on iv.venda_id = v.id_venda
join produtos p on iv.produto_id = p.id_produto
join fornecedores f on p.fornecedor_id = f.id_fornecedor
where strftime('%Y/%m', v.data_venda) = '2022/11'
group by nome_fornecedor, dt_venda
order by qtd_vendas desc;

select sum(qtd_vendas)
from(
  select strftime('%Y/%m', v.data_venda) as dt_venda, f.nome as nome_fornecedor, count(iv.produto_id) as qtd_vendas
  from itens_venda iv
  join vendas v on iv.venda_id = v.id_venda
  join produtos p on iv.produto_id = p.id_produto
  join fornecedores f on p.fornecedor_id = f.id_fornecedor
  group by nome_fornecedor, dt_venda
  order by qtd_vendas desc
)
  
--categoria de produtos na black friday
select strftime('%Y/%m', v.data_venda) as dt_venda, c.nome_categoria, count(iv.produto_id) as qtd_venda
from itens_venda iv
join vendas v on iv.venda_id = v.id_venda
join produtos p on iv.produto_id = p.id_produto
join categorias c on p.categoria_id = c.id_categoria
where strftime('%m', v.data_venda) = '11'
group by c.nome_categoria, dt_venda
order by dt_venda, qtd_venda

--trazer as informações de pedidos de um fornecedor específico
select strftime('%Y/%m', v.data_venda) as dt_venda, count(iv.produto_id) as qtd_vendas
from itens_venda iv
join vendas v on iv.venda_id = v.id_venda
join produtos p on iv.produto_id = p.id_produto
join fornecedores f on p.fornecedor_id = f.id_fornecedor
where f.nome = 'NebulaNetworks'
group by dt_venda
order by dt_venda

select dt_venda, 
sum(case when nome_fornecedor == 'NebulaNetworks' then qtd_vendas else 0 end) as qtd_vendas_nebula,
sum(case when nome_fornecedor == 'AstroSupply' then qtd_vendas else 0 end) as qtd_vendas_astro,
sum(case when nome_fornecedor == 'HorizonDistributors' then qtd_vendas else 0 end) as qtd_vendas_horizon
from(
  select strftime('%Y/%m', v.data_venda) as dt_venda, f.nome as nome_fornecedor, count(iv.produto_id) as qtd_vendas
  from itens_venda iv
  join vendas v on iv.venda_id = v.id_venda
  join produtos p on iv.produto_id = p.id_produto
  join fornecedores f on p.fornecedor_id = f.id_fornecedor
  where f.nome = 'NebulaNetworks' or f.nome = 'AstroSupply' or f.nome = 'HorizonDistributors'
  group by nome_fornecedor, dt_venda
  order by dt_venda)
group by dt_venda


--porcentagem das categorias

--view para obter o total das vendas
create view view_qtd_total_Vendas as
select count(*) as qtd_vendas
FROM itens_venda


--calcula o percentual de vendas de categoria em relação ao total da empresa
select nome_categoria, qtd_venda, 
  round(100.0 * qtd_venda/(select * from view_qtd_total_Vendas),2) || '%' as percentual
from(
  select c.nome_categoria, count(iv.produto_id) as qtd_venda
  from itens_venda iv
  join vendas v on iv.venda_id = v.id_venda
  join produtos p on iv.produto_id = p.id_produto
  join categorias c on p.categoria_id = c.id_categoria
  group by c.nome_categoria
  order by qtd_venda desc
)

--Mão na massa: calculando a participação de mercado de marcas e fornecedores

--participação de mercado das marcas
select nome_marca, qtd_venda, 
  round(100.0 * qtd_venda/(select * from view_qtd_total_Vendas),2) || '%' as percentual
from(
  select m.nome as nome_marca, count(iv.produto_id) as qtd_venda
  from itens_venda iv
  join vendas v on iv.venda_id = v.id_venda
  join produtos p on iv.produto_id = p.id_produto
  join marcas m on p.marca_id = m.id_marca
  group by m.nome
  order by qtd_venda desc
)

--participação de mercado dos fornecedores
select nome_fornecedor, qtd_venda, 
  round(100.0 * qtd_venda/(select * from view_qtd_total_Vendas),2) || '%' as percentual
from(
  select f.nome as nome_fornecedor, count(iv.produto_id) as qtd_venda
  from itens_venda iv
  join vendas v on iv.venda_id = v.id_venda
  join produtos p on iv.produto_id = p.id_produto
  join fornecedores f on p.fornecedor_id = f.id_fornecedor
  group by f.nome
  order by qtd_venda desc
)

--análise de sazonalidade

-- quadro geral de vendas
select strftime('%Y/%m', data_venda) as ano_mes, count(*) as qtd_vendas 
from vendas group by ano_mes order by ano_mes

--colocando a soma dos anos como colunas
select mes,
sum(case when ano == '2020' then qtd_vendas else 0 end) as '2020',
sum(case when ano == '2021' then qtd_vendas else 0 end) as '2021',
sum(case when ano == '2022' then qtd_vendas else 0 end) as '2022',
sum(case when ano == '2023' then qtd_vendas else 0 end) as '2023'
from(
  select strftime('%m', data_venda) as mes, strftime('%Y', data_venda) as ano, count(*) as qtd_vendas 
  from vendas group by mes, ano order by mes
)  group by mes

--Métricas de vendas

--média quantidade de vendas na black friday, quantidade de vendas ano atual

with media_vendas_anteriores as (
  select avg(qtd_vendas) as media_vendas_bf --média vendas black friday
  from(
  select strftime('%Y', v.data_venda) as ano, count(*) as qtd_vendas from vendas v --total vendas por black friday
  where strftime('%m', v.data_venda) == '11' and strftime('%Y', v.data_venda) != '2022'
  group by ano
)), vendas_atual as(
  select qtd_vendas as qtd_vendas_atual --vendas black friday atual (2022)
  from(
  select strftime('%Y', v.data_venda) as ano, count(*) as qtd_vendas from vendas v --total vendas por black friday
  where strftime('%m', v.data_venda) == '11' and strftime('%Y', v.data_venda) == '2022'
  group by ano
 ))
 select mva.media_vendas_bf, va.qtd_vendas_atual,
 round(((va.qtd_vendas_atual - mva.media_vendas_bf) / mva.media_vendas_bf) * 100.0, 2) || '%' as percentual
 --o percentual representa o quanto as vendas de 2022 superaram a média das black fridays anteriores
from vendas_atual va, media_vendas_anteriores mva

