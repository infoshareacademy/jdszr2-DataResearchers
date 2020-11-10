select party,
	avg(home_ownership) as AVG,
	percentile_disc(0.25) within group (order by home_ownership) as Q1,
	mode() within group (order by home_ownership) as MEDIAN,
	percentile_disc(0.75) within group (order by home_ownership) as Q3,
	stddev(home_ownership) as STD
from (
	(select county, party, candidate, votes , hsg445213 as home_ownership
			from (
				select *
				from winning_per_county wpc  
				join county_facts_csv cfc on wpc.fips = cfc.fips) xxx
				where party like('Democrat')
				limit 939)
		union (
		select county, party, candidate, votes ,hsg445213 as home_ownership
			from (
				select *
				from winning_per_county wpc  
				join county_facts_csv cfc on wpc.fips = cfc.fips) xxx
				where party like('Republican')
				limit 939)) xxxx
group by party 
