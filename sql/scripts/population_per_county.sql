with
facts_and_winners as (
	select * from winning_per_county wpc
	join county_facts_csv cfc on wpc.fips = cfc.fips
),
democrats as (
	select
		county, party, candidate, votes,
		PST045214 as population
	from facts_and_winners
	where party like('Democrat')
),
republicans as (
	select
		county, party, candidate, votes,
		PST045214 as population
	from facts_and_winners
	where party like('Republican')
),
population as (
	select * from democrats
	union (
		select * from republicans
	)
)

select
	population.party,
	avg(population),
	percentile_disc(0.25) within group (order by population) as Q1,
	percentile_disc(0.5) within group (order by population) as MEDIAN,
	percentile_disc(0.75) within group (order by population) as Q3,
	stddev(population) as STD
from population
group by population.party


-- party     |avg                |q1   |median|q3    |std            |
-------------|-------------------|-----|------|------|---------------|
-- Democrat  |167117.106496272630|12928| 28163|103675|489944.21893277|
-- Republican|70273.401385927505 |11558| 25957|62893 |186852.56371448|



