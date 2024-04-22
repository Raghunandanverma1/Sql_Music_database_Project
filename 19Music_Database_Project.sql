use music_database;

select * from album;

# Q1 - WHO IS THE SENIOR MOST EMPLOYEE BASED ON JOB TITLE.
  # we can find this based on levels of employee
  
  select * from employee order by levels desc limit 1 ;   # Andrew Adams
  
  # Q2 - WHICH COUNTY HAVE THE MOST INVOICES
  
  select billing_country,count(invoice_id) from invoice group by invoice.billing_country limit 1 ; # USA
  
  # Q3 - WHAT ARE THE TOP THREE VALUES OF TOTAL INVOICES.
  
  select * from invoice order by total desc limit 3;
  
  # Q4 
  
  select city from customer as c where ( select billing_city ,sum(total) from invoice group by billing_city );
  
  select billing_city ,sum(total) as Invoice_total from invoice group by billing_city order by Invoice_total desc; # limit 1   - Prague
  
  # Q5
  
  select customer.customer_id, customer.first_name , customer.last_name , sum(invoice.total) as Total
  from customer
  join invoice on customer.customer_id = invoice.customer_id
  group by customer.customer_id					# something wrong
  order by Total desc;
  
  # MODERATE LEVEL QUESTIONS
  
# Q1

select * from genre;
select * from customer;

select distinct c.email, c.first_name , c.last_name 
from customer c
join invoice on c.customer_id = invoice.invoice_id
join invoice_line on invoice.invoice_id = invoice_line.invoice_id
where track_id in 
(select track_id from track
join genre on track.genre_id = genre.genre_id
where genre.name like 'Rock')
order by c.email asc ;

# Q2 

select * from artist;
select * from track ;
select * from genre;

select  artist.artist_id , artist.name_ , count(artist.artist_id) as No_of_Songs
 from track
 join album on track.album_id = album.album_id 
 join artist on album.artist_id = artist.artist_id
 join genre on genre.genre_id = genre.genre_id
 where genre.name like 'Rock'
 group by artist.artist_id
 order by No_of_Songs desc 
 limit 10;
 
 # Q3
 
 select avg(track.milliseconds) from track;
 
 select track.name , track.milliseconds from track 
 where track.milliseconds > (select avg(track.milliseconds) as Longest_song from track)
 order by track.milliseconds desc;
 
 # QUESTION SET 3 ADVANCE
 
 # Q1
 
 select * from customer;
 select * from invoice;
 select * from invoice_line;
 select * from artist;
 
with best_selling_artist as(
select artist.artist_id as artist_id , artist.name_ as artist_name, sum(il.unit_price * il.quantity) as Total_sales
from invoice_line il
join track on il.track_id = track.track_id
join album on track.album_id = album.album_id
join artist on album.artist_id = artist.artist_id
group by 1
order by 3 desc
)
select customer.customer_id , customer.first_name, customer.last_name , bsa.artist_name , 
sum(il.unit_price * il.quantity) as Total_spent
from invoice i
join customer on i.customer_id = customer.customer_id
join invoice_line il on il.invoice_id = i.invoice_id
join track on il.track_id = track.track_id
join album on track.album_id = album.album_id
join best_selling_artist bsa on album.artist_id = bsa.artist_id
group by 1,2,3,4
order by 5 desc ;

# Q2 

se

use music_database;

with most_popular_genre as(
select count(invoice_line.quantity) as Purchases , customer.country ,genre.name ,  genre.genre_id , 
row_number() over(partition by customer.country order by count(invoice_line.quantity)desc) as row_no
from invoice_line
join invoice on invoice.invoice_id = invoice_line.invoice_id
join customer on customer.customer_id = invoice.customer_id
join track on track.track_id = invoice_line.track_id
join genre on genre.genre_id = track.genre_id
group by 2,3,4 
order by 2 asc , 1 desc
)
select * from most_popular_genre where row_no <= 1 ;  # row_no <=1 means it create only one row for one country like for Australia only one row and one row for other countries too.
 
 
 # Q3
 
 with recursive customer_with_country as(
 select customer.customer_id, customer.first_name, customer.last_name , billing_country , sum(total) as Total_spending
 from invoice
 join customer on invoice.customer_id = customer.customer_id
 group by 1,2,3,4
 order by 1 , 5
 ),
 country_max_spending as (
 select billing_country , max(Total_spending) as max_spending
 from customer_with_country
 group by 1
 )
 select cc.billing_country, cc.total_spending ,cc.first_name ,cc.last_name 
 from customer_with_country cc
 join country_max_spending ms on cc.billing_country = ms.billing_country
 where cc.Total_spending = ms.max_spending 
 order by 1 ;
 
 # the solution for this ques can be done without recursive cte , as done in Q2.
 
 with this_cte as(
 select customer.customer_id , customer.first_name , customer.last_name , billing_country , sum(total) as total_spending ,
 row_number() over(partition by(invoice.billing_country) order by sum(total) desc ) as row_no
 from invoice
 join customer on invoice.customer_id = customer.customer_id
 group by 1,2,3,4
 order by 4 asc , 5 desc
 )
 select * from this_cte where row_no <=1;
 
 
 
 
 
 
 
 
 
 
 
 
 
 