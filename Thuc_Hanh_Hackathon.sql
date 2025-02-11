CREATE DATABASE HKT;
USE HKT;

create table tbl_users (
	user_id INT primary key auto_increment,
    user_name varchar(50) unique not null,
    user_fullname varchar(100) not null,
    email varchar(100) not null unique,
    user_address varchar(255),
    user_phone varchar(20) unique not null
);

create table tbl_employees (
	emp_id char(5) primary key,
    user_id INT,
    foreign key(user_id) references tbl_users(user_id),
    emp_name varchar(255),
    emp_position varchar(50) not null,
    emp_hire_date date,
    salary decimal(10, 2) check(salary > 0) not null,
    emp_status bit default 1
);

create table tbl_orders (
	order_id int primary key auto_increment,
    user_id INT,
    foreign key(user_id) references tbl_users(user_id),
    order_date datetime default current_timestamp,
    order_total_amount decimal(10,2) not null
);

create table tbl_products (
	pro_id char(5) primary key,
    pro_name varchar(100) unique not null,
    pro_price decimal(10,2) not null check(pro_price > 0),
    pro_quantity int,
    pro_status bit default 1
);


create table tbl_order_detail (
	order_detail_id char(5) primary key,
    order_id int,
    foreign key(order_id) references tbl_orders(order_id),
    pro_id char(5),
    foreign key(pro_id) references tbl_products(pro_id),
    order_detail_quantity int check(order_detail_quantity > 0),
    order_detail_price decimal(10, 2)
);

-- Đổi kiểu dữ liệu của cột user_phone thành VARCHAR(11)
alter table tbl_users
modify column user_phone varchar(11) not null;
-- Xóa cột email khỏi bảng tbl_users
alter table tbl_users
drop column email;

ALTER TABLE tbl_orders 
ADD COLUMN order_status ENUM('Pending', 'Processing', 'Completed', 'Cancelled') NOT NULL DEFAULT 'Pending';

-- 3
-- Thêm dữ liệu vào bảng tbl_users
INSERT INTO tbl_users (user_name, user_fullname, user_address, user_phone) VALUES
('nguyen_van_a', 'Nguyễn Văn A', 'Hà Nội', '0912345678'),
('tran_thi_b', 'Trần Thị B', 'TP. Hồ Chí Minh', '0987654321'),
('le_van_c', 'Lê Văn C', 'Đà Nẵng', '0901122334'),
('pham_thanh_d', 'Phạm Thanh D', 'Cần Thơ', '0933445566');

-- Thêm dữ liệu vào bảng tbl_employees
INSERT INTO tbl_employees (emp_id, user_id, emp_name, emp_position, emp_hire_date, salary, emp_status) VALUES
('E0001', 1, 'Ngoc Lan','Manager','2022-01-15', 5000.00, 1),
('E0002', 2, 'Mai Ngan','Sales','2023-05-10', 3000.00, 1),
('E0003', 3, 'Bich Nga','IT Support','2021-08-20', 4000.00, 1),
('E0004', 4, 'Lan Chi','HR', '2020-11-30', 3500.00, 1);

-- Thêm dữ liệu vào bảng tbl_orders
INSERT INTO tbl_orders (user_id, order_date, order_total_amount, order_status) VALUES
(1, '2024-02-01 10:30:00', 150.50, 'Pending'),
(2, '2024-02-02 12:45:00', 250.75, 'Processing'),
(3, '2024-02-03 14:20:00', 99.99, 'Completed'),
(4, '2024-02-04 16:10:00', 200.00, 'Cancelled');

-- Thêm dữ liệu vào bảng tbl_products
INSERT INTO tbl_products (pro_id, pro_name, pro_price, pro_quantity, pro_status) VALUES
('P001', 'Laptop Dell', 1000.00, 10, 1),
('P002', 'iPhone 14', 1200.00, 5, 1),
('P003', 'AirPods Pro', 250.00, 15, 1),
('P004', 'Samsung TV', 800.00, 7, 1);

-- Thêm dữ liệu vào bảng tbl_order_detail
INSERT INTO tbl_order_detail (order_detail_id, order_id, pro_id, order_detail_quantity, order_detail_price) VALUES
('OD001', 1, 'P001', 1, 1000.00),
('OD002', 2, 'P002', 1, 1200.00),
('OD003', 3, 'P002', 2, 500.00),
('OD004', 4, 'P004', 1, 800.00);


-- 4
select order_id, order_date, order_total_amount, order_status 
from tbl_orders;

select distinct user_fullname from tbl_users join tbl_orders on tbl_users.user_id = tbl_orders.user_id;

-- 5
select pro_name, sum(order_detail_quantity) as total_sold
from tbl_products join tbl_order_detail on tbl_products.pro_id = tbl_order_detail.pro_id
group by pro_name;


select pro_name, sum(order_detail_price * order_detail_quantity) as revenue
from tbl_products join tbl_order_detail on tbl_products.pro_id = tbl_order_detail.pro_id
group by pro_name
order by revenue desc;

-- 6
select user_fullname, count(order_total_amount) as total_order 
from tbl_users join tbl_orders on tbl_users.user_id = tbl_orders.user_id
group by user_fullname;


select user_fullname, count(order_total_amount) as total_order 
from tbl_users join tbl_orders on tbl_users.user_id = tbl_orders.user_id
group by user_fullname
having total_order >= 2;

-- 7
select user_fullname , sum(order_detail_quantity * order_detail_price) as total_amount
from tbl_users 
	join tbl_orders on tbl_users.user_id = tbl_orders.user_id
	join tbl_order_detail on tbl_orders.order_id = tbl_order_detail.order_id
group by user_fullname
order by total_amount desc
limit 5;

-- 8
select emp_position, emp_name,  
case
	when count(order_id) is null then 0
    else count(order_id)
end as processing_orders
from tbl_employees 
	join tbl_users on tbl_employees.user_id = tbl_users.user_id
    join tbl_orders on tbl_users.user_id = tbl_orders.user_id
group by emp_position, emp_name;

-- 9
select user_fullname , sum(order_detail_quantity * order_detail_price) as total_amount
from tbl_users 
	join tbl_orders on tbl_users.user_id = tbl_orders.user_id
	join tbl_order_detail on tbl_orders.order_id = tbl_order_detail.order_id
group by user_fullname
order by total_amount desc
limit 1;

-- 10
select p.pro_id, p.pro_name, p.pro_quantity 
from tbl_products p left join tbl_order_detail od on p.pro_id = od.pro_id
where od.pro_id is null;