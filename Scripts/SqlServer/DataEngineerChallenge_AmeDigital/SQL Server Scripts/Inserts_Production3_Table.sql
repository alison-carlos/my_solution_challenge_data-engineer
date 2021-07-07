
drop table if exists Production.linguagem_programacao 

create table Production.linguagem_programacao (

id int identity primary key not null,
nome varchar(255)
)


drop table if exists Production.resp_usa_linguagem 

create table Production.resp_usa_linguagem (
respondente_id int,
linguagem_programacao_id int,
momento bit

)

alter table Production.resp_usa_linguagem
add foreign key (respondente_id) references Production.respondente(id)

alter table Production.resp_usa_linguagem
add foreign key (linguagem_programacao_id) references Production.linguagem_programacao(id)

