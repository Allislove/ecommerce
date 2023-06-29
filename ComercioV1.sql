

use master
go

create database comercio
go
use comercio
go

create table customers (
customerId int IDENTITY(1,1) NOT NULL,
name nvarchar(50) NOT NULL,
lastName nvarchar(50),
age tinyint NOT NULL,
email nvarchar(50) UNIQUE NOT NULL,
password nvarchar(max) NOT NULL,
phone1 nvarchar(20) NOT NULL,
phone2 nvarchar(20) NULL,
address nvarchar(100) NOT NULL,
addressUrl nvarchar(MAX),
createdDate datetime DEFAULT GETDATE(),
modifiedDate datetime,
constraint PK_CustomerIdX_Name primary key NONCLUSTERED(customerId)
);
-- Index
CREATE CLUSTERED Index CusCIdx_Email ON
customers (email);
CREATE NONCLUSTERED INDEX CusNIdx_FirstPhone ON
customers (phone1);
--select * from customers;
/*ALTER TABLE customers 
ALTER COLUMN password NVARCHAR(max); */

create table employees(
employeeId int IDENTITY(1,1) NOT NULL,
name nvarchar(50) NOT NULL,
lastName nvarchar(50),
age tinyint NOT NULL,
email nvarchar(50) NULL,
companyEmail nvarchar(50) UNIQUE,
loginId char(10) UNIQUE NOT NULL,
password nvarchar(max),
jobTitle nvarchar(50),
organizationLevel nvarchar(50),
maritalStatus nvarchar(20),
phone nvarchar(20),
size char(5),
hireDate datetime DEFAULT GETDATE(),
leftDate datetime,
salarieFlag numeric(9,0),
vacationsHours tinyint,
sickLeaveHours tinyint,
constraint PK_Emp primary key NONCLUSTERED(employeeId)
);
-- Indexes
CREATE CLUSTERED INDEX EmpCidx_Lid ON
employees (loginId);
CREATE NONCLUSTERED INDEX EmpNCidx_Email ON
employees (email);
CREATE NONCLUSTERED INDEX emp_NCidx_compEmail ON
employees(companyEmail);

create table suppliers(
supplierId int IDENTITY(1,1) NOT NULL,
name nvarchar(30) NOT NULL,
lastName nvarchar(30),
country nvarchar(30),
city nvarchar(30),
companyEmail nvarchar(50) UNIQUE,
email nvarchar(50) NOT NULL,
phone1 nvarchar(20) NOT NULL,
phone2 nvarchar(20),
createdAt smalldatetime DEFAULT GETDATE(),
modifiedAt smalldatetime NULL,
constraint PK_suppliersPeople primary key CLUSTERED (supplierId)
);

-- Indexes
CREATE NONCLUSTERED INDEX supClIdx_Email ON
suppliers (email);
CREATE NONCLUSTERED INDEX supNClIdx_Name ON
suppliers(name);

create table products (
productId int IDENTITY(1,1) NOT NULL,
name nvarchar(50) NOT NULL,
price numeric(9,0) NOT NULL,
color nvarchar(20),
units smallint NOT NULL,
weight smallint,
code tinyint UNIQUE NOT NULL,
audioMessage nvarchar(50),
warningMessage nvarchar(50),
image nvarchar(MAX),
developer nvarchar(20),
website nvarchar(255),
languages nvarchar(50),
minimumGb tinyint,
createdAt smalldatetime DEFAULT GETDATE(),
modifiedAt smalldatetime,
supplierId INT,
constraint PK_ProductsHistory primary key NONCLUSTERED (productId),
constraint FK_supp_of_prod foreign key(supplierId)
references suppliers(supplierId) ON DELETE CASCADE ON UPDATE CASCADE
);

-- Index
CREATE CLUSTERED INDEX ProdCIDx_name ON
products (name);
CREATE NONCLUSTERED INDEX ProdNIDx_Code ON
products (code);

/*ALTER TABLE products 
ALTER COLUMN website NVARCHAR(250); */

create table stores (
storeId int IDENTITY(1,1) primary key,
name nvarchar(50),
city nvarchar(50),
address nvarchar(50),
addressUrl nvarchar(MAX),
);

