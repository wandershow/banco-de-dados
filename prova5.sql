\c postgres
drop database biblioteca;
create database biblioteca;
\c biblioteca
create table usuario (codigo integer not null, nome varchar(100) not null, tipo char(1) not null check ((tipo = 'A') or (tipo = 'P') or (tipo = 'F')), curso varchar(100), primary key (codigo));
create table livro (codigo integer not null, titulo varchar(200) not null, primary key (codigo));
create table exemplar (codigo integer not null, livro integer not null references livro(codigo), primary key (codigo));
create table locacao (usuario integer not null references usuario(codigo), exemplar integer not null references exemplar(codigo), retirada date not null default now(), entrega date, primary key (usuario, exemplar, retirada));

----------------------------------------------------------------------------------------------------

--1) Resolva utilizando comandos insert, update e delete:

--a) Cadastrar a locação, hoje, de um exemplar do livro Dominando o Postgresql por você, aluno do Curso Superior de Tecnologia em Análise e Desenvolvimento de Sistemas. (1 ponto)
 insert into usuario (codigo, nome, tipo, curso) values (101, 'wanderson', 'A', 'curso superior de tecnologia em analise e desenvolvimento de sistemas');
 insert into livro (codigo, titulo) values (31, 'dominando o postgresql');
 insert into exemplar (codigo, livro) values (31001, 31);
 insert into locacao (usuario, exemplar) values (101, 31001);
 
 select * from locacao where usuario = 101;
 
--b) Cadastrar a entrega, hoje, do exemplar do livro Dominando o Postgresql locado por você. (1 ponto)
update locacao set entrega = '2019-06-18' where usuario = 101 and exemplar = 31001;

--c) Desfazer a locação incorretamente cadastrada ontem do exemplar do livro Criando Páginas Web com PHP pela aluna Maria de Jesus da Silva do Curso Técnico Integrado em Informática para Internet. (1 ponto)

 insert into usuario (codigo, nome, tipo, curso) values (102, 'José da Silva Brasil', 'A', 'Curso Tecnico Integrado em Informatica para Internet');
 insert into livro (codigo, titulo) values (32, 'livro Programando em Java');
 insert into exemplar (codigo, livro) values (32001, 32);
 insert into locacao (usuario, exemplar, retirada) values (102, 32001, '2019-06-17');
 
 select * from locacao where usuario = 102;
 
 delete from locacao where usuario = 102 and exemplar = 32001 and retirada = '2019-06-17';
 
--d) Desfazer a entrega incorretamente cadastrada do exemplar do livro Programando em Java pelo aluno José da Silva Brasil do Curso Técnico Integrado em Informática para Internet em 15 de maio deste ano. (1 ponto)
insert into usuario (codigo, nome, tipo, curso) values (103, 'José da Silva Brasil', 'A', 'Curso Tecnico Integrado em Informatica para Internet');
 insert into livro (codigo, titulo) values (33, 'livro Programando em Java');
 insert into exemplar (codigo, livro) values (33001, 33);
 insert into locacao (usuario, exemplar, retirada, entrega) values (103, 33001, '2019-05-14', '2019-05-15');
 
 select * from locacao where usuario = 103;
 update locacao set entrega = null where usuario = 103 and exemplar = 33001;
 
--2) Resolva utilizando funções em plpgsql:

--a) Sabendo que o prazo de locação é de 7 dias para alunos, mostrar, como no exemplo, a lista de alunos com livros locados e entrega atrasada, por curso. (3 pontos)
 	select usuario.* from locacao join usuario on locacao.usuario = usuario.codigo where (entrega is not null and (entrega -retirada) > 7) and tipo = 'A' group by codigo order by 4 asc, 1 asc;
--	 curso   | alunos
--	---------+---------------------------------------
--	 curso 1 | aluno 23, aluno 12, aluno 98, aluno 7
--	 curso 2 | aluno 37, aluno 74
--	 ...
create type lista as (curso varchar(100), aluno varchar(1000));
create or replace function listaaluno() returns setof lista as $$ -- 'returns setof' retorna varias colunas
declare
	r_curso record;
	r_nome record;
	r_lista lista%rowtype; -- sempre vou usar o '%rowtype' quando usar um 'next'
	begin
		for r_curso in select usuario.curso from locacao join usuario on locacao.usuario = usuario.codigo where (entrega is not null and (entrega -retirada) > 7) and tipo = 'A'group by 1 order by 1 asc loop
				for r_nome in select distinct(usuario.nome) from locacao join usuario on locacao.usuario = usuario.codigo where (entrega is not null and (entrega -retirada) > 7) and tipo = 'A' loop
					--if (r_curso.nome = usuario.curso) then
						r_lista.aluno := r_nome;
					--end if;
				end loop;
			r_lista.curso := r_curso;
			return next r_lista; --'next' = nao retorna ainda, acrescenta uma linha no resultado, nesse caso para cada curso o nome e o nome do aluno
		end loop;
	return;
end;
$$ language 'plpgsql';
select * from listaaluno();

----------------------------------------------------------------------




--b) Mostrar, como no exemplo, a colocação de cada aluno no ranking por quantidade de livros locados nos últimos 6 meses, por curso. (3 pontos)

--	 aluno    | curso   | locacoes | colocacao
--	----------+---------+----------+-----------
--	 aluno 8  | curso 1 | 12       | 1
--	 aluno 23 | curso 1 | 11       | 2
--	 ...
--	 aluno 93 | curso 1 | 0        | 54
--	 aluno 7  | curso 1 | 0        | 55
--	 aluno 15 | curso 2 | 9        | 1
--	 aluno 85 | curso 2 | 9        | 2
--	 ...
--	 aluno 2  | curso 2 | 1        | 67
--	 aluno 79 | curso 2 | 0        | 68
--	 aluno 13 | curso 3 | 15       | 1
--	 aluno 98 | curso 3 | 14       | 2
--	 ...
--	 aluno 35 | curso 3 | 0        | 43
--	 aluno 51 | curso 3 | 0        | 44
--	 ...
 
create type tipoquestao2b as ( aluno varchar(100), curso varchar(100), locacoes integer, colocacao integer);
create function questao2b() returns setof tipoquestao2b as $$
declare 
		r_resposta tipoquestao2b%rowtype;
		r_ranking record;
		curso varchar (100);
		colocacao integer;
begin
		curso = ' ';
		for r_ranking in select usuario.nome, usuario.curso, count(*) as locacoes from locacao join usuario on usuario.codigo = locacao.usuario where usuario.tipo = 'A' and 
		locacao.retirada < now() - '6 months'::interval group by usuario.codigo order by 2 asc, 3 desc loop
				if r_ranking.curso <> then 
					curso := r_ranking.curso;
					colocacao := 1;
				end if;
				r_resposta.aluno := r_ranking.nome;
				r_resposta.curso := r_ranking.curso;
				r_resposta.locacoes:= r_ranking.locacoes;
				r_resposta.colocacao := colocacao;
				return next r_resposta;
				colocacao := colocacao+1;
				end loop;
		return;
	end;
$$ language 'plpgsql';
select * from questao2b();

