

use master
go

create database comercio;
use comercio;

create table customers (
customerId INT IDENTITY(1,1) NOT NULL,
name NVARCHAR(50),
lastName NVARCHAR(50),
age TINYINT,
email NVARCHAR(50) UNIQUE,
password NVARCHAR(50),
phone1 NVARCHAR(20),
phone2 NVARCHAR(20),
address NVARCHAR(100),
addressUrl NVARCHAR(MAX),
createdDate DATETIME,
modifiedDate DATETIME,
constraint PK_CustomerIdX_Name PRIMARY KEY NONCLUSTERED(customerId)
);
-- Index
CREATE CLUSTERED Index CusCIdx_Email ON
customers (email);
CREATE NONCLUSTERED INDEX CusNIdx_FirstPhone ON
customers (phone1);


create table employees(
employeeId INT IDENTITY(1,1) NOT NULL,
name NVARCHAR(50),
lastName NVARCHAR(50),
age TINYINT,
email NVARCHAR(50) NULL,
companyEmail NVARCHAR(50) UNIQUE,
loginId CHAR(10) UNIQUE,
password NVARCHAR(50),
jobTitle NVARCHAR(50),
organizationLevel VARCHAR(50),
maritalStatus NVARCHAR(20),
phone NVARCHAR(20),
size CHAR(5),
hireDate datetime,
leftDate datetime,
salarieFlag NUMERIC(9,0),
vacationsHours TINYINT,
sickLeaveHours TINYINT,
constraint PK_Emp PRIMARY KEY NONCLUSTERED(employeeId)
);
-- Indexes
CREATE CLUSTERED INDEX EmpCidx_Lid ON
employees (loginId);
CREATE NONCLUSTERED INDEX EmpNCidx_Email ON
employees (email);
CREATE NONCLUSTERED INDEX emp_NCidx_compEmail ON
employees(companyEmail);

create table suppliers(
supplierId INT IDENTITY(1,1) NOT NULL,
name NVARCHAR(30),
lastName NVARCHAR(30),
country NVARCHAR(30),
city NVARCHAR(30),
companyEmail NVARCHAR(50),
email NVARCHAR(50),
phone1 NVARCHAR(20),
phone2 NVARCHAR(20),
createdAt SMALLDATETIME,
modifiedAt SMALLDATETIME,
constraint PK_suppliersPeople PRIMARY KEY CLUSTERED (supplierId)
);

-- Indexes
CREATE NONCLUSTERED INDEX supClIdx_Email ON
suppliers (email);
CREATE NONCLUSTERED INDEX supNClIdx_Name ON
suppliers(name);

create table products (
productId INT IDENTITY(1,1) PRIMARY KEY,
name NVARCHAR(50),
color NVARCHAR(20),
units SMALLINT,
weight SMALLINT,
code TINYINT UNIQUE,
audioMessage NVARCHAR(50),
warningMessage NVARCHAR(50),
image NVARCHAR(MAX),
developer NVARCHAR(20),
website NVARCHAR(40),
languages NVARCHAR(50),
minimumGb TINYINT,
createdAt SMALLDATETIME,
modifiedAt SMALLDATETIME,
supplierId INT,
constraint FK_supp_of_prod foreign key(supplierId)
references suppliers(supplierId) ON DELETE CASCADE ON UPDATE CASCADE
);

create table stores (
storeId INT IDENTITY(1,1) PRIMARY KEY,
name NVARCHAR(50),
city NVARCHAR(50),
address NVARCHAR(50),
addressUrl NVARCHAR(MAX),
);

create table availability(
productId INT IDENTITY NOT NULL,
storeId INT,
availability BIT,
constraint fk_storeId FOREIGN KEY (storeId) 
references stores(storeId),
constraint fk_productIdAvailability FOREIGN KEY (productId)
references products(productId)
);

create table orders (
orderId INT IDENTITY(1,1) NOT NULL,
tax TINYINT,
employeeId INT,
customerId INT,
orderDate DATETIME,
modifiedDate SMALLDATETIME,
constraint PK_ordersHistoryId PRIMARY KEY CLUSTERED (orderId),
constraint FK_emp_ord_sales FOREIGN KEY(employeeId) 
references employees(employeeId) ON DELETE CASCADE ON UPDATE CASCADE,
constraint FK_cust_ord_id FOREIGN KEY(customerId) 
references customers(customerId) ON UPDATE CASCADE ON DELETE CASCADE
);

create table ordersDetail(
orderDetailId INT IDENTITY(1,1) NOT NULL,
orderId INT,
productId INT,
quantity SMALLINT,
constraint PK_orderDetailHistoryID PRIMARY KEY CLUSTERED (orderDetailID),
constraint FK_orderId FOREIGN KEY (orderId) REFERENCES orders(orderId) 
ON UPDATE CASCADE ON DELETE CASCADE,
CONSTRAINT uniqueProduct_orderId_productId 
UNIQUE (orderId, productId), -- Pending 

);



-- ¡Adding some index!