create table availability(
availabilityId int IDENTITY(1,1) NOT NULL,
productId int NOT NULL,
storeId int NOT NULL,
availability bit,
constraint PK_availability primary key clustered (availabilityId),
constraint fk_storeId foreign key (storeId) 
references stores(storeId),
constraint fk_productIdAvailability foreign key (productId)
references products(productId),
constraint UQ_ProductIn_a_Store UNIQUE NONCLUSTERED (productId, storeId)
);

/*ALTER TABLE availability ADD availabilityId
INT IDENTITY(1,1) PRIMARY KEY; */
-- SELECT * FROM AVAILABILITY;
select * from products where supplierId = 1
create table orders (
orderId int IDENTITY(1,1) NOT NULL,
tax tinyint,
employeeId int,
customerId int,
orderDate datetime DEFAULT GETDATE(),
modifiedDate smalldatetime NULL,
constraint PK_ordersHistoryId primary key CLUSTERED (orderId),
constraint FK_emp_ord_sales foreign key (employeeId) 
references employees(employeeId) ON DELETE CASCADE ON UPDATE CASCADE,
constraint FK_cust_ord_id foreign key(customerId) 
references customers(customerId) ON UPDATE CASCADE ON DELETE CASCADE
);
-- Indices
CREATE NONCLUSTERED INDEX OrdNCIdx_OrdDate ON
orders (orderDate);


create table ordersDetail(
orderDetailId int IDENTITY(1,1) NOT NULL,
orderId int,
productId int,
quantity smallint,
price numeric(9,0),
constraint PK_orderDetailHistoryID primary key NONCLUSTERED (orderDetailID),
constraint FK_orderId foreign key (orderId) references orders(orderId) 
ON UPDATE CASCADE ON DELETE CASCADE,
constraint FK_WhatProductIs_Id foreign key (productId) references products(productId),
constraint UQ_ProductIn_a_OrdDetail UNIQUE NONCLUSTERED (orderId, productId)
);

--SELECT * FROM ordersDetail;

-- INDEX 
CREATE CLUSTERED INDEX CIDx_OrdDetail_OrdID ON
ordersDetail (orderId ASC);
CREATE NONCLUSTERED INDEX NCidx_OrdDetail_Price ON
ordersDetail(price ASC);

create table shipping(
shippingId int IDENTITY(1,1) NOT NULL,
orderId INT NOT NULL,
stateName nvarchar(30),
province nvarchar(30) NOT NULL,
city nvarchar(30) NOT NULL,
shippingDate DATETIME DEFAULT GETDATE() NOT NULL,
deliveryTime tinyint,
address nvarchar(100) NOT NULL,
courier nvarchar(50) NOT NULL,
courierPhone varchar(20),
postalCode varchar(10),
price numeric(8,0) NOT NULL,
moreInfo NVARCHAR(250),
constraint PK_ShippingId primary key NONCLUSTERED (shippingId),
constraint FK_OrderId_Detail FOREIGN KEY (orderId)
references orders(orderId)
);

CREATE CLUSTERED INDEX C_IDX_Address_Ship 
ON shipping(address ASC);
CREATE INDEX Nc_IDx_ShippingId ON shipping(shippingId);
CREATE INDEX Nc_IDx_OrdId ON shipping(orderId);

create table payments (
paymentId int IDENTITY(1,1) NOT NULL,
orderId int,
customerId int,
paymentDate datetime DEFAULT GETDATE(),
modifiedDate datetime NULL,
paymentMethod nvarchar(30),
amount numeric(9,0),
status nvarchar(50),
moreInfo NVARCHAR(50),
constraint PK_PaymentId PRIMARY KEY CLUSTERED (paymentId),
constraint FK_OrdId_Details FOREIGN KEY
(orderId) references orders(orderId),
constraint FK_CustomerId FOREIGN KEY (customerId)
references customers(customerId)
);
-- Indices
CREATE INDEX CIdx_PaymentId ON
payments(paymentId);
CREATE INDEX NCIdx_OrderId ON
payments(orderId);
CREATE INDEX NCIdx_CustId ON
payments(orderId);
CREATE INDEX NCIDx_PaymentDateId ON
payments(paymentDate);
/*ALTER TABLE dbo.payments
ALTER COLUMN status NVARCHAR(50)*/

