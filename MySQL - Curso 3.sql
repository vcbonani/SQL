SELECT * FROM enderecos;

SELECT (SELECT COUNT(*) FROM alugueis) AS qtd_linhas_alugueis ,
	(SELECT COUNT(*) FROM avaliacoes) AS qtd_linhas_avaliacoes,
	(SELECT COUNT(*) FROM clientes) AS qtd_linhas_clientes,
	(SELECT COUNT(*) FROM enderecos) AS qtd_linhas_enderecos,
	(SELECT COUNT(*) FROM hospedagens) AS qtd_linhas_hospedagens,
	(SELECT COUNT(*) FROM proprietarios)  AS qtd_linhas_proprietarios;
    
SELECT * FROM proprietarios;
SELECT * FROM hospedagens;

SELECT p.nome, COUNT(h.hospedagem_id) as qtd_imoveis
FROM proprietarios p
JOIN hospedagens h ON p.proprietario_id = h.proprietario_id
GROUP BY p.nome
HAVING qtd_imoveis > 1
ORDER BY qtd_imoveis DESC;

SELECT * FROM alugueis;

SELECT SUM(preco_total) AS soma_preco_total, AVG(preco_total) AS media_preco_total,
	   MAX(preco_total) AS maior_preco_total, MIN(preco_total) AS menor_preco_total
FROM alugueis;

SELECT AVG(nota) AS media_notas FROM avaliacoes;

SELECT * FROM avaliacoes;
SELECT * FROM hospedagens;

SELECT h.tipo AS tipo_hospedagem, ROUND(AVG(a.nota), 2) AS media_avaliacao_tipo_hospedagem
FROM avaliacoes a
JOIN hospedagens h ON a.hospedagem_id = h.hospedagem_id
GROUP BY h.tipo;

#relatório com média de avaliações, valores de aluguel por tipo de hospedagem
SELECT h.tipo AS tipo_hospedagem, ROUND(AVG(av.nota), 2) AS media_avaliacao,
       SUM(a.preco_total) AS faturamento_total, ROUND(AVG(a.preco_total), 2) AS media_aluguel,
	   MAX(a.preco_total) AS maior_aluguel, MIN(a.preco_total) AS menor_aluguel
FROM alugueis a
JOIN avaliacoes av ON a.hospedagem_id = av.hospedagem_id
JOIN hospedagens h ON a.hospedagem_id = h.hospedagem_id
GROUP BY h.tipo;

#ajustando a coluna nome da tabela clientes retirando os espaços antes e após o nome
UPDATE clientes SET nome = TRIM(nome);

#exemplo de como formatar a coluna CPF para ficar no formato com . e -
SELECT CONCAT(SUBSTRING(cpf, 1, 3), '.', SUBSTRING(cpf, 4, 3), '.', SUBSTRING(cpf, 7, 3), '-', SUBSTRING(cpf, 10, 2)) AS CPF FROM clientes;

SELECT CONCAT('Cliente: ', nome, ' | Email: ', contato) AS cliente FROM clientes;

#Mão na massa: análise de desempenho das hospedagens
#Desafio: Sua tarefa é criar uma consulta SQL que forneça um resumo das avaliações das hospedagens por cidade, 
#incluindo a média das notas de avaliação e o número total de avaliações. 
#Além disso, para facilitar a leitura do relatório pela equipe de gerenciamento, 
#as cidades devem ser apresentadas em letras maiúsculas.
SELECT UPPER(e.cidade) AS cidade, COUNT(h.hospedagem_id) AS qtd_hospedagens , 
       AVG(a.nota) AS media_avaliacoes, COUNT(a.avaliacao_id) AS qtd_avaliacoes
FROM enderecos e
JOIN hospedagens h ON e.endereco_id = h.endereco_id
JOIN avaliacoes a ON h.hospedagem_id = a.hospedagem_id
GROUP BY e.cidade
ORDER BY e.cidade;

SELECT * FROM hospedagens;
SELECT * FROM alugueis;

#Trabalhando com datas
#Tempo médio que cada cliente aluga as hospedagens
SELECT c.nome, CONCAT(ROUND(AVG((datediff(a.data_fim, a.data_inicio))), 0), ' dias') AS tempo_medio_estadia
FROM alugueis a
JOIN clientes c ON a.cliente_id = c.cliente_id
GROUP BY c.nome
ORDER BY c.nome;

#total de dias que cada tipo de hospedagem foi alugada
SELECT h.tipo, SUM(DATEDIFF(a.data_fim, a.data_inicio)) AS total_dias
FROM hospedagens h
JOIN alugueis a ON h.hospedagem_id = a.hospedagem_id
GROUP BY h.tipo;

