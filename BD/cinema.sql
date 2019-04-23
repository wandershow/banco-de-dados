--Utilizando o script cinema.sql:
--      FILME (Titulo,Pais,Ano,Realizador)
--      DISTRIBUICAO (Titulo,Ator)
--      CINEMA (NomCine,Tel,Rua)
--      SALACINEMA (NomCine,Sala,NuLugares)
--      PROGRAMA (NomCine,Sala,Semana,Titulo,NuEntradas)

--A relação FILME identifica cada filme por seu título, o país de origem, o ano de estréia e o realizador.
--A relação DISTRIBUIÇÃO identifica os atores que participam de um filme.
--A relação CINEMA descreve os cinemas de uma cidade com seus endereços.
--A relação SALACINEMA indica para cada cinema o número de salas do cinema e o núemro de lugares de cada uma destas salas.
--Através da relação PROGRAMA pode-se saber desde o início do ano, semana por semana, o filme que passou em cada sala de cada cinema com o número de pessoas que assistiram ao filme.

--Os atributos destas tabelas têm os seguintes significados:
--      Titulo: título de um filme - varchar(30)
--      Pais: pais onde o filme foi produzido - varchar(10)
--      Ano: ano em que o filme entrou em cartaz - int
--      Realizador: nome do realizador do filme - varchar(30)
--      Ator: nome de um ator - varchar(30)
--      NomCine: nome de um cinema de uma cidade única - varchar(20)
--      Tel: número do telefone do cinema - int
--      Rua: nome da rua onde se situa o cinema - varchar(35)
--      Sala: número de uma sala de um cinema - int
--      NuLugares: número de lugares - int
--      Semana: número da semana no ano (1-52) - int
--      NuEntradas: número de pessoas que assistiram a um filme - int

--Apresentar as consultas SQL que apresentem os dados listados abaixo
--1: Lista dos filmes (Titulo, Ano, Realizador) franceses.
--2: Os anos em que o ator gabin estreou um filme.
--3: Os atores que trabalharam com o realizador truffaut.
--4: Lista dos filmes onde o realizador é também ator.
--5: O número de filmes onde eastwood trabalhou como ator.
--6: O nome do cinema e o número da sala que apresenta um filme realizado por bovin. Dar também o nome do filme.
--7: O nome e o número de telefone dos cinemas que tem salas com capacidade para menos de 100 pessoas.
--8: Todos os atores que trabalharam com a atriz deneuve.
--9: As ruas e número de lugares dos cinemas onde passam os filmes de 1984.
--10: Realizadores que trabalharam como atores em filmes que eles mesmos não realizaram.
--11: O número de atores de cada filme apresentado em qualquer sala de qualquer cinema.
--12: Dar para cada filme em cartaz, depois de quantas semanas ele está em cartaz e o número de entradas.
--13: Para cada realizador, dar o número médio de entradas da totalidade de seus filmes.

DROP TABLE salacinema;
DROP TABLE programa;
DROP TABLE filme;
DROP TABLE distribuicao;
DROP TABLE cinema;

CREATE TABLE filme (
	titulo varchar(30) NOT NULL,
	pais varchar(10) NOT NULL,
	ano int NOT NULL,
	realizador varchar(30) NOT NULL,
    PRIMARY KEY (titulo)
);

CREATE TABLE distribuicao (
	titulo varchar(30) NOT NULL REFERENCES filme(titulo),
	ator varchar(30) NOT NULL,
    PRIMARY KEY (titulo, ator)
);

CREATE TABLE cinema (
	nomcine varchar(20) NOT NULL,
	tel int NOT NULL,
	rua varchar(35) NOT NULL,
    PRIMARY KEY (nomcine)
);

CREATE TABLE salacinema (
	nomcine varchar(20) NOT NULL REFERENCES cinema(nomcine),
	sala int NOT NULL,
	nulugares int NOT NULL,
    PRIMARY KEY (nomcine, sala)
);

CREATE TABLE programa (
	nomcine varchar(20) NOT NULL REFERENCES cinema(nomcine),
	sala int NOT NULL,
	semana int NOT NULL,
	titulo varchar(30) NOT NULL REFERENCES filme(titulo),
	nuentradas int NOT NULL,
    PRIMARY KEY (nomcine, sala,semana, titulo)
);

