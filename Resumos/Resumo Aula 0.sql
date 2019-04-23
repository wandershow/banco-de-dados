Create database pizzaria;
\c pizzaria

--Você cria as tabela em uma ordem das que não tem alguma FK.
--Na hora de criar tabelas que tem FK tem q ver se já criou a tabela q ela usa/puxa a PK.
--Apagar vai ser ao contrário, pois pode quase certamente dar erro, exemplo:
[
mesa
	codigo
	pk codigo

clientemesa
	fk codigo	
]
--Se apagar tabela mesa, na hora de apagar clientemesa vai dar erro pq a tabela tem um pk com erro (ele perde a referencia pois
-- deletou a tabela).

drop table pizzasabor;
drop table ingredientesabor;
drop table pizza;
drop table comanda;
drop table sabor;
drop table ingrediente;
drop table tamanho;
drop table mesa;

create table mesa (
	codigo int NOT NULL check (codigo > 0),
	Nome varchar(100) not null,
	primary key(codigo)
);

Create table tamanho (
	codigo int not null check (codigo > 0),
	nome char(1) not null default 'P' check ((nome = 'P') or (nome = 'M') or (nome = 'G') or (nome = 'F')),
	qtdesabores integer not null default 1 check ((qtdesabores > 0) and (qtdesabores <= 6)),
	primary key (codigo)
);

create table ingrediente (
	codigo int NOT NULL check (codigo > 0),
	Nome varchar(100) not null,
	primary key(codigo)
);

create table sabor (
	codigo int NOT NULL check (codigo > 0),
	Nome varchar(100) not null,
	preco real not null check (preco >= 0),
	primary key(codigo)
);

create table comanda (
	codigo int NOT NULL check (codigo > 0),
	codigomesa int references mesa(codigo),
	pago boolean not null default false,
	pagamento timestamp default NULL check (pagamento >= now()),
	primary key(codigo)
);

create table pizza (
	codigo int NOT NULL check (codigo > 0),
	codigocomanda int references comanda(codigo),
	codigotamanho int references tamanho(codigo),
	pago boolean not null default false,
	primary key(codigo)
);

create table ingredientesabor (
	codigosabor int references sabor(codigo),
	codigoingrediente int references ingrediente(codigo),
	primary key(codigosabor, codigoingrediente)
);

create table pizzasabor (
	codigopizza int references pizza(codigo),
	codigosabor int references sabor(codigo),
	primary key(codigopizza, codigosabor)
);

--Botando dados nas tabelas

Insert into mesa (codigo, nome) values (1, 'mesa 1');
Insert into mesa (codigo, nome) values (2, 'mesa 2');
Insert into mesa (codigo, nome) values (3, 'mesa 5');
Insert into mesa (codigo, nome) values (6, 'mesa 7');
Insert into mesa (codigo, nome) values (7, 'mesa 3');
Insert into mesa (codigo, nome) values (8, 'mesa 4');
Insert into mesa (codigo, nome) values (10, 'mesa 6');

Insert into tamanho (codigo, nome, qtdesabores) values (1, 'P', 2);
Insert into tamanho (codigo, nome, qtdesabores) values (2, 'M', 2);
Insert into tamanho (codigo, nome, qtdesabores) values (4, 'G', 4);
Insert into tamanho (codigo, nome, qtdesabores) values (7, 'F', 6);

Insert into ingrediente (codigo, nome) values (1, 'molho de tomate');
Insert into ingrediente (codigo, nome) values (2, 'queijo parmesao');
Insert into ingrediente (codigo, nome) values (3, 'queijo parmesao');
Insert into ingrediente (codigo, nome) values (4, 'queijo gorgonzola');
Insert into ingrediente (codigo, nome) values (5, 'queijo mussarela');
Insert into ingrediente (codigo, nome) values (6, 'tomate');
Insert into ingrediente (codigo, nome) values (7, 'milho');
Insert into ingrediente (codigo, nome) values (8, 'bacon');
Insert into ingrediente (codigo, nome) values (9, 'galinha');
Insert into ingrediente (codigo, nome) values (10, 'calabresa');

Insert into sabor (codigo, nome, preco) values (1, 'queijo mussarela', 40.00);
Insert into sabor (codigo, nome, preco) values (2, 'tres queijos', 55.00);
Insert into sabor (codigo, nome, preco) values (3, 'frango', 65.00);

Insert into comanda (codigo, codigomesa) values (1, 6);

