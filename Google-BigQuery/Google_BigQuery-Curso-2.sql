#Explorando funções de caixa de texto
#upper (converte string para maiuscula), lower (converte string para minuscula), initcap (deixa só a primeira letra do string maiuscula)

SELECT nome FROM curso-big-query-19140.belleza_verde_vendas.clientes
WHERE id_cliente IN (1, 8, 15, 17);

SELECT nome, UPPER(nome), LOWER(nome), INITCAP(nome) FROM curso-big-query-19140.belleza_verde_vendas.clientes
WHERE id_cliente IN (1, 8, 15, 17);

#Compreendendo funções de extração e corte
#Corte: ltrim, rtrim, trim
#Extração: left, right

SELECT nome, left(nome, 4), right(nome, 3) from curso-big-query-19140.belleza_verde_vendas.produtos
where id_produto IN (3, 9);

select categoria, right(categoria, 8) from curso-big-query-19140.belleza_verde_vendas.produtos
where id_produto in (5, 10);

select nome, trim(nome), ltrim(nome), rtrim(nome) from curso-big-query-19140.belleza_verde_vendas.produtos
where id_produto in (7, 4);

select nome, ltrim(nome, "-") from curso-big-query-19140.belleza_verde_vendas.produtos
where id_produto = 1;

#funçõies de análise e concatenação de string
#char_length, ends_with, starts_with, concat

select nome, char_length(nome), trim(nome), char_length(trim(nome)) from curso-big-query-19140.belleza_verde_vendas.produtos
where id_produto in (7, 4);

select nome, starts_with(nome, 'Óleo'), ends_with(nome, 'Uva'), concat(nome, ' 100') from curso-big-query-19140.belleza_verde_vendas.produtos
where id_produto in (3, 9);

select concat(trim(ltrim(nome, '-')), ' - ', categoria) from curso-big-query-19140.belleza_verde_vendas.produtos;

#Aplicando funções de busca e modificação de textos

#instr -> localiza um string dentro de um campo especificado e retorna a posição
select nome, instr(ltrim(nome), ' ') from curso-big-query-19140.belleza_verde_vendas.produtos;
#substring -> obter a primeira palavra de um string antes do primeiro espaço
select nome, substring(ltrim(nome), 1, instr(ltrim(nome), ' ')) from curso-big-query-19140.belleza_verde_vendas.produtos;
#replace -> substituir caracteres específicos
select nome, replace(substring(ltrim(nome), 1, instr(ltrim(nome), ' ')),'-', '') from curso-big-query-19140.belleza_verde_vendas.produtos;

#Entendendo expressões regulares

#site para testar regex: https://regex101.com/
#^[0-9]{3}\.[0-9]{3}\.[0-9]{3}-[0-9]{2}$ -> para testar CPF
#^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$ -> para testar email
#[0-9]{5}-[0-9]{3}|[0-9]{8} -> para testar CEP

#verifica se existe na string o regex, retorna true ou false
select cep,regexp_contains(cep, r'[0-9]{5}-[0-9]{3}|[0-9]{8}') from curso-big-query-19140.belleza_verde_vendas.clientes;
#extrai do string o regex buscado
select cep,regexp_extract(cep, r'[0-9]{5}-[0-9]{3}|[0-9]{8}') from curso-big-query-19140.belleza_verde_vendas.clientes;

with subquery_1 as(
  select cep,regexp_extract(cep, r'[0-9]{5}-[0-9]{3}|[0-9]{8}') as cep_extract
  from curso-big-query-19140.belleza_verde_vendas.clientes
)
select cep, 
  case when regexp_contains(cep_extract, r'[0-9]{8}') then concat(substr(cep_extract, 1, 5), '-', substr(cep_extract, 6, 8))
  else cep_extract
  end as cep_final
from subquery_1;

#Formatando textos e números

select cli.nome, sum(ven.quantidade) as quantidade
from `belleza_verde_vendas.clientes` cli
inner join `belleza_verde_vendas.vendas` ven on cli.id_cliente = ven.id_cliente
group by cli.nome;

