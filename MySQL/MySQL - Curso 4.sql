# Explorando os dados

SELECT * FROM proprietarios LIMIT 10;

# Trabalhar com taxa de ocupação

SELECT
    hospedagem_id,
    MIN(data_inicio) AS primeira_data,
    SUM(DATEDIFF(data_fim, data_inicio)) AS dias_ocupados,
    DATEDIFF(MAX(data_fim), MIN(data_inicio)) AS total_dias,
    ROUND((SUM(DATEDIFF(data_fim, data_inicio)) / DATEDIFF(MAX(data_fim), MIN(data_inicio))) * 100) AS taxa_ocupacao
FROM alugueis
GROUP BY hospedagem_id
ORDER BY taxa_ocupacao ASC;

# Análise de desempenho de proprietários

#contando a quantidade de hospedagens por proprietário
select p.nome as proprietario, count(distinct h.hospedagem_id) as total_hospedagens
from hospedagens h
join proprietarios p on h.proprietario_id = p.proprietario_id
group by p.proprietario_id
order by total_hospedagens desc;

-- código omitido

SELECT
    p.nome AS Proprietario,
    MIN(primeira_data) AS primeira_data,
    SUM(total_dias) AS total_dias,
    SUM(dias_ocupados) AS dias_ocupados,
    ROUND((SUM(dias_ocupados) / SUM(total_dias)) * 100) AS taxa_ocupacao,
    AVG(preco_medio) AS preco_medio_diario
FROM(
    SELECT  hospedagem_id,
        MIN(data_inicio) AS primeira_data,
        SUM(DATEDIFF(data_fim, data_inicio)) AS dias_ocupados,
        DATEDIFF(MAX(data_fim), MIN(data_inicio)) AS total_dias,
        (SUM(preco_total) / SUM(DATEDIFF(data_fim, data_inicio))) AS preco_medio
    FROM alugueis
    GROUP BY hospedagem_id
    ) tabela_taxa_ocupacao
JOIN hospedagens h ON tabela_taxa_ocupacao.hospedagem_id = h.hospedagem_id
JOIN proprietarios p ON h.proprietario_id = p.proprietario_id
GROUP BY p.proprietario_id
ORDER BY total_dias DESC;

SELECT
    p.nome AS proprietario,
    ROUND(AVG(a.preco_total / DATEDIFF(a.data_fim, a.data_inicio)), 2) AS preco_medio_diario,
    ROUND((SUM(DATEDIFF(a.data_fim, a.data_inicio)) / (DATEDIFF(MAX(a.data_fim), MIN(a.data_inicio)) * COUNT(DISTINCT h.hospedagem_id))) * 100, 2) AS taxa_ocupacao
FROM proprietarios p
JOIN hospedagens h ON p.proprietario_id = h.proprietario_id
JOIN alugueis a ON h.hospedagem_id = a.hospedagem_id
GROUP BY p.proprietario_id;

#Identificando períodos de baixa e alta demanda

select year(data_inicio) AS ano, month(data_inicio) as mes, count(*) as total_alugueis
from alugueis group by ano, mes order by total_alugueis desc;

select month(data_inicio) as mes, count(*) as total_alugueis
from alugueis group by mes order by total_alugueis desc;

#Estratégias de preço baseadas em dados
#Como você criaria uma consulta SQL para ajudar os proprietários a identificar a média de preço por dia
#de aluguel em cada região do país, permitindo-lhes ajustar seus preços de acordo com a demanda sazonal?
select p.nome, e.estado, avg(datediff(a.data_fim, a.data_inicio)) as dias, avg(preco_total / datediff(a.data_fim, a.data_inicio)) as preco_medio
from proprietarios p
join hospedagens h on p.proprietario_id = h.proprietario_id
join enderecos e on e.endereco_id = h.endereco_id
join alugueis a on a.hospedagem_id = h.hospedagem_id
group by p.nome
order by p.nome;

# Construindo métricas por estado
select  a.hospedagem_id, a.preco_total, datediff(a.data_fim, a.data_inicio) as dias_aluguel,
	    a.preco_total / datediff(a.data_fim, a.data_inicio) as preco_dia
from alugueis a
order by preco_dia desc;

select e.estado,
	   avg(a.preco_total / datediff(a.data_fim, a.data_inicio)) as media_preco_diario,
       max(a.preco_total / datediff(a.data_fim, a.data_inicio)) as maior_preco_diario,
       min(a.preco_total / datediff(a.data_fim, a.data_inicio)) as menor_preco_diario,
       avg(datediff(a.data_fim, a.data_inicio)) as media_dias_aluguel
from alugueis a
join hospedagens h on a.hospedagem_id = h.hospedagem_id
join enderecos e on h.endereco_id = e.endereco_id
group by e.estado;

#Identificando tendências de aluguel com MySQL

#Para isso, você decide utilizar os dados de aluguel disponíveis, analisando a quantidade de alugueis por mês e identificando os períodos de alta e baixa demanda.
#Como você pode modificar a consulta SQL existente para incluir uma análise que mostre a média de dias que cada imóvel fica alugado por mês,
#ajudando assim a identificar períodos de maior e menor demanda?

select month(data_inicio) as mes, count(*) as quantidade_alugueis,
       avg(datediff(data_fim, data_inicio)) as media_ocupacao 
from alugueis group by mes order by mes asc;

# Construindo métricas por região do país

