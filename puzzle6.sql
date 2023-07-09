
-- Find the customer who buys lots of items on sale.

select
  name,
  phone,
  count(*) as sale_purchases
from customer
join orders using (customerid)
join order_item using (orderid)
join product using (sku)
where product.wholesale_cost > order_item.unit_price
group by name, phone
order by sale_purchases desc
limit 10;