-- ¡Adding some data to the database!
-- customers Data
INSERT INTO customers (name, lastName, age, email, password, phone1, address)
VALUES ('Juan', 'Perez', 25, 'iam@andresromana.com', '123456', '1234567890', 'Calle 1 # 1-1');
INSERT INTO customers (name, lastName, age, email, password, phone1, address)
VALUES ('Andres', 'Romana', 25, 'dev@andresromana.com', '123456', '1234567890', 'Calle 1 # 1-1');
INSERT INTO customers (name, lastName, age, email, password, phone1, address)
VALUES ('Eduardo', 'Romana', 30, 'eduardo@gmail.com', '123456', '1234567890', 'Calle 5# 10-1');  
INSERT INTO customers (name, lastName, age, email, password, phone1, address)
VALUES ('Seb', 'Star', 48, 'seb@hotmail.com', '123456', '1234567890', 'Calle 5# 10-1');

-- employees Data
INSERT INTO employees (name, lastName, age, email, companyEmail, loginId, password, jobTitle, organizationLevel, maritalStatus, phone, size, hireDate, leftDate, salarieFlag, vacationsHours, sickLeaveHours)
VALUES ('Maria', 'Salaman', 25, 'maria@gmail.com', 'maria@versace.com', 'ZQ0X904', '123456', 'CEO', 1, 'S', '1234567890', 'M', '2019-01-01', NULL, 1, 10, 10);
INSERT INTO employees (name, lastName, age, email, companyEmail, loginId, password, jobTitle, organizationLevel, maritalStatus, phone, size, hireDate, leftDate, salarieFlag, vacationsHours, sickLeaveHours)
VALUES ('Camila', 'Zapata', 65, 'camZ@gmail.com', 'cam.zapata@wallstreet.com', 'ZQ0X905', '123456', 'CEO', 1, 'S', '1234567890', 'M', '2019-01-01', NULL, 1, 10, 10);
INSERT INTO employees (name, lastName, age, email, companyEmail, loginId, password, jobTitle, organizationLevel, maritalStatus, phone, size, hireDate, leftDate, salarieFlag, vacationsHours, sickLeaveHours)
VALUES ('María', 'Mena', 29, 'mariamena@gmail.com', 'menarodrigues@wonderstravel.co', 'ZQ0X906', '123456', 'CEO', 1, 'S', '1234567890', 'M', '2019-01-01', NULL, 1, 100, 10);

-- Suppliers data
INSERT INTO suppliers(name, lastName, country, city, companyEmail, email, phone1, phone2, createdAt, modifiedAt)
VALUES ('Apple', 'Inc', 'USA', 'California', 'sales@apple.com', 'info@apple.com', '1234567890', '1234567890', '2019-01-01', NULL);
INSERT INTO suppliers(name, lastName, country, city, companyEmail, email, phone1, phone2, createdAt, modifiedAt)
VALUES ('Samsung', 'Inc', 'USA', 'California', 'samsumg@sales.com', 'stesamsumg@sales.com', '1234567890', '1234567890', '2019-01-01', NULL);
INSERT INTO suppliers(name, lastName, country, city, companyEmail, email, phone1, phone2, createdAt, modifiedAt)
VALUES ('Huawei', 'Inc', 'USA', 'California', 'jobs@huawei.com', 'ventas@huawei.com', '1234567890', '1234567890', '2019-01-01', NULL);
INSERT INTO suppliers(name, lastName, country, city, companyEmail, email, phone1, phone2, createdAt, modifiedAt)
VALUES ('LG', 'Inc', 'USA', 'California', 'salg@lg.com', 'ventas@lgsales.com', '1234567890', '1234567890', '2019-01-01', NULL);

