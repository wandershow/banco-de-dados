-- http://sqlfiddle.com

\c bd1  -- aqui

select 1+2*3;
select 1+(2*3);
select 1+(2*3) as resultado;                        -- soma e mostra em uma coluna resultado
select CURRENT_TIME;                                -- hora exata no servidor // 11:29:28.076871-03
select CURRENT_DATE;                                -- data atual no servidor // 2019-04-04  **padrão americano "yyyy-mm-dd"
select now();                                       -- data e hora do atual  // 2019-04-04 11:33:12.587491-03
select round(3.14151617181920,3);                   -- mostra penas 3 casas apos a virgula arredondado para cima ou para baixo  // 3.142
select real '12.34';                                -- transforma a string para real
select '12.34'::real;                               -- transforma a string para real de forma correta
select cast('12.34' as real);                       -- transforma a string para real serve para todos os bd's
select '12'::real + 3;                              -- maneira correta de somar string com inteiro, transforma para real e depois soma
select now();
select now()+'2 months 3 days 14 hours'::interval;  -- Pega data e hora atual e soma o tempo que quizer com a função ::interval
select ((2 < 3) = true);                            -- se for verdadeiro a expressão retorna 't'
select ((2 < 3) <> true);                           -- se 2 < 3 for diferente <> de true retorna 'f', nesse caso é 't'
select 'true'::boolean;
select 'abc'||'xyz';    --assim que concatena string, usa ||


\i programacaonet.sql  -- aqui importa para o banco de dados para dentro sgbd

select * from canal;                                -- mostra tudo ' * ' da tabela canal
--------------------------------------
select codigo,nome from canal;        |             
select nome from canal;               |  -- não usar
select nome as nome_canal from canal; |
--------------------------------------
select nome from canal limit 10;                    -- paginação usar esse
select nome from canal limit 10 offset 0;           -- mostra o nome do canal, os primeiros 10
select nome from canal limit 10 offset 10;          -- mostra 10 apartir da posição 10
select nome from canal limit 10 offset 20;          -- mostra 10 apartir da posição 20
select * from programa limit 10 offset 0;           -- mostra os primeiros 10 campos de cada coluna da tabela canal.

select * from programa where canal = 'PLA';                                            --mostra tudo da tabela programa onde o canal = 'PLA'
select * from programa where canal = 'PLA' limit 15 offset 0;                          --mostra 15 campos de cada coluna da tabela programa onde o canal = 'PLA' apartir da posição 0
select * from programa where canal = 'PLA' order by nome asc limit 10 offset 0;        --mostra 10 campos de cada coluna onde o canal = 'PLA' ordena pela coluna nome de forma crescente
select * from programa where canal = 'PLA' order by nome desc limit 10 offset 0;       --mostra 10 campos de cada coluna onde o canal = 'PLA' ordena pela coluna nome de forma decrescente 
select * from programa where canal = 'PLA' order by 4 desc limit 10 offset 0;          --aqui faz a mesma coisa que o de cima passando o numero da coluna e nao o nome da coluna
select * from programa where canal = 'PLA' order by nome desc,horario asc limit 10 offset 0; --10 campos de cada coluna onde o canal = 'PLA' ordena pela coluna nome desc, horario asc
 
 
select nome from programa where canal = 'PLA' order by nome asc; --mostra todos os nomes de programas do canal 'PLA' em ordem crescente
select distinct nome from programa where canal = 'PLA' order by nome asc; --mostra todos os nomes de programas do canal 'PLA' sem repetir em ordem cresc


select * from programa where horario = '2009-05-01 13:00'::timestamp;    --mostra tds campos de cada coluna da tabela programa onde horario = '2009-05-01 13:00'::timestamp
select * from programa where horario = '2009-05-01 13:00:15'::timestamp; --mostra tds campos de cada coluna da tabela programa onde horario = '2009-05-01 13:00:15'::timestamp
select * from programa where horario = '2009-05-01'::date;               --nesse dia as 00:00:00

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
                                                   --todos dentro de 24h--
select * from programa where (horario >= '2009-05-01 00:00'::timestamp) and (horario <= '2009-05-01 23:59'::timestamp);

                                                   -- todos dentro de 24h do canal 'PLA' --
select * from programa where (horario >= '2009-05-01 00:00'::timestamp) and (horario <= '2009-05-01 23:59'::timestamp) and (canal ='PLA');

                                                   -- todos dentro de 24h do canal 'PLA' --
