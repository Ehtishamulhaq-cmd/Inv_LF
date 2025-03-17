USE inventory_db;

CREATE TABLE users (
    id INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(50) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Insert a sample user (password is "admin" hashed using MD5)
INSERT INTO users (username, password) VALUES ('admin', MD5('admin'));

ALTER TABLE users ADD COLUMN role ENUM('admin', 'user') NOT NULL DEFAULT 'user';

-- Insert an Admin User
INSERT INTO users (username, password, role) VALUES ('admin', MD5('admin'), 'admin');

-- Insert a Regular User
INSERT INTO users (username, password, role) VALUES ('employee', MD5('employee'), 'user');
