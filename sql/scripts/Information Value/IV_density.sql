with
density_group as (
 select county, party, density,
   case
   when density between  0 and 99 then 0
   when density between 100 and 299 then 1
   when density between 300 and 799 then 2
   when density between 800 and 1399 then 3
   else 4
   end as density_group
  from (SELECT wpc.county, wpc.party, cfc.POP060210 AS "density"
  		FROM winning_per_county wpc
  		INNER JOIN county_facts_csv cfc ON cfc.fips = wpc.fips
  		) AS dens
order by density desc
),
range_0 as (
 select density_group, count(party) as counter,
 count(case when party = 'Democrat' then 1 end) as democrats,
 count(case when party = 'Republican' then 1 end) as republicans
 from density_group
 where density_group = 0
 group by density_group
),
range_1 as (
 select density_group, count(party) as counter,
 count(case when party = 'Democrat' then 1 end) as democrats,
 count(case when party = 'Republican' then 1 end) as republicans
 from density_group
 where density_group = 1
 group by density_group
),
range_2 as (
 select density_group, count(party) as counter,
 count(case when party = 'Democrat' then 1 end) as democrats,
 count(case when party = 'Republican' then 1 end) as republicans
 from density_group
 where density_group = 2
 group by density_group
),
range_3 as (
 select density_group, count(party) as counter,
 count(case when party = 'Democrat' then 1 end) as democrats,
 count(case when party = 'Republican' then 1 end) as republicans
 from density_group
 where density_group = 3
 group by density_group
),
range_4 as (
 select density_group, count(party) as counter,
 count(case when party = 'Democrat' then 1 end) as democrats,
 count(case when party = 'Republican' then 1 end) as republicans
 from density_group
 where density_group = 4
 group by density_group
),
grouped_data as (
select density_group as lp,
 case when density_group = 0 then '< 99' end as income_range,
 counter as counties, democrats, republicans
from range_0
union
select density_group as lp,
 case when density_group = 1 then 'from 100 to 299' end as income_range,
 counter as counties, democrats, republicans
from range_1
union
select density_group as lp,
 case when density_group = 2 then 'from 300 to 799' end as income_range,
 counter as counties, democrats, republicans
from range_2
union
select density_group as lp,
 case when density_group = 3 then 'from 800 to 1399' end as income_range,
 counter as counties, democrats, republicans
from range_3
union
select density_group as lp,
 case when density_group = 4 then '>= 1400' end as income_range,
 counter as counties, democrats, republicans
from range_4
order by lp
),
distribution as (
 select lp,
 democrats/ sum(democrats)over()::numeric d_democrats,
 republicans/ sum(republicans)over()::numeric d_republicans
 from  grouped_data
),
woe as (select lp, ln(d_republicans/d_democrats) as woe from distribution ),
diff_dg_db as (select lp, d_republicans-d_democrats as "diff(d_democrats, d_republicans)" from distribution),
contributions as (
 select
   lp,
   (d_republicans-d_democrats) *ln(d_republicans/d_democrats) as contributor,
   sum( (d_republicans-d_democrats) *ln(d_republicans/d_democrats) )over()::numeric as iv
 from distribution
)
select gd.lp, gd.income_range, gd.counties, gd.democrats, gd.republicans,
 distribution.d_democrats, distribution.d_republicans,
 woe.woe, diff_dg_db."diff(d_democrats, d_republicans)",
 contributions.contributor, contributions.iv
from grouped_data as gd
full join distribution on gd.lp = distribution.lp
full join woe on gd.lp = woe.lp
full join diff_dg_db on gd.lp = diff_dg_db.lp
full join contributions on gd.lp = contributions.lp