-- Products data
INSERT INTO products (name, price, color, units, weight, code, audioMessage, warningMessage, image, developer, website, languages, minimumGb, createdAt, modifiedAt, supplierId)
VALUES ('iPhone X', 130, 'Black', 100, 0.5, 1, 'Hello, I am an iPhone X', 'Please, do not drop me', 'https://www.apple.com/lae/iphone-x/', 'Apple', 'https://www.apple.com/lae/iphone-x/', 'English', 64, '2019-01-01', NULL, 1);
INSERT INTO products (name, price, color, units, weight, code, audioMessage, warningMessage, image, developer, website, languages, minimumGb, createdAt, modifiedAt, supplierId)
VALUES ('iPhone 8', 120, 'Black', 100, 0.5, 2, 'Hello, I am an iPhone 8', 'Please, do not drop me', 'https://www.apple.com/lae/iphone-8/', 'Apple', 'https://www.apple.com/lae/iphone-8/', 'English', 64, '2019-01-01', NULL, 1);
INSERT INTO products (name, price, color, units, weight, code, audioMessage, warningMessage, image, developer, website, languages, minimumGb, createdAt, modifiedAt, supplierId)
VALUES ('iPhone 7', 100, 'Black', 100, 0.5, 3, 'Hello, I am an iPhone 7', 'Please, do not drop me', 'https://www.apple.com/lae/iphone-7/', 'Apple', 'https://www.apple.com/lae/iphone-7/', 'English', 64, '2019-01-01', NULL, 1);
INSERT INTO products (name, price, color, units, weight, code, audioMessage, warningMessage, image, developer, website, languages, minimumGb, createdAt, modifiedAt, supplierId)
VALUES ('Xbox Series X', 590, 'Black', 100, 0.5, 4, 'Hello, I am an Xbox Series X', 'Please, do not drop me', 'https://www.xbox.com/en-US/consoles/xbox-series-x', 'Microsoft', 'https://www.xbox.com/en-US/consoles/xbox-series-x', 'English', 64, '2019-01-01', NULL, 1);
INSERT INTO products (name, price, color, units, weight, code, audioMessage, warningMessage, image, developer, website, languages, minimumGb, createdAt, modifiedAt, supplierId)
VALUES ('Xbox Series S', 250, 'Black', 100, 0.5, 5, 'Hello, I am an Xbox Series S', 'Please, do not drop me', 'https://www.xbox.com/en-US/consoles/xbox-series-s', 'Microsoft', 'https://www.xbox.com/en-US/consoles/xbox-series-s', 'English', 64, '2019-01-01', NULL, 1);
INSERT INTO products (name, price, color, units, weight, code, audioMessage, warningMessage, image, developer, website, languages, minimumGb, createdAt, modifiedAt, supplierId)
VALUES ('PlayStation 5', 599, 'Black', 100, 0.5, 6, 'Hello, I am an PlayStation 5', 'Please, do not drop me', 'https://www.playstation.com/en-us/ps5/', 'Sony', 'https://www.playstation.com/en-us/ps5/', 'English', 64, '2019-01-01', NULL, 1);
INSERT INTO products (name, price, color, units, weight, code, audioMessage, warningMessage, image, developer, website, languages, minimumGb, createdAt, modifiedAt, supplierId)
VALUES ('Portail Asus ROG', 1300, 'Black', 100, 0.5, 7, 'Hello, I am an Portail Asus ROG', 'Please, do not drop me', 'https://rog.asus.com/us/', 'Asus', 'https://rog.asus.com/us/', 'English', 64, '2019-01-01', NULL, 1);
INSERT INTO products (name, price, color, units, weight, code, audioMessage, warningMessage, image, developer, website, languages, minimumGb, createdAt, modifiedAt, supplierId)
VALUES ('Mac Book Pro', 1500, 'Black', 100, 0.5, 8, 'Hello, I am an Mac Book Pro', 'Please, do not drop me', 'https://www.apple.com/lae/macbook-pro-13/', 'Apple', 'https://www.apple.com/lae/macbook-pro-13/', 'English', 64, '2019-01-01', NULL, 1);
INSERT INTO products (name, price, color, units, weight, code, audioMessage, warningMessage, image, developer, website, languages, minimumGb, createdAt, modifiedAt, supplierId)
VALUES ('Mac Book Air', 500, 'Black', 100, 0.5, 9, 'Hello, I am an Mac Book Air', 'Please, do not drop me', 'https://www.apple.com/lae/macbook-air/', 'Apple', 'https://www.apple.com/lae/macbook-air/', 'English', 64, '2019-01-01', NULL, 1);
INSERT INTO products (name, price, color, units, weight, code, audioMessage, warningMessage, image, developer, website, languages, minimumGb, createdAt, modifiedAt, supplierId)
VALUES ('Mac Book', 1000, 'Black', 100, 0.5, 10, 'Hello, I am an Mac Book', 'Please, do not drop me', 'https://www.apple.com/lae/macbook-air/', 'Apple', 'https://www.apple.com/lae/macbook-air/', 'English', 64, '2019-01-01', NULL, 1);
INSERT INTO products (name, price, color, units, weight, code, audioMessage, warningMessage, image, developer, website, languages, minimumGb, createdAt, modifiedAt, supplierId)
VALUES ('Mac Mini', 469, 'Black', 100, 0.5, 11, 'Hello, I am an Mac Mini', 'Please, do not drop me', 'https://www.apple.com/lae/mac-mini/', 'Apple', 'https://www.apple.com/lae/mac-mini/', 'English', 64, '2019-01-01', NULL, 1);
INSERT INTO products (name, price, color, units, weight, code, audioMessage, warningMessage, image, developer, website, languages, minimumGb, createdAt, modifiedAt, supplierId)
VALUES ('Beats Studio 3', 599, 'Black', 100, 0.5, 12, 'Hello, I am an Beats Studio 3', 'Please, do not drop me', 'https://www.beatsbydre.com/headphones/studio3-wireless', 'Beats', 'https://www.beatsbydre.com/headphones/studio3-wireless', 'English', 64, '2019-01-01', NULL, 1);
INSERT INTO products (name, price, color, units, weight, code, audioMessage, warningMessage, image, developer, website, languages, minimumGb, createdAt, modifiedAt, supplierId)
VALUES ('Beats Solo 3', 440, 'Black', 100, 0.5, 13, 'Hello, I am an Beats Solo 3', 'Please, do not drop me', 'https://www.beatsbydre.com/headphones/solo3-wireless', 'Beats', 'https://www.beatsbydre.com/headphones/solo3-wireless', 'English', 64, '2019-01-01', NULL, 1);
INSERT INTO products (name, price, color, units, weight, code, audioMessage, warningMessage, image, developer, website, languages, minimumGb, createdAt, modifiedAt, supplierId)
VALUES ('iPhone 14 Pro', 999, 'Black', 100, 0.5, 14, 'Hello, I am an iPhone 14 Pro', 'Please, do not drop me', 'https://www.apple.com/iphone-12-pro/', 'Apple', 'https://www.apple.com/iphone-12-pro/', 'English', 64, '2019-01-01', NULL, 1);
INSERT INTO products (name, price, color, units, weight, code, audioMessage, warningMessage, image, developer, website, languages, minimumGb, createdAt, modifiedAt, supplierId)
VALUES ('iPhone 14', 699, 'Black', 100, 0.5, 15, 'Hello, I am an iPhone 14', 'Please, do not drop me', 'https://www.apple.com/iphone-12/', 'Apple', 'https://www.apple.com/iphone-12/', 'English', 64, '2019-01-01', NULL, 1);
--SELECT * FROM PRODUCTS;

