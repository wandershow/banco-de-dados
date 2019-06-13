DROP TABLE CARGOEMPREGADO;
DROP TABLE DEPTOEMPREGADO;
DROP TABLE EMPREGADO;
DROP TABLE CARGO;
DROP TABLE DEPTO;

CREATE TABLE DEPTO (
	CODIGO INTEGER NOT NULL,
	NOME VARCHAR(100) NOT NULL,
	PRIMARY KEY (CODIGO)
);

CREATE TABLE CARGO (
	CODIGO INTEGER NOT NULL,
	DESCRICAO VARCHAR(100) NOT NULL,
	SALARIO REAL NOT NULL,
	PRIMARY KEY (CODIGO)
);

CREATE TABLE EMPREGADO (
	CODIGO INTEGER NOT NULL,
	NOME VARCHAR(100) NOT NULL,
	GENERO CHAR(1) NOT NULL,
	NASCIMENTO DATE NOT NULL,
	PRIMARY KEY (CODIGO)
);

CREATE TABLE DEPTOEMPREGADO (
	DEPTO INTEGER REFERENCES DEPTO(CODIGO),
	EMPREGADO INTEGER REFERENCES EMPREGADO(CODIGO),
	INICIO DATE NOT NULL
);

CREATE TABLE CARGOEMPREGADO (
	CARGO INTEGER REFERENCES CARGO(CODIGO),
	EMPREGADO INTEGER REFERENCES EMPREGADO(CODIGO),
	INICIO DATE NOT NULL
);

INSERT INTO DEPTO VALUES (1, 'DEPTO 1');
INSERT INTO DEPTO VALUES (2, 'DEPTO 2');
INSERT INTO DEPTO VALUES (3, 'DEPTO 3');
INSERT INTO DEPTO VALUES (4, 'DEPTO 4');
INSERT INTO DEPTO VALUES (5, 'DEPTO 5');

INSERT INTO CARGO VALUES (1, 'CARGO 1', 500);
INSERT INTO CARGO VALUES (2, 'CARGO 2', 800);
INSERT INTO CARGO VALUES (3, 'CARGO 3', 1100);
INSERT INTO CARGO VALUES (4, 'CARGO 4', 1400);
INSERT INTO CARGO VALUES (5, 'CARGO 5', 1700);
INSERT INTO CARGO VALUES (6, 'CARGO 6', 2000);
INSERT INTO CARGO VALUES (7, 'CARGO 7', 2300);
INSERT INTO CARGO VALUES (8, 'CARGO 8', 2600);
INSERT INTO CARGO VALUES (9, 'CARGO 9', 2900);
INSERT INTO CARGO VALUES (10, 'CARGO 10', 3200);

INSERT INTO EMPREGADO VALUES (1, 'EMPREGADO 1', 'M', '1930-03-19');
INSERT INTO EMPREGADO VALUES (2, 'EMPREGADO 2', 'F', '2012-11-24');
INSERT INTO EMPREGADO VALUES (3, 'EMPREGADO 3', 'M', '1901-10-09');
INSERT INTO EMPREGADO VALUES (4, 'EMPREGADO 4', 'F', '2013-08-11');
INSERT INTO EMPREGADO VALUES (5, 'EMPREGADO 5', 'M', '1911-12-19');
INSERT INTO EMPREGADO VALUES (6, 'EMPREGADO 6', 'F', '1956-07-24');
INSERT INTO EMPREGADO VALUES (7, 'EMPREGADO 7', 'M', '2000-08-09');
INSERT INTO EMPREGADO VALUES (8, 'EMPREGADO 8', 'M', '1926-07-16');
INSERT INTO EMPREGADO VALUES (9, 'EMPREGADO 9', 'M', '1943-12-04');
INSERT INTO EMPREGADO VALUES (10, 'EMPREGADO 10', 'F', '1996-09-18');
INSERT INTO EMPREGADO VALUES (11, 'EMPREGADO 11', 'F', '2003-01-13');
INSERT INTO EMPREGADO VALUES (12, 'EMPREGADO 12', 'M', '1914-11-11');
INSERT INTO EMPREGADO VALUES (13, 'EMPREGADO 13', 'F', '2006-04-23');
INSERT INTO EMPREGADO VALUES (14, 'EMPREGADO 14', 'F', '1981-05-27');
INSERT INTO EMPREGADO VALUES (15, 'EMPREGADO 15', 'F', '1924-04-09');
INSERT INTO EMPREGADO VALUES (16, 'EMPREGADO 16', 'F', '1965-10-03');
INSERT INTO EMPREGADO VALUES (17, 'EMPREGADO 17', 'F', '1946-09-03');
INSERT INTO EMPREGADO VALUES (18, 'EMPREGADO 18', 'M', '1938-09-26');
INSERT INTO EMPREGADO VALUES (19, 'EMPREGADO 19', 'F', '1912-02-01');
INSERT INTO EMPREGADO VALUES (20, 'EMPREGADO 20', 'F', '1940-11-18');
INSERT INTO EMPREGADO VALUES (21, 'EMPREGADO 21', 'M', '1992-07-18');
INSERT INTO EMPREGADO VALUES (22, 'EMPREGADO 22', 'F', '1953-04-01');
INSERT INTO EMPREGADO VALUES (23, 'EMPREGADO 23', 'M', '1915-01-20');
INSERT INTO EMPREGADO VALUES (24, 'EMPREGADO 24', 'F', '1921-07-05');
INSERT INTO EMPREGADO VALUES (25, 'EMPREGADO 25', 'M', '1930-08-20');
INSERT INTO EMPREGADO VALUES (26, 'EMPREGADO 26', 'M', '1983-05-02');
INSERT INTO EMPREGADO VALUES (27, 'EMPREGADO 27', 'F', '1919-05-22');
INSERT INTO EMPREGADO VALUES (28, 'EMPREGADO 28', 'F', '1928-01-26');
INSERT INTO EMPREGADO VALUES (29, 'EMPREGADO 29', 'M', '1950-03-26');
INSERT INTO EMPREGADO VALUES (30, 'EMPREGADO 30', 'M', '1991-08-28');

