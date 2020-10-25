drop view if exists winning_per_county;
create view winning_per_county as
select fips, county, party, candidate, votes
from (
   select *, max(votes) over (partition by fips) as max_votes
   from primary_results_csv
) t
where votes = max_votes
order by county
