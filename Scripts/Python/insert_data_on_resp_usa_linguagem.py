
import pandas as pd
import pyodbc
import conf as conf

credentials = conf.credentials()

server = credentials[0]
database = credentials[1]
username = credentials[2]
password = credentials[3]
cnxn = pyodbc.connect('DRIVER={SQL Server};SERVER='+server+';DATABASE='+database+';UID='+username+';PWD='+ password)
cursor = cnxn.cursor()

# Open the cursor
cursor = cnxn.cursor()

# This variable will receive the uniques programming language names.
all_programming_language = set()

# This variable will receive the ID of the respodent and the ID of the Programming Languages
resp_usa_linguagem = list()

# Convert the object pyodbc in a list
list_of_languages = list(cursor.execute("Select distinct Respondent, LanguageWorkedWith from [RawData].[Respondent] where LanguageWorkedWith is not null order by Respondent asc"))

for row in list_of_languages:
    
    languages = row[1].split(';')
    
    for language in languages:
        # Assigning the distinct programming languages to the set.
        all_programming_language.add(language)

        # Creating the relation between the respondent and the programming languages that he uses.
        x = {
        'respondente_id' : row[0],
        'linguagem_programacao_id' : language
        }

        resp_usa_linguagem.append(x)

# Clear the table resp_usa_linguagem
cursor.execute("Truncate table Production.resp_usa_linguagem")

# Clear the table linguagem_programacao
cursor.execute("delete from Production.linguagem_programacao")

for programming_language in all_programming_language:
    # Insert the distinct programming language on the table.
    cursor.execute("Insert into Production.linguagem_programacao (nome) values (?)", programming_language) 

list_of_languages_with_id = list(cursor.execute("Select * from Production.linguagem_programacao"))

for row in resp_usa_linguagem:
    
    for language in list_of_languages_with_id:
        
        if row['linguagem_programacao_id'] == language[1]:
            row['linguagem_programacao_id'] = language[0]
            break

for row in resp_usa_linguagem:
    cursor.execute("Insert into Production.resp_usa_linguagem (respondente_id, linguagem_programacao_id) values (?, ?)", row['respondente_id'], row['linguagem_programacao_id'])

cnxn.commit()
cursor.close()
