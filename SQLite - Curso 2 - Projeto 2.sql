-- Mão na massa: gerenciamento escolar com banco de dados relacional

--Consulta 1: Retornar a média de Notas dos Alunos em história.

select avg(nota) as 'Média História' from Notas where id_disciplina = 2;

--Consulta 2: Retornar as informações dos alunos cujo Nome começa com 'A'.

select * from alunos where nome_aluno like 'A%';

--Consulta 3: Buscar apenas os alunos que fazem aniversário em fevereiro.

select * from Alunos WHERE data_nascimento like '%-02-%';

--Consulta 4: Realizar uma consulta que calcula a idade dos Alunos.

select nome_aluno, data_nascimento, (strftime('%Y', date('now')) - strftime('%Y', data_nascimento)) as 'Idade' from alunos;

--Consulta 5: Retornar se o aluno está ou não aprovado. Aluno é considerado aprovado se a sua nota foi igual ou maior que 6.

select A.nome_aluno, D.nome_disciplina, N.Nota, N.Data_Avaliacao,
case
  when N.Nota >= 6 then 'Aprovado'
  ELSE 'Reprovado'
END AS Situação
from Notas N
JOIN Alunos A on A.ID_Aluno = N.ID_Aluno
JOIN Disciplinas D on D.ID_Disciplina = N.ID_Disciplina;