#formatar a quantidade como %d para inteiro e %f para decimal
select cli.nome, format("%d", sum(ven.quantidade)) as quantidade, format("%f", sum(ven.quantidade * ven.preco)) as faturamento
from `belleza_verde_vendas.clientes` cli
inner join `belleza_verde_vendas.vendas` ven on cli.id_cliente = ven.id_cliente
group by cli.nome;

select concat('O cliente ', cli.nome, ' comprou a quantidade de: ', 
              #colocar um número entre o % e a letra "reserva" um espaço para imprimir o dado
              format("%20d", sum(ven.quantidade)), ' totalizando o faturamento de ', 
              #colocar um número que começa com 0 entre o % e a letra "reserva" um espaço para imprimir o dado
              format("%020f", sum(ven.quantidade * ven.preco))
  ) as texto
from `belleza_verde_vendas.clientes` cli
inner join `belleza_verde_vendas.vendas` ven on cli.id_cliente = ven.id_cliente
group by cli.nome;

select concat('O cliente ', cli.nome, ' comprou a quantidade de: ', 
              #colocar ' depois do % ativa os separadores de milhar e decimal
              replace(format("%'d", sum(ven.quantidade)), ',', '.'),
              ' totalizando o faturamento de ', 
              #formatando o faturamento para ser exibido com R$ e 2 casas decimais
              #regexp_replace(format("R$ %'.*f", 2, sum(ven.quantidade * ven.preco)), r'[0-9]{1}\,[0-9]{3}\.', r'abobora') 
              translate(format("R$ %'.*f", 2, sum(ven.quantidade * ven.preco)), ',.', '.,')
  ) as texto
from `belleza_verde_vendas.clientes` cli
inner join `belleza_verde_vendas.vendas` ven on cli.id_cliente = ven.id_cliente
group by cli.nome;

#Funções de tempo

#Conhecendo as diferenças entre Datetime e Timestamp

select current_datetime(), current_timestamp(), current_date(), current_time();

select current_datetime('America/Sao_Paulo'), current_timestamp(), current_date(), current_time();

#inicializa uma data com timestamp, inicializa o mesmo no formato datetime
select timestamp('2020-07-01 10:00:00'), datetime(2020, 7, 1, 10, 0, 0), date(2020, 7, 1), time(10, 0, 0);

#Explorando funções de cálculos de datas

#date_add - adições nas data/horários

select current_timestamp(), date_add(current_timestamp, interval 5 day) as data_atual_5_dias;
select current_datetime(), date_add(current_datetime, interval 10 week) as data_atual_10_semanas;

#date_sub - subtrações nas data/horários

select current_timestamp(), date_sub(current_timestamp, interval 5 day) as data_atual_5_dias;
select current_datetime(), date_sub(current_datetime, interval 10 week) as data_atual_10_semanas;

#date_diff - diferença entre datas/horários

#diferença de data entre o dia atual e 01/01/2024
select date_diff(current_date, date(2024, 1, 1), day);
select date_diff(current_datetime, datetime(2024, 1, 1, 0, 0, 0), second);

select data, sum(quantidade), date_diff(current_date(), data, day)
from `belleza_verde_vendas.vendas`
group by data;

#Extraindo parte das datas com função extract

#gerando intervalo de datas - lista
select generate_date_array('2021-01-01', current_date);

#gerando intervalo de datas como tabela
select data from unnest(generate_date_array('2021-01-01', current_date)) as data;

select data, extract(year from data) as ano, extract(quarter from data) as trimestre, extract(month from data) as mes,
       extract(week from data) as semana, extract(dayofweek from data) as dia_semana, extract(day from data) as dia
from unnest(generate_date_array('2021-01-01', current_date)) as data;

#conferindo se houve alguma data sem vendas dentro da base de dados
with lista_datas as(
  select data from unnest(generate_date_array('2021-01-01', current_date)) as data
)
select distinct ven.data as data_venda, ld.data as data_calendario
from `belleza_verde_vendas.vendas` ven
right join lista_datas ld on ven.data = ld.data
where extract(year from ld.data) = 2022 and ven.data is null
order by ld.data;

#Mão na massa: calculando datas de entrega estimadas
# 1->4, 2->5, 3->6, 4->7(2), 5->1(2), 6->2, 7->3

