-- Ecommerce queries


use comercio;

select * from products;
select * from availability;
insert into availability values(3,1,1);

select * from orders;
select * from ordersDetail;
-- Añadir nueva columna a la tabla ordersDetail,
-- Esta columna llevara la sumatoria total de X orden