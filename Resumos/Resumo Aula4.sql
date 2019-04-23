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

