-- remove repeated teams
with team as(select distinct code, country_code from teams)

--  gold number | country_code
, g_c as(select count(*) as mn,
        case when t.country_code is not null
            then t.country_code
            else a.country_code end
            as c_code
    from (medals left join team as t on medals.winner_code = t.code and medal_code=1) as m 
        left join athletes as a on m.winner_code = a.code and medal_code=1
    where medal_code = 1
    group by c_code
    order by mn desc
)


-- find out top 5 progress
, c_g as (
    select country_code,mn-gold_medal as progress 
    from g_c,tokyo_medals
        where g_c.c_code=tokyo_medals.country_code
    order by progress desc
    limit 5
)

-- find country and its all-female teams
, c_t as (
    select teams.country_code, teams.code from teams,athletes
        where teams.athletes_code=athletes.code
    group by teams.code
    having count(*) = count(case when athletes.gender=1 then 1 end)
)

select c_g.country_code,c_g.progress,c_t.code from c_g,c_t
where c_g.country_code=c_t.country_code
order by c_g.progress desc, c_g.country_code, c_t.code;