INSERT INTO DEPTOEMPREGADO VALUES (4, 1, '2009-07-01');
INSERT INTO DEPTOEMPREGADO VALUES (3, 2, '1990-05-23');
INSERT INTO DEPTOEMPREGADO VALUES (2, 3, '2002-07-20');
INSERT INTO DEPTOEMPREGADO VALUES (1, 4, '2014-12-20');
INSERT INTO DEPTOEMPREGADO VALUES (1, 5, '2003-03-23');
INSERT INTO DEPTOEMPREGADO VALUES (2, 6, '2012-12-15');
INSERT INTO DEPTOEMPREGADO VALUES (2, 7, '1993-06-26');
INSERT INTO DEPTOEMPREGADO VALUES (4, 8, '2005-02-21');
INSERT INTO DEPTOEMPREGADO VALUES (1, 9, '2003-05-16');
INSERT INTO DEPTOEMPREGADO VALUES (2, 10, '2006-12-18');
INSERT INTO DEPTOEMPREGADO VALUES (1, 11, '2008-07-19');
INSERT INTO DEPTOEMPREGADO VALUES (1, 12, '2003-02-21');
INSERT INTO DEPTOEMPREGADO VALUES (4, 13, '1991-09-21');
INSERT INTO DEPTOEMPREGADO VALUES (2, 14, '2013-07-05');
INSERT INTO DEPTOEMPREGADO VALUES (4, 15, '1992-08-27');
INSERT INTO DEPTOEMPREGADO VALUES (5, 16, '2002-09-04');
INSERT INTO DEPTOEMPREGADO VALUES (4, 17, '2002-11-11');
INSERT INTO DEPTOEMPREGADO VALUES (4, 18, '1993-09-27');
INSERT INTO DEPTOEMPREGADO VALUES (4, 19, '2007-05-01');
INSERT INTO DEPTOEMPREGADO VALUES (5, 20, '2006-07-17');
INSERT INTO DEPTOEMPREGADO VALUES (4, 21, '1996-04-28');
INSERT INTO DEPTOEMPREGADO VALUES (4, 22, '1993-12-08');
INSERT INTO DEPTOEMPREGADO VALUES (2, 23, '2013-09-13');
INSERT INTO DEPTOEMPREGADO VALUES (1, 24, '1995-11-07');
INSERT INTO DEPTOEMPREGADO VALUES (1, 25, '2013-01-16');
INSERT INTO DEPTOEMPREGADO VALUES (2, 26, '1991-09-02');
INSERT INTO DEPTOEMPREGADO VALUES (1, 27, '2002-04-10');
INSERT INTO DEPTOEMPREGADO VALUES (5, 28, '1990-04-04');
INSERT INTO DEPTOEMPREGADO VALUES (2, 29, '2008-06-06');
INSERT INTO DEPTOEMPREGADO VALUES (4, 30, '2009-03-06');

INSERT INTO DEPTOEMPREGADO VALUES (2, 14, '1992-06-10');
INSERT INTO DEPTOEMPREGADO VALUES (5, 4, '1992-09-10');
INSERT INTO DEPTOEMPREGADO VALUES (3, 1, '2005-12-28');
INSERT INTO DEPTOEMPREGADO VALUES (4, 10, '1992-12-23');
INSERT INTO DEPTOEMPREGADO VALUES (3, 3, '2007-08-16');
INSERT INTO DEPTOEMPREGADO VALUES (5, 27, '1996-06-16');
INSERT INTO DEPTOEMPREGADO VALUES (3, 11, '1995-10-20');
INSERT INTO DEPTOEMPREGADO VALUES (5, 6, '2005-11-02');
INSERT INTO DEPTOEMPREGADO VALUES (2, 27, '2002-11-20');
INSERT INTO DEPTOEMPREGADO VALUES (5, 21, '1991-03-17');
INSERT INTO DEPTOEMPREGADO VALUES (2, 9, '2013-07-21');
INSERT INTO DEPTOEMPREGADO VALUES (5, 26, '2009-06-25');
INSERT INTO DEPTOEMPREGADO VALUES (2, 22, '2000-10-28');
INSERT INTO DEPTOEMPREGADO VALUES (4, 28, '1998-07-28');
INSERT INTO DEPTOEMPREGADO VALUES (5, 9, '2004-05-08');
INSERT INTO DEPTOEMPREGADO VALUES (1, 11, '1994-11-07');
INSERT INTO DEPTOEMPREGADO VALUES (2, 27, '2006-01-04');
INSERT INTO DEPTOEMPREGADO VALUES (4, 10, '2011-12-14');
INSERT INTO DEPTOEMPREGADO VALUES (2, 5, '1996-06-03');
INSERT INTO DEPTOEMPREGADO VALUES (5, 6, '2008-10-24');
INSERT INTO DEPTOEMPREGADO VALUES (5, 9, '2007-11-04');
INSERT INTO DEPTOEMPREGADO VALUES (3, 23, '1991-06-21');
INSERT INTO DEPTOEMPREGADO VALUES (3, 20, '2003-09-18');
INSERT INTO DEPTOEMPREGADO VALUES (3, 9, '2003-02-04');
INSERT INTO DEPTOEMPREGADO VALUES (3, 6, '1990-06-06');
INSERT INTO DEPTOEMPREGADO VALUES (5, 5, '2004-11-13');
INSERT INTO DEPTOEMPREGADO VALUES (2, 14, '2007-03-15');
INSERT INTO DEPTOEMPREGADO VALUES (3, 19, '2005-04-01');
INSERT INTO DEPTOEMPREGADO VALUES (2, 7, '1996-04-13');
INSERT INTO DEPTOEMPREGADO VALUES (3, 13, '1997-08-05');

