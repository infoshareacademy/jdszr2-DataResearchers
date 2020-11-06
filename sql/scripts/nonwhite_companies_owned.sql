select party,
	avg(nonwhite_ownership) as AVG,
	percentile_disc(0.25) within group (order by nonwhite_ownership) as Q1,
	mode() within group (order by nonwhite_ownership) as MEDIAN,
	percentile_disc(0.75) within group (order by nonwhite_ownership) as Q3,
	stddev(nonwhite_ownership) as STD
from (
	(select county, party, candidate, votes ,SBO315207+SBO115207+SBO215207+SBO515207+SBO415207 as nonwhite_ownership
		from (
			select *
			from winning_per_county wpc  
			join county_facts_csv cfc on wpc.fips = cfc.fips) xxx
			where party like('Democrat')
			limit 939)
	union (
	select county, party, candidate, votes ,SBO315207+SBO115207+SBO215207+SBO515207+SBO415207 as nonwhite_ownership
		from (
			select *
			from winning_per_county wpc  
			join county_facts_csv cfc on wpc.fips = cfc.fips) xxx
			where party like('Republican')
			limit 939)) xxxx
group by party 
