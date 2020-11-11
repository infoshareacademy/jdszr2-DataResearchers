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
)

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


-- lp|income_range       |counties|democrats|republicans|
-----|-------------------|--------|---------|-----------|
--  3|from 25000 to 29999|     382|      194|        188|
--  1|from 17000 to 19999|     394|      207|        187|
--  0|<17000             |     177|      125|         52|
--  2|from 20000 to 24999|     731|      299|        432|
--  4|>= 30000           |     194|      114|         80|
