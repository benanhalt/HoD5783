
select
   *
from customer
where extract(year from birthdate) % 12 = 2  -- Years of the Dog
and birthdate between make_date(extract(year from birthdate)::int, 3, 20) -- Start of Aries
                  and make_date(extract(year from birthdate)::int, 4, 20) -- End of Aries
and citystatezip = ( -- Same neighborhood as Jeremy Davis
   select citystatezip from customer where name = 'Jeremy Davis'
);
