select party,
	avg(more_language) as AVG,
	percentile_disc(0.25) within group (order by more_language) as Q1,
	mode() within group (order by more_language) as MEDIAN,
	percentile_disc(0.75) within group (order by more_language) as Q3,
	stddev(more_language) as STD
from (
	(select county, party, candidate, votes , POP815213 as more_language
			from (
				select *
				from winning_per_county wpc  
				join county_facts_csv cfc on wpc.fips = cfc.fips) xxx
				where party like('Democrat')
				limit 939)
		union (
		select county, party, candidate, votes ,POP815213 as more_language
			from (
				select *
				from winning_per_county wpc  
				join county_facts_csv cfc on wpc.fips = cfc.fips) xxx
				where party like('Republican')
				limit 939)) xxxx
group by party 