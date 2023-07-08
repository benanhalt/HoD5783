begin;

drop table if exists customer;
create table customer (
       customerid int,
       name text,
       address text,
       citystatezip text,
       birthdate text,
       phone text
);
\copy customer from 'noahs-customers.csv' with csv header

drop table if exists orders;
create table orders (
    orderid int,
    customerid int,
    ordered timestamp,
    shipped timestamp,
    items int,
    total decimal
);
\copy orders from 'noahs-orders.csv' with csv header

drop table if exists product;
create table product (
    sku text,
    description text,
    wholesale_cost decimal
);
\copy product from 'noahs-products.csv' with csv header

drop table if exists order_item;
create table order_item (
    orderid int,
    sku text,
    qty int,
    unit_price decimal
);
\copy order_item from 'noahs-orders_items.csv' with csv header

commit;

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

