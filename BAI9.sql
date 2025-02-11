create database BAI9SS7;
USE BAI9SS7;

CREATE TABLE tblPhim (
    PhimID INT PRIMARY KEY AUTO_INCREMENT,
    Ten_phim VARCHAR(30),
    Loai_phim VARCHAR(25),
    Thoi_gian INT
);

CREATE TABLE tblPhong (
    PhongID INT PRIMARY KEY AUTO_INCREMENT,
    Ten_phong VARCHAR(20),
    Trang_thai TINYINT
);

CREATE TABLE tblGhe (
    GheID INT PRIMARY KEY AUTO_INCREMENT,
    PhongID INT,
    So_ghe VARCHAR(10),
    FOREIGN KEY (PhongID) REFERENCES tblPhong(PhongID)
);

CREATE TABLE tblVe (
    PhimID INT,
    GheID INT,
    Ngay_chieu DATETIME,
    Trang_thai VARCHAR(20),
    FOREIGN KEY (PhimID) REFERENCES tblPhim(PhimID),
    FOREIGN KEY (GheID) REFERENCES tblGhe(GheID)
);


-- Chèn dữ liệu vào bảng tblPhim
INSERT INTO tblPhim (Ten_phim, Loai_phim, Thoi_gian) VALUES
('Em bé Hà Nội', 'Tâm lý', 90),
('Nhiệm vụ bất khả thi', 'Hành động', 100),
('Dị nhân', 'Viễn tưởng', 90),
('Cuốn theo chiều gió', 'Tình cảm', 120);

-- Chèn dữ liệu vào bảng tblPhong
INSERT INTO tblPhong (Ten_phong, Trang_thai) VALUES
('Phòng chiếu 1', 1),
('Phòng chiếu 2', 1),
('Phòng chiếu 3', 0);

-- Chèn dữ liệu vào bảng tblGhe
INSERT INTO tblGhe (PhongID, So_ghe) VALUES
(1, 'A3'),
(1, 'B5'),
(2, 'A7'),
(2, 'D1'),
(3, 'T2');

-- Chèn dữ liệu vào bảng tblVe
INSERT INTO tblVe (PhimID, GheID, Ngay_chieu, Trang_thai) VALUES
(1, 1, '2008-10-20', 'Đã bán'),
(1, 3, '2008-11-20', 'Đã bán'),
(1, 4, '2008-12-23', 'Đã bán'),
(2, 1, '2009-02-14', 'Đã bán'),
(3, 1, '2009-02-14', 'Đã bán'),
(2, 5, '2009-03-08', 'Chưa bán'),
(2, 3, '2009-03-08', 'Chưa bán');

select * from tblPhim 
order by Thoi_gian;

select Ten_phim, Thoi_gian
from tblPhim
where Thoi_gian = (select Max(Thoi_gian) from tblPhim);

select Ten_phim, Thoi_gian
from tblPhim
where Thoi_gian = (select MIN(Thoi_gian) from tblPhim);

select * from tblGhe
where So_ghe like 'A%';

alter table tblPhong
modify column Trang_thai varchar(25);

update tblPhong
set Trang_thai = 
    case 
        when Trang_thai = '0' then 'Đang sửa'
        when Trang_thai = '1' then 'Đang sử dụng'
        when Trang_thai IS NULL then 'Unknow'
        else Trang_thai 
    end;
SELECT * FROM tblPhong;

select * from tblPhim 
where length(Ten_phim) > 15 and length(Ten_phim) < 25;

select concat(Ten_phong, ' - ', Trang_thai) as 'Trạng thái phòng chiếu'
from tblPhong;

create view tblRank as
select 
    ROW_NUMBER() over (order by Ten_phim) as STT,
    Ten_phim as TenPhim,
    Thoi_gian
from tblPhim;

-- 10
alter table tblPhim ADD Mo_ta VARCHAR(1000);

update tblPhim 
set Mo_ta = CONCAT('Đây là bộ phim thể loại ', Loai_phim);

select * from tblPhim;

update tblPhim 
set Mo_ta = replace(Mo_ta, 'bộ phim', 'film');

select * from tblPhim;

-- 11
SELECT TABLE_NAME, CONSTRAINT_NAME
FROM information_schema.KEY_COLUMN_USAGE
WHERE TABLE_SCHEMA = 'BAI9SS7' AND REFERENCED_TABLE_NAME IS NOT NULL;

alter table tblGhe drop foreign key tblghe_ibfk_1;
alter table tblVe drop foreign key tblve_ibfk_1;
alter table tblVe drop foreign key tblve_ibfk_2;

-- 12
delete from tblGhe;
-- 13
select 
    GheID, 
    PhimID, 
    Ngay_chieu AS 'Current_Date', 
    DATE_ADD(Ngay_chieu, interval 5000 minute) AS 'Date and Time'
from tblVe;
