CREATE DATABASE inventory_db;
USE inventory_db;

-- Table for storing product details
CREATE TABLE products (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    description TEXT,
    quantity INT NOT NULL DEFAULT 0,
    price DECIMAL(10,2) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Table for tracking stock transactions
CREATE TABLE stock_movements (
    id INT AUTO_INCREMENT PRIMARY KEY,
    product_id INT,
    type ENUM('IN', 'OUT') NOT NULL,
    quantity INT NOT NULL,
    movement_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (product_id) REFERENCES products(id) ON DELETE CASCADE
);
CREATE TABLE warehouses (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    location VARCHAR(255) NOT NULL
);

-- Insert some sample warehouses
INSERT INTO warehouses (name, location) VALUES ('Main Warehouse', 'New York');
INSERT INTO warehouses (name, location) VALUES ('Backup Warehouse', 'Los Angeles');
CREATE TABLE warehouse_stock (
    id INT AUTO_INCREMENT PRIMARY KEY,
    product_id INT NOT NULL,
    warehouse_id INT NOT NULL,
    quantity INT NOT NULL,
    FOREIGN KEY (product_id) REFERENCES products(id),
    FOREIGN KEY (warehouse_id) REFERENCES warehouses(id)
);

-- Sample stock for products in different warehouses
INSERT INTO warehouse_stock (product_id, warehouse_id, quantity) VALUES (1, 1, 50);
INSERT INTO warehouse_stock (product_id, warehouse_id, quantity) VALUES (1, 2, 20);
