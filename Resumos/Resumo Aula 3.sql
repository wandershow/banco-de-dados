\c bd1

create table funcionario (codigo int not null, nome varchar(100) not null, primary key(codigo)); -- criar tabela

insert into funcionario (codigo, nome) values (1, 'xuxa'), (2, 'pele'), (3, 'didi'), (4, 'dede'); --inseriu valor

create table dependente (codigo int not null, nome varchar(100) not null,
	funcionario int not null references funcionario(codigo), primary key(codigo)); -- criou tabela funcionario
	
insert into dependente (codigo, nome, funcionario) values (1, 'sasha', 1), (2, 'paulo', 3); --inseriu valor

select * from funcionario, dependente;-- sempre que um select utilizar mais de uma tabela, vai ser feito um produto cartesiano.

select * from funcionario, dependente where dependente.funcionario = funcionario.codigo; --mostra os dependentes com seus funcionarios

\c bancoing

select * from emprestimo, cliente;

select * from emprestimo, cliente where emprestimo.nome_cliente = cliente.nome_cliente; --cliente com emprestimo e suas ruas

select cliente.cidade_cliente, count(*) as quantidade from emprestimo, cliente 
where emprestimo.nome_cliente = cliente.nome_cliente group by cliente.cidade_cliente having count(*) = 2;

select cliente.nome_cliente, cliente.cidade_cliente from emprestimo,
cliente where emprestimo.nome_cliente = cliente.nome_cliente; --cidade do cliente

select distinct nome_cliente from deposito where (nome_agencia = 'Perryridge'); --cliente que tem conta deposito

select distinct nome_cliente from emprestimo where (nome_agencia = 'Perryridge');-- cliente que tem conta emprestimo

(select distinct nome_cliente from deposito where (nome_agencia = 'Perryridge')) 
union (select distinct nome_cliente from emprestimo where (nome_agencia = 'Perryridge'));

--cliente que tem pelo menos uma conta (usando union), tem que ter mesmo numero de coluna.

(select distinct nome_cliente from deposito where (nome_agencia = 'Perryridge')) 
union all (select distinct nome_cliente from emprestimo where (nome_agencia = 'Perryridge')); --"union all" junta mesmo que repita o nome.

(select distinct nome_cliente from deposito where (nome_agencia = 'Perryridge'))
intersect (select distinct nome_cliente from emprestimo where (nome_agencia = 'Perryridge'));-- que tem conta em ambas

(select distinct nome_cliente from deposito where (nome_agencia = 'Perryridge')) except
(select distinct nome_cliente from emprestimo where (nome_agencia = 'Perryridge')); --que tem conta deposito e não tem conta emprestimo.


--FORMAS DIFERENTES DAS 3 OPERAÇÕES UNION INTERSECT EXECPT

select * from deposito, emprestimo where (deposito.nome_agencia = 'Perryridge') 
and (emprestimo.nome_agencia = 'Perryridge'); 
--que tem conta emprestimo e deposito em uma agencia (INTERSECT) porem tem produto cartesiano

select * from deposito, emprestimo where (deposito.nome_agencia = 'Perryridge')
and (emprestimo.nome_agencia = 'Perryridge') and (deposito.nome_cliente = emprestimo.nome_cliente);-- agora sem produto cartesiano.

select deposito.nome_cliente from deposito, emprestimo where (deposito.nome_agencia = 'Perryridge')
and (emprestimo.nome_agencia = 'Perryridge') and (deposito.nome_cliente = emprestimo.nome_cliente);-- só o nome agora.

--IN no SELECT

select * from emprestimo where emprestimo.quantia = 500 or emprestimo.quantia = 1000 or emprestimo.quantia = 1500;

select * from emprestimo where emprestimo.quantia in ( 500, 1000 , 1500); --quem tem quantia dentro desses valores


select distinct nome_cliente from deposito where (nome_agencia = 'Perryridge') and 
	(nome_cliente in 
		(select distinct nome_cliente from emprestimo where (nome_agencia = 'Perryridge')));
-- outro exemplo de INTERSECT usando IN


select distinct nome_cliente from deposito where (nome_agencia = 'Perryridge') and 
(nome_cliente not in 
(select distinct nome_cliente from emprestimo where (nome_agencia = 'Perryridge')));
--Todo mundo que tem depósito nessa agencias mas não tem depósito naquela agencia EXECEPT usando NOT IN

--EXISTS e NOT EXISTS

select nome_cliente from cliente where exists (select * from deposito where 
(deposito.nome_cliente = cliente.nome_cliente) and (nome_agencia = 'Perryridge'));--cliente que tem deposito em Perryridge

select nome_cliente from cliente where exists (select * from emprestimo where 
(emprestimo.nome_cliente = cliente.nome_cliente) and (nome_agencia = 'Perryridge'));--cliente que tem emprestimo em Perryridge



select nome_cliente from cliente where exists 
(select * from deposito where (deposito.nome_cliente = cliente.nome_cliente) and (nome_agencia = 'Perryridge')) 
and exists (select * from emprestimo where (emprestimo.nome_cliente = cliente.nome_cliente) 
and (nome_agencia = 'Perryridge'));--INTERSECT usando EXISTS

select nome_cliente from cliente where exists (select * from deposito where 
(deposito.nome_cliente = cliente.nome_cliente) and (nome_agencia = 'Perryridge')) 
and not exists (select * from emprestimo where (emprestimo.nome_cliente = cliente.nome_cliente)
and (nome_agencia = 'Perryridge'));--EXECEPT com NOT EXISTS ta em um mas não no outro.

select nome_cliente from cliente where exists 
(select * from deposito where (deposito.nome_cliente = cliente.nome_cliente) and (nome_agencia = 'Perryridge')) 
or exists (select * from emprestimo where
(emprestimo.nome_cliente = cliente.nome_cliente) and (nome_agencia = 'Perryridge'));-- UNION usando OR EXISTS

select ativos from agencia where (cidade_agencia = 'Brooklyn');

some = algum
all = todos

< some
= some (in)
<> some
> some

< all ( < (select min())
= all
<> all ( not in)
> all ( > (select max())


select nome_agencia from agencia where (ativos > some (select ativos from agencia where (cidade_agencia = 'Brooklyn')));
-- agencia que tenha ativos seja maior que algum ativo da agencia brooklyn

select nome_agencia from agencia where (ativos > all (select ativos from agencia where (cidade_agencia = 'Brooklyn')));
-- agencia que ativos seja maior que todos os ativos da agencia brooklyn

select nome_agencia from agencia where (ativos > (select max(ativos) from agencia where (cidade_agencia = 'Brooklyn')));
-- mesma coisa

select nome_agencia, avg(saldo) as saldo_medio from deposito group by nome_agencia having (avg(saldo) >= all 
(select avg(saldo) from deposito group by nome_agencia)) order by nome_agencia asc;
--as agencias com maior media de saldo medio

insert into agencia (nome_agencia, ativos, cidade_agencia) values ('Newone', null, 'Rye');

select * from agencia;

select * from agencia where (ativos is not null);

select * from agencia where (ativos is null);


-- NAO É POSSIVEL FAZER IGUALDADE COM NULO ( ALGO = NULL)
