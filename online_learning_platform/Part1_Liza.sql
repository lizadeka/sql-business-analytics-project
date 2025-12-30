## Part1 questions
use online_learning_platform;

## List all students from student table
select * from students;

## Display student_id, name, and city of students
select student_id,
	full_name,
    city
    from students;
    
## Fetch first 15 students based on student_id(ascending order)
select * from students
order by student_id
limit 15;

## show all courses whose price is greater than 1000
select * from courses
where price > 1000;

## display all courses belonging to category AI
select * from courses
where category = 'AI';

## List all distinct cities from where students come
select distinct city
from students;

## show top 10 most exp courses(highest price first)
select * from courses
order by price desc
limit 10;

## Show students whose name start with letter "A"
select * from students
where full_name like "A%";

## Fetch courses whose category contain the word "data"
select * from courses
where category like "%data%";

## Find the total number of students present in the platform
select count(distinct student_id) AS TotalStudents
from students;

## count total number of courses in each category
select count(course_id) as total_courses,
	category
    from courses
group by category;

## display instructors who joined in the year 2024
select * from instructors
where join_date between '2024-01-01' and '2024-12-31';

## show all enrollments made on the date 2024-08-01
select * from enrollments
where enroll_date = '2024-08-01';

## show students who are not from mumbai
select * from students
where city <> 'Mumbai';

## display the five cheapest courses
select * from courses
order by price
limit 5;

## display course name along with the length of each course name
select course_name,
length(course_name) as length_of_course 
from courses
;

## show students who signed up after 2023-01-01
select * from students
where signup_date > '2023-01-01'
;

## show all courses with price 999
select * from courses
where price = 999;

## list the latest 20 enrollments(based on enroll_date)
select * from enrollments
order by enroll_date desc
limit 20
;

## show student emails alphabetically
select email from students
order by email asc;