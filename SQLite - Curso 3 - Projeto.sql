--Desafio

--Consulta 1: Buscar o nome do professor e a turma que ele é orientador
select p.Nome_Professor, t.Nome_Turma as Orientador_Turma
from Professores p
join turmas t on p.ID_Professor = t.ID_Professor_Orientador

--Consulta 2: Retornar o nome e a nota do aluno que possui a melhor nota na disciplina de Matemática
select a.Nome_Aluno, m.maior_nota  from Alunos a
join (
select id_aluno, max(nota) as maior_nota from notas where id_disciplina = (
select id_disciplina from Disciplinas where nome_disciplina = 'Matemática')) as m
on a.ID_Aluno = m.id_aluno

--Consulta 3: Identificar o total de alunos por turma
select t.Nome_Turma, count(ta.ID_Aluno) as total_alunos
from Turmas t
join Turma_Alunos ta on t.ID_Turma = ta.ID_Turma
group by t.Nome_Turma

--Consulta 4: Listar os Alunos e as disciplinas em que estão matriculados
select a.Nome_Aluno, t.Nome_Turma, d.Nome_Disciplina
from Turma_Alunos ta
join Turma_Disciplinas td on ta.ID_Turma = td.ID_Turma
join alunos a on ta.ID_Aluno = a.ID_Aluno
join Disciplinas d on td.ID_Disciplina = d.ID_Disciplina
join turmas t on ta.ID_Turma = t.ID_Turma
order by a.Nome_Aluno

--Consulta 5: Criar uma view que apresenta o nome, a disciplina e a nota dos alunos
create view ViewEscola as
SELECT a.Nome_Aluno, d.Nome_Disciplina, n.Nota, n.Data_Avaliacao
from alunos a
join Disciplinas d on d.ID_Disciplina = n.ID_Disciplina
Join notas n on n.ID_Aluno = a.ID_Aluno