#trabalhando com funções numéricas e condicionais
#o TRUNCATE corta casas decimais, ROUND arredonda casas decimais
SELECT AVG(nota) AS media, TRUNCATE(AVG(nota), 2) AS media_TRUNCATE,
       ROUND(AVG(nota), 2) AS media_ROUND, tipo
FROM avaliacoes a JOIN hospedagens h ON a.hospedagem_id = h.hospedagem_id GROUP BY tipo;

SELECT CASE nota
    WHEN 1 THEN 'Péssimo'
    WHEN 2 THEN 'Ruim'
    WHEN 3 THEN 'Bom'
    WHEN 4 THEN 'Ótimo'
    ELSE 'Excelente' END AS categoria_hospedagens,
    COUNT(*) as qtd_hospedagens
FROM avaliacoes
GROUP BY categoria_hospedagens
ORDER BY nota DESC;

####################################################################################################

#Criando funções
DELIMITER $$
CREATE FUNCTION retorno_constante() RETURNS VARCHAR(50) DETERMINISTIC
    BEGIN
		RETURN 'Olá mundo!';
    END$$ 
DELIMITER ; 

SELECT retorno_constante();

################################################################################
#Usando variáveis em funções
DELIMITER $$

CREATE FUNCTION media_avaliacoes() RETURNS DECIMAL(10, 2) DETERMINISTIC
	BEGIN
		DECLARE media_notas DECIMAL(10, 2);
        SET media_notas = (SELECT ROUND(AVG(nota), 2) FROM avaliacoes);
        RETURN media_notas;
    END$$

DELIMITER ;

SELECT media_avaliacoes();

SET @variavel_media = (SELECT ROUND(AVG(nota), 2) FROM avaliacoes);

SELECT @variavel_media;

#Mão na massa: explorando a ocupação de hospedagens

SELECT hospedagem_id, COUNT(*) AS qtd_aluguel FROM alugueis GROUP BY hospedagem_id ORDER BY qtd_aluguel DESC;

SELECT COUNT(h.hospedagem_id) AS total_hospedagens, COUNT(a.aluguel_id) AS total_ocupacao
FROM hospedagens h
JOIN alugueis a ON h.hospedagem_id = a.hospedagem_id;

DELIMITER $$
CREATE FUNCTION ocupacao_media() RETURNS DECIMAL(10, 2) DETERMINISTIC
BEGIN
	DECLARE media_ocupacao DECIMAL(10,2);
    DECLARE total_ocupacao INTEGER;
    DECLARE total_hospedagens INTEGER;
    SET total_ocupacao = (SELECT COUNT(*)FROM alugueis);
    SET total_hospedagens = (SELECT COUNT(*) FROM hospedagens);
    SET media_ocupacao = (total_ocupacao / total_hospedagens);
	RETURN media_ocupacao;
END$$
DELIMITER ;

SELECT ocupacao_media();

#Utilizando parâmetros

SELECT SUBSTRING(cpf, 1, 3) FROM clientes;

DELIMITER $$
CREATE FUNCTION tres_primeiros_digitos(nome_parametro VARCHAR(255)) RETURNS VARCHAR(5) DETERMINISTIC
BEGIN
	DECLARE tres_digitos VARCHAR(5);
    SET tres_digitos = (SELECT SUBSTRING(cpf, 1, 3) FROM clientes WHERE nome = nome_parametro);
    RETURN tres_digitos;
END$$
DELIMITER ;

SELECT tres_primeiros_digitos('Luana Moura');

#usando uma função junto com select de tabelas
SELECT nome, cpf, tres_primeiros_digitos('Luana Moura') FROM clientes WHERE nome = 'Luana Moura';

#Retornando mais de um valor


DELIMITER $$
CREATE FUNCTION info_diaria(p_id_aluguel INT) RETURNS VARCHAR(255) DETERMINISTIC
BEGIN
	DECLARE v_valor_diaria DECIMAL(10,2);
    DECLARE v_nome_cliente VARCHAR(255);
	SELECT c.nome, (a.preco_total / DATEDIFF(a.data_fim, a.data_inicio)) INTO v_nome_cliente, v_valor_diaria
	FROM alugueis a JOIN clientes c ON a.cliente_id = c.cliente_id WHERE a.aluguel_id = p_id_aluguel;
    RETURN CONCAT('O cliente ', v_nome_cliente, ' pagou diárias de R$', FORMAT(v_valor_diaria, 2));
