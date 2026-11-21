CREATE TABLE phones (
    id INT PRIMARY KEY,
    number VARCHAR(15),
    carrier VARCHAR(50)
);

INSERT INTO phones (id, number, carrier) VALUES
(1, '088123456', 'TNM'),
(2, '088123457', 'AIRTEL'),
(3, '088123458', 'TNM'),
(4, '088123459', 'AIRTEL');

UPDATE phones SET carrier = 'TNM' WHERE id = 2;
DELETE FROM phones WHERE id = 3;