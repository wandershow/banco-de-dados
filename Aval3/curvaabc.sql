--contar quantas vendas cada vendcedor realizou em fevereiro de 2000

select * from venda;   todas as vendas

select * from venda where venda.dia between '2000-02-01' and '2000-02-29'; --todas de fevereiro

select venda.vendedor, count(*) as quantidade from venda where venda.dia between '2000-02-01' and '2000-02-29' group by venda.vendedor;
--dentro da tabela vendas mostrou 


select vendedor.nome, count(*) as quantidade from venda join vendedor on venda.vendedor = vendedor.cpf where venda.dia between '2000-02-01' and '2000-02-29' group by venda.cpf; -- 



select vendedor.nome, (select count(*) from vendas where venda.dia between '2000-02-01' and '2000-02-29') as quantidade  from vendedor;


select sum(tmp1.valor) from (produto e valor) as tmp1where tmp1.valor between 321.50 and 370.00;

select sum(tmp1.valor) from (produto e valor) as tmp1where tmp1.valor between 319.75 and 370.00;
para cada linha disso (produto de valor) faz um sub selectt q soma que vai de onde eu to até o maximo




select vendedor.nome, (select count(*) from venda where venda.vendedor = vendedor.cpf and venda.dia between '2000-02-01' and '2000-02-29') as quantidade  from vendedor;


pra kd vendedor ele acre o subselect ( conta todas as vendas que aconteceu em fev cujo vendedor é o cara do cpf da tabela de fora)















































