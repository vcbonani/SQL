USE insight_places;

CREATE TABLE proprietarios (
	proprietario_id VARCHAR(255) PRIMARY KEY,
    nome VARCHAR(255),
    cpf_cnpj VARCHAR(20),
    contato VARCHAR(255)
);

CREATE TABLE hospedagens (
    hospedagem_id VARCHAR(255) PRIMARY KEY,
    tipo VARCHAR(50),
    endereco_id VARCHAR(255),
    proprietario_id VARCHAR(255),
        ativo bool,
    FOREIGN KEY (endereco_id) REFERENCES enderecos(endereco_id),
    FOREIGN KEY (proprietario_id) REFERENCES proprietarios(proprietario_id)
);

CREATE TABLE alugueis (
    aluguel_id VARCHAR(255) PRIMARY KEY,
    cliente_id VARCHAR(255),
    hospedagem_id VARCHAR(255),
    data_inicio DATE,
    data_fim DATE,
    preco_total DECIMAL(10, 2),
    FOREIGN KEY (cliente_id) REFERENCES clientes(cliente_id),
    FOREIGN KEY (hospedagem_id) REFERENCES hospedagens(hospedagem_id)
);

CREATE TABLE avaliacoes (
avaliacao_id VARCHAR(255) PRIMARY KEY,
cliente_id VARCHAR(255),
hospedagem_id VARCHAR(255),
nota INT,
comentario TEXT,
FOREIGN KEY (cliente_id) REFERENCES clientes(cliente_id),
FOREIGN KEY (hospedagem_id) REFERENCES hospedagens(hospedagem_id)
);

select count(*) from hospedagens where ativo = 0;

# selecionando as melhores hospedagens
select hospedagem_id from avaliacoes where nota >= 4;

# selecionando as hospedagens de hotel ativas
select * from hospedagens where ativo = 1 and tipo = 'hotel';

# ticket médio que cada cliente gasta na plataforma
select c.cliente_id, c.nome, round(avg(a.preco_total), 2) as ticket_medio
from alugueis a join clientes c on c.cliente_id = a.cliente_id
group by c.cliente_id, c.nome order by c.nome;

#média de dias de estadia de cada cliente
select cliente_id, round(avg(datediff(data_fim, data_inicio)), 0) as media_dias_estadia
from alugueis group by cliente_id order by media_dias_estadia desc;

#selecionar o top 10 de proprietários com mais hospedagens ativas cadastradas na plataforma
select proprietario_id, count(proprietario_id) as qtd_hospedagens 
from hospedagens group by proprietario_id order by qtd_hospedagens desc;

select p.nome as nome_proprietario, count(h.hospedagem_id) as qtd_hospedagens_ativas
from proprietarios p
join hospedagens h on h.proprietario_id = p.proprietario_id
where h.ativo = 1 
group by nome_proprietario
order by qtd_hospedagens_ativas desc limit 10;

#selecionar os proprietários com mais hospedagens inativas cadastradas na plataforma
select p.nome as nome_proprietario, count(h.hospedagem_id) as qtd_hospedagens_inativas
from proprietarios p
join hospedagens h on h.proprietario_id = p.proprietario_id
where h.ativo = 0
group by nome_proprietario
order by qtd_hospedagens_inativas desc;

#qual a demanda de aluguel para cada mês
select year(data_inicio) as ano, month(data_inicio) as mes, count(*) as total_alugueis
from alugueis group by ano, mes order by total_alugueis desc;

#incluir uma coluna nova na tabela de proprietários: quantidades de hospedagens cadastradas
select * from proprietarios;
alter table proprietarios 
add column qtd_hospedagens int;

#populando a nova coluna
update proprietarios set qtd_hospedagens = 0 where proprietario_id != '';
select * from proprietarios;

select p.nome as nome_proprietario, count(h.hospedagem_id) as qtd_hospedagens_ativas
from proprietarios p
join hospedagens h on h.proprietario_id = p.proprietario_id
where h.ativo = 1 
group by nome_proprietario
order by qtd_hospedagens_ativas desc limit 10;

select p.nome, count(h.hospedagem_id) as qtd_hospedagens
from proprietarios p
join hospedagens h on h.proprietario_id = p.proprietario_id
group by p.nome;

#mudar o nome da tabela alugueis para reservas
alter table alugueis rename to reservas;
select * from reservas;

#mudar o nome da coluna aluguel_id para reserva_id
alter table reservas rename column aluguel_id to reserva_id;

#volta alterações
alter table reservas rename to alugueis;
alter table alugueis rename column reserva_id to aluguel_id;

#reativando hospedagens inativas
select * from hospedagens;
update hospedagens set ativo = 1 where hospedagem_id in ('1', '10', '100');

#atualizando informação cadastral
select * from proprietarios where proprietario_id = '120';
update proprietarios set contato = 'daniela_120@email.com' where proprietario_id = '120';

#apagando registros específicos
#no exemplo abaixo, hospedagens possui relacionamento com reservas e avaliações (chave estrangeira)
#por isso foi necessário deletar os registros nessas outras tabelas
delete from avaliacoes where hospedagem_id in ('10000', '1001');
delete from reservas where hospedagem_id in ('10000', '1001');
delete from hospedagens where hospedagem_id in ('10000', '1001');