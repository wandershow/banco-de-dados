----------------------------------------------------------------------------------------------------
--1) Mostrar o nome e o curso dos alunos de cursos técnicos que locaram livros sobre PostgreSQL nos últimos 3 meses.
--MINHA
select usuario.nome,usuario.curso from usuario
join locacao on locacao.usuario = usuario.codigo
where lower(usuario.curso) like 'curso tecnico%' and lower(usuario.tipo) = 'a'
and usuario.codigo in
  (select locacao.usuario from livro
    join exemplar on exemplar.livro = livro.codigo
    join locacao on locacao.exemplar = exemplar.codigo
    where lower(livro.titulo) like '%postgresql%' and locacao.retirada >= (now()-'3 month'::interval)::date
  group by 1)
group by 1,2;

--Passo a Passo
select * from usuario;
--Aluno de curso técnicos
select * from usuario where lower(usuario.tipo) = 'a' and  lower(usuario.curso) like 'curso tecnico%';
--TODAS locacao de 3 meses atras
select * from locacao where locacao.retirada now()-'3 month'::interval;
--Pegar Todos Livros de PostgreSQL
select * from livro where lower(livro.titulo) like '%postgresql%';
--Exemplar de um livro
select * from exemplar where exemplar.livro = 20;
--Livros locados a 3 meses atras com exemplar igual a/ou
select * from locacao where (locacao.retirada now()-'3 month'::interval) and ((locacao.exemplar = 20001)
or (locacao.exemplar = 20002) or (locacao.exemplar = 20003);
--Mesma coisa mas usando in
select * from locacao where locacao.retirada now()-'3 month'::interval and locacao.exemplar in (20001, 20002, 20003);
--Adicionou mais variavel
select * from locacao where locacao.retirada now()-'3 month'::interval and locacao.exemplar in (4001, 4002, 4003, 4004,20001, 20002, 20003);


--OUTRA
--Só os exemplares  que foram retirados nos ultimos 3 meses
select locacao.exemplar from locacao where (locacao.retirada >= now()-'3 month'::interval)
--Todos codigo de exemplar onde o codigo esteja em
select exemplar.livro from exemplar where exemplar.codigo in()
--Tudo de livro onde o codigo de livro esteja em
select * from livro where livro.codigo in ()
--Tudo Junto (titulo dos livro PostgreSQL locados nos ultimos 3 meses)
select * from livro where
lower(livro.titulo) like '%postgresql%' and
livro.codigo in
(select exemplar.livro from exemplar where exemplar.codigo in
  (select locacao.exemplar from locacao where locacao.retirada >= now()-'3 month'::interval));
--Mesma coisa usando JOIN
select * from locacao join exemplar on exemplar.codigo = locacao.exemplar
join livro on livro.codigo = exemplar.livro
where lower(livro.titulo) like '%postgresql%' and locacao.retirada >= now()-'3 month'::interval
--Aluno de curso tecnico
select * from usuario where usuario.tipo = 'A' and lower(usuario.curso) like 'curso%tecnico%' and
usuario.codigo in ()
--Resposta final usando IN
select usuario.nome, usuario.curso from usuario where usuario.tipo = 'A' and lower(usuario.curso) like 'curso%tecnico%' and
usuario.codigo in (select locacao.usuario from locacao join exemplar on exemplar.codigo = locacao.exemplar
join livro on livro.codigo = exemplar.livro
where lower(livro.titulo) like '%postgresql%' and locacao.retirada >= now()-'3 month'::interval);
--Tentando com JOIN
select usuario.nome, usuario.curso from usuario where usuario.tipo = 'A' and lower(usuario.curso) like 'curso%tecnico%' and
usuario.codigo in (select locacao.usuario from locacao join exemplar on exemplar.codigo = locacao.exemplar
join livro on livro.codigo = exemplar.livro
join usuario on usuario.codigo = locacao.usuario
where lower(livro.titulo) like '%postgresql%' and locacao.retirada >= now()-'3 month'::interval
and usuario.tipo = 'A' and lower(usuario.curso) like 'curso%tecnico%');
--E se tiver repitido?
update locacao set exemplar = 4001 where usuario = 22 and exemplar = 7002 and retirada = '2019-04-07';
--Arrumando caso repita (coloca group by)
select usuario.nome, usuario.curso from usuario where usuario.tipo = 'A' and lower(usuario.curso) like 'curso%tecnico%' and
usuario.codigo in (select locacao.usuario from locacao join exemplar on exemplar.codigo = locacao.exemplar
join livro on livro.codigo = exemplar.livro
join usuario on usuario.codigo = locacao.usuario
where lower(livro.titulo) like '%postgresql%' and locacao.retirada >= now()-'3 month'::interval
and usuario.tipo = 'A' and lower(usuario.curso) like 'curso%tecnico%') group by 1,2;




--2) Mostrar o ranking dos livros mais locados por curso no ano passado.
--MINHA
select  usuario.curso,livro.titulo, count(*) from locacao
join usuario on locacao.usuario = usuario.codigo
join exemplar on locacao.exemplar = exemplar.codigo
join livro on livro.codigo = exemplar.livro
where usuario.curso is not null and (locacao.retirada between (now()-'2 year'::interval)::date and (now()-'1 year'::interval)::date)
group by 1,2 order by 1,count(*) desc,2;
--Arrumando a minha (erro na data)
select  usuario.curso,livro.titulo, count(*) from locacao
join usuario on locacao.usuario = usuario.codigo
join exemplar on locacao.exemplar = exemplar.codigo
join livro on livro.codigo = exemplar.livro
where usuario.curso is not null and (date_part('year', locacao.retirada) = date_part('year', now())-1)
group by 1,2 order by 1,count(*) desc,2;

