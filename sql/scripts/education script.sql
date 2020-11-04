select party, array [
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
	select distinct atd.fips, atd.county, wpc.party ,wpc.candidate ,100 - atd.edu635213 as primary_education ,atd.edu635213-atd.edu685213 as secondary_education, atd.edu685213 as higher_education
	from all_together_dropped atd 
	full join winning_per_county wpc on atd.fips = wpc.fips ) epc
group by party 
