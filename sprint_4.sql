-- Creación de la base de datos:
CREATE DATABASE IF NOT EXISTS trade;
-- Importo todas las tablas a traves del wizard
-- Cambio el formato de todos los campos a través de la opcion ALTER TABLE de Workbench
-- Creo una tabla unificada de users
CREATE TABLE users AS
SELECT * FROM ( SELECT * FROM users_uk UNION
				SELECT * FROM users_ca UNION
				SELECT * FROM users_usa ) AS combinadas;
SELECT * FROM users;
-- Claves primarias:
ALTER TABLE companies		ADD PRIMARY KEY (company_id);
ALTER TABLE credit_cards	ADD PRIMARY KEY (id);
ALTER TABLE products		ADD PRIMARY KEY (id);
ALTER TABLE transactions	ADD PRIMARY KEY (id);
ALTER TABLE users			ADD PRIMARY KEY (id);
ALTER TABLE users_ca		ADD PRIMARY KEY (id);
ALTER TABLE users_uk		ADD PRIMARY KEY (id);
ALTER TABLE users_usa		ADD PRIMARY KEY (id);

-- Genero los index:
SHOW INDEX FROM transactions;
	ALTER TABLE transactions ADD INDEX idx_card_id (card_id);
	ALTER TABLE transactions ADD INDEX idx_businnes (business_id);
	ALTER TABLE transactions ADD INDEX idx_products_ids (product_ids);
	ALTER TABLE transactions ADD INDEX idx_user_id (user_id);

SHOW INDEX FROM companies; 	# no necesito mas index
SHOW INDEX FROM credit_cards;
	ALTER TABLE credit_cards ADD INDEX idx_user_id (user_id);
SHOW INDEX FROM products; 	# no necesito mas index
SHOW INDEX FROM users; 		# no necesito mas index

-- Ahora creo las claves foraing para cada tabla:
ALTER TABLE transactions	ADD CONSTRAINT fk_c__id			FOREIGN KEY (business_id) 	REFERENCES companies(company_id);
ALTER TABLE credit_cards	ADD CONSTRAINT fk_cc_user_id	FOREIGN KEY (user_id) 		REFERENCES users(id);
ALTER TABLE transactions	ADD CONSTRAINT fk_t_card_id		FOREIGN KEY (card_id) 		REFERENCES credit_cards(id);
ALTER TABLE transactions	ADD CONSTRAINT fk_t_prdid		FOREIGN KEY (product_ids)	REFERENCES products(id);

CREATE TABLE transaction_products (
    transaction_id 	VARCHAR(255),
    product_id 		VARCHAR(255),
    FOREIGN KEY (transaction_id) REFERENCES transactions(id),
    FOREIGN KEY (product_id) REFERENCES products(id)
);



## Exercici 1
/*Realitza una subconsulta que mostri tots els usuaris amb més de 30 transaccions utilitzant almenys 2 taules.*/
SELECT users.*,
	COUNT(transactions.id) AS num_transactions
FROM users
	JOIN transactions on transactions.user_id = users.id
GROUP BY users.id, users.name,	users.surname,	users.phone,	users.email,	users.birth_date,	users.country,	users.city,	users.postal_code,
	users.address
HAVING num_transactions > 30;

## Exercici 2
/* Mostra la mitjana de la suma de transaccions per IBAN de les targetes de crèdit en la companyia Donec Ltd. utilitzant almenys 2 taules.*/
SELECT c.company_name, AVG(t.amount) AS media_amount FROM transactions t
JOIN  credit_cards cc 	ON t.card_id = cc.id
JOIN companies c 		ON t.business_id = c.company_id
WHERE c.company_name = "Donec Ltd"
GROUP BY c.company_name;




# Sprint 4 - Nivel 2
## Exercici 1

CREATE TABLE card_status AS
SELECT 	card_id, 	CASE WHEN SUM(declined) = 3 THEN "Inactiva"
					ELSE "Activa" END AS estado
FROM	(SELECT 	card_id, declined,
					ROW_NUMBER() OVER (PARTITION BY card_id	ORDER BY timestamp DESC) AS row_num
		FROM	transactions) AS ranked_transactions
WHERE row_num <= 3 GROUP BY card_id;
ALTER TABLE card_status  ADD INDEX idx_card_id (card_id);
ALTER TABLE transactions	ADD CONSTRAINT fk_card_id	FOREIGN KEY (card_id)	REFERENCES card_status(card_id);


/* Quantes targetes estan actives?*/
SELECT count(card_id) FROM card_status WHERE estado = "Activa";


# Sprint 4 - Nivel 2
## Exercici 1
/* Necessitem conèixer el nombre de vegades que s'ha venut cada producte.*/
SELECT products.id, products.product_name, tabla.product, tabla.count_product
FROM products
JOIN (SELECT CAST(SUBSTRING_INDEX(
					SUBSTRING_INDEX(transactions.product_ids, ',', product_id),',',-1) 
                    AS UNSIGNED ) AS product, COUNT(*) AS count_product
		FROM transactions CROSS JOIN (SELECT id AS product_id	FROM products) AS numbers 
		WHERE product_id <= (LENGTH(transactions.product_ids) - LENGTH(REPLACE(transactions.product_ids, ',', '')) + 1)
		GROUP BY product ORDER BY product ) AS tabla ON tabla.product = products.id;
        
        
        
        
        