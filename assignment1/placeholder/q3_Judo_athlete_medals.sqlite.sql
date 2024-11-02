with a_m as(
    select name, count(medal_code) as mn from(
        (select a.name, a.disciplines, a.code from athletes as a 
            where a.disciplines like '%Judo%' ) as a_Judo
        left join medals 
            on medals.winner_code=a_Judo.code 
    ) 
    group by name
)
    
, t_a_m as (select athletes.name, count(athletes.name) as mn from medals, teams, athletes
    where medals.winner_code=teams.code
    and teams.athletes_code=athletes.code

    group by athletes.name
    )


select * from a_m
    union all
select * from t_a_m

order by mn desc, name
