-- 1) Mostrar a quantidade de vendas por faixa etária dos clientes em fevereiro de 2000. Considerar as faixas etárias 18-25, 26-35, 36-45, 46-55, 56-65, 66-75 e 76- e que não são realizadas vendas para menores de 18 anos.


SELECT * FROM venda;

SELECT * FROM venda JOIN cliente ON venda.cliente = cliente.cpf;

SELECT *, now()-cliente.nascimento AS idade FROM venda JOIN cliente ON venda.cliente = cliente.cpf;

SELECT venda.codigo, cliente.codigo, cliente.cpf, cliente.nascimento, now()-cliente.nascimento AS idade FROM venda JOIN cliente ON venda.cliente = cliente.cpf;

SELECT venda.codigo, cliente.codigo, cliente.cpf, cliente.nascimento,DATE_PART('day', now()-cliente.nascimento) AS idade FROM venda JOIN cliente ON venda.cliente = cliente.cpf;

SELECT venda.codigo, FLOOR(DATE_PART('day', now()-cliente.nascimento)/365) AS idade FROM venda JOIN cliente ON venda.cliente = cliente.cpf WHERE venda.dia BETWEEN '2000-02-01' AND '2000-02-29';

SELECT venda.codigo, FLOOR(DATE_PART('day', now()-cliente.nascimento)/365) AS idade FROM venda JOIN cliente ON venda.cliente = cliente.cpf WHERE venda.dia BETWEEN '2000-02-01' AND '2000-02-29';

SELECT * FROM (SELECT venda.codigo, FLOOR(DATE_PART('day', now()-cliente.nascimento)/365) AS idade FROM venda JOIN cliente ON venda.cliente = cliente.cpf WHERE venda.dia BETWEEN '2000-02-01' AND '2000-02-29') AS tmp1 WHERE tmp1idade BETWEEN 18 AND 25;

SELECT '18-25' as faixa, COUNT(*) AS quantidade FROM (SELECT venda.codigo, FLOOR(DATE_PART('day', now()-cliente.nascimento)/365) AS idade FROM venda JOIN cliente ON venda.cliente = cliente.cpf WHERE venda.dia BETWEEN '2000-02-01' AND '2000-02-29') AS tmp1 WHERE tmp1idade BETWEEN 18 AND 25;

SELECT '26-35' as faixa, COUNT(*) AS quantidade FROM (SELECT venda.codigo, FLOOR(DATE_PART('day', now()-cliente.nascimento)/365) AS idade FROM venda JOIN cliente ON venda.cliente = cliente.cpf WHERE venda.dia BETWEEN '2000-02-01' AND '2000-02-29') AS tmp1 WHERE tmp1idade BETWEEN 26 AND 35;

(SELECT '18-25' as faixa, COUNT(*) AS quantidade FROM (SELECT venda.codigo, FLOOR(DATE_PART('day', now()-cliente.nascimento)/365) AS idade FROM venda JOIN cliente ON venda.cliente = cliente.cpf WHERE venda.dia BETWEEN '2000-02-01' AND '2000-02-29') AS tmp1 WHERE tmp1idade BETWEEN 18 AND 25)
UNION
(SELECT '26-35' as faixa, COUNT(*) AS quantidade FROM (SELECT venda.codigo, FLOOR(DATE_PART('day', now()-cliente.nascimento)/365) AS idade FROM venda JOIN cliente ON venda.cliente = cliente.cpf WHERE venda.dia BETWEEN '2000-02-01' AND '2000-02-29') AS tmp1 WHERE tmp1idade BETWEEN 26 AND 35);





(SELECT '18-25' as faixa, COUNT(*) AS quantidade FROM (SELECT venda.codigo, FLOOR(DATE_PART('day', now()-cliente.nascimento)/365) AS idade FROM venda JOIN cliente ON venda.cliente = cliente.cpf WHERE venda.dia BETWEEN '2000-02-01' AND '2000-02-29') AS tmp1 WHERE tmp1.idade BETWEEN 18 AND 25)
UNION
(SELECT '26-35' as faixa, COUNT(*) AS quantidade FROM (SELECT venda.codigo, FLOOR(DATE_PART('day', now()-cliente.nascimento)/365) AS idade FROM venda JOIN cliente ON venda.cliente = cliente.cpf WHERE venda.dia BETWEEN '2000-02-01' AND '2000-02-29') AS tmp2 WHERE tmp2.idade BETWEEN 26 AND 35);
UNION
(SELECT '46-55' as faixa, COUNT(*) AS quantidade FROM (SELECT venda.codigo, FLOOR(DATE_PART('day', now()-cliente.nascimento)/365) AS idade FROM venda JOIN cliente ON venda.cliente = cliente.cpf WHERE venda.dia BETWEEN '2000-02-01' AND '2000-02-29') AS tmp3 WHERE tmp3.idade BETWEEN 46 AND 55)
UNION
(SELECT '56-75' as faixa, COUNT(*) AS quantidade FROM (SELECT venda.codigo, FLOOR(DATE_PART('day', now()-cliente.nascimento)/365) AS idade FROM venda JOIN cliente ON venda.cliente = cliente.cpf WHERE venda.dia BETWEEN '2000-02-01' AND '2000-02-29') AS tmp4 WHERE tmp4.idade BETWEEN 56 AND 75);
UNION
(SELECT '76' as faixa, COUNT(*) AS quantidade FROM (SELECT venda.codigo, FLOOR(DATE_PART('day', now()-cliente.nascimento)/365) AS idade FROM venda JOIN cliente ON venda.cliente = cliente.cpf WHERE venda.dia BETWEEN '2000-02-01' AND '2000-02-29') AS tmp1 WHERE tmp1idade BETWEEN 76);


