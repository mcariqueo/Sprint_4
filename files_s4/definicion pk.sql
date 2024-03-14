# Sprint 4 : Creacion base de datos


ALTER TABLE sales.credit_cards
ADD CONSTRAINT pk_id PRIMARY KEY (id);

ALTER TABLE sales.products
ADD CONSTRAINT pk_id_products PRIMARY KEY (id);

ALTER TABLE sales.users_ca
ADD CONSTRAINT pk_id_users_ca PRIMARY KEY (id);

ALTER TABLE users_usa
ADD CONSTRAINT pk_id_users_usa PRIMARY KEY (id);

