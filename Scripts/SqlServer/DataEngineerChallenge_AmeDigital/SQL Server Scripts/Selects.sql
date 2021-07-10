

Select * from Production.resp_usa_ferrament asxxa
join Production.ferramenta_comunic axsa
on asxxa.ferramenta_comunic_id = axsa.id
where respondente_id = 70881

Select * from Production.resp_usa_linguagem

-----------------------------------------------------------------------------


-- 1.	Qual a quantidade de respondentes de cada pa�s?


Select p.nome as Pais, COUNT(*) as QuantidadeRespondetes from Production.respondente r (nolock)
join Production.pais p (nolock)
on r.pais_id = p.id
group by p.nome
order by QuantidadeRespondetes desc

-- 2. Quantos usu�rios que moram em "United States" gostam de Windows?

Select COUNT(*) as Quantidade from Production.respondente r (nolock)
join Production.pais p (nolock)
on r.pais_id = p.id
join Production.sistema_operacional so (nolock)
on r.sistema_operacional_id = so.id
where p.nome = 'United States' and so.nome = 'Windows'

-- 3. Qual a m�dia de sal�rio dos usu�rios que moram em Israel e gostam de Linux?

Select p.nome as Pais, ROUND(AVG(r.salario), 2) as Salario from Production.respondente r (nolock)
join Production.pais p (nolock)
on r.pais_id = p.id
join Production.sistema_operacional so (nolock)
on r.sistema_operacional_id = so.id
where p.nome = 'Israel' and so.nome = 'Linux-based' and r.salario > 0
group by p.nome

-- 4. Qual a m�dia e o desvio padr�o do sal�rio dos usu�rios que usam Slack para cada tamanho de empresa dispon�vel? 
--(dica: o resultado deve ser uma tabela semelhante a apresentada abaixo)

Select e.tamanho, ROUND(AVG(r.salario), 2) as media_salario, ROUND(STDEV(distinct r.salario), 2) desvio_p_salario 
from Production.respondente r (nolock)
join Production.resp_usa_ferrament ruf (nolock)
on r.id = ruf.respondente_id
join Production.ferramenta_comunic fc (nolock)
on ruf.ferramenta_comunic_id = fc.id
left join Production.empresa e (nolock)
on r.empresa_id = e.id
where fc.nome = 'Slack' and r.salario > 0
group by e.tamanho
order by media_salario desc

-- 5. Qual a diferen�a entre a m�dia de sal�rio dos respondentes do Brasil que acham que criar c�digo � um hobby e a m�dia de todos de sal�rio de
--todos os respondentes brasileiros agrupado por cada sistema operacional que eles usam? (dica: o resultado deve ser uma tabela semelhante a 
--apresentada abaixo)

With media_hobby as (

	Select r.pais_id, round(AVG(salario), 2) as media_hobby from Production.respondente r (nolock)
	join Production.pais p (nolock)
	on r.pais_id = p.id

	where r.programa_hobby = 1 and p.nome = 'Brazil' and salario > 0
	group by r.pais_id
) 
Select so.nome, m.media_hobby, 
round(AVG(r.salario), 2) as media_geral,
round(AVG(r.salario), 2) - m.media_hobby as diff_media
from Production.respondente r (nolock)
join media_hobby m (nolock)
on r.pais_id = m.pais_id
join Production.sistema_operacional so (nolock)
on r.sistema_operacional_id = so.id
group by so.nome, media_hobby
