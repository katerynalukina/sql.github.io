select ad_date, spend, clicks, spend/clicks as spends_clicks
from public.facebook_ads_basic_daily
where clicks>0 
order by ad_date desc 

;


