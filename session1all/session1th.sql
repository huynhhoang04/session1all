CREATE TABLE category (
    category_id SERIAL PRIMARY KEY,
    category_name VARCHAR(100) NOT NULL,
    description TEXT
);

CREATE TABLE book (
    book_id SERIAL PRIMARY KEY,
    title VARCHAR(255) NOT NULL,
    publish_year INT,
    stock INT NOT NULL,
    category_id INT REFERENCES category(category_id)
);

CREATE TABLE author (
    author_id SERIAL PRIMARY KEY,
    author_name VARCHAR(150) NOT NULL,
    biography TEXT
);

CREATE TABLE book_author (
    id SERIAL PRIMARY KEY,
    book_id INT REFERENCES book(book_id),
    author_id INT REFERENCES author(author_id)
);

CREATE TABLE member (
    member_id SERIAL PRIMARY KEY,
    full_name VARCHAR(150),
    dob DATE,
    address TEXT,
    phone VARCHAR(20),
    email VARCHAR(100) UNIQUE,
    register_date DATE DEFAULT CURRENT_DATE,
    status VARCHAR(20)
);

CREATE TABLE borrow (
    borrow_id SERIAL PRIMARY KEY,
    member_id INT REFERENCES member(member_id),
    borrow_date DATE NOT NULL,
    due_date DATE NOT NULL,
    return_date DATE,
    fine_amount NUMERIC(10,2) DEFAULT 0
);

CREATE TABLE borrow_detail (
    id SERIAL PRIMARY KEY,
    borrow_id INT REFERENCES borrow(borrow_id),
    book_id INT REFERENCES book(book_id),
    quantity INT NOT NULL
);
SELECT b.title, c.category_name
FROM book b
JOIN category c ON b.category_id = c.category_id;
SELECT b.title, a.author_name
FROM book b
JOIN book_author ba ON b.book_id = ba.book_id
JOIN author a ON ba.author_id = a.author_id;
SELECT m.full_name, SUM(bd.quantity) AS total_books
FROM member m
JOIN borrow bo ON m.member_id = bo.member_id
JOIN borrow_detail bd ON bo.borrow_id = bd.borrow_id
GROUP BY m.full_name;
SELECT m.full_name, SUM(bd.quantity) AS total_books
FROM member m
JOIN borrow bo ON m.member_id = bo.member_id
JOIN borrow_detail bd ON bo.borrow_id = bd.borrow_id
GROUP BY m.full_name;
SELECT borrow_id, member_id, due_date
FROM borrow
WHERE return_date IS NULL 
  AND due_date < CURRENT_DATE;
SELECT b.title, SUM(bd.quantity) AS total_borrowed
FROM book b
JOIN borrow_detail bd ON b.book_id = bd.book_id
GROUP BY b.title
ORDER BY total_borrowed DESC
LIMIT 5;
