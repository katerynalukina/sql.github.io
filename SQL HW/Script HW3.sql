with common_table as (
select
     ad_date,
     'facebook' as media_source,
     spend,
     impressions,
     reach,
     clicks,
     leads,
     value 
from facebook_ads_basic_daily fabd 
union
select 
     ad_date,
     'google' as media_source,
     spend,
     impressions,
     reach,
     clicks,
     leads,
     value 
from google_ads_basic_daily gabd
)
select ad_date,
       media_source,
       sum(spend)       as spend_sum,
       sum(clicks)      as cnt_clicks,
       sum(impressions) as total_impressions,
       sum(value)       as value_sum,
       round(sum(clicks)::numeric/sum(impressions), 2)                  as ctr,
       round(sum(spend)::numeric/sum(clicks), 2)                        as cpc,
       round(sum(spend)::numeric/sum(impressions)*1000, 2)              as cpm,
       round(((sum(value)::numeric - sum(spend))/sum(spend))*100, 2)    as romi
from common_table
group by ad_date, media_source
having sum(clicks)>0 and sum(impressions)>0 and sum(spend)>0