with
home_ownership_group as (
 select county, party, home_ownership,
   case
   when home_ownership between  0 and 69 then 0
   when home_ownership between 69 and 75 then 1
   when home_ownership between 75 and 79 then 2
   else 3
   end as home_ownership_group
  from home_ownership
 order by home_ownership desc
),
range_0 as (
 select home_ownership_group, count(party) as counter,
 count(case when party = 'Democrat' then 1 end) as democrats,
 count(case when party = 'Republican' then 1 end) as republicans
 from home_ownership_group
 where home_ownership_group = 0
 group by home_ownership_group
),
range_1 as (
 select home_ownership_group, count(party) as counter,
 count(case when party = 'Democrat' then 1 end) as democrats,
 count(case when party = 'Republican' then 1 end) as republicans
 from home_ownership_group
 where home_ownership_group = 1
 group by home_ownership_group
),
range_2 as (
 select home_ownership_group, count(party) as counter,
 count(case when party = 'Democrat' then 1 end) as democrats,
 count(case when party = 'Republican' then 1 end) as republicans
 from home_ownership_group
 where home_ownership_group = 2
 group by home_ownership_group
),
range_3 as (
 select home_ownership_group, count(party) as counter,
 count(case when party = 'Democrat' then 1 end) as democrats,
 count(case when party = 'Republican' then 1 end) as republicans
 from home_ownership_group
 where home_ownership_group = 3
 group by home_ownership_group
),
grouped_data as (
select home_ownership_group as lp,
 case when home_ownership_group = 0 then '<69' end as home_ownership_range,
 counter as counties, democrats, republicans
from range_0
union
select home_ownership_group as lp,
 case when home_ownership_group = 1 then 'from 69 to 75' end as home_ownership_range,
 counter as counties, democrats, republicans
from range_1
union
select home_ownership_group as lp,
 case when home_ownership_group = 2 then 'from 75 to 79' end as home_ownership_range,
 counter as counties, democrats, republicans
from range_2
union
select home_ownership_group as lp,
 case when home_ownership_group = 3 then 'from 79 to 100' end as home_ownership_range,
 counter as counties, democrats, republicans
from range_3
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
select gd.lp, gd.home_ownership_range, gd.counties, gd.democrats, gd.republicans,
 distribution.d_democrats, distribution.d_republicans,
 woe.woe, diff_dg_db."diff(d_democrats, d_republicans)",
 contributions.contributor, contributions.iv
from grouped_data as gd
full join distribution on gd.lp = distribution.lp
full join woe on gd.lp = woe.lp
full join diff_dg_db on gd.lp = diff_dg_db.lp
full join contributions on gd.lp = contributions.lp


--lp|home_ownership_range|counties|democrats|republicans|d_democrats           |d_republicans         |woe                    |diff(d_democrats, d_republicans)|contributor                               |iv                                        |
----|--------------------|--------|---------|-----------|----------------------|----------------------|-----------------------|--------------------------------|------------------------------------------|------------------------------------------|
-- 0|<69                 |     589|      395|        194|0.42066027689030883919|0.20660276890308839191|-0.71102760583779373723|         -0.21405750798722044728|0.1522007974157577648352811580065833882344|0.2561930529001240825489071771118420290382|
-- 1|from 69 to 75       |     578|      280|        298|0.29818956336528221512|0.31735889243876464324| 0.06230388333615484247|          0.01916932907348242812|0.0011943236422266103990964666389916982564|0.2561930529001240825489071771118420290382|
-- 2|from 75 to 79       |     429|      161|        268|0.17145899893503727370|0.28541001064962726305| 0.50958261552639368258|          0.11395101171458998935|0.0580674545913994931159548946587494805230|0.2561930529001240825489071771118420290382|
-- 3|from 79 to 100      |     282|      103|        179|0.10969116080937167199|0.19062832800851970181| 0.55265681761111922542|          0.08093716719914802982|0.0447304772507402141985746578075174620244|0.2561930529001240825489071771118420290382|
