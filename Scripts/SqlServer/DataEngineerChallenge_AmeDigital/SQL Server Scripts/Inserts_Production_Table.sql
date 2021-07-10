
BEGIN TRANSACTION

--Select c from RawData.Respondent

drop table if exists Production.respondente 
drop table if exists Production.sistema_operacional 
drop table if exists Production.pais 
drop table if exists Production.empresa 


-- Converte o texto null para nulo.
Update RawData.Respondent set OpenSource = null where OpenSource = 'null'
Update RawData.Respondent set Hobby = null where OpenSource = 'null'
Update RawData.Respondent set SalaryType = null where SalaryType = 'null'
Update RawData.Respondent set CurrencySymbol = null where CurrencySymbol = 'null'
Update RawData.Respondent set OperatingSystem = null where OperatingSystem = 'null'
Update RawData.Respondent set Country = null where Country = 'null'
Update RawData.Respondent set CompanySize = null where CompanySize = 'null'
Update RawData.Respondent set CommunicationTools = null where CommunicationTools = 'null'
Update RawData.Respondent set LanguageWorkedWith = null where LanguageWorkedWith = 'null'

Create table Production.sistema_operacional (

id int identity primary key,
nome varchar(255))

Insert into Production.sistema_operacional (nome) 
Select distinct OperatingSystem from RawData.Respondent where OperatingSystem is not null

-- Select * from Production.sistema_operacional

----------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------

Create table Production.pais (
id int identity primary key,
nome varchar(255))

Insert into Production.pais (nome)
Select distinct Country from RawData.Respondent where Country is not null

-- Select * from Production.pais

----------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------

Create table Production.empresa (
id int identity primary key,
tamanho varchar(255))

Insert into Production.empresa (tamanho)
Select distinct CompanySize from RawData.Respondent where CompanySize is not null

-- Select * from Production.empresa

----------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------


Create table Production.respondente (
id int primary key,
nome varchar(255),
contrib_open_source bit,
programa_hobby bit,
salario float,
sistema_operacional_id int,
pais_id int,
empresa_id int)

-- Adicionando as FK's

Alter table Production.respondente
Add foreign key (sistema_operacional_id) references Production.sistema_operacional(id)

Alter table Production.respondente
Add foreign key (pais_id) references Production.pais(id)

Alter table Production.respondente
Add foreign key (empresa_id) references Production.empresa(id)

Insert into Production.respondente (id, nome, contrib_open_source, programa_hobby, salario, sistema_operacional_id, pais_id, empresa_id)

Select Respondent as [id], null as [nome], case when OpenSource = 'Yes' then 1 else 0 end as [contrib_open_source],
case when Hobby = 'Yes' then 1 else 0 end as programa_hobby,
round(((convert(float,ConvertedSalary) * 3.81) / 12), 2) as [salario],
so.id as [sistema_operacional_id],
p.id as [pais_id],
e.id as [empresa_id]

from RawData.Respondent r (nolock)
left join Production.sistema_operacional so (nolock)
on r.OperatingSystem = so.nome
left join Production.pais p (nolock)
on r.Country = p.nome
left join Production.empresa e (nolock)
on r.CompanySize = e.tamanho

--Select * from Production.respondente


IF @@ERROR = 0
COMMIT
ELSE
ROLLBACK

