

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
