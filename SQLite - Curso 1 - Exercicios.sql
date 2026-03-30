select * from tabelafornecedores;

select * from tabelafornecedores WHERE país_de_origem = 'China';

select DISTINCT país_de_origem from tabelafornecedores;

select DISTINCT cliente from tabelapedidos;

--Liste todos os IDs únicos dos produtos vendidos pela empresa, ou seja, uma lista de produtos distintos.
--Utilize a cláusula DISTINCT para garantir que os IDs dos produtos sejam únicos.
select DISTINCT id_produto from tabelavendasdesafioaula1;

--Identifique os clientes que se cadastraram na empresa antes de 2020. Liste o nome e a data de cadastro desses
--clientes. Utilize a cláusula WHERE para filtrar os registros.
select nome_do_cliente, data_de_cadastro from tabelaclientesdesafioaula1 where CAST(substr(data_de_cadastro,1,4) as INTEGER) < 2020;

CREATE TABLE tabelaclientes (ID_cliente INT PRIMARY KEY, 
                             Nome_cliente VARCHAR(250),
                             Informacoes_contato VARCHAR(250))
                             
ALTER TABLE tabelaclientes ADD COLUMN Endereco_cliente VARCHAR(250)

drop table 

create table tabelacategorias (ID_categoria INT PRIMARY KEY,
                               nome_categoria VARCHAR(250),
                               descricao_categoria TEXT)
                               
create table tabelaprodutos (
  id_produto INT PRIMARY KEY,
  nome_produto VARCHAR(250),
  descricao_produto TEXT,
  categoria_produto INT,
  preco_compra DECIMAL(10,2),
  unidade VARCHAR(50),
  fornecedor_produto INT,
  data_de_inclusao DATE,
  FOREIGN KEY (categoria_produto) REFERENCES tabelacategorias(id_categoria),
  FOREIGN KEY (fornecedor_produto) REFERENCES tabelafornecedores(id)
)

insert into tabelaclientes (
  id_cliente,
  nome_cliente,
  informacoes_contato,
  endereco_cliente
  )
  values
    (1, 'Jair Jairzinho', 'jair_jairzinho@email.com', 'Rua Jacarepaguá, 200, Jd Maravilha, São Paulo')
    
 insert into tabelaclientes (id_cliente, nome_cliente, informacoes_contato, endereco_cliente)
  values
    (2, 'Amorim Amorinho', 'amorim_amorinho@email.com', 'Rua Jacareí, 20, Jd Sul, São Carlos'),
    (3, 'Machado Achado', 'machado@email.com', 'Rua Goiás, 30, Jd Norte, Santo André'),
    (4, 'Gabriela Luz', 'gabriela_luz@email.com', 'Avenida Aranha, 22, Jd Mato, Guarulhos')
    
insert into tabelaclientes (id_cliente, nome_cliente, informacoes_contato, endereco_cliente) VALUES
(5, 'Patrícia Lima', 'patricia.lima@email.com', 'Rua das Flores, 123'),
(6, 'Rodrigo Almeida', 'rodrigo.almeida@email.com', 'Avenida Central, 456'),
(7, 'André Oliveira', 'andre.oliveira@email.com', 'Travessa do Sol, 789'),
(8, 'Isabela Rodrigues', 'isabela.rodrigues@email.com', 'Rua da Paz, 321'),
(9, 'Ricardo Sousa', 'ricardo.sousa@email.com', 'Alameda dos Sonhos, 654'),
(10, 'Luana Gomes', 'luana.gomes@email.com', 'Praceta das Estrelas, 987'),
(11, 'Juliano Costa', 'juliano.costa@email.com', 'Av. Principal, 234'),
(12, 'Sandra Ferreira', 'sandra.ferreira@email.com', 'Rua da Liberdade, 567'),
(13, 'Roberto Barbosa', 'roberto.barbosa@email.com', 'Rua da Esquina, 432'),
(14, 'Alice Santos', 'alice.santos@email.com', 'Largo da Amizade, 765'),
(15, 'Gustavo Lima', 'gustavo.lima@email.com', 'Avenida das Árvores, 876'),
(16, 'Carla Silva', 'carla.silva@email.com', 'Travessa das Aves, 345'),
(17, 'Daniel Oliveira', 'daniel.oliveira@email.com', 'Alameda dos Bosques, 678'),
(18, 'Luciana Almeida', 'luciana.almeida@email.com', 'Rua das Colinas, 123'),
(19, 'Fernando Pereira', 'fernando.pereira@email.com', 'Avenida das Ondas, 987'),
(20, 'Marina Lima', 'marina.lima@email.com', 'Praceta dos Girassóis, 456'),
(21, 'Lucas Rodrigues', 'lucas.rodrigues@email.com', 'Rua das Montanhas, 321'),
(22, 'Adriana Sousa', 'adriana.sousa@email.com', 'Travessa dos Rios, 654'),
(23, 'Eduardo Gomes', 'eduardo.gomes@email.com', 'Avenida das Pedras, 789'),
(24, 'Marcia Costa', 'marcia.costa@email.com', 'Largo das Praias, 234'),
(25, 'José Silva', 'jose.silva@email.com', 'Av. dos Ventos, 432'),
(26, 'Beatriz Alves', 'beatriz.alves@email.com', 'Rua dos Coqueiros, 765'),
(27, 'André Santos', 'andre.santos@email.com', 'Avenida dos Lagos, 876'),
(28, 'Carolina Lima', 'carolina.lima@email.com', 'Travessa das Neves, 345'),
(29, 'Fábio Rodrigues', 'fabio.rodrigues@email.com', 'Alameda dos Campos, 678'),
(30, 'Larissa Pereira', 'larissa.pereira@email.com', 'Rua dos Bosques, 123')

