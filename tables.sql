CREATE TABLE orders(
	order_id int  PRIMARY KEY NOT NULL,
	order_date date NOT NULL,
	order_time time NOT NULL
)

CREATE TABLE order_details(
	order_details_id int  PRIMARY KEY NOT NULL,
	order_id INT NOT NULL,
	pizza_id text NOT NULL,
	quantity int NOT NULL,
	FOREIGN KEY(order_id) REFERENCES orders(order_id)
)


CREATE TABLE pizza_types(
	pizza_type_id VARCHAR(50) PRIMARY KEY,
	name VARCHAR(40),
	category VARCHAR(50),
	ingredients VARCHAR(255)
)


CREATE TABLE pizzas(
	pizza_id text PRIMARY KEY NOT NULL,
	pizza_type_id VARCHAR(25),
	size VARCHAR(20),
	price FLOAT,
	FOREIGN KEY (pizza_id) REFERENCES pizza_types(pizza_type_id)
);

ALTER TABLE pizza_types
ALTER COLUMN pizza_type_id TYPE VARCHAR(255) 

ALTER TABLE pizza_types
ALTER COLUMN name TYPE VARCHAR(150)

ALTER TABLE pizza_types
ALTER COLUMN ingredients TYPE TEXT 