-- Создание базы данных
USE MyLibrary;
GO
DROP TABLE IF EXISTS Users;
DROP TABLE IF EXISTS Books;
DROP TABLE IF EXISTS Authors;
DROP TABLE IF EXISTS Categories;
DROP TABLE IF EXISTS Roles;
GO
-- Создание таблицы Categories
CREATE TABLE Categories (
    Id INT PRIMARY KEY IDENTITY(1,1),
    Name NVARCHAR(100) NOT NULL
);
GO

-- Создание таблицы Authors
CREATE TABLE Authors (
    Id INT PRIMARY KEY IDENTITY(1,1),
    FirstName NVARCHAR(50) NOT NULL,
    LastName NVARCHAR(50) NOT NULL,
    BirthDate DATE
);
GO

-- Создание таблицы Books 
CREATE TABLE Books (
    Id INT PRIMARY KEY IDENTITY(1,1),
    Title NVARCHAR(200) NOT NULL,
    Author NVARCHAR(100) NOT NULL,
    YearPublished INT,
    CategoryId INT NOT NULL,
    AuthorId INT NULL, 
    CONSTRAINT FK_Books_Categories FOREIGN KEY (CategoryId) REFERENCES Categories(Id),
    CONSTRAINT FK_Books_Authors FOREIGN KEY (AuthorId) REFERENCES Authors(Id)
);
GO

-- Создание таблицы Roles
CREATE TABLE Roles (
    Id INT PRIMARY KEY IDENTITY(1,1),
    RoleName NVARCHAR(50) NOT NULL
);
GO

-- Создание таблицы Users
CREATE TABLE Users (
    Id INT PRIMARY KEY IDENTITY(1,1),
    Username NVARCHAR(50) NOT NULL UNIQUE,
    Password NVARCHAR(100) NOT NULL,
    Email NVARCHAR(100),
    RoleId INT NOT NULL,
    CONSTRAINT FK_Users_Roles FOREIGN KEY (RoleId) REFERENCES Roles(Id)
);
GO

-- Заполнение таблицы Categories данными
INSERT INTO Categories (Name) VALUES 
('Художественная литература'),
('Научная литература'),
('Техническая литература'),
('Детская литература'),
('Фантастика');
GO

-- Заполнение таблицы Authors данными
INSERT INTO Authors (FirstName, LastName, BirthDate) VALUES 
('Лев', 'Толстой', '1828-09-09'),
('Федор', 'Достоевский', '1821-11-11'),
('Александр', 'Пушкин', '1799-06-06'),
('Айзек', 'Азимов', '1920-01-02');
GO

-- Заполнение таблицы Books данными 
INSERT INTO Books (Title, Author, YearPublished, CategoryId) VALUES 
('Война и мир', 'Лев Толстой', 1869, 1),
('Преступление и наказание', 'Федор Достоевский', 1866, 1),
('Евгений Онегин', 'Александр Пушкин', 1833, 1),
('Я, робот', 'Айзек Азимов', 1950, 5),
('Анна Каренина', 'Лев Толстой', 1877, 1);
GO

-- Теперь обновляем AuthorId в таблице Books
UPDATE Books SET AuthorId = 1 WHERE Author LIKE '%Толстой%';
UPDATE Books SET AuthorId = 2 WHERE Author LIKE '%Достоевский%';
UPDATE Books SET AuthorId = 3 WHERE Author LIKE '%Пушкин%';
UPDATE Books SET AuthorId = 4 WHERE Author LIKE '%Азимов%';
GO

-- Заполнение таблицы Roles данными
INSERT INTO Roles (RoleName) VALUES 
('Администратор'),
('Библиотекарь'),
('Читатель');
GO

-- Заполнение таблицы Users данными
INSERT INTO Users (Username, Password, Email, RoleId) VALUES 
('admin', 'admin123', 'admin@library.ru', 1),
('librarian', 'lib123', 'librarian@library.ru', 2),
('reader1', 'read123', 'reader1@mail.ru', 3),
('ivanov', 'pass123', 'ivanov@gmail.com', 3);
GO

-- Делаем AuthorId обязательным после заполнения
ALTER TABLE Books ALTER COLUMN AuthorId INT NOT NULL;
GO

-- Создание дополнительных индексов
CREATE INDEX IX_Books_CategoryId ON Books(CategoryId);
CREATE INDEX IX_Books_AuthorId ON Books(AuthorId);
CREATE INDEX IX_Users_RoleId ON Users(RoleId);
CREATE INDEX IX_Users_Username ON Users(Username);
GO


-- Просмотр всех книг с информацией о категориях и авторах
SELECT 
    b.Id,
    b.Title,
    b.Author as OriginalAuthor,
    b.YearPublished,
    c.Name as CategoryName,
    a.FirstName + ' ' + a.LastName as FullAuthorName
FROM Books b
LEFT JOIN Categories c ON b.CategoryId = c.Id
LEFT JOIN Authors a ON b.AuthorId = a.Id;
GO