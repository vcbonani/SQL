UPDATE curso-big-query-19140.belleza_verde_vendas.clientes SET nome = 'ana beatriz' WHERE id_cliente = 1;
UPDATE curso-big-query-19140.belleza_verde_vendas.clientes SET nome = 'HECTOR ALVES' WHERE id_cliente = 8;
UPDATE curso-big-query-19140.belleza_verde_vendas.clientes SET nome = 'olÃ­via&gomes' WHERE id_cliente = 15;
UPDATE curso-big-query-19140.belleza_verde_vendas.clientes SET nome = 'QuÃªnia Soares' WHERE id_cliente = 17;

UPDATE curso-big-query-19140.belleza_verde_vendas.produtos SET nome = '   Hidratante Corporal' WHERE id_produto = 7;
UPDATE curso-big-query-19140.belleza_verde_vendas.produtos SET nome = 'Creme para as MÃ£os     ' WHERE id_produto = 4;
UPDATE curso-big-query-19140.belleza_verde_vendas.produtos SET nome = '----Ã“leo Essencial Lavanda' WHERE id_produto = 1;

ALTER TABLE curso-big-query-19140.belleza_verde_vendas.clientes  ADD COLUMN cep STRING;
UPDATE curso-big-query-19140.belleza_verde_vendas.clientes SET cep = '30190010' WHERE id_cliente = 1;
UPDATE curso-big-query-19140.belleza_verde_vendas.clientes SET cep = '35400-000' WHERE id_cliente = 8;
UPDATE curso-big-query-19140.belleza_verde_vendas.clientes SET cep = '39100-000' WHERE id_cliente = 17;
UPDATE curso-big-query-19140.belleza_verde_vendas.clientes SET cep = '36010011' WHERE id_cliente = 15;
UPDATE curso-big-query-19140.belleza_verde_vendas.clientes SET cep = '38400-012' WHERE id_cliente = 27;
UPDATE curso-big-query-19140.belleza_verde_vendas.clientes SET cep = '80010020' WHERE id_cliente = 11;
UPDATE curso-big-query-19140.belleza_verde_vendas.clientes SET cep = '86010-150' WHERE id_cliente = 7;
UPDATE curso-big-query-19140.belleza_verde_vendas.clientes SET cep = 'CEP 87013-060' WHERE id_cliente = 1;
UPDATE curso-big-query-19140.belleza_verde_vendas.clientes SET cep = '84010-350' WHERE id_cliente = 28;
UPDATE curso-big-query-19140.belleza_verde_vendas.clientes SET cep = '85810-030' WHERE id_cliente = 24;
UPDATE curso-big-query-19140.belleza_verde_vendas.clientes SET cep = '85851-000' WHERE id_cliente = 3;
UPDATE curso-big-query-19140.belleza_verde_vendas.clientes SET cep = 'CEP 83203000' WHERE id_cliente = 5;
UPDATE curso-big-query-19140.belleza_verde_vendas.clientes SET cep = '85010-000' WHERE id_cliente = 20;
UPDATE curso-big-query-19140.belleza_verde_vendas.clientes SET cep = '86800-010' WHERE id_cliente = 12;
UPDATE curso-big-query-19140.belleza_verde_vendas.clientes SET cep = '85900-220' WHERE id_cliente = 29;
UPDATE curso-big-query-19140.belleza_verde_vendas.clientes SET cep = '87501-030' WHERE id_cliente = 25;
UPDATE curso-big-query-19140.belleza_verde_vendas.clientes SET cep = '40010-000' WHERE id_cliente = 9;
UPDATE curso-big-query-19140.belleza_verde_vendas.clientes SET cep = '40100-000' WHERE id_cliente = 26;
UPDATE curso-big-query-19140.belleza_verde_vendas.clientes SET cep = '40230-001' WHERE id_cliente = 6;
UPDATE curso-big-query-19140.belleza_verde_vendas.clientes SET cep = '40301-110' WHERE id_cliente = 4;
UPDATE curso-big-query-19140.belleza_verde_vendas.clientes SET cep = '40450-000' WHERE id_cliente = 10;
UPDATE curso-big-query-19140.belleza_verde_vendas.clientes SET cep = '41100-000' WHERE id_cliente = 16;
UPDATE curso-big-query-19140.belleza_verde_vendas.clientes SET cep = '41301-110' WHERE id_cliente = 19;
UPDATE curso-big-query-19140.belleza_verde_vendas.clientes SET cep = '01001-000' WHERE id_cliente = 21;
UPDATE curso-big-query-19140.belleza_verde_vendas.clientes SET cep = '01310-000' WHERE id_cliente = 23;
UPDATE curso-big-query-19140.belleza_verde_vendas.clientes SET cep = '01530-010' WHERE id_cliente = 18;
UPDATE curso-big-query-19140.belleza_verde_vendas.clientes SET cep = '20010-000' WHERE id_cliente = 14;
UPDATE curso-big-query-19140.belleza_verde_vendas.clientes SET cep = '22010-000' WHERE id_cliente = 22;
UPDATE curso-big-query-19140.belleza_verde_vendas.clientes SET cep = '22290-010' WHERE id_cliente = 13;
UPDATE curso-big-query-19140.belleza_verde_vendas.clientes SET cep = '23020-090' WHERE id_cliente = 30;
UPDATE curso-big-query-19140.belleza_verde_vendas.clientes SET cep = '85851-000' WHERE id_cliente = 2;

DELETE FROM curso-big-query-19140.belleza_verde_vendas.vendas WHERE data = '2022-01-01';

ALTER TABLE curso-big-query-19140.belleza_verde_vendas.vendas  ADD COLUMN DATA_AUX TIMESTAMP;
UPDATE curso-big-query-19140.belleza_verde_vendas.vendas SET DATA_AUX = TIMESTAMP(data) WHERE 1=1;

ALTER TABLE curso-big-query-19140.belleza_verde_vendas.vendas  ADD COLUMN data_unix INT64;
UPDATE curso-big-query-19140.belleza_verde_vendas.vendas SET data_unix = UNIX_SECONDS(DATA_AUX) WHERE 1=1;
ALTER TABLE curso-big-query-19140.belleza_verde_vendas.vendas  DROP COLUMN DATA_AUX;