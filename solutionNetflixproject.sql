select * from Netflix;

----Number of TV shows and Movies---
select type , count (*) as total_content
from Netflix 
group by type;


----Most comman ratings for TV shows nd movies---
select type , rating 
from 
(
	select type , rating , Count(*) ,
    RANK() OVER (PARTITION BY type ORDER BY COUNT(*) DESC) AS ranking
from Netflix 
group by 1 , 2 
) t1
where ranking = 1;

----All Movies released in 2019----
select * 
from Netflix 
where type = 'Movie'
and release_year = 2019;

----Top 5 Countries with most content on netflix---

select 
UNNEST (string_to_array (country ,', ') )as new_country,
count(show_id) as total_content
from Netflix
group by 1 
order by 2 DESC 
limit 5 ;

----Identify the longest Movie----

 select title, max(CAST(SUBSTRING(duration,1,POSITION(' ' IN duration)-1)as INT)) as maximun_lenght
from netflix
where type = 'Movie' and duration is not null
group by 1
order by 2 desc;

----Content added in the last five years----
SELECT * 
FROM netflix
WHERE to_date(date_added , 'Month DD , YYYY') >= current_date - interval '5 years'
;


---find all movies/TV shows by 'Rajiv chilaka'-----
select * 
from netflix 
where director like '%Rajiv chilaka%'
;

-----List all TV Shows with more than five seasons-----
select *  
from netflix 
where type = 'TV show'
and split_part(duration , ' ' , 1)::numeric > 5
;

-----Number of content ineach Genre----
select 
unnest(string_to_array(listed_in , ',' )) as genre
 , count(show_id) as total_content
from Netflix
group by 1
;

----Average content released in INDIA on Netflix in each year----
SELECT 
    EXTRACT(YEAR FROM TO_DATE(date_added, 'Month DD, YYYY')) AS year, 
    COUNT(*) AS total_content,
    ROUND(COUNT(*)::numeric / (SELECT COUNT(*) FROM Netflix WHERE country = 'India') * 100, 2) AS avg_content

FROM 
    Netflix
GROUP BY 
    EXTRACT(YEAR FROM TO_DATE(date_added, 'Month DD, YYYY'))
ORDER BY 
    year DESC;


----List all Movies that are documentries----
select * 
from Netflix
where listed_in ILIKE'%documentries%';


-----top 10 actors who appeared in the highest number of movies produced in India----
select 
unnest(string_to_array(casts, ',' )) as actors ,
count (*) as total_content 
from Netflix 
where country ilike '%india%'
group by 1 
order by 2 DESC
limit 10;

























