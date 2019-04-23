select 1+2;

select 1+2*3; --incorreto.

select 1+(2*3; --fazer assim, não deixar postgres adivinhar nada.

\! clear  -- limpar tela

select 1+(2*3) as resultado; --vai dar uma coluna com nome de "resultado"

select CURRENTE_TIME; -- hora,minuto,seg,mil

select now() --timestamp: data,hora

select round(3.14151617181920,3) --valor que quero arredondar, 3 casas.

select real '12.34';

select '12.34'::real;

select cast('12.34' as real); --os três métodos transforma os números que eram texto em número, são conversão, mas essa é generalizada.

select '12.34'::real+3.14; --transforma em real e soma;

select now()+'2 months 3 days 14 hours'::interval; --interval é um periodo de tempo que pode acresentar ou subtrair de uma data/hora.

select now()-'1 hours 35 minutes'::interval;

select '2019-04-02'::date; --virou data

select '2019-04-02'::date+'5 hours'::interval;

select (2 < 3);

select ((2 < 3) = true);

select ((2 < 3) = false);

select ((2 < 3) = 'true'::boolean); --devolve true ou false

xxxxx  DENTRO DO BANCO programacaonet.sql xxxxx

\d programa_codigo_seq  --dados do banco

select * from canal; --mostra TUDO (*) que tem em canal: codigo e nome.

select nome from canal; --mostra os nome da tabela canal.

select codigo from canal; -- codigo da tabela canal;

select codigo, nome from canal; -- msm coisa no caso que o *, porem é mais rapido, também pode trocar a ordem: nome,codigo.

select codigo as xuxa, nome as sasha from canal; --vai mostrar os os dados da tabela codigo e nome, com nome da coluna trocado.

select 'betetio' as lindao, codigo as xuxa, nome as sasha from canal; -- adiciona coluna lindao com nome betito em todas.

select 'betetio' as lindao, pi() as numero, codigo as xuxa, nome as sasha from canal; --adicionou coluna pi.

select codigo, nome from canal limit 10; --sómente as 10 primeiras linhas.

select codigo, nome from canal limit 10 offset 0; --me de 10 linhas de codigo e nome a partir da linha 0.

select codigo, nome from canal limit 10 offset 10; -- as próximas 10 linhas depois do codigo acima.

select * from programa limit 20; -- quero todas colunas da tebela programa mas decrescentesómente as 20 primeiras.

select * from programa where canal = 'PLA'; --seleciona todas colunas de programa onde canal é igual a 'PLA'.

select * from programa where canal = 'PLA' limit 10; --seleciona todas colunas de programa onde canal é igual a 'PLA' e sómente 10 primeiros.

select * from programa where canal = 'PLA'  order by nome asc limit 10; --mesma coisa mas ordenado pelo nome de forma crescente, order by é antes de limit.

select * from programa where canal = 'PLA'  order by nome desc limit 10; --decrescente

select * from programa where canal = 'PLA'  order by 4 desc limit 10; --aqui ele escolhe pra ordernar a partir da quarta coluna.

select * from programa where canal = 'PLA'  order by 3 asc, 4 desc limit 10; --ordena primeiropelo horario e depois pelo nome.

select distinct nome from programa where canal = 'PLA' order by nome asc; -- vai mostrar os nome de forma asc sem repetir o nome.

select * from programa where horario = '2009-05-01 13:00:15'::timestamp;

select * from programa where horario = '2009-05-01'::date; --todos programas que passaram nesse dia mas sem horario por estar sem horario definido.

select * from programa where (horario >= '2009-05-01 00:00:00'::timestamp) and (horario <= '2009-05-01 23:59:59'::timestamp); -- todos dentro de 00:00:00 e 23:59:59.

select * from programa where (horario >= '2009-05-01'::date) and (horario < '2009-05-02'::date); -- mesma resposta.

select * from programa where (horario >= '2009-05-01'::date) and (horario <= '2009-05-01'::date+'1day'::interval); --mesma resposta.

select * from programa where (canal = 'PLA') and (horario >= '2009-05-01'::date) and (horario < '2009-05-01'::date+'1day'::interval) order by horario asc limit 10 offset 0; -- 10 primeiro progrmas daquele dia.

select * from programa where (canal = 'PLA') and (horario between '2009-05-01'::date and '2009-05-01'::date+'1day'::interval) order by horario asc limit 10 offset 0; -- between é: de tal dia até tal dia, entre esses dias.

select * from programa where (canal = 'PLA') and (horario::date = '2009-05-01'::date) order by horario asc limit 10 offset 0; -- mesma resposta que o de cima

\! cal 2009 -- calendario de 2009 (linux)

select extract(dow from '2019-04-02'::date); -- devolve dia de semana em número, domingo 0, seg 1, ter 2, etc...

select extract(dow from now()); -- dia da semana do dia atual.

select date_part('dow', now()); -- pega o dia da semana dessa data.

--date_part equivalente ao extract

select date_part('day', now());

select date_part('month', now());

select date_part('year', now());

select * from programa where date_part('dow', horario) = 0; -- tudo que passou em domingo de todos canais.

select * from programa where (date_part('dow', horario) = 0) and (canal = 'PLA'); -- todos canal da PLA que passaram em um domingo

select *,date_part('day', horario) as dia from programa limit 20; --adicionou coluna dia, se for adicionar depois de tudo é *,nova coluna.

select *,date_part('day', horario) as dia,date_part('month', horario) as mes from programa limit 20; --adicionou coluna mes.

select *,date_part('day', horario) as dia,date_part('month', horario) as mes,date_part('year', horario) as ano from programa limit 20; --adicionou coluna ano.

select *, ltrim(to_char(date_part('day', horario), '00')) || '/' || 
          ltrim(to_char(date_part('month', horario), '00')) || '/' || 
	  ltrim(to_char(date_part('year', horario), '0000')) as data from programa limit 20;

select codigo,canal, trim(to_char(date_part('day', horario), '00')) || '/' || ltrim(to_char(date_part('month', horario), '00')) || '/' || ltrim(to_char(date_part('year', horario), '0000')) as data, horario::time as hora, nome from programa limit 20;

select codigo,canal, ltrim(to_char(horario, 'DD/MM/YYYY')) as data, horario::time as hora, nome from programa limit 20;


-- to_char pega o parametro e transfomra em texto, exemplo:  to_char(3, '00') = '03'

select codigo,canal, ltrim(to_char(horario, 'DD/MM/YYYY')) as data, horario::time as hora,
date_part('dow', horario) as dia_da_semana, nome from programa limit 20;

--select case when 1<2 then 'a' else 'b' end;

--select case when 3<2 then 'a' else 'b' end;

--select *, case when current_date - nascimento > 18 then 'maior' else 'menor' end as maioridade from pessoa;

--select *, case when geberi = 'F' then 'muié' else 'omi' end as general from pessoa;

select codigo,
	canal,
	ltrim(to_char(horario, 'DD/MM/YYYY')) as data,
	horario::time as hora,
	case date_part('dow', horario)
		when 0 then 'domingo'
		when 1 then 'segunda'
		when 2 then 'terca'
		when 3 then 'quarta'
		when 4 then 'quinta'
		when 5 then 'sexta'
		when 6 then 'sabado'
	end as dia_da_semana,
	nome 
from 
	programa
limit 20;


select codigo,
	canal,
	ltrim(to_char(horario, 'DD/MM/YYYY')) as data,
	horario::time as hora,
	('{Domingo,Segunda,Terça,Quarta,Quinta,Sexta,Sabado}'::text[])[date_part('dow', horario)+1] as dia_da_semana,
	nome 
from 
	programa
limit 20;

--converte tudo pra vetor de texto [ ... ] , dps usa ( [ ... ] ), o +1 é pra seguinta coisa, no postgres o domingo é 0, mas no vetor é 1
-- o +1 é pra quando der domingo ele busque o valor no vetor que seria 0 + 1 = 1, 1 é a posição de domingo no vetor.

insert into TABELA (data) values ('2019-04-03');
insert into TABELA (data) values (to_date('2019/04/03', 'DD/MM/YYYY')); 
insert into TABELA (data) values (to_date('2019.04.03', 'DD.MM.YYYY')); 

'2009-05-10 13:10'

-- programa passando AGORA no canal PLA
select * from programa where (horario <= '2009-05-10 13:10'::timestamp) and (canal = 'PLA') order by horario desc limit 1;

select * from programa where (horario <= now()) and (canal = 'PLA') order by horario desc limit 1;
