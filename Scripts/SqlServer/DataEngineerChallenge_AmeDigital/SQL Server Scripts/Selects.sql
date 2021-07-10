

Select * from Production.resp_usa_ferrament asxxa
join Production.ferramenta_comunic axsa
on asxxa.ferramenta_comunic_id = axsa.id
where respondente_id = 70881

Select * from Production.resp_usa_linguagem

-----------------------------------------------------------------------------


-- 1.	Qual a quantidade de respondentes de cada país?


Select p.nome as Pais, COUNT(*) as QuantidadeRespondetes from Production.respondente r (nolock)
join Production.pais p (nolock)
on r.pais_id = p.id
group by p.nome
order by QuantidadeRespondetes desc

-- 2. Quantos usuários que moram em "United States" gostam de Windows?

Select COUNT(*) as Quantidade from Production.respondente r (nolock)
join Production.pais p (nolock)
on r.pais_id = p.id
join Production.sistema_operacional so (nolock)
on r.sistema_operacional_id = so.id
where p.nome = 'United States' and so.nome = 'Windows'

-- 3. Qual a média de salário dos usuários que moram em Israel e gostam de Linux?

Select p.nome as Pais, ROUND(AVG(r.salario), 2) as Salario from Production.respondente r (nolock)
join Production.pais p (nolock)
on r.pais_id = p.id
join Production.sistema_operacional so (nolock)
on r.sistema_operacional_id = so.id
where p.nome = 'Israel' and so.nome = 'Linux-based' and r.salario > 0
group by p.nome

-- 4. Qual a média e o desvio padrão do salário dos usuários que usam Slack para cada tamanho de empresa disponível? 
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

-- 5. Qual a diferença entre a média de salário dos respondentes do Brasil que acham que criar código é um hobby e a média de todos de salário de
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

-- 6. Quais são as top 3 tecnologias mais usadas pelos desenvolvedores?

Select top 3 lp.nome, COUNT(lp.id) as Quantidade from Production.respondente r (nolock)
join Production.resp_usa_linguagem rul (nolock)
on r.id = rul.respondente_id
join Production.linguagem_programacao lp (nolock)
on rul.linguagem_programacao_id = lp.id
group by lp.nome
order by Quantidade desc

-- 7. Quais são os top 5 países em questão de salário?

Select top 5 p.nome, round(avg(r.salario), 2) as salario from Production.respondente r (nolock)
join Production.pais p (nolock)
on r.pais_id = p.id
where r.salario > 0
group by p.nome
order by salario desc

-- 8. A tabela abaixo contém os salários mínimos mensais de cinco países presentes na amostra de dados. Baseado nesses valores, gostaríamos de saber 
-- quantos usuários ganham mais de 5 salários mínimos em cada um desses países.


create table #minimum_salary (

paid_id int,
minimum_salary_month float

)

Insert into #minimum_salary values (176, 4787.90), (213, 243.52), (192, 6925.63), (165, 6664.00), (229, 5567.68)

Select p.nome, COUNT(*) as quantidade from Production.respondente r (nolock)
join Production.pais p (nolock)
on r.pais_id = p.id
join #minimum_salary ms (nolock)
on p.id = ms.paid_id
where (r.salario * 5) > ms.minimum_salary_month
group by p.nome
order by quantidade desc