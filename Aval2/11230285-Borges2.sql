-- 1) Mostrar o valor total concedido em descontos por mês em 2000.

--84 55 166 54
--select SUM(desconto) as jan from venda where (dia between '2000-01-02' and '2000-01-31'); -- no banco começa em 02
--select SUM(desconto) as Fev from venda where (dia between '2000-02-01' and '2000-02-29');
--select SUM(desconto) as mar from venda where (dia between '2000-03-01' and '2000-03-30');
--select SUM(desconto) as abr from venda where (dia between '2000-04-01' and '2000-04-17'); -- no banco termina em 17

--84 166 54 55
(select SUM(desconto) as desconto_mes from venda where (dia between '2000-01-02' and '2000-01-31'))
UNION 
(select SUM(desconto) as fev from venda where (dia between '2000-02-01' and '2000-02-29'))
UNION
(select SUM(desconto) as mar from venda where (dia between '2000-03-01' and '2000-03-30'))
UNION
(select SUM(desconto) as abr from venda where (dia between '2000-04-01' and '2000-04-17'))

-- eu não consegui por em ordem.
---------------------------------------------------------------------------------------------------------------------------

-- 2) Mostrar o ranking dos produtos mais vendidos por faixa etária em fevereiro de 2000.


--select * from venda where dia between '2000-02-01' and '2000-02-29';

-- quantidade de vezes que tal item foi vendido
--SELECT item.produto, SUM(item.quantidade) AS quantidade FROM venda JOIN item ON venda.codigo = item.venda WHERE venda.dia BETWEEN '2000-02-01' AND '2000-02-29' GROUP BY item.produto ORDER BY item.produto;


-- ranking dos mais vendidos em fev
--SELECT item.produto, SUM(item.quantidade) AS quantidade FROM venda JOIN item ON venda.codigo = item.venda WHERE venda.dia BETWEEN '2000-02-01' AND '2000-02-29' GROUP BY item.produto ORDER BY quantidade DESC;


-- quantidade de vendas para tal idade
--(SELECT '18-25' as faixa, COUNT(*) AS quantidade FROM (SELECT venda.codigo, FLOOR(DATE_PART('day', now()-cliente.nascimento)/365) AS idade FROM venda JOIN cliente ON venda.cliente = cliente.cpf WHERE venda.dia BETWEEN '2000-02-01' AND '2000-02-29') AS tmp1 WHERE tmp1.idade BETWEEN 18 AND 25);



---------------------------------------------------------------------------------------------------------------------------
--QUESTAO 3

-- venda 1 em 2000-01-01
-- item |  preco | quantidade |  valor | comissao | bonus 
--    1 |   $2.0 |          3 |   $6.0 |       0% |    $0
--    2 |   $5.0 |          2 |  $10.0 |       2% |  $0.2
--    3 |  $10.0 |          2 |  $20.0 |       5% |  $1.0
--    4 |  $45.0 |          2 |  $90.0 |      10% |  $9.0
-- valor em produtos = $126.0
-- desconto de 5% = $6.3
-- valor da nota = $119.7
-- bonus em comissao = $10.2
-- valor liquido = $109.5

-- Todas os produtos e quantidade deles vendidas de certa venda durante o mes de fev
--select venda, produto, quantidade from item join venda on item.venda = venda.codigowhere ( venda.dia between '2000-02-01' and '2000-02-29');

-- Valor total de todas vendas por dia até entre (1-15 de fev)
--SELECT SUM(item.quantidade*produto.preco) AS valor FROM venda JOIN item ON venda.codigo = item.venda JOIN produto ON item.produto = produto.codigo WHERE venda.dia BETWEEN '2000-02-01' AND '2000-02-15' GROUP BY venda.dia ORDER BY venda.dia ASC;

-- Valor total por venda entre (1-15 de fev)
--SELECT SUM(item.quantidade*produto.preco) AS valor FROM venda JOIN item ON venda.codigo = item.venda JOIN produto ON item.produto = produto.codigo WHERE venda.dia BETWEEN '2000-02-01' AND '2000-02-15' GROUP BY venda.codigo ORDER BY venda.codigo ASC;
















