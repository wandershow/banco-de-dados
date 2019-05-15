--1) Mostrar o título dos livros sobre PostgreSQL não locados por alunos do Curso Superior de Tecnologia em Análise e Desenvolvimento de Sistemas.
--Minha
select livro.titulo from locacao
join exemplar on locacao.exemplar = exemplar.codigo
join livro on exemplar.livro = livro.codigo
join usuario on locacao.usuario = usuario.codigo
where lower(livro.titulo) like '%postgresql%'
and lower(livro.titulo) not in(
select livro.titulo from locacao
join exemplar on locacao.exemplar = exemplar.codigo
join livro on exemplar.livro = livro.codigo
join usuario on locacao.usuario = usuario.codigo
where lower(usuario.tipo) = 'a'
and lower(usuario.curso) = 'curso superior de tecnologia em analise e desenvolvimento de sistemas'
and lower(livro.titulo) like '%postgresql%' group by 1);

--Usando EXCEPT
(select livro.titulo
from livro
where lower(livro.titulo) like '%postgresql%')
except
(select livro.titulo from locacao
join exemplar on locacao.exemplar = exemplar.codigo
join livro on exemplar.livro = livro.codigo
join usuario on locacao.usuario = usuario.codigo
where lower(livro.titulo) like '%postgresql%'
and lower(usuario.tipo) = 'a'
and lower(usuario.curso) = 'curso superior de tecnologia em analise e desenvolvimento de sistemas');

--Usando NOT IN
select livro.titulo
from livro
where lower(livro.titulo) like '%postgresql%'
and livro.codigo not in(select livro.codigo
                        from locacao
                        join exemplar on locacao.exemplar = exemplar.codigo
                        join livro on exemplar.livro = livro.codigo
                        join usuario on locacao.usuario = usuario.codigo
                        where lower(livro.titulo) like '%postgresql%'
                        and lower(usuario.tipo) = 'a'
                        and lower(usuario.curso) = 'curso superior de tecnologia em analise e desenvolvimento de sistemas');


--2) Mostrar o nome do último aluno que locou o livro PostgreSQL na prática.
--Minha
select usuario.nome, livro.titulo, locacao.retirada from locacao
join exemplar on locacao.exemplar = exemplar.codigo
join livro on exemplar.livro = livro.codigo
join usuario on locacao.usuario = usuario.codigo
where lower(usuario.tipo) = 'a' and lower(livro.titulo) = 'postgresql na pratica'
group by 1,2,3
having locacao.retirada =(
select locacao.retirada from locacao
join exemplar on locacao.exemplar = exemplar.codigo
join livro on exemplar.livro = livro.codigo
join usuario on locacao.usuario = usuario.codigo
where lower(usuario.tipo) = 'a' and lower(livro.titulo) = 'postgresql na pratica' order by 1 desc limit 1);

--
select usuario.nome from locacao
join exemplar on locacao.exemplar = exemplar.codigo
join livro on exemplar.livro = livro.codigo
join usuario on locacao.usuario = usuario.codigo
where usuario.tipo = 'A' and lower(livro.titulo) = 'postgresql na pratica'
and locacao.retirada = (select max(locacao.retirada)
                        from locacao
                        join exemplar on locacao.exemplar = exemplar.codigo
                        join livro on exemplar.livro = livro.codigo
                        join usuario on locacao.usuario = usuario.codigo
                        where usuario.tipo = 'A' and lower(livro.titulo) = 'postgresql na pratica');


--3) Mostrar o título dos livros sobre PostgreSQL menos locados.
--Minha
select livro.titulo, count(*) from locacao
join exemplar on locacao.exemplar = exemplar.codigo
join livro on exemplar.livro = livro.codigo
join usuario on locacao.usuario = usuario.codigo
where lower(livro.titulo) like '%postgresql%' group by 1
having count(*) =
(select tmp1.contador from
(select livro.titulo, count(*) as contador from locacao
join exemplar on locacao.exemplar = exemplar.codigo
join livro on exemplar.livro = livro.codigo
join usuario on locacao.usuario = usuario.codigo
where lower(livro.titulo) like '%postgresql%' group by 1 order by 2 asc limit 1) as tmp1);

--
select livro.titulo
from locacao
join exemplar on locacao.exemplar = exemplar.codigo
join livro on exemplar.livro = livro.codigo
where lower(livro.titulo) like '%postgresql%'
group by livro.titulo
having count(*) =(select count(*)
                  from locacao
                  join exemplar on locacao.exemplar = exemplar.codigo
                  join livro on exemplar.livro = livro.codigo
                  where lower(livro.titulo) like '%postgresql%' group by livro.titulo order by 1 asc limit 1);



--4) Mostrar o nome dos alunos e dos professores que locaram mais livros em março de 2018.
--Minha (ela tem o seguinte erro, caso aluno tenha pego 15 e professore 13, se um aluno pegar 13 ele também aparece)
select tmp10.nome from(
select usuario.nome, count(*) as contador_definitivo from locacao
join exemplar on locacao.exemplar = exemplar.codigo
join livro on exemplar.livro = livro.codigo
join usuario on locacao.usuario = usuario.codigo
where lower(usuario.tipo) = 'a' or lower(usuario.tipo) = 'p'
and locacao.retirada between '2018-03-01' AND '2018-03-31' group by 1) as tmp10
where tmp10.contador_definitivo in
(select tmp3.contador_final from
(select tmp2.tipo, max(tmp2.contador2) as contador_final from
(select usuario.nome, usuario.tipo, count(*) as contador2 from locacao
join exemplar on locacao.exemplar = exemplar.codigo
join livro on exemplar.livro = livro.codigo
join usuario on locacao.usuario = usuario.codigo
where lower(usuario.tipo) = 'a' or lower(usuario.tipo) = 'p'
and locacao.retirada between '2018-03-01' AND '2018-03-31' group by 1,2 order by 3 desc) as tmp2
where lower(tmp2.tipo) = 'a' or lower(tmp2.tipo) = 'p' group by 1) as tmp3);

--
(select usuario.nome
from locacao
join usuario on usuario.codigo = locacao.usuario
where usuario.tipo = 'A' and locacao.retirada between '2018-03-01' AND '2018-03-31' group by usuario.codigo
having count(*) = (select count(*)
                  from locacao
                  join usuario on usuario.codigo = locacao.usuario
                  where usuario.tipo = 'A' and locacao.retirada between '2018-03-01' AND '2018-03-31' group by usuario.codigo order by 1 desc limit 1))
UNION
(select usuario.nome
from locacao
join usuario on usuario.codigo = locacao.usuario
where usuario.tipo = 'P' and locacao.retirada between '2018-03-01' AND '2018-03-31'  group by usuario.codigo
having count(*) = (select count(*)
                  from locacao
                  join usuario on usuario.codigo = locacao.usuario
                  where usuario.tipo = 'P' and locacao.retirada between '2018-03-01' AND '2018-03-31' group by usuario.codigo order by 1 desc limit 1));
