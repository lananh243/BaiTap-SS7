create database BAI6SS7;
USE BAI6SS7;

create table Departments (
	department_id int primary key,
    department_name varchar(255),
    location varchar(255)
);

create table Employees (
	employee_id int primary key,
    name varchar(255),
    dob date,
    department_id int,
    foreign key(department_id) references Departments(department_id),
    salary decimal(10, 2)
);

create table Projects (
	project_id int primary key,
    project_name varchar(255),
    start_date date,
    end_date date
);


create table Timesheets (
	timesheet_id int primary key,
    employee_id int,
    foreign key(employee_id) references Employees(employee_id),
    project_id int,
    foreign key(project_id) references Projects(project_id),
    work_date date,
    hours_worked decimal(5, 2)
);

create table WorkReports (
	report_id int primary key,
    employee_id int,
    foreign key(employee_id) references Employees(employee_id),
    report_date date,
    report_content text
);

INSERT INTO Departments (department_id, department_name, location) VALUES
(1, 'IT', 'Building A'),
(2, 'HR', 'Building B'),
(3, 'Finance', 'Building C');
-- Insert sample data into Employees table
INSERT INTO Employees (employee_id, name, dob, department_id, salary) VALUES
(1, 'Alice Williams', '1985-06-15', 1, 5000.00),
(2, 'Bob Johnson', '1990-03-22', 2, 4500.00),
(3, 'Charlie Brown', '1992-08-10', 1, 5500.00),
(4, 'David Smith', '1988-11-30', NULL, 4700.00);
-- Insert sample data into Projects table
INSERT INTO Projects (project_id, project_name, start_date, end_date) VALUES
(1, 'Project A', '2025-01-01', '2025-12-31'),
(2, 'Project B', '2025-02-01', '2025-11-30');
-- Insert sample data into WorkReports table
INSERT INTO WorkReports (report_id, employee_id, report_date, report_content) VALUES
(1, 1, '2025-01-31', 'Completed initial setup for Project A.'),
(2, 2, '2025-02-10', 'Completed HR review for Project A.'),
(3, 3, '2025-01-20', 'Worked on debugging and testing for Project A.'),
(4, 4, '2025-02-05', 'Worked on financial reports for Project B.'),
(5, NULL, '2025-02-15', 'No report submitted.');
-- Insert sample data into Timesheets table
INSERT INTO Timesheets (timesheet_id, employee_id, project_id, work_date, hours_worked) VALUES
(1, 1, 1, '2025-01-10', 8),
(2, 1, 2, '2025-02-12', 7),
(3, 2, 1, '2025-01-15', 6),
(4, 3, 1, '2025-01-20', 8),
(5, 4, 2, '2025-02-05', 5);

select name, department_name
from Employees join Departments on Departments.department_id = Employees.department_id
order by name;

select name, salary
from Employees
where salary > 5000
order by salary desc;

select name, sum(hours_worked) as total_worked
from Timesheets join Employees on Timesheets.employee_id = Employees.employee_id
group by name;

select Departments.department_name, avg(Employees.salary) as avg_salary
from Employees join Departments on Departments.department_id = Employees.department_id
group by Departments.department_name;

select project_name, sum(hours_worked) as total_hours
from Timesheets join Projects on Timesheets.project_id = Projects.project_id
where month(work_date) = 2 and year(work_date) = 2025
group by project_name;

select name, project_name, sum(hours_worked) as total_worked
from Timesheets
	join Employees on Timesheets.employee_id = Employees.employee_id
    join Projects on Timesheets.project_id = Projects.project_id
group by name, project_name;

select department_name, count(employee_id) as count_emp
from Employees join Departments on Departments.department_id = Employees.department_id
group by department_name
having count_emp > 1;

select report_date, name, report_content
from WorkReports join Employees on WorkReports.employee_id = Employees.employee_id
order by report_date desc
limit 2 offset 1;

select report_date, name, count(report_id) as count_report
from WorkReports join Employees on WorkReports.employee_id = Employees.employee_id
where report_content is not null and report_date between '2025-01-01' and '2025-02-01'
group by report_date, name;

select name as employee_name, project_name, sum(hours_worked) as total_hours, round(sum(hours_worked * salary)) as total_salary
from Timesheets
	join Employees on Timesheets.employee_id = Employees.employee_id
    join Projects on Timesheets.project_id = Projects.project_id
group by name,project_name
having total_hours > 5
order by total_salary desc;