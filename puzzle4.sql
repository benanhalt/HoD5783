
-- Solution is likely the woman with the most orders before 5AM.

select
  *
from customer,
lateral (
   -- Number of bakery orders between 3AM and 5AM
   select
     count(*)
   from orders
   join order_item using (orderid)
   where sku like 'BKY%'
   and shipped - date_trunc('day', shipped) between '3:00:00' and '5:00:00'
   and orders.customerid = customer.customerid
) as order_count
order by order_count desc
limit 10;

