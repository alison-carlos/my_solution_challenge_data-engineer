
### Repositório Criado para apresentar minha solução para o desafio <a href="https://github.com/AmeDigital/challenge-data-engineer" target="_blank">AmeDigital</a>

A primeira etapa do desafio foi criar um banco de dados relacional baseado no arquivo "base_de_respostas_10k_amostra.csv"

Seguindo o modelo proposto abaixo.

![Modelo ER](images/modelo_entidade_relacionamento.png)

E levando em consideração as regras de negócios definidas:

![Regras de Negócio](images/regras_de_negocio.png)

____________________________________________________________________________________________________________________________________________________________________

Neste projeto optei por trabalhar no banco de dados SQL Server.

Para a importação dos dados optei por utilizar o Python, com a biblioteca do pandas.

~~~python
import pandas as pd
import pyodbc

data = pd.read_csv(r'D:\Projects\AmeDigital_MySolution\File\base_de_respostas_10k_amostra.csv')

df = pd.DataFrame(data, columns= ['Respondent', 'Hobby', 'OpenSource', 'Country', 'Student', 'Employment', 'FormalEducation', 'UndergradMajor', 'CompanySize', 'DevType', 'YearsCoding', 'YearsCodingProf', \
  'JobSatisfaction', 'CareerSatisfaction', 'HopeFiveYears', 'JobSearchStatus', 'LastNewJob', 'AssessJob1', 'AssessJob2', 'AssessJob3', 'AssessJob4', 'AssessJob5', 'AssessJob6', 'AssessJob7', 'AssessJob8', \
  'AssessJob9', 'AssessJob10', 'AssessBenefits1', 'AssessBenefits2', 'AssessBenefits3', 'AssessBenefits4', 'AssessBenefits5', 'AssessBenefits6', 'AssessBenefits7', 'AssessBenefits8', 'AssessBenefits9', \
  'AssessBenefits10', 'AssessBenefits11', 'JobContactPriorities1', 'JobContactPriorities2', 'JobContactPriorities3', 'JobContactPriorities4', 'JobContactPriorities5', 'JobEmailPriorities1', 'JobEmailPriorities2', \
  'JobEmailPriorities3', 'JobEmailPriorities4', 'JobEmailPriorities5', 'JobEmailPriorities6', 'JobEmailPriorities7', 'UpdateCV', 'Currency', 'Salary', 'SalaryType', 'ConvertedSalary', 'CurrencySymbol', 'CommunicationTools', \
  'TimeFullyProductive', 'EducationTypes', 'SelfTaughtTypes', 'TimeAfterBootcamp', 'HackathonReasons', 'AgreeDisagree1', 'AgreeDisagree2', 'AgreeDisagree3', 'LanguageWorkedWith', 'LanguageDesireNextYear', 'DatabaseWorkedWith', \
  'DatabaseDesireNextYear', 'PlatformWorkedWith', 'PlatformDesireNextYear', 'FrameworkWorkedWith', 'FrameworkDesireNextYear', 'IDE', 'OperatingSystem', 'NumberMonitors', 'Methodology', 'VersionControl', 'CheckInCode', 'AdBlocker', \
  'AdBlockerDisable', 'AdBlockerReasons', 'AdsAgreeDisagree1', 'AdsAgreeDisagree2', 'AdsAgreeDisagree3', 'AdsActions', 'AdsPriorities1', 'AdsPriorities2', 'AdsPriorities3', 'AdsPriorities4', 'AdsPriorities5', 'AdsPriorities6', 'AdsPriorities7', \
  'AIDangerous', 'AIInteresting', 'AIResponsible', 'AIFuture', 'EthicsChoice', 'EthicsReport', 'EthicsResponsible', 'EthicalImplications', 'StackOverflowRecommend', 'StackOverflowVisit', 'StackOverflowHasAccount', 'StackOverflowParticipate', \
  'StackOverflowJobs', 'StackOverflowDevStory', 'StackOverflowJobsRecommend', 'StackOverflowConsiderMember', 'HypotheticalTools1', 'HypotheticalTools2', 'HypotheticalTools3', 'HypotheticalTools4', 'HypotheticalTools5', 'WakeTime', 'HoursComputer', \
  'HoursOutside', 'SkipMeals', 'ErgonomicDevices', 'Exercise', 'Gender', 'SexualOrientation', 'EducationParents', 'RaceEthnicity', 'Age', 'Dependents', 'MilitaryUS', 'SurveyTooLong', 'SurveyEasy'])

# Connection with database

server = 'DESKTOP-O45NRLD\TEST' 
database = 'AmeDigital_Project' 
username = 'admin.amedigital' 
password = 'Am3D1g1T4L' 
cnxn = pyodbc.connect('DRIVER={SQL Server};SERVER='+server+';DATABASE='+database+';UID='+username+';PWD='+ password)
cursor = cnxn.cursor()

# Insert the data

cursor = cnxn.cursor()

# Limpa a tabela
cursor.execute("TRUNCATE TABLE RawData.Respondent")

# Salário vazio ou com valor "NA" deve ser convertido para zero (0.0).

df["Salary"].fillna("0.0", inplace=True)
df["SalaryType"].fillna("null", inplace=True)
df["ConvertedSalary"].fillna("0.0", inplace=True)
df["CurrencySymbol"].fillna("null", inplace=True)
df["OperatingSystem"].fillna("null", inplace=True)
df["Country"].fillna("null", inplace=True)
df["CompanySize"].fillna("null", inplace=True)
df["CommunicationTools"].fillna("null", inplace=True)
df["LanguageWorkedWith"].fillna("null", inplace=True)

# Insert Dataframe into SQL Server:
for index, row in df.iterrows():

  cursor.execute("INSERT INTO RawData.Respondent (Respondent, OpenSource, Hobby, Salary, SalaryType, ConvertedSalary, CurrencySymbol, OperatingSystem, Country, CompanySize, CommunicationTools, LanguageWorkedWith) values (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)",
  row.Respondent, row.OpenSource, row.Hobby, row.Salary, row.SalaryType, row.ConvertedSalary, row.CurrencySymbol, row.OperatingSystem, row.Country, row.CompanySize, row.CommunicationTools, row.LanguageWorkedWith)

cnxn.commit()
cursor.close()

~~~

Eu obtei por fazer ELT (Extract, Load, Transform) então, carreguei o arquivo ".csv" no formato original e foi realizando os tratamentos antes de colocar na tabela final.

![Select na tabela RAW](images/select_raw_data.png)

Com o arquivo no banco de dados, começei a trabalhar na arquitetura das tabelas do modelo ER

```

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
round(((convert(float,ConvertedSalary) / 3.81) / 12), 2) as [salario],
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

```

As tabelas desta forma no banco de dados

![Select na tabela sistema_operacional](images/select_production.sistema_operacional.PNG)

![Select na tabela pais](images/select_production.pais.PNG)

![Select na tabela empresa](images/select_production.sistema_operacional.PNG)

![Select na tabela respondente](images/select_production.respondente.PNG)



