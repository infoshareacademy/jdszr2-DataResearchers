with
facts_and_winners as (
	select * from winning_per_county wpc
	join county_facts_csv cfc on wpc.fips = cfc.fips
),
democrats as (
	select
		county, party, candidate, votes,
		INC910213 as income
	from facts_and_winners
	where party like('Democrat')
	order by random() limit 939	
),
republicans as (
	select
		county, party, candidate, votes,
		INC910213 as income
	from facts_and_winners
	where party like('Republican')
	order by random() limit 939
),
income as (
	select * from democrats
	union (
		select * from republicans
	)
)

select
	income.party,
	avg(income),
	percentile_disc(0.25) within group (order by income) as Q1,
	percentile_disc(0.5) within group (order by income) as MEDIAN,
	percentile_disc(0.75) within group (order by income) as Q3,
	stddev(income) as STD
from income
group by income.party


-- party     |avg               |q1   |median|q3   |std              |
-------------|------------------|-----|------|-----|-----------------|
-- Democrat  |23291.840255591054|18750| 22381|26271|6854.316450396281|
-- Republican|23108.782515991471|20052| 22551|25378|4573.073489329557|