INSERT INTO tabelaprodutos (id_produto, nome_produto, descricao_produto,   categoria_produto, preco_compra, unidade, fornecedor_produto,data_de_inclusao) VALUES
(1, 'Smartphone X', 'Smartphone de última geração', 1, 699.99, 'Unidade', 1, '2023-08-01'),
(2, 'Notebook Pro', 'Notebook poderoso com tela HD', 2, 1199.99, 'Unidade', 2, '2023-08-02'),
(3, 'Tablet Lite', 'Tablet compacto e leve', 3, 299.99, 'Unidade', 3, '2023-08-03'),
(4, 'TV LED 55"', 'TV LED Full HD de 55 polegadas', 4, 599.99, 'Unidade', 4, '2023-08-04'),
(5, 'Câmera DSLR', 'Câmera digital DSLR com lente intercambiável', 5, 699.99, 'Unidade', 5, '2023-08-05'),
(6, 'Impressora Laser', 'Impressora laser de alta qualidade', 6, 349.99, 'Unidade', 6, '2023-08-06'),
(7, 'Mouse Óptico', 'Mouse óptico sem fio', 7, 19.99, 'Unidade', 7, '2023-08-07'),
(8, 'Teclado sem Fio', 'Teclado sem fio ergonômico', 8, 39.99, 'Unidade', 8, '2023-08-08'),
(9, 'Headphones Estéreo', 'Headphones estéreo com cancelamento de ruído', 9, 149.99, 'Unidade', 9, '2023-08-09'),
(10, 'Smartwatch', 'Smartwatch com monitor de frequência cardíaca', 10, 199.99, 'Unidade', 10, '2023-08-10'),
(11, 'Monitor 24"', 'Monitor LED Full HD de 24 polegadas', 11, 149.99, 'Unidade', 11, '2023-08-11'),
(12, 'HD Externo 1TB', 'HD Externo portátil de 1TB', 12, 79.99, 'Unidade', 12, '2023-08-12'),
(13, 'Drone DJI', 'Drone DJI com câmera 4K', 13, 799.99, 'Unidade', 13, '2023-08-13'),
(14, 'Console de Jogos', 'Console de jogos de última geração', 14, 299.99, 'Unidade', 14, '2023-08-14'),
(15, 'Fones de Ouvido Bluetooth', 'Fones de ouvido Bluetooth com estojo de carregamento', 15, 59.99, 'Unidade', 15, '2023-08-15'),
(16, 'Projetor HD', 'Projetor HD de alta definição', 16, 499.99, 'Unidade', 16, '2023-08-16'),
(17, 'Impressora Multifuncional', 'Impressora multifuncional com scanner', 6, 249.99, 'Unidade', 6, '2023-08-17'),
(18, 'Notebook Ultrafino', 'Notebook ultrafino com SSD rápido', 2, 999.99, 'Unidade', 2, '2023-08-18'),
(19, 'Mouse Gamer', 'Mouse gamer com iluminação RGB', 7, 49.99, 'Unidade', 7, '2023-08-19'),
(20, 'Câmera de Ação', 'Câmera de ação à prova d''água', 5, 129.99, 'Unidade', 5, '2023-08-20'),
(21, 'Tablet Profissional', 'Tablet profissional para designers', 3, 499.99, 'Unidade', 3, '2023-08-21'),
(22, 'Monitor Curvo', 'Monitor LED curvo de 32 polegadas', 11, 299.99, 'Unidade', 11, '2023-08-22'),
(23, 'Teclado Mecânico', 'Teclado mecânico para jogos', 8, 89.99, 'Unidade', 8, '2023-08-23'),
(24, 'Console Portátil', 'Console de jogos portátil', 14, 199.99, 'Unidade', 14, '2023-08-24'),
(25, 'HD Externo 2TB', 'HD Externo portátil de 2TB', 12, 109.99, 'Unidade', 12, '2023-08-25'),
(26, 'Kit de Caixas de Som', 'Kit de caixas de som estéreo', 17, 29.99, 'Unidade', 17, '2023-08-26'),
(27, 'Câmera de Segurança', 'Câmera de segurança com visão noturna', 18, 79.99, 'Unidade', 18, '2023-08-27'),
(28, 'Projetor Mini', 'Projetor mini portátil', 16, 199.99, 'Unidade', 16, '2023-08-28'),
(29, 'Impressora a Jato de Tinta', 'Impressora a jato de tinta colorida', 6, 89.99, 'Unidade', 6, '2023-08-29'),
(30, 'Servidor de Rede', 'Servidor de rede empresarial', 19, 799.99, 'Unidade', 19, '2023-08-30'),
(31, 'Smartphone Y', 'Smartphone de última geração', 1, 699.99, 'Unidade', 1, '2022-08-01'),
(32, 'Notebook Avançado', 'Notebook poderoso com tela Full HD', 2, 1299.99, 'Unidade', 2, '2022-08-02'),
(33, 'Tablet Pro', 'Tablet profissional com caneta stylus', 3, 399.99, 'Unidade', 3, '2022-08-03'),
(34, 'TV OLED 65"', 'TV OLED 4K de 65 polegadas', 4, 899.99, 'Unidade', 4, '2022-08-04'),
(35, 'Câmera Mirrorless', 'Câmera digital mirrorless de alta qualidade', 5, 799.99, 'Unidade', 5, '2022-08-05'),
(36, 'Impressora Jato de Tinta', 'Impressora jato de tinta colorida', 6, 299.99, 'Unidade', 6, '2022-08-06'),
(37, 'Mouse Bluetooth', 'Mouse Bluetooth ergonômico', 7, 29.99, 'Unidade', 7, '2022-08-07'),
(38, 'Teclado Mecânico RGB', 'Teclado mecânico RGB para gamers', 8, 59.99, 'Unidade', 8, '2022-08-08'),
(39, 'Fones de Ouvido Sem Fio', 'Fones de ouvido sem fio com cancelamento de ruído', 9, 169.99, 'Unidade', 9, '2022-08-09'),
(40, 'Smartwatch Pro', 'Smartwatch com GPS e monitor de saúde', 10, 249.99, 'Unidade', 10, '2022-08-10'),
(41, 'Monitor 27"', 'Monitor LED Quad HD de 27 polegadas', 11, 199.99, 'Unidade', 11, '2022-08-11'),
(42, 'HD Externo 4TB', 'HD Externo portátil de 4TB', 12, 129.99, 'Unidade', 12, '2022-08-12'),
(43, 'Drone DJI Pro', 'Drone DJI com câmera 8K', 13, 1199.99, 'Unidade', 13, '2022-08-13'),
(44, 'Console de Jogos Elite', 'Console de jogos de elite com VR', 14, 599.99, 'Unidade', 14, '2022-08-14'),
(45, 'Fones de Ouvido com Cancelamento de Ruído', 'Fones de ouvido com cancelamento de ruído ativo', 15, 89.99, 'Unidade', 15, '2022-08-15'),
(46, 'Projetor 4K', 'Projetor 4K de alta definição', 16, 799.99, 'Unidade', 16, '2022-08-16'),
(47, 'Impressora Laser Colorida', 'Impressora laser colorida de alta qualidade', 6, 349.99, 'Unidade', 6, '2022-08-17'),
(48, 'Notebook Ultrafino SSD', 'Notebook ultrafino com SSD rápido', 2, 1099.99, 'Unidade', 2, '2022-08-18'),
(49, 'Mouse Gamer RGB', 'Mouse gamer com iluminação RGB personalizável', 7, 69.99, 'Unidade', 7, '2022-08-19'),
(50, 'Câmera de Ação Pro', 'Câmera de ação 4K à prova dágua', 5, 149.99, 'Unidade', 5, '2022-08-20'),
(51, 'Tablet Profissional', 'Tablet profissional para designers e artistas', 3, 449.99, 'Unidade', 3, '2021-08-21'),
(52, 'Monitor Curvo 34"', 'Monitor LED curvo ultra-amplo de 34 polegadas', 11, 399.99, 'Unidade', 11, '2021-08-22'),
(53, 'Teclado Mecânico Retroiluminado', 'Teclado mecânico com retroiluminação', 8, 79.99, 'Unidade', 8, '2021-08-23'),
(54, 'Console Portátil Clássico', 'Console portátil com jogos clássicos', 14, 149.99, 'Unidade', 14, '2021-08-24'),
(55, 'HD Externo 5TB', 'HD Externo portátil de 5TB', 12, 149.99, 'Unidade', 12, '2021-08-25'),
(56, 'Kit de Caixas de Som Bluetooth', 'Kit de caixas de som Bluetooth estéreo', 17, 49.99, 'Unidade', 17, '2021-08-26'),
(57, 'Câmera de Segurança HD', 'Câmera de segurança HD com gravação em nuvem', 18, 99.99, 'Unidade', 18, '2021-08-27'),
(58, 'Projetor Portátil', 'Projetor portátil de alta qualidade', 16, 249.99, 'Unidade', 16, '2021-08-28'),
(59, 'Impressora a Laser Monocromática', 'Impressora a laser monocromática de alta velocidade', 6, 169.99, 'Unidade', 6, '2021-08-29'),
(60, 'Servidor de Rede Empresarial', 'Servidor de rede empresarial com suporte 24/7', 19, 1999.99, 'Unidade', 19, '2021-08-30');

