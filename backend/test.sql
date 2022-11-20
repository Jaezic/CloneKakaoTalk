CREATE TABLE User_file (
    id int NOT NULL AUTO_INCREMENT,
    user_id varchar(30) NOT NULL,
    fieldname VARCHAR(256),
    originalname VARCHAR(256),
    encoding VARCHAR(16),
    mimetype VARCHAR(64),
    destination VARCHAR(256),
    filename VARCHAR(256),
    path VARCHAR(256),
    size int,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (id),
    FOREIGN KEY (user_id) REFERENCES User(ID) on delete cascade
);