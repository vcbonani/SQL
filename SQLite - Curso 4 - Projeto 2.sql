--Consulta 1: Retorne todas as disciplinas
select * from Disciplinas

--Consulta 2: Retorne os alunos que estão aprovados na disciplina de matemática
--critério para aprovação: nota 6.0
select a.Nome_Aluno, n.Nota
from Notas n
join Disciplinas d on d.ID_Disciplina = n.ID_Disciplina
join Alunos a on a.ID_Aluno = n.ID_Aluno
where d.Nome_Disciplina = 'Matemática' and n.Nota >= 6.0

--Consulta 3: Identificar o total de disciplinas por turma
select t.Nome_Turma, count(td.id_disciplina) as disciplinas_turma
from Turma_Disciplinas td
join turmas t on t.ID_Turma = td.ID_Turma
group by t.Nome_Turma
order by t.Nome_Turma

--Consulta 4: Porcentagem dos alunos que estão aprovados
with total_notas as (
  select count(*) as total from Notas),
alunos_aprovados as (
  select count(*) as aprovados from Notas where nota > 6.0)
select tn.total as total_alunos, aa.aprovados as alunos_aprovados, 
  round(((aa.aprovados * 1.0) / (tn.total * 1.0)) * 100.0, 2) || '%' as percentual_aprovados
from total_notas tn, alunos_aprovados aa

--Consulta 5: Porcentagem dos alunos que estão aprovados por disciplina
with total_notas as (
  select id_disciplina, count(*) as total from Notas group by id_disciplina),
alunos_aprovados as (
  select id_disciplina, count(id_disciplina) as aprovados from Notas where nota > 6.0 group by id_disciplina)
select d.Nome_Disciplina, 
  round(((aa.aprovados * 1.0) / (tn.total * 1.0)) * 100.0, 2) || '%' as percentual_aprovados
from total_notas tn, alunos_aprovados aa
join Disciplinas d on aa.id_disciplina = d.ID_Disciplina
group by d.Nome_Disciplina
order by d.ID_Disciplina