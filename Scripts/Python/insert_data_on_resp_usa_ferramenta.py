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

# This variable will receive the name of the unique communication tools 
unique_tools = set()
# This list will receive all communication tools
list_of_communicationstools = []

query =  cursor.execute("Select distinct Respondent, CommunicationTools from [RawData].[Respondent] where CommunicationTools is not null order by Respondent asc")

# For each row will append the respondet and his communication tools
for row in query:
    x = { 
        'Respondent' : row[0],
        'Tools' : row[1]
        }
    list_of_communicationstools.append(x)

# Passing for all the tools
for tool in list_of_communicationstools:
    list_of_tool = tool['Tools'].split(';')
    for tool in list_of_tool:
        unique_tools.add(tool)

# Clear the table ferramenta_comunic
cursor.execute("Truncate table Production.ferramenta_comunic")

# Insert the unique communication tools
for tool in unique_tools:
    cursor.execute("Insert into Production.ferramenta_comunic (nome) values (?)", tool) 

#########################################################################################

# Clear the table ferramenta_comunic
cursor.execute("Truncate table Production.resp_usa_ferrament")

# This second part relates the respondent to the ID's of the tools that he uses

# Receive a list with the ID and the Tool
tool_id = cursor.execute("Select * from Production.ferramenta_comunic")

ferramenta_comunic = []

for x in tool_id:
    ferramenta_comunic.append(x)

resp_usa_ferramenta = []

for row in list_of_communicationstools:

    list_of_tool = row['Tools'].split(';')
    
    for tool in list_of_tool:

        x = {
            'Respondent' : row['Respondent'],
            'ID' : tool
            }

        resp_usa_ferramenta.append(x)


# Convert the name to the ID
for x in resp_usa_ferramenta:
    for y in ferramenta_comunic:
        if x['ID'] == y[1]:
            x['ID'] = y[0]
            break

# Insert this into SQL 
for id in resp_usa_ferramenta:
    cursor.execute("Insert into Production.resp_usa_ferrament (ferramenta_comunic_id, respondente_id) values (?, ?)", id['ID'], id['Respondent'])

cnxn.commit()
cursor.close()

print('Carga concluida com sucesso!')