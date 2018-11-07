1) Mostrar os vendedores que não cumpriram a meta de $500 em vendas


quanto cada vendedor vendeu na segunda quinzena

SELECT vendedor.cpf, SUM(produto.preco*item.quantidade*(1-venda.desconto/100.0)) as valor
FROM venda
JOIN item ON venda.codigo = item.venda
JOIN produto ON item.produto = produto.codigo
JOIN vendedor ON venda.vendedor = vendedor.cpf
WHERE venda.dia BETWEEN '2000-02-16' and '2000-02-29'
GROUP BY vendedor.cpf
ORDER BY vendedor.cpf asc;

SELECT vendedor.nome, SUM(produto.preco*item.quantidade*(1-venda.desconto/100.0)) as valor
FROM venda
JOIN item ON venda.codigo = item.venda
JOIN produto ON item.produto = produto.codigo
JOIN vendedor ON venda.vendedor = vendedor.cpf
WHERE venda.dia BETWEEN '2000-02-16' and '2000-02-29'
GROUP BY vendedor.cpf
HAVING SUM(produto.preco*item.quantidade*(1-venda.desconto/100.0)) < 500
ORDER BY vendedor.cpf asc;


2) Mostrar os clientes que realizaram mais de 1 compra em todos os 3 primeiros meses de 2000.

quantas venda cada cpf de cliente teve e agrupando por cpf
SELECT venda.cliente, count(*) AS quantidade
FROM venda
WHERE venda.dia BETWEEN '2000-01-01' and '2000-01-31'
GROUP BY venda.cliente;

SELECT venda.cliente, count(*) AS quantidade
FROM venda
WHERE venda.dia BETWEEN '2000-01-01' and '2000-01-31'
GROUP BY venda.cliente
HAVING count(*) > 1;


SELECT venda.cliente, count(*) AS quantidade
FROM venda
WHERE venda.dia BETWEEN '2000-01-01' and '2000-01-31'
GROUP BY venda.cliente
HAVING count(*) > 1;

SELECT venda.cliente, count(*) AS quantidade
FROM venda
WHERE venda.dia BETWEEN '2000-02-01' and '2000-02-29'
GROUP BY venda.cliente
HAVING count(*) > 1;

SELECT venda.cliente, count(*) AS quantidade
FROM venda
WHERE venda.dia BETWEEN '2000-03-01' and '2000-03-31'
GROUP BY venda.cliente
HAVING count(*) > 1;



(SELECT venda.cliente,
FROM venda
WHERE venda.dia BETWEEN '2000-01-01' and '2000-01-31'
GROUP BY venda.cliente
HAVING count(*) > 1)
INTERSECT
(SELECT venda.cliente,
FROM venda
WHERE venda.dia BETWEEN '2000-02-01' and '2000-02-29'
GROUP BY venda.cliente
HAVING count(*) > 1)
INTERSECT
(SELECT venda.cliente,
FROM venda
WHERE venda.dia BETWEEN '2000-03-01' and '2000-03-31'
GROUP BY venda.cliente
HAVING count(*) > 1);



SELECT cliente.nome
 FROM cliente
  WHERE cliente.cpf IN
   (SELECT venda.cliente,
     FROM venda
      WHERE venda.dia BETWEEN '2000-01-01' and '2000-01-31'
        GROUP BY venda.cliente
         HAVING count(*) > 1)
INTERSECT
   (SELECT venda.cliente,
     FROM venda
      WHERE venda.dia BETWEEN '2000-02-01' and '2000-02-29'
       GROUP BY venda.cliente
        HAVING count(*) > 1)
INTERSECT
   (SELECT venda.cliente,
     FROM venda
      WHERE venda.dia BETWEEN '2000-03-01' and '2000-03-31'
       GROUP BY venda.cliente
        HAVING count(*) > 1);


3) Mostrar a(s) venda(s) de maior valor (valor da nota) em fevereiro de 2000.

valor final de cada venda
SELECT vendeda.codigo, SUM(produto.preco*item.quantidade*(1-venda.desconto/100.0)) as valor
FROM venda
JOIN item ON venda.codigo = item.venda
JOIN produto ON item.produto = produto.codigo
WHERE venda.dia BETWEEN '2000-02-01' and '2000-02-29'
GROUP BY venda.codigo;

SELECT vendeda.codigo, SUM(produto.preco*item.quantidade*(1-venda.desconto/100.0)) as valor
FROM venda
JOIN item ON venda.codigo = item.venda
JOIN produto ON item.produto = produto.codigo
WHERE venda.dia BETWEEN '2000-02-01' and '2000-02-29'
GROUP BY venda.codigo
ORDER BY 2 desc;

SELECT vendeda.codigo, SUM(produto.preco*item.quantidade*(1-venda.desconto/100.0)) as valor
FROM venda
JOIN item ON venda.codigo = item.venda
JOIN produto ON item.produto = produto.codigo
WHERE venda.dia BETWEEN '2000-02-01' and '2000-02-29'
GROUP BY venda.codigo
ORDER BY 2 desc
limit 1;

