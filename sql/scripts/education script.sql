select party, 
array [
	round(avg(primary_education)),
	round(avg(secondary_education)), 
	round(avg(higher_education))] as AVG, 
array [
	round(percentile_disc(0.25) within group (order by primary_education)),
	round(percentile_disc(0.25) within group (order by secondary_education)),
	round(percentile_disc(0.25) within group (order by higher_education))] as Q1,
array [
	round(mode() within group (order by primary_education)),
	round(mode() within group (order by secondary_education)), 
	round(mode() within group (order by higher_education))] as MEDIAN,
array [
	round(percentile_disc(0.75) within group (order by primary_education)),
	round(percentile_disc(0.75) within group (order by secondary_education)),
	round(percentile_disc(0.75) within group (order by higher_education))] as Q3,
array [
	round(stddev(primary_education)),
	round(stddev(secondary_education)),
	round(stddev(higher_education))] as STD
from (
	(select county, party, candidate, votes ,100 - edu635213 as primary_education ,edu635213-edu685213 as secondary_education, edu685213 as higher_education
		from (
			select *
			from winning_per_county wpc  
			join county_facts_csv cfc on wpc.fips = cfc.fips) xxx
			where party like('Democrat')
			limit 939)
	union (
	select county, party, candidate, votes ,100 - edu635213 as primary_education ,edu635213-edu685213 as secondary_education, edu685213 as higher_education
		from (
			select *
			from winning_per_county wpc  
			join county_facts_csv cfc on wpc.fips = cfc.fips) xxx
			where party like('Republican')
			limit 939)) epc
group by party 
