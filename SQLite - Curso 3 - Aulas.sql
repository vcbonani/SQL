--buscar informações em comum de várias tabelas e combinar numa visualização única
select nome, rua, bairro, cidade, estado, cep from colaboradores
union all --o union all traz inclusive os registros que podem ter informações repetidas
select nome, rua, bairro, cidade, estado, cep from fornecedores;

--usando except -> traz da primeira tabela aquilo que não existe na segunda tabela
--os bairros da tabela colaboradores mostrados não existem na tabela fornecedores
select bairro from colaboradores
except
select bairro from fornecedores;

--usando intersect -> traz da primeira e da segunda tabela o que é comum a ambas
select bairro from colaboradores
INTERSECT
select bairro from fornecedores;

--combinando as informações com condicional usando subconsulta
select nome from produtos where id = (
select idproduto from itenspedidos where precounitario = (
select MAX(precounitario) from itenspedidos));

select nome, telefone from clientes where id = (
select idcliente from pedidos where id = 1);

--o comando IN permite montar consultas quando são retornados vários registros
--no exemplo, trazemos os nomes de vários clientes que fizeram no pedido no mês 01
select nome from clientes where id in(
select idcliente from pedidos where strftime('%m', datahorapedido) = '01');

--esta consulta traz os produtos com preço acima da média usando HAVING
select nome, preco from produtos group by nome, preco having preco > (
  select avg(preco) from produtos);

--o having é usado junto com funções agregadoras (count, max, min, avg, etc) e com o group by
select bairro, count(*) from colaboradores group by bairro having count(*) > 1;

--inner join
--trazer o nome de quem fez os pedidos
select c.nome, p.id, p.datahorapedido from clientes c
inner join pedidos p on c.id = p.idcliente;

select * from produtos;
insert into produtos (id, nome, descricao, preco, categoria) VALUES
(31, 'Lasanha à bolonhesa', 'Deliciosa lasanha caseir com molho bolonhesa', 12.50, 'Almoço');

--right join
--quais produtos já foram vendidos ou não no mês 10
--misturando o uso de subconsulta e o right join
select x.idpedido, x.idproduto, p.nome 
from
    (select i.idpedido, i.idproduto from pedidos p join itenspedidos i 
     on p.id = i.idpedido where strftime('%m', p.datahorapedido) = '10') x
right join produtos p

--desafio
--encontrando clientes sem pedidos
select p.id, c.nome from pedidos p
right join clientes c on p.idcliente = c.id WHERE p.id is null
on p.id = x.idproduto

INSERT INTO Clientes (id, Nome, Telefone, Email, Endereco)
VALUES (28, 'João Santos', '215555678', 'joao.santos@email.com', 'Avenida Principal, 456, Cidade B'),
       (29, 'Carla Ferreira', '315557890', 'carla.ferreira@email.com', 'Travessa das Ruas, 789, Cidade C');

--left join
--buscar os clientes que não possuem pedidos registrados
select c.nome, x.id
from clientes c
left join (
   select p.id, p.idcliente from pedidos p
  where strftime('%m', p.datahorapedido) = '07'
) x
on c.id = x.idcliente
where x.id ISNULL

--full join
--verifica os pedidos por clientes e vice-versa
--se não tiver pedido, aparece null; se não tiver cliente, aparece null
select c.nome, p.id
from clientes c
full join pedidos p
on c.id = p.idcliente
where c.id ISNULL OR p.id isnull

--calcular o valor total dos pedidos
select p.id as id_pedido, p.datahorapedido, c.nome, sum(ip.precounitario) as total_pedido
from clientes c
join pedidos p on c.id = p.idcliente
join itenspedidos ip on p.id = ip.idpedido
group by p.id

--desafio:total de pedidos por cliente
select c.nome, count(p.id) as quantidade_pedidos, SUM(ip.precounitario) as valor_total
from pedidos p
join clientes c on p.idcliente = c.id
join itenspedidos ip on p.id = ip.idpedido
group by c.nome
order by c.nome

--criação de views
create view ViewCliente as 
select nome, endereco from clientes

select * from ViewCliente

create view ViewTotalPedidos AS
select p.id as id_pedido, p.datahorapedido, c.nome, sum(ip.precounitario) as total_pedido
from clientes c
join pedidos p on c.id = p.idcliente
join itenspedidos ip on p.id = ip.idpedido
group by p.id, c.nome

select * from ViewTotalPedidos
where total_pedido >= 10 and total_pedido < 20 and strftime('%m', datahorapedido) = '08'

--removendo uma view
drop view ViewCliente

--calcular valor faturamento diário
insert into faturamentoDiario (dia, faturamentototal)
select date(p.datahorapedido) as dia, sum(ip.precounitario) as faturamento_diario
from pedidos p 
join itenspedidos ip on p.id = ip.idpedido
group by dia
order by dia

select * from faturamentoDiario

