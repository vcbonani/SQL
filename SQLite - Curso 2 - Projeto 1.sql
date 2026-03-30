--Mão na massa: hora da prática

--Selecione os primeiros 5 registros da tabela clientes, ordenando-os pelo nome em ordem crescente.
select * from Colaboradores limit 5;

--Encontre todos os produtos na tabela produtos que não têm uma descrição associada (suponha que a coluna de descrição possa ser nula).
select * from Colaboradores where nome isnull;

--Liste os funcionários cujo nome começa com 'A' e termina com 's' na tabela funcionarios.
select * from Colaboradores WHERE nome like 'A%s';

--Exiba o departamento e a média salarial dos funcionários em cada departamento na tabela funcionarios, agrupando por departamento, apenas para os departamentos cuja média salarial é superior a $5000.
select cargo, round(AVG(salario),2) as MediaSalarial from CargosColaboradores group by cargo having MediaSalarial > 5000;

--Selecione todos os clientes da tabela clientes e concatene o primeiro e o último nome, além de calcular o comprimento total do nome completo.
select (nome || ' é ' || parentesco || ' de um colaborador') as texto, 
  length((nome || ' é ' || parentesco || ' de um colaborador')) as tamanhoTexto from Dependentes;

--Para cada venda na tabela vendas, exiba o ID da venda, a data da venda e a diferença em dias entre a data da venda e a data atual.
select ('O curso ' || curso || ' foi concluído a ' || 
        round((JULIANDAY(datetime('now')) - JULIANDAY(dataconclusao)),0) || ' dias' ) as texto
from Treinamento;

--Selecione todos os itens da tabela pedidos e arredonde o preço total para o número inteiro mais próximo.
select id, ceil(faturamento_bruto) from faturamento;

--Converta a coluna data_string da tabela eventos, que está em formato de texto (YYYY-MM-DD), para o tipo de data e selecione todos os eventos após '2023-01-01'.
select date(substr(mes, 4, 4) || '-' || substr(mes, 1, 2) || '-01') AS data_atualizada
from faturamento
where date(substr(mes, 4, 4) || '-' || substr(mes, 1, 2) || '-01') > '2023-01-01';

--Na tabela avaliacoes, classifique cada avaliação como 'Boa', 'Média', ou 'Ruim' com base na pontuação: 1-3 para 'Ruim', 4-7 para 'Média', e 8-10 para 'Boa'.
select id, mes, faturamento_bruto,
CASE
  when faturamento_bruto < 100000 then 'Faturamento baixo'
  when faturamento_bruto BETWEEN 100000 and 150000 then 'Faturamento na média'
  else 'Faturamento alto'
end as ClassificaoFaturamento
from faturamento;

--Altere o nome da coluna data_nasc para data_nascimento na tabela funcionarios e selecione todos os funcionários que nasceram após '1990-01-01'.
alter table CargosColaboradores rename id_colaborador to idcolaboradores;