-- all athletics venue
with v_d as(select venue,disciplines from venues
where venues.disciplines like '%Athletics%'
order by venue
)


-- find all venue - discipline_name - event_name
, v_e as(select distinct results.venue, discipline_name, results.event_name from results,v_d
where results.venue = v_d.venue
group by discipline_name, results.event_name
)

-- find all name - code - la - lo in these venue
, n_c_c as(select name,country_code, nationality_code, countries.Latitude, countries.Longitude  from athletes,v_e,countries
where athletes.disciplines like '%'||v_e.discipline_name||'%'
and athletes.events like '%'||v_e.event_name||'%'
and athletes.country_code=countries.code
)

-- find their nationality_code and sort by distance
, n_c_n as (select name,country_code, nationality_code, n_c_c.Latitude as c_La, n_c_c.Longitude as c_Lo, countries.Latitude as n_La, countries.Longitude as n_Lo from n_c_c, countries
where n_c_c.nationality_code=countries.code
order by pow(c_La-n_La,2)+pow(c_Lo-n_Lo,2) desc,name
)

-- find valid part 
select distinct name, country_code,nationality_code from n_c_n
where n_c_n.n_La is not null
and n_c_n.n_Lo is not null
and n_c_n.c_La is not null
and n_c_n.c_Lo is not null