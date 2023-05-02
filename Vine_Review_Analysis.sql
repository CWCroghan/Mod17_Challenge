-- Limiting table to those reviews with at least 20 votes
create table vine_20 as 
	SELECT * from vine_table
	where total_votes >= 20
;

-- Create a table where reviews were considered helpful 50% of the time.
create table vine_20_helpful as 
select * from vine_20
where CAST(helpful_votes AS FLOAT)/CAST(total_votes AS FLOAT) >=0.5;

-- Split the helpful reviews into Vime/ not Vime tables
create table Yvine_20_helpful as 
select * from vine_20_helpful
where vine = 'Y';

create table Nvine_20_helpful as 
select * from vine_20_helpful
where vine = 'N';



create table star5 as
select total, yvinetotal, nvinetotal, total5stars, yvine5stars , CAST(yvine5stars AS FLOAT)/CAST(yvinetotal AS FLOAT) as ypctvine, 
	nvine5stars, CAST(nvine5stars AS FLOAT)/CAST(nvinetotal AS FLOAT) as npctvine, r0, y0, n0, r1, r2, r3
from 
	(select count(review_id) as total, 1 as r0
	from vine_20_helpful) as t0 
join
(select count(review_id) as yvinetotal, 1 as y0
	from Yvine_20_helpful) as y0 on (t0.r0 = y0.y0)
join
(select count(review_id) as nvinetotal, 1 as n0
	from Nvine_20_helpful) as n0 on (t0.r0 = n0.n0)
join
(select count(review_id) as total5stars, 1 as r1
	from vine_20_helpful
	where star_rating = 5) as t on (t0.r0 = t.r1)
join
	(select count(review_id) as yvine5stars, 1 as r2
	from Yvine_20_helpful
	where star_rating = 5) as y on (t.r1 = y.r2)
join
	(select count(review_id) as nvine5stars, 1 as r3
	from nvine_20_helpful
	where star_rating = 5) as n on (r2 = r3);

select * from star5


-- Generate the contingency table to be used in R for calculation of Chi-square.

create table contingency as
	select yvine5stars as Vime1, nvine5stars as notVime1,
	(yvinetotal - yvine5stars) as Vime2, (nvinetotal-nvine5stars) as notVime2
	from star5;
	
select * from contingency;