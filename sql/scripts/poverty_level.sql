select party,
	avg(poverty_level) as AVG,
	percentile_disc(0.25) within group (order by poverty_level) as Q1,
	mode() within group (order by poverty_level) as MEDIAN,
	percentile_disc(0.75) within group (order by poverty_level) as Q3,
	stddev(poverty_level) as STD
from (
	select 
	distinct atd.fips, atd.county, wpc.party ,wpc.candidate , atd.pvy020213 as poverty_level
	from all_together_dropped atd 
	full join winning_per_county wpc on atd.fips = wpc.fips
	where atd.fips is not null
	order by atd.pvy020213 desc) xxxx
group by party 
