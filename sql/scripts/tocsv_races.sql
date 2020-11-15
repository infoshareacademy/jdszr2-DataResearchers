copy (

with
facts_and_winners as (
	select * from winning_per_county wpc
	join county_facts_csv cfc on wpc.fips = cfc.fips
),
democrats as (
  select
		county, party, candidate, votes,
		RHI825214 as white,
  	RHI225214 as black,
  	RHI325214+RHI525214 as indians,
  	RHI725214 as latin,
  	RHI425214 as asians
  from facts_and_winners
	where party like('Democrat')
	order by random() limit 939
),
republicans as (
	select
		county, party, candidate, votes,
		RHI825214 as white,
		RHI225214 as black,
		RHI325214+RHI525214 as indians,
		RHI725214 as latin,
		RHI425214 as asians
  from facts_and_winners
  where party like('Republican')
  order by random() limit 939
),
race as (
	select * from democrats
	union (
		select * from republicans
  )
)

select
	county, party, white, black, latin, indians, asians,
	latin+indians+asians as "others"
from race
) to '/tmp/races.csv'
delimiter ';' csv header;
