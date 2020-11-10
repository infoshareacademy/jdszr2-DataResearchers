select party,
	avg(persons_per_household) as AVG,
	percentile_disc(0.25) within group (order by persons_per_household) as Q1,
	mode() within group (order by persons_per_household) as MEDIAN,
	percentile_disc(0.75) within group (order by persons_per_household) as Q3,
	stddev(persons_per_household) as STD
from (
	(select county, party, candidate, votes , HSD310213 as persons_per_household
			from (
				select *
				from winning_per_county wpc  
				join county_facts_csv cfc on wpc.fips = cfc.fips) xxx
				where party like('Democrat')
				limit 939)
		union (
		select county, party, candidate, votes ,HSD310213 as persons_per_household
			from (
				select *
				from winning_per_county wpc  
				join county_facts_csv cfc on wpc.fips = cfc.fips) xxx
				where party like('Republican')
				limit 939)) xxxx
group by party 
