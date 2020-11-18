with
races_group as (
 select county, party, white,
 case
 when white > 80 then 0
 when white between 70 and 80 then 1
 when white < 70 then 2
 end as races_group
 from races
),
range_0 as (
 select races_group, count(party) as counter,
 count(case when party = 'Democrat' then 1 end) as democrats,
 count(case when party = 'Republican' then 1 end) as republicans
 from races_group
 where races_group = 0
 group by races_group
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
grouped_data as (
select races_group as lp,
 case when races_group = 0 then 'white > 75%' end as races_range,
 counter as counties, democrats, republicans
from range_0
union
select races_group as lp,
 case when races_group = 1 then 'white between 65 and 75%' end as races_range,
 counter as counties, democrats, republicans
from range_1
union
select races_group as lp,
 case when races_group = 2 then 'white < 64' end as races_range,
 counter as counties, democrats, republicans
from range_2


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

-- lp|races_range             |counties|democrats|republicans|d_democrats           |d_republicans         |woe                    |diff(d_democrats, d_republicans)|contributor                               |iv                                        |
--|------------------------|--------|---------|-----------|----------------------|----------------------|-----------------------|--------------------------------|------------------------------------------|------------------------------------------|
-- 0|white > 75%             |     929|      338|        591|0.35995740149094781683|0.62939297124600638978| 0.55877012192307941665|          0.26943556975505857295|0.1505525461624484477236186778552674696175|0.4733387981794491937611217884974756708205|
-- 1|white between 65 and 75%|     254|      102|        152|0.10862619808306709265|0.16187433439829605964| 0.39890770756200530723|          0.05324813631522896699|0.0212410919894571516112247676510104783377|0.4733387981794491937611217884974756708205|
-- 2|white < 64              |     695|      499|        196|0.53141640042598509052|0.20873269435569755059|-0.93449143652100143621|         -0.32268370607028753993|0.3015451600275435944262783429911977228653|0.4733387981794491937611217884974756708205|