END$$
DELIMITER ;

SELECT info_diaria(10000);

#Mão na massa: desvendando as preferências dos hóspede

SELECT DISTINCT tipo FROM hospedagens;
SELECT tipo, COUNT(*) FROM hospedagens GROUP BY tipo;

DELIMITER $$
CREATE FUNCTION hospedagens_disponiveis(p_tipo VARCHAR(50)) RETURNS VARCHAR(255) DETERMINISTIC
BEGIN
	DECLARE qtd_hospedagens INTEGER;
    SELECT COUNT(*) INTO qtd_hospedagens FROM hospedagens WHERE tipo = p_tipo;
    RETURN CONCAT('A quantidade de hospedagens disponíveis do tipo ', p_tipo, ' é: ', qtd_hospedagens, '.');
END$$
DELIMITER ;


SELECT hospedagens_disponiveis('hotel');

### Criando um novo relatório
# Objetivo da empresa: atrair novos clientes, fidelizar clientes
# Criar política de desconto
-- MENOS DE 4 IAS = 0%
-- 4 A 6 DIAS = 5%
-- 7 A 9 DIAS = 10%
-- 10 OU MAIS DIAS = 15%

DELIMITER $$
CREATE FUNCTION calcula_desconto_por_dias(id_aluguel INT) RETURNS INT DETERMINISTIC
BEGIN
	DECLARE desconto INT;
	SELECT CASE
			WHEN DATEDIFF(data_fim, data_inicio) >= 10 THEN 15
			WHEN DATEDIFF(data_fim, data_inicio) BETWEEN 7 AND 9 THEN 10
			WHEN DATEDIFF(data_fim, data_inicio) BETWEEN 4 AND 6 THEN 5
			ELSE 0
		END INTO desconto
	FROM alugueis
    WHERE aluguel_id = id_aluguel;
    RETURN desconto;
END$$
DELIMITER ;

SELECT calcula_desconto_por_dias(10001);

## Mão na massa: duração média de estadias

select ceil(avg(datediff(data_fim, data_inicio))) as media_estadia from alugueis;

delimiter $$
create function CalculaDuracaoMediaEstadias() returns int deterministic
begin
	declare media_estadia int;
    select ceil(avg(datediff(data_fim, data_inicio))) into media_estadia from alugueis;
    return media_estadia;
end$$
delimiter ;

select CalculaDuracaoMediaEstadias();

#Chamando função em uma função

delimiter $$
create function calcularvalorfinalcomdesconto(id_aluguel int) returns decimal(10, 2) deterministic
begin
	declare valor_total decimal(10, 2);
    declare desconto int;
    declare preco_com_desconto decimal(10, 2);
    
    select preco_total into valor_total from alugueis where aluguel_id = id_aluguel;
    select calcula_desconto_por_dias(id_aluguel) into desconto;
    
    set preco_com_desconto = valor_total * ((100 - desconto) / 100);
    return preco_com_desconto;
end$$
delimiter ;

SELECT calcula_desconto_por_dias(10001);
select preco_total from alugueis where aluguel_id = 10001;
select calcularvalorfinalcomdesconto(10001);

### Criando uma nova tabela de resumo de aluguel

create table resumo_aluguel(
	aluguel_id varchar(255),
    cliente_id varchar(255),
    valor_total decimal(10, 2),
    desconto_aplicado decimal(10, 2),
    valor_final decimal(10, 2),
    primary key (aluguel_id, cliente_id),
    foreign key (aluguel_id) references alugueis(aluguel_id),
    foreign key (cliente_id) references clientes(cliente_id)
);

### Trabalhando com Trigger

delimiter $$
create trigger atualiza_resumo_aluguel after insert on alugueis for each row
begin
	declare desconto int;
    declare valor_final decimal(10, 2);
    set desconto = calcula_desconto_por_dias(new.aluguel_id);
    set valor_final = calcularvalorfinalcomdesconto(new.aluguel_id);
    insert into resumo_aluguel (aluguel_id, cliente_id, valor_total, desconto_aplicado, valor_final)
		                values (new.aluguel_id, new.cliente_id, new.preco_total, desconto, valor_final);
end$$
delimiter ;

select * from resumo_aluguel;
INSERT INTO alugueis (aluguel_id, cliente_id, hospedagem_id, data_inicio, data_fim, preco_total)
	values (10050, 42, 15, '2024-01-01', '2024-01-10', 3000.00);
    
### Controle de erros dentro de funções

select info_diaria(99999);

### Excluindo funções

drop function if exists retorno_constante;