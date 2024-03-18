# Sprint 4 - Nivel 1
## Exercici 1

Realitza una subconsulta que mostri tots els usuaris amb més de 30 transaccions utilitzant almenys 2 taules.

- Para realizar esta consulta, utilizo las tablas **transactions** y **users** que previamente cree mediante la union de las tres tablas usuarios (*users_ca*, u*sers_uk*, *users_usa*)
- El `HAVING`lo utilizo para poner lacondición del numero de transacciones. 

![](files_s4/S4N1E1.png)

## Exercici 2
Mostra la mitjana de la suma de transaccions per IBAN de les targetes de crèdit en la companyia Donec Ltd. utilitzant almenys 2 taules.

![](files_s4/S4N1E2.png)

# Sprint 4 - Nivel 2

Crea una nova taula que reflecteixi l'estat de les targetes de crèdit basat en si les últimes tres transaccions van ser declinades.

En este caso, utilizo un condicional para realizar esta tabla. El `CASE`permite realizar la condición y con ello identificar las tarjetas como ***activas*** o ***inactivas*** de acuerdo a si la suma de *declined* es es 3 (***inactiva***) o menor (***activa***)

Utilizo `ROW_NUMBER`para identificar en orden el *timestamp*, es decir, las fechas de las transacciones. 

![](files_s4/S4N2E1.png)

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

