with
veteran_group as (
 select county, party, veterans_factor,
   case
   when veterans_factor between  0 and 0.06 then 0
   when veterans_factor between 0.06 and 0.08 then 1
   when veterans_factor between 0.08 and 0.1 then 2
   else 3
   end as veteran_group
  from veterans_per_county
 order by veterans_factor desc
),
range_0 as (
 select veteran_group, count(party) as counter,
 count(case when party = 'Democrat' then 1 end) as democrats,
 count(case when party = 'Republican' then 1 end) as republicans
 from veteran_group
 where veteran_group = 0
 group by veteran_group
),
range_1 as (
 select veteran_group, count(party) as counter,
 count(case when party = 'Democrat' then 1 end) as democrats,
 count(case when party = 'Republican' then 1 end) as republicans
 from veteran_group
 where veteran_group = 1
 group by veteran_group
),
range_2 as (
 select veteran_group, count(party) as counter,
 count(case when party = 'Democrat' then 1 end) as democrats,
 count(case when party = 'Republican' then 1 end) as republicans
 from veteran_group
 where veteran_group = 2
 group by veteran_group
),
range_3 as (
 select veteran_group, count(party) as counter,
 count(case when party = 'Democrat' then 1 end) as democrats,
 count(case when party = 'Republican' then 1 end) as republicans
 from veteran_group
 where veteran_group = 3
 group by veteran_group
),
grouped_data as (
select veteran_group as lp,
 case when veteran_group = 0 then '<0.06' end as veterans_range,
 counter as counties, democrats, republicans
from range_0
union
select veteran_group as lp,
 case when veteran_group = 1 then 'from 0.06 to 0.08' end as veterans_range,
 counter as counties, democrats, republicans
from range_1
union
select veteran_group as lp,
 case when veteran_group = 2 then 'from 0.08 to 0.1' end as veterans_range,
 counter as counties, democrats, republicans
from range_2
union
select veteran_group as lp,
 case when veteran_group = 3 then 'from 0.1 to 1' end as veterans_range,
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
select gd.lp, gd.veterans_range, gd.counties, gd.democrats, gd.republicans,
 distribution.d_democrats, distribution.d_republicans,
 woe.woe, diff_dg_db."diff(d_democrats, d_republicans)",
 contributions.contributor, contributions.iv
from grouped_data as gd
full join distribution on gd.lp = distribution.lp
full join woe on gd.lp = woe.lp
full join diff_dg_db on gd.lp = diff_dg_db.lp
full join contributions on gd.lp = contributions.lp


--lp|veterans_range   |counties|democrats|republicans|d_democrats           |d_republicans         |woe                    |diff(d_democrats, d_republicans)|contributor                               |iv                                        |
----|-----------------|--------|---------|-----------|----------------------|----------------------|-----------------------|--------------------------------|------------------------------------------|------------------------------------------|
-- 0|<0.06            |     453|      306|        147|0.32587859424920127796|0.15654952076677316294|-0.73315251517364447087|         -0.16932907348242811502|0.1241440361156650382013858535754593994674|0.2261983101146304230002937696593194224666|
-- 1|from 0.06 to 0.08|     743|      369|        374|0.39297124600638977636|0.39829605963791267306| 0.01345915337400474707|          0.00532481363152289670|0.0000716674833546578651411042591972376690|0.2261983101146304230002937696593194224666|
-- 2|from 0.08 to 0.1 |     454|      196|        258|0.20873269435569755059|0.27476038338658146965| 0.27484492569110019523|          0.06602768903088391906|0.0181473752852483621975813764618335180838|0.2261983101146304230002937696593194224666|
-- 3|from 0.1 to 1    |     228|       68|        160|0.07241746538871139510|0.17039403620873269436| 0.85566611005772022264|          0.09797657082002129926|0.0838352312303623647361854353628292672464|0.2261983101146304230002937696593194224666|
