

with color as (
   -- Extract a relation of colors from product descriptions.  They
   -- mostly seem to be in parentheses. With some exceptions.
   select distinct
     (regexp_matches(description, '\(.*\)'))[1] as color
   from product
   where description like '%(%)%'
   and description not like 'Jigsaw%' -- spurious
   and description not like '%HO Scale%' -- spurios
),
color_pair as (
   -- Construct pairs of distinct colors.
   select c1.color as c1, c2.color as c2
   from color c1, color c2
   where c2 > c1 -- avoid repeated pairs in opposite order
),
product_pair as (
   -- Construct pairs of products that differ only in
   -- color according to the color pairs constructed above.
   select
     p1.description as description1,
     p2.description as description2,
     p1.sku as sku1,
     p2.sku as sku2
   from color_pair
   join product p1 on p1.description like '%' || c1 || '%'
   join product p2 on p2.description like '%' || c2 || '%'
   where p2.description = replace(p1.description, c1, c2)
)
-- Find pairs of customers who bought such a pair of products within 5
-- minutes of one another.
select
  c1.name,
  c1.phone,
  c2.name,
  c2.phone,
  product_pair.*
from product_pair
join order_item i1 on i1.sku = sku1
join order_item i2 on i2.sku = sku2
join orders o1 on o1.orderid = i1.orderid
join orders o2 on o2.orderid = i2.orderid
   and o2.customerid <> o1.customerid
   and o2.shipped - o1.shipped between '-5 minutes'::interval and '5 minutes'::interval
   -- This is probably extraneous.
   and o2.ordered - o1.ordered between '-5 minutes'::interval and '5 minutes'::interval
join customer c1 on o1.customerid = c1.customerid
join customer c2 on o2.customerid = c2.customerid
-- We know who one of the customers was.
where c1.name = 'Emily Randolph' or c2.name = 'Emily Randolph';

-- I made this a lot harder than it needed to be because I somehow got
-- the idea that both customers' identities were unknown. So I tried
-- finding all such customer pair. There are a lot. Then I spent along
-- time trying to figure out how to use the fact they lived together
-- for about a month. Finally had a duh moment and added the final
-- where clause.