INSERT INTO CARGOEMPREGADO VALUES (1, 1, '2009-07-01');
INSERT INTO CARGOEMPREGADO VALUES (1, 2, '1990-05-23');
INSERT INTO CARGOEMPREGADO VALUES (1, 3, '2002-07-20');
INSERT INTO CARGOEMPREGADO VALUES (1, 4, '2014-12-20');
INSERT INTO CARGOEMPREGADO VALUES (1, 5, '2003-03-23');
INSERT INTO CARGOEMPREGADO VALUES (1, 6, '2012-12-15');
INSERT INTO CARGOEMPREGADO VALUES (1, 7, '1993-06-26');
INSERT INTO CARGOEMPREGADO VALUES (1, 8, '2005-02-21');
INSERT INTO CARGOEMPREGADO VALUES (1, 9, '2003-05-16');
INSERT INTO CARGOEMPREGADO VALUES (1, 10, '2006-12-18');
INSERT INTO CARGOEMPREGADO VALUES (1, 11, '2008-07-19');
INSERT INTO CARGOEMPREGADO VALUES (1, 12, '2003-02-21');
INSERT INTO CARGOEMPREGADO VALUES (1, 13, '1991-09-21');
INSERT INTO CARGOEMPREGADO VALUES (1, 14, '2013-07-05');
INSERT INTO CARGOEMPREGADO VALUES (1, 15, '1992-08-27');
INSERT INTO CARGOEMPREGADO VALUES (1, 16, '2002-09-04');
INSERT INTO CARGOEMPREGADO VALUES (1, 17, '2002-11-11');
INSERT INTO CARGOEMPREGADO VALUES (1, 18, '1993-09-27');
INSERT INTO CARGOEMPREGADO VALUES (1, 19, '2007-05-01');
INSERT INTO CARGOEMPREGADO VALUES (1, 20, '2006-07-17');
INSERT INTO CARGOEMPREGADO VALUES (1, 21, '1996-04-28');
INSERT INTO CARGOEMPREGADO VALUES (1, 22, '1993-12-08');
INSERT INTO CARGOEMPREGADO VALUES (1, 23, '2013-09-13');
INSERT INTO CARGOEMPREGADO VALUES (1, 24, '1995-11-07');
INSERT INTO CARGOEMPREGADO VALUES (1, 25, '2013-01-16');
INSERT INTO CARGOEMPREGADO VALUES (1, 26, '1991-09-02');
INSERT INTO CARGOEMPREGADO VALUES (1, 27, '2002-04-10');
INSERT INTO CARGOEMPREGADO VALUES (1, 28, '1990-04-04');
INSERT INTO CARGOEMPREGADO VALUES (1, 29, '2008-06-06');
INSERT INTO CARGOEMPREGADO VALUES (1, 30, '2009-03-06');

INSERT INTO CARGOEMPREGADO VALUES (2, 4, '2003-07-14');
INSERT INTO CARGOEMPREGADO VALUES (6, 26, '1991-04-15');
INSERT INTO CARGOEMPREGADO VALUES (9, 6, '2003-05-15');
INSERT INTO CARGOEMPREGADO VALUES (7, 8, '2005-09-23');
INSERT INTO CARGOEMPREGADO VALUES (3, 19, '1994-10-28');
INSERT INTO CARGOEMPREGADO VALUES (7, 24, '2000-06-07');
INSERT INTO CARGOEMPREGADO VALUES (5, 12, '1995-02-19');
INSERT INTO CARGOEMPREGADO VALUES (9, 10, '2005-11-09');
INSERT INTO CARGOEMPREGADO VALUES (7, 30, '2010-03-27');
INSERT INTO CARGOEMPREGADO VALUES (8, 8, '1996-08-11');
INSERT INTO CARGOEMPREGADO VALUES (5, 23, '2009-07-06');
INSERT INTO CARGOEMPREGADO VALUES (9, 12, '2013-01-18');
INSERT INTO CARGOEMPREGADO VALUES (2, 11, '2001-01-25');
INSERT INTO CARGOEMPREGADO VALUES (8, 25, '2008-06-06');
INSERT INTO CARGOEMPREGADO VALUES (4, 30, '2003-02-05');
INSERT INTO CARGOEMPREGADO VALUES (5, 30, '2010-02-08');
INSERT INTO CARGOEMPREGADO VALUES (9, 10, '2003-11-17');
INSERT INTO CARGOEMPREGADO VALUES (8, 15, '2010-09-19');
INSERT INTO CARGOEMPREGADO VALUES (10, 25, '1993-06-13');
INSERT INTO CARGOEMPREGADO VALUES (4, 29, '1992-03-02');
INSERT INTO CARGOEMPREGADO VALUES (7, 5, '2004-05-12');
INSERT INTO CARGOEMPREGADO VALUES (9, 1, '2006-11-02');
INSERT INTO CARGOEMPREGADO VALUES (4, 10, '1997-04-14');
INSERT INTO CARGOEMPREGADO VALUES (7, 2, '1995-02-25');
INSERT INTO CARGOEMPREGADO VALUES (3, 20, '2007-09-16');
INSERT INTO CARGOEMPREGADO VALUES (6, 25, '1993-06-06');
INSERT INTO CARGOEMPREGADO VALUES (6, 12, '2003-06-21');
INSERT INTO CARGOEMPREGADO VALUES (4, 27, '1998-06-24');
INSERT INTO CARGOEMPREGADO VALUES (5, 15, '2001-09-19');
INSERT INTO CARGOEMPREGADO VALUES (9, 24, '2002-02-05');

-- mostrar quantos cargos cada empregado teve
select empregado.nome, count(*) as qtde from empregado
		     join CARGOEMPREGADO on empregado.codigo = cargoempregado.empregado
group by empregado.codigo
order by 2 desc;



-- mostrar o nome do empregado que teve mais cargos
select empregado.nome, count(*) as qtde from empregado
		     join CARGOEMPREGADO on empregado.codigo = cargoempregado.empregado
group by empregado.codigo having count(*) = (
select count(*) from empregado
		     join CARGOEMPREGADO on empregado.codigo = cargoempregado.empregado
group by empregado.codigo
order by 1 desc limit 1) order by 1;



