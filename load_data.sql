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
create index on customer(customerid);

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
create index on orders(orderid);
create index on orders(customerid);

drop table if exists product;
create table product (
    sku text,
    description text,
    wholesale_cost decimal
);
\copy product from 'noahs-products.csv' with csv header
create index on product(sku);

drop table if exists order_item;
create table order_item (
    orderid int,
    sku text,
    qty int,
    unit_price decimal
);
\copy order_item from 'noahs-orders_items.csv' with csv header
create index on order_item(orderid);
create index on order_item(sku);

commit;
