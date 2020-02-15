
drop table pizzasabor;
drop table ingredientesabor;
drop table pizza;
drop table comanda;
drop table sabor;
drop table ingrediente;
drop table tamanho;
drop table mesa; -- sempre quando for excluir fazer na ordem inversa de criação

create table mesa (
    codigo integer NOT NULL CHECK (codigo > 0),
    nome varchar(50) NOT NULL,
    primary key (codigo)
);

CREATE TABLE tamanho ( 
    codigo integer not null check (codigo > 0), 
    nome char(1) not null default 'P' check ((nome = 'P') or (nome = 'M') or (nome = 'G') or (nome = 'F')) ,
    qtdesabores integer not null default 1 check ((qtdesabores > 0) and (qtdesabores <= 6)),
    primary key(codigo)
);

create table ingrediente (
    codigo integer NOT NULL CHECK (codigo > 0),
    nome varchar(50) NOT NULL,
    primary key (codigo)
);

create table sabor (
    codigo integer NOT NULL CHECK (codigo > 0),
    nome varchar(50) NOT NULL,
    preco real not null check (preco > 0),
    primary key (codigo)
);

create table comanda (
    codigo integer not null check (codigo > 0),
    codigomesa integer REFERENCES mesa(codigo),
    pago boolean not null default false,
    pagamento timestamp default null check (pagamento <= now()),
    primary key (codigo)
);

create table pizza(
     codigo integer not null check (codigo > 0),
     codigocomanda integer REFERENCES comanda(codigo),
     codigotamanho integer REFERENCES tamanho(codigo),
     primary key (codigo)
);

create table ingredientesabor(
    codigosabor integer REFERENCES sabor(codigo),
    codigoingrediente integer REFERENCES ingrediente(codigo),
    primary key (codigosabor, codigoingrediente)
);

create table pizzasabor(
    codigosabor integer REFERENCES sabor(codigo),
    codigopizza integer REFERENCES pizza(codigo),
    primary key (codigosabor, codigopizza)
);


insert into mesa (codigo, nome) values (1, 'mesa 1');
insert into mesa (codigo, nome) values (2, 'mesa 2');
insert into mesa (codigo, nome) values (3, 'mesa 5');
insert into mesa (codigo, nome) values (6, 'mesa 7');
insert into mesa (codigo, nome) values (7, 'mesa 3');
insert into mesa (codigo, nome) values (8, 'mesa 4');
insert into mesa (codigo, nome) values (10, 'mesa 6');

insert into tamanho (codigo, nome, qtdesabores) values (1, 'P', 2);
insert into tamanho (codigo, nome, qtdesabores) values (2, 'M', 2);
insert into tamanho (codigo, nome, qtdesabores) values (4, 'G', 4);
insert into tamanho (codigo, nome, qtdesabores) values (7, 'F', 6);

insert into ingrediente (codigo, nome) values (1, 'molho de tomate');
insert into ingrediente (codigo, nome) values (2, 'queijo parmesao');
insert into ingrediente (codigo, nome) values (3, 'queijo gorgonzola');
insert into ingrediente (codigo, nome) values (4, 'queijo mussarela');
insert into ingrediente (codigo, nome) values (5, 'tomate');
insert into ingrediente (codigo, nome) values (6, 'cebola');
insert into ingrediente (codigo, nome) values (7, 'milho');
insert into ingrediente (codigo, nome) values (8, 'bacon');
insert into ingrediente (codigo, nome) values (9, 'galinha');
insert into ingrediente (codigo, nome) values (10, 'calabresa');


insert into sabor (codigo, nome, preco) values (1, 'queijo mussarela', 40.00);
insert into sabor (codigo, nome, preco) values (2, 'tres queijos',55.00);
insert into sabor (codigo, nome, preco) values (3, 'frango', 65.00);

insert into ingredientesabor(codigosabor, codigoingrediente) values (1,1); -- o sabor 1(queijo mussarela tem o ingrediente 1 (moho de tomate)
insert into ingredientesabor(codigosabor, codigoingrediente) values (1,4); -- o sabor 1(queijo mussarela tem o ingrediente 4 (queijo mussarela)
insert into ingredientesabor(codigosabor, codigoingrediente) values (2,1);
insert into ingredientesabor(codigosabor, codigoingrediente) values (2,2);
insert into ingredientesabor(codigosabor, codigoingrediente) values (2,3);
insert into ingredientesabor(codigosabor, codigoingrediente) values (2,4);
insert into ingredientesabor(codigosabor, codigoingrediente) values (3,1);
insert into ingredientesabor(codigosabor, codigoingrediente) values (3,9);
insert into ingredientesabor(codigosabor, codigoingrediente) values (3,7);
insert into ingredientesabor(codigosabor, codigoingrediente) values (3,4);

insert into comanda (codigo, codigomesa) values (1, 6); -- como pago e pagamento possuem valores default não preciso passar ele quando adiciono


insert into pizza (codigo, codigocomanda, codigotamanho) values (3, 1, 7);

insert into pizzasabor (codigopizza, codigosabor) values (3, 2);
insert into pizzasabor (codigopizza, codigosabor) values (3, 3);















