--Sabendo que o prazo de locação é de 21 dias para professores, 14 dias para funcionários e 7 dias para alunos,
-- e ainda que a multa por atraso é de R$ 0,75 por dia:
--1) Mostrar o nome do aluno que pagou o maior valor total em multas nos últimos 3 meses. (soma total de multa de 1 pessoa)
--MINHA
select tmp1.nome from(
select usuario.nome,sum((locacao.entrega-locacao.retirada-7)*0.75) as pagou
from locacao
join usuario on usuario.codigo = locacao.usuario
where locacao.retirada >= now()-'3 month'::interval
and usuario.tipo = 'A'
and (locacao.entrega is not null and locacao.entrega-locacao.retirada > 7) group by usuario.nome) as tmp1
where tmp1.pagou =
(select sum((locacao.entrega-locacao.retirada-7)*0.75) as pagou
from locacao
join usuario on usuario.codigo = locacao.usuario
where locacao.retirada >= now()-'3 month'::interval
and usuario.tipo = 'A'
and (locacao.entrega is not null and locacao.entrega-locacao.retirada > 7)
group by usuario.codigo order by 1 desc limit 1);

----
select usuario.nome
  from locacao
join usuario on usuario.codigo = locacao.usuario
where usuario.tipo = 'A' and locacao.retirada >= now()-'3 month'::interval
and locacao.entrega is not null
and locacao.entrega-locacao.retirada>7
group by usuario.codigo
having sum((locacao.entrega-locacao.retirada-7)*0.75)=
(select sum((locacao.entrega-locacao.retirada-7)*0.75) as multa
  from locacao
join usuario on usuario.codigo = locacao.usuario
where usuario.tipo = 'A' and locacao.retirada >= now()-'3 month'::interval
and locacao.entrega is not null
and locacao.entrega-locacao.retirada>7
group by locacao.usuario order by 1 desc limit 1);


--2) Mostrar quanto foi arrecadado com pagamento de multas no mês passado.
select sum(tmp2.pagou) as arrecadado from
(select *,case tmp1.tipo
when 'A' then (tmp1.contador-7)* 0.75
when 'F' then (tmp1.contador-14)* 0.75
when 'P' then (tmp1.contador-21)* 0.75 end as pagou
from(
select usuario.nome,usuario.tipo,locacao.retirada,locacao.entrega, locacao.entrega-locacao.retirada as contador from locacao
join usuario on usuario.codigo = locacao.usuario
where date_part('year', locacao.retirada) = date_part('year', now())
and date_part('month', locacao.retirada) = date_part('month', now())-1
and date_part('day', locacao.retirada) between 1 and 31
and (locacao.entrega is not null and locacao.entrega-locacao.retirada > case usuario.tipo
when 'A' then 7 when 'F' then 14 when 'P' then 21 end) order by 1) as tmp1) as tmp2;

--
select sum((locacao.entrega-locacao.retirada -  case usuario.tipo when 'A' then 7 when 'F' then 14 when 'P' then 21 end)*0.75) as multa
  from locacao
join usuario on usuario.codigo = locacao.usuario
where
date_part('month',locacao.retirada) = date_part('month',now()-'1 months'::interval) and
date_part('year',locacao.retirada) = date_part('year',now()-'1 months'::interval)
and locacao.entrega is not null
and locacao.entrega-locacao.retirada > case usuario.tipo when 'A' then 7 when 'F' then 14 when 'P' then 21 end;



--3) Mostrar a quantidade de alunos por faixa de valor total pago em multa: $0, $0-$5, $5-$10, $10-$50, $50+, nos últimos 6 meses.
(select case when tmp2.teste > 0 then '$0' end as faixa, count (*) as quantidade
from
(select tmp1.codigo as teste
  from(
    (select usuario.codigo
      from locacao
      join usuario on usuario.codigo = locacao.usuario
      where locacao.retirada >= now()-'6 month'::interval
      and usuario.tipo = 'A'
      and (locacao.entrega is not null and locacao.entrega-locacao.retirada < 7)order by 1 desc)
      except
      (select usuario.codigo
      from locacao
      join usuario on usuario.codigo = locacao.usuario
      where locacao.retirada >= now()-'6 month'::interval
      and usuario.tipo = 'A'
      and (locacao.entrega is not null and locacao.entrega-locacao.retirada > 7)order by 1 desc)) as tmp1)as tmp2 group by 1)
