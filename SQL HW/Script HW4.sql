with fb_ads_data as (
select 
fabd.ad_date,
'facebook' as media_source,
fc.campaign_name,
fa.adset_name,
fabd.spend,
fabd. impressions,
fabd. reach,
fabd.clicks,
fabd .value
from facebook_ads_basic_daily fabd
left join facebook_adset fa on fa.adset_id = fabd.adset_id
left join facebook_campaign fc on fc.campaign_id = fabd. campaign_id
union 
select 
     ad_date,
     'google' as media_source,
     campaign_name,
     adset_name,
     spend,
     impressions,
     reach,
     clicks,
     value
from google_ads_basic_daily gabd 
)
select
ad_date,
media_source,
campaign_name,
adset_name,
round(sum(spend)::numeric/100, 2) as total_spend, -- центи перевела в долари
sum (impressions) as total_impressions, --
sum(clicks) as total_clicks,
round (sum (value)::numeric/100, 2) as total_value
from fb_ads_data
group by ad_date, media_source, campaign_name, adset_name
having campaign_name is not null
order by campaign_name, ad_date
;



select*
from google_ads_basic_daily gabd 

with fb_ads_data as (
select fabd.ad_date,
fc.campaign_name,
fa.adset_name,
fabd.spend,
fabd. impressions,
fabd. reach,
fabd.clicks,
fabd .value
from facebook_ads_basic_daily fabd
left join facebook_adset fa on fa.adset_id = fabd.adset_id
left join facebook_campaign fc on fc.campaign_id = fabd. campaign_id
)
select
ad_date,
campaign_name,
round(sum(spend)::numeric/100, 2) as total_spend, -- центи перевела в долари
sum (impressions) as total_impressions, --
sum(clicks) as total_clicks,
round (sum (value)::numeric/100, 2) as total_value
from fb_ads_data
group by 1,2
having campaign_name is not null
order by campaign_name, ad_date