insert into filme values ('annee du soleil calme','pologne', 1989,'krzysztof');
insert into filme values ('baxter', 'france', 1989 ,'bovin');
insert into filme values ('cop', 'usa', 1989,'harris');
insert into filme values ('la baie des anges', 'france', 1962,'demy');
insert into filme values ('la boca del lobo','espagne',1989, 'lombardi');
insert into filme values ('la derniere cible','usa', 1984 ,'eastwood');
insert into filme values ('mon cher sujet', 'france', 1989 ,'mieville');
insert into filme values ('un poisson nomme wanda', 'usa', 1989 ,'crichton');
insert into filme values ('veuve mais pas trop', 'usa', 1989 ,'truffaut');

insert into distribuicao values ('annee du soleil calme','gabin');
insert into distribuicao values ('annee du soleil calme','komorowska');
insert into distribuicao values ('annee du soleil calme','skanzanka');
insert into distribuicao values ('annee du soleil calme','wilson');
insert into distribuicao values ('baxter','delamare');
insert into distribuicao values ('baxter','delon');
insert into distribuicao values ('baxter','gastaldi');
insert into distribuicao values ('baxter','mercure');
insert into distribuicao values ('baxter','piccoli');
insert into distribuicao values ('baxter','spiesser');
insert into distribuicao values ('cop','deneuve');
insert into distribuicao values ('cop','durning');
insert into distribuicao values ('cop','eastwood');
insert into distribuicao values ('cop','haid');
insert into distribuicao values ('cop','warren');
insert into distribuicao values ('cop','woods');
insert into distribuicao values ('la baie des anges','gabin');
insert into distribuicao values ('la baie des anges','guers');
insert into distribuicao values ('la baie des anges','mann');
insert into distribuicao values ('la baie des anges','moreau');
insert into distribuicao values ('la baie des anges','nassiet');
insert into distribuicao values ('la boca del lobo','bueno');
insert into distribuicao values ('la boca del lobo','vega');
insert into distribuicao values ('la derniere cible','clarkson');
insert into distribuicao values ('la derniere cible','delon');
insert into distribuicao values ('la derniere cible','deneuve');
insert into distribuicao values ('la derniere cible','eastwood');
insert into distribuicao values ('la derniere cible','hunt');
insert into distribuicao values ('mon cher sujet','le roi');
insert into distribuicao values ('mon cher sujet','romand');
insert into distribuicao values ('mon cher sujet','roussel');
insert into distribuicao values ('mon cher sujet','truffaut');
insert into distribuicao values ('un poisson nomme wanda','cleese');
insert into distribuicao values ('un poisson nomme wanda','curtis');
insert into distribuicao values ('un poisson nomme wanda','kline');
insert into distribuicao values ('un poisson nomme wanda','palin');
insert into distribuicao values ('veuve mais pas trop','modine');
insert into distribuicao values ('veuve mais pas trop','pfeiffer');
insert into distribuicao values ('veuve mais pas trop','piccoli');
insert into distribuicao values ('veuve mais pas trop','stockwell');
insert into distribuicao values ('veuve mais pas trop','truffaut');

insert into cinema values ('gaumont', 76461645 ,'alsace lorraine');
insert into cinema values ('la nef', 76465325 ,'edouard rey');
insert into cinema values ('le club', 76467390 ,'phalanstere');
insert into cinema values ('le melies', 76430362 ,'strasbourg');
insert into cinema values ('les 6 rex', 76517200 ,'saint jacques');
insert into cinema values ('les dauphins', 76460454 ,'sault');
insert into cinema values ('lux', 76464658 ,'thiers');
insert into cinema values ('pathe grenette', 76515757 ,'grenette');
insert into cinema values ('ugc royal', 76461142 ,'clot bey');
insert into cinema values ('vox', 76515757 ,'place victor hugo');

