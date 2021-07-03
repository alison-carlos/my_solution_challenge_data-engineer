
### Repositório Criado para apresentar minha solução para o desafio <a href="https://github.com/AmeDigital/challenge-data-engineer" target="_blank">AmeDigital</a>

A primeira etapa do desafio foi criar um banco de dados relacional baseado no arquivo "base_de_respostas_10k_amostra.csv"

Seguindo o modelo proposto abaixo.

![Modelo ER](images/modelo_entidade_relacionamento.png)

E levando em consideração as regras de negócios definidas:

![Regras de Negócio](images/regras_de_negocio.png)

____________________________________________________________________________________________________________________________________________________________________

Neste projeto optei por trabalhar no banco de dados SQL Server.

Para a importação dos dados optei por utilizar o Python, com a biblioteca do pandas.

```
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

```

Eu obtei por fazer ELT (Extract, Load, Transform) então, carreguei o arquivo ".csv" no formato original e foi realizando os tratamentos antes de colocar na tabela final.

![Select na tabela RAW](images\select_raw_data.png)

