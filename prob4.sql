-- Write your PostgreSQL query statement below
with cte as (
    select employee_id,experience,salary, 
    sum(salary) over (partition by experience order by salary, employee_id) as rsum
    from Candidates
    order by experience desc, salary
)
select 'Senior' as experience, coalesce(count(employee_id),0) as accepted_candidates
from cte
where experience = 'Senior' and
rsum <= 70000
group by experience
union
select 'Junior' as experience, coalesce(count(employee_id),0) as accepted_candidates
from cte
where experience = 'Junior' and
rsum <= (select 70000 -  coalesce(max(rsum),0) from cte where experience = 'Senior' and rsum <= 70000)
group by experience


    
