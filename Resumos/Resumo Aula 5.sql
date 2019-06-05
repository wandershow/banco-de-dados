--select with
--views
--explain/analyse
--update
--  update com join
--delete
--controle de concorrência
--  pessimista
--  otimista
--transações

--diferença de select pra select with (nenhuma)

--serve pra:

with tmp1 as (select sum(biblioteca), [...]) 
(select falta
 from tmp1
where tmp1.presensa > 0)
union
(select falta
 from tmp1
where tmp1.presensa < 0); (vc diz q a variavel tmp1 tem esse select/subselect, e q apartir disso um select quando falar tmp1 vai usar ele).
                                       
explain select * from locacao; (eu fiz um procura sequencia da tabela locacao, com essa quantidade de linhas com esse custo)
(o custo é de usar essa execução).
ex: cost: 3.25..111.05 [...]  só comparar os valores depois dos ".." (111.05)    
                                       
explain analyse select ...  é mais detalhado com tempo e tal.                                      
                                       
create view tmp1 as (select); view serve pra mais ou menos pra mesma coisa que o IF, sacar fora uma subselect ( é uma select com nome)                                       
                                       
update usuario set nome = 'xuxa zafir' where codigo = 82;   atualiza o nome do usuario para xuxa zafir onde codigo é 82.
update funcionario set salario = salario*1.15 where codigo = 37; dar aumento de 15% no salario do funcionario com codigo 37.                                       
update funcionario set salario = salario*1.15 where dept = 2; aumento de 15% pra todo funcionario do depto 2.

o join no update é SEMPRE teta join  (from tabela1,tabela2,tabela3,...)  

update funcionario set salario = salario*case ... when vendas.total ... end 
 from (select funcionario.codigo, sum(...) as total from ...) as vendas where funcionario .codigo = vendas.codigo;                                      

returning                                        
  
update usuario set nome = 'xuxa zafir' where codigo = 82 returning *; vai altera e devolve os dados pra conferir
                                       
create table tmp2 ( codigo seria, nome varchar(100) );
insert into tmp2 (nome) values ('xuxa'),('sasha'),('zafir'),('didi'),('dede'),('mussum'),('zacarias');
insert into tmp2 (nome) values ('pele') returning codigo; inclui o pele e devolve o codigo dele.
  
delete (atualmente dificil de usar)
                                       
delete from tmp2 where codigo = 3 returning *;
delete from tmp2 where nome like '%a%';
                                       
delete from loccao where usuario = 11;
delete from usuario where codigo = 11; (por causa da FK, tem q deletar registros dele depois o usuario) 

já que não pode deletar, usar então assim (marca como inativo)                                       
                                       
update locacao set ativo = false where usuario = 11;      
update usuario set ativo = false where codigo = 11;
                                       
controle de concorrência (duas ou mais pessoas tentando comprar uma passagem ao mesmo tempo)                                      
                                      
pessimista (usar com cautela)                                      
select * from tabela where ... for update; 
for update (essas linhas q eu acabei de selecionar vão ser alteradas logo em seguida e tranca elas (n vão sofrer mudança até terminar))                                       
ele selecionou essas linhas, elas vão ser trancadas até terminar o update
     
 otimista                                      
   versionamento                               
   timestamp                                    
   
insert into viagem (linha, saida, chegada, lugar, ocupado) 
   values ('rg-pel','19:00', '20:00', 19, null);
                                                                                                    
select * from viagem where linha = 'rg-pel' and saida = '19:00';
                                                                                                    
update viagem set ocupado = '1234578901' where linha = 'rg-pel' and saida = '19:00' and lugar = 19;                          
                                       
xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx                                       

insert into viagem (linha, saida, chegada, lugar, ocupado, alterado) 
   values ('rg-pel','19:00', '20:00', 19, null, now()); --- '2019-0-04 21:12:00'
                                                                                                    
select * from viagem where linha = 'rg-pel' and saida = '19:00'; --alterado
                                                                                                    
update viagem set ocupado = '1234578901', alterado = now() where linha = 'rg-pel' and saida = '19:00' 
           and lugar = 19 and alterado = '2019-06-04 21:12:00';                                                                                                       
                                                                                                    
transação (ACID: Atomicidade, Consistência, Isolamento e Durabilidade)/(ou faz tudo, ou faz nada)/                                 
begin; (começa transação)  
commit;(confirma todas mudanças e SALVA)           
rollback;(desfaz tudo e deixa como tava antes do begin)
           
begin;
select * from locacao where usuario = 37 for update;                              
update locacao set usuario = 12 where usuario = 37 returning *;                                                
commit/rollback;                                                     
