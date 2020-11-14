with
races_group as (
 select county, party, black,
 case
 when black > 19 then 1
 when black between 15 and 19 then 2
 when black < 15 then 3
 end as races_group
 from races
 order by black desc
),
range_1 as (
 select races_group, count(party) as counter,
 count(case when party = 'Democrat' then 1 end) as democrats,
 count(case when party = 'Republican' then 1 end) as republicans
 from races_group
 where races_group = 1
 group by races_group
),
range_2 as (
 select races_group, count(party) as counter,
 count(case when party = 'Democrat' then 1 end) as democrats,
 count(case when party = 'Republican' then 1 end) as republicans
 from races_group
 where races_group = 2
 group by races_group
),
range_3 as (
 select races_group, count(party) as counter,
 count(case when party = 'Democrat' then 1 end) as democrats,
 count(case when party = 'Republican' then 1 end) as republicans
 from races_group
 where races_group = 3
 group by races_group
),
grouped_data as (
select races_group as lp,
 case when races_group = 1 then 'black > 19' end as races_range,
 counter as counties, democrats, republicans
from range_1
union
select races_group as lp,
 case when races_group = 2 then 'black between 15 and 19' end as races_range,
 counter as counties, democrats, republicans
from range_2
union
select races_group as lp,
 case when races_group = 3 then 'black < 15' end as races_range,
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

select gd.lp, gd.races_range, gd.counties, gd.democrats, gd.republicans,
 distribution.d_democrats, distribution.d_republicans,
 woe.woe, diff_dg_db."diff(d_democrats, d_republicans)",
 contributions.contributor, contributions.iv
from grouped_data as gd
full join distribution on gd.lp = distribution.lp
full join woe on gd.lp = woe.lp
full join diff_dg_db on gd.lp = diff_dg_db.lp
full join contributions on gd.lp = contributions.lp

-- lp|races_range            |counties|democrats|republicans|d_democrats           |d_republicans         |woe                    |diff(d_democrats, d_republicans)|contributor                               |iv                                        |
-- --|-----------------------|--------|---------|-----------|----------------------|----------------------|-----------------------|--------------------------------|------------------------------------------|------------------------------------------|
--  1|black > 19             |     424|      335|         89|0.35676251331203407881|0.09478168264110756124|-1.32549416209292659591|         -0.26198083067092651757|0.3472540616345686289579487490235309051387|0.4381042494020726377946599920564944900111|
--  2|black between 15 and 19|      65|       24|         41|0.02555910543130990415|0.04366347177848775293| 0.53551823635636218438|          0.01810436634717784878|0.0096952183365901566952364117195901180564|0.4381042494020726377946599920564944900111|
--  3|black < 15             |    1389|      580|        809|0.61767838125665601704|0.86155484558040468584| 0.33277081351802666882|          0.24387646432374866880|0.0811549694309138521414748313133734668160|0.4381042494020726377946599920564944900111|
