with ash as (
	 select *,ceil(extract(epoch from max(ash_time)over()-min(ash_time)over()))::numeric samples
	 from pg_active_session_history where ash_time>=current_timestamp - interval '10 minutes'
) select  round(100 * count(*)/sum(count(*)) over(),0) as "%", round(count(*)/samples,2) as "AAS",
   datname,client_addr
 from ash
 group by datname,client_addr,samples
 order by 1 desc fetch first 10 rows only
;
