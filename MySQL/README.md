# MySQL — Alura

Repositório com os scripts SQL desenvolvidos ao longo da trilha de cursos de **MySQL** da [Alura](https://www.alura.com.br/), cobrindo desde modelagem e manipulação de dados até funções, procedures, triggers e cursores.

Todo o desenvolvimento usa como base o banco de dados fictício **`insight_places`**, simulando uma plataforma de aluguel de hospedagens (nos moldes de um Airbnb), com tabelas de proprietários, hospedagens, clientes, endereços, aluguéis (posteriormente `reservas`) e avaliações.

## 🎯 Objetivo

Consolidar, na prática, os principais recursos do MySQL para modelagem relacional e análise de dados: criação de tabelas com chaves estrangeiras, DML (INSERT/UPDATE/DELETE), agregações e relatórios de negócio, funções e stored procedures, triggers, views, cursores e tratamento de erros.

## 🗂️ Estrutura do repositório

| Arquivo | Conteúdo |
|---|---|
| `MySQL - Curso 1.sql` | Modelagem inicial: criação de tabelas (`proprietarios`, `hospedagens`, `alugueis`, `avaliacoes`) com chaves primária/estrangeira, consultas de ticket médio e ocupação, ranking de proprietários, `ALTER TABLE` (adicionar/renomear coluna, renomear tabela), `UPDATE`/`DELETE` com tratamento de dependências entre tabelas |
| `MySQL - Curso 2.sql` | Criação e execução de **stored procedures**: parâmetros de entrada/saída (`IN`/`INOUT`), tratamento de erros com `EXIT HANDLER FOR SQLEXCEPTION`, estruturas `IF`/`CASE`, chamadas encadeadas entre procedures (`novoaluguel_22` até `novoaluguel_44`), tabelas temporárias, `CURSOR` para iterar listas de clientes e automatizar inclusão de aluguéis em lote |
| `MySQL - Curso 3.sql` | Subqueries e agregações (`SUM`, `AVG`, `MAX`, `MIN`), relatórios por tipo de hospedagem, tratamento de texto (`TRIM`, `CONCAT`, formatação de CPF), funções de data (`DATEDIFF`), `TRUNCATE` vs `ROUND`, `CASE WHEN`, criação de **funções** (`CREATE FUNCTION`) com variáveis, parâmetros e retorno de valores, função com múltiplos valores via `SELECT ... INTO`, regras de negócio (política de desconto por tempo de estadia), criação de tabela de resumo e **trigger** (`AFTER INSERT`) |
| `MySQL - Curso 4.sql` | Análises de negócio mais avançadas: taxa de ocupação por hospedagem/proprietário, preço médio diário, sazonalidade (alta/baixa demanda por mês), métricas por estado e região, **procedures parametrizadas** por região, **views** consolidando métricas de proprietários e dados regionais, relatório de estados sem região cadastrada |
| `MySQL - Stored Procedures.sql` | Dump completo (`mysqldump`) de todas as **functions** e **procedures** criadas no banco `insight_places` — versão consolidada de referência de todo o código de rotinas armazenadas |

## 🧠 Principais aprendizados técnicos

- **Modelagem relacional**: criação de tabelas com integridade referencial (`FOREIGN KEY`), `ALTER TABLE` para evolução de schema
- **Relatórios de negócio**: joins múltiplos, agregações, análise de ocupação, sazonalidade e desempenho por região/estado
- **Rotinas armazenadas**: `FUNCTION` (com e sem parâmetros, retorno único e múltiplo via `INTO`) e `PROCEDURE` (parâmetros `IN`/`INOUT`, `IF`/`CASE`, `WHILE`, chamadas encadeadas)
- **Tratamento de erros**: `DECLARE EXIT HANDLER FOR SQLEXCEPTION` e `GET DIAGNOSTICS` para capturar e tratar erros de chave estrangeira e duplicidade
- **Automação e reuso**: `CURSOR` para processar listas de registros, tabelas temporárias, `TRIGGER` para atualizar tabelas automaticamente após inserts
- **Views**: consolidação de métricas recorrentes para consumo por área de negócio

## 🛠️ Tecnologias

- MySQL 8.0
- SQL (DDL, DML, Stored Procedures, Functions, Triggers, Views, Cursors)

## 📚 Curso

Trilha de **MySQL** — Alura

---

📌 Repositório com fins de estudo e portfólio, desenvolvido por [Vinícius Cunha](https://www.linkedin.com/).
