CREATE TABLE Product_table (Product_code VARCHAR2 (50) PRIMARY KEY,
                        price VARCHAR2 (50),
                        categor VARCHAR2 (10)
                       )
                       
SELECT * FROM Product_table FOR UPDATE 


SELECT * FROM product_t t FOR UPDATE

ALTER TABLE product_t t
ADD (
    Qty NUMBER,
    Price NUMBER,
    Amount NUMBER,
    ship_city VARCHAR2(50),
    ship_state VARCHAR2(50),
    ship_postal_code VARCHAR2(20),
    B2B VARCHAR2(10)
);


SELECT * FROM product_t t FOR UPDATE

SELECT date_ord
FROM product_t t
WHERE TO_DATE(date_ord DEFAULT NULL ON CONVERSION ERROR, 'YYYYMMDD') IS NULL;

SELECT 
    CASE 
        WHEN REGEXP_LIKE(date_ord, '^[0-9]{8}$') 
        THEN TO_DATE(date_ord, 'YYYYMMDD')
        ELSE NULL
    END AS new_date
FROM product_t t;


--1 Identify the top 5 channels with the highest number of orders. Display the channel name and the corresponding product count.

Select Channel , count(*)
from product_t t
GROUP BY Channel
ORDER BY  Channel DESC
FETCH FIRST 5 ROWS ONLY;
__________________________________________________________


-- 2 Group the ordered products based on the predefined age groups and determine which age group places the most orders. Display the results in descending order by order count.
 With  Select Case
           When age>50 then "Senior"
           when age>30 and age<40 then "Adult"
           When age<30 then "Teenager"
           end as  t ,     count(*)


    from product_t t
     Group by 
       Case
           When age>50 then "Senior"
           when age>30 and age<40 then "Adult"
           When age<30 then "Teenager"
           end 
   order by t  desc
           


____________________________________________________________


--3 Based on the age group categories defined above, calculate and display the total order amount for the Teenager and Adult categories. 
 With table_2 as( Select Case
           When age>50 then "Senior"
           when age>30 and age<40 then "Adult"
           When age<30 then "Teenager"
           end as  t ,     count(*),sum(Amount) as Amount


    FROM product_t t
     Group by 
       Case
           When age>50 then "Senior"
           when age>30 and age<40 then "Adult"
           When age<30 then "Teenager"
           end 
   order by t desc)



   Select  t, sum(Amount)
    from table_2
    where t in ("Teenager","Adult")


--------------------------------------------------



---4 For each customer, display the following information:

--The date of their most recent order
--The name of the product ordered
--The product category
--The number of days that have passed from the order date until today

select MAX(TO_DATE(date_ord,'YYYYMMDD')) as MAX_DATE,current_date- MAX(TO_DATE(date_ord,'YYYYMMDD')) as Difference
       product_code,
       prodct_category
from product_t
group by prodct_code, prodct_category


____________________________________

--5 Identify the customer who ordered the product with the highest amount. Display the following details:

--Customer ID
--Order date
--Gender

SELECT customer_id,
       TO_DATE(date_ord,'YYYYMMDD') AS order_date,
       gender,
       Amount,
       prodct_code
FROM product_t
WHERE Amount = (SELECT MAX(Amount) FROM product_t);



________________________________________

--6 Categorize order counts according to product size and display the results.




select prodct_size, sum(Qty)
FROM product_t
group by prodct_size



--7 Determine the top 10 cities with the highest number of deliveries and display the number of delivered products for each city.
select ship_city ,Sum(Qty)
from product_t
group by ship_city
order by Sum(Qty) desc
fetch first 10 rows only;




--8 Calculate the average order amount for each customer. The average amount should be rounded to the nearest whole number and displayed without decimal places.

--Additionally, customer IDs must be displayed in reverse order (with their characters reversed)

SELECT 
    REVERSE(customer_id),
    TRUNC(AVG(Amount))
FROM product_t t
GROUP BY customer_id;




--9 For each customer, display the order placed immediately before their most recent order. Include the following information:

--Previous order date
--Product name
--Product price
--Product size
--Product category


SELECT 
    customer_id,
    TO_DATE(Date,'YYYYMMDD') AS order_date,
    product_code,
    Amount AS price,
    prodct_size,
    prodct_category
FROM (
  select 
    customer_id,
    TO_DATE(Date,'YYYYMMDD') AS order_date,
    product_code,
    Amount AS price,
    Prodct_size,
    Prodct_category
    ROW_NUMBER() OVER (
            PARTITION BY customer_id 
            ORDER BY TO_DATE(date_ord,'YYYYMMDD') DESC
        ) AS rn
    FROM product_t t
)
WHERE rn = 2;
 



COMMIT 


                        
                        
                        
                        
                        
