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
),
ad_metrics as (
    select 
        date(date_trunc('month', ad_date)) as ad_month,
        case when lower(substring(url_parameters, 'utm_campaign=([^&#$]+)'))='nan' then null
        else substring(url_parameters, 'utm_campaign=([^&#$]+)') end as utm_campaign,
        sum(spend) as total_spend,
        sum(impressions) as total_impressions,
        sum(clicks) as cnt_clicks,
        sum(value) as sum_value,
        case 
        	when sum(clicks)!=0 then sum(spend)::numeric/sum(clicks)
        end as cpc,
        case 
        	when sum(impressions)!=0 then 1000*sum(spend)::numeric/sum(impressions)
        end as cpm,
        case 
        	when sum(impressions)!=0 then sum(clicks)::numeric/sum(impressions)
        end as ctr,
        case 
        	when sum(spend)!=0 then round(sum(value)::numeric/sum(spend),2)
        end as romi
from fb_ads_data
group by ad_month, url_parameters, media_source
order by 1 desc
)
select 
    metrics.ad_month,
    metrics.utm_campaign,
    metrics.total_spend,
    metrics.total_impressions,
    metrics.cnt_clicks,
    metrics.sum_value,
    metrics.cpc,
    cpc1m.cpc as cpc1m,
    round(100*metrics.cpc/cpc1m.cpc,2) as diff_cpc, 
    metrics.cpm,
    cpm1m.cpm as cpm1m,
    round(100*metrics.cpm/cpm1m.cpm,2) as diff_cpm,
    metrics.ctr,
    ctr1m.ctr as ctr1m,
    round(100*metrics.ctr/ctr1m.ctr,2) as diff_ctr,
    metrics.romi,
    romi1m.romi as romi1m,
    round(100*metrics.romi/romi1m.romi,2) as diff_romi
    from ad_metrics as metrics
    left join ad_metrics as cpc1m on metrics.ad_month = cpc1m.ad_month + interval '1 month'
    left join ad_metrics as cpm1m on metrics.ad_month = cpm1m.ad_month + interval '1 month'
    left join ad_metrics as ctr1m on metrics.ad_month = ctr1m.ad_month + interval '1 month'   
    left join ad_metrics as romi1m on metrics.ad_month = romi1m.ad_month + interval '1 month'
    ;
       
        
      
        
    



