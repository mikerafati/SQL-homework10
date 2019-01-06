use sakila;
#1a`
select first_name,last_name from actor;

#1b
select upper(concat(first_name,'',last_name)) as 'Actor Name'
from actor;

#2a
select actor_id, first_name,last_name from actor where first_name='joe';

#2b
select * from actor where last_name like '%GEN';

#2c
select * from actor where last_name like '%LI%' order by last_name,first_name;

#2d
select country_id,country from country
where country in ('Afghanistan', 'Bangladesh', 'China');

#3a
alter table actor
ADD COLUMN middle_name VARCHAR(45) NULL AFTER first_name;
select * from actor;

#3b
ALTER TABLE actor 
CHANGE COLUMN middle_name middle_name BLOB NULL DEFAULT NULL ;

select * from actor;

#3c
alter table actor
drop column middle_name;
select * from actor;

#4a
select distinct last_name, count(last_name) from actor
group by last_name;

#4b
select distinct last_name,count(last_name) as 'name_count'
from actor
group by last_name having name_count >=2;

#4c
update actor
set first_name = 'HArpo' where first_name = 'GROUCHO' and last_name = 'WILLIAMS';

select actor_id from actor where first_name = 'HArpo' and last_name='WILLIAMS';
select * from actor where first_name = 'HArpo';

#4d not actor id 172
update actor
set first_name = 'GROUCHO' where actor_id = 172;

select * from actor where actor_id = 172;

#5a
show create table address;
create table if not exists
`address`(
`address_id` smallint(5) unsigned not null auto_increment,

`address` varchar(50) NOT NULL,
`address2` varchar(50) DEFAULT NULL,
`district` varchar(20) NOT NULL,
`city_id` smallint(5) unsigned NOT NULL,
`postal_code` varchar(10) DEFAULT NULL,
`phone` varchar(20) NOT NULL,
`location` geometry NOT NULL,
`last_update` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
PRIMARY KEY (`address_id`),
KEY `idx_fk_city_id` (`city_id`),
SPATIAL KEY `idx_location` (`location`),
CONSTRAINT `fk_address_city` FOREIGN KEY (`city_id`) REFERENCES `city` (`city_id`) ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=606 DEFAULT CHARSET=utf8;

#6a
select staff.first_name,staff.last_name,
address.address,
city.city,
country.country
from staff inner join address on staff.address_id = address.address_id
inner join city on address.city_id = city.city_id
inner join country on city.country_id = country.country_id;

#6b
select staff.first_name,staff.last_name, sum(payment.amount)
from staff inner join payment on staff.staff_id = payment.staff_id
where payment.payment_date like '2005-08%'
group by payment.staff_id;

#6c
select title,count(actor_id) as 'number of actor'
from film
inner join film_actor on film.film_id = film_actor.film_id
group by title;

#6d
SELECT 
title, COUNT(inventory_id) AS number_of_copies
FROM
film
INNER JOIN
inventory ON film.film_id = inventory.film_id
WHERE
title = 'Hunchback Impossible';

#6e
select last_name,first_name,sum(amount) as ' Total Paid'
from payment
inner join customer on payment.customer_id = customer.customer_id
group by payment.customer_id
order by last_name ASC;

#7a
SELECT title FROM film
WHERE language_id IN
(SELECT language_id 
FROM language
WHERE name = "English" )
AND (title LIKE "K%") OR (title LIKE "Q%");

#7b
select last_name,first_name from actor
where actor_id in (select actor_id from film_actor where film_id in
(select film_id from film where title = 'Alone Trip'));

#7c
SELECT 
customer.last_name, customer.first_name, customer.email
FROM
customer
INNER JOIN
customer_list ON customer.customer_id = customer_list.ID
WHERE
customer_list.country = 'Canada';

#7d
select title from film where film_id in (
select film_id from film_category where category_id in (
select category_id from category where name = 'Family'));

#7e
select film.title,count(*) as 'rent count'
from film, inventory, rental where 
film.film_id = inventory.film_id
and rental.inventory_id = inventory.inventory_id
group by inventory.film_id
order by count(*) desc,film.title ASC;

#7f
SELECT 
store.store_id, SUM(amount) AS 'Dollars brought in'
FROM
store
INNER JOIN
staff ON store.store_id = staff.store_id
INNER JOIN
payment ON payment.staff_id = staff.staff_id
GROUP BY store.store_id;

#7g

select store.store_id,city.city,country.country
from store inner join address on store.address_id = address.address_id
inner join city on address.city_id = city.city_id
inner join country on city.country_id = country.country_id;

#7h

SELECT 
name, SUM(p.amount) AS 'gross_income'
FROM
category c
INNER JOIN
film_category fc ON fc.category_id = c.category_id
INNER JOIN
inventory i ON i.film_id = fc.film_id
INNER JOIN
rental r ON r.inventory_id = i.inventory_id
RIGHT JOIN
payment p ON p.rental_id = r.rental_id
GROUP BY name
ORDER BY 'gross_income' DESC
LIMIT 5;

#8a

DROP VIEW IF EXISTS top_five_genres;
CREATE VIEW top_five_genres AS

SELECT 
name, SUM(p.amount) AS gross_revenue
FROM
category c
INNER JOIN
film_category fc ON fc.category_id = c.category_id
INNER JOIN
inventory i ON i.film_id = fc.film_id
INNER JOIN
rental r ON r.inventory_id = i.inventory_id
RIGHT JOIN
payment p ON p.rental_id = r.rental_id
GROUP BY name
ORDER BY gross_revenue DESC
LIMIT 5;

-- 8b. How would you display the view that you created in 8a?
SELECT * FROM top_five_genres;

-- 8c. You find that you no longer need the view `top_five_genres`. Write a query to delete it.
DROP VIEW top_five_genres;









