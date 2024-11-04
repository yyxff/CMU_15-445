
with team as(
    select code, country_code from teams
    group by code, country_code
)

, discipline_country as (
    select 
        m_c.discipline as discipline, 
        case when m_c.country_code is not null
            then m_c.country_code
            else athletes.country_code end
            as country_code 
    from 
    (select * from medals left join team on medals.winner_code = team.code) as m_c
    left join athletes on m_c.winner_code = athletes.code
)


-- select * from discipline_country
-- select discipline, count(*) from discipline_country
-- group by discipline

select name as coach_name, COUNT(*) as medal_number from coaches, discipline_country
    where coaches.discipline=discipline_country.discipline 
    AND coaches.country_code = discipline_country.country_code
    group by name    
    order by medal_number desc, name;