-- stores Data
INSERT INTO stores (name, city, address, addressUrl)
VALUES ('Apple Store', 'New York', '5th Avenue', 'https://goo.gl/maps/5thAvenue');
INSERT INTO stores (name, city, address, addressUrl)
VALUES ('Apple Store', 'New York', '5th Avenue', 'https://goo.gl/maps/5thAvenue');
INSERT INTO stores (name, city, address, addressUrl)
VALUES ('Microsoft Store', 'New York', '7Th Avenue', 'https://goo.gl/maps/5thAvenue');
INSERT INTO stores (name, city, address, addressUrl)
VALUES ('Netflix', 'New York', '7Th Avenue', 'https://goo.gl/maps/5thAvenue');

-- Products availability data
INSERT INTO availability (productId, storeId, availability)
VALUES (1, 1, 1);
INSERT INTO availability (productId, storeId, availability)
VALUES (2, 1, 1);
INSERT INTO availability (productId, storeId, availability)
VALUES (3, 1, 1);
INSERT INTO availability (productId, storeId, availability)
VALUES (4, 1, 1);
INSERT INTO availability (productId, storeId, availability)
VALUES (5, 1, 1);
--SELECT * FROM availability;

-- orders Data
INSERT INTO orders (tax, employeeId, customerId, orderDate, modifiedDate)
VALUES (0.19, 1, 1, '2019-01-01', NULL);
INSERT INTO orders (tax, employeeId, customerId, orderDate, modifiedDate)
VALUES (0.19, 2, 3, '2019-01-01', NULL);
INSERT INTO orders (tax, employeeId, customerId, orderDate, modifiedDate)
VALUES (0.19, 2, 2, '2019-01-01', NULL);
INSERT INTO orders (tax, employeeId, customerId, orderDate, modifiedDate)
VALUES (0.19, 1, 1, '2019-01-01', NULL);
INSERT INTO orders (tax, employeeId, customerId, orderDate, modifiedDate)
VALUES (20, 1, 1, '2023-06-14', NULL);
--SELECT * FROM orders;