insert into salacinema values ('gaumont',1,600);
insert into salacinema values ('gaumont',2,300);
insert into salacinema values ('gaumont',3,300);
insert into salacinema values ('gaumont',4,230);
insert into salacinema values ('gaumont',5,100);
insert into salacinema values ('gaumont',6,100);
insert into salacinema values ('la nef',1,360);
insert into salacinema values ('la nef',2,210);
insert into salacinema values ('la nef',3,200);
insert into salacinema values ('la nef',4,100);
insert into salacinema values ('la nef',5,50);
insert into salacinema values ('le club',1,300);
insert into salacinema values ('le club',2,200);
insert into salacinema values ('le club',3,100);
insert into salacinema values ('le club',4,100);
insert into salacinema values ('le club',5,100);
insert into salacinema values ('le melies', 1,200);
insert into salacinema values ('le melies', 2,150);
insert into salacinema values ('le melies', 3,150);
insert into salacinema values ('les 6 rex',1,400);
insert into salacinema values ('les 6 rex',2,370);
insert into salacinema values ('les 6 rex',3,240);
insert into salacinema values ('les 6 rex',4,100);
insert into salacinema values ('les 6 rex',5,100);
insert into salacinema values ('les 6 rex',6,80);
insert into salacinema values ('les dauphins',1,250);
insert into salacinema values ('les dauphins',2,50);
insert into salacinema values ('lux', 1,200);
insert into salacinema values ('pathe grenette',1,600);
insert into salacinema values ('pathe grenette',2,300);
insert into salacinema values ('pathe grenette',3,300);
insert into salacinema values ('pathe grenette',4,150);
insert into salacinema values ('pathe grenette',5,100);
insert into salacinema values ('pathe grenette',6,100);
insert into salacinema values ('ugc royal',1, 600);
insert into salacinema values ('ugc royal',2, 500);
insert into salacinema values ('ugc royal',3, 200);
insert into salacinema values ('ugc royal',4, 100);
insert into salacinema values ('ugc royal',5, 100);

