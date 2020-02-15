\c bd1

\i navenet.sql

    -- mostra todas as linhas da tabela produto
select * from produto;

'%HD' acabe com HD
'HD%' Comece com HD
'%HD%' que tenha a palavra HD
                        --**** o like e lento pra caralho evitar, tentar categorizar, acaba com a performance
    -- mostra todas as linhas da tabela produto onde decrição comece com HD
select * from produto where descricao like '%HD';

    -- mostra todas as linhas da tabela produto onde decrição termine com HD
select * from produto where descricao like 'HD%';

    
select * from produto where descricao like 'HD %';

    -- lista todos hd de 500 gb
select * from produto where descricao like '%HD % 500%GB%'; 
    
    --lista todos hd de 500 gb da marca maxtor
select * from produto where descricao like '%HD % 500%GB%MAXTOR%';

    -- lista todos hd da marca maxtor compara em caixa baixa
select * from produto where lower(descricao) like '%hd %maxtor%';

    -- lista todos hd da marca maxtor compara em caixa alta
select * from produto where descricao like upper('%hd %maxtor%');

    -- ** pior maneira... coloca upper na tabela e na comparaçao, demora pra caralho
select * from produto where upper(descricao) like upper('%hd %maxtor%');

    -- ** pior maneira... faz o mesmo que o de cima escrevendo menos apenas
    -- e igual a colocar lower dos dois lados, o pior de todos em performance,**nao usar
select * from produto where descricao ilike '%hd %maxtor%';

xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
lower() -- coloca tudo em minuscula
upper() -- coloca tudo em maiuscula

select lower('xuxa');  -- aqui nao faz nada
select lower('XUXA');  -- aqui coloca para caixa baixa 'xuxa'

select upper('XuXa');  -- aqui coloca pra cima 'XUXA'

select md5('senha');  -- assim faz uma rash da senha (tipo uma criptografica)

    -- pior maneira ****nao usar
select * from produto where descricao like '%'||upper(replace('hd maxtor',' ','%'))||'%'; 

Funcoes de agregação
count
min
max
avg
sum

select count(*) from canal; -- conta quantas linhas tem na tabela canal
select count(*) from programa; -- quantas linhas na tabela programa
select count(*) from programa where canal = 'PLA'; --conta quantas linhas tem na tabela programa do canal 'PLA'
select count(distinct nome) from programa where canal = 'PLA'; --conta quantas linhas tem na tabela programa do canal 'PLA' sem repetir 
select count(*) as quantidade from produto where descricao like '%HD %MAXTOR%'; --conta e mostra em uma tabela quantidade todos produtos HD MAXTOR
select min(preco) as menor_preco from produto where descricao like '%HD %MAXTOR%'; -- mostra o menor valor das HD MAXTOR
select max(preco) as maior_preco from produto where descricao like '%HD %MAXTOR%'; -- mostra o maior valor das HD MAXTOR
select avg(preco) as preco_medio from produto where descricao like '%HD %MAXTOR%'; -- mostra a media valor das HD MAXTOR

    -- mostra o menor preço da HD MAXTOR
select * from produto where (descricao like '%HD %MAXTOR%') and (preco = (select min(preco) from produto where descricao like '%HD %MAXTOR%')); 

    -- mostra a media de preço da HD MAXTOR
select * from produto where (descricao like '%HD %MAXTOR%') and (preco < (select avg(preco) from produto where descricao like '%HD %MAXTOR%'));

    -- mostra todas HD MAXTOR que o preço for menor do que 30
select * from (select * from produto where descricao like '%HD %MAXTOR%') as tmp1 where preco < 30; ** sempre que o select for no from tem que renomear ex* as tmp1
  
  -- mostra o menor preço, a media e o maior preço
select (select min(preco) from produto where descricao like '%HD %MAXTOR%') as minimo, (select avg(preco) from produto where descricao like '%HD %MAXTOR%') as media, (select max(preco) from produto where descricao like '%HD %MAXTOR%') as maximo;

\i bancoingles.sql 
    -- mostra o nome das agencias que tem algum deposito
select nome_agencia from deposito ;

    -- mostra o nome das agencias sem repetir
select distinct nome_agencia from deposito ;

    -- mostra o nome das agencias sem repetir, *** melhor maneira
select nome_agencia from deposito group by nome_agencia;

    -- mostra o nome das agencias sem repetir e conta quantos depositos tem cada
select nome_agencia,count(*) as quantidade from deposito group by nome_agencia;

    -- mostra o nome das agencias sem repetir e a media de saldo em cada
select nome_agencia,avg(saldo) as media from deposito group by nome_agencia;

    --mostra o nome das agencias sem repetir e quantos clientes fizeram deposito
select nome_agencia,count(nome_cliente) from deposito group by nome_agencia;


insert into deposito values ('Downtown',999,'Johnson',550);
--mostra o nome das agencias sem repetir e quantos depositos foram feitos em cada agencia
select nome_agencia,count(nome_cliente) from deposito group by nome_agencia;

    -- mostra o nome das agencias e a quantidade de depositos feitos por pessoas diferentes
select nome_agencia,count(distinct nome_cliente) from deposito group by nome_agencia;

    -- mostra o nome das agencias onde tiveram 2 ou mais depositos
select * from (select nome_agencia,count(*) as quantidade from deposito group by nome_agencia) as tmp1 where quantidade >= 2; ** o select no from tem que ser sempre renomeado **ex: as tmp1

    -- faz o mesmo que o de cima so que usando having ao inves de sub select
select nome_agencia,count(*) as quantidade from deposito group by nome_agencia having count(*) >= 2; ** having e o where do group by

    -- mostra o somatorio do saldo de cada agencia
select nome_agencia,sum(saldo) as total from deposito group by nome_agencia;

    --mostra o somatorio do saldo de cada agencia que tenha 1000 ou mais de saldo
select nome_agencia,sum(saldo) as total from deposito group by nome_agencia having sum(saldo) >= 1000;




