--triggers
create table faturamentoDiario(
  dia date,
  faturamentoTotal decimal(10,2)
)

create TRIGGER CalculaFaturamentoDiario
after insert on itenspedidos
for each ROW
BEGIN
  delete from faturamentoDiario;
  insert into faturamentoDiario (dia, faturamentototal)
  select date(p.datahorapedido) as dia, sum(ip.precounitario) as faturamento_diario
  from pedidos p 
  join itenspedidos ip on p.id = ip.idpedido
  group by dia
  order by dia;
end;

INSERT INTO Pedidos(ID, IDCliente, DataHoraPedido, Status)
VALUES (451, 27, '2023-10-07 14:30:00', 'Em Andamento');
INSERT INTO ItensPedidos(IDPedido, IDProduto, Quantidade, PrecoUnitario)
VALUES (451, 14, 1, 6.0),
         (451, 13, 1, 7.0);
INSERT INTO Pedidos (ID, IDCliente, DataHoraPedido, Status) 
VALUES (452, 28, '2023-10-07 14:35:00', 'Em Andamento');
INSERT INTO ItensPedidos (IDPedido, IDProduto, Quantidade, PrecoUnitario) VALUES (452, 10, 1, 5.0),
         (452, 31, 1, 12.50);

select * from faturamentoDiario

--o sqllite online não faz validação de chave estrangeira, por isso usa-se o comando PRAGMA para ativar isso
PRAGMA foreign_keys = ON

--atualizando informações das tabelas
select * from produtos
update produtos set preco = 13.0 where id = 31
update produtos set descricao = 'Croissant recheado com amêndoa.' where id = 28

--excluindo dados
select * from colaboradores
delete from colaboradores where id = 3

select * from clientes
delete from clientes where id = 27
--o id do cliente é uma chave estrangeira, com a eliminação do registro, 
--os registros de pedidos também foram excluídos

select * from pedidos
update pedidos set status = 'Concluído' where status = 'Em Andamento'

--transações
--bloco de execução onde ele só é concluído se todos funcionarem com sucesso
begin TRANSACTION;
select * from clientes
select * from pedidos
update pedidos set status = 'Concluído'
delete from clientes
rollback; --o rollback desfaz todas as alterações depois do begin transaction
commit; --o commit efetiva todas as alterações depois do begin transaction

insert into produtos (id, nome, descricao, preco, categoria) VALUES
(32, 'Lasanha à bolonhesa', 'Deliciosa lasanha caseir com molho bolonhesa', 12.50, 'Almoço');

--Mão na massa: hora da prática

--Traga todos os dados da cliente Maria Silva.
select * from clientes WHERE nome = 'Maria Silva'

--Busque o ID do pedido e o ID do cliente dos pedidos onde o status esteja como entregue
select id as idPedido, idcliente from pedidos where status = 'Entregue'

--Retorne todos os produtos onde o preço seja maior que 10 e menor que 15.
select * from produtos where preco > 10 and preco < 15

--Busque o nome e cargo dos colaboradores que foram contratados entre 2022-01-01 e 2022-06-30
select nome, cargo, datacontratacao from colaboradores where datacontratacao between '2022-01-01' and '2022-06-30'

--Recupere o nome do cliente que fez o primeiro pedido.
select c.nome
from clientes c
join pedidos p on c.id = p.idcliente
where p.id = 1

--Liste os produtos que nunca foram pedidos.
select pr.id, pr.nome, ip.idpedido
from produtos pr
left join itenspedidos ip on pr.id = ip.idproduto
where ip.idpedido isnull

--Liste os nomes dos clientes que fizeram pedidos entre 2023-01-01 e 2023-12-31.
select DISTINCT c.nome
from clientes c
join pedidos p on c.id = p.idcliente
where date(datahorapedido) BETWEEN '2023-01-01' and '2023-12-31'
order by c.nome

--Recupere os nomes dos produtos que estão em menos de 15 pedidos.
select nome from produtos where id in (
select  idproduto
from itenspedidos
group by idproduto
having count(idpedido) < 15)

--Liste os produtos e o ID do pedido que foram realizados pelo cliente "Pedro Alves" ou pela cliente "Ana Rodrigues".
select pp.idpedido, p.nome as nomeProduto
from produtos p
join 
(select idproduto, idpedido from itenspedidos where idpedido in(
select id from pedidos where idcliente in(
select id from clientes where nome = 'Pedro Alves' or nome = 'Ana Rodrigues'))) as pp
on pp.idproduto = p.id
order by pp.idpedido

--Recupere o nome e o ID do cliente que mais comprou(valor) no Serenatto.
select c.id, c.nome
from clientes c
join pedidos p on c.id = p.idcliente
join
(select idpedido, max(ip.totalpedido) from
(select idpedido, sum(precounitario) as totalpedido from itenspedidos group by idpedido) as ip) as ipmax
on p.id = ipmax.idpedido