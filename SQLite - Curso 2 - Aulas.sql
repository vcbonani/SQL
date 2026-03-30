--1 - Conhecendo os dados
SELECT * FROM HistoricoEmprego 
ORDER BY salario DESC
LIMIT 5;

SELECT * FROM HistoricoEmprego 
WHERE datatermino ISNULL
ORDER BY salario DESC
limit 5;

SELECT * FROM HistoricoEmprego 
WHERE datatermino NOTNULL
ORDER BY salario DESC
limit 5;

--2 - Utilizando operadores

SELECT * FROM Treinamento
WHERE curso LIKE 'O poder%';

SELECT * from Treinamento
where curso LIKE '%realizar%';

SELECT * from Colaboradores
where nome LIKE 'Isadora%';

SELECT * FROM HistoricoEmprego
WHERE cargo = 'Professor' AND
datatermino NOT NULL;

SELECT * FROM HistoricoEmprego
WHERE cargo = 'Oftalmologista' OR
cargo = 'Dermatologista';

SELECT * FROM HistoricoEmprego 
WHERE cargo IN ('Oftalmologista', 'Dermatologista', 'Professor');

SELECT * FROM HistoricoEmprego 
WHERE cargo NOT IN ('Oftalmologista', 'Dermatologista', 'Professor');

SELECT * FROM Treinamento
WHERE (curso LIKE 'O direito%' AND instituicao = 'da Rocha')
OR (curso LIKE 'O conforto%' AND instituicao = 'das Neves');

--3 - Trabalhando com funções de agregação
SELECT mes, MAX(faturamento_bruto) FROM faturamento;

SELECT mes, MIN(faturamento_bruto) FROM faturamento;

SELECT SUM(numero_novos_clientes) AS 'Novos clientes 2023' FROM Faturamento
WHERE mes LIKE '%2023'

SELECT AVG(despesas) FROM faturamento;

SELECT AVG(lucro_liquido) FROM faturamento;

SELECT COUNT(*) FROM HistoricoEmprego
WHERE datatermino NOT NULL;

SELECT COUNT(*) from Licencas
WHERE tipolicenca = 'férias';

SELECT parentesco, COUNT(*) FROM Dependentes
GROUP BY parentesco;

SELECT instituicao, COUNT(curso) 
FROM Treinamento
GROUP BY instituicao
HAVING COUNT(curso) > 2;

SELECT cargo, COUNT(*) qtd
FROM HistoricoEmprego
GROUP BY cargo
HAVING qtd >=2;

--4 - Utilizando outras funções

SELECT nome, LENGTH(cpf) qtd
FROM Colaboradores
WHERE qtd = 11;

SELECT COUNT(*), LENGTH(cpf) qtd
FROM Colaboradores
WHERE qtd = 11;

SELECT (' pessoa colaboradora ' || nome || ' de CPF ' || cpf || ' possui o seguinte endereço: '
            || endereco) AS texto
            FROM Colaboradores;
            
SELECT UPPER(' pessoa colaboradora ' || nome || ' de CPF ' || cpf || ' possui o seguinte endereço: '
            || endereco) AS texto
            FROM Colaboradores;
            
SELECT LOWER(' pessoa colaboradora ' || nome || ' de CPF ' || cpf || ' possui o seguinte endereço: '
            || endereco) AS texto
            FROM Colaboradores;
            
SELECT TRIM(nome) FROM tabela;

SELECT INSTR(descricao, 'abc') FROM tabela;

SELECT REPLACE(saudacao, 'hello', 'hi') FROM tabela;

SELECT SUBSTR(comentario, 1, 5) FROM tabela;

-- STRFTIME seleciona do campo de data o que eu quero ver (só ano, só mês etc)
SELECT id_colaborador, STRFTIME('%Y/%m', datainicio) from Licencas;

-- JULIANDAY tempo de cada colaborador em cada contrato
select id_colaborador, JULIANDAY(datatermino) - JULIANDAY(datacontratacao) AS dias_contrato
from HistoricoEmprego WHERE datatermino NOTNULL order by dias_contrato;

--outras funções de data:
SELECT DATE('now'); --data corrente
SELECT DATE('now', '-10 days'); --10 dias atrás
SELECT TIME('now'); --hora corrente
SELECT DATETIME('now'); --data e hora correntes
SELECT DATETIME('now', '+1 year'); --ano seguinte
SELECT CURRENT_TIMESTAMP; -- data e hora correntes

--funções numéricas
--ROUND arredonda, CEIL arredonda para cima, FLOOR arredonda para baixo
select AVG(faturamento_bruto), ROUND(AVG(faturamento_bruto), 2),
CEIL(AVG(faturamento_bruto)), FLOOR(AVG(faturamento_bruto))from faturamento;
SELECT POWER(2, 3); --potenciação
SELECT SQRT(16); --raiz quadrada
SELECT RANDOM(); --número aleatório
SELECT ABS(-5); --transforma o número em absoluto
SELECT HEX('hello'); --HEX converte um número ou uma string para a sua forma hexadecimal

--Funções de conversão de dados
--CAST transforma o tipo do dado
SELECT ('O faturamento bruto médio foi ' || CAST(ROUND(AVG(faturamento_bruto),2) AS TEXT))
from faturamento;

--Utilizando a expressão CASE

--Criar faixas salariais
select id_colaborador, cargo, salario,
case 
  when salario < 3000 then 'Baixo'
  when salario between 3000 and 6000 then 'Médio'
  else 'Alto'
END as faixa_salarial
from HistoricoEmprego;

--renomeando com a cláusula RENAME
alter table HistoricoEmprego rename to CargosColaboradores;