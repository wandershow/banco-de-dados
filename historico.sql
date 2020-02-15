create table historico

drop table alunodisciplina
drop table cursodisciplina
drop table aluno
drop table disciplina
drop table curso


create table curso(
    codigo integer not null check (codigo > 0);
    nome varchar(50) not null;
    primary key (codigo);
);

insert into curso (codigo, nome) values (1123, 'TADS');
insert into curso (codigo, nome) values (9999, 'TCE');

create table disciplina(
    codigo integer not null check (codigo > 0),
    nome varchar(50) not null,
    carga_horaria real not null,
    primary key (codigo)
);

insert into disciplina (codigo, nome, carga_horaria) values (2, 'logica de programacao' 150);
insert into disciplina (codigo, nome, carga_horaria) values (5, 'fundamentos de matematica discreta' 50);
insert into disciplina (codigo, nome, carga_horaria) values (10, 'programacao orientada a objetos' 100);
insert into disciplina (codigo, nome, carga_horaria) values (13, 'bancos de dados' 116.67);

create table aluno(
    matricula char(8) not null, 
    nome varchar(50) not null,
    cpf char(11) not null,
    rg varchar(20) not null,
    nascimento date not null check( nascimento < now()),
    naturalidade varchar(30) not null,
    nacionalidade varchar(30) not null,
    filiacao varchar(100) not null,
    genero char(1) not null default 'M' check((genero = 'M') or (genero = 'F')),
    obrigacao_eleitoral boolean not null,
    obrigacao_militar boolean,
    ingresso date not null default now() check (ingresso <= now()),
    conclusao date check (conclusao <= now()),
    situacao_academica char(1) not null default 'R' check (( situacao_academica = 'R') or (situacao_academica = 'E') or
    (situacao_academica = 'E')), 
    forma_ingresso varchar(10) not null check ((formaingresso = 'enem') or (forma_ingresso = 'vestibular')),
    primary key (matricula);     
);

insert into aluno values ('11230320', 'Marina', '03445175004', '999999999999', '1996-02-11', 'rio grande', 'brasileira', 'maria, rui', 'F', true, null, '2018-07-15', null, 'R', 'vestibular'); 
insert into aluno values ('11230285', 'Borges', '03445175004', '888888888888', '1996-02-11', 'rio grande', 'brasileira', 'maria, rui', 'F', true, null, '2018-07-15', null, 'R', 'vestibular'); 


create table cursodisciplina(
    codigocurso integer references curso(codigo),
    codigodisciplina integer references disciplina(codigo),
    posicaoqsl integer not null check(posicaoqsl > 0),
    primary key(codigocurso, codigodisciplina)
);

insert into cursodisciplina (codigocurso, codigodisciplina, posicaoqsl) values (1123, 2, 1)
insert into cursodisciplina (codigocurso, codigodisciplina, posicaoqsl) values (1123, 5, 1)
insert into cursodisciplina (codigocurso, codigodisciplina, posicaoqsl) values (1123, 10, 2)
insert into cursodisciplina (codigocurso, codigodisciplina, posicaoqsl) values (1123, 13, 2)



create table alunodisciplina(
    matriculaaluno char(8) references aluno(matricula),
    codigocurso integer references curso(codigo),
    codigodisciplina integer references disciplina(codigo),
    semestre char(6) not null,
    frequencia real not null check(frequencia >= 0), 
    nota real not null check ((nota >= 0) and (nota <= 10)),
    situacao varchar(3) not null check((situacao = 'APR') or (situacao = 'REP') or (situacao = 'TRA') or (situacao = 'RPF')  or (situacao = 'MAT') or (situacao = 'AE')),
    primary key (matriculaaluno, codigocurso, codigodisciplina, semestre)
);

insert into alunodisciplina values ('11230320', 1123, 2, '2018-2', 85.6, 5.7, 'APR')
insert into alunodisciplina values ('11230320', 1123, 5, '2018-2', 76.9, 8.9, 'AE')
insert into alunodisciplina values ('11230320', 1123, 10, '2019-1', 0, 0, 'MAT')
insert into alunodisciplina values ('11230320', 1123, 13, '2019-1', 0, 0, 'MAT')

insert into alunodisciplina values ('11230285', 1123, 2, '2018-1', 85.3, 7.6, 'APR')
insert into alunodisciplina values ('11230320', 1123, 5, '2018-1', 80.2, 5.6, 'APR')
insert into alunodisciplina values ('11230320', 1123, 10, '2018-2', 100, 9.5, 'APR')
insert into alunodisciplina values ('11230320', 1123, 13, '2018-2', 100, 4.6, 'REP')
insert into alunodisciplina values ('11230320', 1123, 13, '2018-2', 0, 0, 'MAT')



























