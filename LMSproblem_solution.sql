select * from books
select * from members 
select * from issued_books

-- Task 1. Create a New Book Record -- "978-1-60129-456-2', 'To Kill a Mockingbird', 'Classic', 6.00, 'yes', 'Harper Lee', 'J.B. Lippincott & Co.')"

insert into books(isbn,book_title,category,rental_price,status,author,publisher)
values ('978-1-60129-456-2', 'To Kill a Mockingbird', 'Classic', 6.00, 'yes', 'Harper Lee', 'J.B. Lippincott & Co.')

-- Task 2: Update an Existing Member's Address

update members
set member_address = '125 main st'
where member_id='C101';

--Task 3: Delete a Record from the Issued Status Table -- Objective: Delete the record with issued_id = 'IS131' from the issued_status table.
delete from issued_books
where issued_id='IS131'


-- Task 4: Retrieve All Books Issued by a Specific Employee -- Objective: Select all books issued by the employee with emp_id = 'E101'.
select * from issued_books
where issued_emp_id='E101'


-- Task 5: List Members Who Have Issued More Than One Book -- Objective: Use GROUP BY to find members who have issued more than one book.
select 
issued_emp_id,
count(issued_id) as total_book_issue
from issued_books
group by 1
having count(issued_id)>1;

--Task 6: Create Summary Tables: Used CTAS to generate new tables based on query results - each book and total book_issued_cnt**

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
group by 1,2 ;  --- your database has create one table 'book_cnt' becouse you use cte


-- Task 7. Retrieve All Books in a Specific Category:

select * from books
where category = 'Classic';


-- Task 8: Find Total Rental Income by Category:

select category ,

sum(rental_price) as total_price,
count(*)
from books 
group by category ;


-- task 9 : List Members Who Registered in the Last 180 Days:
select * from members 
where reg_date >= CURRENT_DATE - INTERVAL '180 days'


insert into members (member_id,member_name,member_address,reg_date)
values 
('C120', 'sam', '145 main ste','2024-06-01'),
('C121', 'brijesh', '145 outer ste','2024-05-01')

-- Task 10 : List Employees with Their Branch Manager's Name and their branch details:
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

-- Task 11 : create a table of books with rental price above a certain thresold 7 USD ? 
create table price_greter_than_seven
as 
select * from books
where rental_price  > 7 

select * from price_greter_than_seven

-- Task 12 : retrieve the list of books not yet return 

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