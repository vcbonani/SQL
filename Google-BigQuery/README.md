# Bancos de Dados & SQL com Google BigQuery — Alura

Repositório com os scripts SQL e comandos de terminal desenvolvidos ao longo do curso **"Bancos de Dados & SQL com Google BigQuery"**, da [Alura](https://www.alura.com.br/). O curso trabalha manipulação e análise de grandes volumes de dados na nuvem, cobrindo desde a criação de datasets até automação de cargas via Shell.

Todo o desenvolvimento usa como base o dataset fictício **`belleza_verde_vendas`** (e sua cópia de homologação, `belleza_verde_vendas_hom`), simulando uma empresa de cosméticos com tabelas de clientes, produtos, vendedores, vendas, metas e matérias-primas.

## 🎯 Objetivo

Consolidar, na prática, os principais recursos do BigQuery para análise de dados em escala: criação e gerenciamento de datasets/tabelas, tratamento e transformação de dados, funções analíticas (texto, data, número), joins, arrays/structs e automação via linha de comando (`bq`).

## 🗂️ Estrutura do repositório

| Arquivo | Conteúdo |
|---|---|
| `Google-BigQuery-Curso_1 - Atividades.sql` | Subqueries, `WITH`, `GROUP BY`/`HAVING`, arrays e `STRUCT`, `UNNEST` (simples e múltiplo), tipos de `JOIN`, análise de vendas anuais por vendedor vs. metas |
| `Google-BigQuery-Curso_1 - Desafio.sql` | Desafio prático: análise de Pareto (ranking de clientes por faturamento, percentual de participação e distribuição cumulativa) |
| `Google-BigQuery-Curso_2.sql` | Funções de texto (`UPPER`, `TRIM`, `INSTR`, `SUBSTRING`, `REPLACE`), expressões regulares (CPF, e-mail, CEP), formatação de números/texto, funções de data/hora (`DATE_ADD`, `DATE_DIFF`, `EXTRACT`, data UNIX) |
| `Google-BigQuery-Curso_2 - Ajustes.sql` | Correções de qualidade de dados: padronização de nomes, tratamento de encoding, criação de coluna `cep`, conversão de datas para UNIX timestamp |
| `Google-BigQuery-Curso_2 - Exemplo.sql` | Consulta consolidada de desempenho de vendedores por produto/ano, comparando vendas realizadas com metas |
| `Google-BigQuery-Curso_3.sql` | Funções numéricas (`ROUND`, `TRUNC`, `SAFE`, `SIGN`, `RAND`, funções trigonométricas/logarítmicas), tratamento de overflow, `RANGE_BUCKET`, operadores lógicos, `COALESCE`, `CAST`/`SAFE_CAST` |
| `Google-BigQuery-Curso_4.sql` | DDL/DML: renomear coluna, adicionar coluna, `INSERT`, `UPDATE`, `DELETE`, carga entre tabelas evitando duplicidade e uso de `MERGE` |
| `Comandos_Terminal.txt` | Comandos `bq` (Cloud Shell): criar/listar/atualizar/remover datasets, criar tabelas via schema, transferência de dados entre datasets, carga via CSV/Storage, execução de scripts `.sql` e `.sh` |

## 🧠 Principais aprendizados técnicos

- **Modelagem e gestão de datasets/tabelas**: criação via Console, BigQuery Studio, Cloud Shell e schema JSON
- **Qualidade e tratamento de dados**: padronização de texto, tratamento de encoding, expressões regulares, `COALESCE`/`IF` para tratamento de nulos
- **Transformações e análises complexas**: CTEs (`WITH`), `JOIN`s, `ARRAY`/`STRUCT`/`UNNEST`, funções de janela (`RANK`, `SUM() OVER()`)
- **Séries temporais**: cálculo de datas de entrega, dias úteis, primeiro/último dia do período, data UNIX
- **Automação**: scripts Shell (`bq`) para carga, cópia e transferência de dados entre datasets

## 🛠️ Tecnologias

- Google BigQuery
- SQL (Standard SQL / GoogleSQL)
- Google Cloud Shell / `bq` CLI
- Google Cloud Storage (carga de arquivos)

## 📚 Curso

[Bancos de Dados & SQL com Google BigQuery](https://www.alura.com.br/) — Alura

---

📌 Repositório com fins de estudo e portfólio, desenvolvido por [Vinícius Cunha](https://www.linkedin.com/).