-- mostrar o cargo e o salário atual de cada empregado
select empregado.nome, cargo.descricao, cargo.salario
from empregado
join CARGOEMPREGADO on empregado.codigo = cargoempregado.empregado
	join (select empregado.codigo, max(CARGOEMPREGADO.INICIO) as inicio_cargo from empregado
	join CARGOEMPREGADO on empregado.codigo = cargoempregado.empregado
	group by 1 order by 1) as tmp1
	on tmp1.codigo = empregado.codigo
join cargo on cargoempregado.cargo = cargo.codigo
where cargoempregado.inicio = tmp1.inicio_cargo;

--xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
select * from cargoempregado order by 2 asc, 3 asc;

select cargoempregado.empregado, max(cargoempregado.inicio) from cargoempregado group by 1;

select cargoempregado.empregado, max(cargoempregado.inicio) as inicio from cargoempregado group by 1;

--Cargo Atual (usando IN)
select * from cargoempregado where (empregado, inicio) in
(select cargoempregado.empregado, max(cargoempregado.inicio) as inicio from cargoempregado group by 1);

select empregado.nome, cargo.descricao, cargo.salario from cargo
join (select * from cargoempregado where (empregado, inicio) in
	(select cargoempregado.empregado, max(cargoempregado.inicio) as inicio from cargoempregado group by 1)) as cargoatual
on cargo.codigo = cargoatual.cargo
join empregado on empregado.codigo = cargoatual.empregado;
--xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx




-- mostrar os empregados que atualmente trabalham no Depto 2
--Em todos
select empregado.nome, depto.codigo
from empregado
join DEPTOEMPREGADO on empregado.codigo = deptoempregado.empregado
join depto on deptoempregado.depto = depto.codigo
join (select empregado.codigo, max(DEPTOEMPREGADO.INICIO) as inicio_cargo from empregado
	join DEPTOEMPREGADO on empregado.codigo = deptoempregado.empregado
	group by 1) as tmp1
on tmp1.codigo = empregado.codigo
where deptoempregado.inicio = tmp1.inicio_cargo;
--Só no 2
select empregado.nome, depto.codigo
from empregado
join DEPTOEMPREGADO on empregado.codigo = deptoempregado.empregado
join depto on deptoempregado.depto = depto.codigo
join (select empregado.codigo, max(DEPTOEMPREGADO.INICIO) as inicio_cargo from empregado
	join DEPTOEMPREGADO on empregado.codigo = deptoempregado.empregado
	group by 1) as tmp1
on tmp1.codigo = empregado.codigo
where deptoempregado.inicio = tmp1.inicio_cargo and depto.codigo = 2;



-- mostrar quantos empregados trabalham atualmente em cada depto
select distinct deptoempregado.depto,count(*) as trabalham
from empregado
join DEPTOEMPREGADO on empregado.codigo = deptoempregado.empregado
join depto on deptoempregado.depto = depto.codigo
join (select empregado.codigo, max(DEPTOEMPREGADO.INICIO) as inicio_cargo from empregado
	join DEPTOEMPREGADO on empregado.codigo = deptoempregado.empregado
	group by 1 order by 1) as tmp1
on tmp1.codigo = empregado.codigo
where deptoempregado.inicio = tmp1.inicio_cargo
group by 1 order by 1;

-- mostrar o nome do empregado atualmente com o maior salário de cada depto
select tmp3.depcod, max(tmp4.salario) from empregado
join (select empregado.codigo as empcod, depto.codigo as depcod
	from empregado
	join DEPTOEMPREGADO on empregado.codigo = deptoempregado.empregado
	join depto on deptoempregado.depto = depto.codigo
	join (select empregado.codigo, max(DEPTOEMPREGADO.INICIO) as inicio_cargo from empregado
		join DEPTOEMPREGADO on empregado.codigo = deptoempregado.empregado
		group by 1 order by 1) as tmp1
		on tmp1.codigo = empregado.codigo
		where deptoempregado.inicio = tmp1.inicio_cargo
		order by 1) as tmp3
on empregado.codigo = tmp3.empcod
join (select empregado.codigo, cargoempregado.cargo, cargo.salario
	from empregado
	join CARGOEMPREGADO on empregado.codigo = cargoempregado.empregado
		join (select empregado.codigo, max(CARGOEMPREGADO.INICIO) as inicio_cargo from empregado
		join CARGOEMPREGADO on empregado.codigo = cargoempregado.empregado
		group by 1 order by 1) as tmp2
		on tmp2.codigo = empregado.codigo
		join cargo on cargoempregado.cargo = cargo.codigo
		where cargoempregado.inicio = tmp2.inicio_cargo
		order by 1 asc) as tmp4
on tmp4.codigo = tmp3.empcod
group by 1;







(select empregado.codigo as empcod, depto.codigo as depcod
	from empregado
	join DEPTOEMPREGADO on empregado.codigo = deptoempregado.empregado
	join depto on deptoempregado.depto = depto.codigo
	join (select empregado.codigo, max(DEPTOEMPREGADO.INICIO) as inicio_cargo from empregado
		join DEPTOEMPREGADO on empregado.codigo = deptoempregado.empregado
		group by 1) as tmp1
		on tmp1.codigo = empregado.codigo
		where deptoempregado.inicio = tmp1.inicio_cargo) as suba

		(select empregado.codigo, cargoempregado.cargo, cargo.salario
			from empregado
			join CARGOEMPREGADO on empregado.codigo = cargoempregado.empregado
				join (select empregado.codigo, max(CARGOEMPREGADO.INICIO) as inicio_cargo from empregado
				join CARGOEMPREGADO on empregado.codigo = cargoempregado.empregado
				group by 1 order by 1) as tmp2
				on tmp2.codigo = empregado.codigo
				join cargo on cargoempregado.cargo = cargo.codigo
				where cargoempregado.inicio = tmp2.inicio_cargo
				order by 1 asc) as subb