CREATE TABLE tabelapedidosgold (
 ID_pedido_gold INT PRIMARY KEY,
 Data_Do_Pedido_gold DATE,
 Status_gold VARCHAR(50),
 Total_Do_Pedido_gold DECIMAL(10, 2),
 Cliente_gold INT,
 Data_De_Envio_Estimada_gold DATE,
 FOREIGN KEY (cliente_gold) REFERENCES tabelaclientes(id_cliente))

insert into tabelapedidosgold (id_pedido_gold, data_do_pedido_gold, status_gold, 
                               total_do_pedido_gold, cliente_gold, data_de_envio_estimada_gold)
  select ID, data_do_pedido, status, total_do_pedido, cliente, data_de_envio_estimada
  from tabelapedidos where total_do_pedido >= 400
  
select * from tabelapedidosgold


INSERT OR REPLACE INTO Estoque (ID_produto, quantidade)
SELECT Vendas.ID_produto, Estoque.quantidade - Vendas.quantidade
FROM Vendas
JOIN Estoque ON Vendas.ID_produto = Estoque.ID_produto;

create table tabelafuncionarios(
  ID_funcionario primary key,
  Nome_funcionario text,
  Cargo_Funcionario text,
  Departamento_funcionario text,
  data_contratacao_funcionario date,
  salario_funcionario decimal
)