-- ordersDetail data
INSERT INTO ordersDetail (orderId, productId, quantity, price)
VALUES (1, 1, 1, 1000000);
INSERT INTO ordersDetail (orderId, productId, quantity, price)
VALUES (1, 2, 1, 1000000);
INSERT INTO ordersDetail (orderId, productId, quantity, price)
VALUES (1, 3, 1, 1000000);
INSERT INTO ordersDetail (orderId, productId, quantity, price)
VALUES (1, 4, 1, 1000000);

-- Shipping data
INSERT INTO shipping (orderId, stateName, province, city, shippingDate, deliveryTime, address, courier, courierPhone, postalCode, price, moreInfo)
VALUES (1, 'Buenos Aires', 'Buenos Aires', 'Buenos Aires', '2019-01-01', 1, 'Av. Corrientes 1234', 'Andreani', '0800-1234-5678', '1234', 100, 'Entregar de 9 a 18hs');
INSERT INTO shipping (orderId, stateName, province, city, shippingDate, deliveryTime, address, courier, courierPhone, postalCode, price, moreInfo)
VALUES (2, 'Buenos Aires', 'Buenos Aires', 'Buenos Aires', '2019-01-01', 1, 'Av. Corrientes 1234', 'Andreani', '0800-1234-5678', '1234', 100, 'Entregar de 9 a 18hs');
INSERT INTO shipping (orderId, stateName, province, city, shippingDate, deliveryTime, address, courier, courierPhone, postalCode, price, moreInfo)
VALUES (3, 'Medellin', 'Antioquia', 'Medellin', '2019-01-01', 1, 'Av. Sur A', 'Andreani', '0800-1234-5678', '1234', 100, 'Entregar de 9 a 18hs');
INSERT INTO shipping (orderId, stateName, province, city, shippingDate, deliveryTime, address, courier, courierPhone, postalCode, price, moreInfo)
VALUES (4, 'Envigado', 'Antioquia', 'Envigado', '2019-01-01', 1, 'Av. Sur B', 'Andreani', '0800-1234-5678', '1234', 100, 'Entregar de 9 a 18hs');
INSERT INTO shipping (orderId, stateName, province, city, shippingDate, deliveryTime, address, courier, courierPhone, postalCode, price, moreInfo)
VALUES (4, 'Caldas', 'Antioquia', 'Caldas', '2019-01-01', 1, 'Av. Sur C', 'Andreani', '0800-1234-5678', '1234', 100, 'Entregar de 9 a 18hs');

-- Payments
INSERT INTO payments (orderId, customerId, paymentDate, modifiedDate, amount, status, moreInfo)
VALUES (1, 1, '2019-01-01', NULL, 100.00, 'PAID', 'XXXX-XXXX-XXXX-1111');

INSERT INTO payments (orderId, customerId, paymentDate, modifiedDate, paymentMethod, amount, status, moreInfo)
VALUES (2, 1, '2019-01-01', NULL, 'PayPal', 100.00, 'PAID', 'XXXX-XXXX-XXXX-1111');
INSERT INTO payments (orderId, customerId, paymentDate, modifiedDate, paymentMethod, amount, status, moreInfo)
VALUES (3, 1, '2019-01-01', NULL, 'Seguros', 100.00, 'PAID', 'XXXX-XXXX-XXXX-1111');
INSERT INTO payments (orderId, customerId, paymentDate, modifiedDate, paymentMethod, amount, status, moreInfo)
VALUES (4, 1, '2019-01-01', NULL, 'Transaccion', 100.00, 'PAID', 'XXXX-XXXX-XXXX-1111');
INSERT INTO payments (orderId, customerId, paymentDate, modifiedDate, paymentMethod, amount, status, moreInfo)
VALUES (5, 1, '2019-01-01', NULL, 'CREDIT_CARD', 100.00, 'PAID', 'XXXX-XXXX-XXXX-1111');
select * from payments;


select * from shipping;
SELECT * FROM orders;
select * from customers;
select * from products;