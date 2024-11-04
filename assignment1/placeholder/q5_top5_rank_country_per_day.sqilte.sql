-- find all teams that day
with r_tc as(select distinct date,rank,participant_code,teams.country_code
from results,teams
where results.participant_code = teams.code
and rank is not null
-- and date = '2024-07-26'
-- and teams.country_code="KOR"
)

-- find all athletes that day
, r_ac as (select date,rank,participant_code,athletes.country_code
from results,athletes
where results.participant_code = athletes.code
and rank is not null
-- and date = '2024-07-25'
-- and athletes.country_code="KOR"
)

-- union them
, r_c as(select * from r_tc
union all
select * from r_ac
)

-- 找出每天得到前五名次数最多的国家
, res as(
    select date,country_code,appearance from (
        select date,country_code,appearance, ROW_NUMBER() over (partition by date order by appearance desc ) as r from (
            select *, count(country_code) as appearance from r_c
            where rank <= 5
            group by date,country_code
        ) as a
    )
    where r=1
)

-- country - gdp rank 
, c_gdp_rank as(
    select code,  ROW_NUMBER() over (order by "GDP ($ per capita)" desc) as r  from countries

)

-- country - population rank
, c_po_rank as(
    select code, ROW_NUMBER() over (order by Population desc) as r from countries
)

-- combine rank
, c_rank as(
    select c_gdp_rank.code, c_gdp_rank.r as gdp, c_po_rank.r as po from c_gdp_rank, c_po_rank
    where c_gdp_rank.code=c_po_rank.code
    order by c_gdp_rank.r
)


select date,country_code,appearance,c_rank.gdp,c_rank.po from res,c_rank
where country_code=c_rank.code
order by date;

