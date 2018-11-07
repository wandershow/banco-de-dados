-- Com base no exemplo de venda abaixo:

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




-- 1) Mostrar o valor total concedido em descontos por mês em 2000.


SELECT * FROM venda;

SELECT *
 FROM VENDA
  JOIN item ON venda.codigo = item.venda;

SELECT *
 FROM VENDA
  JOIN item ON venda.codigo = item.venda
   JOIN produto ON item.produto = produto.codigo;

SELECT venda.codigo, venda.dia, item.quantidade, produto.preco, venda.desconto
 FROM VENDA
  JOIN item ON venda.codigo = item.venda
   JOIN produto ON item.produto = produto.codigo;

SELECT venda.codigo, venda.dia, item.quantidade, produto.preco, item.quantidade*produto.preco AS subtotal, venda.desconto
 FROM VENDA
  JOIN item ON venda.codigo = item.venda
   JOIN produto ON item.produto = produto.codigo;

--só pode por coisas no select que estão declaradas nos from e join
SELECT venda.codigo, venda.dia, item.quantidade, produto.preco, item.quantidade*produto.preco AS subtotal, venda.desconto, item.quantidade*produto.preco*venda.desconto/100 AS desconto2
 FROM VENDA
  JOIN item ON venda.codigo = item.venda
   JOIN produto ON item.produto = produto.codigo;

SELECT venda.codigo,item.quantidade*produto.preco*venda.desconto/100 AS desconto
 FROM VENDA
  JOIN item ON venda.codigo = item.venda
   JOIN produto ON item.produto = produto.codigo;

SELECT venda.codigo,item.quantidade*produto.preco*venda.desconto/100 AS desconto
 FROM VENDA
  JOIN item ON venda.codigo = item.venda
   JOIN produto ON item.produto = produto.codigo
    GROUP BY venda.codigo;

SELECT venda.codigo,SUM(item.quantidade*produto.preco*venda.desconto/100) AS desconto
 FROM VENDA
  JOIN item ON venda.codigo = item.venda
   JOIN produto ON item.produto = produto.codigo
    GROUP BY venda.codigo;

SELECT venda.codigo, SUM(item.quantidade*produto.preco*venda.desconto/100) AS desconto
 FROM VENDA
  JOIN item ON venda.codigo = item.venda
   JOIN produto ON item.produto = produto.codigo
    GROUP BY venda.codigo
     ORDER BY venda.codigo;

SELECT date_part('month', venda.dia) AS mes,
 item.quantidade*produto.preco*venda.desconto/100 AS desconto
 FROM VENDA
  JOIN item ON venda.codigo = item.venda
   JOIN produto ON item.produto = produto.codigo;


---------------------------------------------------------------------------------------------------------------
SELECT date_part('month', venda.dia) AS mes, SUM(item.quantidade*produto.preco*venda.desconto/100) AS desconto
 FROM VENDA
  JOIN item ON venda.codigo = item.venda
   JOIN produto ON item.produto = produto.codigo
    GROUP BY mes;  -- da pra trocar o "mes" por "1"
---------------------------------------------------------------------------------------------------------------


-- 2) Mostrar o ranking dos produtos mais vendidos por faixa etária em fevereiro de 2000.

SELECT *
 FROM venda
  JOIN item ON venda.codigo = item.venda
   JOIN cliente ON venda.cliente = cliente.cpf;

SELECT *
 FROM venda
  JOIN item ON venda.codigo = item.venda
   JOIN cliente ON venda.cliente = cliente.cpf
    WHERE venda.dia BETWEEN '2000-02-01' AND '2000-02-29';

SELECT venda.codigo, cliente.nascimento, AGE(cliente.nascimento)
 FROM venda
  JOIN item ON venda.codigo = item.venda
   JOIN cliente ON venda.cliente = cliente.cpf
    WHERE venda.dia BETWEEN '2000-02-01' AND '2000-02-29';

