
-- List of products purchased by customers in Queens Village.
-- The owner of many senior cats is apparent.

select
   name,
   phone,
   array_agg(product.description)
from customer
join orders using (customerid)
join order_item using (orderid)
join product using (sku)
where citystatezip like 'Queens Village%'
group by name, phone;

