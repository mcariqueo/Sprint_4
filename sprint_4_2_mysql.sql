# Sprint 4 - Nivel 1
## Exercici 1

/*Realitza una subconsulta que mostri tots els usuaris amb més de 30 transaccions utilitzant almenys 2 taules.*/
SELECT 		users.*, COUNT(transactions.id) AS num_transactions
FROM 		users
JOIN 		transactions on transactions.user_id = users.id
GROUP BY 	users.id, users.name, users.surname, users.phone, users.email, 
			users.birth_date, users.country, users.city, users.postal_code, users.address
HAVING 		num_transactions > 30;
## Exercici 2
/* Mostra la mitjana de la suma de transaccions per IBAN de les targetes de crèdit en la companyia Donec Ltd. utilitzant almenys 2 taules.*/
SELECT * FROM companies WHERE companies.company_name = "Donec Ltd";
SELECT * FROM transactions WHERE business_id = "b-2242";
SELECT * FROM credit_cards WHERE company_id = "b-2242";

SELECT companies.company_name, AVG(transactions.amount) AS media_amount
FROM transactions
JOIN credit_cards 	ON transactions.card_id = credit_cards.id
JOIN companies		ON transactions.business_id = companies.company_id
WHERE companies.company_name = "Donec Ltd"
GROUP BY companies.company_name;

# Sprint 4 - Nivel 2
## Exercici 1


CREATE TABLE card_status AS
SELECT  card_id, 
		CASE WHEN SUM(declined) = 3 THEN "Inactiva" 
        ELSE "Activa" END AS estado
FROM 	(SELECT	card_id, declined,
				ROW_NUMBER() OVER (PARTITION BY card_id ORDER BY timestamp DESC) AS row_num
		FROM	transactions) AS ranked_transactions
WHERE	row_num <= 3
GROUP BY	card_id;

/* Quantes targetes estan actives?*/
SELECT count(card_id) FROM card_status WHERE estado ="Activa";


## Exercici 2
/* Necessitem conèixer el nombre de vegades que s'ha venut cada producte.*/

# creare una tabla del tipo 
	CREATE TEMPORARY TABLE temp_numeros (n INT);
	INSERT INTO temp_numeros (n)
	VALUES (1), (2), (3), (4), (5), (6), (7), (8), (9), (10);
/* buscar otra manera de crear esta tabla*/
SELECT total_productos.product_id, total_productos.num_compras, products.product_name
FROM 		(SELECT		CAST(SUBSTRING_INDEX(SUBSTRING_INDEX(product_ids, ',', temp_numeros.n), ',', -1) AS unsigned) AS product_id,
			COUNT(id) AS num_compras
			FROM		transactions
			JOIN		temp_numeros ON temp_numeros.n <= LENGTH(product_ids) - LENGTH(REPLACE(product_ids, ',', '')) + 1
			GROUP BY	product_id) AS total_productos
JOIN 		products ON total_productos.product_id = products.id;



