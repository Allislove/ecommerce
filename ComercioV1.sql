

use master
go

create database comercio;
use comercio;

create table customers (
customerId int IDENTITY(1,1) NOT NULL,
name nvarchar(50) NOT NULL,
lastName nvarchar(50),
age tinyint NOT NULL,
email nvarchar(50) UNIQUE NOT NULL,
password nvarchar(50) NOT NULL,
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


create table employees(
employeeId int IDENTITY(1,1) NOT NULL,
name nvarchar(50) NOT NULL,
lastName nvarchar(50),
age tinyint NOT NULL,
email nvarchar(50) NULL,
companyEmail nvarchar(50) UNIQUE,
loginId char(10) UNIQUE NOT NULL,
password nvarchar(50),
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
name nvarchar(30) UNIQUE NOT NULL,
lastName nvarchar(30),
country nvarchar(30),
city nvarchar(30),
companyEmail nvarchar(50),
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
website nvarchar(40),
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

create table stores (
storeId int IDENTITY(1,1) primary key,
name nvarchar(50),
city nvarchar(50),
address nvarchar(50),
addressUrl nvarchar(MAX),
);

create table availability(
productId int IDENTITY NOT NULL,
storeId int,
availability bit,
constraint fk_storeId foreign key (storeId) 
references stores(storeId),
constraint fk_productIdAvailability foreign key (productId)
references products(productId),
constraint UQ_ProductIn_a_Store UNIQUE NONCLUSTERED (productId, storeId)
);

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

-- INDEX 
CREATE CLUSTERED INDEX CIDx_OrdDetail_OrdID ON
ordersDetail (orderId ASC);
CREATE NONCLUSTERED INDEX NCidx_OrdDetail_Price ON
ordersDetail(price ASC);


