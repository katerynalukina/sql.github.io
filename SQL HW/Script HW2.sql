--HW2
select ad_date,
       campaign_id,
       sum(spend)       as amt_all_spend,
       sum(impressions) as amt_impressions,
       sum(clicks)      as cnt_clicks,
       sum(value)       as incame,
       sum(clicks)::numeric/sum(impressions)                            as ctr,
       sum(spend)::numeric/sum(clicks)                                  as cpc,
       sum(spend)::numeric/sum(impressions)*1000                        as cpm,
       round(((sum(value)::numeric - sum(spend))/sum(spend))*100, 2)    as romi      
from public.facebook_ads_basic_daily
where impressions>0 and clicks>0
group by ad_date, campaign_id 
having sum(spend)>0 and sum(value)>0 and campaign_id is not null 
order by ad_date 
;
     
--romi max if value>500000
select campaign_id,
       sum(spend)                                                                       as amt_all_spend,
       sum(value)                                                                       as incame,
       round(((sum(value)::numeric - sum(spend)::numeric)/sum(spend)::numeric)*100,2)   as romi   
from public.facebook_ads_basic_daily
group by campaign_id 
having campaign_id is not null and sum(value)>500000 
order by romi desc 