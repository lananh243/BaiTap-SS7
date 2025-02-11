create database BAI10SS7;
USE BAI10SS7;

create table students (
	studentId int primary key,
    studentName varchar(50),
    age int,
    email varchar(100)
);

create table class (
	classId int primary key,
    className varchar(50)
);

create table classStudent (
	studentId int,
    foreign key(studentId) references students(studentId),
    classId int,
    foreign key(classId) references class(classId)
);

create table subjects (
	subjectId int primary key,
    subjectName varchar(50)
);

create table marks (
	subjectId int,
    foreign key(subjectId) references subjects(subjectId),
	studentId int,
    foreign key(studentId) references students(studentId),
    mark int
);

-- Bảng students
INSERT INTO students (studentId, studentName, age, email) VALUES
(1, 'Nguyen Quang An', 18, 'an@yahoo.com'),
(2, 'Nguyen Cong Vinh', 20, 'vinh@gmail.com'),
(3, 'Nguyen Van Quyen', 19, 'quyen'),
(4, 'Pham Thanh Binh', 25, 'binh@com'),
(5, 'Nguyen Van Tai Em', 30, 'taiem@sport.vn');

-- Bảng class
INSERT INTO class (classId, className) VALUES
(1, 'C0706L'),
(2, 'C0708G');

-- Bảng classStudent
INSERT INTO classStudent (studentId, classId) VALUES
(1, 1),
(2, 1),
(3, 2),
(4, 2),
(5, 2),
(5, 1);

-- Bảng subjects
INSERT INTO subjects (subjectId, subjectName) VALUES
(1, 'SQL'),
(2, 'Java'),
(3, 'C'),
(4, 'Visual Basic');

-- Bảng mark
INSERT INTO marks (mark, subjectId, studentId) VALUES
(8, 1, 1),
(4, 2, 1),
(9, 1, 1),
(7, 1, 3),
(3, 1, 4),
(5, 2, 5),
(8, 3, 3),
(1, 3, 5),
(3, 2, 4);

select * from students;

select * from subjects;

select avg(mark) as Avg_Mark, studentName
from marks
join students on marks.studentId = students.studentId
group by studentName;

select subjectName, studentName
from marks
join students on marks.studentId = students.studentId
join subjects on marks.subjectId = subjects.subjectId
where mark > 9;

select avg(mark) as Avg_Mark, studentName
from marks
join students on marks.studentId = students.studentId
group by studentName
order by Avg_Mark desc;

update subjects
set subjectName = concat('Day la mon hoc ', subjectName);

DELIMITER //
	create trigger check_student_age
    before insert on students
    for each row
    begin 
	if new.age <= 15 or new.age >= 50
        then signal sqlstate '4500'
        set message_text = 'tuổi của học sinh phải lớn hơn 15 và nhỏ 50';
        end if;
	end;
//
DELIMITER ;

SELECT TABLE_NAME, CONSTRAINT_NAME
FROM information_schema.KEY_COLUMN_USAGE
WHERE TABLE_SCHEMA = 'BAI10SS7';

alter table classStudent drop foreign key classstudent_ibfk_2;
alter table marks drop foreign key marks_ibfk_1;
alter table marks drop foreign key marks_ibfk_2;

delete from marks where studentId = 1;
delete from classStudent where studentId = 1;
delete from students where studentId = 1;

alter table students 
add column status bit default 1;

update students 
set status = 0;
