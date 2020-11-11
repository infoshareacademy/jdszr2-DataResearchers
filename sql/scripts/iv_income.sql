with
income_group as (
 select county, party, income,
   case
   when income between  0 and 16999 then 0
   when income between 17000 and 19999 then 1
   when income between 20000 and 24999 then 2
   when income between 25000 and 29999 then 3
   else 4
   end as income_group
  from income_per_capita
 order by income desc
),
range_0 as (
 select income_group, count(party) as counter,
 count(case when party = 'Democrat' then 1 end) as democrats,
 count(case when party = 'Republican' then 1 end) as republicans
 from income_group
 where income_group = 0
 group by income_group
),
range_1 as (
 select income_group, count(party) as counter,
 count(case when party = 'Democrat' then 1 end) as democrats,
 count(case when party = 'Republican' then 1 end) as republicans
 from income_group
 where income_group = 1
 group by income_group
),
range_2 as (
 select income_group, count(party) as counter,
 count(case when party = 'Democrat' then 1 end) as democrats,
 count(case when party = 'Republican' then 1 end) as republicans
 from income_group
 where income_group = 2
 group by income_group
),
range_3 as (
 select income_group, count(party) as counter,
 count(case when party = 'Democrat' then 1 end) as democrats,
 count(case when party = 'Republican' then 1 end) as republicans
 from income_group
 where income_group = 3
 group by income_group
),
range_4 as (
 select income_group, count(party) as counter,
 count(case when party = 'Democrat' then 1 end) as democrats,
 count(case when party = 'Republican' then 1 end) as republicans
 from income_group
 where income_group = 4
 group by income_group
),
grouped_data as (
select income_group as lp,
 case when income_group = 0 then '<17000' end as income_range,
 counter as counties, democrats, republicans
from range_0
union
select income_group as lp,
 case when income_group = 1 then 'from 17000 to 19999' end as income_range,
 counter as counties, democrats, republicans
from range_1
union
select income_group as lp,
 case when income_group = 2 then 'from 20000 to 24999' end as income_range,
 counter as counties, democrats, republicans
from range_2
union
select income_group as lp,
 case when income_group = 3 then 'from 25000 to 29999' end as income_range,
 counter as counties, democrats, republicans
from range_3
union
select income_group as lp,
 case when income_group = 4 then '>= 30000' end as income_range,
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
with
income_group as (
 select county, party, income,
   case
   when income between  0 and 16999 then 0
   when income between 17000 and 19999 then 1
   when income between 20000 and 24999 then 2
   when income between 25000 and 29999 then 3
   else 4
   end as income_group
  from income_per_capita
 order by income desc
),
range_0 as (
 select income_group, count(party) as counter,
 count(case when party = 'Democrat' then 1 end) as democrats,
 count(case when party = 'Republican' then 1 end) as republicans
 from income_group
 where income_group = 0
 group by income_group
),
range_1 as (
 select income_group, count(party) as counter,
 count(case when party = 'Democrat' then 1 end) as democrats,
 count(case when party = 'Republican' then 1 end) as republicans
 from income_group
 where income_group = 1
 group by income_group
),
range_2 as (
 select income_group, count(party) as counter,
 count(case when party = 'Democrat' then 1 end) as democrats,
 count(case when party = 'Republican' then 1 end) as republicans
 from income_group
 where income_group = 2
 group by income_group
),
range_3 as (
 select income_group, count(party) as counter,
 count(case when party = 'Democrat' then 1 end) as democrats,
 count(case when party = 'Republican' then 1 end) as republicans
 from income_group
 where income_group = 3
 group by income_group
),
range_4 as (
 select income_group, count(party) as counter,
 count(case when party = 'Democrat' then 1 end) as democrats,
 count(case when party = 'Republican' then 1 end) as republicans
 from income_group
 where income_group = 4
 group by income_group
),
grouped_data as (
select income_group as lp,
 case when income_group = 0 then '<17000' end as income_range,
 counter as counties, democrats, republicans
from range_0
union
select income_group as lp,
 case when income_group = 1 then 'from 17000 to 19999' end as income_range,
 counter as counties, democrats, republicans
from range_1
union
select income_group as lp,
 case when income_group = 2 then 'from 20000 to 24999' end as income_range,
 counter as counties, democrats, republicans
from range_2
union
select income_group as lp,
 case when income_group = 3 then 'from 25000 to 29999' end as income_range,
 counter as counties, democrats, republicans
from range_3
union
select income_group as lp,
 case when income_group = 4 then '>= 30000' end as income_range,
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
woe as (select lp, ln(d_democrats/d_republicans) as woe from distribution ),
diff_dg_db as (select lp, d_republicans-d_democrats as "diff(d_democrats, d_republicans)" from distribution),
contributions as (
 select
   lp,
   (d_republicans-d_democrats) *ln(d_democrats/d_republicans) as contributor,
   sum( (d_republicans-d_democrats) *ln(d_democrats/d_republicans) )over()::numeric as iv
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

-- lp|income_range       |counties|democrats|republicans|d_democrats           |d_republicans         |woe                    |diff(d_democrats, d_republicans)|contributor                               |iv
-- -|-------------------|--------|---------|-----------|----------------------|----------------------|-----------------------|--------------------------------|------------------------------------------|------------------------------------------
-- 0|<17000             |     171|      125|         46|0.13312034078807241747|0.04898828541001064963|-0.99967234081320612355|         -0.08413205537806176784|0.0841044887372132947414370855376264566320|0.1819955383066219053999024088686736554397
-- 1|from 17000 to 19999|     391|      207|        184|0.22044728434504792332|0.19595314164004259851|-0.11778303565638345453|         -0.02449414270500532481|0.0028849944835961868517447921708325158893|0.1819955383066219053999024088686736554397
-- 2|from 20000 to 24999|     745|      299|        446|0.31842385516506922258|0.47497337593184238552| 0.39987537862937764119|          0.15654952076677316294|0.0626002988908610364805047047389727254986|0.1819955383066219053999024088686736554397
-- 3|from 25000 to 29999|     394|      194|        200|0.20660276890308839191|0.21299254526091586794| 0.03045920748470854588|          0.00638977635782747603|0.0001946275238639523695862666724118552564|0.1819955383066219053999024088686736554397
-- 4|>= 30000           |     177|      114|         63|0.12140575079872204473|0.06709265175718849840|-0.59306372200296277298|         -0.05431309904153354633|0.0322111286710874349566295597488301021634|0.1819955383066219053999024088686736554397