UNION
(select case
when tmp1.pagou <= 5 then '$0-$5'
when tmp1.pagou <= 10 then '$5-$10'
when tmp1.pagou <= 50 then '$10-$50'
else '$50+' end as faixa, count(*) as quantidade
from (select sum((locacao.entrega-locacao.retirada-7)*0.75) as pagou
  from locacao
  join usuario on usuario.codigo = locacao.usuario
  where locacao.retirada >= now()-'6 month'::interval
  and usuario.tipo = 'A'
  and (locacao.entrega is not null and locacao.entrega-locacao.retirada > 7)
  group by usuario.codigo order by 1 desc) as tmp1
group by 1 order by 1);


--CASE
select case
when tmp1.multa = 0 then '1: $0'
when tmp1.multa <= 5 then '2: $0-$5'
when tmp1.multa <= 10 then '3: $5-$10'
when tmp1.multa <= 50 then '4: $10-$50'
else '$50+' end as faixa, count(*)
 from(
select usuario.codigo,sum((locacao.entrega-locacao.retirada > 7)::integer*(locacao.entrega-locacao.retirada - 7)*0.75) as multa
  from locacao
join usuario on usuario.codigo = locacao.usuario
where usuario.tipo ='A'
and locacao.retirada >= now()-'6 months'::interval
and locacao.entrega is not null
group by 1) as tmp1 group by 1 order by 1 asc;


--UNION
(select '1: $0' as faixa, count(*) as quantidade from (
select usuario.codigo,sum((locacao.entrega-locacao.retirada > 7)::integer*(locacao.entrega-locacao.retirada - 7)*0.75) as multa
  from locacao
join usuario on usuario.codigo = locacao.usuario
where usuario.tipo ='A'
and locacao.retirada >= now()-'6 months'::interval
and locacao.entrega is not null
group by 1) as tmp1 where tmp1.multa = 0)
UNION
(select '2: $0- $5' as faixa, count(*) as quantidade from (
select usuario.codigo,sum((locacao.entrega-locacao.retirada > 7)::integer*(locacao.entrega-locacao.retirada - 7)*0.75) as multa
  from locacao
join usuario on usuario.codigo = locacao.usuario
where usuario.tipo ='A'
and locacao.retirada >= now()-'6 months'::interval
and locacao.entrega is not null
group by 1) as tmp1 where tmp1.multa > 0 and tmp1.multa <= 5)
UNION
(select '$5- $10' as faixa, count(*) as quantidade from (
select usuario.codigo,sum((locacao.entrega-locacao.retirada > 7)::integer*(locacao.entrega-locacao.retirada - 7)*0.75) as multa
  from locacao
join usuario on usuario.codigo = locacao.usuario
where usuario.tipo ='A'
and locacao.retirada >= now()-'6 months'::interval
and locacao.entrega is not null
group by 1) as tmp1 where tmp1.multa > 5 and tmp1.multa <= 10)
UNION
(select '3: $10- $50' as faixa, count(*) as quantidade from (
select usuario.codigo,sum((locacao.entrega-locacao.retirada > 7)::integer*(locacao.entrega-locacao.retirada - 7)*0.75) as multa
  from locacao
join usuario on usuario.codigo = locacao.usuario
where usuario.tipo ='A'
and locacao.retirada >= now()-'6 months'::interval
and locacao.entrega is not null
group by 1) as tmp1 where tmp1.multa > 10 and tmp1.multa <= 50)
UNION
(select '4: $50 +' as faixa, count(*) as quantidade from (
select usuario.codigo,sum((locacao.entrega-locacao.retirada > 7)::integer*(locacao.entrega-locacao.retirada - 7)*0.75) as multa
  from locacao
join usuario on usuario.codigo = locacao.usuario
where usuario.tipo ='A'
and locacao.retirada >= now()-'6 months'::interval
and locacao.entrega is not null
group by 1) as tmp1 where tmp1.multa > 50) order by 1;




























select usuario.codigo,sum((locacao.entrega-locacao.retirada > 7)::integer*(locacao.entrega-locacao.retirada - 7)*0.75) as multa
  from locacao
join usuario on usuario.codigo = locacao.usuario
where usuario.tipo ='A'
and locacao.retirada >= now()-'6 months'::interval
and locacao.entrega is not null
group by 1
