
DROP TABLE IF EXISTS Production.ferramenta_comunic 

Create table Production.ferramenta_comunic  (

id int identity primary key,
nome varchar(255)
)

GO

DROP TABLE IF EXISTS Production.resp_usa_ferrament

Create table Production.resp_usa_ferrament  (

ferramenta_comunic_id int,
respondente_id int

)









