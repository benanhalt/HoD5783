

with color as (
   select distinct
     (regexp_matches(description, '\(.*\)'))[1] as color
   from product
   where description like '%(%)%'
   and description not like 'Jigsaw%'
   and description not like '%HO Scale%'
),
color_pair as (
   select c1.color as c1, c2.color as c2
   from color c1, color c2
   where c2 > c1
),
product_pair as (
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
   and o2.ordered - o1.ordered between '-5 minutes'::interval and '5 minutes'::interval
join customer c1 on o1.customerid = c1.customerid
join customer c2 on o2.customerid = c2.customerid
where c1.name = 'Emily Randolph' or c2.name = 'Emily Randolph';
