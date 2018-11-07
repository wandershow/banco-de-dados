select *
 from produto
  join item on produto.codigo = item.produto;

select produto.codigo, produto.preco, item.quantidade
 from produto
  join item on produto.codigo = item.produto;

select produto.codigo, FLOOR(SUM(produto.preco*item.quantidade)) as subtotal
 from produto
  join item on produto.codigo = item.produto
  group by produto.codigo
   order by subtotal desc;


     CÓDIGO E SUBTOTAL
SELECT item.produto, floor(SUM(item.quantidade*produto.preco)) AS subtotal
FROM venda
JOIN item ON venda.codigo = item.venda
JOIN produto ON item.produto = produto.codigo
WHERE venda.dia BETWEEN '2000-01-01' AND '2000-04-17'
GROUP BY item.produto
ORDER BY 2 desc;

    SOMENTE SUBTOTAL
SELECT tmp1.subtotal
from(
SELECT item.produto, SUM(item.quantidade*produto.preco) AS subtotal
FROM venda
JOIN item ON venda.codigo = item.venda
JOIN produto ON item.produto = produto.codigo
WHERE venda.dia BETWEEN '2000-01-01' AND '2000-04-17'
GROUP BY item.produto
ORDER BY 2 desc) as tmp1
ORDER BY tmp1.subtotal desc;






SELECT
    title,
    category,
    total_sales,
    rank() OVER (PARTITION BY category ORDER BY total_sales DESC) AS rank,
    sum(total_sales) OVER (PARTITION BY category ORDER BY total_sales DESC) AS sum
FROM sales_pgday;


total acumulado
select sum(tmp1.subtotal) as acumulado from (SELECT item.produto, floor(SUM(item.quantidade*produto.preco)) AS subtotal
FROM venda
JOIN item ON venda.codigo = item.venda
JOIN produto ON item.produto = produto.codigo
WHERE venda.dia BETWEEN '2000-01-01' AND '2000-04-17'
GROUP BY item.produto
ORDER BY 2 desc) as tmp1 where tmp1.subtotal between 31 and 1589;
























    CÓDIGO E 2 COLUNAS DE SUBTOTAL
SELECT tmp1.produto, tmp1.valor, tmp3.subtotal
FROM(
SELECT item.produto, SUM(item.quantidade*produto.preco) AS valor
FROM venda
JOIN item ON venda.codigo = item.venda
JOIN produto ON item.produto = produto.codigo
WHERE venda.dia BETWEEN '2000-01-01' AND '2000-04-17'
GROUP BY item.produto
ORDER BY 2 desc) as tmp1
JOIN (SELECT tmp2.subtotal
from(
SELECT item.produto, SUM(item.quantidade*produto.preco) AS subtotal
FROM venda
JOIN item ON venda.codigo = item.venda
JOIN produto ON item.produto = produto.codigo
WHERE venda.dia BETWEEN '2000-01-01' AND '2000-04-17'
GROUP BY item.produto
ORDER BY 2 desc) as tmp2
ORDER BY tmp2.subtotal desc) AS tmp3 ON tmp3.subtotal = tmp1.valor
GROUP BY tmp1.valor, tmp1.produto , tmp3.subtotal
ORDER BY 2 desc;









    CÓDIGO 2 TABELA DE SUBTOTAL E UMA COM A SOMA DOS DOIS
SELECT tmp1.produto, tmp1.valor, tmp3.subtotal, SUM( tmp1.valor + subtotal) AS test
FROM(
SELECT item.produto, SUM(item.quantidade*produto.preco) AS valor
FROM venda
JOIN item ON venda.codigo = item.venda
JOIN produto ON item.produto = produto.codigo
WHERE venda.dia BETWEEN '2000-01-01' AND '2000-04-17'
GROUP BY item.produto
ORDER BY 2 desc) as tmp1
JOIN (SELECT tmp2.subtotal
from(
SELECT item.produto, SUM(item.quantidade*produto.preco) AS subtotal
FROM venda
JOIN item ON venda.codigo = item.venda
JOIN produto ON item.produto = produto.codigo
WHERE venda.dia BETWEEN '2000-01-01' AND '2000-04-17'
GROUP BY item.produto
ORDER BY 2 desc) as tmp2
ORDER BY tmp2.subtotal desc) AS tmp3 ON tmp3.subtotal = tmp1.valor
GROUP BY tmp1.valor, tmp1.produto , tmp3.subtotal
ORDER BY 2 desc;




SELECT tmp1.produto, tmp1.valor, tmp3.subtotal, SUM( tmp1.valor + subtotal) AS test
FROM(
SELECT item.produto, SUM(item.quantidade*produto.preco) AS valor
FROM venda
JOIN item ON venda.codigo = item.venda
JOIN produto ON item.produto = produto.codigo
WHERE venda.dia BETWEEN '2000-01-01' AND '2000-04-17'
GROUP BY item.produto
ORDER BY 2 desc) as tmp1
JOIN (SELECT tmp2.subtotal
from(
SELECT item.produto, SUM(item.quantidade*produto.preco) AS subtotal
FROM venda
JOIN item ON venda.codigo = item.venda
JOIN produto ON item.produto = produto.codigo
WHERE venda.dia BETWEEN '2000-01-01' AND '2000-04-17'
GROUP BY item.produto
ORDER BY 2 desc) as tmp2
ORDER BY tmp2.subtotal desc) AS tmp3 ON tmp3.subtotal = tmp1.valor
GROUP BY tmp1.valor, tmp1.produto , tmp3.subtotal
ORDER BY 2 desc;




SELECT tmp1.produto, tmp1.valor, tmp3.subtotal, sum(tmp1.valor + tmp3.subtotal) as soma_de_ambos
FROM(
SELECT item.produto, SUM(item.quantidade*produto.preco) AS valor
FROM venda
JOIN item ON venda.codigo = item.venda
JOIN produto ON item.produto = produto.codigo
WHERE venda.dia BETWEEN '2000-01-01' AND '2000-04-17'
GROUP BY item.produto
ORDER BY 2 desc) as tmp1
JOIN (SELECT tmp2.subtotal
from(
SELECT item.produto, SUM(item.quantidade*produto.preco) AS subtotal
FROM venda
JOIN item ON venda.codigo = item.venda
JOIN produto ON item.produto = produto.codigo
WHERE venda.dia BETWEEN '2000-01-01' AND '2000-04-17'
GROUP BY item.produto
ORDER BY 2 desc) as tmp2
ORDER BY tmp2.subtotal desc) AS tmp3 ON tmp3.subtotal = tmp1.valor
GROUP BY tmp1.valor, tmp1.produto , tmp3.subtotal
ORDER BY 2 desc;
