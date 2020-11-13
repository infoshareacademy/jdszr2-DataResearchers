with
poverty_group as (
 select county, party, poverty_level,
   case
   when poverty_level between  0 and 13.2 then 0
   when poverty_level between 13.2 and 19 then 1
   when poverty_level between 19 and 24 then 2
   else 3
   end as poverty_group
  from poverty_level
 order by poverty_level desc
),
range_0 as (
 select poverty_group, count(party) as counter,
 count(case when party = 'Democrat' then 1 end) as democrats,
 count(case when party = 'Republican' then 1 end) as republicans
 from poverty_group
 where poverty_group = 0
 group by poverty_group
),
range_1 as (
 select poverty_group, count(party) as counter,
 count(case when party = 'Democrat' then 1 end) as democrats,
 count(case when party = 'Republican' then 1 end) as republicans
 from poverty_group
 where poverty_group = 1
 group by poverty_group
),
range_2 as (
 select poverty_group, count(party) as counter,
 count(case when party = 'Democrat' then 1 end) as democrats,
 count(case when party = 'Republican' then 1 end) as republicans
 from poverty_group
 where poverty_group = 2
 group by poverty_group
),
range_3 as (
 select poverty_group, count(party) as counter,
 count(case when party = 'Democrat' then 1 end) as democrats,
 count(case when party = 'Republican' then 1 end) as republicans
 from poverty_group
 where poverty_group = 3
 group by poverty_group
),
grouped_data as (
select poverty_group as lp,
 case when poverty_group = 0 then '<13.2' end as poverty_range,
 counter as counties, democrats, republicans
from range_0
union
select poverty_group as lp,
 case when poverty_group = 1 then 'from 13.2 to 19' end as poverty_range,
 counter as counties, democrats, republicans
from range_1
union
select poverty_group as lp,
 case when poverty_group = 2 then 'from 19 to 24' end as poverty_range,
 counter as counties, democrats, republicans
from range_2
union
select poverty_group as lp,
 case when poverty_group = 3 then 'from 24 to 100' end as poverty_range,
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
select gd.lp, gd.poverty_range, gd.counties, gd.democrats, gd.republicans,
 distribution.d_democrats, distribution.d_republicans,
 woe.woe, diff_dg_db."diff(d_democrats, d_republicans)",
 contributions.contributor, contributions.iv
from grouped_data as gd
full join distribution on gd.lp = distribution.lp
full join woe on gd.lp = woe.lp
full join diff_dg_db on gd.lp = diff_dg_db.lp
full join contributions on gd.lp = contributions.lp


--lp|poverty_range  |counties|democrats|republicans|d_democrats           |d_republicans         |woe                    |diff(d_democrats, d_republicans)|contributor                               |iv                                        |
----|---------------|--------|---------|-----------|----------------------|----------------------|-----------------------|--------------------------------|------------------------------------------|------------------------------------------|
 --0|<13.2          |     487|      229|        258|0.24387646432374866880|0.27476038338658146965| 0.11923758136737777584|          0.03088391906283280085|0.0036825238121980356753348354360706614640|0.1426339593408905897399973379401139942716|
 --1|from 13.2 to 19|     649|      274|        375|0.29179978700745473908|0.39936102236421725240| 0.31379791958234059049|          0.10756123535676251332|0.0337524918826585725685167289014652903268|0.1426339593408905897399973379401139942716|
 --2|from 19 to 24  |     399|      201|        198|0.21405750798722044728|0.21086261980830670927|-0.01503787736454051476|         -0.00319488817891373801|0.0000480443366279249671464578018011780276|0.1426339593408905897399973379401139942716|
 --3|from 24 to 100 |     343|      235|        108|0.25026624068157614483|0.11501597444089456869|-0.77745428701993926838|         -0.13525026624068157614|0.1051508993094060565289993158007768644532|0.1426339593408905897399973379401139942716|

