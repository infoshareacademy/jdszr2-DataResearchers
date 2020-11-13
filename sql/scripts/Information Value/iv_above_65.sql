with
above_65_group as (
 select county, party, above_65,
   case
   when above_65 between  0 and 14 then 0
   when above_65 between 14 and 18 then 1
   when above_65 between 18 and 20.4 then 2
   else 3
   end as above_65_group
  from above_65
 order by above_65 desc
),
range_0 as (
 select above_65_group, count(party) as counter,
 count(case when party = 'Democrat' then 1 end) as democrats,
 count(case when party = 'Republican' then 1 end) as republicans
 from above_65_group
 where above_65_group = 0
 group by above_65_group
),
range_1 as (
 select above_65_group, count(party) as counter,
 count(case when party = 'Democrat' then 1 end) as democrats,
 count(case when party = 'Republican' then 1 end) as republicans
 from above_65_group
 where above_65_group = 1
 group by above_65_group
),
range_2 as (
 select above_65_group, count(party) as counter,
 count(case when party = 'Democrat' then 1 end) as democrats,
 count(case when party = 'Republican' then 1 end) as republicans
 from above_65_group
 where above_65_group = 2
 group by above_65_group
),
range_3 as (
 select above_65_group, count(party) as counter,
 count(case when party = 'Democrat' then 1 end) as democrats,
 count(case when party = 'Republican' then 1 end) as republicans
 from above_65_group
 where above_65_group = 3
 group by above_65_group
),
grouped_data as (
select above_65_group as lp,
 case when above_65_group = 0 then '<69' end as above_65_range,
 counter as counties, democrats, republicans
from range_0
union
select above_65_group as lp,
 case when above_65_group = 1 then 'from 69 to 75' end as above_65_range,
 counter as counties, democrats, republicans
from range_1
union
select above_65_group as lp,
 case when above_65_group = 2 then 'from 75 to 79' end as above_65_range,
 counter as counties, democrats, republicans
from range_2
union
select above_65_group as lp,
 case when above_65_group = 3 then 'from 79 to 100' end as above_65_range,
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
select gd.lp, gd.above_65_range, gd.counties, gd.democrats, gd.republicans,
 distribution.d_democrats, distribution.d_republicans,
 woe.woe, diff_dg_db."diff(d_democrats, d_republicans)",
 contributions.contributor, contributions.iv
from grouped_data as gd
full join distribution on gd.lp = distribution.lp
full join woe on gd.lp = woe.lp
full join diff_dg_db on gd.lp = diff_dg_db.lp
full join contributions on gd.lp = contributions.lp


--lp|above_65_range|counties|democrats|republicans|d_democrats           |d_republicans         |woe                    |diff(d_democrats, d_republicans)|contributor                               |iv                                        |
----|--------------|--------|---------|-----------|----------------------|----------------------|-----------------------|--------------------------------|------------------------------------------|------------------------------------------|
-- 0|<69           |     406|      269|        137|0.28647497337593184239|0.14589989350372736954|-0.67473045377371419094|         -0.14057507987220447285|0.0948502874314486402643552633553869459790|0.1638754041322101035682430807740914244054|
-- 1|from 69 to 75 |     768|      380|        388|0.40468583599574014909|0.41320553780617678381| 0.02083408690284198752|          0.00851970181043663472|0.0001775002079049370609194194896250386944|0.1638754041322101035682430807740914244054|
-- 2|from 75 to 79 |     341|      161|        180|0.17145899893503727370|0.19169329073482428115| 0.11155248590574738028|          0.02023429179978700745|0.0022571855508085199412391815098183430860|0.1638754041322101035682430807740914244054|
-- 3|from 79 to 100|     363|      129|        234|0.13738019169329073482|0.24920127795527156550| 0.59550871099602931345|          0.11182108626198083068|0.0665904309420480063017292164192610966460|0.1638754041322101035682430807740914244054|