SELECT SUM(produto.preco*item.quantidade*(1-venda.desconto/100.0)) as valor
FROM venda
JOIN item ON venda.codigo = item.venda
JOIN produto ON item.produto = produto.codigo
WHERE venda.dia BETWEEN '2000-02-01' and '2000-02-29'
GROUP BY venda.codigo
ORDER BY 1 desc
limit 1;




SELECT venda.codigo, SUM(produto.preco*item.quantidade*(1-venda.desconto/100.0)) as valor
FROM venda
JOIN item ON venda.codigo = item.venda
JOIN produto ON item.produto = produto.codigo
WHERE venda.dia BETWEEN '2000-02-01' and '2000-02-29'
GROUP BY venda.codigo
HAVING SUM(produto.preco*item.quantidade*(1-venda.desconto/100.0)) = (
     SELECT SUM(produto.preco*item.quantidade*(1-venda.desconto/100.0)) as valor
     FROM venda
     JOIN item ON venda.codigo = item.venda
     JOIN produto ON item.produto = produto.codigo
     WHERE venda.dia BETWEEN '2000-02-01' and '2000-02-29'
     GROUP BY venda.codigo
     ORDER BY 1 desc
     limit 1);




4) Mostrar os vendedores que venderam (valor da nota) mais em fevereiro do que em janeiro de 2000.

Somatorio dos valor que cada vendedor fez em janeiro

SELECT venda.vendedor, SUM(produto.preco*item.quantidade*(1-venda.desconto/100.0)) as valor
FROM venda
     JOIN item ON venda.codigo = item.venda
     JOIN produto ON item.produto = produto.codigo
WHERE venda.dia BETWEEN '2000-01-01' and '2000-01-31'
GROUP BY venda.vendedor;



SELECT *
FROM(
     SELECT venda.vendedor, SUM(produto.preco*item.quantidade*(1-venda.desconto/100.0)) as janeiro
     FROM venda
          JOIN item ON venda.codigo = item.venda
          JOIN produto ON item.produto = produto.codigo
     WHERE venda.dia BETWEEN '2000-01-01' and '2000-01-31'
     GROUP BY venda.vendedor) AS tmp1
     JOIN (
SELECT venda.vendedor, SUM(produto.preco*item.quantidade*(1-venda.desconto/100.0)) as fevereiro
FROM venda
     JOIN item ON venda.codigo = item.venda
     JOIN produto ON item.produto = produto.codigo
WHERE venda.dia BETWEEN '2000-02-01' and '2000-01-29'
GROUP BY venda.vendedor) AS tmp2 ON tmp1.vendedor = tmp2.vendedor;


SELECT *
FROM(
     SELECT venda.vendedor, SUM(produto.preco*item.quantidade*(1-venda.desconto/100.0)) as janeiro
     FROM venda
          JOIN item ON venda.codigo = item.venda
          JOIN produto ON item.produto = produto.codigo
     WHERE venda.dia BETWEEN '2000-01-01' and '2000-01-31'
     GROUP BY venda.vendedor) AS tmp1
     JOIN (
SELECT venda.vendedor, SUM(produto.preco*item.quantidade*(1-venda.desconto/100.0)) as fevereiro
FROM venda
     JOIN item ON venda.codigo = item.venda
     JOIN produto ON item.produto = produto.codigo
WHERE venda.dia BETWEEN '2000-02-01' and '2000-01-29'
GROUP BY venda.vendedor) AS tmp2 ON tmp1.vendedor = tmp2.vendedor
WHERE tmp1.fevereiro > tmp1.janeiro;




SELECT vendedor.nome, tmp1.janeiro, tmp2.fevereiro
FROM(
     SELECT venda.vendedor, SUM(produto.preco*item.quantidade*(1-venda.desconto/100.0)) as janeiro
     FROM venda
          JOIN item ON venda.codigo = item.venda
          JOIN produto ON item.produto = produto.codigo
     WHERE venda.dia BETWEEN '2000-01-01' and '2000-01-31'
     GROUP BY venda.vendedor) AS tmp1
     JOIN (
SELECT venda.vendedor, SUM(produto.preco*item.quantidade*(1-venda.desconto/100.0)) as fevereiro
FROM venda
     JOIN item ON venda.codigo = item.venda
     JOIN produto ON item.produto = produto.codigo
WHERE venda.dia BETWEEN '2000-02-01' and '2000-01-29'
GROUP BY venda.vendedor) AS tmp2 ON tmp1.vendedor = tmp2.vendedor
     JOIN vendedor ON tmp1.vendedor = vendedor.cpf
WHERE tmp1.fevereiro > tmp1.janeiro;





Quanto cada produto vendeu em janeiro

SELECT item.produto, SUM(item.quantidade*produto.preco) AS valor
FROM venda
     JOIN item ON venda.codigo = item.venda
     JOIN produto ON item.produto = produto.codigo
