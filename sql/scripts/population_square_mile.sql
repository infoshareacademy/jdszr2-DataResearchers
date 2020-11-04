select party,
	avg(population_square_mile) as AVG,
	percentile_disc(0.25) within group (order by population_square_mile) as Q1,
	mode() within group (order by population_square_mile) as MEDIAN,
	percentile_disc(0.75) within group (order by population_square_mile) as Q3,
	stddev(population_square_mile) as STD
from (
	select 
	distinct atd.fips, atd.county, wpc.party ,wpc.candidate , atd.pop060210 as population_square_mile
	from all_together_dropped atd 
	full join winning_per_county wpc on atd.fips = wpc.fips
	where atd.fips is not null
	order by atd.pop060210 desc) xxxx
group by party 
	