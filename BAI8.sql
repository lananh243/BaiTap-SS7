create database BAI8SS7;
USE BAI8SS7;

create table Customer (
	CID INT primary key,
    NAME varchar(25),
    CAGE tinyint
);
create table Orders (
	OID INT primary key,
    CID INT,
    foreign key(CID) references Customer(CID),
    ODATE datetime,
    OTotalPrice int
);

create table Product (
	pID INT primary key,
    pName varchar(25),
    pPrice int
);

create table OrderDetail (
	oID int,
    foreign key(oID) references Orders(oID),
    pID int,
    foreign key(pID) references Product(pID),
    odQTY int
);

INSERT INTO Customer (cID, Name, cAge) VALUES
(1, 'Minh Quan', 10),
(2, 'Ngoc Oanh', 20),
(3, 'Hong Ha', 50);

INSERT INTO Orders (oID, cID, oDate, oTotalPrice) VALUES
(1, 1, '2006-03-21', NULL),
(2, 2, '2006-03-23', NULL),
(3, 1, '2006-03-16', NULL);

INSERT INTO Product (pID, pName, pPrice) VALUES
(1, 'May Giat', 3),
(2, 'Tu Lanh', 5),
(3, 'Dieu Hoa', 7),
(4, 'Quat', 1),
(5, 'Bep Dien', 2);

INSERT INTO OrderDetail (oID, pID, odQTY) VALUES
(1, 1, 3),
(1, 3, 7),
(1, 4, 2),
(2, 1, 1),
(3, 1, 8),
(2, 5, 4),
(2, 3, 3);

select *
from Orders
order by oDate desc;

select pName,pPrice
from Product
where pPrice = (select Max(pPrice) from Product);

select Name as CName, pName
from Orders
	join Customer on Customer.cID = Orders.cID
    join OrderDetail on OrderDetail.oID = Orders.oID
    join Product on Product.pID = OrderDetail.pID;

select Customer.Name as CName
from Customer
	left join Orders on Customer.cID = Orders.cID
where Orders.cID is null;

select Orders.oID, Orders.oDate, OrderDetail.odQTY, Product.pName, Product.pPrice
from OrderDetail
	join Orders on Orders.oID = OrderDetail.oID
    join Product on Product.pID = OrderDetail.pID;
    
select  Orders.oID, Orders.oDate, sum((odQTY*pPrice)) AS Total
from OrderDetail
	join Orders on Orders.oID = OrderDetail.oID
    join Product on Product.pID = OrderDetail.pID
group by Orders.oID, Orders.oDate;

SELECT TABLE_NAME, COLUMN_NAME, CONSTRAINT_NAME, REFERENCED_TABLE_NAME 
FROM information_schema.KEY_COLUMN_USAGE 
WHERE TABLE_SCHEMA = 'BAI8SS7' AND REFERENCED_TABLE_NAME IS NOT NULL;

alter table Orders drop foreign key orders_ibfk_1;
alter table OrderDetail drop foreign key orderdetail_ibfk_1;
alter table OrderDetail drop foreign key orderdetail_ibfk_2;

alter table Customer drop primary key;
alter table Orders drop primary key;
alter table Product drop primary key;

