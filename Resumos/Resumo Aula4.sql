\i booktown.sql 

select title, last_name, first_name from books, authors where books.author_id = authors.author_id;
select title, last_name, first_name from books cross join authors where books.author_id = authors.author_id;
select title, last_name, first_name from books inner join authors on books.author_id = authors.author_id;
select title, last_name, first_name from books inner join authors using (author_id);
select title, last_name, first_name from books natural inner join authors;
select title, isbn from books inner join editions on books.book_id = editions.book_id;
select title, isbn from books left join editions on books.book_id = editions.book_id;

select * from books, authors; --produto cartesiano

select * from books, authors where books.author_id = authors.author_id; --cross join liga author_id de uma tabela com outra.

--select com nome do livro e nome completo do autor usando o select de cima ^
select books.title, authors.first_name|| ' ' ||authors.last_name as name from books, authors where books.author_id = authors.author_id;

select * from books cross join authors where books.author_id = authors.author_id; -- mesma coisa que o primeiro cross join, troca , por cross join

-- inner join: junção de tipo interno,
-- a junção do inner join acontece por causa do "on books.author_id = authors.author_id" e o where pode ser posto depois
select * from books inner join authors on books.author_id = authors.author_id; -- faz mesma coisa que o cross join de cima


--Proibido usar esses 2 selects a seguir, usar só quando um banco foi muito bem modelado.
-- faz o join onde o campo esteja usando "author_id" (da pra fazer com campos diferentes)
select * from books inner join authors using (author_id);

-- natural inner join: e ele vai fazer o join naturalmente procurando campo com authors
select * from books natural inner join authors;


select * from books join authors on books.author_id = authors.author_id;
select * from books join authors using (author_id);
select * from books natural join authors;


select * from books left outer join authors on books.author_id = authors.author_id; --todos livros mesmo sem autor.

select * from authors right outer join books on books.author_id = authors.author_id;--autor independente que não tenha livro.

select * from books join editions on books.book_id = editions.book_id;--livros que tem edição

select * from books left join editions on books.book_id = editions.book_id; --livros que tem e não tem edição

select * from books left join editions on books.book_id = editions.book_id where editions.book_id is null;