SELECT venda.codigo, cliente.nascimento, DATE_PART('year', AGE(cliente.nascimento))
 FROM venda
  JOIN item ON venda.codigo = item.venda
   JOIN cliente ON venda.cliente = cliente.cpf
    WHERE venda.dia BETWEEN '2000-02-01' AND '2000-02-29';

SELECT venda.codigo, cliente.nascimento, ('{18-25,26-35,-36-45,46-55,56-65,66-75,76-}'::text[])[FLOOR((date_part('year', AGE(cliente.nascimento))-6/10))] as faixa
 FROM venda
  JOIN item ON venda.codigo = item.venda
   JOIN cliente ON venda.cliente = cliente.cpf
    WHERE venda.dia BETWEEN '2000-02-01' AND '2000-02-29';

SELECT  ('{18-25,26-35,-36-45,46-55,56-65,66-75,76-}'::text[])[FLOOR((date_part('year', AGE(cliente.nascimento))-6)/10)] as faixa
 FROM venda
  JOIN item ON venda.codigo = item.venda
   JOIN cliente ON venda.cliente = cliente.cpf
    WHERE venda.dia BETWEEN '2000-02-01' AND '2000-02-29'
     GROUP BY 1;

SELECT  ('{18-25,26-35,-36-45,46-55,56-65,66-75,76-}'::text[])[FLOOR((date_part('year', AGE(cliente.nascimento))-6)/10)] as faixa, produto.descricao , SUM(item.quantidade) as quantidade
 FROM venda
  JOIN item ON venda.codigo = item.venda
   JOIN cliente ON venda.cliente = cliente.cpf
    WHERE venda.dia BETWEEN '2000-02-01' AND '2000-02-29'
     GROUP BY 1;

SELECT  ('{18-25,26-35,-36-45,46-55,56-65,66-75,76-}'::text[])[FLOOR((date_part('year', AGE(cliente.nascimento))-6)/10)] as faixa, produto.descricao, item.quantidade AS quantidade
 FROM venda
  JOIN item ON venda.codigo = item.venda
   JOIN cliente ON venda.cliente = cliente.cpf
    JOIN produto ON item.produto = produto.codigo
    WHERE venda.dia BETWEEN '2000-02-01' AND '2000-02-29';

SELECT  ('{18-25,26-35,-36-45,46-55,56-65,66-75,76-}'::text[])[FLOOR((date_part('year', AGE(cliente.nascimento))-6)/10)] as faixa, produto.descricao, SUM(item.quantidade) AS quantidade
 FROM venda
  JOIN item ON venda.codigo = item.venda
   JOIN cliente ON venda.cliente = cliente.cpf
    JOIN produto ON item.produto = produto.codigo
     WHERE venda.dia BETWEEN '2000-02-01' AND '2000-02-29'
      GROUP BY 1,2
       ORDER BY 1,2;

----------------------------------------------------------------------------------------------------------------------------------
SELECT ('{18-25,26-35,-36-45,46-55,56-65,66-75,76-}'::text[])[FLOOR((date_part('year', AGE(cliente.nascimento))-6)/10)] as faixa, produto.descricao, SUM(item.quantidade) AS quantidade
 FROM venda
  JOIN item ON venda.codigo = item.venda
   JOIN cliente ON venda.cliente = cliente.cpf
    JOIN produto ON item.produto = produto.codigo
     WHERE venda.dia BETWEEN '2000-02-01' AND '2000-02-29'
      GROUP BY 1,2
       ORDER BY 1 asc ,3 desc;
----------------------------------------------------------------------------------------------------------------------------------


-- 3) Mostrar o faturamento líquido quinzenal em fevereiro de 2000.

SELECT *
 FROM venda
  JOIN item ON venda.codigo = item.venda
   JOIN produto ON item.produto = produto.codigo;

-- preco = $200
-- comissao = 5%
-- preco*comissao = 200*5/100 = $10

