with fb_ads_data as (
select 
fabd.ad_date,
    'facebook' as media_source,
    fc.campaign_name,
    fa.adset_name,
    fabd.url_parameters,
    fabd.spend,
    fabd.impressions,
    fabd.reach,
    fabd.clicks,
    fabd.value
from facebook_ads_basic_daily fabd
left join facebook_adset fa on fa.adset_id = fabd.adset_id
left join facebook_campaign fc on fc.campaign_id = fabd. campaign_id
union 
select 
     ad_date,
     'google' as media_source,
     campaign_name,
     url_parameters,
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
url_parameters,
media_source,
campaign_name,
adset_name,
case when lower(substring(url_parameters, 'utm_campaign=([^&#$]+)'))='nan' then null
     else substring(url_parameters, 'utm_campaign=([^&#$]+)') end as utm_campaign,
round(sum(spend)::numeric/100, 2) as total_spend, 
sum (impressions) as total_impressions, --
sum(clicks) as total_clicks,
round (sum (value)::numeric/100, 2) as total_value,
  case when sum(clicks)>0 then sum(spend)/sum(clicks)  else 0 end as cpc, ---vide string
  case when sum(impressions)>0 then 1000*sum(spend)/sum(impressions) else 0 end as cpm,
  case when sum(impressions)>0 then sum(clicks)::numeric/sum(impressions) else 0 end as ctr,
  case when sum(spend)>0 then round(sum(value)::numeric/sum(spend),2) else 0 end as romi
from fb_ads_data
group by ad_date, media_source, campaign_name, adset_name, url_parameters
having campaign_name is not null
order by campaign_name, ad_date











