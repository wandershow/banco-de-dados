\c bd1

create table funcionario (codigo int not null, nome varchar(100) not null, primary key(codigo));
insert into funcionario (codigo, nome) values (1, 'xuxa'), (2, 'pele'), (3, 'didi'), (4, 'dede');
create table dependente (codigo int not null, nome varchar(100) not null, funcionario int not null references funcionario(codigo), primary key(codigo));
insert into dependente (codigo, nome, funcionario) values (1, 'sasha', 1), (2, 'paulo', 3);

-- sempre que formos trabalhar com mais de 1 tabela sera feito um produto cartesiano.
 **produto cartesiano pega todos da direita e todos da esquerda 
select * from funcionario, dependente;

-- produto cartesiano com filtro 'where ... 
select * from funcionario, dependente where dependente.funcionario = funcionario.codigo;
select * from dependente, funcionario where dependente.funcionario = funcionario.codigo;
 

select * from emprestimo, cliente;
select * from emprestimo, cliente where emprestimo.nome_cliente = cliente.nome_cliente;
select cliente.nome_cliente, cliente.cidade_cliente from emprestimo, cliente where emprestimo.nome_cliente = cliente.nome_cliente;

select cliente.cidade_cliente, count(*) as quantidade from emprestimo, cliente where emprestimo.nome_cliente = cliente.nome_cliente group by cliente.cidade_cliente having count(*) = 2;

select distinct nome_cliente from deposito where (nome_agencia = 'Perryridge');
select distinct nome_cliente from emprestimo where (nome_agencia = 'Perryridge');

-- A estrutura do que esta do lado esquerdo tem que ser igual a estrutura que esta do lado direito para poder usar 'union' ou 'union all'
(select distinct nome_cliente from deposito where (nome_agencia = 'Perryridge')) union (select distinct nome_cliente from emprestimo where (nome_agencia = 'Perryridge'));
(select distinct nome_cliente from deposito where (nome_agencia = 'Perryridge')) union all (select distinct nome_cliente from emprestimo where (nome_agencia = 'Perryridge'));


(select distinct nome_cliente from deposito where (nome_agencia = 'Perryridge')) intersect (select distinct nome_cliente from emprestimo where (nome_agencia = 'Perryridge'));

(select distinct nome_cliente from deposito where (nome_agencia = 'Perryridge')) except (select distinct nome_cliente from emprestimo where (nome_agencia = 'Perryridge'));

-- faz o mesmo que o de cima sem usar except
select * from deposito, emprestimo where (deposito.nome_agencia = 'Perryridge') and (emprestimo.nome_agencia = 'Perryridge');
select * from deposito, emprestimo where (deposito.nome_agencia = 'Perryridge') and (emprestimo.nome_agencia = 'Perryridge') and (deposito.nome_cliente = emprestimo.nome_cliente);
select deposito.nome_cliente from deposito, emprestimo where (deposito.nome_agencia = 'Perryridge') and (emprestimo.nome_agencia = 'Perryridge') and (deposito.nome_cliente = emprestimo.nome_cliente);

-- todo mundo onde a quantia seja (500, 1000, 1500)
select * from emprestimo where emprestimo.quantia in (500, 1000, 1500);

-- Faz uma intersecção sem usar cross join nem intersect...
select distinct nome_cliente from deposito where (nome_agencia = 'Perryridge') and (nome_cliente in (select distinct nome_cliente from emprestimo where (nome_agencia = 'Perryridge')));

-- Aqui faz a diferença, uma outra forma de fazer o except.
select distinct nome_cliente from deposito where (nome_agencia = 'Perryridge') and (nome_cliente not in (select distinct nome_cliente from emprestimo where (nome_agencia = 'Perryridge')));

--'exists' faz a mesma coisa que o 'in' mas sem precisar ter a mesma estrutura dos dois lados... 
select nome_cliente from cliente where exists (select * from deposito where (deposito.nome_cliente = cliente.nome_cliente) and (nome_agencia = 'Perryridge'));

select nome_cliente from deposito where ( nome_agencia = 

select nome_cliente from cliente where exists (select * from emprestimo where (emprestimo.nome_cliente = cliente.nome_cliente) and (nome_agencia = 'Perryridge'));

-- igual a intersecção
select nome_cliente from cliente where exists (select * from deposito where (deposito.nome_cliente = cliente.nome_cliente) and (nome_agencia = 'Perryridge')) and exists (select * from emprestimo where (emprestimo.nome_cliente = cliente.nome_cliente) and (nome_agencia = 'Perryridge'));

-- igual ao union
select nome_cliente from cliente where exists (select * from deposito where (deposito.nome_cliente = cliente.nome_cliente) and (nome_agencia = 'Perryridge')) or exists (select * from emprestimo where (emprestimo.nome_cliente = cliente.nome_cliente) and (nome_agencia = 'Perryridge'));

--igual a diferença
select nome_cliente from cliente where exists (select * from deposito where (deposito.nome_cliente = cliente.nome_cliente) and (nome_agencia = 'Perryridge')) and not exists (select * from emprestimo where (emprestimo.nome_cliente = cliente.nome_cliente) and (nome_agencia = 'Perryridge'));


select ativos from agencia where (cidade_agencia = 'Brooklyn');
select nome_agencia from agencia where (ativos > some (select ativos from agencia where (cidade_agencia = 'Brooklyn')));
select nome_agencia from agencia where (ativos > all (select ativos from agencia where (cidade_agencia = 'Brooklyn')));
select nome_agencia from agencia where (ativos > (select max(ativos) from agencia where (cidade_agencia = 'Brooklyn')));

-- mostra as agencias que tem a media de saldo maior que a media de saldo de todas as agencias
select nome_agencia, avg(saldo) as saldo_medio from deposito group by nome_agencia having (avg(saldo) >= all (select avg(saldo) from deposito group by nome_agencia)) order by nome_agencia asc;

< some
= some  (in)
<> some  (not in)
> some 

< all (< (select min())
= all  (in)
<> all  (not in)
> all  (> (select max())

insert into agencia (nome_agencia, ativos, cidade_agencia) values ('Newone', null, 'Rye');
select * from agencia;
select * from agencia where (ativos is not null);
select * from agencia where (ativos is null);

--** o 'null' é um valor especial, nao posso fazer igualdade com 'null --> isso nao pode --> ativos = null

