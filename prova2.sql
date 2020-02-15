\c postgres
drop database biblioteca;
create database biblioteca;
\c biblioteca
create table usuario (codigo integer not null, nome varchar(100) not null, tipo char(1) not null check ((tipo = 'A') or (tipo = 'P') or (tipo = 'F')), curso varchar(100), primary key (codigo));
create table livro (codigo integer not null, titulo varchar(200) not null, primary key (codigo));
create table exemplar (codigo integer not null, livro integer not null references livro(codigo), primary key (codigo));
create table locacao (usuario integer not null references usuario(codigo), exemplar integer not null references exemplar(codigo), retirada date not null default now(), entrega date, primary key (usuario, exemplar, retirada));

----------------------------------------------------------------------------------------------------

--1) Mostrar o título dos livros sobre PostgreSQL não locados por alunos do Curso Superior de Tecnologia em Análise e Desenvolvimento de Sistemas.

select livro.titulo from livro join exemplar on livro.codigo = exemplar.livro join locacao on exemplar.codigo = locacao.exemplar join usuario on locacao.usuario = usuario.codigo where lower(livro.titulo) like '%postgresql%' and
 usuario.tipo = 'A' and lower(usuario.curso) = 'curso superior de tecnologia em analise e desenvolvimento de sistemas' and locacao.exemplar not in (select exemplar.codigo from exemplar join livro on exemplar.livro = livro.codigo where livro.titulo like '%postgresql%') group by 1;
 -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
 --resolucao de betito
    select livro.titulo from locacao
    join exemplar on locacao.exemplar = exemplar.codigo
    join livro on exemplar.livro = livro.codigo
    join usuario on locacao.usuario = usuario.codigo
    where lower(livro.titulo) like '%postgresql%'
    and lower(livro.titulo) not in(
    select livro.titulo from locacao
    join exemplar on locacao.exemplar = exemplar.codigo
    join livro on exemplar.livro = livro.codigo
    join usuario on locacao.usuario = usuario.codigo
    where lower(usuario.tipo) = 'a'
    and lower(usuario.curso) = 'curso superior de tecnologia em analise e desenvolvimento de sistemas'
    and lower(livro.titulo) like '%postgresql%' group by 1);
   
    --Usando EXCEPT
    (select livro.titulo
    from livro
    where lower(livro.titulo) like '%postgresql%')
    except
    (select livro.titulo from locacao
    join exemplar on locacao.exemplar = exemplar.codigo
    join livro on exemplar.livro = livro.codigo
    join usuario on locacao.usuario = usuario.codigo
    where lower(livro.titulo) like '%postgresql%'
    and lower(usuario.tipo) = 'a'
    and lower(usuario.curso) = 'curso superior de tecnologia em analise e desenvolvimento de sistemas');

    --Usando NOT IN
    select livro.titulo
    from livro
    where lower(livro.titulo) like '%postgresql%'
    and livro.codigo not in(select livro.codigo
                            from locacao
                            join exemplar on locacao.exemplar = exemplar.codigo
                            join livro on exemplar.livro = livro.codigo
                            join usuario on locacao.usuario = usuario.codigo
                            where lower(livro.titulo) like '%postgresql%'
                            and lower(usuario.tipo) = 'a'
                            and lower(usuario.curso) = 'curso superior de tecnologia em analise e desenvolvimento de sistemas');


--2) Mostrar o nome do último aluno que locou o livro PostgreSQL na prática.
--minha
    select usuario.nome, livro.titulo, locacao.retirada from livro join exemplar on livro.codigo = exemplar.livro join locacao on exemplar.codigo = locacao.exemplar join usuario on locacao.usuario = usuario.codigo where lower(livro.titulo) like '%postgresql na pratica%' and
 usuario.tipo = 'A' and locacao.retirada = (select locacao.retirada from livro join exemplar on livro.codigo = exemplar.livro join locacao on exemplar.codigo = locacao.exemplar join usuario on locacao.usuario = usuario.codigo where livro.titulo like '%postgresql na pratica%' and usuario.tipo = 'A' order by 1 desc limit 1);

--betito resolução

    select usuario.nome, livro.titulo, locacao.retirada from locacao
    join exemplar on locacao.exemplar = exemplar.codigo
    join livro on exemplar.livro = livro.codigo
    join usuario on locacao.usuario = usuario.codigo
    where lower(usuario.tipo) = 'a' and lower(livro.titulo) = 'postgresql na pratica'
    group by 1,2,3
    having locacao.retirada =(
    select locacao.retirada from locacao
    join exemplar on locacao.exemplar = exemplar.codigo
    join livro on exemplar.livro = livro.codigo
    join usuario on locacao.usuario = usuario.codigo
    where lower(usuario.tipo) = 'a' and lower(livro.titulo) = 'postgresql na pratica' order by 1 desc limit 1);

    --
    select usuario.nome from locacao
    join exemplar on locacao.exemplar = exemplar.codigo
    join livro on exemplar.livro = livro.codigo
    join usuario on locacao.usuario = usuario.codigo
    where usuario.tipo = 'A' and lower(livro.titulo) = 'postgresql na pratica'
    and locacao.retirada = (select max(locacao.retirada)
                            from locacao
                            join exemplar on locacao.exemplar = exemplar.codigo
                            join livro on exemplar.livro = livro.codigo
                            join usuario on locacao.usuario = usuario.codigo
                            where usuario.tipo = 'A' and lower(livro.titulo) = 'postgresql na pratica');


--3) Mostrar o título dos livros sobre PostgreSQL menos locados.
    -- minha
    select livro.titulo
        from livro join exemplar on livro.codigo = exemplar.livro join locacao on exemplar.codigo = locacao.exemplar join usuario on locacao.usuario = usuario.codigo
    where lower(livro.titulo) like '%postgresql%'
        group by 1 
        having count(*) = (select count(*) 
                                from livro join exemplar on livro.codigo = exemplar.livro join locacao on exemplar.codigo = locacao.exemplar join usuario on locacao.usuario = usuario.codigo 
                           where lower(livro.titulo) like '%postgresql%'
                           group by livro.titulo order by count(*) asc limit 1);
--------------------------------------------------------------------------------------------------------------------------------------------------
--resolução betito
    select livro.titulo, count(*) from locacao
    join exemplar on locacao.exemplar = exemplar.codigo
    join livro on exemplar.livro = livro.codigo
    join usuario on locacao.usuario = usuario.codigo
    where lower(livro.titulo) like '%postgresql%' group by 1
    having count(*) = 
    (select tmp1.contador from
    (select livro.titulo, count(*) as contador from locacao
    join exemplar on locacao.exemplar = exemplar.codigo
    join livro on exemplar.livro = livro.codigo
    join usuario on locacao.usuario = usuario.codigo
    where lower(livro.titulo) like '%postgresql%' group by 1 order by 2 asc limit 1) as tmp1);

    --
    select livro.titulo
    from locacao
    join exemplar on locacao.exemplar = exemplar.codigo
    join livro on exemplar.livro = livro.codigo
    where lower(livro.titulo) like '%postgresql%'
    group by livro.titulo
    having count(*) =(select count(*)
                      from locacao
                      join exemplar on locacao.exemplar = exemplar.codigo
                      join livro on exemplar.livro = livro.codigo
                      where lower(livro.titulo) like '%postgresql%' group by livro.titulo order by 1 asc limit 1);
    
    