select *
from suba
	join subb on suba.empcod = subb.codigo
	join empregado on empregado.codigo = suba.empcod;



	(select *
	from (select empregado.codigo as empcod, depto.codigo as depcod
		from empregado
		join DEPTOEMPREGADO on empregado.codigo = deptoempregado.empregado
		join depto on deptoempregado.depto = depto.codigo
		join (select empregado.codigo, max(DEPTOEMPREGADO.INICIO) as inicio_cargo from empregado
			join DEPTOEMPREGADO on empregado.codigo = deptoempregado.empregado
			group by 1) as tmp1
			on tmp1.codigo = empregado.codigo
			where deptoempregado.inicio = tmp1.inicio_cargo) as suba
		join (select empregado.codigo, cargoempregado.cargo, cargo.salario
			from empregado
			join CARGOEMPREGADO on empregado.codigo = cargoempregado.empregado
				join (select empregado.codigo, max(CARGOEMPREGADO.INICIO) as inicio_cargo from empregado
				join CARGOEMPREGADO on empregado.codigo = cargoempregado.empregado
				group by 1 order by 1) as tmp2
				on tmp2.codigo = empregado.codigo
				join cargo on cargoempregado.cargo = cargo.codigo
				where cargoempregado.inicio = tmp2.inicio_cargo
				order by 1 asc) as subb on suba.empcod = subb.codigo
		join empregado on empregado.codigo = suba.empcod) as subc




	select subc.depcod, max(subc.salario) as max_salario
	from subc
	group by subc.depcod



	(select subc.depcod, max(subc.salario) as max_salario
	from (select *
	from (select empregado.codigo as empcod, depto.codigo as depcod
		from empregado
		join DEPTOEMPREGADO on empregado.codigo = deptoempregado.empregado
		join depto on deptoempregado.depto = depto.codigo
		join (select empregado.codigo, max(DEPTOEMPREGADO.INICIO) as inicio_cargo from empregado
			join DEPTOEMPREGADO on empregado.codigo = deptoempregado.empregado
			group by 1) as tmp1
			on tmp1.codigo = empregado.codigo
			where deptoempregado.inicio = tmp1.inicio_cargo) as suba
		join (select empregado.codigo, cargoempregado.cargo, cargo.salario
			from empregado
			join CARGOEMPREGADO on empregado.codigo = cargoempregado.empregado
				join (select empregado.codigo, max(CARGOEMPREGADO.INICIO) as inicio_cargo from empregado
				join CARGOEMPREGADO on empregado.codigo = cargoempregado.empregado
				group by 1 order by 1) as tmp2
				on tmp2.codigo = empregado.codigo
				join cargo on cargoempregado.cargo = cargo.codigo
				where cargoempregado.inicio = tmp2.inicio_cargo
				order by 1 asc) as subb on suba.empcod = subb.codigo
		join empregado on empregado.codigo = suba.empcod) as subc
	group by subc.depcod) as subd




select subd.depcod,subc.nome,subd.max_salario from (select *
from (select empregado.codigo as empcod, depto.codigo as depcod
	from empregado
	join DEPTOEMPREGADO on empregado.codigo = deptoempregado.empregado
	join depto on deptoempregado.depto = depto.codigo
	join (select empregado.codigo, max(DEPTOEMPREGADO.INICIO) as inicio_cargo from empregado
		join DEPTOEMPREGADO on empregado.codigo = deptoempregado.empregado
		group by 1) as tmp1
		on tmp1.codigo = empregado.codigo
		where deptoempregado.inicio = tmp1.inicio_cargo) as suba
	join (select empregado.codigo, cargoempregado.cargo, cargo.salario
		from empregado
		join CARGOEMPREGADO on empregado.codigo = cargoempregado.empregado
			join (select empregado.codigo, max(CARGOEMPREGADO.INICIO) as inicio_cargo from empregado
			join CARGOEMPREGADO on empregado.codigo = cargoempregado.empregado
			group by 1 order by 1) as tmp2
			on tmp2.codigo = empregado.codigo
			join cargo on cargoempregado.cargo = cargo.codigo
			where cargoempregado.inicio = tmp2.inicio_cargo
			order by 1 asc) as subb on suba.empcod = subb.codigo
	join empregado on empregado.codigo = suba.empcod) as subc join (select subc.depcod, max(subc.salario) as max_salario
	from (select *
	from (select empregado.codigo as empcod, depto.codigo as depcod
		from empregado
		join DEPTOEMPREGADO on empregado.codigo = deptoempregado.empregado
		join depto on deptoempregado.depto = depto.codigo
		join (select empregado.codigo, max(DEPTOEMPREGADO.INICIO) as inicio_cargo from empregado
			join DEPTOEMPREGADO on empregado.codigo = deptoempregado.empregado
			group by 1) as tmp1
			on tmp1.codigo = empregado.codigo
			where deptoempregado.inicio = tmp1.inicio_cargo) as suba
		join (select empregado.codigo, cargoempregado.cargo, cargo.salario
			from empregado
			join CARGOEMPREGADO on empregado.codigo = cargoempregado.empregado
				join (select empregado.codigo, max(CARGOEMPREGADO.INICIO) as inicio_cargo from empregado
				join CARGOEMPREGADO on empregado.codigo = cargoempregado.empregado
				group by 1 order by 1) as tmp2
				on tmp2.codigo = empregado.codigo
				join cargo on cargoempregado.cargo = cargo.codigo
				where cargoempregado.inicio = tmp2.inicio_cargo
				order by 1 asc) as subb on suba.empcod = subb.codigo
		join empregado on empregado.codigo = suba.empcod) as subc
	group by subc.depcod) as subd on subc.depcod = subd.depcod and subc.salario = subd.max_salario order by 1,2;




select * from subc join subd on subc.depcod = subd.depcod and subc.salario = subd.max_salario



