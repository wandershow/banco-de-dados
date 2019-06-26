pg_dump -U postgres biblioteca1
pg_dump -U postgres -f backup.sql biblioteca1 --inves de mostrar na tela, criou um arquivo chamado backup.sql
pg_dump -U postgres -f backup.sql -- insert biblioteca1 (pg_dump = fazer backup)

privilégios
GRANT
REVOKE
CREATE USER
DROP USER CREATE GROUP
DROP GROUP

create user betito password '12345'; --criou um usuario Betito com senha 12345

\dp --mostra privilégios

grant all on livro to betito; --todas perimissoes na tabela livro para o usuario Betito
grant select on exemplar to betito; --só da permissao de fazer select na tabela exemplar pro usuario Betito
psql -U betito biblioteca1 --loga como usuario betito no banco biblioteca1
revoke all on exemplar from betito; -- retira as permissao
drop user betito;

NÃO É PRA FAZER ASSIM

baixar driver para conexão de java com postgres: https://jdbc.postgresql.org/download.html

jar: java compilado dentro de um zip

eclipse: clica com direito no projeto>build path>configure build path>add external JARs, clica no arq drive jar

conectar via jbc, nesse local/ip onde nome do banco é biblioteca 1, como usuario e com senha 12345
"jdbc:postgresql://localhost/biblioteca1", "usuario",'12345"
