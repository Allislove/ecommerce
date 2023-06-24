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

-- Adding more items to ordersDetail
INSERT INTO ordersDetail (orderId, productId, quantity, price)
VALUES (2, 1, 20, 1000000);
INSERT INTO ordersDetail (orderId, productId, quantity, price)
VALUES (2, 2, 100, 1000000);
INSERT INTO ordersDetail (orderId, productId, quantity, price)
VALUES (2, 3, 250, 1000000);
INSERT INTO ordersDetail (orderId, productId, quantity, price)
VALUES (2, 9, 49, 1000000);


use comercio;
SELECT name, quantity, orderId from products p 
inner join ordersDetail oD on oD.productId = p.productId;