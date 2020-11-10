select party,
	avg(households) as AVG,
	percentile_disc(0.25) within group (order by households) as Q1,
	percentile_disc(0.5) within group (order by households) as MEDIAN,
	percentile_disc(0.75) within group (order by households) as Q3,
	stddev(households) as STD
from (
	(select county, party, candidate, votes , HSD410213 as households
			from (
				select *
				from winning_per_county wpc  
				join county_facts_csv cfc on wpc.fips = cfc.fips) xxx
				where party like('Democrat')
				limit 939)
		union (
		select county, party, candidate, votes ,HSD410213 as households
			from (
				select *
				from winning_per_county wpc  
				join county_facts_csv cfc on wpc.fips = cfc.fips) xxx
				where party like('Republican')
				limit 939)) xxxx
group by party 