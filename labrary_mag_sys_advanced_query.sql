--- Advanced query 

select * from books
select * from branch
select * from employee
select * from issued_books
select * from members
select * from return_status

/* Task 13: Identify Members with Overdue Books
Write a query to identify members who have overdue books (assume a 30-day return period). Display the member's_id,
member's name, book title, issue date, and days overdue. */

select ist.issued_member_id , 
m.member_name,
bk.book_title,
ist.issued_date,
rs.return_date,
CURRENT_DATE - ist.issued_date as over_due
from issued_books as ist
join 
members as m
on ist.issued_member_id = m.member_id

join 
books as bk
on bk.isbn = ist.issued_book_isbn
left join 
return_status as rs 
on rs.issued_id = ist.issued_id
where 
	rs.return_date IS NULL
	and (CURRENT_DATE - ist.issued_date) > 365;

	
select * from books 



/* ask 15: Branch Performance Report
Create a query that generates a performance report for each branch, showing the number of books issued, the number of books 
returned, and the total revenue generated from book rentals. */

CREATE TABLE branch_reports
AS
SELECT 
    b.branch_id,
    b.manager_id,
    COUNT(ist.issued_id) as number_book_issued,
    COUNT(rs.return_id) as number_of_book_return,
    SUM(bk.rental_price) as total_revenue
FROM issued_books as ist
JOIN 
employee as e
ON e.emp_id = ist.issued_emp_id
JOIN
branch as b
ON e.branch_id = b.branch_id
LEFT JOIN
return_status as rs
ON rs.issued_id = ist.issued_id
JOIN 
books as bk
ON ist.issued_book_isbn = bk.isbn
GROUP BY 1, 2;

SELECT * FROM branch_reports;


/* Task 16: CTAS: Create a Table of Active Members
Use the CREATE TABLE AS (CTAS) statement to create a new table active_members containing members who have issued at least
one book in the last 2 months. */



CREATE TABLE active_members
AS
SELECT * FROM members
WHERE member_id IN (SELECT 
                        DISTINCT issued_member_id   
                    FROM issued_books
                    WHERE 
                        issued_date >= CURRENT_DATE - INTERVAL '2 month'
                    )
;

SELECT * FROM active_members;


/* Task 17: Find Employees with the Most Book Issues Processed
Write a query to find the top 3 employees who have processed the most book issues. Display 
the employee name, number of books processed, and their branch.
*/ 

SELECT 
    e.emp_name,
    b.*,
    COUNT(ist.issued_id) as no_book_issued
FROM issued_books as ist
JOIN
employee as e
ON e.emp_id = ist.issued_emp_id
JOIN
branch as b
ON e.branch_id = b.branch_id
GROUP BY 1, 2