Insert into ingredientesabor (codigosabor, codigoingrediente) values (1, 1); --o sabor 1 tem o ingrediente 1
Insert into ingredientesabor (codigosabor, codigoingrediente) values (1, 4); --o sabor 1 também tem o ingrdiente 4
Insert into ingredientesabor (codigosabor, codigoingrediente) values (2, 1);
Insert into ingredientesabor (codigosabor, codigoingrediente) values (2, 2);
Insert into ingredientesabor (codigosabor, codigoingrediente) values (2, 3);
Insert into ingredientesabor (codigosabor, codigoingrediente) values (2, 4);
Insert into ingredientesabor (codigosabor, codigoingrediente) values (3, 1);
Insert into ingredientesabor (codigosabor, codigoingrediente) values (3, 9);
Insert into ingredientesabor (codigosabor, codigoingrediente) values (3, 7);
Insert into ingredientesabor (codigosabor, codigoingrediente) values (3, 4);

insert into pizza (codigo, codigocomanda, codigotamanho) values (3, 1, 7);

insert into pizzasabor (codigopizza, codigosabor) values (3, 2);
insert into pizzasabor (codigopizza, codigosabor) values (3, 3);

-- atualizando a comanda, falando que ela foi paga.
update comanda set pago = true, pagamento = now() where codigo = 1;

Anotações:

NOT NULL ela não pode ser nula/vazia
"check (codigo > 0)" além de não ser null ele tem q ser positivo.
default 'P' caso não tenha um valor vai por 'P'
references nome_tabela(nome_atributo/dado)   ||  references pessoa(cpf)
timestamp default now() check (pagamento <= now())  ele pega dia e hora do sistema naquele momento e verifica se é no momento.
Para por um dado na tabela você usa "insert into" e diz os valores "values", não precisa ser na ordem ex:
[
Insert into mesa (codigo, nome) values (1, 'mesa 1');
xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
Insert into mesa (nome, codigo) values ('mesa 1', 1);
]
Na hora de por dados nas tabelas, os que não forem preenchido e tiverem default, o banco vai por o valor que foi posto no default


xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx

Banco do HistoricoEscolar

DROP TABLE AlunoDisciplina;
DROP TABLE CursoDisciplina;
DROP TABLE Disciplina;
DROP TABLE Curso;
DROP TABLE Aluno;

Create Table Aluno(
	Matricula char(8) not null,
	Nome varchar(50) not null,
	CPF char(11) not null,
	RG varchar(20) not null,
	Nascimento date not null check (nascimento <= now()),
	Naturalidade varchar(50) not null,
	Nacionalidade varchar(50) not null,
	Filiacao varchar(100) not null,
	Genero char(1) not null check ((genero = 'M') or (Genero = 'F')),
	ObrigacaoEleitoral boolean,
	ObrigacaoMilitar boolean,
	DataIngresso date not null default now() check (DataIngresso <= now()),
	DataConclusao date check ( DataConclusao <= NOW()),
	SituacaoAcademica char(1) not null default 'R' check ((SituacaoAcademica = 'R') or (SituacaoAcademica = 'T') or (SituacaoAcademica = 'E')),
	FormaIngresso varchar(20) not null check ((FormaIngresso = 'enem') or (FormaIngresso 'vestibular')),
	primary key (Matricula)
);

Create Table Curso(
	Codigo integer not null check (codigo > 0),
	Nome varchar(50) not null,
	primary key (codigo)
);

Create Table Disciplina(
	Codigo int not null check (codigo > 0),
	Nome varchar(50) not null,
	Cargahoraria real not null check (Cargahoraria > 0),
	primary key (Codigo)
);

Create Table CursoDisciplina(
	CodigoCurso int references Curso(Codigo),
	CodigoDisciplina int references Disciplina(Codigo),
	PosicaoQSL int not null check (posicaoqsl > 0),
	primary key (CodigoCurso, CodigoDisciplina)
);

Create Table AlunoDisciplina(
	MatriculaAluno char(8) references Aluno(Matricula),
	CodigoCurso int references Curso(Codigo),
	CodigoDisciplina int references Disciplina(Codigo),
	Semestre char(6) not null,
	Frequencia real not null check (Frequencia >= 0),
	Nota real not null check ((nota >= 0) and (nota <= 10)),
	Situacao varchar(3) not null ((Situacao ='MAT') or (Situacao ='APR') or (Situacao ='REP') or (Situacao ='TRA') or (Situacao ='RPF') or (Situacao ='AE')),
	primary key (MatriculaAluno, CodigoCurso, CodigoDisciplina, Semestre)
);

