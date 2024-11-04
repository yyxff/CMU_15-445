
-- 所有运动员｜他们的个人奖杯数量
with a_m as(
    select name, count(medal_code) as mn from(
        (select a.name, a.disciplines, a.code from athletes as a 
            where a.disciplines like '%Judo%' ) as a_Judo
        left join medals 
            on medals.winner_code=a_Judo.code 
    ) 
    group by name
)
-- 有团体奖的运动员 name｜他们的团体奖数量
, t_a_m as (select athletes.name, count(athletes.name) as mn from medals, teams, athletes
    where medals.winner_code=teams.code
    and teams.athletes_code=athletes.code
    and medals.discipline='Judo'
    group by athletes.name
    )

-- union 两者，排序
, a_mn as(
    select * from a_m
        union all
    select * from t_a_m
)
select a_mn.name,sum(mn) as newmn from a_mn
group by name
order by newmn desc, name
