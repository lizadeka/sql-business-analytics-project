## Part3 questions
use online_learning_platform;

## Find students who exactly enrolled in one course
select s.full_name,
	count(c.course_name) as courses_enrolled
from students s
join enrollments e on e.student_id = s.student_id
join courses c on c.course_id = e.course_id
group by s.full_name
having count(c.course_name) = 1;

## List courses priced below the average course price
with avgprice as (
select round(avg(price),2) as avg_price
from courses
)
select c.course_name
from courses c
cross join avgprice ap
where c.price < ap.avg_price
;

## Find students whose first enrollment was after 2024-06-01
select s.full_name, e.enroll_date
from students s
join enrollments e on e.student_id = s.student_id
where e.enroll_date > '2024-06-01'
;

## Show students who completed at least one course fully
select distinct s.full_name
from students s
join enrollments e on e.student_id = s.student_id
join course_progress cp on cp.enrollment_id = e.enrollment_id
where cp.completed_percent = 100
;

## Find the cheapest course in each category
select course_name, category
 from 
(
	select course_name, category, price,
    row_number() over(partition by category order by price asc) as c_c
    from courses
) as temp
where c_c = 1
;

## Display students whose highest course price is above 3000
select s.full_name
from students s
join enrollments e on e.student_id = s.student_id
join courses c on c.course_id = e.course_id
where c.price > 3000
;

## Show courses whose enrollment count is below average
with course_count as (
select course_id,
count(*) as enroll_count
from enrollments
group by course_id
),
avg_enrollment as (
select avg(enroll_count) as avg_enroll
from course_count
)
select c.course_name
from courses c
join course_count cc on cc.course_id = c.course_id
join avg_enrollment ae
where cc.enroll_count < ae.avg_enroll
;

## Find students enrolled in atleast 2 different categories
select s.full_name
from students s
join enrollments e on e.student_id = s.student_id
join courses c on c.course_id = e.course_id
group by s.full_name
having count(distinct c.category) >= 2
;

## List courses where no students has completed more than 50%
select c.course_name
from courses c
join enrollments e on e.course_id = c.course_id
join course_progress cp on cp.enrollment_id = e.enrollment_id
group by c.course_name
having max(cp.completed_percent) <= 50
;

## Find students whose total spending is below average
with studentspend as(
	select s.full_name,
			sum(c.price) as total_spent
	from students s
    join enrollments e on e.student_id = s.student_id
	join courses c on c.course_id = e.course_id
    group by s.full_name
),
avgSpend as (
	select avg(total_spent) as avg_spend
    from studentspend
)
select ss.full_name
from studentspend as ss
join avgSpend as avgS
where ss.total_spent < avgS.avg_spend
;

## Show students who enrolled but never completed any course
select s.full_name
from students s
join enrollments e on e.student_id = s.student_id
join course_progress cp on cp.enrollment_id = e.enrollment_id
group by s.full_name
having max(cp.completed_percent) = 0
;

## Find categories with more than 3 courses
select count(*) as course_count,
category
from courses
group by category
having course_count > 3
;

## Show students whose average completion is above overall average
with overall_avg as (
  select avg(completed_percent) as avg_completion
  from course_progress
),
student_avg as (
  select s.student_id, s.full_name, 
  avg(cp.completed_percent) as avg_completion
  from students s
  join enrollments e on e.student_id = s.student_id
  join course_progress cp on cp.enrollment_id = e.enrollment_id
  group by s.student_id, s.full_name
)
select full_name
from student_avg sa
join overall_avg oa
where sa.avg_completion > oa.avg_completion;


## Find students enrolled in the least expensive course
select s.full_name
from students s
join enrollments e on e.student_id = s.student_id
join courses c on c.course_id = e.course_id
where c.price = (
	select min(price)
    from courses
)
;

## Find courses whose price is lower than the average price of their own category
select course_name
from courses c
where price < (
select avg(price)
from courses
where category = c.category
)
;

## Find students who enrolled only in free courses
select s.full_name
from students s
join enrollments e on e.student_id = s.student_id
join courses c on c.course_id = e.course_id
where c.price = 0
;

## Show courses where maximum completion < 70 %
select c.course_name
from courses c
join enrollments e on e.course_id = c.course_id
join course_progress cp on cp.enrollment_id = e.enrollment_id
group by c.course_name
having max(cp.completed_percent) < 70
;

## Find students who enrolled in the second most expensive course
select distinct full_name
from 
(
	select c.course_name, c.category, c.price, s.full_name,
    dense_rank() over(order by price desc) as c_c
    from courses c
    join enrollments e on e.course_id = c.course_id
    join students s on s.student_id = e.student_id
) as temp
where c_c = 2
;

## Display courses with enrollments greater than median
WITH course_enrollments AS (
    SELECT c.course_id,
           c.course_name,
           COUNT(e.enrollment_id) AS enroll_count
    FROM courses c
    LEFT JOIN enrollments e
        ON e.course_id = c.course_id
    GROUP BY c.course_id, c.course_name
),
ranked AS (
    SELECT *,
           ROW_NUMBER() OVER (ORDER BY enroll_count) AS rn,
           COUNT(*) OVER () AS total_cnt
    FROM course_enrollments
),
median_val AS (
    SELECT AVG(enroll_count) AS median_enroll
    FROM ranked
    WHERE rn IN (
        FLOOR((total_cnt + 1) / 2),
        CEIL((total_cnt + 1) / 2)
    )
)
SELECT ce.course_name
FROM course_enrollments ce
JOIN median_val mv
WHERE ce.enroll_count > mv.median_enroll;

## Find students who completed exactly one course
select s.full_name
from students s
join enrollments e on e.student_id = s.student_id
join course_progress cp on cp.enrollment_id = e.enrollment_id
where cp.completed_percent = 100
group by s.full_name
having count(*) = 1
;