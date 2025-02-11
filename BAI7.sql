create database BAI7SS7;
USE BAI7SS7;

-- Tạo bảng Student
CREATE TABLE Student (
    RN INT PRIMARY KEY,
    Name VARCHAR(20),
    Age TINYINT
);

-- Chèn dữ liệu vào bảng Student
INSERT INTO Student (RN, Name, Age) VALUES 
(1, 'Nguyen Hong Ha', 20),
(2, 'Truong Ngoc Anh', 30),
(3, 'Tuan Minh', 25),
(4, 'Dan Truong', 22);

-- Tạo bảng Test
CREATE TABLE Test (
    TestID INT PRIMARY KEY,
    Name VARCHAR(20)
);

-- Chèn dữ liệu vào bảng Test
INSERT INTO Test (TestID, Name) VALUES 
(1, 'EPC'),
(2, 'DWMX'),
(3, 'SQL1'),
(4, 'SQL2');

-- Tạo bảng StudentTest
CREATE TABLE StudentTest (
    RN INT,
    TestID INT,
    Date DATETIME,
    Mark FLOAT,
    FOREIGN KEY (RN) REFERENCES Student(RN),
    FOREIGN KEY (TestID) REFERENCES Test(TestID)
);

-- Chèn dữ liệu vào bảng StudentTest
INSERT INTO StudentTest (RN, TestID, Date, Mark) VALUES 
(1, 1, '2006-07-17', 8),
(1, 2, '2006-07-18', 5),
(1, 3, '2006-07-19', 7),
(2, 1, '2006-07-17', 7),
(2, 2, '2006-07-18', 4),
(2, 3, '2006-07-19', 2),
(3, 1, '2006-07-17', 10),
(3, 3, '2006-07-18', 1);

alter table Student 
add constraint chk_age check (Age between 15 and 55);

alter table StudentTest 
alter column Mark set default 0;

alter table StudentTest 
add constraint pk_studenttest primary key (RN, TestID);

alter table Test 
add constraint unique_test_name unique (Name);

alter table Test 
drop index unique_test_name;

select Student.Name as Student_Name, Test.Name as Test_Name, StudentTest.Mark, StudentTest.Date
from StudentTest
	join Student on StudentTest.RN = Student.RN
    join Test ON StudentTest.TestID = Test.TestID;

select Student.RN, Student.Name, Student.Age
from Student
left join StudentTest on Student.RN = StudentTest.RN
where StudentTest.RN is null;

select Student.Name as Student_Name, Test.Name as Test_Name, StudentTest.Mark, StudentTest.Date
from StudentTest
	join Student on StudentTest.RN = Student.RN
    join Test ON StudentTest.TestID = Test.TestID
where StudentTest.Mark < 5;

select Student.Name as Student_Name, avg(StudentTest.Mark) AS AVG_mark
from StudentTest
	join Student on StudentTest.RN = Student.RN
group by Name
order by AVG_mark desc;

select Student.Name as Student_Name, avg(StudentTest.Mark) AS AVG_mark
from StudentTest
	join Student on StudentTest.RN = Student.RN
group by Name
order by AVG_mark desc
limit 1;

select Test.Name as Test_Name, max(StudentTest.Mark) as Max_Mark
from StudentTest
	join Test ON StudentTest.TestID = Test.TestID
group by Name
order by Name;

select Student.RN, Student.Name as StudentName, Student.Age, Test.Name as TestName
from Student
left join StudentTest on Student.RN = StudentTest.RN
left join Test on StudentTest.TestID = Test.TestID;

update Student
set Age = Age + 1;
alter table Student
add Status varchar(10);

update Student
set Status = CASE 
    when Age < 30 then 'Young'
    else 'Old'
end;
select distinct Student.RN, Student.Name as StudentName, Student.Age, Status
from Student
left join StudentTest on Student.RN = StudentTest.RN
left join Test on StudentTest.TestID = Test.TestID;

select Student.Name as Student_Name, Test.Name as Test_Name, StudentTest.Mark, StudentTest.Date
from StudentTest
	join Student on StudentTest.RN = Student.RN
    join Test ON StudentTest.TestID = Test.TestID
order by Date asc;

select Student.Name as Student_Name, Student.Age, avg(StudentTest.Mark) as AVG
from StudentTest
	join Student on StudentTest.RN = Student.RN
where Student.Name like '%T%'
group by Student.Name, Student.Age
having AVG > 4.5;

select 
    S.RN, 
    S.Name as Student_Name, 
    S.Age, 
    avg(ST.Mark) as AVG_Mark, 
    (select count(distinct Subquery.AVG_Mark) 
     from (select RN, avg(Mark) as AVG_Mark from StudentTest group by RN) as Subquery
     where Subquery.AVG_Mark > AVG_Mark) + 1 as `Rank`
from Student S
join StudentTest ST on S.RN = ST.RN
group by S.RN, S.Name, S.Age;

alter table Student modify Name varchar(1000);

update Student
set Name = concat('Old ', Name)
where Age > 20;

update Student
set Name = case 
    when Age > 20 then concat('Old ', Name)
    else concat('Young ', Name)
end;

delete from Test 
where TestID not in (select distinct TestID from StudentTest);

delete from StudentTest 
where Mark < 5;