WHERE venda.dia BETWEEN '2000-01-01' AND '2000-01-31'
GROUP BY item.produto
ORDER BY 2 desc;


SELECT *
FROM (
SELECT item.produto, SUM(item.quantidade*produto.preco) AS valor
FROM venda
     JOIN item ON venda.codigo = item.venda
     JOIN produto ON item.produto = produto.codigo
WHERE venda.dia BETWEEN '2000-01-01' AND '2000-01-31'
GROUP BY item.produto
ORDER BY 2 desc) as tmp1;










                         CURVA ABC



SELECT *
FROM (
SELECT item.produto, SUM(item.quantidade*produto.preco) AS valor
FROM venda
     JOIN item ON venda.codigo = item.venda
     JOIN produto ON item.produto = produto.codigo
WHERE venda.dia BETWEEN '2000-01-01' AND '2000-01-31'
GROUP BY item.produto
ORDER BY 2 desc) as tmp1
WHERE valor BETWEEN 460.99 AND 599.5;




Somatorio da 3 primeiras linhas
SELECT SUM(valor)
FROM (
SELECT item.produto, SUM(item.quantidade*produto.preco) AS valor
FROM venda
     JOIN item ON venda.codigo = item.venda
     JOIN produto ON item.produto = produto.codigo
WHERE venda.dia BETWEEN '2000-01-01' AND '2000-01-31'
GROUP BY item.produto
ORDER BY 2 desc) as tmp1
WHERE valor BETWEEN 460.99 AND 599.5;




Somatorio da 4 primeiras linhas
SELECT SUM(valor)
 FROM (
  SELECT item.produto, SUM(item.quantidade*produto.preco) AS valor
   FROM venda
    JOIN item ON venda.codigo = item.venda
     JOIN produto ON item.produto = produto.codigo
      WHERE venda.dia BETWEEN '2000-01-01' AND '2000-01-31'
       GROUP BY item.produto
        ORDER BY 2 desc) as tmp1
         WHERE valor BETWEEN 460.99 AND 599.5;
                               ^ valor da linha no caso boto o valor q ta na 4 linha.




SELECT SUM(valor)
FROM (
SELECT item.produto, SUM(item.quantidade*produto.preco) AS valor
FROM venda
     JOIN item ON venda.codigo = item.venda
     JOIN produto ON item.produto = produto.codigo
WHERE venda.dia BETWEEN '2000-01-01' AND '2000-01-31'
GROUP BY item.produto
ORDER BY 2 desc) as tmp1
WHERE valor BETWEEN tmp1.valor AND 599.5;




cada vendedor ele teve nesse periodo inteiro

SELECT venda.vendedor, COUNT(*) as quantidade
 FROM venda
  GROUP BY venda.vendedor
   ORDER BY venda.vendedor asc;

pra cada linha do vendedor adiciona uma coluna que é esse subselect , o sub select conta quantas vendas esse
vendedor teve.
é um para faça

para esse vendedor  faça o subselect
     v                v
SELECT *, (select count (*) as total_de_vendas from venda where venda.vendedor = vendedor.cpf) FROM vendedor ORDER BY vendedor.cpf asc;






   (SELECT SUM(valor) as soma
   FROM (
   SELECT item.produto, SUM(item.quantidade*produto.preco) AS valor
   FROM venda
        JOIN item ON venda.codigo = item.venda
        JOIN produto ON item.produto = produto.codigo
   WHERE venda.dia BETWEEN '2000-01-01' AND '2000-04-17'
   GROUP BY item.produto
   ORDER BY 2 desc) as tmp1
   WHERE valor BETWEEN tmp1.valor AND 599.5)


select sum(subtotal+field) as field




select sum(tmp1.subtotal2) as tt from
(select produto.codigo,(SUM(produto.preco*item.quantidade)) as subtotal2
from produto
join item on produto.codigo = item.produto group by produto.codigo
order by subtotal2 desc)as tmp1,

(select produto.codigo, (SUM(produto.preco*item.quantidade)) as subtotal
from produto
join item on produto.codigo = item.produto
group by produto.codigo
order by subtotal desc) as tmp2 where tmp1.codigo = tmp2.codigo and tmp1.subtotal2<=tmp2.subtotal
group by tmp2.subtotal;

 as tmp1 ON tmp1.codigo = produto.codigo AND tmp1.subtotal => subtotal2
group by produto.codigo, tmp1.subtotal
order by tmp1.subtotal desc;








select produto.codigo, tmp1.subtotal,(SUM(produto.preco*item.quantidade)) as subtotal2
from produto
join item on produto.codigo = item.produto
join (select produto.codigo, (SUM(produto.preco*item.quantidade)) as subtotal
from produto
join item on produto.codigo = item.produto
group by produto.codigo
order by subtotal desc) as tmp1 ON tmp1.codigo = produto.codigo AND tmp1.subtotal => subtotal2
group by produto.codigo, tmp1.subtotal
order by tmp1.subtotal desc;

















.
