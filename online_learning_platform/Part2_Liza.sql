## Part2 questions
use online_learning_platform;

## Display all students who signed up after 2024-01-01
select * from students
where signup_date > '2024-01-01';

## List all courses priced above 2000
select * from courses
where price > 2000;

## Show total number of students city wise
select count(*) as total_students,
city 
from students
group by city;

## find the total number of enrollments per course
select count(*) as total_enrollments,
c.course_name 
from courses c
join enrollments e on e.course_id = c.course_id
group by c.course_name;

## Display student names along with courses they are enrolled in
select s.full_name,
	c.course_name
from students s
join enrollments e on e.student_id = s.student_id
join courses c on c.course_id = e.course_id
order by s.full_name asc
;

## Find total revenue generated from all courses
select sum(price) as total_revenue
from courses;

## show total amount spent by each student
select s.full_name,
    sum(c.price) as total_amount
from students s
join enrollments e on e.student_id = s.student_id
join courses c on c.course_id = e.course_id
group by s.full_name
;

## list students who enrolled in paid courses
select s.full_name
from students s
join enrollments e on e.student_id = s.student_id
join courses c on c.course_id = e.course_id
where c.price > 0
;

## Find average course price category wise
select round(avg(price),2) as avg_price,
category
from courses
group by category;

## Show students who enrolled in more than one course
select s.full_name,
	count(c.course_name) as courses_enrolled
from students s
join enrollments e on e.student_id = s.student_id
join courses c on c.course_id = e.course_id
group by s.full_name
having count(c.course_name) > 1
;

## Display courses with 0 enrollemnts
select c.course_name
from courses c
left join enrollments e on e.course_id = c.course_id
where c.course_id is null
;

## Find students who have never enrolled in any course
select s.full_name
from students s
join enrollments e on e.student_id = s.student_id
where s.student_id is null
;

## show highest priced course
select course_name, price
from courses
order by price desc
limit 1;

## count total enrollments month wise
select count(*) as total_enrollments,
monthname(enroll_date) as Name_of_month
from enrollments
group by Name_of_month
order by total_enrollments desc
;

## Display students with course completion above 80%
select s.full_name,
	cp.completed_percent
from students s
join enrollments e on e.student_id = s.student_id
join course_progress cp on cp.enrollment_id = e.enrollment_id
where cp.completed_percent > 80
;

## Find total number of course per category
select count(course_id) as total_courses,
	category
    from courses
group by category;

## show students who enrolled but have 0% progress
select s.full_name,
	cp.completed_percent
from students s
join enrollments e on e.student_id = s.student_id
join course_progress cp on cp.enrollment_id = e.enrollment_id
where cp.completed_percent = 0
;

## List top 3 students who spent highest total amount
select s.full_name,
    sum(c.price) as total_amount
from students s
join enrollments e on e.student_id = s.student_id
join courses c on c.course_id = e.course_id
group by s.full_name
order by total_amount desc
limit 3
;

## display course wise avg completion percentage
select c.course_name, 
round(avg(cp.completed_percent),2) as avg_completion
from courses c
join enrollments e on e.course_id = c.course_id
join course_progress cp on cp.enrollment_id = e.enrollment_id
group by c.course_name;

## Show students who enrolled in courses costing more than 2000
select s.full_name,
c.price
from students s
join enrollments e on e.student_id = s.student_id
join courses c on c.course_id = e.course_id
where c.price > 2000
;