-- preco - $200
-- comissao = 5$
-- faturamento = 200*(100-comissao)/100

SELECT venda.codigo, item.quantidade, produto.preco, produto.comissao,venda.desconto,
 item.quantidade*produto.preco AS bruto,
  item.quantidade*produto.preco*venda.desconto/100 AS desconto,
   item.quantidade*produto.preco*produto.comissao/100 AS comissao
    FROM venda
     JOIN item ON venda.codigo = item.venda
      JOIN produto ON item.produto = produto.codigo;

SELECT venda.codigo, item.quantidade, produto.preco, produto.comissao,venda.desconto,
 item.quantidade*produto.preco AS bruto,
  item.quantidade*produto.preco*venda.desconto/100 AS desconto,
   item.quantidade*produto.preco*produto.comissao/100 AS comissao
    FROM venda
     JOIN item ON venda.codigo = item.venda
      JOIN produto ON item.produto = produto.codigo
       WHERE venda.dia BETWEEN '2000-02-01' AND '2000-02-29';

SELECT
 item.quantidade*produto.preco AS bruto,
  item.quantidade*produto.preco*venda.desconto/100 AS desconto,
   item.quantidade*produto.preco*produto.comissao/100 AS comissao
    FROM venda
     JOIN item ON venda.codigo = item.venda
      JOIN produto ON item.produto = produto.codigo
       WHERE venda.dia BETWEEN '2000-02-01' AND '2000-02-29';

SELECT
 (item.quantidade*produto.preco) -
  (item.quantidade*produto.preco*venda.desconto/100) -
   (item.quantidade*produto.preco*produto.comissao/100) AS liquido
    FROM venda
     JOIN item ON venda.codigo = item.venda
      JOIN produto ON item.produto = produto.codigo
       WHERE venda.dia BETWEEN '2000-02-01' AND '2000-02-29';

SELECT FLOOR(1+date_part('day', venda.dia)/16) as quinzena,
	(item.quantidade*produto.preco) - -- evidencia
  (item.quantidade*produto.preco*venda.desconto/100) -
   (item.quantidade*produto.preco*produto.comissao/100) AS liquido
    FROM venda
     JOIN item ON venda.codigo = item.venda
      JOIN produto ON item.produto = produto.codigo
       WHERE venda.dia BETWEEN '2000-02-01' AND '2000-02-29';

SELECT FLOOR(1+date_part('day', venda.dia)/16) as quinzena,
	SUM((item.quantidade*produto.preco) - -- evidencia
  (item.quantidade*produto.preco*venda.desconto/100) -
   (item.quantidade*produto.preco*produto.comissao/100)) AS liquido
    FROM venda
     JOIN item ON venda.codigo = item.venda
      JOIN produto ON item.produto = produto.codigo
       WHERE venda.dia BETWEEN '2000-02-01' AND '2000-02-29'
	GROUP BY 1; --podia por "quinzena"


---------------------------------------------------------------------------------------------------------------
SELECT FLOOR(1+date_part('day', venda.dia)/16) as quinzena,
	SUM((item.quantidade*produto.preco) - -- evidencia
  (item.quantidade*produto.preco*venda.desconto/100) -
   (item.quantidade*produto.preco*produto.comissao/100)) AS liquido
    FROM venda
     JOIN item ON venda.codigo = item.venda
      JOIN produto ON item.produto = produto.codigo
       WHERE venda.dia BETWEEN '2000-02-01' AND '2000-02-29'
	GROUP BY 1 --podia por "quinzena"
	 ORDER BY 1 ASC; -- tb aceita numero da coluna
---------------------------------------------------------------------------------------------------------------


-- 4) Mostrar o pagamento que cada vendedor deve receber por fevereiro de 2000.

SELECT *
 FROM venda
  JOIN item ON venda.codigo = item.venda
   JOIN produto ON item.produto = produto.codigo;