select data,
       extract(dayofweek from data) as dia_semana,
       case
           when extract(dayofweek from data) = 4 then date_add(data, interval 5 day)
           when extract(dayofweek from data) = 5 then date_add(data, interval 4 day)
           else date_add(data, interval 3 day)
       end as data_entrega_estimada,
       case
           when extract(dayofweek from data) = 4 then extract(dayofweek from date_add(data, interval 5 day))
           when extract(dayofweek from data) = 5 then extract(dayofweek from date_add(data, interval 4 day))
           else extract(dayofweek from date_add(data, interval 3 day))
       end as dia_entrega_estimada,
       count(*) as qtd_vendas
from `belleza_verde_vendas.vendas` group by data order by data;

#Calculando o primeiro e último dia do período

#                        último dia do mês                  último dia do ano                 último dia da semana
select current_datetime, last_day(current_datetime, month), last_day(current_datetime, year), last_day(current_datetime, week);

#                        primeiro dia do mês                  primeiro dia do ano                 primeiro dia da semana
select current_datetime, date_trunc(current_datetime, month), date_trunc(current_datetime, year), date_trunc(current_datetime, week);

#calcular: 15 dias após o primeiro dia útil do mês seguinte a data da venda
select id_produto, data, quantidade,
       date_add(date_trunc(date_add(data, interval 1 month), month), interval 15 day) as mes_seguinte
from `belleza_verde_vendas.vendas`;

with ajuste_dias_uteis as (
  select id_produto, data, quantidade,
  case
    when extract(dayofweek from date_trunc(date_add(data, interval 1 month), month)) = 7 then date_add(date_trunc(date_add(data, interval 1 month), month), interval 2 day)
    when extract(dayofweek from date_trunc(date_add(data, interval 1 month), month)) = 1 then date_add(date_trunc(date_add(data, interval 1 month), month), interval 1 day)
    else date_trunc(date_add(data, interval 1 month), month)
  end as primeiro_dia_util
  from `belleza_verde_vendas.vendas`
)
select id_produto, data, quantidade,
       date_add(primeiro_dia_util, interval 21 day) as quinze_dias_uteis_apos
from ajuste_dias_uteis;

#Formatando a exibição de datas

#formatando para exibir dd/mm/aaaa
select format_datetime('%d/%m/%Y', current_datetime);

#formatação por extenso do dia, mês e ano
select id_venda, data, format_date('%A, %d de %B de %y', data) as data_formatada from `belleza_verde_vendas.vendas`;

#Conhecendo a data UNIX
select data, unix_seconds(timestamp_seconds(data_unix)), data_unix, timestamp_seconds(data_unix) from `belleza_verde_vendas.vendas`;

#Função: UNIX_SECONDS(timestamp_expression).
#Descrição: Converte um valor de timestamp para o número total de segundos desde o início da época Unix (1º de janeiro de 1970 00:00:00 UTC). O valor retornado é um inteiro representando esses segundos.

#Função: TIMESTAMP_SECONDS(integer_expression).
#Descrição: Converte um valor inteiro representando segundos desde a época Unix (1º de janeiro de 1970 00:00:00 UTC) em um valor de timestamp. Isso permite converter de uma representação de tempo baseada em segundos Unix para o formato de timestamp mais legível e rico em informações.


#Bug de 2038 Y2038 -> cuidado com o campo de armazenamento da data unix para que seja atualizado para 64 bits

#Exemplos práticos

#Mão na massa: usando Data Unix para operações em datas

with datas as(
  select distinct data, data_unix, timestamp_seconds(data_unix) as data_unix_timestamp from `belleza_verde_vendas.vendas`
)
select data, 
       date_add(date_trunc(date_add(data, interval 1 month), month), interval 15 day) as dt_vencimento,
       data_unix as dt_unix_original,
       data_unix_timestamp,
       timestamp_add(timestamp_trunc(timestamp_add(data_unix_timestamp, interval 2678400 second), month), interval 15 day) as dt_unix_ts_15,
       unix_seconds(timestamp_add(timestamp_trunc(timestamp_add(data_unix_timestamp, interval 2678400 second), month), interval 15 day)) as data_unix_vencimento
from datas;











