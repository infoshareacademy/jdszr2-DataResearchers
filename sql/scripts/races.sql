
select
	party,
	avg(white) as "white avg", stddev(white) as "white std",
	avg(black) as "black avg", stddev(black) as "black std",
	avg(latin+indians+asians) as "others avg", stddev(latin+indians+asians) as "others std"	
from races
group by races.party



-- party     |white avg        |white std         |black avg         |black std         |others avg        |others std        |
-------------|-----------------|------------------|------------------|------------------|------------------|------------------|
-- Democrat  |65.45814696485621| 23.94938660016623|17.612886048988297|20.837812472892736|16.128008519701822|20.588787739236984|
-- Republican|81.93599574014905|14.746494048440088| 6.115654952076666| 8.678926998826784| 11.11938232161875|13.055674910906003|
