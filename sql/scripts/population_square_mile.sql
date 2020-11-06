select party,
	avg(population_square_mile) as AVG,
	percentile_disc(0.25) within group (order by population_square_mile) as Q1,
	percentile_disc(0.5) within group (order by population_square_mile) as MEDIAN,
	percentile_disc(0.75) within group (order by population_square_mile) as Q3,
	stddev(population_square_mile) as STD
from (
	(select county, party, candidate, votes , pop060210 as population_square_mile
			from (
				select *
				from winning_per_county wpc  
				join county_facts_csv cfc on wpc.fips = cfc.fips) xxx
				where party like('Democrat')
				limit 939)
		union (
		select county, party, candidate, votes ,pop060210 as population_square_mile
			from (
				select *
				from winning_per_county wpc  
				join county_facts_csv cfc on wpc.fips = cfc.fips) xxx
				where party like('Republican')
				limit 939)) xxxx
group by party 
