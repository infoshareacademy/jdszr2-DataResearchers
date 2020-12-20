SELECT * --COUNTY, STATE, DENSITY
FROM 
(SELECT *
FROM 
	(SELECT wpc.fips, wpc.county, wpc.party
	, cfc.state_abbreviation AS "STATE"
	, cfc.pst045214 AS "POPULATION"
	, cfc.pop060210 AS "DENSITY"
--	, cfc.RHI125214 + RHI225214+ RHI325214+ RHI425214 +RHI525214 AS "ALL RACES"
--	, cfc.RHI125214 AS "WHITE"
	, cfc.RHI225214 AS "BLACK"
--	, cfc.RHI325214 AS "NATIVE"
--	, cfc.RHI425214 AS "ASIAN"
--	, cfc.RHI725214 + cfc.RHI825214 AS "WHITE2"
	, cfc.HSG445213 AS "HOMEOWNERSHIP"
	, cfc.VET605213 AS "VETERANS"
	, cfc.AGE775214 AS "AGE ABOVE 65"
	, cfc.INC910213 AS "INCOME PER CAPITA"
	FROM winning_per_county wpc
	JOIN county_facts_csv cfc ON wpc.fips = cfc.fips
	WHERE party = 'Democrat'
--	ORDER BY RANDOM() 
--	LIMIT 939
	UNION 
	SELECT wpc.fips, wpc.county, wpc.party
	, cfc.state_abbreviation AS "STATE"
	, cfc.pst045214 AS "POPULATION"
	, cfc.pop060210 AS "DENSITY"
--	, cfc.RHI125214 + RHI225214+ RHI325214+ RHI425214 +RHI525214 AS "ALL RACES"
--	, cfc.RHI125214 AS "WHITE"
	, cfc.RHI225214 AS "BLACK"
--	, cfc.RHI325214 AS "NATIVE"
--	, cfc.RHI425214 AS "ASIAN"
--	, cfc.RHI725214 + cfc.RHI825214 AS "WHITE2"
	, cfc.HSG445213 AS "HOMEOWNERSHIP"
	, cfc.VET605213 AS "VETERANS"
	, cfc.AGE775214 AS "AGE ABOVE 65"
	, cfc.INC910213 AS "INCOME PER CAPITA"
	FROM winning_per_county wpc
	JOIN county_facts_csv cfc ON wpc.fips = cfc.fips
	WHERE party = 'Republican'
--	ORDER BY RANDOM() 
--	LIMIT 939
	) population
ORDER BY "DENSITY" DESC) AS "MAP"

	
