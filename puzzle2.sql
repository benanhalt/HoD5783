
select
   customer.customerid,
   name,
   phone,
   initials,
   orders.*
from customer,
lateral (
   select
     string_agg(substring(name_word from 1 for 1), '') as initials
   from string_to_table(
           regexp_replace(lower(name), '[^a-z ]', '', 'g'), -- lowercase name and remove punctuation
           ' '
     ) as name_word -- split the name into words
) initials,
lateral (
   select
     orderid,
     ordered,
     string_agg(description, '; ') as items
   from orders
   join order_item using (orderid)
   join product using (sku)
   where orders.customerid = customer.customerid
   group by orderid, ordered
) orders
where initials = 'jd'
and extract(year from ordered) = 2017
and items ilike '%bagel%';

