CREATE TABLE Topic (
    topic_id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL
);

CREATE TABLE University (
    university_id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    location VARCHAR(100)
);

CREATE TABLE Program (
    program_id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    type VARCHAR(20) NOT NULL,
    duration INT NOT NULL
);

CREATE TABLE Student (
    student_id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    date_of_birth DATE NOT NULL,
    category VARCHAR(50),
    skill_level VARCHAR(50),
    country VARCHAR(50)
);

CREATE TABLE Instructor (
    instructor_id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    department VARCHAR(100)
);

CREATE TABLE OnlineContent (
    content_id SERIAL PRIMARY KEY,
    name VARCHAR(200) NOT NULL,
    type VARCHAR(50),
    url VARCHAR(500)
);

CREATE TABLE Book (
    book_id SERIAL PRIMARY KEY,
    name VARCHAR(100),
    author VARCHAR(100)
);

CREATE TABLE Course (
    course_id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL UNIQUE,
    duration INT NOT NULL,
    university_id INT NOT NULL REFERENCES University(university_id)
);

CREATE TABLE Teaches (
    instructor_id INT REFERENCES Instructor(instructor_id),
    course_id INT REFERENCES Course(course_id),
    PRIMARY KEY (instructor_id, course_id)
);

CREATE TABLE Enrollment (
    student_id INT REFERENCES Student(student_id),
    course_id INT REFERENCES Course(course_id),
    score INT CHECK (score BETWEEN 0 AND 100),
    PRIMARY KEY (student_id, course_id)
);

CREATE TABLE CourseTopic (
    course_id INT REFERENCES Course(course_id),
    topic_id INT REFERENCES Topic(topic_id),
    PRIMARY KEY (course_id, topic_id)
);

CREATE TABLE CourseOnlineContent (
    course_id INT REFERENCES Course(course_id),
    content_id INT REFERENCES OnlineContent(content_id),
    PRIMARY KEY (course_id, content_id)
);

CREATE TABLE CourseBook (
    course_id INT REFERENCES Course(course_id),
    book_id INT REFERENCES Book(book_id),
    PRIMARY KEY (course_id, book_id)
);

CREATE TABLE CourseProgram (
    course_id INT REFERENCES Course(course_id),
    program_id INT REFERENCES Program(program_id),
    PRIMARY KEY (course_id, program_id)
);



INSERT INTO University (name, location) VALUES
('IITKGP', 'West Bengal'),
('IITG', 'Assam');

INSERT INTO Program (name, type, duration) VALUES
('AI Certificate', 'Certificate', 6),
('Data Science Diploma', 'Diploma', 12),
('CS Degree', 'Degree', 48);

INSERT INTO Topic (name) VALUES
('AI'), ('Databases'), ('ML');

INSERT INTO Book (name, author) VALUES
('Deep Learning', 'Goodfellow'),
('AI Basics', 'Russell'),
('DB Systems', 'Silberschatz');

INSERT INTO Course (name, duration, university_id) VALUES
('GenAI', 6, 1),
('Intro to AI', 6, 1),
('ML Foundations', 8, 2),
('Database Systems', 12, 2);

INSERT INTO CourseTopic VALUES
(1,1),(2,1),(3,1),(4,2);

INSERT INTO CourseProgram VALUES
(1,1),(2,1),(3,2),(4,3);

INSERT INTO CourseBook VALUES
(1,1),(2,2),(3,1),(4,3);

INSERT INTO Instructor (name, department) VALUES
('Andrew Ng','AI'),
('Dr Sharma','CSE'),
('Dr Rao','Data Science');

INSERT INTO Teaches VALUES
(1,1),(1,2),(2,4),(3,3);

INSERT INTO Student (name, date_of_birth, category, skill_level, country) VALUES
('Amit','2010-05-10','School','Beginner','India'),
('Ravi','1960-01-01','Retired','Beginner','India'),
('John','1999-07-12','UG','Intermediate','USA'),
('Sara','2001-09-20','UG','Advanced','UK');

INSERT INTO Enrollment VALUES
(1,1,85),(2,1,78),(3,1,88),(4,1,90),
(1,2,70),(3,2,75),
(3,3,82),
(2,4,65);

