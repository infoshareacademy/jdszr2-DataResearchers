select party,
	avg(above_65) as AVG,
	percentile_disc(0.25) within group (order by above_65) as Q1,
	mode() within group (order by above_65) as MEDIAN,
	percentile_disc(0.75) within group (order by above_65) as Q3,
	stddev(above_65) as STD
from (
	(select county, party, candidate, votes ,AGE775214 as above_65
		from (
			select *
			from winning_per_county wpc  
			join county_facts_csv cfc on wpc.fips = cfc.fips) xxx
			where party like('Democrat')
			limit 939)
	union (
	select county, party, candidate, votes ,AGE775214 as above_65
		from (
			select *
			from winning_per_county wpc  
			join county_facts_csv cfc on wpc.fips = cfc.fips) xxx
			where party like('Republican')
			limit 939)) xxxx
group by party 