insert into programa values ('gaumont',1,1,'cop',600);
insert into programa values ('gaumont',1,2,'cop',520);
insert into programa values ('gaumont',1,3,'cop',348);
insert into programa values ('gaumont',1,4,'mon cher sujet',390);
insert into programa values ('gaumont',2,1,'annee du soleil calme',1300);
insert into programa values ('gaumont',2,2,'annee du soleil calme',1600);
insert into programa values ('gaumont',2,3,'annee du soleil calme',1120);
insert into programa values ('gaumont',2,4,'annee du soleil calme',1076);
insert into programa values ('gaumont',3,1,'un poisson nomme wanda',1402);
insert into programa values ('gaumont',3,2,'un poisson nomme wanda',2402);
insert into programa values ('gaumont',3,3,'un poisson nomme wanda',1347);
insert into programa values ('gaumont',3,4,'un poisson nomme wanda',1007);
insert into programa values ('gaumont',4,1,'veuve mais pas trop',730);
insert into programa values ('gaumont',4,2,'veuve mais pas trop',930);
insert into programa values ('gaumont',4,3,'veuve mais pas trop',678);
insert into programa values ('gaumont',4,4,'veuve mais pas trop',610);
insert into programa values ('gaumont',5,1,'la derniere cible',100);
insert into programa values ('gaumont',5,2,'la derniere cible',100);
insert into programa values ('gaumont',5,3,'la derniere cible',149);
insert into programa values ('gaumont',5,4,'la derniere cible',234);
insert into programa values ('gaumont',6,1,'la boca del lobo',40);
insert into programa values ('gaumont',6,2,'la boca del lobo',80);
insert into programa values ('gaumont',6,3,'la boca del lobo',118);
insert into programa values ('gaumont',6,4,'la boca del lobo',289);
insert into programa values ('la nef',1,1,'cop',1502);
insert into programa values ('la nef',1,2,'cop',1012);
insert into programa values ('la nef',1,3,'cop',816);
insert into programa values ('la nef',1,4,'cop',816);
insert into programa values ('la nef',2,1,'baxter',210);
insert into programa values ('la nef',2,2,'baxter',110);
insert into programa values ('la nef',2,3,'baxter',168);
insert into programa values ('la nef',2,4,'la boca del lobo',345);
insert into programa values ('la nef',3,1,'veuve mais pas trop',1200);
insert into programa values ('la nef',3,2,'veuve mais pas trop',1200);
insert into programa values ('la nef',3,3,'veuve mais pas trop',1316);
insert into programa values ('la nef',3,4,'veuve mais pas trop',1009);
insert into programa values ('la nef',4,1,'annee du soleil calme',850);
insert into programa values ('la nef',4,2,'annee du soleil calme',850);
insert into programa values ('la nef',4,3,'annee du soleil calme',850);
insert into programa values ('la nef',4,4,'annee du soleil calme',750);
insert into programa values ('la nef',5,1,'un poisson nomme wanda',1560);
insert into programa values ('la nef',5,2,'un poisson nomme wanda',1820);
insert into programa values ('la nef',5,3,'un poisson nomme wanda',1710);
insert into programa values ('la nef',5,4,'un poisson nomme wanda',910);
insert into programa values ('le club',1,1,'annee du soleil calme',100);
insert into programa values ('le club',1,2,'annee du soleil calme',130);
insert into programa values ('le club',1,3,'annee du soleil calme',110);
insert into programa values ('le club',1,4,'veuve mais pas trop',210);
insert into programa values ('le club',2,1,'cop',20);
insert into programa values ('le club',2,2,'cop',50);
insert into programa values ('le club',2,3,'la boca del lobo',60);
insert into programa values ('le club',2,4,'la boca del lobo',100);
insert into programa values ('le club',3,1,'la baie des anges',800);
insert into programa values ('le club',3,2,'la baie des anges',550);
insert into programa values ('le club',3,3,'la baie des anges',730);
insert into programa values ('le club',3,4,'la baie des anges',600);
insert into programa values ('le club',4,1,'mon cher sujet',245);
insert into programa values ('le club',4,2,'mon cher sujet',200);
insert into programa values ('le club',4,3,'mon cher sujet',214);
insert into programa values ('le club',4,4,'mon cher sujet',189);
insert into programa values ('le club',5,1,'baxter',840);
insert into programa values ('le club',5,2,'baxter',100);
insert into programa values ('le club',5,3,'baxter',276);
insert into programa values ('le club',5,4,'cop',210);
insert into programa values ('le melies', 1,1,'la derniere cible',200);
insert into programa values ('le melies', 1,2,'la derniere cible',234);
insert into programa values ('le melies', 1,3,'la derniere cible',345);
insert into programa values ('le melies', 1,4,'la derniere cible',418);
insert into programa values ('le melies', 2,1,'cop',150);
insert into programa values ('le melies', 2,2,'cop',121);
insert into programa values ('le melies', 2,3,'cop',141);
insert into programa values ('le melies', 2,4,'cop',106);
insert into programa values ('le melies', 3,1,'baxter',150);
insert into programa values ('le melies', 3,2,'baxter',150);
insert into programa values ('le melies', 3,3,'baxter',50);
insert into programa values ('le melies', 3,4,'veuve mais pas trop',261);
insert into programa values ('le melies',3,5,'veuve mais pas trop',400);
insert into programa values ('les 6 rex',1,1,'la derniere cible',400);
insert into programa values ('les 6 rex',1,2,'la derniere cible',230);
insert into programa values ('les 6 rex',1,3,'la derniere cible',342);
insert into programa values ('les 6 rex',1,4,'la derniere cible',284);
insert into programa values ('les 6 rex',2,1,'cop',370);
insert into programa values ('les 6 rex',2,2,'cop',123);
insert into programa values ('les 6 rex',2,3,'cop',219);
insert into programa values ('les 6 rex',2,4,'annee du soleil calme',320);
insert into programa values ('les 6 rex',3,1,'la baie des anges',240);
insert into programa values ('les 6 rex',3,2,'la baie des anges',312);
insert into programa values ('les 6 rex',3,3,'la baie des anges',380);
insert into programa values ('les 6 rex',3,4,'la baie des anges',413);
insert into programa values ('les 6 rex',4,1,'baxter',100);
insert into programa values ('les 6 rex',4,2,'baxter',57);
insert into programa values ('les 6 rex',4,3,'un poisson nomme wanda',412);
insert into programa values ('les 6 rex',4,4,'un poisson nomme wanda',349);
insert into programa values ('les 6 rex',5,1,'veuve mais pas trop',100);
insert into programa values ('les 6 rex',5,2,'veuve mais pas trop',212);
insert into programa values ('les 6 rex',5,3,'veuve mais pas trop',234);
insert into programa values ('les 6 rex',5,4,'veuve mais pas trop',274);
insert into programa values ('les 6 rex',6,1,'mon cher sujet',80);
insert into programa values ('les 6 rex',6,2,'mon cher sujet',180);
insert into programa values ('les 6 rex',6,3,'mon cher sujet',129);
insert into programa values ('les 6 rex',6,4,'mon cher sujet',358);
insert into programa values ('les dauphins',1,1,'annee du soleil calme',250);
insert into programa values ('les dauphins',1,2,'annee du soleil calme',220);
insert into programa values ('les dauphins',1,3,'annee du soleil calme',250);
insert into programa values ('les dauphins',1,4,'annee du soleil calme',214);
insert into programa values ('les dauphins',2,1,'baxter',150);
insert into programa values ('les dauphins',2,2,'baxter',50);
insert into programa values ('les dauphins',2,3,'veuve mais pas trop',150);
insert into programa values ('les dauphins',2,4,'la baie des anges',310);
insert into programa values ('pathe grenette',1,1,'mon cher sujet',600);
insert into programa values ('pathe grenette',1,2,'mon cher sujet',600);
insert into programa values ('pathe grenette',1,3,'mon cher sujet',832);
insert into programa values ('pathe grenette',1,4,'mon cher sujet',548);
insert into programa values ('pathe grenette',2,1,'un poisson nomme wanda',300);
insert into programa values ('pathe grenette',2,2,'un poisson nomme wanda',540);
insert into programa values ('pathe grenette',2,3,'un poisson nomme wanda',356);
insert into programa values ('pathe grenette',2,4,'un poisson nomme wanda',219);
insert into programa values ('pathe grenette',2,5,'un poisson nomme wanda',400);
insert into programa values ('pathe grenette',3,1,'la boca del lobo',300);
insert into programa values ('pathe grenette',3,2,'la boca del lobo',289);
insert into programa values ('pathe grenette',3,3,'la boca del lobo',450);
insert into programa values ('pathe grenette',3,4,'la boca del lobo',240);
insert into programa values ('pathe grenette',4,1,'annee du soleil calme',150);
insert into programa values ('pathe grenette',4,2,'annee du soleil calme',230);
insert into programa values ('pathe grenette',4,3,'annee du soleil calme',215);
insert into programa values ('pathe grenette',4,4,'annee du soleil calme',319);
insert into programa values ('pathe grenette',5,1,'la baie des anges',100);
insert into programa values ('pathe grenette',5,2,'la baie des anges',123);
insert into programa values ('pathe grenette',5,3,'la baie des anges',234);
insert into programa values ('pathe grenette',5,4,'la baie des anges',289);
insert into programa values ('pathe grenette',6,1,'baxter',100);
insert into programa values ('pathe grenette',6,2,'baxter',54);
insert into programa values ('pathe grenette',6,3,'baxter',100);
insert into programa values ('pathe grenette',6,4,'la derniere cible',381);
insert into programa values ('ugc royal',1, 1,'un poisson nomme wanda',600);
insert into programa values ('ugc royal',1, 2,'un poisson nomme wanda',1200);
insert into programa values ('ugc royal',1, 3,'un poisson nomme wanda',843);
insert into programa values ('ugc royal',1, 4,'un poisson nomme wanda',528);
insert into programa values ('ugc royal',2, 1,'baxter',500);
insert into programa values ('ugc royal',2, 2,'baxter',241);
insert into programa values ('ugc royal',2, 3,'baxter',213);
insert into programa values ('ugc royal',2, 4,'baxter',101);
insert into programa values ('ugc royal',3, 1,'mon cher sujet',200);
insert into programa values ('ugc royal',3, 2,'mon cher sujet',242);
insert into programa values ('ugc royal',3, 3,'mon cher sujet',245);
insert into programa values ('ugc royal',3, 4,'mon cher sujet',278);
insert into programa values ('ugc royal',4, 1,'la boca del lobo',100);
insert into programa values ('ugc royal',4, 2,'la boca del lobo',141);
insert into programa values ('ugc royal',4, 3,'la boca del lobo',168);
insert into programa values ('ugc royal',4, 4,'la derniere cible',389);
insert into programa values ('ugc royal',5, 1,'cop',100);
insert into programa values ('ugc royal',5, 2,'cop',120);
insert into programa values ('ugc royal',5, 3,'cop',102);
insert into programa values ('ugc royal',5, 4,'cop',62);
