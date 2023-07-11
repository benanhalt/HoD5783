-- The following won't work. It tries to find a customer who bought
-- every collectible item. I've assumed a collectible item is one that
-- starts with "Noah's". It turns out there is no such customer.

-- with collectible as (
--    select *
--    from product
--    where description like 'Noah''s%'
-- )
-- select
--   *
-- from customer
-- where (
--   select
--     bool_and(exists (
--       select 1
--       from orders o
--       join order_item using (orderid)
--       where sku = collectible.sku
--       and o.customerid = customer.customerid
--     ))
--   from collectible
-- );

-- Instead just find the customer who bought the most collectibles. It
-- turns out there are some collectibles they never bought. It's an
-- interesting bonus puzzle to find what those item are!

select
  name,
  phone,
  count(*) as collectibles
from customer
join orders using (customerid)
join order_item using (orderid)
join product using (sku)
where description like 'Noah''s%'
group by name, phone
order by collectibles desc
limit 10;
