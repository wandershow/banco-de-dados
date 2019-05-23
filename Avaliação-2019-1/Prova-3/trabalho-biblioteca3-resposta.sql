-- Sabendo que o prazo de locação é de 21 dias para professores, 14 dias para funcionários e 7 dias para alunos:
--1) Mostrar a quantidade de alunos por curso que não atrasaram entrega de livros nos últimos 3 meses.
--Minha
select tmp2.curso, count(*) as quantidade_de_aluno from
(select tmp1.nome,tmp1.curso,tmp1.teste from
(select usuario.nome, usuario.curso,(locacao.entrega - locacao.retirada) as teste,locacao.entrega,locacao.retirada from locacao
join exemplar on locacao.exemplar = exemplar.codigo
join livro on exemplar.livro = livro.codigo
join usuario on locacao.usuario = usuario.codigo
where locacao.retirada >= (now()-'3 month'::interval)::date and usuario.tipo = 'A') as tmp1
where tmp1.teste <= 7 or now()::date - tmp1.retirada <= 7 group by 1,2,3 order by 2,3 desc) as tmp2
group by 1 order by 2 desc;

--
select curso, count(*) from usuario where tipo = 'A' and codigo
not in (
  select locacao.usuario from locacao
  join usuario on usuario.codigo = locacao.usuario
  where  usuario.tipo = 'A' and locacao.retirada >= now()-'3 month'::interval
  and
  ((locacao.entrega is not null and locacao.entrega-locacao.retirada > 7)
  or
  (locacao.entrega is null and now()::date-locacao.retirada > 7)))
  group by 1 order by 2 desc;



--2) Mostrar, de duas formas diferentes, o nome dos usuários que atrasaram entrega de livros nos últimos 3 meses.
--Minha
select * from(
(select distinct tmp2.nome from
(select tmp1.nome,tmp1.teste from
(select usuario.nome,(locacao.entrega - locacao.retirada) as teste,locacao.entrega,locacao.retirada from locacao
join usuario on locacao.usuario = usuario.codigo
where locacao.retirada >= (now()-'3 month'::interval)::date and usuario.tipo = 'A') as tmp1
where tmp1.teste > 7 or now()::date - tmp1.retirada > 7 group by 1,2 order by 1) as tmp2 group by 1 order by 1)
UNION
(select distinct tmp2.nome from
(select tmp1.nome,tmp1.teste from
(select usuario.nome,(locacao.entrega - locacao.retirada) as teste,locacao.entrega,locacao.retirada from locacao
join usuario on locacao.usuario = usuario.codigo
where locacao.retirada >= (now()-'3 month'::interval)::date and usuario.tipo = 'F') as tmp1
where tmp1.teste > 14 or now()::date - tmp1.retirada > 14 group by 1,2 order by 1) as tmp2 group by 1 order by 1)
UNION
(select distinct tmp2.nome from
(select tmp1.nome,tmp1.teste from
(select usuario.nome,(locacao.entrega - locacao.retirada) as teste,locacao.entrega,locacao.retirada from locacao
join usuario on locacao.usuario = usuario.codigo
where locacao.retirada >= (now()-'3 month'::interval)::date and usuario.tipo = 'P') as tmp1
where tmp1.teste > 21 or now()::date - tmp1.retirada > 21 group by 1,2 order by 1) as tmp2 group by 1 order by 1)) as tmp10 order by 1;
----------------------------------------------------------------------------------------------------------------------------------------
--Minha
select * from(
(select nome from usuario where tipo ='A' and codigo in
(select distinct teste3.usuario from
  (select teste2.usuario from
    (select * from
      (select usuario, (entrega - retirada) as conta, retirada, entrega from locacao
      where retirada >= (now()-'3 month'::interval)::date)
      as teste1
    where teste1.conta > 7 or now()::date - teste1.retirada > 7 order by 1)
   as teste2)as teste3))
UNION
(select nome from usuario where tipo ='F' and codigo in
(select distinct teste3.usuario from
  (select teste2.usuario from
    (select * from
      (select usuario, (entrega - retirada) as conta, retirada, entrega from locacao
      where retirada >= (now()-'3 month'::interval)::date)
      as teste1
    where teste1.conta > 14 or now()::date - teste1.retirada > 14 order by 1)
   as teste2)as teste3))
UNION
(select nome from usuario where tipo ='P' and codigo in
(select distinct teste3.usuario from
  (select teste2.usuario from
    (select * from
      (select usuario, (entrega - retirada) as conta, retirada, entrega from locacao
      where retirada >= (now()-'3 month'::interval)::date)
      as teste1
    where teste1.conta > 21 or now()::date - teste1.retirada > 21 order by 1)
   as teste2)as teste3))) as finalmente order by 1;