select * from programa where (horario >= '2009-05-01'::date) and (horario < ('2009-05-01'::date+'1 day'::interval)) and (canal ='PLA');

                                                   -- todos dentro de 24h do canal 'PLA'  os 10 primeiros--
select * from programa where (horario >= '2009-05-01'::date) and (horario < ('2009-05-01'::date+'1 day'::interval)) and (canal ='PLA') limit 10 offset 0;

                                                   -- todos dentro de 24h do canal 'PLA' --
select * from programa where (horario between '2009-05-01 00:00'::timestamp and '2009-05-01 23:59'::timestamp) and (canal ='PLA');

          --os 10 primeiros data em horario--
select horario::date from programa limit 10 offset 0;

    --pegando horario e transformando em data)--
select horario cast(horario as date) from programa limit 10 offset 0;

        -- todos dentro de 24h do canal 'PLA' --
select * from programa where (horario::date = '2009-05-01'::date) and (canal = 'PLA');

-- todos dentro de 24h do canal 'PLA' os 10 primeiros --
select * from programa where (horario::date = '2009-05-01'::date) and (canal ='PLA') limit 10 offset 0;

            -- mostra so o dia --
select date_part('day',horario) from programa where (canal = 'PLA');
            -- mostra so mes --
select date_part('month',horario) from programa where (canal = 'PLA');
            -- mostra so o ano --
select date_part('year',horario) from programa where (canal = 'PLA');

                                                    -- mostra a data no padrão brasileiro  'dd/mm/aaaa' --
select to_char(date_part('day',horario),'00')||'/'||to_char(date_part('month',horario),'00')||'/'||to_char(date_part('year',horario),'0000') from programa where (canal = 'PLA');
                                                  
                                                    -- mostra a data no padrão brasileiro  'dd/mm/aaaa' --
select ltrim(to_char(date_part('day',horario),'00'))||'/'||ltrim(to_char(date_part('month',horario),'00'))||'/'||ltrim(to_char(date_part('year',horario),'0000')) from programa where (canal = 'PLA');

                                                    -- mostra todas colunas mais a data no padrão brasileiro  'dd/mm/aaaa' --
select *,ltrim(to_char(date_part('day',horario),'00'))||'/'||ltrim(to_char(date_part('month',horario),'00'))||'/'||ltrim(to_char(date_part('year',horario),'0000')) from programa where (canal = 'PLA');

                                                    -- mostra todas colunas mais a data no padrão brasileiro  'dd/mm/aaaa' e nomeia a tabela criada como data --
select canal,ltrim(to_char(date_part('day',horario),'00'))||'/'||ltrim(to_char(date_part('month',horario),'00'))||'/'||ltrim(to_char(date_part('year',horario),'0000')) as data,nome from programa where (canal = 'PLA');

                        -- mesma coisa que a de cima --
select canal,to_char(horario,'DD/MM/YYYY') as data,nome from programa where (canal = 'PLA');

                        -- dia da semana por numero, Dom 0, seg 1)--
select *,date_part('dow',horario) as dia_semana from programa where (canal = 'PLA');

    --dias da semana direitinho
select *, case date_part('dow',horario)
	when 0 then 'Domingo'
	when 1 then 'Segunda'
	when 2 then 'Terça'
	when 3 then 'Quarta'
	when 4 then 'Quinta'
	when 5 then 'Sexta'
	when 6 then 'Sábado' end as dia_semana from programa where (canal = 'PLA');

                --mesma coisa que o de cima -- precisa adicionar +1 porque no postgres o vetor começa a partir de 1, diferente do java que eh a partir de 0
select *,('{Domingo,Segunda,Terça,Quarta,Quinta,Sexta,Sabado}'::text[])[date_part('dow',horario)+1] as dia_semana from programa where (canal = 'PLA');


insert into tabela (data) values (to_date('31/12/1990','DD/MM/YYYY'));
        -- passo a passo como ele chegou no programa que esta passando no momento...
select * from programa where (horario = '2009-05-10 13:10'::timestamp) and (canal = 'PLA');
select * from programa where (horario <= '2009-05-10 13:10'::timestamp) and (canal = 'PLA');
select * from programa where (horario <= '2009-05-02 13:10'::timestamp) and (canal = 'PLA') order by horario desc;
select * from programa where (horario <= '2009-05-02 13:10'::timestamp) and (canal = 'PLA') order by horario desc limit 1;
                --programa que esta passando nesse momento
select * from programa where (horario <= now()) and (canal = 'PLA') order by horario desc limit 1;