--locacao no ano passado
select * from locacao where date_part('year', locacao.retirada) = date_part('year', now())-1;
--Botando todos os JOIN
select *
from locacao
join exemplar on exemplar.codigo = locacao.exemplar
join livro on livro.codigo = exemplar.livro
join usuario on usuario.codigo = locacao.usuario
where date_part('year', locacao.retirada) = date_part('year', now())-1 usuario.tipo = 'A';
--Oque quer buscar
select usuario.curso, livro.titulo
from locacao
join exemplar on exemplar.codigo = locacao.exemplar
join livro on livro.codigo = exemplar.livro
join usuario on usuario.codigo = locacao.usuario
where date_part('year', locacao.retirada) = date_part('year', now())-1 usuario.tipo = 'A';
--Agrupando e contando
select usuario.curso, livro.titulo, count(*) as quantidade
from locacao
join exemplar on exemplar.codigo = locacao.exemplar
join livro on livro.codigo = exemplar.livro
join usuario on usuario.codigo = locacao.usuario
where date_part('year', locacao.retirada) = date_part('year', now())-1 usuario.tipo = 'A' group by 1,2;
--Ordenando
select usuario.curso, livro.titulo, count(*) as quantidade
from locacao
join exemplar on exemplar.codigo = locacao.exemplar
join livro on livro.codigo = exemplar.livro
join usuario on usuario.codigo = locacao.usuario
where date_part('year', locacao.retirada) = date_part('year', now())-1 usuario.tipo = 'A' group by 1,2 order by 1 asc, 3 desc, 2 asc;

--Contando quantas vezes cada exemplar foi retirado no ultimo ano
select locacao.exemplar, count(*) as quantidade from locacao
where date_part('year', locacao.retirada) = date_part('year', now())-1 group by 1



--3) Mostrar o nome dos alunos do Curso Superior de Tecnologia em Análise e Desenvolvimento de Sistemas que locaram mais de uma vez o mesmo livro sobre PostgreSQL.
--MINHA
select usuario.nome from usuario
  join locacao on locacao.usuario = usuario.codigo
  where lower(usuario.curso) = 'curso superior de tecnologia em analise e desenvolvimento de sistemas' and lower(usuario.tipo) = 'a'
  and usuario.codigo in
    (select tmp2.usuario from
      (select * from
        (select locacao.usuario,livro.titulo,count(*) as contador from livro
          join exemplar on exemplar.livro = livro.codigo
          join locacao on locacao.exemplar = exemplar.codigo
          where lower(livro.titulo) like '%postgresql%' group by 1,2) as tmp1
      group by 1,2,3 having tmp1.contador > 1) as tmp2)
group by 1;

--Dados completo da locacao
select * from locacao
join exemplar on exemplar.codigo = locacao.exemplar
join livro on exemplar.livro = livro.codigo
join usuario on usuario.codigo = locacao.usuario
--Mostrar usuario e o codigo com livro que pegou
select usuario.codigo, usuario.nome, livro.titulo from locacao
join exemplar on exemplar.codigo = locacao.exemplar
join livro on exemplar.livro = livro.codigo
join usuario on usuario.codigo = locacao.usuario
--Contando e Ordenando
select usuario.codigo, usuario.nome, livro.titulo,count(*) as quantidade from locacao
join exemplar on exemplar.codigo = locacao.exemplar
join livro on exemplar.livro = livro.codigo
join usuario on usuario.codigo = locacao.usuario
group by 1,2,3 order by 1 asc, 2 asc;
--Contagem mas só de alunos do TADS
select usuario.codigo, usuario.nome, livro.titulo,count(*) as quantidade from locacao
join exemplar on exemplar.codigo = locacao.exemplar
join livro on exemplar.livro = livro.codigo
join usuario on usuario.codigo = locacao.usuario
where usuario.tipo = 'A' and lower(usuario.curso) = 'curso superior de tecnologia em analise e desenvolvimento de sistemas'
group by 1,2,3 order by 1 asc, 2 asc;
--E que os livros fosse de PostgreSQL
select usuario.codigo, usuario.nome, livro.titulo,count(*) as quantidade from locacao
join exemplar on exemplar.codigo = locacao.exemplar
join livro on exemplar.livro = livro.codigo
join usuario on usuario.codigo = locacao.usuario
where usuario.tipo = 'A' and lower(usuario.curso) = 'curso superior de tecnologia em analise e desenvolvimento de sistemas' and
lower(livro.titulo) like '%postgresql%'
group by 1,2,3 order by 1 asc, 2 asc;
--Mais de uma vez
select usuario.codigo, usuario.nome, livro.titulo,count(*) as quantidade from locacao
join exemplar on exemplar.codigo = locacao.exemplar
join livro on exemplar.livro = livro.codigo
join usuario on usuario.codigo = locacao.usuario
where usuario.tipo = 'A' and lower(usuario.curso) = 'curso superior de tecnologia em analise e desenvolvimento de sistemas' and
lower(livro.titulo) like '%postgresql%'
group by 1,2,3
having count(*) > 1
order by 1 asc, 2 asc;
--Mostrando só o nome e colocando distinct para caso um aluno alugue 2 livros de postgresql mais de 2x
select distinct(usuario.nome) from locacao
join exemplar on exemplar.codigo = locacao.exemplar
join livro on exemplar.livro = livro.codigo
join usuario on usuario.codigo = locacao.usuario
where usuario.tipo = 'A' and lower(usuario.curso) = 'curso superior de tecnologia em analise e desenvolvimento de sistemas' and
lower(livro.titulo) like '%postgresql%'
group by usuario.codigo, livro.titulo
having count(*) > 1;



