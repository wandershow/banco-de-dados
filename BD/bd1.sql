DROP TABLE pessoa;

create table pessoa ( 
	cpf CHAR(11) NOT NULL,
	nome VARCHAR(100)NOT NULL,
	nascimento DATE NOT NULL CHECK nascimento <= NOW(),
	genero char(1) NOT NULL DEFAULT 'M' CHECK ((genero = 'M') OR (genero = 'F')),
	PRIMARY KEY (cpf)
);
