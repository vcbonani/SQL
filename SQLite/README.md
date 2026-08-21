# SQLite — Alura

Repositório com os scripts SQL desenvolvidos ao longo da trilha de cursos de **SQLite** da [Alura](https://www.alura.com.br/), cobrindo desde comandos básicos até joins avançados, views, triggers e transações.

Os exercícios usam diferentes bases de dados fictícias ao longo da trilha: uma loja/e-commerce (`clientes`, `produtos`, `pedidos`, `fornecedores`), uma escola (`alunos`, `professores`, `disciplinas`, `turmas`, `notas`), uma empresa com dados de RH (`colaboradores`, `HistoricoEmprego`, `Treinamento`, `Licencas`, `Dependentes`, `faturamento`) e uma loja de varejo com vendas por categoria/marca/fornecedor (`categorias`, `produtos`, `vendas`, `itens_venda`, `marcas`, `fornecedores`).

## 🎯 Objetivo

Consolidar, na prática, os fundamentos e recursos intermediários/avançados do SQLite: DDL/DML, filtros e operadores, funções de agregação, texto, data e conversão, `CASE WHEN`, joins (inner/left/right/full), subconsultas, `UNION`/`EXCEPT`/`INTERSECT`, views, triggers, transações e análises de negócio (sazonalidade, participação de mercado, séries temporais).

## 🗂️ Estrutura do repositório

| Arquivo | Conteúdo |
|---|---|
| `SQLite - Curso 1 - Projeto.sql` | Fundamentos: `CREATE TABLE`, `INSERT`, `SELECT`, `WHERE`, `DISTINCT`, `UPDATE`, `DELETE`, chave estrangeira, `DROP TABLE` |
| `SQLite - Curso 1 - Exercicios.sql` | Exercícios de fixação: filtros com `WHERE`, `DISTINCT`, criação e alteração de tabelas (`ALTER TABLE`), inserção em lote, `LIKE`, `BETWEEN`, `NOT IN`, comparações de texto/data |
| `SQLite - Curso 1 - Projeto 2.sql` | Modelagem de banco escolar (alunos, professores, disciplinas, turmas, notas) com chaves estrangeiras, carga de dados e consultas simples com `ORDER BY` e filtros numéricos |
| `SQLite - Curso 2 - Aulas.sql` | Operadores (`LIKE`, `IN`, `NOT IN`, `ISNULL`/`NOTNULL`), funções de agregação (`MAX`, `MIN`, `SUM`, `AVG`, `COUNT`) com `GROUP BY`/`HAVING`, funções de texto (`UPPER`, `LOWER`, `TRIM`, `SUBSTR`, `REPLACE`), funções de data (`STRFTIME`, `JULIANDAY`, `DATE`, `DATETIME`), funções numéricas (`ROUND`, `CEIL`, `FLOOR`, `POWER`, `SQRT`), `CAST`, `CASE WHEN` e `ALTER TABLE ... RENAME` |
| `SQLite - Curso 2 - Projeto 1.sql` | Exercícios práticos combinando filtros, concatenação de texto, cálculo de diferença de datas, arredondamento, conversão de datas em texto para tipo data e classificação por faixas com `CASE` |
| `SQLite - Curso 2 - Projeto 2.sql` | Gerenciamento escolar: médias por disciplina, filtros por nome/data de nascimento, cálculo de idade e status de aprovação com `CASE` |
| `SQLite - Curso 3 - Aulas.sql` | `UNION ALL`, `EXCEPT`, `INTERSECT`, subconsultas, joins (`INNER`, `RIGHT`, `LEFT`, `FULL`), criação e remoção de **views**, **triggers** (`AFTER INSERT`) para cálculo automático de faturamento diário, `PRAGMA foreign_keys`, transações (`BEGIN TRANSACTION`, `ROLLBACK`, `COMMIT`) |
| `SQLite - Curso 3 - Projeto.sql` | Desafio final de joins e views: professor orientador por turma, melhor nota por disciplina, total de alunos por turma, alunos x disciplinas matriculadas, criação de view consolidada |
| `SQLite - Curso 4 - Aulas.sql` | Análises de negócio mais avançadas: contagem total por tabela (`UNION ALL`), ajuste de valores com `RANDOM()`, séries temporais com `STRFTIME`, papel de fornecedores/categorias na Black Friday, pivot de dados com `CASE WHEN` + `SUM`, participação de mercado (marcas/fornecedores/categorias) com views, análise de sazonalidade e comparação de métricas com CTEs (`WITH`) |
| `SQLite - Curso 4 - Projeto 1.sql` | Desafio de análise de vendas: quantidade de clientes/produtos vendidos, categoria mais vendida por ano, fornecedor líder, comparação de categorias ao longo do tempo (pivot), percentual de vendas por categoria, gap entre melhor e pior categoria |
| `SQLite - Curso 4 - Projeto 2.sql` | Desafio de gerenciamento escolar: alunos aprovados por disciplina (critério de nota), total de disciplinas por turma, percentual geral e por disciplina de aprovação usando CTEs |

## 🧠 Principais aprendizados técnicos

- **Fundamentos SQL**: DDL/DML, filtros, ordenação, chaves primária/estrangeira
- **Funções**: agregação, texto, data/hora (`STRFTIME`, `JULIANDAY`), numéricas e de conversão (`CAST`)
- **Joins e combinação de conjuntos**: `INNER`/`LEFT`/`RIGHT`/`FULL JOIN`, `UNION ALL`, `EXCEPT`, `INTERSECT`
- **Subconsultas e CTEs**: consultas aninhadas, `WITH`, pivot de dados com `CASE WHEN` + `SUM`
- **Objetos de banco**: views para consolidar métricas recorrentes, triggers para automatizar cálculos
- **Controle transacional**: `BEGIN TRANSACTION`, `ROLLBACK`, `COMMIT`, `PRAGMA foreign_keys`
- **Análises de negócio**: sazonalidade, participação de mercado, séries temporais, percentuais e comparações entre categorias/fornecedores

## 🛠️ Tecnologias

- SQLite

## 📚 Curso

Trilha de **SQLite** — Alura

---

📌 Repositório com fins de estudo e portfólio, desenvolvido por [Vinícius Cunha](https://www.linkedin.com/).
