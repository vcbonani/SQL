--1) Crie uma tabela chamada funcionarios com as seguintes colunas: id (int, chave primária), nome (varchar(100)), departamento (varchar(100)) e salario (float). Em seguida, insira os seguintes registros de funcionários na tabela:

create table funcionarios(
  id_funcionarios INT PRIMARY KEY,
  nome_funcionarios VARCHAR(100),
  departamento_funcionarios VARCHAR(100),
  salario_funcionarios FLOAT
  );
  
insert into funcionarios (id_funcionarios, nome_funcionarios, departamento_funcionarios, salario_funcionarios)
values
(1,'Heitor Vieira','Financeiro',4959.22),
(2,'Daniel Campos','Vendas',3884.44),
(3,'Luiza Dias','TI',8205.78),
(4,'Davi Lucas Moraes','Financeiro',8437.02),
(5,'Pietro Cavalcanti','TI',4946.88),
(6,'Evelyn da Mata','Vendas',5278.88),
(7,'Isabella Rocha','Marketing',4006.03),
(8,'Sra. Manuela Azevedo','Vendas',6101.88),
(9,'Brenda Cardoso','TI',8853.34),
(10,'Danilo Souza','TI',8242.14);

--2) Selecione todos os campos de todos os registros na tabela funcionarios.

select * from funcionarios;

--3) Na tabela funcionarios, selecione os nomes dos funcionários que trabalham no departamento de "Vendas".

select * from funcionarios where departamento_funcionarios = 'Vendas';

--4) Selecione os funcionários da tabela funcionarios cujo salário seja maior que 5000.

select * from funcionarios where salario_funcionarios > 5000;

--5) Na tabela funcionarios, selecione todos os departamentos distintos.

select DISTINCT departamento_funcionarios from funcionarios;

--6) Atualize o salário dos funcionários do departamento de "TI" para 7500 na tabela funcionarios.

select * from funcionarios where departamento_funcionarios = 'TI';
update funcionarios set salario_funcionarios = 7500 where departamento_funcionarios = 'TI';

--7) Delete da tabela funcionarios todos os registros de funcionários que ganham menos de 4000.

select * from funcionarios where salario_funcionarios < 4000;
delete from funcionarios where salario_funcionarios < 4000;

--8) Selecione os nomes e salários dos funcionários que trabalham no departamento de "Vendas" e cujo salário seja maior ou igual a 6000.

select nome_funcionarios, salario_funcionarios from funcionarios where departamento_funcionarios = 'Vendas' AND salario_funcionarios > 6000;

--9) Crie uma tabela chamada projetos com as colunas: id_projeto (int, chave primária), nome_projeto (varchar(100)), id_gerente (int, referência a id na tabela funcionarios). Insira 3 registros na tabela projetos e, em seguida, selecione todos os projetos cujo id_gerente seja igual a 2.

create table projetos(
  id_projeto INT PRIMARY KEY, 
  nome_projeto VARCHAR(100),
  id_gerente INT,
  FOREIGN key (id_gerente) REFERENCES funcionarios(id_funcionarios)
  );

insert into projetos (id_projeto, nome_projeto, id_gerente)
VALUES
(1,'Prédio novo', 2),
(2, 'Sistema novo', 2),
(3, 'Ampliação de CD', 1);

select * from projetos where id_gerente = 2;

--10) Remova a tabela funcionarios do banco de dados.

drop table funcionarios;