--4) Mostrar o título dos livros sobre PostgreSQL não locados nos últimos 3 meses.
select livro.titulo from livro
join exemplar on exemplar.livro = livro.codigo
join locacao on locacao.exemplar = exemplar.codigo
where lower(livro.titulo) like '%postgresql%' and livro.titulo not in(
  select livro.titulo from livro
  join exemplar on exemplar.livro = livro.codigo
  join locacao on locacao.exemplar = exemplar.codigo
  where lower(livro.titulo) like '%postgresql%' and locacao.retirada >= (now()-'3 month'::interval)::date
  group by 1);

--Pega parte da primeira resposta coloca not in
select livro.titulo from livro
where lower(livro.titulo) like '%postgresql%'
and livro.codigo not in (select livro.codigo from locacao join exemplar on exemplar.codigo = locacao.exemplar
join livro on livro.codigo = exemplar.livro
join usuario on usuario.codigo = locacao.usuario
where lower(livro.titulo) like '%postgresql%' and locacao.retirada >= now()-'3 month'::interval)

--Usa EXECEPT
(select livro.titulo from livro
where lower(livro.titulo) like '%postgresql%')
execept
(select livro.titulo from locacao join exemplar on exemplar.codigo = locacao.exemplar
join livro on livro.codigo = exemplar.livro
join usuario on usuario.codigo = locacao.usuario
where lower(livro.titulo) like '%postgresql%' and locacao.retirada >= now()-'3 month'::interval);

--5) Mostrar o tempo médio das locações de alunos do Curso Superior de Tecnologia em Análise e Desenvolvimento de Sistemas.
--MINHA
select avg(locacao.entrega-locacao.retirada) as tempo_medio from usuario
join locacao on locacao.usuario = usuario.codigo
where lower(usuario.curso) = 'curso superior de tecnologia em analise e desenvolvimento de sistemas' and lower(usuario.tipo) = 'a';
--Arrumar tem que por IS NOT NULL
select avg(locacao.entrega-locacao.retirada) as tempo_medio from usuario
join locacao on locacao.usuario = usuario.codigo
where lower(usuario.curso) = 'curso superior de tecnologia em analise e desenvolvimento de sistemas' and lower(usuario.tipo) = 'a'
and locacao.entrega is not null;


select * from locacao
join usuario on usuario.codigo = locacao.usuario
where usuario.tipo = 'A' and lower(usuario.curso) = 'curso superior de tecnologia em analise e desenvolvimento de sistemas';
--Validando pro calculo tem que ser tudo "certo" então tem que ter pego e entregue
select * from locacao
join usuario on usuario.codigo = locacao.usuario
where usuario.tipo = 'A' and lower(usuario.curso) = 'curso superior de tecnologia em analise e desenvolvimento de sistemas'
and locacao.entrega is not null;
--Para cada linha vai calcular quantos dias o aluno ficou com o livro
select *, locacao.entrega - locacao.retirada from locacao
join usuario on usuario.codigo = locacao.usuario
where usuario.tipo = 'A' and lower(usuario.curso) = 'curso superior de tecnologia em analise e desenvolvimento de sistemas'
and locacao.entrega is not null;
--Para cada conta faz a média
select avg(locacao.entrega - locacao.retirada) as media from locacao
join usuario on usuario.codigo = locacao.usuario
where usuario.tipo = 'A' and lower(usuario.curso) = 'curso superior de tecnologia em analise e desenvolvimento de sistemas'
and locacao.entrega is not null;