--1 forma
(select usuario.nome from locacao
join usuario on usuario.codigo = locacao.usuario
where  usuario.tipo = 'A' and locacao.retirada >= now()-'3 month'::interval
and
((locacao.entrega is not null and locacao.entrega-locacao.retirada > 7)
or
(locacao.entrega is null and now()::date-locacao.retirada > 7)))
UNION
(select usuario.nome from locacao
join usuario on usuario.codigo = locacao.usuario
where  usuario.tipo = 'F' and locacao.retirada >= now()-'3 month'::interval
and
((locacao.entrega is not null and locacao.entrega-locacao.retirada > 14)
or
(locacao.entrega is null and now()::date-locacao.retirada > 14)))
UNION
(select usuario.nome from locacao
join usuario on usuario.codigo = locacao.usuario
where  usuario.tipo = 'p' and locacao.retirada >= now()-'3 month'::interval
and
((locacao.entrega is not null and locacao.entrega-locacao.retirada > 21)
or
(locacao.entrega is null and now()::date-locacao.retirada > 21)));

--2 forma
select distinct usuario.nome from locacao
join usuario on usuario.codigo = locacao.usuario
where locacao.retirada >= now()-'3 month'::interval
and
((locacao.entrega is not null and locacao.entrega-locacao.retirada > case usuario.tipo
when 'A' then 7 when 'F' then 14 when 'P' then 21 end)
or
(locacao.entrega is null and now()::date-locacao.retirada > case usuario.tipo
when 'A' then 7 when 'F' then 14 when 'P' then 21 end));

--3) Mostrar o nome dos alunos com a 1a, 2a e 3a maior quantidade de locações de livros sobre PostgreSQL nos últimos 9 meses.
select * from(
(select usuario.nome,count(*) as teste from locacao
join exemplar on locacao.exemplar = exemplar.codigo
join livro on exemplar.livro = livro.codigo
join usuario on locacao.usuario = usuario.codigo
where locacao.retirada >= (now()-'9 month'::interval)::date and usuario.tipo = 'A'
and lower(livro.titulo) like '%postgresql%' group by 1
having count(*)=
(select tmp1.teste from
(select usuario.nome,count(*) as teste from locacao
join exemplar on locacao.exemplar = exemplar.codigo
join livro on exemplar.livro = livro.codigo
join usuario on locacao.usuario = usuario.codigo
where locacao.retirada >= (now()-'9 month'::interval)::date and usuario.tipo = 'A'
and lower(livro.titulo) like '%postgresql%' group by 1 order by 2 desc) as tmp1
group by 1 order by 1 desc limit 1 offset 0))
UNION
(select usuario.nome,count(*) as teste from locacao
join exemplar on locacao.exemplar = exemplar.codigo
join livro on exemplar.livro = livro.codigo
join usuario on locacao.usuario = usuario.codigo
where locacao.retirada >= (now()-'9 month'::interval)::date and usuario.tipo = 'A'
and lower(livro.titulo) like '%postgresql%' group by 1
having count(*)=
(select tmp1.teste from
(select usuario.nome,count(*) as teste from locacao
join exemplar on locacao.exemplar = exemplar.codigo
join livro on exemplar.livro = livro.codigo
join usuario on locacao.usuario = usuario.codigo
where locacao.retirada >= (now()-'9 month'::interval)::date and usuario.tipo = 'A'
and lower(livro.titulo) like '%postgresql%' group by 1 order by 2 desc) as tmp1
group by 1 order by 1 desc limit 1 offset 1))
UNION
(select usuario.nome,count(*) as teste from locacao
join exemplar on locacao.exemplar = exemplar.codigo
join livro on exemplar.livro = livro.codigo
join usuario on locacao.usuario = usuario.codigo
where locacao.retirada >= (now()-'9 month'::interval)::date and usuario.tipo = 'A'
and lower(livro.titulo) like '%postgresql%' group by 1
having count(*)=
(select tmp1.teste from
(select usuario.nome,count(*) as teste from locacao
join exemplar on locacao.exemplar = exemplar.codigo
join livro on exemplar.livro = livro.codigo
join usuario on locacao.usuario = usuario.codigo
where locacao.retirada >= (now()-'9 month'::interval)::date and usuario.tipo = 'A'
and lower(livro.titulo) like '%postgresql%' group by 1 order by 2 desc) as tmp1
group by 1 order by 1 desc limit 1 offset 2))) as final order by 2 desc,1;

--
select usuario.nome, count(*) as quantidade from locacao
join exemplar on locacao.exemplar = exemplar.codigo
join livro on exemplar.livro = livro.codigo
join usuario on locacao.usuario = usuario.codigo
where usuario.tipo = 'A' and lower(livro.titulo) like '%postgresql%'
and locacao.retirada >= now()-'9 month'::interval
group by usuario.codigo having count(*) in(
select distinct count(*) from locacao
join exemplar on locacao.exemplar = exemplar.codigo
join livro on exemplar.livro = livro.codigo
join usuario on locacao.usuario = usuario.codigo
where usuario.tipo = 'A' and lower(livro.titulo) like '%postgresql%'
and locacao.retirada >= now()-'9 month'::interval
group by usuario.codigo order by 1 desc limit 3)
order by 2 desc;
