#alterando o nome de uma coluna

create or replace table `belleza_verde_vendas_hom.clientes` as
select id_cliente, nome_cliente as nome, email, localizacao, id_vendedor, cep
from `belleza_verde_vendas_hom.clientes`;

select * from `belleza_verde_vendas_hom.clientes`;

#incluindo uma coluna nova

alter table `belleza_verde_vendas_hom.materiasprimas`
add column id_fornecedor int64;

#inserindo registros

insert into `belleza_verde_vendas_hom.vendedores`
(id_vendedor, nome) values (1, 'Carlos Augusto');

select * from `belleza_verde_vendas_hom.vendedores`;

insert into `belleza_verde_vendas_hom.vendedores`
(id_vendedor, nome) values (2, 'João Almeida'), (5, 'Katia Machado');

#alterando e excluindo linhas

update `belleza_verde_vendas_hom.vendedores`
set nome = 'Joana Almeida' where id_vendedor = 2;

delete from `belleza_verde_vendas_hom.vendedores`
where id_vendedor = 5;

#deletando todas as linhas de uma tabela
delete from `belleza_verde_vendas_hom.vendedores` where 1 = 1;

#carregando dados de uma tabela para outra

select * from `belleza_verde_vendas_hom.vendedores`;

insert into `belleza_verde_vendas_hom.vendedores`
(id_vendedor, nome)
select id_vendedor, nome from `belleza_verde_vendas_hom.tmp_vendedores1`;

insert into `belleza_verde_vendas_hom.vendedores`
(id_vendedor, nome)
select id_vendedor, nome from `belleza_verde_vendas_hom.tmp_vendedores2`;

# como resolver casos onde o id é igual e onde o conteúdo de um registro anteriormente gravado foi alterado

select * from `belleza_verde_vendas_hom.vendedores`;

# 1 - garantir que a tabela está vazia
delete from `belleza_verde_vendas_hom.vendedores` where 1 = 1;

# 2 - adicionar os primeiros registros
insert into `belleza_verde_vendas_hom.vendedores`
(id_vendedor, nome)
select id_vendedor, nome from `belleza_verde_vendas_hom.tmp_vendedores1`;

# 3 - carregar dados com id que não existem na tabela (só registros com id novo) - evita duplicidade
insert into `belleza_verde_vendas_hom.vendedores`
(id_vendedor, nome)
select id_vendedor, nome from `belleza_verde_vendas_hom.tmp_vendedores2`
where id_vendedor not in (select id_vendedor from `belleza_verde_vendas_hom.vendedores`);

# outra forma de fazer

# 1 - garantir que a tabela está vazia
delete from `belleza_verde_vendas_hom.vendedores` where 1 = 1;

# 2 - adicionar os primeiros registros
insert into `belleza_verde_vendas_hom.vendedores`
(id_vendedor, nome)
select id_vendedor, nome from `belleza_verde_vendas_hom.tmp_vendedores1`;

# 3 - usar comando merge para incluir registro novo / atualizar registro existente
merge into `belleza_verde_vendas_hom.vendedores` alvo
using `belleza_verde_vendas_hom.tmp_vendedores2` fonte
on alvo.id_vendedor = fonte.id_vendedor
when matched then
    update set id_vendedor = fonte.id_vendedor, nome = fonte.nome
when not matched then
    insert (id_vendedor, nome) values (fonte.id_vendedor, fonte.nome);

select * from `belleza_verde_vendas_hom.vendedores`;

-- salvo o json da tabela tmp_vendedores1, 1 vez só
-- apagar conteúdo da tabela tmp_vendedores1
-- carregar os dados dos novos vendedores na tabela tmp_vendedores1 vindo do storage
-- efetuar o merge

delete from `belleza_verde_vendas_hom.vendedores` where 1 = 1;
select * from `belleza_verde_vendas_hom.tmp_vendedores1`;
select * from `belleza_verde_vendas_hom.vendedores`;