--4) Mostrar o nome dos alunos e dos professores que locaram mais livros em março de 2018.
  (select usuario.nome
  from locacao
    join usuario on usuario.codigo = locacao.usuario
  where usuario.tipo = 'A' and locacao.retirada between '2018-03-01' and '2018-03-31'
  group by usuario.codigo
  having count(*) = (select count(*) 
                    from locacao
                        join usuario on usuario.codigo = locacao.usuario
                    where usuario.tipo = 'A' and locacao.retirada between '2018-03-01' and '2018-03-31'
                    group by usuario.codigo
                    order by 1 desc limit 1)
  union
  (select usuario.nome
  from locacao
    join usuario on usuario.codigo = locacao.usuario
  where usuario.tipo = 'P' and locacao.retirada between '2018-03-01' and '2018-03-31'
  group by usuario.codigo
  having count(*) = (select count(*) 
                    from locacao
                        join usuario on usuario.codigo = locacao.usuario
                    where usuario.tipo = 'P' and locacao.retirada between '2018-03-01' and '2018-03-31'
                    group by usuario.codigo
                    order by 1 desc limit 1));












insert into usuario (codigo, nome, tipo, curso) values (1, 'aluno 1', 'A', 'curso tecnico integrado em informatica para internet');
insert into usuario (codigo, nome, tipo, curso) values (2, 'aluno 2', 'A', 'curso superior de tecnologia em analise e desenvolvimento de sistemas');
insert into usuario (codigo, nome, tipo, curso) values (3, 'aluno 3', 'A', 'curso tecnico integrado em refrigeracao e ar condicionado');
insert into usuario (codigo, nome, tipo) values (4, 'professor 4', 'P');
insert into usuario (codigo, nome, tipo, curso) values (5, 'aluno 5', 'A', 'curso tecnico integrado em informatica para internet');
insert into usuario (codigo, nome, tipo, curso) values (6, 'aluno 6', 'A', 'curso tecnico integrado em eletrotecnica');
insert into usuario (codigo, nome, tipo, curso) values (7, 'aluno 7', 'A', 'curso superior de tecnologia em analise e desenvolvimento de sistemas');
insert into usuario (codigo, nome, tipo, curso) values (8, 'aluno 8', 'A', 'curso tecnico integrado em refrigeracao e ar condicionado');
insert into usuario (codigo, nome, tipo, curso) values (9, 'aluno 9', 'A', 'curso superior de tecnologia em analise e desenvolvimento de sistemas');
insert into usuario (codigo, nome, tipo) values (10, 'funcionario 10', 'F');
insert into usuario (codigo, nome, tipo, curso) values (11, 'aluno 11', 'A', 'curso superior de tecnologia em analise e desenvolvimento de sistemas');
insert into usuario (codigo, nome, tipo, curso) values (12, 'aluno 12', 'A', 'curso superior de tecnologia em analise e desenvolvimento de sistemas');
insert into usuario (codigo, nome, tipo, curso) values (13, 'aluno 13', 'A', 'curso superior de tecnologia em analise e desenvolvimento de sistemas');
insert into usuario (codigo, nome, tipo, curso) values (14, 'aluno 14', 'A', 'curso superior de bacharelado em engenharia mecanica');
insert into usuario (codigo, nome, tipo) values (15, 'funcionario 15', 'F');
insert into usuario (codigo, nome, tipo, curso) values (16, 'aluno 16', 'A', 'curso superior de bacharelado em engenharia mecanica');
insert into usuario (codigo, nome, tipo, curso) values (17, 'aluno 17', 'A', 'curso superior de tecnologia em analise e desenvolvimento de sistemas');
insert into usuario (codigo, nome, tipo, curso) values (18, 'aluno 18', 'A', 'curso tecnico integrado em refrigeracao e ar condicionado');
insert into usuario (codigo, nome, tipo) values (19, 'professor 19', 'P');
insert into usuario (codigo, nome, tipo, curso) values (20, 'aluno 20', 'A', 'curso superior de tecnologia em analise e desenvolvimento de sistemas');
insert into usuario (codigo, nome, tipo, curso) values (21, 'aluno 21', 'A', 'curso tecnico integrado em eletrotecnica');
insert into usuario (codigo, nome, tipo, curso) values (22, 'aluno 22', 'A', 'curso tecnico integrado em refrigeracao e ar condicionado');
insert into usuario (codigo, nome, tipo, curso) values (23, 'aluno 23', 'A', 'curso tecnico integrado em eletrotecnica');
insert into usuario (codigo, nome, tipo, curso) values (24, 'aluno 24', 'A', 'curso tecnico integrado em informatica para internet');
insert into usuario (codigo, nome, tipo) values (25, 'funcionario 25', 'F');
insert into usuario (codigo, nome, tipo) values (26, 'professor 26', 'P');
insert into usuario (codigo, nome, tipo, curso) values (27, 'aluno 27', 'A', 'curso superior de bacharelado em engenharia mecanica');
insert into usuario (codigo, nome, tipo) values (28, 'funcionario 28', 'F');
insert into usuario (codigo, nome, tipo, curso) values (29, 'aluno 29', 'A', 'curso tecnico integrado em eletrotecnica');
insert into usuario (codigo, nome, tipo, curso) values (30, 'aluno 30', 'A', 'curso tecnico integrado em informatica para internet');
insert into usuario (codigo, nome, tipo) values (31, 'professor 31', 'P');
insert into usuario (codigo, nome, tipo, curso) values (32, 'aluno 32', 'A', 'curso tecnico integrado em informatica para internet');
insert into usuario (codigo, nome, tipo, curso) values (33, 'aluno 33', 'A', 'curso tecnico integrado em eletrotecnica');
insert into usuario (codigo, nome, tipo, curso) values (34, 'aluno 34', 'A', 'curso superior de bacharelado em engenharia mecanica');
insert into usuario (codigo, nome, tipo, curso) values (35, 'aluno 35', 'A', 'curso superior de bacharelado em engenharia mecanica');
insert into usuario (codigo, nome, tipo, curso) values (36, 'aluno 36', 'A', 'curso tecnico integrado em informatica para internet');
insert into usuario (codigo, nome, tipo, curso) values (37, 'aluno 37', 'A', 'curso tecnico integrado em informatica para internet');
insert into usuario (codigo, nome, tipo, curso) values (38, 'aluno 38', 'A', 'curso tecnico integrado em informatica para internet');
insert into usuario (codigo, nome, tipo, curso) values (39, 'aluno 39', 'A', 'curso tecnico integrado em refrigeracao e ar condicionado');
insert into usuario (codigo, nome, tipo, curso) values (40, 'aluno 40', 'A', 'curso tecnico integrado em eletrotecnica');
insert into usuario (codigo, nome, tipo) values (41, 'professor 41', 'P');
insert into usuario (codigo, nome, tipo, curso) values (42, 'aluno 42', 'A', 'curso tecnico integrado em refrigeracao e ar condicionado');
insert into usuario (codigo, nome, tipo, curso) values (43, 'aluno 43', 'A', 'curso tecnico integrado em informatica para internet');
insert into usuario (codigo, nome, tipo) values (44, 'funcionario 44', 'F');
insert into usuario (codigo, nome, tipo) values (45, 'funcionario 45', 'F');
insert into usuario (codigo, nome, tipo) values (46, 'funcionario 46', 'F');
insert into usuario (codigo, nome, tipo, curso) values (47, 'aluno 47', 'A', 'curso tecnico integrado em refrigeracao e ar condicionado');
insert into usuario (codigo, nome, tipo) values (48, 'professor 48', 'P');
insert into usuario (codigo, nome, tipo, curso) values (49, 'aluno 49', 'A', 'curso superior de bacharelado em engenharia mecanica');
insert into usuario (codigo, nome, tipo) values (50, 'professor 50', 'P');
insert into usuario (codigo, nome, tipo, curso) values (51, 'aluno 51', 'A', 'curso tecnico integrado em eletrotecnica');
insert into usuario (codigo, nome, tipo, curso) values (52, 'aluno 52', 'A', 'curso tecnico integrado em informatica para internet');
insert into usuario (codigo, nome, tipo, curso) values (53, 'aluno 53', 'A', 'curso tecnico integrado em eletrotecnica');
insert into usuario (codigo, nome, tipo) values (54, 'professor 54', 'P');
insert into usuario (codigo, nome, tipo, curso) values (55, 'aluno 55', 'A', 'curso tecnico integrado em informatica para internet');
insert into usuario (codigo, nome, tipo, curso) values (56, 'aluno 56', 'A', 'curso tecnico integrado em eletrotecnica');
insert into usuario (codigo, nome, tipo) values (57, 'professor 57', 'P');
insert into usuario (codigo, nome, tipo, curso) values (58, 'aluno 58', 'A', 'curso tecnico integrado em informatica para internet');
insert into usuario (codigo, nome, tipo, curso) values (59, 'aluno 59', 'A', 'curso tecnico integrado em eletrotecnica');
insert into usuario (codigo, nome, tipo) values (60, 'professor 60', 'P');
insert into usuario (codigo, nome, tipo, curso) values (61, 'aluno 61', 'A', 'curso superior de bacharelado em engenharia mecanica');
insert into usuario (codigo, nome, tipo, curso) values (62, 'aluno 62', 'A', 'curso superior de tecnologia em analise e desenvolvimento de sistemas');
insert into usuario (codigo, nome, tipo, curso) values (63, 'aluno 63', 'A', 'curso tecnico integrado em informatica para internet');
insert into usuario (codigo, nome, tipo, curso) values (64, 'aluno 64', 'A', 'curso tecnico integrado em informatica para internet');
insert into usuario (codigo, nome, tipo, curso) values (65, 'aluno 65', 'A', 'curso superior de bacharelado em engenharia mecanica');
insert into usuario (codigo, nome, tipo) values (66, 'funcionario 66', 'F');
insert into usuario (codigo, nome, tipo, curso) values (67, 'aluno 67', 'A', 'curso superior de tecnologia em analise e desenvolvimento de sistemas');
insert into usuario (codigo, nome, tipo) values (68, 'funcionario 68', 'F');
insert into usuario (codigo, nome, tipo, curso) values (69, 'aluno 69', 'A', 'curso superior de tecnologia em analise e desenvolvimento de sistemas');
insert into usuario (codigo, nome, tipo, curso) values (70, 'aluno 70', 'A', 'curso superior de bacharelado em engenharia mecanica');
insert into usuario (codigo, nome, tipo, curso) values (71, 'aluno 71', 'A', 'curso tecnico integrado em refrigeracao e ar condicionado');
insert into usuario (codigo, nome, tipo, curso) values (72, 'aluno 72', 'A', 'curso superior de bacharelado em engenharia mecanica');
insert into usuario (codigo, nome, tipo, curso) values (73, 'aluno 73', 'A', 'curso tecnico integrado em eletrotecnica');
insert into usuario (codigo, nome, tipo, curso) values (74, 'aluno 74', 'A', 'curso superior de tecnologia em analise e desenvolvimento de sistemas');
insert into usuario (codigo, nome, tipo, curso) values (75, 'aluno 75', 'A', 'curso tecnico integrado em informatica para internet');
insert into usuario (codigo, nome, tipo) values (76, 'professor 76', 'P');
insert into usuario (codigo, nome, tipo, curso) values (77, 'aluno 77', 'A', 'curso tecnico integrado em eletrotecnica');
insert into usuario (codigo, nome, tipo) values (78, 'professor 78', 'P');
insert into usuario (codigo, nome, tipo, curso) values (79, 'aluno 79', 'A', 'curso superior de bacharelado em engenharia mecanica');
insert into usuario (codigo, nome, tipo) values (80, 'funcionario 80', 'F');
insert into usuario (codigo, nome, tipo, curso) values (81, 'aluno 81', 'A', 'curso tecnico integrado em refrigeracao e ar condicionado');
insert into usuario (codigo, nome, tipo, curso) values (82, 'aluno 82', 'A', 'curso superior de tecnologia em analise e desenvolvimento de sistemas');
insert into usuario (codigo, nome, tipo, curso) values (83, 'aluno 83', 'A', 'curso tecnico integrado em informatica para internet');
insert into usuario (codigo, nome, tipo) values (84, 'professor 84', 'P');
insert into usuario (codigo, nome, tipo) values (85, 'funcionario 85', 'F');
insert into usuario (codigo, nome, tipo, curso) values (86, 'aluno 86', 'A', 'curso tecnico integrado em eletrotecnica');
insert into usuario (codigo, nome, tipo) values (87, 'funcionario 87', 'F');
insert into usuario (codigo, nome, tipo) values (88, 'funcionario 88', 'F');
insert into usuario (codigo, nome, tipo) values (89, 'professor 89', 'P');
insert into usuario (codigo, nome, tipo) values (90, 'funcionario 90', 'F');
insert into usuario (codigo, nome, tipo) values (91, 'funcionario 91', 'F');
insert into usuario (codigo, nome, tipo, curso) values (92, 'aluno 92', 'A', 'curso superior de bacharelado em engenharia mecanica');
insert into usuario (codigo, nome, tipo, curso) values (93, 'aluno 93', 'A', 'curso tecnico integrado em refrigeracao e ar condicionado');
insert into usuario (codigo, nome, tipo) values (94, 'professor 94', 'P');
insert into usuario (codigo, nome, tipo, curso) values (95, 'aluno 95', 'A', 'curso tecnico integrado em eletrotecnica');
insert into usuario (codigo, nome, tipo, curso) values (96, 'aluno 96', 'A', 'curso tecnico integrado em informatica para internet');
insert into usuario (codigo, nome, tipo, curso) values (97, 'aluno 97', 'A', 'curso tecnico integrado em informatica para internet');
insert into usuario (codigo, nome, tipo) values (98, 'funcionario 98', 'F');
insert into usuario (codigo, nome, tipo, curso) values (99, 'aluno 99', 'A', 'curso tecnico integrado em eletrotecnica');
insert into usuario (codigo, nome, tipo) values (100, 'professor 100', 'P');
insert into livro (codigo, titulo) values (1, 'postgresql na pratica');
insert into livro (codigo, titulo) values (2, 'livro 2');
insert into livro (codigo, titulo) values (3, 'livro 3');
insert into livro (codigo, titulo) values (4, 'livro 4');
insert into livro (codigo, titulo) values (5, 'xxx postgresql xxx 5');
insert into livro (codigo, titulo) values (6, 'livro 6');
insert into livro (codigo, titulo) values (7, 'livro 7');
insert into livro (codigo, titulo) values (8, 'postgresql xxx 8');
insert into livro (codigo, titulo) values (9, 'livro 9');
insert into livro (codigo, titulo) values (10, 'xxx postgresql 10');
insert into livro (codigo, titulo) values (11, 'livro 11');
insert into livro (codigo, titulo) values (12, 'livro 12');
insert into livro (codigo, titulo) values (13, 'livro 13');
insert into livro (codigo, titulo) values (14, 'livro 14');
insert into livro (codigo, titulo) values (15, 'livro 15');
insert into livro (codigo, titulo) values (16, 'livro 16');
insert into livro (codigo, titulo) values (17, 'livro 17');
insert into livro (codigo, titulo) values (18, 'livro 18');
insert into livro (codigo, titulo) values (19, 'postgresql xxx 19');
insert into livro (codigo, titulo) values (20, 'livro 20');
insert into livro (codigo, titulo) values (21, 'xxx postgresql 21');
insert into livro (codigo, titulo) values (22, 'postgresql xxx 22');
insert into livro (codigo, titulo) values (23, 'livro 23');
insert into livro (codigo, titulo) values (24, 'postgresql xxx 24');
insert into livro (codigo, titulo) values (25, 'livro 25');
insert into livro (codigo, titulo) values (26, 'livro 26');
insert into livro (codigo, titulo) values (27, 'livro 27');
insert into livro (codigo, titulo) values (28, 'livro 28');
insert into livro (codigo, titulo) values (29, 'livro 29');
insert into livro (codigo, titulo) values (30, 'livro 30');
insert into exemplar (codigo, livro) values (1001, 1);
insert into exemplar (codigo, livro) values (1002, 1);
insert into exemplar (codigo, livro) values (1003, 1);
insert into exemplar (codigo, livro) values (1004, 1);
insert into exemplar (codigo, livro) values (1005, 1);
insert into exemplar (codigo, livro) values (2001, 2);
insert into exemplar (codigo, livro) values (2002, 2);
insert into exemplar (codigo, livro) values (3001, 3);
insert into exemplar (codigo, livro) values (3002, 3);
insert into exemplar (codigo, livro) values (3003, 3);
insert into exemplar (codigo, livro) values (3004, 3);
insert into exemplar (codigo, livro) values (3005, 3);
insert into exemplar (codigo, livro) values (4001, 4);
insert into exemplar (codigo, livro) values (4002, 4);
insert into exemplar (codigo, livro) values (5001, 5);
insert into exemplar (codigo, livro) values (5002, 5);
insert into exemplar (codigo, livro) values (6001, 6);
insert into exemplar (codigo, livro) values (6002, 6);
insert into exemplar (codigo, livro) values (7001, 7);
insert into exemplar (codigo, livro) values (8001, 8);
insert into exemplar (codigo, livro) values (9001, 9);
insert into exemplar (codigo, livro) values (9002, 9);
insert into exemplar (codigo, livro) values (9003, 9);
insert into exemplar (codigo, livro) values (9004, 9);
insert into exemplar (codigo, livro) values (9005, 9);
insert into exemplar (codigo, livro) values (10001, 10);
insert into exemplar (codigo, livro) values (10002, 10);
insert into exemplar (codigo, livro) values (10003, 10);
insert into exemplar (codigo, livro) values (10004, 10);
insert into exemplar (codigo, livro) values (11001, 11);
insert into exemplar (codigo, livro) values (12001, 12);
insert into exemplar (codigo, livro) values (12002, 12);
insert into exemplar (codigo, livro) values (12003, 12);
insert into exemplar (codigo, livro) values (12004, 12);
insert into exemplar (codigo, livro) values (12005, 12);
insert into exemplar (codigo, livro) values (13001, 13);
insert into exemplar (codigo, livro) values (13002, 13);
insert into exemplar (codigo, livro) values (13003, 13);
insert into exemplar (codigo, livro) values (14001, 14);
insert into exemplar (codigo, livro) values (14002, 14);
insert into exemplar (codigo, livro) values (14003, 14);
insert into exemplar (codigo, livro) values (15001, 15);
insert into exemplar (codigo, livro) values (15002, 15);
insert into exemplar (codigo, livro) values (15003, 15);
insert into exemplar (codigo, livro) values (16001, 16);
insert into exemplar (codigo, livro) values (16002, 16);
insert into exemplar (codigo, livro) values (16003, 16);
insert into exemplar (codigo, livro) values (16004, 16);
insert into exemplar (codigo, livro) values (16005, 16);
insert into exemplar (codigo, livro) values (17001, 17);
insert into exemplar (codigo, livro) values (18001, 18);
insert into exemplar (codigo, livro) values (18002, 18);
insert into exemplar (codigo, livro) values (18003, 18);
insert into exemplar (codigo, livro) values (18004, 18);
insert into exemplar (codigo, livro) values (18005, 18);
insert into exemplar (codigo, livro) values (19001, 19);
insert into exemplar (codigo, livro) values (19002, 19);
insert into exemplar (codigo, livro) values (20001, 20);
insert into exemplar (codigo, livro) values (20002, 20);
insert into exemplar (codigo, livro) values (20003, 20);
insert into exemplar (codigo, livro) values (21001, 21);
insert into exemplar (codigo, livro) values (21002, 21);
insert into exemplar (codigo, livro) values (21003, 21);
insert into exemplar (codigo, livro) values (22001, 22);
insert into exemplar (codigo, livro) values (22002, 22);
insert into exemplar (codigo, livro) values (22003, 22);
insert into exemplar (codigo, livro) values (22004, 22);
insert into exemplar (codigo, livro) values (23001, 23);
insert into exemplar (codigo, livro) values (23002, 23);
insert into exemplar (codigo, livro) values (23003, 23);
insert into exemplar (codigo, livro) values (24001, 24);
insert into exemplar (codigo, livro) values (24002, 24);
insert into exemplar (codigo, livro) values (25001, 25);
insert into exemplar (codigo, livro) values (25002, 25);
insert into exemplar (codigo, livro) values (26001, 26);
insert into exemplar (codigo, livro) values (27001, 27);
insert into exemplar (codigo, livro) values (27002, 27);
insert into exemplar (codigo, livro) values (27003, 27);
insert into exemplar (codigo, livro) values (27004, 27);
insert into exemplar (codigo, livro) values (27005, 27);
insert into exemplar (codigo, livro) values (28001, 28);
insert into exemplar (codigo, livro) values (28002, 28);
insert into exemplar (codigo, livro) values (28003, 28);
insert into exemplar (codigo, livro) values (28004, 28);
insert into exemplar (codigo, livro) values (28005, 28);
insert into exemplar (codigo, livro) values (29001, 29);
insert into exemplar (codigo, livro) values (29002, 29);
insert into exemplar (codigo, livro) values (29003, 29);
insert into exemplar (codigo, livro) values (29004, 29);
insert into exemplar (codigo, livro) values (30001, 30);
insert into exemplar (codigo, livro) values (30002, 30);
insert into exemplar (codigo, livro) values (30003, 30);
insert into exemplar (codigo, livro) values (30004, 30);
insert into exemplar (codigo, livro) values (30005, 30);
insert into locacao (usuario, exemplar, retirada, entrega) values (46, 1001, '2018-02-27', '2018-03-02');
insert into locacao (usuario, exemplar, retirada, entrega) values (45, 1001, '2018-05-08', '2018-05-17');
insert into locacao (usuario, exemplar, retirada, entrega) values (34, 1001, '2018-06-07', '2018-06-08');
insert into locacao (usuario, exemplar, retirada, entrega) values (8, 1001, '2018-07-29', '2018-08-08');
insert into locacao (usuario, exemplar, retirada, entrega) values (27, 1001, '2018-09-06', '2018-09-17');
insert into locacao (usuario, exemplar, retirada, entrega) values (93, 1001, '2018-12-13', '2018-12-16');
insert into locacao (usuario, exemplar, retirada, entrega) values (82, 1001, '2019-01-21', '2019-01-30');
insert into locacao (usuario, exemplar, retirada, entrega) values (90, 1001, '2019-03-30', '2019-04-12');
insert into locacao (usuario, exemplar, retirada, entrega) values (31, 1002, '2018-02-17', '2018-02-20');
insert into locacao (usuario, exemplar, retirada, entrega) values (87, 1002, '2018-03-02', '2018-03-09');
insert into locacao (usuario, exemplar, retirada, entrega) values (97, 1002, '2018-05-11', '2018-05-18');
insert into locacao (usuario, exemplar, retirada, entrega) values (79, 1002, '2018-06-28', '2018-07-06');
insert into locacao (usuario, exemplar, retirada, entrega) values (1, 1002, '2018-07-10', '2018-07-14');
insert into locacao (usuario, exemplar, retirada, entrega) values (49, 1002, '2018-07-14', '2018-07-25');
insert into locacao (usuario, exemplar, retirada, entrega) values (75, 1002, '2018-07-17', '2018-07-24');
insert into locacao (usuario, exemplar, retirada, entrega) values (16, 1002, '2018-09-15', '2018-09-26');
insert into locacao (usuario, exemplar, retirada, entrega) values (44, 1002, '2018-09-17', '2018-09-23');
insert into locacao (usuario, exemplar, retirada, entrega) values (40, 1002, '2018-10-06', '2018-10-12');
insert into locacao (usuario, exemplar, retirada, entrega) values (21, 1002, '2018-12-29', '2019-01-05');
insert into locacao (usuario, exemplar, retirada, entrega) values (15, 1002, '2019-02-24', '2019-02-28');
insert into locacao (usuario, exemplar, retirada, entrega) values (44, 1003, '2018-04-06', '2018-04-14');
insert into locacao (usuario, exemplar, retirada, entrega) values (55, 1003, '2018-05-24', '2018-05-31');
insert into locacao (usuario, exemplar, retirada, entrega) values (6, 1003, '2018-08-10', '2018-08-23');
insert into locacao (usuario, exemplar, retirada, entrega) values (85, 1003, '2018-10-02', '2018-10-09');
insert into locacao (usuario, exemplar, retirada, entrega) values (48, 1003, '2018-11-10', '2018-11-14');
insert into locacao (usuario, exemplar, retirada, entrega) values (77, 1003, '2019-02-07', '2019-02-08');
insert into locacao (usuario, exemplar, retirada, entrega) values (90, 1003, '2019-03-01', '2019-03-12');
insert into locacao (usuario, exemplar, retirada, entrega) values (37, 1004, '2018-01-29', '2018-01-29');
insert into locacao (usuario, exemplar, retirada, entrega) values (88, 1004, '2018-03-09', '2018-03-17');
insert into locacao (usuario, exemplar, retirada, entrega) values (9, 1004, '2018-04-29', '2018-05-02');
insert into locacao (usuario, exemplar, retirada, entrega) values (62, 1004, '2018-08-05', '2018-08-11');
insert into locacao (usuario, exemplar, retirada, entrega) values (65, 1004, '2018-08-29', '2018-09-04');
insert into locacao (usuario, exemplar, retirada, entrega) values (29, 1004, '2018-10-06', '2018-10-19');
insert into locacao (usuario, exemplar, retirada, entrega) values (12, 1004, '2018-11-01', '2018-11-07');
insert into locacao (usuario, exemplar, retirada, entrega) values (31, 1004, '2018-11-04', '2018-11-14');
insert into locacao (usuario, exemplar, retirada, entrega) values (89, 1004, '2018-12-22', '2018-12-29');
insert into locacao (usuario, exemplar, retirada, entrega) values (100, 1004, '2019-02-22', '2019-02-23');
insert into locacao (usuario, exemplar, retirada, entrega) values (34, 1004, '2019-04-02', '2019-04-14');
insert into locacao (usuario, exemplar, retirada, entrega) values (100, 1005, '2018-02-13', '2018-02-20');
insert into locacao (usuario, exemplar, retirada, entrega) values (63, 1005, '2018-03-26', '2018-04-01');
insert into locacao (usuario, exemplar, retirada, entrega) values (95, 1005, '2018-04-09', '2018-04-11');
insert into locacao (usuario, exemplar, retirada, entrega) values (23, 1005, '2018-04-20', '2018-05-01');
insert into locacao (usuario, exemplar, retirada, entrega) values (44, 1005, '2018-06-22', '2018-06-27');
insert into locacao (usuario, exemplar, retirada, entrega) values (88, 1005, '2018-08-16', '2018-08-24');
insert into locacao (usuario, exemplar, retirada, entrega) values (74, 1005, '2018-11-02', '2018-11-02');
insert into locacao (usuario, exemplar, retirada, entrega) values (45, 1005, '2018-11-09', '2018-11-10');
insert into locacao (usuario, exemplar, retirada, entrega) values (90, 1005, '2019-01-17', '2019-01-23');
insert into locacao (usuario, exemplar, retirada, entrega) values (55, 1005, '2019-02-11', '2019-02-19');
insert into locacao (usuario, exemplar, retirada, entrega) values (30, 2001, '2018-03-31', '2018-04-02');
insert into locacao (usuario, exemplar, retirada, entrega) values (18, 2001, '2018-05-26', '2018-06-03');
insert into locacao (usuario, exemplar, retirada, entrega) values (41, 2001, '2018-07-10', '2018-07-17');
insert into locacao (usuario, exemplar, retirada, entrega) values (16, 2001, '2018-08-05', '2018-08-11');
insert into locacao (usuario, exemplar, retirada, entrega) values (93, 2001, '2018-10-13', '2018-10-15');
insert into locacao (usuario, exemplar, retirada, entrega) values (68, 2001, '2018-12-11', '2018-12-14');
insert into locacao (usuario, exemplar, retirada, entrega) values (81, 2001, '2019-02-13', '2019-02-26');
insert into locacao (usuario, exemplar, retirada, entrega) values (15, 2002, '2018-03-07', '2018-03-15');
insert into locacao (usuario, exemplar, retirada, entrega) values (50, 2002, '2018-03-18', '2018-03-31');
insert into locacao (usuario, exemplar, retirada, entrega) values (100, 2002, '2018-06-10', '2018-06-22');
insert into locacao (usuario, exemplar, retirada, entrega) values (92, 2002, '2018-06-13', '2018-06-14');
insert into locacao (usuario, exemplar, retirada, entrega) values (91, 2002, '2018-08-30', '2018-09-02');
insert into locacao (usuario, exemplar, retirada, entrega) values (33, 2002, '2018-09-08', '2018-09-15');
insert into locacao (usuario, exemplar, retirada, entrega) values (82, 2002, '2018-10-23', '2018-10-24');
insert into locacao (usuario, exemplar, retirada, entrega) values (94, 2002, '2019-01-19', '2019-01-23');
insert into locacao (usuario, exemplar, retirada, entrega) values (55, 2002, '2019-03-17', '2019-03-29');
insert into locacao (usuario, exemplar, retirada, entrega) values (6, 2002, '2019-03-21', '2019-03-25');
insert into locacao (usuario, exemplar, retirada, entrega) values (76, 3001, '2018-04-08', '2018-04-21');
insert into locacao (usuario, exemplar, retirada, entrega) values (46, 3001, '2018-05-04', '2018-05-12');
insert into locacao (usuario, exemplar, retirada, entrega) values (41, 3001, '2018-06-14', '2018-06-20');
insert into locacao (usuario, exemplar, retirada, entrega) values (4, 3001, '2018-07-16', '2018-07-29');
insert into locacao (usuario, exemplar, retirada, entrega) values (98, 3001, '2018-08-31', '2018-09-03');
insert into locacao (usuario, exemplar, retirada, entrega) values (9, 3001, '2018-11-13', '2018-11-20');
insert into locacao (usuario, exemplar, retirada, entrega) values (11, 3001, '2018-11-21', '2018-11-22');
insert into locacao (usuario, exemplar, retirada, entrega) values (69, 3001, '2018-11-28', '2018-12-01');
insert into locacao (usuario, exemplar, retirada, entrega) values (87, 3001, '2019-03-03', '2019-03-05');
insert into locacao (usuario, exemplar, retirada, entrega) values (75, 3001, '2019-03-13', '2019-03-25');
insert into locacao (usuario, exemplar, retirada, entrega) values (62, 3001, '2019-04-27', '2019-05-09');
insert into locacao (usuario, exemplar, retirada, entrega) values (89, 3002, '2018-01-22', '2018-02-03');
insert into locacao (usuario, exemplar, retirada, entrega) values (44, 3002, '2018-03-06', '2018-03-12');
insert into locacao (usuario, exemplar, retirada, entrega) values (80, 3002, '2018-03-25', '2018-04-06');
insert into locacao (usuario, exemplar, retirada, entrega) values (41, 3002, '2018-04-05', '2018-04-11');
insert into locacao (usuario, exemplar, retirada, entrega) values (1, 3002, '2018-04-13', '2018-04-23');
insert into locacao (usuario, exemplar, retirada, entrega) values (41, 3002, '2018-05-09', '2018-05-18');
insert into locacao (usuario, exemplar, retirada, entrega) values (92, 3002, '2018-05-22', '2018-05-23');
insert into locacao (usuario, exemplar, retirada, entrega) values (40, 3002, '2018-07-12', '2018-07-17');
insert into locacao (usuario, exemplar, retirada, entrega) values (21, 3002, '2018-08-15', '2018-08-20');
insert into locacao (usuario, exemplar, retirada, entrega) values (93, 3002, '2018-10-09', '2018-10-15');
insert into locacao (usuario, exemplar, retirada, entrega) values (2, 3002, '2019-01-07', '2019-01-20');
insert into locacao (usuario, exemplar, retirada, entrega) values (42, 3002, '2019-02-25', '2019-02-25');
insert into locacao (usuario, exemplar, retirada, entrega) values (33, 3002, '2019-04-03', '2019-04-06');
insert into locacao (usuario, exemplar, retirada, entrega) values (15, 3003, '2018-02-05', '2018-02-10');
insert into locacao (usuario, exemplar, retirada, entrega) values (23, 3003, '2018-04-10', '2018-04-14');
insert into locacao (usuario, exemplar, retirada, entrega) values (33, 3003, '2018-06-13', '2018-06-22');
insert into locacao (usuario, exemplar, retirada, entrega) values (40, 3003, '2018-09-19', '2018-09-26');
insert into locacao (usuario, exemplar, retirada, entrega) values (1, 3003, '2018-12-02', '2018-12-09');
insert into locacao (usuario, exemplar, retirada, entrega) values (62, 3003, '2019-02-01', '2019-02-08');
insert into locacao (usuario, exemplar, retirada, entrega) values (36, 3003, '2019-04-26', '2019-04-27');
insert into locacao (usuario, exemplar, retirada, entrega) values (76, 3004, '2018-03-14', '2018-03-17');
insert into locacao (usuario, exemplar, retirada, entrega) values (39, 3004, '2018-05-09', '2018-05-15');
insert into locacao (usuario, exemplar, retirada, entrega) values (56, 3004, '2018-07-13', '2018-07-25');
insert into locacao (usuario, exemplar, retirada, entrega) values (13, 3004, '2018-08-31', '2018-09-09');
insert into locacao (usuario, exemplar, retirada, entrega) values (13, 3004, '2018-11-14', '2018-11-17');
insert into locacao (usuario, exemplar, retirada, entrega) values (42, 3004, '2018-12-22', '2019-01-03');
insert into locacao (usuario, exemplar, retirada, entrega) values (95, 3004, '2018-12-22', '2019-01-01');
insert into locacao (usuario, exemplar, retirada, entrega) values (83, 3004, '2019-02-20', '2019-02-21');
insert into locacao (usuario, exemplar, retirada, entrega) values (4, 3004, '2019-04-30', '2019-05-06');
insert into locacao (usuario, exemplar, retirada, entrega) values (2, 3005, '2018-04-04', '2018-04-05');
insert into locacao (usuario, exemplar, retirada, entrega) values (64, 3005, '2018-07-02', '2018-07-07');
insert into locacao (usuario, exemplar, retirada, entrega) values (62, 3005, '2018-10-07', '2018-10-15');
insert into locacao (usuario, exemplar, retirada, entrega) values (66, 3005, '2018-11-18', '2018-11-22');
insert into locacao (usuario, exemplar, retirada, entrega) values (84, 3005, '2019-01-25', '2019-01-27');
insert into locacao (usuario, exemplar, retirada, entrega) values (54, 3005, '2019-04-26', '2019-05-05');
insert into locacao (usuario, exemplar, retirada, entrega) values (85, 4001, '2018-01-19', '2018-01-27');
insert into locacao (usuario, exemplar, retirada, entrega) values (57, 4001, '2018-02-18', '2018-02-21');
insert into locacao (usuario, exemplar, retirada, entrega) values (49, 4001, '2018-03-06', '2018-03-14');
insert into locacao (usuario, exemplar, retirada, entrega) values (12, 4001, '2018-04-15', '2018-04-27');
insert into locacao (usuario, exemplar, retirada, entrega) values (16, 4001, '2018-05-03', '2018-05-15');
insert into locacao (usuario, exemplar, retirada, entrega) values (64, 4001, '2018-05-27', '2018-06-07');
insert into locacao (usuario, exemplar, retirada, entrega) values (10, 4001, '2018-07-02', '2018-07-14');
insert into locacao (usuario, exemplar, retirada, entrega) values (67, 4001, '2018-09-18', '2018-09-21');
insert into locacao (usuario, exemplar, retirada, entrega) values (60, 4001, '2018-09-22', '2018-09-26');
insert into locacao (usuario, exemplar, retirada, entrega) values (52, 4001, '2018-10-23', '2018-10-28');
insert into locacao (usuario, exemplar, retirada, entrega) values (58, 4001, '2018-10-30', '2018-11-06');
insert into locacao (usuario, exemplar, retirada, entrega) values (3, 4001, '2018-11-27', '2018-11-27');
insert into locacao (usuario, exemplar, retirada, entrega) values (91, 4001, '2019-01-30', '2019-01-31');
insert into locacao (usuario, exemplar, retirada, entrega) values (97, 4001, '2019-02-10', '2019-02-12');
insert into locacao (usuario, exemplar, retirada, entrega) values (57, 4002, '2018-01-05', '2018-01-08');
insert into locacao (usuario, exemplar, retirada, entrega) values (91, 4002, '2018-01-30', '2018-02-05');
insert into locacao (usuario, exemplar, retirada, entrega) values (60, 4002, '2018-03-30', '2018-03-30');
insert into locacao (usuario, exemplar, retirada, entrega) values (87, 4002, '2018-04-30', '2018-05-12');
insert into locacao (usuario, exemplar, retirada, entrega) values (32, 4002, '2018-06-11', '2018-06-17');
insert into locacao (usuario, exemplar, retirada, entrega) values (33, 4002, '2018-08-26', '2018-09-06');
insert into locacao (usuario, exemplar, retirada, entrega) values (9, 4002, '2018-11-07', '2018-11-20');
insert into locacao (usuario, exemplar, retirada, entrega) values (74, 4002, '2019-02-12', '2019-02-13');
insert into locacao (usuario, exemplar, retirada, entrega) values (56, 4002, '2019-04-30', '2019-04-30');
insert into locacao (usuario, exemplar, retirada, entrega) values (88, 5001, '2018-01-06', '2018-01-14');
insert into locacao (usuario, exemplar, retirada, entrega) values (80, 5001, '2018-02-14', '2018-02-17');
insert into locacao (usuario, exemplar, retirada, entrega) values (86, 5001, '2018-05-21', '2018-05-23');
insert into locacao (usuario, exemplar, retirada, entrega) values (62, 5001, '2018-06-14', '2018-06-18');
insert into locacao (usuario, exemplar, retirada, entrega) values (7, 5001, '2018-07-20', '2018-07-22');
insert into locacao (usuario, exemplar, retirada, entrega) values (86, 5001, '2018-10-06', '2018-10-12');
insert into locacao (usuario, exemplar, retirada, entrega) values (12, 5001, '2018-11-17', '2018-11-24');
insert into locacao (usuario, exemplar, retirada, entrega) values (97, 5001, '2019-02-13', '2019-02-16');
insert into locacao (usuario, exemplar, retirada, entrega) values (56, 5001, '2019-04-21', '2019-04-26');
insert into locacao (usuario, exemplar, retirada, entrega) values (31, 5002, '2018-01-26', '2018-01-30');
insert into locacao (usuario, exemplar, retirada, entrega) values (93, 5002, '2018-04-11', '2018-04-19');
insert into locacao (usuario, exemplar, retirada, entrega) values (100, 5002, '2018-07-13', '2018-07-22');
insert into locacao (usuario, exemplar, retirada, entrega) values (28, 5002, '2018-09-09', '2018-09-11');
insert into locacao (usuario, exemplar, retirada, entrega) values (7, 5002, '2018-12-10', '2018-12-10');
insert into locacao (usuario, exemplar, retirada, entrega) values (61, 5002, '2019-02-14', '2019-02-18');
insert into locacao (usuario, exemplar, retirada, entrega) values (5, 5002, '2019-04-24', '2019-05-01');
insert into locacao (usuario, exemplar, retirada, entrega) values (13, 6001, '2018-03-15', '2018-03-26');
insert into locacao (usuario, exemplar, retirada, entrega) values (58, 6001, '2018-04-22', '2018-04-30');
insert into locacao (usuario, exemplar, retirada, entrega) values (6, 6001, '2018-05-13', '2018-05-25');
insert into locacao (usuario, exemplar, retirada, entrega) values (95, 6001, '2018-06-03', '2018-06-09');
insert into locacao (usuario, exemplar, retirada, entrega) values (83, 6001, '2018-06-09', '2018-06-20');
insert into locacao (usuario, exemplar, retirada, entrega) values (93, 6001, '2018-07-17', '2018-07-25');
insert into locacao (usuario, exemplar, retirada, entrega) values (55, 6001, '2018-07-25', '2018-07-27');
insert into locacao (usuario, exemplar, retirada, entrega) values (39, 6001, '2018-09-04', '2018-09-09');
insert into locacao (usuario, exemplar, retirada, entrega) values (74, 6001, '2018-11-25', '2018-12-07');
insert into locacao (usuario, exemplar, retirada, entrega) values (54, 6001, '2019-02-09', '2019-02-09');
insert into locacao (usuario, exemplar, retirada, entrega) values (31, 6001, '2019-02-22', '2019-03-04');
insert into locacao (usuario, exemplar, retirada, entrega) values (81, 6001, '2019-03-11', '2019-03-12');
insert into locacao (usuario, exemplar, retirada, entrega) values (3, 6002, '2018-03-23', '2018-03-31');
insert into locacao (usuario, exemplar, retirada, entrega) values (65, 6002, '2018-05-25', '2018-06-04');
insert into locacao (usuario, exemplar, retirada, entrega) values (5, 6002, '2018-08-15', '2018-08-17');
insert into locacao (usuario, exemplar, retirada, entrega) values (13, 6002, '2018-10-02', '2018-10-12');
insert into locacao (usuario, exemplar, retirada, entrega) values (49, 6002, '2018-12-29', '2019-01-03');
insert into locacao (usuario, exemplar, retirada, entrega) values (97, 6002, '2019-01-23', '2019-02-05');
insert into locacao (usuario, exemplar, retirada, entrega) values (24, 6002, '2019-04-22', '2019-05-01');
insert into locacao (usuario, exemplar, retirada, entrega) values (10, 7001, '2018-02-22', '2018-02-26');
insert into locacao (usuario, exemplar, retirada, entrega) values (98, 7001, '2018-04-22', '2018-04-24');
insert into locacao (usuario, exemplar, retirada, entrega) values (12, 7001, '2018-06-27', '2018-07-08');
insert into locacao (usuario, exemplar, retirada, entrega) values (5, 7001, '2018-09-15', '2018-09-21');
insert into locacao (usuario, exemplar, retirada, entrega) values (78, 7001, '2018-10-17', '2018-10-23');
insert into locacao (usuario, exemplar, retirada, entrega) values (10, 7001, '2018-10-19', '2018-10-28');
insert into locacao (usuario, exemplar, retirada, entrega) values (97, 7001, '2018-11-28', '2018-12-10');
insert into locacao (usuario, exemplar, retirada, entrega) values (49, 7001, '2019-01-11', '2019-01-16');
insert into locacao (usuario, exemplar, retirada, entrega) values (67, 7001, '2019-03-30', '2019-04-07');
insert into locacao (usuario, exemplar, retirada, entrega) values (45, 8001, '2018-01-25', '2018-01-29');
insert into locacao (usuario, exemplar, retirada, entrega) values (21, 8001, '2018-03-06', '2018-03-07');
insert into locacao (usuario, exemplar, retirada, entrega) values (99, 8001, '2018-03-10', '2018-03-19');
insert into locacao (usuario, exemplar, retirada, entrega) values (40, 8001, '2018-04-14', '2018-04-22');
insert into locacao (usuario, exemplar, retirada, entrega) values (13, 8001, '2018-06-04', '2018-06-06');
insert into locacao (usuario, exemplar, retirada, entrega) values (64, 8001, '2018-06-13', '2018-06-20');
insert into locacao (usuario, exemplar, retirada, entrega) values (4, 8001, '2018-06-30', '2018-06-30');
insert into locacao (usuario, exemplar, retirada, entrega) values (46, 8001, '2018-10-01', '2018-10-02');
insert into locacao (usuario, exemplar, retirada, entrega) values (71, 8001, '2018-10-28', '2018-11-05');
insert into locacao (usuario, exemplar, retirada, entrega) values (27, 8001, '2018-10-31', '2018-11-05');
insert into locacao (usuario, exemplar, retirada, entrega) values (57, 8001, '2018-11-28', '2018-12-10');
insert into locacao (usuario, exemplar, retirada, entrega) values (41, 8001, '2019-02-25', '2019-03-01');
insert into locacao (usuario, exemplar, retirada, entrega) values (61, 9001, '2018-03-26', '2018-04-07');
insert into locacao (usuario, exemplar, retirada, entrega) values (13, 9001, '2018-04-28', '2018-05-10');
insert into locacao (usuario, exemplar, retirada, entrega) values (69, 9001, '2018-06-28', '2018-07-10');
insert into locacao (usuario, exemplar, retirada, entrega) values (26, 9001, '2018-08-26', '2018-09-08');
insert into locacao (usuario, exemplar, retirada, entrega) values (89, 9001, '2018-11-15', '2018-11-28');
insert into locacao (usuario, exemplar, retirada, entrega) values (76, 9001, '2018-12-29', '2019-01-05');
insert into locacao (usuario, exemplar, retirada, entrega) values (14, 9001, '2019-02-03', '2019-02-09');
insert into locacao (usuario, exemplar, retirada, entrega) values (9, 9002, '2018-01-04', '2018-01-08');
insert into locacao (usuario, exemplar, retirada, entrega) values (84, 9002, '2018-02-09', '2018-02-18');
insert into locacao (usuario, exemplar, retirada, entrega) values (86, 9002, '2018-03-16', '2018-03-28');
insert into locacao (usuario, exemplar, retirada, entrega) values (23, 9002, '2018-06-17', '2018-06-28');
insert into locacao (usuario, exemplar, retirada, entrega) values (47, 9002, '2018-07-11', '2018-07-11');
insert into locacao (usuario, exemplar, retirada, entrega) values (73, 9002, '2018-09-17', '2018-09-22');
insert into locacao (usuario, exemplar, retirada, entrega) values (75, 9002, '2018-10-01', '2018-10-06');
insert into locacao (usuario, exemplar, retirada, entrega) values (40, 9002, '2018-12-27', '2018-12-29');
insert into locacao (usuario, exemplar, retirada, entrega) values (12, 9002, '2019-03-17', '2019-03-18');
insert into locacao (usuario, exemplar, retirada, entrega) values (90, 9003, '2018-03-29', '2018-03-29');
insert into locacao (usuario, exemplar, retirada, entrega) values (29, 9003, '2018-06-10', '2018-06-10');
insert into locacao (usuario, exemplar, retirada, entrega) values (83, 9003, '2018-06-20', '2018-06-22');
insert into locacao (usuario, exemplar, retirada, entrega) values (29, 9003, '2018-07-20', '2018-07-27');
insert into locacao (usuario, exemplar, retirada, entrega) values (39, 9003, '2018-10-25', '2018-11-03');
insert into locacao (usuario, exemplar, retirada, entrega) values (46, 9003, '2019-01-10', '2019-01-16');
insert into locacao (usuario, exemplar, retirada, entrega) values (51, 9003, '2019-04-06', '2019-04-19');
insert into locacao (usuario, exemplar, retirada, entrega) values (74, 9004, '2018-01-27', '2018-01-31');
insert into locacao (usuario, exemplar, retirada, entrega) values (3, 9004, '2018-04-01', '2018-04-08');
insert into locacao (usuario, exemplar, retirada, entrega) values (65, 9004, '2018-04-09', '2018-04-18');
insert into locacao (usuario, exemplar, retirada, entrega) values (49, 9004, '2018-05-26', '2018-05-26');
insert into locacao (usuario, exemplar, retirada, entrega) values (5, 9004, '2018-07-07', '2018-07-12');
insert into locacao (usuario, exemplar, retirada, entrega) values (38, 9004, '2018-10-08', '2018-10-14');
insert into locacao (usuario, exemplar, retirada, entrega) values (95, 9004, '2019-01-10', '2019-01-19');
insert into locacao (usuario, exemplar, retirada, entrega) values (14, 9004, '2019-02-12', '2019-02-24');
insert into locacao (usuario, exemplar, retirada, entrega) values (27, 9004, '2019-04-15', '2019-04-27');
insert into locacao (usuario, exemplar, retirada, entrega) values (15, 9005, '2018-01-02', '2018-01-06');
insert into locacao (usuario, exemplar, retirada, entrega) values (28, 9005, '2018-01-13', '2018-01-21');
insert into locacao (usuario, exemplar, retirada, entrega) values (3, 9005, '2018-03-13', '2018-03-24');
insert into locacao (usuario, exemplar, retirada, entrega) values (41, 9005, '2018-04-15', '2018-04-28');
insert into locacao (usuario, exemplar, retirada, entrega) values (69, 9005, '2018-05-01', '2018-05-09');
insert into locacao (usuario, exemplar, retirada, entrega) values (35, 9005, '2018-06-11', '2018-06-20');
insert into locacao (usuario, exemplar, retirada, entrega) values (85, 9005, '2018-09-16', '2018-09-16');
insert into locacao (usuario, exemplar, retirada, entrega) values (21, 9005, '2018-10-28', '2018-11-06');
insert into locacao (usuario, exemplar, retirada, entrega) values (10, 9005, '2019-01-20', '2019-02-02');
insert into locacao (usuario, exemplar, retirada, entrega) values (89, 9005, '2019-02-23', '2019-03-07');
insert into locacao (usuario, exemplar, retirada, entrega) values (54, 9005, '2019-04-12', '2019-04-15');
insert into locacao (usuario, exemplar, retirada, entrega) values (99, 10001, '2018-01-14', '2018-01-26');
insert into locacao (usuario, exemplar, retirada, entrega) values (63, 10001, '2018-03-25', '2018-04-05');
insert into locacao (usuario, exemplar, retirada, entrega) values (15, 10001, '2018-05-16', '2018-05-25');
insert into locacao (usuario, exemplar, retirada, entrega) values (15, 10001, '2018-07-25', '2018-07-26');
insert into locacao (usuario, exemplar, retirada, entrega) values (32, 10001, '2018-10-17', '2018-10-25');
insert into locacao (usuario, exemplar, retirada, entrega) values (77, 10001, '2018-11-13', '2018-11-17');
insert into locacao (usuario, exemplar, retirada, entrega) values (19, 10001, '2019-01-08', '2019-01-09');
insert into locacao (usuario, exemplar, retirada, entrega) values (64, 10001, '2019-02-04', '2019-02-10');
insert into locacao (usuario, exemplar, retirada, entrega) values (8, 10001, '2019-03-19', '2019-03-22');
insert into locacao (usuario, exemplar, retirada, entrega) values (47, 10001, '2019-04-30', '2019-05-03');
insert into locacao (usuario, exemplar, retirada, entrega) values (17, 10002, '2018-04-07', '2018-04-18');
insert into locacao (usuario, exemplar, retirada, entrega) values (88, 10002, '2018-07-04', '2018-07-15');
insert into locacao (usuario, exemplar, retirada, entrega) values (18, 10002, '2018-08-04', '2018-08-15');
insert into locacao (usuario, exemplar, retirada, entrega) values (67, 10002, '2018-09-14', '2018-09-24');
insert into locacao (usuario, exemplar, retirada, entrega) values (39, 10002, '2018-09-25', '2018-09-26');
insert into locacao (usuario, exemplar, retirada, entrega) values (28, 10002, '2018-11-19', '2018-11-23');
insert into locacao (usuario, exemplar, retirada, entrega) values (91, 10002, '2019-01-24', '2019-01-27');
insert into locacao (usuario, exemplar, retirada, entrega) values (22, 10002, '2019-03-26', '2019-04-08');
insert into locacao (usuario, exemplar, retirada, entrega) values (27, 10002, '2019-04-06', '2019-04-12');
insert into locacao (usuario, exemplar, retirada, entrega) values (69, 10003, '2018-01-23', '2018-01-24');
insert into locacao (usuario, exemplar, retirada, entrega) values (61, 10003, '2018-02-09', '2018-02-16');
insert into locacao (usuario, exemplar, retirada, entrega) values (80, 10003, '2018-04-05', '2018-04-09');
insert into locacao (usuario, exemplar, retirada, entrega) values (68, 10003, '2018-04-16', '2018-04-17');
insert into locacao (usuario, exemplar, retirada, entrega) values (58, 10003, '2018-04-29', '2018-05-10');
insert into locacao (usuario, exemplar, retirada, entrega) values (16, 10003, '2018-06-12', '2018-06-21');
insert into locacao (usuario, exemplar, retirada, entrega) values (81, 10003, '2018-07-13', '2018-07-20');
insert into locacao (usuario, exemplar, retirada, entrega) values (25, 10003, '2018-09-22', '2018-09-26');
insert into locacao (usuario, exemplar, retirada, entrega) values (87, 10003, '2018-10-28', '2018-10-31');
insert into locacao (usuario, exemplar, retirada, entrega) values (63, 10003, '2018-11-24', '2018-12-03');
insert into locacao (usuario, exemplar, retirada, entrega) values (48, 10003, '2018-12-04', '2018-12-04');
insert into locacao (usuario, exemplar, retirada, entrega) values (27, 10003, '2019-02-27', '2019-03-10');
insert into locacao (usuario, exemplar, retirada, entrega) values (2, 10003, '2019-03-17', '2019-03-18');
insert into locacao (usuario, exemplar, retirada, entrega) values (96, 10003, '2019-04-25', '2019-04-28');
insert into locacao (usuario, exemplar, retirada, entrega) values (85, 10004, '2018-02-21', '2018-02-24');
insert into locacao (usuario, exemplar, retirada, entrega) values (67, 10004, '2018-05-15', '2018-05-21');
insert into locacao (usuario, exemplar, retirada, entrega) values (53, 10004, '2018-08-09', '2018-08-09');
insert into locacao (usuario, exemplar, retirada, entrega) values (3, 10004, '2018-10-13', '2018-10-17');
insert into locacao (usuario, exemplar, retirada, entrega) values (70, 10004, '2018-11-18', '2018-11-23');
insert into locacao (usuario, exemplar, retirada, entrega) values (99, 10004, '2019-02-15', '2019-02-21');
insert into locacao (usuario, exemplar, retirada, entrega) values (7, 10004, '2019-03-10', '2019-03-19');
insert into locacao (usuario, exemplar, retirada, entrega) values (32, 11001, '2018-01-11', '2018-01-21');
insert into locacao (usuario, exemplar, retirada, entrega) values (79, 11001, '2018-02-05', '2018-02-11');
insert into locacao (usuario, exemplar, retirada, entrega) values (34, 11001, '2018-02-21', '2018-02-25');
insert into locacao (usuario, exemplar, retirada, entrega) values (73, 11001, '2018-04-27', '2018-05-09');
insert into locacao (usuario, exemplar, retirada, entrega) values (7, 11001, '2018-04-29', '2018-05-10');
insert into locacao (usuario, exemplar, retirada, entrega) values (17, 11001, '2018-05-22', '2018-05-28');
insert into locacao (usuario, exemplar, retirada, entrega) values (55, 11001, '2018-08-16', '2018-08-28');
insert into locacao (usuario, exemplar, retirada, entrega) values (93, 11001, '2018-09-01', '2018-09-11');
insert into locacao (usuario, exemplar, retirada, entrega) values (4, 11001, '2018-09-06', '2018-09-06');
insert into locacao (usuario, exemplar, retirada, entrega) values (40, 11001, '2018-11-22', '2018-12-04');
insert into locacao (usuario, exemplar, retirada, entrega) values (81, 11001, '2018-12-04', '2018-12-04');
insert into locacao (usuario, exemplar, retirada, entrega) values (43, 11001, '2019-01-26', '2019-02-01');
insert into locacao (usuario, exemplar, retirada, entrega) values (51, 11001, '2019-02-10', '2019-02-21');
insert into locacao (usuario, exemplar, retirada, entrega) values (29, 11001, '2019-03-31', '2019-04-04');
insert into locacao (usuario, exemplar, retirada, entrega) values (85, 12001, '2018-03-09', '2018-03-14');
insert into locacao (usuario, exemplar, retirada, entrega) values (63, 12001, '2018-06-09', '2018-06-16');
insert into locacao (usuario, exemplar, retirada, entrega) values (69, 12001, '2018-06-28', '2018-07-02');
insert into locacao (usuario, exemplar, retirada, entrega) values (35, 12001, '2018-08-14', '2018-08-22');
insert into locacao (usuario, exemplar, retirada, entrega) values (20, 12001, '2018-08-14', '2018-08-19');
insert into locacao (usuario, exemplar, retirada, entrega) values (86, 12001, '2018-10-25', '2018-10-28');
insert into locacao (usuario, exemplar, retirada, entrega) values (29, 12001, '2018-11-11', '2018-11-18');
insert into locacao (usuario, exemplar, retirada, entrega) values (10, 12001, '2019-01-23', '2019-02-04');
insert into locacao (usuario, exemplar, retirada, entrega) values (89, 12001, '2019-04-23', '2019-04-30');
insert into locacao (usuario, exemplar, retirada, entrega) values (81, 12002, '2018-04-01', '2018-04-03');
insert into locacao (usuario, exemplar, retirada, entrega) values (64, 12002, '2018-06-25', '2018-07-07');
insert into locacao (usuario, exemplar, retirada, entrega) values (11, 12002, '2018-08-27', '2018-08-31');
insert into locacao (usuario, exemplar, retirada, entrega) values (24, 12002, '2018-10-14', '2018-10-20');
insert into locacao (usuario, exemplar, retirada, entrega) values (10, 12002, '2018-11-09', '2018-11-13');
insert into locacao (usuario, exemplar, retirada, entrega) values (80, 12002, '2018-12-30', '2018-12-31');
insert into locacao (usuario, exemplar, retirada, entrega) values (38, 12002, '2019-03-14', '2019-03-21');
insert into locacao (usuario, exemplar, retirada, entrega) values (3, 12002, '2019-04-10', '2019-04-18');
insert into locacao (usuario, exemplar, retirada, entrega) values (38, 12003, '2018-01-22', '2018-01-31');
insert into locacao (usuario, exemplar, retirada, entrega) values (7, 12003, '2018-04-06', '2018-04-19');
insert into locacao (usuario, exemplar, retirada, entrega) values (60, 12003, '2018-05-05', '2018-05-14');
insert into locacao (usuario, exemplar, retirada, entrega) values (56, 12003, '2018-06-21', '2018-06-22');
insert into locacao (usuario, exemplar, retirada, entrega) values (60, 12003, '2018-09-17', '2018-09-20');
insert into locacao (usuario, exemplar, retirada, entrega) values (82, 12003, '2018-12-16', '2018-12-20');
insert into locacao (usuario, exemplar, retirada, entrega) values (72, 12003, '2019-02-06', '2019-02-12');
insert into locacao (usuario, exemplar, retirada, entrega) values (13, 12003, '2019-03-22', '2019-03-29');
insert into locacao (usuario, exemplar, retirada, entrega) values (31, 12004, '2018-04-08', '2018-04-19');
insert into locacao (usuario, exemplar, retirada, entrega) values (90, 12004, '2018-04-10', '2018-04-19');
insert into locacao (usuario, exemplar, retirada, entrega) values (27, 12004, '2018-05-11', '2018-05-17');
insert into locacao (usuario, exemplar, retirada, entrega) values (70, 12004, '2018-06-07', '2018-06-09');
insert into locacao (usuario, exemplar, retirada, entrega) values (40, 12004, '2018-08-02', '2018-08-12');
insert into locacao (usuario, exemplar, retirada, entrega) values (63, 12004, '2018-08-15', '2018-08-26');
insert into locacao (usuario, exemplar, retirada, entrega) values (1, 12004, '2018-10-03', '2018-10-12');
insert into locacao (usuario, exemplar, retirada, entrega) values (77, 12004, '2018-12-27', '2019-01-05');
insert into locacao (usuario, exemplar, retirada, entrega) values (40, 12004, '2019-03-04', '2019-03-07');
insert into locacao (usuario, exemplar, retirada, entrega) values (7, 12004, '2019-03-19', '2019-03-25');
insert into locacao (usuario, exemplar, retirada, entrega) values (79, 12005, '2018-04-03', '2018-04-14');
insert into locacao (usuario, exemplar, retirada, entrega) values (10, 12005, '2018-04-15', '2018-04-24');
insert into locacao (usuario, exemplar, retirada, entrega) values (77, 12005, '2018-04-15', '2018-04-22');
insert into locacao (usuario, exemplar, retirada, entrega) values (37, 12005, '2018-07-03', '2018-07-11');
insert into locacao (usuario, exemplar, retirada, entrega) values (79, 12005, '2018-09-04', '2018-09-07');
insert into locacao (usuario, exemplar, retirada, entrega) values (74, 12005, '2018-09-27', '2018-10-03');
insert into locacao (usuario, exemplar, retirada, entrega) values (65, 12005, '2019-01-02', '2019-01-02');
insert into locacao (usuario, exemplar, retirada, entrega) values (79, 12005, '2019-01-24', '2019-01-31');
insert into locacao (usuario, exemplar, retirada, entrega) values (84, 12005, '2019-03-13', '2019-03-26');
insert into locacao (usuario, exemplar, retirada, entrega) values (65, 13001, '2018-01-19', '2018-01-22');
insert into locacao (usuario, exemplar, retirada, entrega) values (99, 13001, '2018-02-03', '2018-02-14');
insert into locacao (usuario, exemplar, retirada, entrega) values (61, 13001, '2018-03-29', '2018-04-09');
insert into locacao (usuario, exemplar, retirada, entrega) values (3, 13001, '2018-06-28', '2018-06-30');
insert into locacao (usuario, exemplar, retirada, entrega) values (34, 13001, '2018-09-04', '2018-09-06');
insert into locacao (usuario, exemplar, retirada, entrega) values (5, 13001, '2018-10-22', '2018-11-02');
insert into locacao (usuario, exemplar, retirada, entrega) values (48, 13001, '2018-12-29', '2019-01-02');
insert into locacao (usuario, exemplar, retirada, entrega) values (93, 13001, '2019-01-13', '2019-01-21');
insert into locacao (usuario, exemplar, retirada, entrega) values (13, 13001, '2019-02-08', '2019-02-20');
insert into locacao (usuario, exemplar, retirada, entrega) values (66, 13001, '2019-03-13', '2019-03-22');
insert into locacao (usuario, exemplar, retirada, entrega) values (26, 13001, '2019-04-15', '2019-04-25');
insert into locacao (usuario, exemplar, retirada, entrega) values (23, 13002, '2018-04-03', '2018-04-13');
insert into locacao (usuario, exemplar, retirada, entrega) values (96, 13002, '2018-06-03', '2018-06-05');
insert into locacao (usuario, exemplar, retirada, entrega) values (1, 13002, '2018-06-17', '2018-06-22');
insert into locacao (usuario, exemplar, retirada, entrega) values (98, 13002, '2018-08-16', '2018-08-26');
insert into locacao (usuario, exemplar, retirada, entrega) values (43, 13002, '2018-08-24', '2018-08-24');
insert into locacao (usuario, exemplar, retirada, entrega) values (59, 13002, '2018-11-01', '2018-11-06');
insert into locacao (usuario, exemplar, retirada, entrega) values (96, 13002, '2018-11-16', '2018-11-29');
insert into locacao (usuario, exemplar, retirada, entrega) values (62, 13002, '2019-01-16', '2019-01-18');
insert into locacao (usuario, exemplar, retirada, entrega) values (37, 13002, '2019-03-27', '2019-03-31');
insert into locacao (usuario, exemplar, retirada, entrega) values (18, 13002, '2019-04-08', '2019-04-12');
insert into locacao (usuario, exemplar, retirada, entrega) values (28, 13003, '2018-03-14', '2018-03-16');
insert into locacao (usuario, exemplar, retirada, entrega) values (4, 13003, '2018-03-18', '2018-03-29');
insert into locacao (usuario, exemplar, retirada, entrega) values (14, 13003, '2018-04-13', '2018-04-13');
insert into locacao (usuario, exemplar, retirada, entrega) values (61, 13003, '2018-05-04', '2018-05-10');
insert into locacao (usuario, exemplar, retirada, entrega) values (90, 13003, '2018-07-02', '2018-07-08');
insert into locacao (usuario, exemplar, retirada, entrega) values (26, 13003, '2018-09-19', '2018-09-22');
insert into locacao (usuario, exemplar, retirada, entrega) values (94, 13003, '2018-12-08', '2018-12-12');
insert into locacao (usuario, exemplar, retirada, entrega) values (85, 13003, '2019-01-27', '2019-02-04');
insert into locacao (usuario, exemplar, retirada, entrega) values (49, 13003, '2019-04-23', '2019-05-05');
insert into locacao (usuario, exemplar, retirada, entrega) values (77, 14001, '2018-01-10', '2018-01-11');
insert into locacao (usuario, exemplar, retirada, entrega) values (38, 14001, '2018-02-07', '2018-02-09');
insert into locacao (usuario, exemplar, retirada, entrega) values (62, 14001, '2018-03-05', '2018-03-13');
insert into locacao (usuario, exemplar, retirada, entrega) values (24, 14001, '2018-05-06', '2018-05-16');
insert into locacao (usuario, exemplar, retirada, entrega) values (29, 14001, '2018-05-27', '2018-06-09');
insert into locacao (usuario, exemplar, retirada, entrega) values (14, 14001, '2018-06-21', '2018-06-21');
insert into locacao (usuario, exemplar, retirada, entrega) values (69, 14001, '2018-06-23', '2018-07-03');
insert into locacao (usuario, exemplar, retirada, entrega) values (24, 14001, '2018-08-24', '2018-08-27');
insert into locacao (usuario, exemplar, retirada, entrega) values (21, 14001, '2018-11-22', '2018-12-05');
insert into locacao (usuario, exemplar, retirada, entrega) values (10, 14001, '2019-02-03', '2019-02-04');
insert into locacao (usuario, exemplar, retirada, entrega) values (77, 14001, '2019-03-02', '2019-03-15');
insert into locacao (usuario, exemplar, retirada, entrega) values (65, 14001, '2019-03-21', '2019-04-03');
insert into locacao (usuario, exemplar, retirada, entrega) values (77, 14001, '2019-04-22', '2019-04-26');
insert into locacao (usuario, exemplar, retirada, entrega) values (75, 14002, '2018-03-16', '2018-03-18');
insert into locacao (usuario, exemplar, retirada, entrega) values (41, 14002, '2018-04-06', '2018-04-19');
insert into locacao (usuario, exemplar, retirada, entrega) values (93, 14002, '2018-07-09', '2018-07-17');
insert into locacao (usuario, exemplar, retirada, entrega) values (92, 14002, '2018-09-14', '2018-09-25');
insert into locacao (usuario, exemplar, retirada, entrega) values (47, 14002, '2018-11-04', '2018-11-12');
insert into locacao (usuario, exemplar, retirada, entrega) values (24, 14002, '2019-01-12', '2019-01-14');
insert into locacao (usuario, exemplar, retirada, entrega) values (30, 14002, '2019-04-21', '2019-05-03');
insert into locacao (usuario, exemplar, retirada, entrega) values (42, 14003, '2018-04-09', '2018-04-12');
insert into locacao (usuario, exemplar, retirada, entrega) values (80, 14003, '2018-04-13', '2018-04-22');
insert into locacao (usuario, exemplar, retirada, entrega) values (22, 14003, '2018-07-15', '2018-07-20');
insert into locacao (usuario, exemplar, retirada, entrega) values (45, 14003, '2018-07-19', '2018-07-25');
insert into locacao (usuario, exemplar, retirada, entrega) values (72, 14003, '2018-09-04', '2018-09-13');
insert into locacao (usuario, exemplar, retirada, entrega) values (84, 14003, '2018-10-06', '2018-10-14');
insert into locacao (usuario, exemplar, retirada, entrega) values (30, 14003, '2018-10-16', '2018-10-25');
insert into locacao (usuario, exemplar, retirada, entrega) values (69, 14003, '2018-12-03', '2018-12-11');
insert into locacao (usuario, exemplar, retirada, entrega) values (59, 14003, '2018-12-09', '2018-12-18');
insert into locacao (usuario, exemplar, retirada, entrega) values (71, 14003, '2018-12-21', '2018-12-25');
insert into locacao (usuario, exemplar, retirada, entrega) values (19, 14003, '2019-03-14', '2019-03-18');
insert into locacao (usuario, exemplar, retirada, entrega) values (88, 14003, '2019-04-25', '2019-04-28');
insert into locacao (usuario, exemplar, retirada, entrega) values (53, 15001, '2018-01-13', '2018-01-19');
insert into locacao (usuario, exemplar, retirada, entrega) values (48, 15001, '2018-02-14', '2018-02-22');
insert into locacao (usuario, exemplar, retirada, entrega) values (39, 15001, '2018-04-10', '2018-04-20');
insert into locacao (usuario, exemplar, retirada, entrega) values (79, 15001, '2018-06-12', '2018-06-18');
insert into locacao (usuario, exemplar, retirada, entrega) values (18, 15001, '2018-07-15', '2018-07-25');
insert into locacao (usuario, exemplar, retirada, entrega) values (18, 15001, '2018-09-03', '2018-09-14');
insert into locacao (usuario, exemplar, retirada, entrega) values (48, 15001, '2018-11-06', '2018-11-11');
insert into locacao (usuario, exemplar, retirada, entrega) values (34, 15001, '2019-01-12', '2019-01-19');
insert into locacao (usuario, exemplar, retirada, entrega) values (90, 15001, '2019-04-03', '2019-04-11');
insert into locacao (usuario, exemplar, retirada, entrega) values (41, 15002, '2018-02-01', '2018-02-08');
insert into locacao (usuario, exemplar, retirada, entrega) values (40, 15002, '2018-02-14', '2018-02-20');
insert into locacao (usuario, exemplar, retirada, entrega) values (66, 15002, '2018-04-27', '2018-05-04');
insert into locacao (usuario, exemplar, retirada, entrega) values (29, 15002, '2018-07-17', '2018-07-29');
insert into locacao (usuario, exemplar, retirada, entrega) values (20, 15002, '2018-08-17', '2018-08-26');
insert into locacao (usuario, exemplar, retirada, entrega) values (82, 15002, '2018-10-04', '2018-10-08');
insert into locacao (usuario, exemplar, retirada, entrega) values (23, 15002, '2018-12-22', '2018-12-25');
insert into locacao (usuario, exemplar, retirada, entrega) values (45, 15002, '2019-01-22', '2019-02-02');
insert into locacao (usuario, exemplar, retirada, entrega) values (66, 15002, '2019-02-22', '2019-02-25');
insert into locacao (usuario, exemplar, retirada, entrega) values (23, 15002, '2019-02-27', '2019-03-04');
insert into locacao (usuario, exemplar, retirada, entrega) values (23, 15003, '2018-02-12', '2018-02-15');
insert into locacao (usuario, exemplar, retirada, entrega) values (22, 15003, '2018-04-19', '2018-05-02');
insert into locacao (usuario, exemplar, retirada, entrega) values (93, 15003, '2018-07-27', '2018-07-30');
insert into locacao (usuario, exemplar, retirada, entrega) values (65, 15003, '2018-10-22', '2018-10-25');
insert into locacao (usuario, exemplar, retirada, entrega) values (84, 15003, '2018-12-15', '2018-12-18');
insert into locacao (usuario, exemplar, retirada, entrega) values (56, 15003, '2019-02-19', '2019-02-21');
insert into locacao (usuario, exemplar, retirada, entrega) values (94, 15003, '2019-03-19', '2019-03-27');
insert into locacao (usuario, exemplar, retirada, entrega) values (66, 15003, '2019-04-25', '2019-05-04');
insert into locacao (usuario, exemplar, retirada, entrega) values (21, 16001, '2018-01-01', '2018-01-07');
insert into locacao (usuario, exemplar, retirada, entrega) values (25, 16001, '2018-02-28', '2018-03-08');
insert into locacao (usuario, exemplar, retirada, entrega) values (84, 16001, '2018-06-07', '2018-06-10');
insert into locacao (usuario, exemplar, retirada, entrega) values (32, 16001, '2018-06-24', '2018-07-05');
insert into locacao (usuario, exemplar, retirada, entrega) values (77, 16001, '2018-09-18', '2018-09-23');
insert into locacao (usuario, exemplar, retirada, entrega) values (85, 16001, '2018-10-21', '2018-11-01');
insert into locacao (usuario, exemplar, retirada, entrega) values (45, 16001, '2019-01-01', '2019-01-09');
insert into locacao (usuario, exemplar, retirada, entrega) values (61, 16001, '2019-04-06', '2019-04-10');
insert into locacao (usuario, exemplar, retirada, entrega) values (90, 16002, '2018-01-21', '2018-02-03');
insert into locacao (usuario, exemplar, retirada, entrega) values (13, 16002, '2018-03-13', '2018-03-21');
insert into locacao (usuario, exemplar, retirada, entrega) values (94, 16002, '2018-06-13', '2018-06-22');
insert into locacao (usuario, exemplar, retirada, entrega) values (11, 16002, '2018-09-18', '2018-09-19');
insert into locacao (usuario, exemplar, retirada, entrega) values (69, 16002, '2018-12-04', '2018-12-17');
insert into locacao (usuario, exemplar, retirada, entrega) values (55, 16002, '2019-02-11', '2019-02-17');
insert into locacao (usuario, exemplar, retirada, entrega) values (43, 16002, '2019-02-12', '2019-02-20');
insert into locacao (usuario, exemplar, retirada, entrega) values (39, 16002, '2019-04-11', '2019-04-13');
insert into locacao (usuario, exemplar, retirada, entrega) values (90, 16003, '2018-03-27', '2018-04-02');
insert into locacao (usuario, exemplar, retirada, entrega) values (47, 16003, '2018-04-15', '2018-04-24');
insert into locacao (usuario, exemplar, retirada, entrega) values (27, 16003, '2018-06-11', '2018-06-15');
insert into locacao (usuario, exemplar, retirada, entrega) values (18, 16003, '2018-08-01', '2018-08-06');
insert into locacao (usuario, exemplar, retirada, entrega) values (11, 16003, '2018-09-28', '2018-10-07');
insert into locacao (usuario, exemplar, retirada, entrega) values (93, 16003, '2018-12-08', '2018-12-16');
insert into locacao (usuario, exemplar, retirada, entrega) values (20, 16003, '2019-01-23', '2019-02-02');
insert into locacao (usuario, exemplar, retirada, entrega) values (15, 16003, '2019-04-02', '2019-04-14');
insert into locacao (usuario, exemplar, retirada, entrega) values (55, 16004, '2018-03-16', '2018-03-28');
insert into locacao (usuario, exemplar, retirada, entrega) values (35, 16004, '2018-05-07', '2018-05-16');
insert into locacao (usuario, exemplar, retirada, entrega) values (73, 16004, '2018-08-11', '2018-08-11');
insert into locacao (usuario, exemplar, retirada, entrega) values (47, 16004, '2018-11-09', '2018-11-18');
insert into locacao (usuario, exemplar, retirada, entrega) values (75, 16004, '2019-02-12', '2019-02-21');
insert into locacao (usuario, exemplar, retirada, entrega) values (93, 16004, '2019-02-12', '2019-02-22');
insert into locacao (usuario, exemplar, retirada, entrega) values (37, 16004, '2019-03-01', '2019-03-04');
insert into locacao (usuario, exemplar, retirada, entrega) values (24, 16004, '2019-04-08', '2019-04-08');
insert into locacao (usuario, exemplar, retirada, entrega) values (51, 16004, '2019-04-25', '2019-05-07');
insert into locacao (usuario, exemplar, retirada, entrega) values (5, 16005, '2018-02-02', '2018-02-03');
insert into locacao (usuario, exemplar, retirada, entrega) values (18, 16005, '2018-04-22', '2018-04-29');
insert into locacao (usuario, exemplar, retirada, entrega) values (64, 16005, '2018-06-20', '2018-06-24');
insert into locacao (usuario, exemplar, retirada, entrega) values (74, 16005, '2018-07-25', '2018-08-03');
insert into locacao (usuario, exemplar, retirada, entrega) values (45, 16005, '2018-10-13', '2018-10-16');
insert into locacao (usuario, exemplar, retirada, entrega) values (66, 16005, '2019-01-06', '2019-01-06');
insert into locacao (usuario, exemplar, retirada, entrega) values (93, 16005, '2019-02-05', '2019-02-06');
insert into locacao (usuario, exemplar, retirada, entrega) values (89, 16005, '2019-04-24', '2019-04-28');
insert into locacao (usuario, exemplar, retirada, entrega) values (7, 17001, '2018-03-26', '2018-03-30');
insert into locacao (usuario, exemplar, retirada, entrega) values (15, 17001, '2018-06-08', '2018-06-16');
insert into locacao (usuario, exemplar, retirada, entrega) values (13, 17001, '2018-07-15', '2018-07-21');
insert into locacao (usuario, exemplar, retirada, entrega) values (47, 17001, '2018-08-17', '2018-08-22');
insert into locacao (usuario, exemplar, retirada, entrega) values (7, 17001, '2018-10-21', '2018-10-28');
insert into locacao (usuario, exemplar, retirada, entrega) values (58, 17001, '2019-01-14', '2019-01-20');
insert into locacao (usuario, exemplar, retirada, entrega) values (100, 17001, '2019-03-08', '2019-03-20');
insert into locacao (usuario, exemplar, retirada, entrega) values (35, 18001, '2018-01-22', '2018-01-24');
insert into locacao (usuario, exemplar, retirada, entrega) values (100, 18001, '2018-01-28', '2018-02-04');
insert into locacao (usuario, exemplar, retirada, entrega) values (5, 18001, '2018-04-05', '2018-04-17');
insert into locacao (usuario, exemplar, retirada, entrega) values (37, 18001, '2018-05-14', '2018-05-27');
insert into locacao (usuario, exemplar, retirada, entrega) values (29, 18001, '2018-05-17', '2018-05-29');
insert into locacao (usuario, exemplar, retirada, entrega) values (45, 18001, '2018-08-03', '2018-08-13');
insert into locacao (usuario, exemplar, retirada, entrega) values (38, 18001, '2018-10-12', '2018-10-19');
insert into locacao (usuario, exemplar, retirada, entrega) values (67, 18001, '2018-11-22', '2018-12-03');
insert into locacao (usuario, exemplar, retirada, entrega) values (66, 18001, '2018-12-28', '2019-01-02');
insert into locacao (usuario, exemplar, retirada, entrega) values (30, 18001, '2019-02-04', '2019-02-09');
insert into locacao (usuario, exemplar, retirada, entrega) values (19, 18001, '2019-04-30', '2019-05-06');
insert into locacao (usuario, exemplar, retirada, entrega) values (60, 18002, '2018-01-02', '2018-01-05');
insert into locacao (usuario, exemplar, retirada, entrega) values (43, 18002, '2018-03-08', '2018-03-10');
insert into locacao (usuario, exemplar, retirada, entrega) values (6, 18002, '2018-04-13', '2018-04-22');
insert into locacao (usuario, exemplar, retirada, entrega) values (42, 18002, '2018-05-20', '2018-05-21');
insert into locacao (usuario, exemplar, retirada, entrega) values (65, 18002, '2018-08-07', '2018-08-10');
insert into locacao (usuario, exemplar, retirada, entrega) values (73, 18002, '2018-10-26', '2018-10-26');
insert into locacao (usuario, exemplar, retirada, entrega) values (71, 18002, '2019-01-29', '2019-02-04');
insert into locacao (usuario, exemplar, retirada, entrega) values (12, 18002, '2019-03-15', '2019-03-26');
insert into locacao (usuario, exemplar, retirada, entrega) values (85, 18002, '2019-04-07', '2019-04-13');
insert into locacao (usuario, exemplar, retirada, entrega) values (10, 18003, '2018-01-02', '2018-01-05');
insert into locacao (usuario, exemplar, retirada, entrega) values (33, 18003, '2018-01-08', '2018-01-09');
insert into locacao (usuario, exemplar, retirada, entrega) values (6, 18003, '2018-02-11', '2018-02-23');
insert into locacao (usuario, exemplar, retirada, entrega) values (66, 18003, '2018-05-15', '2018-05-25');
insert into locacao (usuario, exemplar, retirada, entrega) values (1, 18003, '2018-08-09', '2018-08-13');
insert into locacao (usuario, exemplar, retirada, entrega) values (54, 18003, '2018-10-04', '2018-10-08');
insert into locacao (usuario, exemplar, retirada, entrega) values (54, 18003, '2018-10-28', '2018-11-04');
insert into locacao (usuario, exemplar, retirada, entrega) values (69, 18003, '2018-11-19', '2018-11-28');
insert into locacao (usuario, exemplar, retirada, entrega) values (33, 18003, '2018-12-11', '2018-12-16');
insert into locacao (usuario, exemplar, retirada, entrega) values (81, 18003, '2019-02-24', '2019-03-07');
insert into locacao (usuario, exemplar, retirada, entrega) values (9, 18004, '2018-04-02', '2018-04-15');
insert into locacao (usuario, exemplar, retirada, entrega) values (34, 18004, '2018-04-18', '2018-04-20');
insert into locacao (usuario, exemplar, retirada, entrega) values (63, 18004, '2018-05-11', '2018-05-23');
insert into locacao (usuario, exemplar, retirada, entrega) values (98, 18004, '2018-07-24', '2018-08-05');
insert into locacao (usuario, exemplar, retirada, entrega) values (67, 18004, '2018-08-31', '2018-09-09');
insert into locacao (usuario, exemplar, retirada, entrega) values (71, 18004, '2018-09-26', '2018-09-28');
insert into locacao (usuario, exemplar, retirada, entrega) values (9, 18004, '2018-11-19', '2018-11-29');
insert into locacao (usuario, exemplar, retirada, entrega) values (19, 18004, '2018-12-23', '2019-01-02');
insert into locacao (usuario, exemplar, retirada, entrega) values (30, 18004, '2019-03-13', '2019-03-13');
insert into locacao (usuario, exemplar, retirada, entrega) values (27, 18005, '2018-01-29', '2018-02-03');
insert into locacao (usuario, exemplar, retirada, entrega) values (17, 18005, '2018-03-14', '2018-03-21');
insert into locacao (usuario, exemplar, retirada, entrega) values (71, 18005, '2018-04-22', '2018-04-30');
insert into locacao (usuario, exemplar, retirada, entrega) values (85, 18005, '2018-04-23', '2018-04-30');
insert into locacao (usuario, exemplar, retirada, entrega) values (45, 18005, '2018-06-19', '2018-06-19');
insert into locacao (usuario, exemplar, retirada, entrega) values (42, 18005, '2018-08-26', '2018-09-02');
insert into locacao (usuario, exemplar, retirada, entrega) values (57, 18005, '2018-10-28', '2018-11-02');
insert into locacao (usuario, exemplar, retirada, entrega) values (19, 18005, '2019-01-02', '2019-01-05');
insert into locacao (usuario, exemplar, retirada, entrega) values (58, 18005, '2019-01-04', '2019-01-08');
insert into locacao (usuario, exemplar, retirada, entrega) values (67, 18005, '2019-02-16', '2019-02-18');
insert into locacao (usuario, exemplar, retirada, entrega) values (11, 18005, '2019-03-22', '2019-03-30');
insert into locacao (usuario, exemplar, retirada, entrega) values (88, 18005, '2019-04-09', '2019-04-11');
insert into locacao (usuario, exemplar, retirada, entrega) values (41, 19001, '2018-03-03', '2018-03-05');
insert into locacao (usuario, exemplar, retirada, entrega) values (85, 19001, '2018-03-26', '2018-04-04');
insert into locacao (usuario, exemplar, retirada, entrega) values (75, 19001, '2018-06-25', '2018-07-01');
insert into locacao (usuario, exemplar, retirada, entrega) values (72, 19001, '2018-08-25', '2018-08-25');
insert into locacao (usuario, exemplar, retirada, entrega) values (72, 19001, '2018-09-03', '2018-09-05');
insert into locacao (usuario, exemplar, retirada, entrega) values (79, 19001, '2018-10-20', '2018-10-29');
insert into locacao (usuario, exemplar, retirada, entrega) values (44, 19001, '2018-11-17', '2018-11-27');
insert into locacao (usuario, exemplar, retirada, entrega) values (69, 19001, '2019-01-30', '2019-02-06');
insert into locacao (usuario, exemplar, retirada, entrega) values (55, 19001, '2019-03-02', '2019-03-11');
insert into locacao (usuario, exemplar, retirada, entrega) values (20, 19002, '2018-02-21', '2018-03-06');
insert into locacao (usuario, exemplar, retirada, entrega) values (25, 19002, '2018-05-03', '2018-05-05');
insert into locacao (usuario, exemplar, retirada, entrega) values (26, 19002, '2018-05-24', '2018-05-30');
insert into locacao (usuario, exemplar, retirada, entrega) values (79, 19002, '2018-08-25', '2018-09-03');
insert into locacao (usuario, exemplar, retirada, entrega) values (24, 19002, '2018-09-03', '2018-09-13');
insert into locacao (usuario, exemplar, retirada, entrega) values (71, 19002, '2018-11-19', '2018-11-20');
insert into locacao (usuario, exemplar, retirada, entrega) values (38, 19002, '2018-12-29', '2019-01-01');
insert into locacao (usuario, exemplar, retirada, entrega) values (8, 19002, '2019-02-19', '2019-03-04');
insert into locacao (usuario, exemplar, retirada, entrega) values (10, 20001, '2018-02-04', '2018-02-16');
insert into locacao (usuario, exemplar, retirada, entrega) values (18, 20001, '2018-02-17', '2018-02-21');
insert into locacao (usuario, exemplar, retirada, entrega) values (50, 20001, '2018-05-07', '2018-05-20');
insert into locacao (usuario, exemplar, retirada, entrega) values (31, 20001, '2018-05-08', '2018-05-08');
insert into locacao (usuario, exemplar, retirada, entrega) values (100, 20001, '2018-07-06', '2018-07-12');
insert into locacao (usuario, exemplar, retirada, entrega) values (23, 20001, '2018-09-17', '2018-09-21');
insert into locacao (usuario, exemplar, retirada, entrega) values (67, 20001, '2018-10-11', '2018-10-18');
insert into locacao (usuario, exemplar, retirada, entrega) values (39, 20001, '2018-12-20', '2018-12-25');
insert into locacao (usuario, exemplar, retirada, entrega) values (93, 20001, '2019-03-13', '2019-03-16');
insert into locacao (usuario, exemplar, retirada, entrega) values (27, 20002, '2018-03-27', '2018-04-08');
insert into locacao (usuario, exemplar, retirada, entrega) values (96, 20002, '2018-03-31', '2018-04-04');
insert into locacao (usuario, exemplar, retirada, entrega) values (74, 20002, '2018-06-20', '2018-06-23');
insert into locacao (usuario, exemplar, retirada, entrega) values (96, 20002, '2018-08-10', '2018-08-22');
insert into locacao (usuario, exemplar, retirada, entrega) values (35, 20002, '2018-10-08', '2018-10-15');
insert into locacao (usuario, exemplar, retirada, entrega) values (94, 20002, '2018-10-16', '2018-10-22');
insert into locacao (usuario, exemplar, retirada, entrega) values (52, 20002, '2018-10-28', '2018-10-28');
insert into locacao (usuario, exemplar, retirada, entrega) values (80, 20002, '2018-11-08', '2018-11-16');
insert into locacao (usuario, exemplar, retirada, entrega) values (20, 20002, '2018-12-01', '2018-12-09');
insert into locacao (usuario, exemplar, retirada, entrega) values (36, 20002, '2019-03-05', '2019-03-07');
insert into locacao (usuario, exemplar, retirada, entrega) values (69, 20002, '2019-03-05', '2019-03-13');
insert into locacao (usuario, exemplar, retirada, entrega) values (38, 20002, '2019-03-09', '2019-03-14');
insert into locacao (usuario, exemplar, retirada, entrega) values (95, 20003, '2018-01-20', '2018-01-24');
insert into locacao (usuario, exemplar, retirada, entrega) values (64, 20003, '2018-02-23', '2018-02-27');
insert into locacao (usuario, exemplar, retirada, entrega) values (84, 20003, '2018-04-20', '2018-04-28');
insert into locacao (usuario, exemplar, retirada, entrega) values (66, 20003, '2018-07-27', '2018-08-09');
insert into locacao (usuario, exemplar, retirada, entrega) values (58, 20003, '2018-10-23', '2018-11-02');
insert into locacao (usuario, exemplar, retirada, entrega) values (16, 20003, '2019-01-28', '2019-02-06');
insert into locacao (usuario, exemplar, retirada, entrega) values (70, 21001, '2018-03-14', '2018-03-15');
insert into locacao (usuario, exemplar, retirada, entrega) values (39, 21001, '2018-03-16', '2018-03-22');
insert into locacao (usuario, exemplar, retirada, entrega) values (79, 21001, '2018-04-23', '2018-04-29');
insert into locacao (usuario, exemplar, retirada, entrega) values (23, 21001, '2018-07-07', '2018-07-18');
insert into locacao (usuario, exemplar, retirada, entrega) values (17, 21001, '2018-07-11', '2018-07-14');
insert into locacao (usuario, exemplar, retirada, entrega) values (4, 21001, '2018-09-07', '2018-09-19');
insert into locacao (usuario, exemplar, retirada, entrega) values (61, 21001, '2018-10-30', '2018-11-05');
insert into locacao (usuario, exemplar, retirada, entrega) values (7, 21001, '2019-01-09', '2019-01-19');
insert into locacao (usuario, exemplar, retirada, entrega) values (80, 21001, '2019-02-16', '2019-02-19');
insert into locacao (usuario, exemplar, retirada, entrega) values (88, 21002, '2018-03-16', '2018-03-23');
insert into locacao (usuario, exemplar, retirada, entrega) values (93, 21002, '2018-06-11', '2018-06-17');
insert into locacao (usuario, exemplar, retirada, entrega) values (17, 21002, '2018-09-10', '2018-09-16');
insert into locacao (usuario, exemplar, retirada, entrega) values (71, 21002, '2018-12-16', '2018-12-25');
insert into locacao (usuario, exemplar, retirada, entrega) values (92, 21002, '2019-03-13', '2019-03-19');
insert into locacao (usuario, exemplar, retirada, entrega) values (97, 21002, '2019-03-22', '2019-03-27');
insert into locacao (usuario, exemplar, retirada, entrega) values (2, 21002, '2019-04-04', '2019-04-09');
insert into locacao (usuario, exemplar, retirada, entrega) values (28, 21003, '2018-02-02', '2018-02-02');
insert into locacao (usuario, exemplar, retirada, entrega) values (14, 21003, '2018-03-27', '2018-03-31');
insert into locacao (usuario, exemplar, retirada, entrega) values (26, 21003, '2018-05-27', '2018-05-28');
insert into locacao (usuario, exemplar, retirada, entrega) values (50, 21003, '2018-06-27', '2018-07-04');
insert into locacao (usuario, exemplar, retirada, entrega) values (80, 21003, '2018-07-31', '2018-08-13');
insert into locacao (usuario, exemplar, retirada, entrega) values (28, 21003, '2018-08-12', '2018-08-20');
insert into locacao (usuario, exemplar, retirada, entrega) values (75, 21003, '2018-08-19', '2018-08-25');
insert into locacao (usuario, exemplar, retirada, entrega) values (48, 21003, '2018-08-29', '2018-08-30');
insert into locacao (usuario, exemplar, retirada, entrega) values (61, 21003, '2018-10-18', '2018-10-22');
insert into locacao (usuario, exemplar, retirada, entrega) values (98, 21003, '2019-01-20', '2019-01-22');
insert into locacao (usuario, exemplar, retirada, entrega) values (18, 21003, '2019-01-31', '2019-02-06');
insert into locacao (usuario, exemplar, retirada, entrega) values (33, 21003, '2019-03-15', '2019-03-18');
insert into locacao (usuario, exemplar, retirada, entrega) values (23, 21003, '2019-04-06', '2019-04-13');
insert into locacao (usuario, exemplar, retirada, entrega) values (28, 22001, '2018-03-26', '2018-03-28');
insert into locacao (usuario, exemplar, retirada, entrega) values (21, 22001, '2018-04-02', '2018-04-10');
insert into locacao (usuario, exemplar, retirada, entrega) values (94, 22001, '2018-04-19', '2018-04-21');
insert into locacao (usuario, exemplar, retirada, entrega) values (74, 22001, '2018-06-21', '2018-06-24');
insert into locacao (usuario, exemplar, retirada, entrega) values (23, 22001, '2018-09-03', '2018-09-11');
insert into locacao (usuario, exemplar, retirada, entrega) values (52, 22001, '2018-11-01', '2018-11-05');
insert into locacao (usuario, exemplar, retirada, entrega) values (55, 22001, '2018-11-18', '2018-11-22');
insert into locacao (usuario, exemplar, retirada, entrega) values (18, 22001, '2019-02-04', '2019-02-07');
insert into locacao (usuario, exemplar, retirada, entrega) values (60, 22001, '2019-02-19', '2019-02-27');
insert into locacao (usuario, exemplar, retirada, entrega) values (43, 22001, '2019-04-12', '2019-04-13');
insert into locacao (usuario, exemplar, retirada, entrega) values (7, 22002, '2018-01-21', '2018-02-01');
insert into locacao (usuario, exemplar, retirada, entrega) values (16, 22002, '2018-04-10', '2018-04-12');
insert into locacao (usuario, exemplar, retirada, entrega) values (78, 22002, '2018-06-27', '2018-07-07');
insert into locacao (usuario, exemplar, retirada, entrega) values (21, 22002, '2018-09-16', '2018-09-20');
insert into locacao (usuario, exemplar, retirada, entrega) values (5, 22002, '2018-10-06', '2018-10-15');
insert into locacao (usuario, exemplar, retirada, entrega) values (45, 22002, '2018-11-05', '2018-11-08');
insert into locacao (usuario, exemplar, retirada, entrega) values (41, 22002, '2018-11-06', '2018-11-15');
insert into locacao (usuario, exemplar, retirada, entrega) values (14, 22002, '2018-11-25', '2018-12-03');
insert into locacao (usuario, exemplar, retirada, entrega) values (48, 22002, '2018-12-17', '2018-12-20');
insert into locacao (usuario, exemplar, retirada, entrega) values (65, 22002, '2018-12-27', '2018-12-27');
insert into locacao (usuario, exemplar, retirada, entrega) values (20, 22002, '2019-03-24', '2019-03-28');
insert into locacao (usuario, exemplar, retirada, entrega) values (74, 22003, '2018-01-05', '2018-01-15');
insert into locacao (usuario, exemplar, retirada, entrega) values (73, 22003, '2018-01-22', '2018-01-23');
insert into locacao (usuario, exemplar, retirada, entrega) values (25, 22003, '2018-03-28', '2018-04-01');
insert into locacao (usuario, exemplar, retirada, entrega) values (66, 22003, '2018-06-08', '2018-06-19');
insert into locacao (usuario, exemplar, retirada, entrega) values (80, 22003, '2018-09-15', '2018-09-15');
insert into locacao (usuario, exemplar, retirada, entrega) values (44, 22003, '2018-12-02', '2018-12-12');
insert into locacao (usuario, exemplar, retirada, entrega) values (41, 22003, '2019-01-16', '2019-01-28');
insert into locacao (usuario, exemplar, retirada, entrega) values (56, 22003, '2019-03-27', '2019-04-05');
insert into locacao (usuario, exemplar, retirada, entrega) values (6, 22003, '2019-04-06', '2019-04-19');
insert into locacao (usuario, exemplar, retirada, entrega) values (77, 22004, '2018-03-10', '2018-03-20');
insert into locacao (usuario, exemplar, retirada, entrega) values (29, 22004, '2018-05-21', '2018-05-31');
insert into locacao (usuario, exemplar, retirada, entrega) values (64, 22004, '2018-08-28', '2018-08-29');
insert into locacao (usuario, exemplar, retirada, entrega) values (39, 22004, '2018-09-28', '2018-10-10');
insert into locacao (usuario, exemplar, retirada, entrega) values (62, 22004, '2018-11-27', '2018-12-01');
insert into locacao (usuario, exemplar, retirada, entrega) values (97, 22004, '2019-01-03', '2019-01-13');
insert into locacao (usuario, exemplar, retirada, entrega) values (25, 22004, '2019-02-19', '2019-02-22');
insert into locacao (usuario, exemplar, retirada, entrega) values (38, 23001, '2018-01-31', '2018-02-09');
insert into locacao (usuario, exemplar, retirada, entrega) values (88, 23001, '2018-03-13', '2018-03-15');
insert into locacao (usuario, exemplar, retirada, entrega) values (11, 23001, '2018-04-23', '2018-04-23');
insert into locacao (usuario, exemplar, retirada, entrega) values (55, 23001, '2018-04-27', '2018-05-09');
insert into locacao (usuario, exemplar, retirada, entrega) values (91, 23001, '2018-05-26', '2018-05-29');
insert into locacao (usuario, exemplar, retirada, entrega) values (35, 23001, '2018-06-03', '2018-06-03');
insert into locacao (usuario, exemplar, retirada, entrega) values (28, 23001, '2018-07-05', '2018-07-18');
insert into locacao (usuario, exemplar, retirada, entrega) values (31, 23001, '2018-09-26', '2018-10-05');
insert into locacao (usuario, exemplar, retirada, entrega) values (83, 23001, '2018-12-19', '2018-12-31');
insert into locacao (usuario, exemplar, retirada, entrega) values (64, 23001, '2019-02-20', '2019-03-05');
insert into locacao (usuario, exemplar, retirada, entrega) values (90, 23001, '2019-03-19', '2019-03-25');
insert into locacao (usuario, exemplar, retirada, entrega) values (28, 23002, '2018-02-25', '2018-02-25');
insert into locacao (usuario, exemplar, retirada, entrega) values (48, 23002, '2018-03-17', '2018-03-24');
insert into locacao (usuario, exemplar, retirada, entrega) values (62, 23002, '2018-05-31', '2018-06-09');
insert into locacao (usuario, exemplar, retirada, entrega) values (85, 23002, '2018-07-06', '2018-07-06');
insert into locacao (usuario, exemplar, retirada, entrega) values (63, 23002, '2018-09-12', '2018-09-21');
insert into locacao (usuario, exemplar, retirada, entrega) values (59, 23002, '2018-09-15', '2018-09-16');
insert into locacao (usuario, exemplar, retirada, entrega) values (71, 23002, '2018-10-19', '2018-10-23');
insert into locacao (usuario, exemplar, retirada, entrega) values (8, 23002, '2018-11-29', '2018-12-07');
insert into locacao (usuario, exemplar, retirada, entrega) values (50, 23002, '2019-01-07', '2019-01-10');
insert into locacao (usuario, exemplar, retirada, entrega) values (50, 23002, '2019-03-21', '2019-03-24');
insert into locacao (usuario, exemplar, retirada, entrega) values (65, 23002, '2019-04-01', '2019-04-14');
insert into locacao (usuario, exemplar, retirada, entrega) values (92, 23002, '2019-04-13', '2019-04-14');
insert into locacao (usuario, exemplar, retirada, entrega) values (64, 23003, '2018-02-14', '2018-02-16');
insert into locacao (usuario, exemplar, retirada, entrega) values (24, 23003, '2018-04-26', '2018-05-04');
insert into locacao (usuario, exemplar, retirada, entrega) values (67, 23003, '2018-06-24', '2018-07-05');
insert into locacao (usuario, exemplar, retirada, entrega) values (31, 23003, '2018-08-08', '2018-08-20');
insert into locacao (usuario, exemplar, retirada, entrega) values (97, 23003, '2018-08-19', '2018-08-20');
insert into locacao (usuario, exemplar, retirada, entrega) values (44, 23003, '2018-09-20', '2018-09-24');
insert into locacao (usuario, exemplar, retirada, entrega) values (99, 23003, '2018-10-14', '2018-10-18');
insert into locacao (usuario, exemplar, retirada, entrega) values (50, 23003, '2018-12-08', '2018-12-15');
insert into locacao (usuario, exemplar, retirada, entrega) values (9, 23003, '2018-12-11', '2018-12-18');
insert into locacao (usuario, exemplar, retirada, entrega) values (58, 23003, '2018-12-17', '2018-12-17');
insert into locacao (usuario, exemplar, retirada, entrega) values (18, 23003, '2019-03-20', '2019-03-27');
insert into locacao (usuario, exemplar, retirada, entrega) values (93, 24001, '2018-03-28', '2018-04-09');
insert into locacao (usuario, exemplar, retirada, entrega) values (89, 24001, '2018-05-22', '2018-06-02');
insert into locacao (usuario, exemplar, retirada, entrega) values (24, 24001, '2018-07-17', '2018-07-29');
insert into locacao (usuario, exemplar, retirada, entrega) values (26, 24001, '2018-09-02', '2018-09-11');
insert into locacao (usuario, exemplar, retirada, entrega) values (92, 24001, '2018-10-19', '2018-10-25');
insert into locacao (usuario, exemplar, retirada, entrega) values (32, 24001, '2018-10-25', '2018-10-31');
insert into locacao (usuario, exemplar, retirada, entrega) values (82, 24001, '2018-12-04', '2018-12-13');
insert into locacao (usuario, exemplar, retirada, entrega) values (83, 24001, '2019-02-26', '2019-03-04');
insert into locacao (usuario, exemplar, retirada, entrega) values (37, 24002, '2018-04-06', '2018-04-14');
insert into locacao (usuario, exemplar, retirada, entrega) values (25, 24002, '2018-04-26', '2018-05-08');
insert into locacao (usuario, exemplar, retirada, entrega) values (27, 24002, '2018-04-30', '2018-05-07');
insert into locacao (usuario, exemplar, retirada, entrega) values (79, 24002, '2018-05-30', '2018-06-01');
insert into locacao (usuario, exemplar, retirada, entrega) values (91, 24002, '2018-06-07', '2018-06-19');
insert into locacao (usuario, exemplar, retirada, entrega) values (99, 24002, '2018-07-05', '2018-07-07');
insert into locacao (usuario, exemplar, retirada, entrega) values (89, 24002, '2018-09-01', '2018-09-01');
insert into locacao (usuario, exemplar, retirada, entrega) values (24, 24002, '2018-09-12', '2018-09-14');
insert into locacao (usuario, exemplar, retirada, entrega) values (96, 24002, '2018-12-01', '2018-12-09');
insert into locacao (usuario, exemplar, retirada, entrega) values (9, 24002, '2018-12-21', '2018-12-29');
insert into locacao (usuario, exemplar, retirada, entrega) values (31, 24002, '2019-03-24', '2019-04-02');
insert into locacao (usuario, exemplar, retirada, entrega) values (100, 25001, '2018-01-04', '2018-01-16');
insert into locacao (usuario, exemplar, retirada, entrega) values (43, 25001, '2018-02-05', '2018-02-10');
insert into locacao (usuario, exemplar, retirada, entrega) values (6, 25001, '2018-03-01', '2018-03-09');
insert into locacao (usuario, exemplar, retirada, entrega) values (12, 25001, '2018-06-05', '2018-06-16');
insert into locacao (usuario, exemplar, retirada, entrega) values (6, 25001, '2018-07-07', '2018-07-12');
insert into locacao (usuario, exemplar, retirada, entrega) values (2, 25001, '2018-10-03', '2018-10-10');
insert into locacao (usuario, exemplar, retirada, entrega) values (11, 25001, '2019-01-02', '2019-01-13');
insert into locacao (usuario, exemplar, retirada, entrega) values (13, 25001, '2019-01-03', '2019-01-11');
insert into locacao (usuario, exemplar, retirada, entrega) values (59, 25001, '2019-03-20', '2019-03-25');
insert into locacao (usuario, exemplar, retirada, entrega) values (72, 25002, '2018-03-23', '2018-04-04');
insert into locacao (usuario, exemplar, retirada, entrega) values (26, 25002, '2018-05-02', '2018-05-09');
insert into locacao (usuario, exemplar, retirada, entrega) values (46, 25002, '2018-06-30', '2018-07-06');
insert into locacao (usuario, exemplar, retirada, entrega) values (44, 25002, '2018-08-06', '2018-08-06');
insert into locacao (usuario, exemplar, retirada, entrega) values (39, 25002, '2018-11-02', '2018-11-11');
insert into locacao (usuario, exemplar, retirada, entrega) values (75, 25002, '2018-12-06', '2018-12-06');
insert into locacao (usuario, exemplar, retirada, entrega) values (54, 25002, '2019-03-09', '2019-03-20');
insert into locacao (usuario, exemplar, retirada, entrega) values (15, 25002, '2019-04-29', '2019-05-04');
insert into locacao (usuario, exemplar, retirada, entrega) values (66, 26001, '2018-01-08', '2018-01-17');
insert into locacao (usuario, exemplar, retirada, entrega) values (7, 26001, '2018-03-17', '2018-03-24');
insert into locacao (usuario, exemplar, retirada, entrega) values (76, 26001, '2018-04-28', '2018-05-11');
insert into locacao (usuario, exemplar, retirada, entrega) values (51, 26001, '2018-05-24', '2018-05-31');
insert into locacao (usuario, exemplar, retirada, entrega) values (6, 26001, '2018-08-19', '2018-08-24');
insert into locacao (usuario, exemplar, retirada, entrega) values (47, 26001, '2018-09-24', '2018-10-06');
insert into locacao (usuario, exemplar, retirada, entrega) values (38, 26001, '2018-12-25', '2019-01-04');
insert into locacao (usuario, exemplar, retirada, entrega) values (21, 26001, '2019-01-02', '2019-01-12');
insert into locacao (usuario, exemplar, retirada, entrega) values (90, 26001, '2019-03-16', '2019-03-28');
insert into locacao (usuario, exemplar, retirada, entrega) values (82, 27001, '2018-01-31', '2018-02-10');
insert into locacao (usuario, exemplar, retirada, entrega) values (48, 27001, '2018-03-29', '2018-04-05');
insert into locacao (usuario, exemplar, retirada, entrega) values (98, 27001, '2018-05-03', '2018-05-13');
insert into locacao (usuario, exemplar, retirada, entrega) values (63, 27001, '2018-07-29', '2018-07-29');
insert into locacao (usuario, exemplar, retirada, entrega) values (53, 27001, '2018-08-25', '2018-08-26');
insert into locacao (usuario, exemplar, retirada, entrega) values (76, 27001, '2018-09-28', '2018-09-30');
insert into locacao (usuario, exemplar, retirada, entrega) values (47, 27001, '2018-11-05', '2018-11-06');
insert into locacao (usuario, exemplar, retirada, entrega) values (57, 27001, '2019-01-09', '2019-01-22');
insert into locacao (usuario, exemplar, retirada, entrega) values (14, 27001, '2019-02-13', '2019-02-24');
insert into locacao (usuario, exemplar, retirada, entrega) values (49, 27001, '2019-02-25', '2019-03-08');
insert into locacao (usuario, exemplar, retirada, entrega) values (29, 27002, '2018-01-13', '2018-01-25');
insert into locacao (usuario, exemplar, retirada, entrega) values (19, 27002, '2018-03-09', '2018-03-16');
insert into locacao (usuario, exemplar, retirada, entrega) values (34, 27002, '2018-03-17', '2018-03-26');
insert into locacao (usuario, exemplar, retirada, entrega) values (60, 27002, '2018-06-21', '2018-06-22');
insert into locacao (usuario, exemplar, retirada, entrega) values (77, 27002, '2018-07-21', '2018-07-29');
insert into locacao (usuario, exemplar, retirada, entrega) values (53, 27002, '2018-08-30', '2018-09-10');
insert into locacao (usuario, exemplar, retirada, entrega) values (27, 27002, '2018-09-02', '2018-09-12');
insert into locacao (usuario, exemplar, retirada, entrega) values (10, 27002, '2018-09-27', '2018-10-01');
insert into locacao (usuario, exemplar, retirada, entrega) values (22, 27002, '2018-12-12', '2018-12-21');
insert into locacao (usuario, exemplar, retirada, entrega) values (66, 27002, '2018-12-30', '2019-01-04');
insert into locacao (usuario, exemplar, retirada, entrega) values (21, 27002, '2019-01-01', '2019-01-07');
insert into locacao (usuario, exemplar, retirada, entrega) values (72, 27002, '2019-04-07', '2019-04-12');
insert into locacao (usuario, exemplar, retirada, entrega) values (20, 27003, '2018-03-05', '2018-03-08');
insert into locacao (usuario, exemplar, retirada, entrega) values (13, 27003, '2018-03-17', '2018-03-28');
insert into locacao (usuario, exemplar, retirada, entrega) values (33, 27003, '2018-05-06', '2018-05-10');
insert into locacao (usuario, exemplar, retirada, entrega) values (93, 27003, '2018-07-06', '2018-07-16');
insert into locacao (usuario, exemplar, retirada, entrega) values (11, 27003, '2018-10-07', '2018-10-20');
insert into locacao (usuario, exemplar, retirada, entrega) values (19, 27003, '2018-11-03', '2018-11-04');
insert into locacao (usuario, exemplar, retirada, entrega) values (64, 27003, '2019-02-02', '2019-02-11');
insert into locacao (usuario, exemplar, retirada, entrega) values (84, 27003, '2019-04-10', '2019-04-12');
insert into locacao (usuario, exemplar, retirada, entrega) values (39, 27004, '2018-03-20', '2018-03-29');
insert into locacao (usuario, exemplar, retirada, entrega) values (45, 27004, '2018-03-25', '2018-04-06');
insert into locacao (usuario, exemplar, retirada, entrega) values (37, 27004, '2018-05-07', '2018-05-14');
insert into locacao (usuario, exemplar, retirada, entrega) values (55, 27004, '2018-06-03', '2018-06-09');
insert into locacao (usuario, exemplar, retirada, entrega) values (37, 27004, '2018-06-10', '2018-06-20');
insert into locacao (usuario, exemplar, retirada, entrega) values (46, 27004, '2018-08-19', '2018-08-23');
insert into locacao (usuario, exemplar, retirada, entrega) values (49, 27004, '2018-10-10', '2018-10-23');
insert into locacao (usuario, exemplar, retirada, entrega) values (95, 27004, '2018-12-31', '2019-01-02');
insert into locacao (usuario, exemplar, retirada, entrega) values (70, 27004, '2019-01-11', '2019-01-18');
insert into locacao (usuario, exemplar, retirada, entrega) values (70, 27004, '2019-03-27', '2019-03-29');
insert into locacao (usuario, exemplar, retirada, entrega) values (41, 27005, '2018-01-30', '2018-02-04');
insert into locacao (usuario, exemplar, retirada, entrega) values (83, 27005, '2018-03-16', '2018-03-16');
insert into locacao (usuario, exemplar, retirada, entrega) values (41, 27005, '2018-03-27', '2018-03-28');
insert into locacao (usuario, exemplar, retirada, entrega) values (34, 27005, '2018-04-16', '2018-04-25');
insert into locacao (usuario, exemplar, retirada, entrega) values (93, 27005, '2018-07-07', '2018-07-15');
insert into locacao (usuario, exemplar, retirada, entrega) values (1, 27005, '2018-09-08', '2018-09-20');
insert into locacao (usuario, exemplar, retirada, entrega) values (62, 27005, '2018-11-23', '2018-11-23');
insert into locacao (usuario, exemplar, retirada, entrega) values (99, 27005, '2019-01-04', '2019-01-15');
insert into locacao (usuario, exemplar, retirada, entrega) values (26, 27005, '2019-04-04', '2019-04-16');
insert into locacao (usuario, exemplar, retirada, entrega) values (63, 27005, '2019-04-21', '2019-04-25');
insert into locacao (usuario, exemplar, retirada, entrega) values (53, 28001, '2018-03-14', '2018-03-21');
insert into locacao (usuario, exemplar, retirada, entrega) values (86, 28001, '2018-05-21', '2018-05-22');
insert into locacao (usuario, exemplar, retirada, entrega) values (28, 28001, '2018-06-16', '2018-06-20');
insert into locacao (usuario, exemplar, retirada, entrega) values (17, 28001, '2018-08-21', '2018-08-22');
insert into locacao (usuario, exemplar, retirada, entrega) values (65, 28001, '2018-11-02', '2018-11-11');
insert into locacao (usuario, exemplar, retirada, entrega) values (66, 28001, '2018-11-28', '2018-12-06');
insert into locacao (usuario, exemplar, retirada, entrega) values (57, 28001, '2019-01-08', '2019-01-20');
insert into locacao (usuario, exemplar, retirada, entrega) values (64, 28001, '2019-01-18', '2019-01-26');
insert into locacao (usuario, exemplar, retirada, entrega) values (82, 28001, '2019-02-16', '2019-02-25');
insert into locacao (usuario, exemplar, retirada, entrega) values (99, 28001, '2019-04-01', '2019-04-07');
insert into locacao (usuario, exemplar, retirada, entrega) values (25, 28002, '2018-03-11', '2018-03-12');
insert into locacao (usuario, exemplar, retirada, entrega) values (83, 28002, '2018-05-18', '2018-05-24');
insert into locacao (usuario, exemplar, retirada, entrega) values (47, 28002, '2018-07-04', '2018-07-04');
insert into locacao (usuario, exemplar, retirada, entrega) values (12, 28002, '2018-09-10', '2018-09-21');
insert into locacao (usuario, exemplar, retirada, entrega) values (50, 28002, '2018-11-17', '2018-11-25');
insert into locacao (usuario, exemplar, retirada, entrega) values (100, 28002, '2019-02-24', '2019-03-09');
insert into locacao (usuario, exemplar, retirada, entrega) values (27, 28002, '2019-04-20', '2019-04-24');
insert into locacao (usuario, exemplar, retirada, entrega) values (36, 28003, '2018-03-20', '2018-03-25');
insert into locacao (usuario, exemplar, retirada, entrega) values (13, 28003, '2018-03-30', '2018-03-31');
insert into locacao (usuario, exemplar, retirada, entrega) values (79, 28003, '2018-05-04', '2018-05-11');
insert into locacao (usuario, exemplar, retirada, entrega) values (25, 28003, '2018-07-19', '2018-07-23');
insert into locacao (usuario, exemplar, retirada, entrega) values (68, 28003, '2018-09-21', '2018-09-22');
insert into locacao (usuario, exemplar, retirada, entrega) values (6, 28003, '2018-10-27', '2018-10-31');
insert into locacao (usuario, exemplar, retirada, entrega) values (68, 28003, '2018-12-12', '2018-12-17');
insert into locacao (usuario, exemplar, retirada, entrega) values (95, 28003, '2019-03-02', '2019-03-13');
insert into locacao (usuario, exemplar, retirada, entrega) values (80, 28004, '2018-04-02', '2018-04-13');
insert into locacao (usuario, exemplar, retirada, entrega) values (83, 28004, '2018-05-27', '2018-06-04');
insert into locacao (usuario, exemplar, retirada, entrega) values (66, 28004, '2018-08-18', '2018-08-23');
insert into locacao (usuario, exemplar, retirada, entrega) values (51, 28004, '2018-10-15', '2018-10-28');
insert into locacao (usuario, exemplar, retirada, entrega) values (64, 28004, '2018-12-04', '2018-12-05');
insert into locacao (usuario, exemplar, retirada, entrega) values (23, 28004, '2019-02-06', '2019-02-15');
insert into locacao (usuario, exemplar, retirada, entrega) values (13, 28004, '2019-02-10', '2019-02-16');
insert into locacao (usuario, exemplar, retirada, entrega) values (58, 28004, '2019-02-12', '2019-02-12');
insert into locacao (usuario, exemplar, retirada, entrega) values (45, 28004, '2019-04-25', '2019-05-02');
insert into locacao (usuario, exemplar, retirada, entrega) values (48, 28005, '2018-01-14', '2018-01-18');
insert into locacao (usuario, exemplar, retirada, entrega) values (22, 28005, '2018-01-29', '2018-02-08');
insert into locacao (usuario, exemplar, retirada, entrega) values (96, 28005, '2018-02-22', '2018-02-22');
insert into locacao (usuario, exemplar, retirada, entrega) values (43, 28005, '2018-04-17', '2018-04-28');
insert into locacao (usuario, exemplar, retirada, entrega) values (65, 28005, '2018-06-22', '2018-07-02');
insert into locacao (usuario, exemplar, retirada, entrega) values (16, 28005, '2018-07-05', '2018-07-16');
insert into locacao (usuario, exemplar, retirada, entrega) values (51, 28005, '2018-09-25', '2018-09-28');
insert into locacao (usuario, exemplar, retirada, entrega) values (13, 28005, '2018-12-10', '2018-12-17');
insert into locacao (usuario, exemplar, retirada, entrega) values (97, 28005, '2018-12-18', '2018-12-24');
insert into locacao (usuario, exemplar, retirada, entrega) values (18, 28005, '2019-03-20', '2019-04-01');
insert into locacao (usuario, exemplar, retirada, entrega) values (73, 28005, '2019-04-26', '2019-05-04');
insert into locacao (usuario, exemplar, retirada, entrega) values (92, 29001, '2018-02-24', '2018-03-06');
insert into locacao (usuario, exemplar, retirada, entrega) values (24, 29001, '2018-04-14', '2018-04-24');
insert into locacao (usuario, exemplar, retirada, entrega) values (36, 29001, '2018-06-17', '2018-06-27');
insert into locacao (usuario, exemplar, retirada, entrega) values (35, 29001, '2018-08-25', '2018-09-07');
insert into locacao (usuario, exemplar, retirada, entrega) values (24, 29001, '2018-09-15', '2018-09-21');
insert into locacao (usuario, exemplar, retirada, entrega) values (92, 29001, '2018-12-01', '2018-12-03');
insert into locacao (usuario, exemplar, retirada, entrega) values (24, 29001, '2019-01-22', '2019-02-02');
insert into locacao (usuario, exemplar, retirada, entrega) values (59, 29001, '2019-01-29', '2019-01-30');
insert into locacao (usuario, exemplar, retirada, entrega) values (32, 29002, '2018-01-14', '2018-01-17');
insert into locacao (usuario, exemplar, retirada, entrega) values (42, 29002, '2018-02-06', '2018-02-08');
insert into locacao (usuario, exemplar, retirada, entrega) values (86, 29002, '2018-05-04', '2018-05-09');
insert into locacao (usuario, exemplar, retirada, entrega) values (14, 29002, '2018-07-24', '2018-08-04');
insert into locacao (usuario, exemplar, retirada, entrega) values (32, 29002, '2018-09-30', '2018-10-11');
insert into locacao (usuario, exemplar, retirada, entrega) values (50, 29002, '2018-12-19', '2018-12-20');
insert into locacao (usuario, exemplar, retirada, entrega) values (34, 29002, '2019-02-23', '2019-03-06');
insert into locacao (usuario, exemplar, retirada, entrega) values (9, 29002, '2019-03-28', '2019-04-09');
insert into locacao (usuario, exemplar, retirada, entrega) values (70, 29003, '2018-01-22', '2018-02-02');
insert into locacao (usuario, exemplar, retirada, entrega) values (17, 29003, '2018-03-15', '2018-03-27');
insert into locacao (usuario, exemplar, retirada, entrega) values (25, 29003, '2018-04-19', '2018-05-02');
insert into locacao (usuario, exemplar, retirada, entrega) values (100, 29003, '2018-04-24', '2018-05-06');
insert into locacao (usuario, exemplar, retirada, entrega) values (96, 29003, '2018-07-10', '2018-07-18');
insert into locacao (usuario, exemplar, retirada, entrega) values (20, 29003, '2018-07-18', '2018-07-20');
insert into locacao (usuario, exemplar, retirada, entrega) values (64, 29003, '2018-08-30', '2018-09-05');
insert into locacao (usuario, exemplar, retirada, entrega) values (12, 29003, '2018-09-20', '2018-09-30');
insert into locacao (usuario, exemplar, retirada, entrega) values (14, 29003, '2018-11-12', '2018-11-25');
insert into locacao (usuario, exemplar, retirada, entrega) values (34, 29003, '2018-12-03', '2018-12-05');
insert into locacao (usuario, exemplar, retirada, entrega) values (75, 29003, '2019-02-27', '2019-03-09');
insert into locacao (usuario, exemplar, retirada, entrega) values (92, 29004, '2018-01-21', '2018-01-22');
insert into locacao (usuario, exemplar, retirada, entrega) values (4, 29004, '2018-03-01', '2018-03-12');
insert into locacao (usuario, exemplar, retirada, entrega) values (73, 29004, '2018-04-20', '2018-04-24');
insert into locacao (usuario, exemplar, retirada, entrega) values (23, 29004, '2018-06-09', '2018-06-11');
insert into locacao (usuario, exemplar, retirada, entrega) values (68, 29004, '2018-08-07', '2018-08-19');
insert into locacao (usuario, exemplar, retirada, entrega) values (49, 29004, '2018-08-17', '2018-08-19');
insert into locacao (usuario, exemplar, retirada, entrega) values (57, 29004, '2018-10-06', '2018-10-07');
insert into locacao (usuario, exemplar, retirada, entrega) values (71, 29004, '2018-10-21', '2018-10-29');
insert into locacao (usuario, exemplar, retirada, entrega) values (17, 29004, '2018-11-02', '2018-11-03');
insert into locacao (usuario, exemplar, retirada, entrega) values (30, 29004, '2019-02-06', '2019-02-17');
insert into locacao (usuario, exemplar, retirada, entrega) values (32, 30001, '2018-02-08', '2018-02-13');
insert into locacao (usuario, exemplar, retirada, entrega) values (96, 30001, '2018-03-17', '2018-03-19');
insert into locacao (usuario, exemplar, retirada, entrega) values (9, 30001, '2018-04-02', '2018-04-02');
insert into locacao (usuario, exemplar, retirada, entrega) values (80, 30001, '2018-06-02', '2018-06-03');
insert into locacao (usuario, exemplar, retirada, entrega) values (86, 30001, '2018-07-24', '2018-08-03');
insert into locacao (usuario, exemplar, retirada, entrega) values (49, 30001, '2018-09-19', '2018-09-26');
insert into locacao (usuario, exemplar, retirada, entrega) values (92, 30001, '2018-10-17', '2018-10-22');
insert into locacao (usuario, exemplar, retirada, entrega) values (58, 30001, '2019-01-11', '2019-01-24');
insert into locacao (usuario, exemplar, retirada, entrega) values (66, 30001, '2019-01-21', '2019-01-31');
insert into locacao (usuario, exemplar, retirada, entrega) values (70, 30001, '2019-02-26', '2019-03-11');
insert into locacao (usuario, exemplar, retirada, entrega) values (74, 30002, '2018-01-12', '2018-01-21');
insert into locacao (usuario, exemplar, retirada, entrega) values (7, 30002, '2018-04-14', '2018-04-26');
insert into locacao (usuario, exemplar, retirada, entrega) values (57, 30002, '2018-04-14', '2018-04-20');
insert into locacao (usuario, exemplar, retirada, entrega) values (56, 30002, '2018-04-15', '2018-04-22');
insert into locacao (usuario, exemplar, retirada, entrega) values (85, 30002, '2018-06-01', '2018-06-04');
insert into locacao (usuario, exemplar, retirada, entrega) values (23, 30002, '2018-06-22', '2018-06-28');
insert into locacao (usuario, exemplar, retirada, entrega) values (52, 30002, '2018-07-14', '2018-07-26');
insert into locacao (usuario, exemplar, retirada, entrega) values (49, 30002, '2018-08-01', '2018-08-02');
insert into locacao (usuario, exemplar, retirada, entrega) values (52, 30002, '2018-08-16', '2018-08-19');
insert into locacao (usuario, exemplar, retirada, entrega) values (76, 30002, '2018-10-02', '2018-10-06');
insert into locacao (usuario, exemplar, retirada, entrega) values (8, 30002, '2018-12-19', '2018-12-29');
insert into locacao (usuario, exemplar, retirada, entrega) values (60, 30002, '2019-02-05', '2019-02-15');
insert into locacao (usuario, exemplar, retirada, entrega) values (75, 30002, '2019-04-21', '2019-04-26');
insert into locacao (usuario, exemplar, retirada, entrega) values (67, 30003, '2018-03-26', '2018-04-03');
insert into locacao (usuario, exemplar, retirada, entrega) values (54, 30003, '2018-04-06', '2018-04-06');
insert into locacao (usuario, exemplar, retirada, entrega) values (9, 30003, '2018-05-28', '2018-06-04');
insert into locacao (usuario, exemplar, retirada, entrega) values (64, 30003, '2018-07-24', '2018-07-25');
insert into locacao (usuario, exemplar, retirada, entrega) values (16, 30003, '2018-08-05', '2018-08-12');
insert into locacao (usuario, exemplar, retirada, entrega) values (49, 30003, '2018-11-01', '2018-11-09');
insert into locacao (usuario, exemplar, retirada, entrega) values (52, 30003, '2019-02-02', '2019-02-10');
insert into locacao (usuario, exemplar, retirada, entrega) values (12, 30003, '2019-04-19', '2019-04-25');
insert into locacao (usuario, exemplar, retirada, entrega) values (83, 30004, '2018-03-26', '2018-04-02');
insert into locacao (usuario, exemplar, retirada, entrega) values (68, 30004, '2018-05-31', '2018-06-07');
insert into locacao (usuario, exemplar, retirada, entrega) values (12, 30004, '2018-07-18', '2018-07-30');
insert into locacao (usuario, exemplar, retirada, entrega) values (10, 30004, '2018-10-16', '2018-10-25');
insert into locacao (usuario, exemplar, retirada, entrega) values (24, 30004, '2018-11-03', '2018-11-06');
insert into locacao (usuario, exemplar, retirada, entrega) values (98, 30004, '2018-11-11', '2018-11-13');
insert into locacao (usuario, exemplar, retirada, entrega) values (78, 30004, '2019-01-11', '2019-01-12');
insert into locacao (usuario, exemplar, retirada, entrega) values (18, 30004, '2019-01-17', '2019-01-22');
insert into locacao (usuario, exemplar, retirada, entrega) values (39, 30004, '2019-03-09', '2019-03-20');
insert into locacao (usuario, exemplar, retirada, entrega) values (66, 30005, '2018-03-05', '2018-03-09');
insert into locacao (usuario, exemplar, retirada, entrega) values (83, 30005, '2018-03-27', '2018-04-09');
insert into locacao (usuario, exemplar, retirada, entrega) values (50, 30005, '2018-05-20', '2018-05-21');
insert into locacao (usuario, exemplar, retirada, entrega) values (26, 30005, '2018-05-27', '2018-06-02');
insert into locacao (usuario, exemplar, retirada, entrega) values (33, 30005, '2018-06-01', '2018-06-02');
insert into locacao (usuario, exemplar, retirada, entrega) values (75, 30005, '2018-06-03', '2018-06-13');
insert into locacao (usuario, exemplar, retirada, entrega) values (16, 30005, '2018-08-19', '2018-08-29');
insert into locacao (usuario, exemplar, retirada, entrega) values (19, 30005, '2018-09-06', '2018-09-13');
insert into locacao (usuario, exemplar, retirada, entrega) values (79, 30005, '2018-09-08', '2018-09-10');
insert into locacao (usuario, exemplar, retirada, entrega) values (75, 30005, '2018-10-03', '2018-10-13');
insert into locacao (usuario, exemplar, retirada, entrega) values (9, 30005, '2018-10-20', '2018-10-23');
insert into locacao (usuario, exemplar, retirada, entrega) values (99, 30005, '2019-01-13', '2019-01-18');
insert into locacao (usuario, exemplar, retirada, entrega) values (12, 30005, '2019-02-10', '2019-02-13');
insert into locacao (usuario, exemplar, retirada, entrega) values (92, 30005, '2019-04-21', '2019-04-30');
insert into locacao (usuario, exemplar, retirada) values (50, 1005, '2019-05-01');
insert into locacao (usuario, exemplar, retirada) values (13, 2001, '2019-05-08');
insert into locacao (usuario, exemplar, retirada) values (67, 5001, '2019-05-05');
insert into locacao (usuario, exemplar, retirada) values (45, 8001, '2019-05-11');
insert into locacao (usuario, exemplar, retirada) values (96, 12002, '2019-05-01');
insert into locacao (usuario, exemplar, retirada) values (49, 13003, '2019-05-04');
insert into locacao (usuario, exemplar, retirada) values (91, 15003, '2019-05-01');
insert into locacao (usuario, exemplar, retirada) values (53, 16003, '2019-05-05');
insert into locacao (usuario, exemplar, retirada) values (66, 16004, '2019-05-05');
insert into locacao (usuario, exemplar, retirada) values (88, 17001, '2019-05-06');
insert into locacao (usuario, exemplar, retirada) values (60, 18001, '2019-05-02');
insert into locacao (usuario, exemplar, retirada) values (77, 19001, '2019-05-11');
insert into locacao (usuario, exemplar, retirada) values (71, 21001, '2019-05-08');
insert into locacao (usuario, exemplar, retirada) values (18, 21002, '2019-05-05');
insert into locacao (usuario, exemplar, retirada) values (34, 22002, '2019-05-05');
insert into locacao (usuario, exemplar, retirada) values (10, 23001, '2019-05-04');
insert into locacao (usuario, exemplar, retirada) values (99, 25001, '2019-05-10');
insert into locacao (usuario, exemplar, retirada) values (72, 28001, '2019-05-07');
insert into locacao (usuario, exemplar, retirada) values (37, 28005, '2019-05-10');
insert into locacao (usuario, exemplar, retirada) values (11, 29004, '2019-05-10');
insert into locacao (usuario, exemplar, retirada) values (36, 30001, '2019-05-02');
insert into locacao (usuario, exemplar, retirada) values (77, 30003, '2019-05-02');

----------------------------------------------------------------------------------------------------

--1) Mostrar o título dos livros sobre PostgreSQL não locados por alunos do Curso Superior de Tecnologia em Análise e Desenvolvimento de Sistemas.
--2) Mostrar o nome do último aluno que locou o livro PostgreSQL na prática.
--3) Mostrar o título dos livros sobre PostgreSQL menos locados.
--4) Mostrar o nome dos alunos e dos professores que locaram mais livros em março de 2018.

