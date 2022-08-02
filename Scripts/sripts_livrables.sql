-- script_1
--OK

select 		COUNT(bien.type_local) as "Nombre d'appartements S1 2020"

from 		bien

join 		vente on vente.vente_id = bien.vente_id 

where 		bien.type_local 	= 'Appartement'
and 		date_mutation 		between '2020-01-01' and '2020-06-30'
;

-- scrip_2
--OK

select 
			bien.nombre_pieces_principales 			as 	"Nombre de piecesnb_pieces", 
			count(bien.nombre_pieces_principales) 	as 	"Nombre d'appartements",
			
			round(count(bien.nombre_pieces_principales) *100) / 
					(select count(bien.nombre_pieces_principales)			
					from bien 
					where bien.type_local = 'Appartement') as "Proportion des ventes"
				
from 		bien

where 		bien.type_local = 'Appartement'
group by 	"Nombre de piecesnb_pieces" 
order by 	"Nombre de piecesnb_pieces"
;

-- script_3
--OK

select 		adresse.code_departement as "Departement",
			round(avg (vente.valeur_fonciere / bien.lot_1_surface_carrez),2) 	as "Prix moyen du m2"
		
from		vente 

join 		bien 		on vente.vente_id 			= 	bien.vente_id
join 		adresse 	on adresse.adresse_id		=	bien.adresse_id

group by 	"Departement"
order by 	"Prix moyen du m2" desc
limit 		10
;

-- script_4
-- OK

select 			
				(round(avg(vente.valeur_fonciere/bien.lot_1_surface_carrez),2)) as "Prix moyen du m2 en Ile de France"
				
from 			adresse	

join			bien 							on 		bien.vente_id 		=	adresse.adresse_id 
join 			vente  							on		vente.vente_id 		=	bien.adresse_id 

where 			adresse.code_departement		in 		('75','77','78','91','92','93','94','95')
and 			bien.type_local 				= 		'Maison'

;

-- script_5
--OK

select 		bien.bien_id 				as 	"ID appartements",
			adresse.code_departement 	as 	"Departement",
			vente.valeur_fonciere		as	"Valeur fonciere",
			bien.lot_1_surface_carrez 	as	"Surface Carrez"
		
from		bien

join 		vente 		on 		bien.vente_id 		= 	vente.vente_id
join 		adresse 	on 		bien.adresse_id 	=	adresse.adresse_id

where		bien.type_local = 'Appartement'
and			vente.valeur_fonciere is not null

group by 	"ID appartements", "Departement", "Valeur fonciere", "Surface Carrez"
order by	"Valeur fonciere" desc
limit 		10
;

--script 6
--OK

with

table1	as		(

select 			round(count(vente.vente_id),2)	as	nb_ventes_trimestre_1
from 			vente
where			vente.date_mutation 	between		'2020-01-01' and '2020-03-31'),

			
table2	as		(

select 			round(count(vente.vente_id),2)	as	nb_ventes_trimestre_2
from 			vente
where			vente.date_mutation 	between		'2020-04-01' and '2020-06-30')

select 			round(((table2.nb_ventes_trimestre_2 - table1.nb_ventes_trimestre_1)/table1.nb_ventes_trimestre_1*100),2) as "Taux d'evolution"
from			table1, table2
;


--script 7
--OK

with

table1 		as (

select 		adresse.nom_commune,	
			round(count(vente.vente_id),2) 	as nb_ventes_1				
from		adresse

join 		bien 		on 	bien.adresse_id 	=	adresse.adresse_id
join 		vente 		on 	bien.vente_id 		= 	vente.vente_id


where		vente.date_mutation between '2020-01-01' and '2020-03-31'
group by 	adresse.nom_commune),


table2 		as (

select 		adresse.nom_commune,	
			round(count(vente.vente_id),2) 	as nb_ventes_2				
from		adresse

join 		bien 		on 	bien.adresse_id 	=	adresse.adresse_id
join 		vente 		on 	bien.vente_id 		= 	vente.vente_id


where		vente.date_mutation between '2020-04-01' and '2020-06-30'
group by 	adresse.nom_commune)


---------------------------------------------------------------------------------------------------

select 		table1.nom_commune	as "Communes",	
			table1.nb_ventes_1	as "Nombre de ventes trimestre 1",
			table2.nb_ventes_2	as "Nombre de ventes trimestre 2",
			ROUND((table2.nb_ventes_2 - table1.nb_ventes_1)/table1.nb_ventes_1*100,2)  as "Evolution"				

			from 		table1
join		table2		on 		table1.nom_commune = table2.nom_commune

where 		round(((table2.nb_ventes_2 - table1.nb_ventes_1)/table1.nb_ventes_1)*100) >= 20
order by 	"Evolution"
;


--script 8
--OK

with

table1	as		(

select 			round(avg(vente.valeur_fonciere/bien.lot_1_surface_carrez),2) as valfonc_moy_2
				
from 			adresse	

join			bien 			on 		bien.vente_id 		=	adresse.adresse_id 
join 			vente  			on		vente.vente_id 		=	bien.adresse_id 

where 			bien.nombre_pieces_principales 	= 		2
and				bien.type_local 				=		'Appartement'),


table2	as		(

select 			round(avg(vente.valeur_fonciere/bien.lot_1_surface_carrez),2) as valfonc_moy_3
				
from 			adresse	

join			bien 			on 		bien.vente_id 		=	adresse.adresse_id 
join 			vente  			on		vente.vente_id 		=	bien.adresse_id 

where 			bien.nombre_pieces_principales 	= 		3
and				bien.type_local 				=		'Appartement')


select 			round(((table2.valfonc_moy_3 - table1.valfonc_moy_2)/table1.valfonc_moy_2)*100,2) as "Taux d'evolution"
from			table1, table2
;

--script 9


with table1 as (

select 		adresse.code_departement 				as "Departement",
			adresse.nom_commune 					as "Commune",
			round(avg(vente.valeur_fonciere),2)   	as "Valeur fonciere",
			rank () over(partition by adresse.code_departement order by round(avg(vente.valeur_fonciere),2)desc) as "Classement"
			
from		adresse

join		bien	on	bien.adresse_id	= 	adresse.adresse_id
join		vente 	on	vente.vente_id	=	bien.vente_id


where 		adresse.code_departement in ('6','13','33','59','69')
and 		vente.valeur_fonciere is not null


group by 	"Departement", "Commune"
order by 	"Valeur fonciere" desc)

select 		* 
from 		table1
where 		"Classement" <= 3
order by 	"Departement","Valeur fonciere" desc

;

