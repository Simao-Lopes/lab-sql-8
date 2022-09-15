-- 1. Write a query to display for each store its store ID, city, and country.
select s.store_id, c.city, ct.country
from store s
join address using(address_id)
join city c using (city_id)
join country ct using (country_id);

-- 2. Write a query to display how much business, in dollars, each store brought in.
select s.store_id, sum(p.amount) as business_value
from payment p
join rental r using (rental_id)
join staff s 
where s.staff_id = p.staff_id
group by s.store_id;

-- 3. Which film categories are longest?
select c.name, count(film_id) as 'number of movies'
from film_category fc
join category c using (category_id)
group by c.category_id
order by count(film_id) desc;


-- 4. Display the most frequently rented movies in descending order.
select title as Movie
from rental
join inventory using (inventory_id)
join film using (film_id)
group by title
order by count(rental_id) desc;

-- 5. List the top five genres in gross revenue in descending order.
select c.name as genre, sum(p.amount) as 'gross revenue'
from category c
join film_category f using (category_id)
join inventory i using (film_id)
join rental r using (inventory_id)
join payment p using (rental_id)
group by f.category_id
order by sum(p.amount) desc
Limit 5;

-- 6. Is "Academy Dinosaur" available for rent from Store 1?
select 
case 
when count(i.film_id)>0 then 'Available'
else 'Unavailable'
end as 'Store availability', count(i.film_id) as 'Quantity'
from film f
join inventory i using(film_id)
join store s using (store_id)
where f.title = "Academy Dinosaur" and s.store_id=1
group by i.film_id;

-- 7. Get all pairs of actors that worked together.
-- Numeric pair Version
SELECT a1.actor_id as 'Actor 1' , a2.actor_id as 'Actor 2' 
FROM film_actor a1
JOIN film_actor a2
ON (a1.film_id = a2.film_id) AND (a1.actor_id <> a2.actor_id)
order by a1.actor_id asc;

-- Full name pair Version
select concat(a.first_name, ' ', a.last_name) as 'Actor 1', concat(b.first_name, ' ', b.last_name) as 'Actor 2'
from(
SELECT a1.actor_id as actor1 , a2.actor_id as actor2 
FROM film_actor a1
JOIN film_actor a2
ON (a1.film_id = a2.film_id) AND (a1.actor_id <> a2.actor_id)
)t1
join actor a
on a.actor_id = t1.actor1
join actor b
on b.actor_id = t1.actor2
order by t1.actor1 asc;

-- 8. Get all pairs of customers that have rented the same film more than 3 times.

# Need to make a querry that gives customers that rented the same movie 3 times or more, and then make 2
# subqueries with that, make a self join whre the filmID is the same

-- 9. For each film, list actor that has acted in more films.
select film.title as Movie, concat(actor.first_name, ' ',actor.last_name) as Actor, max(t1.ct) as 'Acted films'
from(
select actor_id, count(film_id) as ct
from film_actor
group by actor_id
order by count(film_id)
)t1
join (
select actor_id, film_id
from film_actor
)t2
on t2.actor_id = t1.actor_id
join film
on film.film_id = t2.film_id
join actor
on actor.actor_id = t1.actor_id
group by t2.film_id
order by t2.film_id asc;