SELECT CASE FLOOR((FLOOR(DATE_PART('day', now()-cliente.nascimento)/365)-6/10) WHEN 1 THEN '18-25' WHEN 2 THEN '26-35' WHEN 3 THEN '36-45' WHEN 4 THEN '46-55' WHEN 5 THEN '56-65' WHEN 5 THEN '66-75' WHEN 6 THEN '76-' END AS faixa, COUNT(*) AS quantidade FROM venda JOIN cliente ON venda.cliente = cliente.cpf WHERE venda.dia BETWEEN '2000-02-01' AND '2000-02-29' GROUP BY 1 ORDER BY '1' ASC;


-- 2) Mostrar os vendedores que não realizaram vendas de 10 a 15 de fevereiro de 2000.


SELECT * FROM venda;

SELECT * FROM venda WHERE venda.dia BETWEEN '2000-02-10' AND '2000-02-15';

SELECT venda.vendedor FROM venda WHERE venda.dia BETWEEN '2000-02-10' AND '2000-02-15';


(SELECT vendedor.cpf FROM vendedor)
EXCEPT
SELECT venda.vendedor FROM venda WHERE venda.dia BETWEEN '2000-02-10' AND '2000-02-15';


SELECT vendedor.nome FROM vendedor WHERE vendedor.cpf not in (SELECT venda.vendedor FROM venda
WHERE venda.dia BETWEEN '2000-02-10' AND '2000-02-15');


-- 3) Mostrar o ranking dos produtos mais vendidos de janeiro a março de 2000.


SELECT * FROM venda JOIN item ON venda.codigo = item.venda;

SELECT * FROM venda JOIN item ON venda.codigo = item.venda WHERE venda.dia BETWEEN '2000-01-01' AND '2000-03-31';


SELECT item.produto, SUM(item.quantidade) AS quantidade FROM venda JOIN item ON venda.codigo = item.venda WHERE venda.dia BETWEEN '2000-01-01' AND '2000-03-31' GROUP BY item.produto ORDER BY item.produto;


SELECT item.produto, SUM(item.quantidade) AS quantidade FROM venda JOIN item ON venda.codigo = item.venda WHERE venda.dia BETWEEN '2000-01-01' AND '2000-03-31' GROUP BY item.produto ORDER BY quantidade DESC;


-- 4) Mostrar o valor total de vendas por dia em fevereiro de 2000.

SELECT * FROM venda JOIN item ON venda.codigo = item.venda WHERE venda.dia BETWEEN '2000-02-01' AND '2000-02-29';

SELECT * FROM venda JOIN item ON venda.codigo = item.venda JOIN produto ON item.produto = produto.codigo WHERE venda.dia BETWEEN '2000-02-01' AND '2000-02-29';

SELECT * , item.quantidade*produto.preco AS subtotal FROM venda JOIN item ON venda.codigo = item.venda JOIN produto ON item.produto = produto.codigo WHERE venda.dia BETWEEN '2000-02-01' AND '2000-02-29';


SELECT venda.dia , SUM(item.quantidade*produto.preco) AS subtotal FROM venda JOIN item ON venda.codigo = item.venda JOIN produto ON item.produto = produto.codigo WHERE venda.dia BETWEEN '2000-02-01' AND '2000-02-29' GROUP BY venda.dia ORDER BY venda.dia ASC;


-- 5) Mostrar o ranking de clientes por gastos em fevereiro de 2000.


SELECT cliente.nome, SUM(tmp1.subtotal) AS gastos
 FROM (SELECT venda.codigo , SUM(item.quantidade*produto.preco) AS subtotal
  FROM venda JOIN item ON venda.codigo = item.venda
   JOIN produto ON item.produto = produto.codigo
   WHERE venda.dia BETWEEN '2000-02-01' AND '2000-02-29' GROUP BY venda.codigo) AS tmp1
    JOIN venda ON tmp1.codigo = venda.codigo
     JOIN cliente ON venda.cliente = cliente.cpf
      GROUP BY cliente.cpf
       ORDER BY 2 DESC;
