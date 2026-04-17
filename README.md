# library-management-system-project
## This project demonstrates the implementation of a Library Management System using SQL. It includes creating and managing tables, performing CRUD operations, and executing advanced SQL queries. The goal is to showcase skills in database design, manipulation, and querying.


**Task 1. Create a New Book Record -- "978-1-60129-456-2', 'To Kill a Mockingbird', 'Classic', 6.00, 'yes', 'Harper Lee', 'J.B. Lippincott & Co.')"

```sql
insert into books(isbn,book_title,category,rental_price,status,author,publisher)
values ('978-1-60129-456-2', 'To Kill a Mockingbird', 'Classic', 6.00, 'yes', 'Harper Lee', 'J.B. Lippincott & Co.')

```

** -- Task 2: Update an Existing Member's Address
```sql
update members
set member_address = '125 main st'
where member_id='C101';
```

** --Task 3: Delete a Record from the Issued Status Table -- Objective: Delete the record with issued_id = 'IS131' from the issued_status table.
```sql
delete from issued_books
where issued_id='IS131'
```

** -- Task 4: Retrieve All Books Issued by a Specific Employee -- Objective: Select all books issued by the employee with emp_id = 'E101'.
```sql
select * from issued_books
where issued_emp_id='E101'

```

** -- Task 5: List Members Who Have Issued More Than One Book -- Objective: Use GROUP BY to find members who have issued more than one book.
```sql
select 
issued_emp_id,
count(issued_id) as total_book_issue
from issued_books
group by 1
having count(issued_id)>1;
```

** --Task 6: Create Summary Tables: Used CTAS to generate new tables based on query results - each book and total book_issued_cnt**
```sql
create table book_cnt
as
select 
b.isbn,
b.book_title,
count(ist.issued_id) as no_issued
from books as b
join 
issued_books as ist
on ist.issued_book_isbn = b.isbn
group by 1,2 ;

```
** -- Task 7. Retrieve All Books in a Specific Category:
```sql

select * from books
where category = 'Classic';

```

** -- Task 8: Find Total Rental Income by Category:
```sql '
select category ,

sum(rental_price) as total_price,
count(*)
from books 
group by category ;

```

** -- task 9 : List Members Who Registered in the Last 180 Days:
```sql
select * from members 
where reg_date >= CURRENT_DATE - INTERVAL '180 days'
```

** value inser 
```sql
insert into members (member_id,member_name,member_address,reg_date)
values 
('C120', 'sam', '145 main ste','2024-06-01'),
('C121', 'brijesh', '145 outer ste','2024-05-01')

```

** -- Task 10 : List Employees with Their Branch Manager's Name and their branch details:
```sql

select e.*,
e1.emp_name as manager ,
b.manager_id
from employee as e
join 
branch as b
on b.branch_id = e.branch_id
join 
employee as e1
on b.manager_id = e1.emp_id

```

** -- Task 11 : create a table of books with rental price above a certain thresold 7 USD ? 
```sql
create table price_greter_than_seven
as 
select * from books
where rental_price  > 7 

select * from price_greter_than_seven

```

** -- Task 12 : retrieve the list of books not yet return 
```sql

select 
distinct ist.issued_book_name
from issued_books as ist
left  join
return_status as st
on ist.issued_id = st.issued_id
where st.return_id is null;

select * from return_status

ALTER TABLE return_status
ADD COLUMN book_quality VARCHAR(15) DEFAULT('good');

update return_status
set book_quality ='Damaged'
where issued_id in
	('IS112','IS114','IS120') ;

```

### advanced query 

### Task 13: Identify Members with Overdue BooksWrite a query to identify members who have overdue books (assume a 30-day return period). Display the member's_id,member's name, book title, issue date, and days overdue.

```sql
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

```

###  ask 14: Branch Performance ReportCreate a query that generates a performance report for each branch, showing the number of books issued, the number of books returned, and the total revenue generated from book rentals.

```sql
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
```

### ask 15: CTAS: Create a Table of Active MembersUse the CREATE TABLE AS (CTAS) statement to create a new table active_members containing members who have issued at leastone book in the last 2 months

```sql
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

```

###  Task 16: Find Employees with the Most Book Issues ProcessedWrite a query to find the top 3 employees who have processed the most book issues. Display the employee name, number of books processed, and their branch.
```sql

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

```

**  end of the peoject ** 