select rg.regiao,
	   avg(a.preco_total / datediff(a.data_fim, a.data_inicio)) as media_preco_diario,
       max(a.preco_total / datediff(a.data_fim, a.data_inicio)) as maior_preco_diario,
       min(a.preco_total / datediff(a.data_fim, a.data_inicio)) as menor_preco_diario,
       avg(datediff(a.data_fim, a.data_inicio)) as media_dias_aluguel
from alugueis a
join hospedagens h on a.hospedagem_id = h.hospedagem_id
join enderecos e on h.endereco_id = e.endereco_id
join regioes_geograficas rg on e.estado = rg.estado
group by rg.regiao;

# Separando os dados por região

#criando uma análise de série temporal com a quantidade de alugueis por ano e mês

select year(data_inicio) as ano, month(data_inicio) as mes, count(*) as total_alugueis
from alugueis a
join hospedagens h on a.hospedagem_id = h.hospedagem_id
join enderecos e on h.endereco_id = e.endereco_id
join regioes_geograficas r on e.estado = r.estado
where r.regiao = 'Sudeste'
group by ano, mes
order by ano, mes;

#criando uma procedure com o select acima

DELIMITER //
drop procedure if exists obtem_dados_regiao;
create procedure obtem_dados_regiao(regiao_nome varchar(255))
begin
	select year(data_inicio) as ano, month(data_inicio) as mes, count(*) as total_alugueis
	from alugueis a
	join hospedagens h on a.hospedagem_id = h.hospedagem_id
	join enderecos e on h.endereco_id = e.endereco_id
	join regioes_geograficas r on e.estado = r.estado
	where r.regiao = regiao_nome
	group by ano, mes
	order by ano, mes;
end//
DELIMITER ;

call obtem_dados_regiao('Norte');

# Função que descreve os dados

drop procedure if exists calcula_taxa_ocupacao;
delimiter //
create procedure calcula_taxa_ocupacao(id varchar(255))
begin
	SELECT p.nome AS Proprietario, MIN(primeira_data) AS primeira_data, SUM(total_dias) AS total_dias, SUM(dias_ocupados) AS dias_ocupados,
		ROUND((SUM(dias_ocupados) / SUM(total_dias)) * 100) AS taxa_ocupacao
	FROM(
		SELECT  hospedagem_id,
			MIN(data_inicio) AS primeira_data,
			SUM(DATEDIFF(data_fim, data_inicio)) AS dias_ocupados,
			DATEDIFF(MAX(data_fim), MIN(data_inicio)) AS total_dias
		FROM alugueis
		GROUP BY hospedagem_id
		) tabela_taxa_ocupacao
	JOIN hospedagens h ON tabela_taxa_ocupacao.hospedagem_id = h.hospedagem_id
	JOIN proprietarios p ON h.proprietario_id = p.proprietario_id
    where p.proprietario_id = id
	GROUP BY p.proprietario_id
	ORDER BY total_dias DESC;
end//
delimiter ;

call calcula_taxa_ocupacao('21');

## Criando uma view com as principais métricas para cada proprietário

create view view_metricas_proprietario as
	SELECT p.nome AS Proprietario, count(distinct h.hospedagem_id) as total_hospedagens, MIN(primeira_data) AS primeira_data, 
    SUM(total_dias) AS total_dias, SUM(dias_ocupados) AS dias_ocupados, ROUND((SUM(dias_ocupados) / SUM(total_dias)) * 100) AS taxa_ocupacao
	FROM(
		SELECT  hospedagem_id,
			MIN(data_inicio) AS primeira_data,
			SUM(DATEDIFF(data_fim, data_inicio)) AS dias_ocupados,
			DATEDIFF(MAX(data_fim), MIN(data_inicio)) AS total_dias
		FROM alugueis
		GROUP BY hospedagem_id
		) tabela_taxa_ocupacao
	JOIN hospedagens h ON tabela_taxa_ocupacao.hospedagem_id = h.hospedagem_id
	JOIN proprietarios p ON h.proprietario_id = p.proprietario_id
	GROUP BY p.proprietario_id;
    
select * from view_metricas_proprietario order by Proprietario;

## Criando uma view com os principais dados descritivos por região

create view view_dados_regiao as
	select rg.regiao,
	   avg(a.preco_total / datediff(a.data_fim, a.data_inicio)) as media_preco_diario,
       max(a.preco_total / datediff(a.data_fim, a.data_inicio)) as maior_preco_diario,
       min(a.preco_total / datediff(a.data_fim, a.data_inicio)) as menor_preco_diario,
       avg(datediff(a.data_fim, a.data_inicio)) as media_dias_aluguel
	from alugueis a
	join hospedagens h on a.hospedagem_id = h.hospedagem_id
	join enderecos e on h.endereco_id = e.endereco_id
	join regioes_geograficas rg on e.estado = rg.estado
	group by rg.regiao;
    
select * from view_dados_regiao;

create view view_ocupacao_regiao_tempo as
	select r.regiao, year(data_inicio) as ano, month(data_inicio) as mes, count(*) as total_alugueis
    from alugueis a
    join hospedagens h on a.hospedagem_id = h.hospedagem_id
    join enderecos e on h.endereco_id = e.endereco_id
    join regioes_geograficas r on r.estado = e.estado
    group by r.regiao, year(data_inicio), month(data_inicio)
    order by r.regiao, ano, mes;
    
select * from view_ocupacao_regiao_tempo;
select regiao, sum(total_alugueis) from view_ocupacao_regiao_tempo group by regiao;

## Criando um relatório para a área de negócios

select * from regioes_geograficas;
#id, estado, regiao

select e.estado
from regioes_geograficas r
right join enderecos e on r.estado = e.estado
where r.estado is null
group by e.estado;

call inclui_regioes_estados();