select tmp3.depcod, max(tmp4.salario) from
(select empregado.codigo as empcod, depto.codigo as depcod
	from empregado
	join DEPTOEMPREGADO on empregado.codigo = deptoempregado.empregado
	join depto on deptoempregado.depto = depto.codigo
	join (select empregado.codigo, max(DEPTOEMPREGADO.INICIO) as inicio_cargo from empregado
		join DEPTOEMPREGADO on empregado.codigo = deptoempregado.empregado
		group by 1 order by 1) as tmp1
		on tmp1.codigo = empregado.codigo
		where deptoempregado.inicio = tmp1.inicio_cargo
		order by 1) as tmp3
join (select empregado.codigo, cargoempregado.cargo, cargo.salario
	from empregado
	join CARGOEMPREGADO on empregado.codigo = cargoempregado.empregado
		join (select empregado.codigo, max(CARGOEMPREGADO.INICIO) as inicio_cargo from empregado
		join CARGOEMPREGADO on empregado.codigo = cargoempregado.empregado
		group by 1 order by 1) as tmp2
		on tmp2.codigo = empregado.codigo
		join cargo on cargoempregado.cargo = cargo.codigo
		where cargoempregado.inicio = tmp2.inicio_cargo
		order by 1 asc) as tmp4
on tmp4.codigo = tmp3.empcod
join empregado on empregado.codigo = tmp3.empcod
group by 1;



-- mostrar a faixa do IRPF atual de cada empregado
--SEI LA OQUE É IRPF



-- mostrar todos os cargos de um empregado
select distinct empregado.nome, cargoempregado.cargo
from cargoempregado
join deptoempregado on deptoempregado.empregado = cargoempregado.empregado
join empregado on empregado.codigo = cargoempregado.empregado
join cargo on cargo.codigo = cargoempregado.cargo
join depto on depto.codigo = deptoempregado.depto
where empregado.codigo = 1;



-- mostrar o salário médio de um empregado
select distinct empregado.nome, avg(cargo.salario) as salario_médio
from cargoempregado
join deptoempregado on deptoempregado.empregado = cargoempregado.empregado
join empregado on empregado.codigo = cargoempregado.empregado
join cargo on cargo.codigo = cargoempregado.cargo
join depto on depto.codigo = deptoempregado.depto
where empregado.codigo = 1
group by 1;


-- mostrar o cargo mais alto atual de cada depto
select subc.depcod,max(subc.cargo) from
	(select *
	from (select empregado.codigo as empcod, depto.codigo as depcod
		from empregado
		join DEPTOEMPREGADO on empregado.codigo = deptoempregado.empregado
		join depto on deptoempregado.depto = depto.codigo
		join (select empregado.codigo, max(DEPTOEMPREGADO.INICIO) as inicio_cargo from empregado
			join DEPTOEMPREGADO on empregado.codigo = deptoempregado.empregado
			group by 1) as tmp1
			on tmp1.codigo = empregado.codigo
			where deptoempregado.inicio = tmp1.inicio_cargo) as suba
		join (select empregado.codigo, cargoempregado.cargo, cargo.salario
			from empregado
			join CARGOEMPREGADO on empregado.codigo = cargoempregado.empregado
				join (select empregado.codigo, max(CARGOEMPREGADO.INICIO) as inicio_cargo from empregado
				join CARGOEMPREGADO on empregado.codigo = cargoempregado.empregado
				group by 1 order by 1) as tmp2
				on tmp2.codigo = empregado.codigo
				join cargo on cargoempregado.cargo = cargo.codigo
				where cargoempregado.inicio = tmp2.inicio_cargo
				order by 1 asc) as subb on suba.empcod = subb.codigo
		join empregado on empregado.codigo = suba.empcod) as subc
		group by 1;




-- mostrar a média de salário atual por gênero
select subc.genero, avg(subc.salario) as salario_médio
	from	(select *
	from (select empregado.codigo as empcod, depto.codigo as depcod
		from empregado
		join DEPTOEMPREGADO on empregado.codigo = deptoempregado.empregado
		join depto on deptoempregado.depto = depto.codigo
		join (select empregado.codigo, max(DEPTOEMPREGADO.INICIO) as inicio_cargo from empregado
			join DEPTOEMPREGADO on empregado.codigo = deptoempregado.empregado
			group by 1) as tmp1
			on tmp1.codigo = empregado.codigo
			where deptoempregado.inicio = tmp1.inicio_cargo) as suba
		join (select empregado.codigo, cargoempregado.cargo, cargo.salario
			from empregado
			join CARGOEMPREGADO on empregado.codigo = cargoempregado.empregado
				join (select empregado.codigo, max(CARGOEMPREGADO.INICIO) as inicio_cargo from empregado
				join CARGOEMPREGADO on empregado.codigo = cargoempregado.empregado
				group by 1 order by 1) as tmp2
				on tmp2.codigo = empregado.codigo
				join cargo on cargoempregado.cargo = cargo.codigo
				where cargoempregado.inicio = tmp2.inicio_cargo
				order by 1 asc) as subb on suba.empcod = subb.codigo
		join empregado on empregado.codigo = suba.empcod) as subc group by 1;



-- mostrar a média de salário atual por depto
select subc.depcod, avg(subc.salario)
	from	(select *
	from (select empregado.codigo as empcod, depto.codigo as depcod
		from empregado
		join DEPTOEMPREGADO on empregado.codigo = deptoempregado.empregado
		join depto on deptoempregado.depto = depto.codigo
		join (select empregado.codigo, max(DEPTOEMPREGADO.INICIO) as inicio_cargo from empregado
			join DEPTOEMPREGADO on empregado.codigo = deptoempregado.empregado
			group by 1) as tmp1
			on tmp1.codigo = empregado.codigo
			where deptoempregado.inicio = tmp1.inicio_cargo) as suba
		join (select empregado.codigo, cargoempregado.cargo, cargo.salario
			from empregado
			join CARGOEMPREGADO on empregado.codigo = cargoempregado.empregado
				join (select empregado.codigo, max(CARGOEMPREGADO.INICIO) as inicio_cargo from empregado
				join CARGOEMPREGADO on empregado.codigo = cargoempregado.empregado
				group by 1 order by 1) as tmp2
				on tmp2.codigo = empregado.codigo
				join cargo on cargoempregado.cargo = cargo.codigo
				where cargoempregado.inicio = tmp2.inicio_cargo
				order by 1 asc) as subb on suba.empcod = subb.codigo
		join empregado on empregado.codigo = suba.empcod) as subc group by 1;




