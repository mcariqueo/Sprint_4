# Sprint 4 - Nivel 1

### Esquemas

Descàrrega els arxius CSV, estudia'ls i dissenya una base de dades amb un esquema d'estrella que contingui, almenys 4 taules.

Realizaré los siguientes pasos:
1. Crear la base de datos 'trade' e importar los archivos .'.csv' a travès del "table import wizard":

![](files_s4/S4a.png)


2. Dado que las tres tablas de users_ca/users_uk y users_usa son iguales, creo una nueva tabla. Utilizo esta opcion para poder unirlas sin utilizar UNION , ni cambiar el formato de cada una de los compos.

![](files_s4/S4b.png)

### Definicion de relacdion , PK, FK e INDEX
- Creo el index para la tabla users, que será id. De esta manera pouedo crear las clavesz primerarias:

![](files_s4/S4c.png)

- Ahora creo las claves foraing para cada tabla:

![](files_s4/S4d.png)
A continuacion muestro el resto de comandos utilizados:

```sql
-- Creación de la base de datos:

-- Claves primarias:
ALTER TABLE companies ADD PRIMARY KEY (company_id);
ALTER TABLE credit_cards ADD PRIMARY KEY (id);
ALTER TABLE products ADD PRIMARY KEY (id);
ALTER TABLE transactions ADD PRIMARY KEY (id);
ALTER TABLE users ADD PRIMARY KEY (id);
ALTER TABLE users_ca ADD PRIMARY KEY (id);
ALTER TABLE users_uk ADD PRIMARY KEY (id);
ALTER TABLE users_usa ADD PRIMARY KEY (id);

-- Genero los index:
SHOW INDEX FROM transactions;
ALTER TABLE transactions ADD INDEX idx_card_id (card_id);
ALTER TABLE transactions ADD INDEX idx_businnes (business_id);
ALTER TABLE transactions ADD INDEX idx_products_ids (product_ids);
ALTER TABLE transactions ADD INDEX idx_user_id (user_id);

SHOW INDEX FROM companies; -- no necesito más índices
SHOW INDEX FROM credit_cards;
ALTER TABLE credit_cards ADD INDEX idx_user_id (user_id);
SHOW INDEX FROM products; -- no necesito más índices
SHOW INDEX FROM users; -- no necesito más índices

-- Ahora creo las claves foráneas para cada tabla:
ALTER TABLE transactions ADD CONSTRAINT fk_c__id FOREIGN KEY (business_id) REFERENCES companies(company_id);
ALTER TABLE credit_cards ADD CONSTRAINT fk_cc_user_id FOREIGN KEY (user_id) REFERENCES users(id);
ALTER TABLE transactions ADD CONSTRAINT fk_t_card_id FOREIGN KEY (card_id) REFERENCES credit_cards(id);
ALTER TABLE transactions ADD CONSTRAINT fk_t_prdid FOREIGN KEY (product_ids) REFERENCES products(id);
```






## Exercici 2
Mostra la mitjana de la suma de transaccions per IBAN de les targetes de crèdit en la companyia Donec Ltd. utilitzant almenys 2 taules.

![](files_s4/S4N1E2.png)



# Sprint 4 - Nivel 2

Crea una nova taula que reflecteixi l'estat de les targetes de crèdit basat en si les últimes tres transaccions van ser declinades.

En este caso, utilizo un condicional para realizar esta tabla. El `CASE`permite realizar la condición y con ello identificar las tarjetas como ***activas*** o ***inactivas*** de acuerdo a si la suma de *declined* es es 3 (***inactiva***) o menor (***activa***)

Utilizo `ROW_NUMBER`para identificar en orden el *timestamp*, es decir, las fechas de las transacciones.  Ademas indico los comando de las relacion con transactions.

![](files_s4/S4N2E1c.png)


El equema de relacion con las otra tablas es: 

![](files_s4/S4N3E1a.png)


## Exercici 1
Quantes targetes estan actives?

![](files_s4/S4N2E1b.png)

- De acuerdo a esta consulta, todas las tarjetas estan activas. Es decir, ninguna tiene tres rechazos en las ultimas transacciones.


# Sprint 4 - Nivel 3

Crea una taula amb la qual puguem unir les dades del nou arxiu ***products.csv*** amb la base de dades creada, tenint en compte que des de transaction tens _**product_ids**_. Genera la següent consulta: 

## Exercici 1

Necessitem conèixer el nombre de vegades que s'ha venut cada producte.

![](files_s4/S4N3E1.png)

En la siguiente tabla explico algunos puntos del código utilizado: 
| Componente         |Descripción                                                                             |
|--------------------|----------------------------------------------------------------------------------------|
| `SUBSTRING_INDEX()`| Divide la cadena de **product_id** basada en el índice.                                |
| `CAST()`           | La utilizo para para convertir el resultado en un entero sin igno.                     |
| `WHERE`            | Asegurar que solo se seleccionen productos que estén dentro de la lista de productos   |
| `CROSS JOIN`       | Genera identificadores de la tabla `products` y combinarla con la tabla `transactions` |

