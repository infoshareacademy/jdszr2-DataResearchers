SELECT * 
FROM 
	(
	SELECT wpc.fips, wpc.county, wpc.party
	, cfc.pst045214 AS "POPULATION"
	, cfc.pop060210 AS "DENSITY"
	, cfc.RHI125214 + RHI225214+ RHI325214+ RHI425214 +RHI525214 AS "ALL-100%"
	, cfc.RHI125214 AS "WHITE"
	, cfc.RHI725214 + cfc.RHI825214 AS "WHITE+LATINO"
--	, CFC.
	FROM winning_per_county wpc
	JOIN county_facts_csv cfc ON wpc.fips = cfc.fips
	WHERE party = 'Democrat', 
	ORDER BY RANDOM() 
	LIMIT 939
	UNION 
	SELECT wpc.fips, wpc.county, wpc.party, cfc.pst045214 AS POPULATION, cfc.pop060210 AS DENSITY
	, cfc.RHI125214 + RHI225214+ RHI325214+ RHI425214 +RHI525214 AS "ALL"
	, cfc.RHI125214 AS WHITE
	, cfc.RHI725214 + cfc.RHI825214 AS WHITE2
	FROM winning_per_county wpc
	JOIN county_facts_csv cfc ON wpc.fips = cfc.fips
	WHERE party = 'Republican'
	ORDER BY RANDOM() 
	LIMIT 939
	) population
ORDER BY "DENSITY" desc

	
