select party,
	avg(poverty_level) as AVG,
	percentile_disc(0.25) within group (order by poverty_level) as Q1,
	mode() within group (order by poverty_level) as MEDIAN,
	percentile_disc(0.75) within group (order by poverty_level) as Q3,
	stddev(poverty_level) as STD
from (
	(select county, party, candidate, votes , pvy020213 as poverty_level
			from (
				select *
				from winning_per_county wpc  
				join county_facts_csv cfc on wpc.fips = cfc.fips) xxx
				where party like('Democrat')
				limit 939)
		union (
		select county, party, candidate, votes ,pvy020213 as poverty_level
			from (
				select *
				from winning_per_county wpc  
				join county_facts_csv cfc on wpc.fips = cfc.fips) xxx
				where party like('Republican')
				limit 939)) xxxx
group by party 