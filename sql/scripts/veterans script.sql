select party,
	round(avg(veterans_factor),2) as AVG,
	round(percentile_disc(0.25) within group (order by veterans_factor),2) as Q1,
	round(mode() within group (order by veterans_factor),2) as MEDIAN,
	round(percentile_disc(0.75) within group (order by veterans_factor),2) as Q3,
	round(stddev(veterans_factor),2) as STD
from (
	select 
	distinct atd.fips, atd.county, wpc.party ,wpc.candidate , round(atd.vet605213::numeric / atd.pst045214::numeric,2) as veterans_factor
	from all_together_dropped atd 
	full join winning_per_county wpc on atd.fips = wpc.fips
	where atd.fips is not null
	order by veterans_factor desc) xxxx
group by party 
	
	
	
