/* Datubāzes shēmas un biznesa loģikas intepretēšana ir kā daļa no uzdevuma.
Ieteicams iesniegt visus vaicājumus, kurus uzrakstat, pat ja kāds no tiem nestrādā vai neatgriež pareizu rezultātu.

1. Atlasīt visus neapmaksātos (ieskaitot daļēji apmaksātus) rēķinus 2023. gadā. Iegūtos ierakstus sakārtot pēc rēķina apmaksas termiņa dilstošā secībā.
*/
SELECT * FROM invoices
WHERE 
	payment_status IN ('paid', 'partially paid')
    AND Year(due_date)=2023
ORDER BY due_date DESC;
/*
2. Atlasīt visus klientus, kuri ir veikuši pirkumus starp 2021. gada 3. janvāri un 2022. gada 15. martu un kuru vārds sākas ar 'A'.

*/
SELECT customers.customer_id 
FROM orders
JOIN invoices ON invoices.order_id = orders.order_id
JOIN customers ON orders.customer_id = customers.customer_id
WHERE orders.order_date >= '2021-01-3' 
	AND orders.order_date <= '2021-03-15'
    AND customers.first_name LIKE "A%";
/*
3. Atlasīt visu darbinieku vārdus, uzvārdus un amatu, šī darbinieka tiešā priekšnieka vārdu un uzvārdu, kā arī vērtību, vai darbiniekam ir priekšnieks - ja ir, tad izvadīt 'Boss', citādi izvadīt NULL. 
SELECT 	D.employees.first_name AS name1, 
		M.employees.first_name As name2
FROM employees D, employees M
*/

/* strādā, bet noteikti var labāk */
SELECT darbinieks_vards,
		darbinieks_uzvards,
        prieksnieka_vards,
		prieksnieka_uzvards,
        has_boss,
        title
	FROM (SELECT  
        D.employee_id,
        D.first_name AS darbinieks_vards,
		D.last_name AS darbinieks_uzvards,
        M.first_name AS prieksnieka_vards,
		M.last_name AS prieksnieka_uzvards,
		CASE
        	WHEN D.manager_id IS NULL 
            THEN NULL
            WHEN D.manager_id IS NOT NULL 
            THEN 'Boss'
        END AS has_boss
FROM employees D, employees M 
WHERE 	D.manager_id = M.employee_id OR 
        (D.manager_id IS NULL AND D.employee_id = M.employee_id)) AS names
JOIN jobs ON jobs.job_id =names.employee_id
 
/*
4. Atlasīt visus preču piegādātajus, kuru preces ir pasūtītas no veikala vismaz 3 reizes.
*/
SELECT suppliers.company_name AS piegādātājs, 
		Count(*) AS pasūtīto_preču_skaits 
FROM products
JOIN order_details ON products.product_id = order_details.product_id
JOIN suppliers ON suppliers.supplier_id = products.supplier_id
GROUP BY products.supplier_id
HAVING COUNT(*)>2
/*
5. Atrast pasūtījumu ierakstus, pasūtījumu summas un lielāko piešķirto atlaidi precei no šī pasūtījuma izteiktu procentos. Atlasīt tikai to pasūtījumu, kuram ir lielākā pasūtījuma summa, ņemot vērā preču atlaides.

*/

 
-- noteikti ir labāka metode kā atlasīt nekā sanāca

SELECT order_id,
	SUM(summa_apmaksai) AS total
FROM(SELECT *,
	ROUND((pas_sum-pas_sum*atlaide/100),2) AS summa_apmaksai
FROM (SELECT *, 
		ROUND(unit_price*quantity) AS pas_sum,
        CASE
        	WHEN discount_ratio IS NULL
            THEN 0
            WHEN discount_ratio IS NOT NULL
            THEN ROUND((unit_price * quantity* discount_ratio)
            				/(unit_price * quantity)*100,2)
      	END AS atlaide
FROM order_details) AS pasutijums) AS total
GROUP BY order_id
ORDER BY total DESC
LIMIT 1
/*
6. Atlasīt klienta vārdu, uzvārdu, rēķinos kopējo neapmaksāto summu un parādnieka pazīmi - 'Y', ja eksistē kaut viens neapmaksāts vai daļēji apmaksāts rēķins ar nokavētu apmaksas termiņu (termiņš vecāks par šodienu), citādi 'N'.
*/
SELECT first_name,
		last_name,
        subtotal_amount,
        (subtotal_amount-SUM(amount)) AS unpaid_amount,
        CASE
        	WHEN subtotal_amount-SUM(amount)>0 
            	OR SUM(paied_late)>0
            THEN 'Y'
            ELSE 'N'
        END AS piezīme
FROM(SELECT 	invoices.invoice_id,
		customers.first_name ,
		customers.last_name ,
        payments.amount,
     	invoices.subtotal_amount,
	CASE
    	WHEN payments.pay_date>invoices.due_date
        THEN 1
        ELSE 0
    END AS paied_late   
FROM invoices
JOIN orders ON orders.order_id = invoices.order_id
JOIN customers ON customers.customer_id = orders.customer_id
JOIN payments ON payments.invoice_id = invoices.invoice_id) AS paid
GROUP BY first_name,last_name,subtotal_amount