INSERT INTO OnlineContent (name,type,url) VALUES
('GenAI Intro Video','video','x.com/1'),
('AI Notes','pdf','x.com/2');

INSERT INTO CourseOnlineContent VALUES
(1,1),(2,2);



SELECT DISTINCT c.name
FROM Course c
JOIN CourseProgram cp ON c.course_id = cp.course_id
JOIN Program p ON p.program_id = cp.program_id
JOIN CourseTopic ct ON c.course_id = ct.course_id
JOIN Topic t ON t.topic_id = ct.topic_id
WHERE p.type = 'Certificate'
  AND t.name = 'AI'
  AND c.duration <= 6;

SELECT DISTINCT c.name
FROM Course c
JOIN CourseProgram cp ON c.course_id = cp.course_id
JOIN Program p ON p.program_id = cp.program_id
JOIN CourseTopic ct ON c.course_id = ct.course_id
JOIN Topic t ON t.topic_id = ct.topic_id
JOIN University u ON u.university_id = c.university_id
WHERE p.type = 'Certificate'
  AND t.name = 'AI'
  AND u.name = 'IITKGP'
  AND c.duration <= 6;

SELECT s.name
FROM Student s
JOIN Enrollment e ON s.student_id = e.student_id
JOIN Course c ON c.course_id = e.course_id
WHERE c.name = 'GenAI'
  AND (
      EXTRACT(YEAR FROM AGE(CURRENT_DATE, s.date_of_birth)) < 18
   OR EXTRACT(YEAR FROM AGE(CURRENT_DATE, s.date_of_birth)) > 60
  );

SELECT DISTINCT s.name
FROM Student s
JOIN Enrollment e ON s.student_id = e.student_id
JOIN Course c ON c.course_id = e.course_id
JOIN CourseTopic ct ON c.course_id = ct.course_id
JOIN Topic t ON t.topic_id = ct.topic_id
JOIN University u ON u.university_id = c.university_id
WHERE s.country <> 'India'
  AND t.name = 'AI'
  AND u.name = 'IITKGP';

SELECT DISTINCT s.country
FROM Student s
JOIN Enrollment e ON s.student_id = e.student_id
JOIN Course c ON c.course_id = e.course_id
JOIN Teaches t ON t.course_id = c.course_id
JOIN Instructor i ON i.instructor_id = t.instructor_id
WHERE i.name = 'Andrew Ng';

SELECT DISTINCT i.name
FROM Instructor i
JOIN Teaches t ON t.instructor_id = i.instructor_id
JOIN Course c ON c.course_id = t.course_id
JOIN Enrollment e ON e.course_id = c.course_id
JOIN Student s ON s.student_id = e.student_id
WHERE s.country = 'India';

SELECT DISTINCT c.name
FROM Course c
JOIN Enrollment e ON c.course_id = e.course_id
WHERE e.student_id IN (
    SELECT e2.student_id
    FROM Enrollment e2
    JOIN Course g ON g.course_id = e2.course_id
    WHERE g.name = 'GenAI'
);

SELECT c.name
FROM Course c
WHERE NOT EXISTS (
    SELECT *
    FROM Enrollment e1
    WHERE e1.course_id = c.course_id
      AND NOT EXISTS (
          SELECT *
          FROM Enrollment e2
          JOIN Course g ON g.course_id = e2.course_id
          WHERE e2.student_id = e1.student_id
            AND g.name = 'GenAI'
      )
);

SELECT c.name
FROM Course c
JOIN University u ON u.university_id = c.university_id
JOIN Enrollment e ON e.course_id = c.course_id
WHERE u.name = 'IITKGP'
GROUP BY c.course_id, c.name
ORDER BY COUNT(e.student_id) DESC
LIMIT 1;

SELECT s.name
FROM Student s
JOIN Enrollment e ON s.student_id = e.student_id
JOIN Course c ON c.course_id = e.course_id
JOIN CourseTopic ct ON c.course_id = ct.course_id
JOIN Topic t ON t.topic_id = ct.topic_id
WHERE s.country = 'India'
  AND t.name = 'AI'
GROUP BY s.student_id, s.name
ORDER BY AVG(e.score) DESC
LIMIT 1;
