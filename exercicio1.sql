1 Mostrar quantas vezes passou o programa friends no canal warner
select count(*)as qtd from programa where canal = 'WBT' and lower(nome) = 'friends';

2 mostrar em quantos dias diferentes passou o programa friends no canal warner
select count(distinct horario::date) as dias from programa where canal = 'WBT' and lower(nome) = 'friends';

3 mostrar quantas vezes passou/repetiu cada programa do canal werner
select lower(nome),count(lower(nome)) from programa where canal = 'WBT' group by lower(nome) order by 1 asc; -- quando usamos o group by nao usar distinct

4 mostrar o programa que mais repetiu no canal warner
select lower(nome) as nome, count(*) as quantidade from programa where canal = 'WBT' group by 1 having count(*) = (select count(*) as quantidade from programa where canal = 'WBT' group by lower(nome) order by 1 desc limit 1);

5 mostrar em quais dias passou o filme batman begins
select nome,(horario::date) from programa where lower(nome) like '%batman begins%';

6 mostrar em quais dias e canais passou o filme batman begins
select canal,(horario::date) from programa where lower(nome) like '%batman begins%';

7 mostrar quantos noticiarios (news) foram exbidos em 05/05/2009
select nome, count(horario::date) as dias from programa where (horario::date) = '2009-05-05'::date and lower(nome) like '%news%' group by nome ;

8 mostrar quais canais exibiram noticiarios (news) em 05/05/2009
select canal, count(horario::date) as dias from programa where (horario::date) = '2009-05-05'::date and lower(nome) like '%news%' group by canal ;

9 mostrar quais os noticiarios esportivos em 05/05/2009
