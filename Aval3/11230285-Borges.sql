1) Mostrar os vendedores que não cumpriram a meta de $500 em vendas
--(valor da nota) na segunda quinzena de fevereiro de 2000.


Resposta:
--não consigo/lembro uma forma de continuar, acabou dando resultado em boolean
-- mas n consigo tirar as alternativas que não quero nesse caso tirar os "F"

SELECT vendedor.nome,(tmp1.valor_da_nota < 500) AS meta
 FROM vendedor
  JOIN(
   SELECT venda.vendedor,SUM(item.quantidade*produto.preco) AS valor_da_nota
    FROM venda
     JOIN item ON venda.codigo = item.venda
      JOIN produto ON item.produto = produto.codigo
       JOIN vendedor ON venda.vendedor = vendedor.cpf
        WHERE venda.dia BETWEEN '2000-02-16' AND '2000-02-29'
          GROUP BY venda.vendedor) AS tmp1 ON vendedor.cpf = tmp1.vendedor
           order by meta;

--------------------------------------------------------------------------------
2) Mostrar os clientes que realizaram mais de 1 compra em todos os 3 primeiros meses de 2000.

-- SELECT *
--  FROM venda
--   JOIN cliente ON venda.cliente = cliente.cpf;
--
-- SELECT venda.codigo, cliente.cpf , venda.dia
--  FROM venda
--   JOIN cliente ON venda.cliente = cliente.cpf
--    WHERE venda.dia between '2000-01-02' AND '2000-03-31';
--
--
-- SELECT cliente.cpf, tmp1.cliente
--  FROM venda
--   JOIN cliente ON venda.cliente = cliente.cpf
--   JOIN  tmp1 ON(
--   (select venda.cliente, count(*) as quantidade
--    from venda
--     WHERE venda.dia between '2000-01-02' AND '2000-01-31'
--      group by venda.cliente having count(*) >= 2) as janeiro)
--      (select venda.cliente, count(*) as quantidade
--       from venda
--        WHERE venda.dia between '2000-02-01' AND '2000-02-29'
--         group by venda.cliente having count(*) >= 2) as fevereiro
--         (select venda.cliente, count(*) as quantidade
--          from venda
--           WHERE venda.dia between '2000-01-01' AND '2000-03-31'
--            group by venda.cliente having count(*) >= 2) as marco) as tmp1 on venda.cliente = tmp1.cliente
--             order by venda.cliente;
--
-- verificar todos no mes até iguais
-- SELECT cliente.cpf, cliente.nome
-- FROM venda
-- JOIN cliente ON venda.cliente = cliente.cpf
-- WHERE venda.dia between '2000-03-01' AND '2000-03-31'
-- order by cliente.cpf;



Resposta:
-- n tem quem comprou nos 3 meses 2 coisas ou mais,
-- n ta perfeito pois mostrar quem vai ter 6 ou mais, n consegui fazer o de cima ^
-- pra mostrar corretamente

SELECT cliente.nome, tmp1.cliente
   FROM (
    (select venda.cliente, count(*) as quantidade
     from venda
      WHERE venda.dia between '2000-01-02' AND '2000-03-31'
       group by venda.cliente having count(*) >= 6)) as tmp1
        JOIN cliente ON tmp1.cliente = cliente.cpf
         order by tmp1.cliente;
--------------------------------------------------------------------------------


3) Mostrar a(s) venda(s) de maior valor (valor da nota) em fevereiro de 2000.
-- esse ta só a soma de todas as venda de um vendedor não a venda.
Resposta:
SELECT vendedor.nome, tmp1.valor_da_nota
 FROM vendedor
  JOIN(
   SELECT venda.vendedor,SUM( item.quantidade*produto.preco) AS valor_da_nota
    FROM venda
     JOIN item ON venda.codigo = item.venda
      JOIN produto ON item.produto = produto.codigo
       JOIN vendedor ON venda.vendedor = vendedor.cpf
        WHERE venda.dia BETWEEN '2000-02-01' AND '2000-02-29'
          GROUP BY venda.codigo) AS tmp1 ON vendedor.cpf = tmp1.vendedor
           order by tmp1.valor_da_nota desc limit 1 offset 0;


--------------------------------------------------------------------------------


4) Mostrar os vendedores que venderam (valor da nota) mais em fevereiro do que em janeiro de 2000.
-- não consegui/lembrei como selecionar o maior entre as duas tabelas


SELECT vendedor.nome, jan.jan_valor_da_nota, fev.fev_valor_da_nota
 FROM vendedor
  JOIN(
   SELECT venda.vendedor,SUM( item.quantidade*produto.preco) AS jan_valor_da_nota
    FROM venda
     JOIN item ON venda.codigo = item.venda
      JOIN produto ON item.produto = produto.codigo
       JOIN vendedor ON venda.vendedor = vendedor.cpf
        WHERE venda.dia BETWEEN '2000-01-02' AND '2000-01-31'
          GROUP BY venda.vendedor) AS jan ON vendedor.cpf = jan.vendedor
            JOIN(
             SELECT venda.vendedor,SUM( item.quantidade*produto.preco) AS fev_valor_da_nota
              FROM venda
               JOIN item ON venda.codigo = item.venda
                JOIN produto ON item.produto = produto.codigo
                 JOIN vendedor ON venda.vendedor = vendedor.cpf
                  WHERE venda.dia BETWEEN '2000-02-01' AND '2000-02-29'
                    GROUP BY venda.vendedor) AS fev ON vendedor.cpf = fev.vendedor
                     order by vendedor.nome;

Resposta:
-- peguei a tabela de cima ^ e transformei pra boolean mas n sei como tirar as false

SELECT vendedor.nome, (jan.jan_valor_da_nota < fev.fev_valor_da_nota) as vendeu_mais_em_fev
 FROM vendedor
  JOIN(
   SELECT venda.vendedor,SUM( item.quantidade*produto.preco) AS jan_valor_da_nota
    FROM venda
     JOIN item ON venda.codigo = item.venda
      JOIN produto ON item.produto = produto.codigo
       JOIN vendedor ON venda.vendedor = vendedor.cpf
        WHERE venda.dia BETWEEN '2000-01-02' AND '2000-01-31'
          GROUP BY venda.vendedor) AS jan ON vendedor.cpf = jan.vendedor
            JOIN(
             SELECT venda.vendedor,SUM( item.quantidade*produto.preco) AS fev_valor_da_nota
              FROM venda
               JOIN item ON venda.codigo = item.venda
                JOIN produto ON item.produto = produto.codigo
                 JOIN vendedor ON venda.vendedor = vendedor.cpf
                  WHERE venda.dia BETWEEN '2000-02-01' AND '2000-02-29'
                    GROUP BY venda.vendedor) AS fev ON vendedor.cpf = fev.vendedor
                     order by vendedor.nome;
