-- Ecommerce queries

USE master
go

use comercio;

select * from products;
select * from availability;
insert into availability values(3,1,1);

select * from orders;
select * from ordersDetail;
insert into ordersDetail values(1,3,100,25000000);

