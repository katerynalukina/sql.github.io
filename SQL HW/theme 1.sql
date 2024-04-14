select ad_date,
       spend, 
       clicks,
       spend/clicks as spends_clicks
from public.facebook_ads_basic_daily
where clicks>0 
order by ad_date desc 

;

select ad_date,
       spend,
       clicks,
       impressions,
       'auto' as write_mode,
       round((spend/(impressions*1.0)*100.0),2) as new_number
from public.facebook_ads_basic_daily
where spend>50000 and clicks>100 and impressions>10000
order by spend desc, leads 
limit 10

;

select *
from public.facebook_ads_basic_daily fabd 
limit 100

;

create table __users_klukina (
    user_id int,
    user_name varchar,
    email varchar  
)
;

select*from __users_klukina
;
drop table if exists __users_klukina
;
insert into __users_klukina(user_id,user_name,email)
values(1,'John','jo@gmail.com')
;
insert into __users_klukina(user_id,user_name,email)
values(2,'Marie','mar@gmail.com'), (3,'Lily','lily@gmail.com')
;

update __users_klukina
set email='mar2@dmail.com'
where user_id=2
;
delete from __users_klukina
where user_id=2
;
--lesson 2

select first_name,
       last_name,
       salary
from "HR".employees  