-- mostrar o maior e o menor salário atual por gênero
select subc.genero, max(subc.salario) as maior, min(subc.salario) as menor
from	(select *
from (select empregado.codigo as empcod, depto.codigo as depcod
	from empregado
	join DEPTOEMPREGADO on empregado.codigo = deptoempregado.empregado
	join depto on deptoempregado.depto = depto.codigo
	join (select empregado.codigo, max(DEPTOEMPREGADO.INICIO) as inicio_cargo from empregado
		join DEPTOEMPREGADO on empregado.codigo = deptoempregado.empregado
		group by 1) as tmp1
		on tmp1.codigo = empregado.codigo
		where deptoempregado.inicio = tmp1.inicio_cargo) as suba
	join (select empregado.codigo, cargoempregado.cargo, cargo.salario
		from empregado
		join CARGOEMPREGADO on empregado.codigo = cargoempregado.empregado
			join (select empregado.codigo, max(CARGOEMPREGADO.INICIO) as inicio_cargo from empregado
			join CARGOEMPREGADO on empregado.codigo = cargoempregado.empregado
			group by 1 order by 1) as tmp2
			on tmp2.codigo = empregado.codigo
			join cargo on cargoempregado.cargo = cargo.codigo
			where cargoempregado.inicio = tmp2.inicio_cargo
			order by 1 asc) as subb on suba.empcod = subb.codigo
	join empregado on empregado.codigo = suba.empcod) as subc
	group by 1;

-- mostrar o maior e o menor salário atual por depto
select subc.depcod,max(subc.salario) as maior, min(subc.salario) as menor
from (select *
from (select empregado.codigo as empcod, depto.codigo as depcod
	from empregado
	join DEPTOEMPREGADO on empregado.codigo = deptoempregado.empregado
	join depto on deptoempregado.depto = depto.codigo
	join (select empregado.codigo, max(DEPTOEMPREGADO.INICIO) as inicio_cargo from empregado
		join DEPTOEMPREGADO on empregado.codigo = deptoempregado.empregado
		group by 1) as tmp1
		on tmp1.codigo = empregado.codigo
		where deptoempregado.inicio = tmp1.inicio_cargo) as suba
	join (select empregado.codigo, cargoempregado.cargo, cargo.salario
		from empregado
		join CARGOEMPREGADO on empregado.codigo = cargoempregado.empregado
			join (select empregado.codigo, max(CARGOEMPREGADO.INICIO) as inicio_cargo from empregado
			join CARGOEMPREGADO on empregado.codigo = cargoempregado.empregado
			group by 1 order by 1) as tmp2
			on tmp2.codigo = empregado.codigo
			join cargo on cargoempregado.cargo = cargo.codigo
			where cargoempregado.inicio = tmp2.inicio_cargo
			order by 1 asc) as subb on suba.empcod = subb.codigo
	join empregado on empregado.codigo = suba.empcod) as subc
group by 1;


-- mostrar o nome da mulher que recebe atualmente o maior salario
select subc.nome, max(subc.salario)
from (select *
from (select empregado.codigo as empcod, depto.codigo as depcod
	from empregado
	join DEPTOEMPREGADO on empregado.codigo = deptoempregado.empregado
	join depto on deptoempregado.depto = depto.codigo
	join (select empregado.codigo, max(DEPTOEMPREGADO.INICIO) as inicio_cargo from empregado
		join DEPTOEMPREGADO on empregado.codigo = deptoempregado.empregado
		group by 1) as tmp1
		on tmp1.codigo = empregado.codigo
		where deptoempregado.inicio = tmp1.inicio_cargo) as suba
	join (select empregado.codigo, cargoempregado.cargo, cargo.salario
		from empregado
		join CARGOEMPREGADO on empregado.codigo = cargoempregado.empregado
			join (select empregado.codigo, max(CARGOEMPREGADO.INICIO) as inicio_cargo from empregado
			join CARGOEMPREGADO on empregado.codigo = cargoempregado.empregado
			group by 1 order by 1) as tmp2
			on tmp2.codigo = empregado.codigo
			join cargo on cargoempregado.cargo = cargo.codigo
			where cargoempregado.inicio = tmp2.inicio_cargo
			order by 1 asc) as subb on suba.empcod = subb.codigo
	join empregado on empregado.codigo = suba.empcod) as subc
	where lower(subc.genero) = 'f' group by 1
	having max(subc.salario) =
	(select subc1.max from
	(select subc.nome, max(subc.salario) as max
	from (select *
	from (select empregado.codigo as empcod, depto.codigo as depcod
		from empregado
		join DEPTOEMPREGADO on empregado.codigo = deptoempregado.empregado
		join depto on deptoempregado.depto = depto.codigo
		join (select empregado.codigo, max(DEPTOEMPREGADO.INICIO) as inicio_cargo from empregado
			join DEPTOEMPREGADO on empregado.codigo = deptoempregado.empregado
			group by 1) as tmp1
			on tmp1.codigo = empregado.codigo
			where deptoempregado.inicio = tmp1.inicio_cargo) as suba
		join (select empregado.codigo, cargoempregado.cargo, cargo.salario
			from empregado
			join CARGOEMPREGADO on empregado.codigo = cargoempregado.empregado
				join (select empregado.codigo, max(CARGOEMPREGADO.INICIO) as inicio_cargo from empregado
				join CARGOEMPREGADO on empregado.codigo = cargoempregado.empregado
				group by 1 order by 1) as tmp2
				on tmp2.codigo = empregado.codigo
				join cargo on cargoempregado.cargo = cargo.codigo
				where cargoempregado.inicio = tmp2.inicio_cargo
				order by 1 asc) as subb on suba.empcod = subb.codigo
		join empregado on empregado.codigo = suba.empcod) as subc
		where lower(subc.genero) = 'f' group by 1 order by 2 desc limit 1) subc1)


