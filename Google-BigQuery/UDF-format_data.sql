CREATE OR REPLACE FUNCTION `project-3683e6cb-e8ee-4b8e-8b5.belleza_verde_lib.formata_data`(data_usuario DATE) RETURNS STRING AS (
FORMAT('%02d/%02d/%04d',
            EXTRACT(DAY FROM data_usuario),
            EXTRACT(MONTH FROM data_usuario),
            EXTRACT(YEAR FROM data_usuario))
);