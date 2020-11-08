with
facts_and_winners as (
	select * from winning_per_county wpc
	join county_facts_csv cfc on wpc.fips = cfc.fips
),
democrats as (
	select
		county, party, candidate, votes,
		SBO315207+SBO115207+SBO215207+SBO515207+SBO415207 as nonwhite_ownership
	from facts_and_winners
	where party like('Democrat')
),
republicans as (
	select
		county, party, candidate, votes,
		SBO315207+SBO115207+SBO215207+SBO515207+SBO415207 as nonwhite_ownership
	from facts_and_winners
	where party like('Republican')
),
nonwhite_together as (
	select * from democrats
	union (
		select * from republicans
	)
)

select
	nonwhite_together.party,
	avg(nonwhite_ownership),
	percentile_disc(0.25) within group (order by nonwhite_ownership) as Q1,
	mode() within group (order by nonwhite_ownership) as MEDIAN,
	percentile_disc(0.75) within group (order by nonwhite_ownership) as Q3,
	stddev(nonwhite_ownership) as STD
from nonwhite_together
group by nonwhite_together.party


-- party     |avg               |q1 |median|q3  |std               |
-------------|------------------|---|------|----|------------------|
-- Democrat  |11.312034078807242|0.0|   0.0|19.4|16.347566670609126|
-- Republican| 2.876812366737744|0.0|   0.0| 3.0| 5.968441509046421|

