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

commit;

with translated as (
-- Define a relation with a name_numbers column that translates each
-- word in a customer's name to telephone digits. One row per word per
-- name.
     select
        name,
        phone,
        name_word,
        translate(name_word, 'abcdefghijklmnopqrstuvwxyz', '22233344455566677778889999') as name_numbers
     from customer,
          string_to_table(
                regexp_replace(lower(name), '[^a-z ]', '', 'g'), -- lowercase name and remove punctuation
                ' '
          ) as name_word -- split the name into words
)
-- Find rows where the phone number matches a translated name word.
-- This could find first or middle names, too, but inspection should
-- yield the result.
select * from translated
where replace(phone, '-', '') = name_numbers;



-- From wikipedia:
-- Number	Letter
-- 0	none (on some telephones, "OPERATOR" or "OPER")
-- 1	none (on some older telephones, QZ)
-- 2	ABC
-- 3	DEF
-- 4	GHI
-- 5	JKL
-- 6	MNO (on some older telephones, MN)
-- 7	PQRS (on older telephones, PRS)
-- 8	TUV
-- 9	WXYZ (on older telephones, WXY)
