Aula dia 02/04/2019

select 1+2*3;  -- resultado = 7 maneira errada   ** deixar tudo sempre explicito
select (1+2)*3; -- resultado = 9 maneira correta
select 1+(2*3); -- resultado = 7 maneira correta

select 1+(2*3) as resultado ;-- resultado = 7 maneira correta

bd1=# select CURRENT_DATE;
 current_date 
--------------
 2019-04-02
(1 row)

bd1=# select now();
             now              
------------------------------
 2019-04-02 19:44:36.01992-03
(1 row)

bd1=# select round(3.14151617181920,3);
 round 
-------
 3.142
(1 row)
******************************************************
bd1=# select pi()
bd1-# ;
        pi        
------------------
 3.14159265358979
(1 row)
******************************************************

bd1=# select '12.34'*2;
ERROR:  invalid input syntax for integer: "12.34"  -- assim  da erro
LINE 1: select '12.34'*2;
               ^
bd1=# select real '12.34';
 float4 
--------
  12.34
(1 row)

bd1=# select real '12.34'*2;   -- assim diz que e um real e faz a conta
     ?column?     
------------------
 24.6800003051758
(1 row)

bd1=# select real '12.34'::real; -- Assim transforma para Real
 float4 
--------
  12.34
(1 row)

bd1=# select cast('12.34' as real);  -- assim serve para todos bancos (oracle, postgre, my sql etc...)
 float4 
--------
  12.34
(1 row)

**********************************************************************************

\dfS+ // lista as funcoes/metodos disponiveis no postgre
**********************************************************************************

bd1=# select now()+'2 months 3 days 14 hours'::interval;
           ?column?           
------------------------------
 2019-06-06 10:13:58.36195-03
(1 row)

bd1=# select now()-'1 hours 25 minutes'::interval;
           ?column?            
-------------------------------
 2019-04-02 18:49:51.353084-03
(1 row)

bd1=# select '2019-04-02'+'5 hours'::interval;
ERROR:  invalid input syntax for type interval: "2019-04-02"
LINE 1: select '2019-04-02'+'5 hours'::interval;
               ^
bd1=# select '2019-04-02'::date+'5 hours'::interval;
      ?column?       
---------------------
 2019-04-02 05:00:00
(1 row)

*******************************************************************************************************************

bd1=# select (2<3);
 ?column? 
----------
 t
(1 row)

bd1=# select ((2<3) = true);
 ?column? 
----------
 t
(1 row)

bd1=# select ((2<3) = false);
 ?column? 
----------
 f
(1 row)

bd1=# select ((2<3) = 'true')::boolean; 
 bool 
------
 t
(1 row)

bd1=# select ((2<3) = 'true');
 ?column? 
----------
 t
(1 row)
*****************************************************************************************************************


select * from canal;  -- seleciona todos os arquivos da tabela canal 




aula 03/04

select codigo, canal, ltrim(to_char(horario, 'DD/MM/YYYY')) as data,horario::time as hora, case date_part('dow', horario) when 0 then 'domingo' when 1 then 'segunda' when 2 then 'terca' when 3 then 'quarta' when 4 then 'quinta' when 5 then 'sexta' when 6 then 'sabado' end as dia_da_semana, nome from programa;


select codigo, canal, ltrim(to_char(horario, 'DD/MM/YYYY')) as data,horario::time as hora,('{Domingo,segunda,terca,quarta,quinta,sexta,sabado}'::text[])[date_part('dow', horario)+1] as dia_da_semana, nome from programa;  -- precisa adicionar +1 porque no postgres o vetor começa a partir de 1, diferente do java que eh a partir de 0




aula 09/04



select * from produto where descricao like 'HD'; -- o like e lento pra caralho evitar, tentar categorizar, acaba com a performance
'%HD' acabe com HD
'HD%' Comece com HD
'%HD%' que tenha a palavra HD

select * from produto where descricao like '%HD% 500%GB%';  --lista todos HD de 500 gb
select * from produto where descricao like '%hd % 500%gb%'; -- ele é case sensitive, nao vai mostrar nada nesse caso

lower() -- coloca tudo em minuscula
upper() -- coloca tudo em maiuscula

select lower('xuxa');  -- aqui nao faz nada
select lower('XUXA');  -- aqui coloca para caixa baixa 'xuxa'

select upper('XuXa');  -- aqui coloca pra cima 'XUXA'

select md5('senha');  -- assim faz uma rash da senha (tipo ma criptografica)

select * from produto where lower(descricao) like '%hd% %500%hd'; -- compara tudo em minusucula

select * from produto where lower(descricao) like lower('%HD% 500%gb%');  -- compara tudo em minuscula na tabela e na consulta

select * from produto where descricao like upper('%HD% 500%gb%'); -- sabendo que o banco esta em caixa alta, passa so a consulta para upper

select * from produto where descricao ilike '%HD% 500%GB%'; -- e igual a colocar lower dos dois lados, o pior de todos em performance,**nao usar


        -- Assim resolve mas e uma bosta em questao de performance, maneira correta...
select * from produto where descricao like '%'||upper('forma')||'%' and descricao like '%'||upper('bolo')||'%' and descricao like '%'||upper('redonda')||'%'; 

select * from produto where descricao like '%'||upper(replace(trim('    forma     bolo     redonda   '), ' ','%'))||'%';  ****nao usar


Funcoes de agregação
count
min
max
avg
sum

        -- conta quantos itens que são hd de 500 gb
select count(*) as quantidade from produto where lower(descricao) like '%hd% %500%hd';

select count(*) from produto;  -- conta a quantidade de linhas na tabela produto...

select count(distinct nome) from programa where canal = 'PLA'; mostra a quantidade de programas sem repetir sem repetir os nomes.

select * from produto where lower(descricao) like '%hd% 500%gb%' order by preco asc limit 1; -- mostra o menor preço, porem apenas 1 se tiver mais nao mostra

select min(preco) as menor from produto where lower(descricao) like '%hd% 500%gb%';  -- melhor maneira de mostrar o menor preço

select max(preco) as maior from produto where lower(descricao) like '%hd% 500%gb%';  -- melhor maneira de mostrar o maior preço

select avg(preco) as media from produto where lower(descricao) like '%hd% 500%gb%';  -- melhor maneira de mostrar a media


*** um select pode ir dentro de outro select... e por ai vai .... 

         
select   -- seleciona
     *   --  em todas as linhas
from     -- da tabela  
    produto  -- produto
where        -- onde
    (lower(descricao) like '%hd% 500%gb%') and  
    (preco = (select
                min(preco) as menor
             from
                produto
             where 
                lower(descricao) like '%hd% 500%gb%'));
                
                
**** ponto extra

Quais as hd mais barata menor que menor do que 1 tb?

select
     *
from 
    produto 
where 
    (produto 
    (lower(descricao) like '%hd% 1000%gb%')) and
    (preco = (select
                min(preco) as menor
             from
                produto
             where 
                lower(descricao) like '%hd% 1000%gb%'));


select * from programa where (horario <= now()) and (canal = 'PLA') order by horario desc limit 1;

select * from (select *
from 
    produto 
where 
    (lower(descricao) like '%hd% %gb%') and
    (preco = (select
                min(preco) as menor
             from
                produto
             where 
                lower(descricao) like '%hd% %gb%'))) as barato order by descricao asc;

insert into produto (codigo,descricao,preco) values (100000,'HD IDE 1000 GB MAXTOR 5400 2MB RECERTIFIED REF.',6.00);




























