Insert Into curso (Codigo, Nome) values (1123, 'TADS');
Insert Into curso (Codigo, Nome) values (999, 'TCE');

Insert Into Disciplina (Codigo, Nome, CargaHoraria) values (2, 'logica de programacao', 150);
Insert Into Disciplina (Codigo, Nome, CargaHoraria) values (5, 'fundamentos de matematica discreta', 50);
Insert Into Disciplina (Codigo, Nome, CargaHoraria) values (10, 'programacao orientada a objeto', 100);
Insert Into Disciplina (Codigo, Nome, CargaHoraria) values (13, 'banco de dados', 116.67);

Insert Into Aluno (Matricula, Nome, CPF, RG, Nascimento, Naturalidade, Nacionalidade, Filiacao, Genero, ObrigacaoEleitoral,
	ObrigacaoMilitar, Ingresso, Conclusao, SituacaoAcademica, FormaIngresso) values ('11230320', 'Marina', '03445175004', '9a99999999',
	'1996-02-11', 'Rio Grande', 'brasileira', 'Maria, Rui', 'F', true, null, '2018-07-15', 'R', 'vestibular');

Insert Into Aluno (Matricula, Nome, CPF, RG, Nascimento, Naturalidade, Nacionalidade, Filiacao, Genero, ObrigacaoEleitoral,
	ObrigacaoMilitar, Ingresso, Conclusao, SituacaoAcademica, FormaIngresso) values ('11230285', 'Borges', '03819881042', '9b99999999',
	'2000-05-10', 'Rio Grande', 'brasileira', 'Lucerema, Adalberto', 'M', true, true, '2018-01-15', 'R', 'vestibular');

Insert into CursoDisciplina (CodigoCurso, CodigoDisciplina, PosicaoQSL) values (1123, 2,1);
Insert into CursoDisciplina (CodigoCurso, CodigoDisciplina, PosicaoQSL) values (1123, 5,1);
Insert into CursoDisciplina (CodigoCurso, CodigoDisciplina, PosicaoQSL) values (1123, 10,2);
Insert into CursoDisciplina (CodigoCurso, CodigoDisciplina, PosicaoQSL) values (1123, 13,2);

Insert into AlunoDisciplina (MatriculaAluno,CodigoCurso,CodigoDisciplina,Semestre,Frequencia,Nota,Situacao) values ('11230320', 1123, 2, '2018-2', 85.6, 5.7, 'APR');
Insert into AlunoDisciplina (MatriculaAluno,CodigoCurso,CodigoDisciplina,Semestre,Frequencia,Nota,Situacao) values ('11230320', 1123, 5, '2018-2', 76.9, 8.9, 'AE');
Insert into AlunoDisciplina (MatriculaAluno,CodigoCurso,CodigoDisciplina,Semestre,Frequencia,Nota,Situacao) values ('11230320', 1123, 10, '2019-1', 0, 0, 'MAT');
Insert into AlunoDisciplina (MatriculaAluno,CodigoCurso,CodigoDisciplina,Semestre,Frequencia,Nota,Situacao) values ('11230320', 1123, 13, '2019-1', 0, 0, 'MAT');


Insert into AlunoDisciplina (MatriculaAluno,CodigoCurso,CodigoDisciplina,Semestre,Frequencia,Nota,Situacao) values ('11230285', 1123, 2, '2018-1', 85.3, 7.6, 'APR');
Insert into AlunoDisciplina (MatriculaAluno,CodigoCurso,CodigoDisciplina,Semestre,Frequencia,Nota,Situacao) values ('11230285', 1123, 5, '2018-1', 76.9, 5.6, 'APR');
Insert into AlunoDisciplina (MatriculaAluno,CodigoCurso,CodigoDisciplina,Semestre,Frequencia,Nota,Situacao) values ('11230285', 1123, 10, '2018-2', 100, 9.5, 'APR');
Insert into AlunoDisciplina (MatriculaAluno,CodigoCurso,CodigoDisciplina,Semestre,Frequencia,Nota,Situacao) values ('11230285', 1123, 13, '2018-2', 100, 4.6, 'REP');
Insert into AlunoDisciplina (MatriculaAluno,CodigoCurso,CodigoDisciplina,Semestre,Frequencia,Nota,Situacao) values ('11230285', 1123, 13, '2019-1', 0, 0, 'MAT');