SELECT *, item.quantidade*produto.preco*produto.comissao/100 AS comissao
 FROM venda
  JOIN item ON venda.codigo = item.venda
   JOIN produto ON item.produto = produto.codigo;

SELECT *, item.quantidade*produto.preco*produto.comissao/100 AS comissao
 FROM venda
  JOIN item ON venda.codigo = item.venda
   JOIN produto ON item.produto = produto.codigo
    WHERE venda.dia BETWEEN '2000-02-01' AND '2000-02-29';

SELECT venda.vendedor, item.quantidade*produto.preco*produto.comissao/100 AS comissao
 FROM venda
  JOIN item ON venda.codigo = item.venda
   JOIN produto ON item.produto = produto.codigo
    WHERE venda.dia BETWEEN '2000-02-01' AND '2000-02-29';

SELECT venda.vendedor, item.quantidade*produto.preco*produto.comissao/100 AS comissao
 FROM venda
  JOIN item ON venda.codigo = item.venda
   JOIN produto ON item.produto = produto.codigo
    WHERE venda.dia BETWEEN '2000-02-01' AND '2000-02-29'
     GROUP BY venda.vendedor;

SELECT venda.vendedor,SUM( item.quantidade*produto.preco*produto.comissao/100) AS comissao
 FROM venda
  JOIN item ON venda.codigo = item.venda
   JOIN produto ON item.produto = produto.codigo
    WHERE venda.dia BETWEEN '2000-02-01' AND '2000-02-29'
     GROUP BY venda.vendedor;

-- vai dar erro        v
SELECT venda.vendedor, vendedor.salario,SUM( item.quantidade*produto.preco*produto.comissao/100) AS comissao
 FROM venda
  JOIN item ON venda.codigo = item.venda
   JOIN produto ON item.produto = produto.codigo
    JOIN vendedor ON venda.vendedor = vendedor.cpf
     WHERE venda.dia BETWEEN '2000-02-01' AND '2000-02-29'
      GROUP BY venda.vendedor;

-- troca " , " por " + "               v   mas vai dar erro
SELECT venda.vendedor, vendedor.salario+SUM( item.quantidade*produto.preco*produto.comissao/100) AS comissao
 FROM venda
  JOIN item ON venda.codigo = item.venda
   JOIN produto ON item.produto = produto.codigo
    JOIN vendedor ON venda.vendedor = vendedor.cpf
     WHERE venda.dia BETWEEN '2000-02-01' AND '2000-02-29'
      GROUP BY venda.vendedor;

SELECT *
 FROM vendedor
  JOIN(
   SELECT venda.vendedor,SUM( item.quantidade*produto.preco*produto.comissao/100) AS comissao
    FROM venda
     JOIN item ON venda.codigo = item.venda
      JOIN produto ON item.produto = produto.codigo
       JOIN vendedor ON venda.vendedor = vendedor.cpf
        WHERE venda.dia BETWEEN '2000-02-01' AND '2000-02-29'
         GROUP BY venda.vendedor) AS tmp1 ON vendedor.cpf = tmp1.vendedor;


---------------------------------------------------------------------------------------------------------------
-- salario foi declarado no from do vendedor e comissao no tmp1
SELECT vendedor.nome, vendedor.salario +tmp1.comissao AS pagamento
 FROM vendedor
  JOIN(
   SELECT venda.vendedor,SUM( item.quantidade*produto.preco*produto.comissao/100) AS comissao
    FROM venda
     JOIN item ON venda.codigo = item.venda
      JOIN produto ON item.produto = produto.codigo
       JOIN vendedor ON venda.vendedor = vendedor.cpf
        WHERE venda.dia BETWEEN '2000-02-01' AND '2000-02-29'
         GROUP BY venda.vendedor) AS tmp1 ON vendedor.cpf = tmp1.vendedor;
---------------------------------------------------------------------------------------------------------------