-- mostrar o nome da mulher que recebe atualmente o maior salario por depto
select subd.depcod,subc.nome,subd.max_salario
from (select *
from (select empregado.codigo as empcod, depto.codigo as depcod
	from empregado
	join DEPTOEMPREGADO on empregado.codigo = deptoempregado.empregado
	join depto on deptoempregado.depto = depto.codigo
	join (select empregado.codigo, max(DEPTOEMPREGADO.INICIO) as inicio_cargo from empregado
	join DEPTOEMPREGADO on empregado.codigo = deptoempregado.empregado
	group by 1) as tmp1
	on tmp1.codigo = empregado.codigo
	where deptoempregado.inicio = tmp1.inicio_cargo) as suba
	join (select empregado.codigo, cargoempregado.cargo, cargo.salario
	from empregado
	join CARGOEMPREGADO on empregado.codigo = cargoempregado.empregado
	join (select empregado.codigo, max(CARGOEMPREGADO.INICIO) as inicio_cargo from empregado
	join CARGOEMPREGADO on empregado.codigo = cargoempregado.empregado
	group by 1 order by 1) as tmp2
	on tmp2.codigo = empregado.codigo
	join cargo on cargoempregado.cargo = cargo.codigo
	where cargoempregado.inicio = tmp2.inicio_cargo
	order by 1 asc) as subb on suba.empcod = subb.codigo
	join empregado on empregado.codigo = suba.empcod) as subc
join (select subc.depcod, max(subc.salario) as max_salario
	from (select *
	from (select empregado.codigo as empcod, depto.codigo as depcod
	from empregado
	join DEPTOEMPREGADO on empregado.codigo = deptoempregado.empregado
	join depto on deptoempregado.depto = depto.codigo
	join (select empregado.codigo, max(DEPTOEMPREGADO.INICIO) as inicio_cargo from empregado
	join DEPTOEMPREGADO on empregado.codigo = deptoempregado.empregado
	group by 1) as tmp1
	on tmp1.codigo = empregado.codigo
	where deptoempregado.inicio = tmp1.inicio_cargo) as suba
	join (select empregado.codigo, cargoempregado.cargo, cargo.salario
	from empregado
	join CARGOEMPREGADO on empregado.codigo = cargoempregado.empregado
	join (select empregado.codigo, max(CARGOEMPREGADO.INICIO) as inicio_cargo from empregado
	join CARGOEMPREGADO on empregado.codigo = cargoempregado.empregado
	group by 1 order by 1) as tmp2
	on tmp2.codigo = empregado.codigo
	join cargo on cargoempregado.cargo = cargo.codigo
	where cargoempregado.inicio = tmp2.inicio_cargo
	order by 1 asc) as subb on suba.empcod = subb.codigo
	join empregado on empregado.codigo = suba.empcod) as subc
group by subc.depcod) as subd on subc.depcod = subd.depcod and subc.salario = subd.max_salario
	where lower(subc.genero) = 'f' order by 1,2;


-- mostrar o departamento com mais empregados atualmente
select subc.depcod,count(*) as trabalham
from (select *
from (select empregado.codigo as empcod, depto.codigo as depcod
	from empregado
	join DEPTOEMPREGADO on empregado.codigo = deptoempregado.empregado
	join depto on deptoempregado.depto = depto.codigo
	join (select empregado.codigo, max(DEPTOEMPREGADO.INICIO) as inicio_cargo from empregado
		join DEPTOEMPREGADO on empregado.codigo = deptoempregado.empregado
		group by 1) as tmp1
		on tmp1.codigo = empregado.codigo
		where deptoempregado.inicio = tmp1.inicio_cargo) as suba
	join (select empregado.codigo, cargoempregado.cargo, cargo.salario
		from empregado
		join CARGOEMPREGADO on empregado.codigo = cargoempregado.empregado
			join (select empregado.codigo, max(CARGOEMPREGADO.INICIO) as inicio_cargo from empregado
			join CARGOEMPREGADO on empregado.codigo = cargoempregado.empregado
			group by 1 order by 1) as tmp2
			on tmp2.codigo = empregado.codigo
			join cargo on cargoempregado.cargo = cargo.codigo
			where cargoempregado.inicio = tmp2.inicio_cargo
			order by 1 asc) as subb on suba.empcod = subb.codigo
	join empregado on empregado.codigo = suba.empcod) as subc group by 1
having count(*) =
	(select subc1.trabalham from
		(select subc.depcod,count(*) as trabalham
		from (select *
			from (select empregado.codigo as empcod, depto.codigo as depcod
				from empregado
				join DEPTOEMPREGADO on empregado.codigo = deptoempregado.empregado
				join depto on deptoempregado.depto = depto.codigo
				join (select empregado.codigo, max(DEPTOEMPREGADO.INICIO) as inicio_cargo from empregado
				join DEPTOEMPREGADO on empregado.codigo = deptoempregado.empregado
				group by 1) as tmp1
				on tmp1.codigo = empregado.codigo
				where deptoempregado.inicio = tmp1.inicio_cargo) as suba
				join (select empregado.codigo, cargoempregado.cargo, cargo.salario
					from empregado
					join CARGOEMPREGADO on empregado.codigo = cargoempregado.empregado
					join (select empregado.codigo, max(CARGOEMPREGADO.INICIO) as inicio_cargo from empregado
					join CARGOEMPREGADO on empregado.codigo = cargoempregado.empregado
					group by 1 order by 1) as tmp2
					on tmp2.codigo = empregado.codigo
					join cargo on cargoempregado.cargo = cargo.codigo
					where cargoempregado.inicio = tmp2.inicio_cargo
					order by 1 asc) as subb on suba.empcod = subb.codigo
					join empregado on empregado.codigo = suba.empcod) as subc group by 1 order by 2 desc limit 1) as subc1);
