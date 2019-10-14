DROP DATABASE IF EXISTS avonriver;
CREATE DATABASE avonriver;

use avonriver;

CREATE TABLE riverdata (
    date        datetime,
    height    float
);

DROP USER IF EXISTS 'avon'@'localhost';
CREATE USER 'avon'@'localhost' identified by 'river';
GRANT ALL PRIVILEGES ON avonriver.* TO 'avon'@'localhost';
FLUSH PRIVILEGES;
