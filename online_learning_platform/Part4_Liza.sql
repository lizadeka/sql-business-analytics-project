## Part4 questions
use online_learning_platform;

## Categorize courses as Cheap, Medium or Premium based on price
select  course_id,
	course_name,
	price,
case when price <= 500 then 'Cheap'
	when price <= 2000 then 'Medium'
    when price > 2000 then 'Premium'
    end as category_of_courses
from courses
;

## Label students as old or new based on sign up date
select student_id,
full_name,
signup_date,
case when signup_date < '2024-06-06' then 'Old'
	when signup_date >= '2024-06-06' then 'New'
    end as label
from students
;

## Classify instructors based on years of experience since joining
select 
  instructor_name,
  timestampdiff(year, join_date, curdate()) as years_experience,
  case
    when timestampdiff(year, join_date, curdate()) < 2 then 'Junior'
    when timestampdiff(year, join_date, curdate()) between 2 and 5 then 'Mid-level'
    else 'Senior'
  end as experience_level
from instructors;

## Find total enrollments year wise
select year(enroll_date) as year_wise,
count(*) as total_enrollments
from enrollments
group by year_wise
order by year_wise;

## Show month wise course enrollments
select monthname(enroll_date) as month_name,
count(*) as total_enrollments
from enrollments
group by month_name
order by month_name
;

## Identify inactive students(no enrollments)
select s.student_id,
s.full_name
from students s
left join enrollments e on e.student_id = s.student_id
where e.enrollment_id is null;

## Classify course completion status
select s.student_id, 
	s.full_name,
    c.course_name,
    cp.completed_percent,
    case when cp.completed_percent = 0 then "Not Started"
		when cp.completed_percent < 100 then "In Progress"
        when cp.completed_percent = 100 then "Completed"
        end as completion_status
from students s
join enrollments e on e.student_id = s.student_id
join courses c on c.course_id = e.course_id
join course_progress cp on cp.enrollment_id = e.enrollment_id
order by  s.student_id
;

## Find courses enrolled in during last 6 months
select c.course_id,
c.course_name,
e.enroll_date
from courses c
join enrollments e on e.course_id = c.course_id
where e.enroll_date >= date_sub(curdate(), interval 6 month)
order by c.course_id
;

## Show students with total courses enrolled
select s.full_name,
    count(e.course_id) as courses_enrolled
from students s
join enrollments e on e.student_id = s.student_id
join courses c on c.course_id = e.course_id
group by s.full_name
;

## Identify high value students based on total course value
select s.full_name,
    sum(c.price) as total_amount_spend,
    case when sum(c.price) > 10000 then 'High Value'
		when sum(c.price) between 5000 and 10000 then 'Medium Value'
        else 'Low Value'
        end as value_of_students
from students s
join enrollments e on e.student_id = s.student_id
join courses c on c.course_id = e.course_id
group by s.full_name
;

## Display courses and their demand level
select s.full_name,
    count(e.course_id) as courses_enrolled,
    case when count(e.course_id) > 10 then 'High Demand'
		when count(e.course_id) between 5 and 10 then 'Middle Demand'
        else 'Low Demand'
        end as demand_of_courses
from students s
join enrollments e on e.student_id = s.student_id
join courses c on c.course_id = e.course_id
group by s.full_name
;

## Find average completion percentage month wise
select monthname(e.enroll_date) as name_of_month,
        avg(cp.completed_percent) as avg_completion
from courses c
join enrollments e on e.course_id = c.course_id
join course_progress cp on cp.enrollment_id = e.enrollment_id
group by MONTH(e.enroll_date), name_of_month
order by MONTH(e.enroll_date)
;

## Identify students who enrolled but did not start learning
select s.full_name
from students s
join enrollments e on e.student_id = s.student_id
left join course_progress cp on cp.enrollment_id = e.enrollment_id
group by s.full_name
having max(coalesce(cp.completed_percent, 0)) = 0;

## Show course value contribution category wise
select c.category,
	count(e.enrollment_id) as total_enrollments,
    sum(c.price) as total_revenue
from courses c
join enrollments e on e.course_id = c.course_id
group by c.category
order by sum(c.price) desc
;

## Find the busiest enrollment date
select date(enroll_date) as enrollment_date,
	count(*) as total_enrollments
    from enrollments
    group by date(enroll_date)
    order by total_enrollments desc
    limit 1
    ;

## Rank students based on total course value(basic ranking)
select s.full_name,
    sum(c.price) as total_amount,
    dense_rank() over(order by sum(c.price) desc) as c_c
from students s
join enrollments e on e.student_id = s.student_id
join courses c on c.course_id = e.course_id
group by s.full_name
order by total_amount desc
;

## Identify courses with poor engagement(avg completion < 40%)
select c.course_name,
        round(avg(cp.completed_percent),2) as avg_completion,
        case when avg(cp.completed_percent) < 40 then "Poor engagement"
        else "High engagement"
        end as engagement_rate
from courses c
join enrollments e on e.course_id = c.course_id
join course_progress cp on cp.enrollment_id = e.enrollment_id
group by c.course_name
;


## Label students as active or inactive learners
select s.full_name,
	cp.completed_percent,
    case when cp.completed_percent > 0 then "Active learners"
    else "Inactive learners"
    end as label
from students s
join enrollments e on e.student_id = s.student_id
join course_progress cp on cp.enrollment_id = e.enrollment_id
;

## Find students who enrolled but dropped out early(< 30% completion)
select distinct s.full_name
from students s
join enrollments e on e.student_id = s.student_id
join course_progress cp on cp.enrollment_id = e.enrollment_id
where cp.completed_percent < 30
;

## Business Insight : Identify the top 3 most enrolled courses
select c.course_id,
	c.course_name,
	c.category,
	c.price,
	count(*) as total_enrollments
from courses c
join enrollments e on e.course_id = c.course_id
group by c.course_id, c.course_name, c.category, c.price
order by total_enrollments desc
limit 3
;

