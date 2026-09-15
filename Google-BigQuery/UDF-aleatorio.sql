CREATE OR REPLACE FUNCTION `project-3683e6cb-e8ee-4b8e-8b5.belleza_verde_lib.aleatorio`(minimo INT64, maximo INT64) RETURNS INT64 AS (
CAST(FLOOR((RAND() * (maximo - minimo + 1))) AS INT64) + minimo
);