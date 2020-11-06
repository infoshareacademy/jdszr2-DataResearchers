select party,
	round(avg(veterans_factor),2) as AVG,
	round(percentile_disc(0.25) within group (order by veterans_factor),2) as Q1,
	round(mode() within group (order by veterans_factor),2) as MEDIAN,
	round(percentile_disc(0.75) within group (order by veterans_factor),2) as Q3,
	round(stddev(veterans_factor),2) as STD
from (
	(select county, party, candidate, votes , round(vet605213::numeric / pst045214::numeric,2) as veterans_factor
			from (
				select *
				from winning_per_county wpc  
				join county_facts_csv cfc on wpc.fips = cfc.fips) xxx
				where party like('Democrat')
				limit 939)
		union (
		select county, party, candidate, votes ,round(vet605213::numeric / pst045214::numeric,2) as veterans_factor
			from (
				select *
				from winning_per_county wpc  
				join county_facts_csv cfc on wpc.fips = cfc.fips) xxx
				where party like('Republican')
				limit 939)) xxxx
group by party 
<<<<<<< HEAD
	
	
	
=======
>>>>>>> grzegorz
