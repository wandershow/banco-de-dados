select * from produto ;
select * from produto where descricao like '%HD'; -- procurar oque acaba com HD
select * from produto where descricao like 'HD%'; -- procurar oque termina com HD
select * from produto where descricao like 'HD %';
select * from produto where descricao like '%HD % 500%GB%'; -- ta fazendo a seguinte busca "bla bla HD blabla 500blablaGB
select * from produto where descricao like '%HD % 500%GB%MAXTOR%';
select * from produto where lower(descricao) like '%hd %maxtor%'; --lower() tira do caps, nesse caso oque tiver no campo descrição vai tar em lower
select * from produto where descricao like upper('%hd %maxtor%'); --upper() bota em caps, nesse caso oq vier da pesquisa vem em CAPS
select * from produto where upper(descricao) like upper('%hd %maxtor%');
select * from produto where descricao ilike '%hd %maxtor%'; -- preferencia não utilizar, proibido em prova.

--select * from produto where descricao like '%"||upper('%forma%')||'%' and 
			      descricao like '%"||upper('%bolo')||'%' and 
			      descricao like '%'||upper('redonda')||'%";
			      
-- trim() tira os espaços.			      
select * from produto where descricao like '%'||upper(replace('hd maxtor',' ','%'))||'%';

-- FUNÇÕES DE AGREGRAÇÃO

select count(*) as quantidade from produto where lower(descricao) like '%hd% 500%gb%';
select count(*) from canal;
select count(*) from programa;
select count(*) from programa where canal = 'PLA';
select count(distinct nome) from programa where canal = 'PLA';
select count(*) as quantidade from produto where descricao like '%HD %MAXTOR%';
select min(preco) as menor_preco from produto where descricao like '%HD %MAXTOR%'; -- hd de menor preco
select max(preco) as maior_preco from produto where descricao like '%HD %MAXTOR%'; -- hd de maior preco
select avg(preco) as preco_medio from produto where descricao like '%HD %MAXTOR%'; -- hd com preco medio

-- SELECT E SUB-SELECT

select * from produto where (descricao like '%HD %MAXTOR%') and (preco = (select min(preco) from produto where descricao like '%HD %MAXTOR%'));


xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
select * from produto where (lower(descricao) like '%hd % 500%gb%');
xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx

select *, case when (tmp1.descricao < (select descricao from produto where (lower(descricao) like '%hd %1000%gb%') limit 1)) then 'menor' else 'maior' end as teste from (
select *  from produto
where (lower(descricao) like '%hd %gb%')
and
(preco = (select min(preco) as menor
from produto  where lower(descricao) like '%hd %gb%'))
) as tmp1
where lower(tmp1.descricao) not in
(select descricao from produto where (lower(descricao) like '%hd %1000%gb%'));


insert into produto (codigo,descricao,preco) values (99994,'HD EXT. 900 GB WESTERN DIG. MYBOOK ESSENTIAL 3.5" USB2.0',15)

select * from produto where (lower(descricao) like '%hd % 1%gb%');
1687  87
xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
select * 
from produto 
where (lower(descricao) like '%hd %gb%') 
and 
(preco = (select min(preco) as menor
	from produto 
	where lower(descricao) like '%hd %gb%'));
xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
	
	
select * 
from produto 
where (lower(descricao) like '%hd %100%gb%');


select nome_agencia,sum(saldo) as total from deposito group by nome_agencia having sum(saldo) >= 1000;
select * from produto group by descricao having










select * from produto where (descricao like '%HD %MAXTOR%') and (preco < (select avg(preco) from produto where descricao like '%HD %MAXTOR%'));
select * from (select * from produto where descricao like '%HD %MAXTOR%') as tmp1 where preco < 30;
select (select min(preco) from produto where descricao like '%HD %MAXTOR%') as minimo, (select avg(preco) from produto where descricao like '%HD %MAXTOR%') as media, (select max(preco) from produto where descricao like '%HD %MAXTOR%') as maximo;

\i bancoingles.sql 

select nome_agencia from deposito ;
select distinct nome_agencia from deposito ;
select nome_agencia from deposito group by nome_agencia;
select nome_agencia,count(*) as quantidade from deposito group by nome_agencia;
select nome_agencia,avg(saldo) as media from deposito group by nome_agencia;
select nome_agencia,count(nome_cliente) from deposito group by nome_agencia;
insert into deposito values ('Downtown',999,'Johnson',550);
select nome_agencia,count(nome_cliente) from deposito group by nome_agencia;
select nome_agencia,count(distinct nome_cliente) from deposito group by nome_agencia;
select * from (select nome_agencia,count(*) as quantidade from deposito group by nome_agencia) as tmp1 where quantidade >= 2;
select nome_agencia,count(*) as quantidade from deposito group by nome_agencia having count(*) >= 2;
select nome_agencia,sum(saldo) as total from deposito group by nome_agencia;
select nome_agencia,sum(saldo) as total from deposito group by nome_agencia having sum(saldo) >= 1000;




1-Mostrar quantas vezes passou o programa Friends no canal Warner
--select count(*) from programa where canal = 'WBT' and lower(nome) = 'friends';

2-Mostrar em quantos dias diferentes passou o programa Friends no canal Warner
--select count(distinct horario::date) from programa where lower(nome) = 'friends' and canal = 'WBT';

3-Mostrar quantas vezes passou/repetiu cada programa do canal Warner
--select nome,count(nome) from programa where programa.canal = 'WBT' group by programa.nome;

4-Mostrar o programa que mais repetiu no canal Warner
--LIMIT
--select lower(nome) as nome ,count(*) as quantidade from programa where canal = 'WBT' group by 1 having count(*)
= (select count(*) as quantidade from programa where canal = 'WBT' group by lower(nome) order by 1 desc limit 1);

--MAX
--select lower(nome) as nome ,count(*) as quantidade from programa where canal = 'WBT' group by 1 having count(*)
=(select max(quantidade) as maximo from (select nome, count(*) as quantidade from programa where canal = 'WBT' group by nome) as tmp1);

--corrigir
--select * from (select nome,count(*) as quantidade from programa where canal = 'WBT' group by nome) as tmp1 where 
quantidade = (select max(quantidade) from (select nome, count(*) from programa where canal = 'WBT' group by nome) as tmp2);


5-Mostrar em quais dias passou o filme Batman Begins
--select distinct horario::date from programa where lower(nome) = 'batman begins';

6-Mostrar em quais dias e canais passou o filme Batman Begins
--select horario::date, canal from programa where lower(nome) = 'batman begins';

7-Mostrar quantos noticiários (news) foram exibidios em 05/05/2009
--select count(distinct nome) from programa where horario::date = '05/05/2009' and lower(nome) like '%news%'

xx
--select count(distinct nome) from programa where horario::date = '05/05/2009' and lower(nome) like '%news%' group by nome,horario;
--select distinct nome from programa where horario::date = '05/05/2009' and lower(nome) like '%news%' group by nome,horario;
xx

8-Mostrar quantos canais exibiram noticiários (news) em 05/05/2009
select count(distinct canal) from programa where horario::date = '05/05/2009' and lower(nome) like '%news%';

9-Mostrar quais os noticiários esportivos em 05/05/2009
--select distinct nome,horario::date from programa where horario::date = '05/05/2009' and lower(nome) like '%news%' group by nome,horario;

10-Quais dias o canal wbt teve mais programa

select horario::date,count(*) from programa where canal = 'WBT' group by horario::date having count(*) 
=(select count(*) from programa where canal = 'WBT' group by horario::date order by 1 desc limit 1);
