-- Questão 2
-- todos os vendedores
select cpf from vendedor;

-- só os que venderam
select distinct vendedor as venderam from venda where ( dia between '2000-02-10' and '2000-02-15');
-- ( eu não to conseguindo negar  ou usar morgan pra pegar só os que estão fora dessa
-- lista  no caso quem começa com cpf 23 e 96) e também n consigo fazer
-- diferença entra eles (todos cpf e só os que venderam nos dias)


 -- select cpf.vendeor from vendedor where exists(
 -- (select cpf as vendedores from vendedor) where not exists
 -- (select distinct vendedor as venderam from venda where (dia between '2000-02-10' and '2000-02-15')));

-- select cpf as nao_vendeu from vendedor where not exists(
--   select distinct vendedor as venderam from venda where
--   ( dia between '2000-02-10' and '2000-02-15'));



---------------------------------------------------------------------------------
-- Quest 3

select * from item where()
-- teve 202 vendas
select codigo from venda where ( dia between '2000-01-01' and '2000-03-31');

---------------------------------------------------------------------------------
-- Quest 4

-- todas venda ocorridas no mês de fevereiro
select codigo from venda where ( dia between '2000-02-01' and '2000-02-29');
---------------------------------------------------------------------------------
-- Quest 5

-- Clientes que compraram durante esse tempo
select distinct cliente from venda where (dia between '2000-01-01' and '2000-01-31');

-- Quantos clientes compraram durante esse periodo
select count(cliente) from venda where (dia between '2000-01-01' and '2000-01-31');