insert into tabelafuncionarios (ID_funcionario, Nome_funcionario, Cargo_Funcionario, Departamento_funcionario,
  data_contratacao_funcionario, salario_funcionario)
VALUES ('32D','João Silva','Desenvolvedor de Software', 'TI', '2023-10-24', 6000.00)

select * from tabelapedidos where total_do_pedido = 200

select * from tabelaclientes WHERE nome_cliente like '%c%'
select * from tabelaclientes WHERE nome_cliente > 'C'

select * from tabelapedidos where data_do_pedido > '2023-09-19'

select * from tabelapedidos where total_do_pedido > 200 and status = 'Pendente'
select DISTINCT status from tabelapedidos
select * from tabelapedidos where not status = 'Entregue'
select * from tabelapedidos where data_de_envio_estimada BETWEEN '2023-08-01' and '2023-09-01'

select * from tabelaprodutos where preco_compra BETWEEN 200 and 600 order by preco_compra asc
select * from tabelaprodutos where preco_compra BETWEEN 200 and 600 order by nome_produto desc
select * from tabelaprodutos where preco_compra BETWEEN 200 and 600 order by data_de_inclusao

select *, informacoes_contato as email_cliente from tabelaclientes

select p.nome_produto as NomeProduto, f.nome_do_fornecedor as NomeFornecedor
from tabelaprodutos as p
join tabelafornecedores as f on p.fornecedor_produto = f.id

select * from tabelapedidos where status = 'Processando'

update tabelapedidos set status = 'Enviado' where status = 'Processando'

select * from tabelafornecedores

UPDATE tabelafornecedores set país_de_origem = 'Brasil', informações_de_contato = 'email@email.com' where ID = '1'

DELETE from tabelafornecedores where país_de_origem = 'Alemanha'