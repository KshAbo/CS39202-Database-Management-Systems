# 0. Database Creation

```
CREATE DATABASE Open_Courses;
USE Open_Courses;
```

# 1. Table Definations
## 1.1 Topic
```sql
CREATE TABLE Topic (
    topic_id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL
);
```
## 1.2 University
```sql
CREATE TABLE University (
    university_id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    location VARCHAR(100)
);
```
## 1.3 Program
```sql
CREATE TABLE Program (
    program_id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    type VARCHAR(20) NOT NULL,
    duration INT NOT NULL
);
```
## 1.4 Student
```sql
CREATE TABLE Student (
    student_id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    date_of_birth DATE NOT NULL,
    category VARCHAR(50),
    skill_level VARCHAR(50),
    country VARCHAR(50)
);
```
## 1.5 Instructor
```
CREATE TABLE Instructor (
    instructor_id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    department VARCHAR(100)
);
```
## 1.6 Online Content
```sql
CREATE TABLE OnlineContent (
    content_id SERIAL PRIMARY KEY,
    name VARCHAR(200) NOT NULL,
    type VARCHAR(50),
    url VARCHAR(500)
);
```
## 1.7 Book
```sql
CREATE TABLE Book (
    book_id SERIAL PRIMARY KEY,
    name VARCHAR(100),
    author VARCHAR(100)
);
```
## 1.8 Course
```sql
CREATE TABLE Course (
    course_id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL UNIQUE,
    duration INT NOT NULL,
    university_id INT NOT NULL REFERENCES University(university_id)
);
```
## 1.9 Teaches
```sql
CREATE TABLE Teaches (
    instructor_id INT REFERENCES Instructor(instructor_id),
    course_id INT REFERENCES Course(course_id),
    PRIMARY KEY (instructor_id, course_id)
);
```
## 1.10 Enrollment
```sql
CREATE TABLE Enrollment (
    student_id INT REFERENCES Student(student_id),
    course_id INT REFERENCES Course(course_id),
    score INT CHECK (score BETWEEN 0 AND 100),
    PRIMARY KEY (student_id, course_id)
);
```
## 1.11 CourseTopic
```sql
CREATE TABLE CourseTopic (
    course_id INT REFERENCES Course(course_id),
    topic_id INT REFERENCES Topic(topic_id),
    PRIMARY KEY (course_id, topic_id)
);
```
## 1.12 CourseOnlineContent
```sql
CREATE TABLE CourseOnlineContent (
    course_id INT REFERENCES Course(course_id),
    content_id INT REFERENCES OnlineContent(content_id),
    PRIMARY KEY (course_id, content_id)
);
```
## 1.13 CourseBook
```sql
CREATE TABLE CourseBook (
    course_id INT REFERENCES Course(course_id),
    book_id INT REFERENCES Book(book_id),
    PRIMARY KEY (course_id, book_id)
);
```
## 1.14 CourseProgram
```sql
CREATE TABLE CourseProgram (
    course_id INT REFERENCES Course(course_id),
    program_id INT REFERENCES Program(program_id),
    PRIMARY KEY (course_id, program_id)
);
```


# 2. Row Insertions
## 2.1 University
```sql
INSERT INTO University VALUES
(1, 'IITKGP', 'West Bengal'),
(2, 'IITG', 'Assam');
```
## 2.2 Programs
```sql
INSERT INTO Program VALUES
(1, 'AI Certificate', 'Certificate', 6),
(2, 'Data Science Diploma', 'Diploma', 12),
(3, 'CS Degree', 'Degree', 48);
```
# 2.3 Topics
```sql
INSERT INTO Topic VALUES
(1, 'AI'),
(2, 'Databases'),
(3, 'ML');
```
## 2.4 Book
```sql
INSERT INTO Book VALUES
(1, 'Deep Learning', 'Goodfellow'),
(2, 'AI Basics', 'Russell'),
(3, 'DB Systems', 'Silberschatz');
```
## 2.5 Course
```sql
INSERT INTO Course VALUES
(1, 'GenAI', 6, 1),
(2, 'Intro to AI', 6, 1),
(3, 'ML Foundations', 8, 2),
(4, 'Database Systems', 12, 2);
```
# 2.6 CourseTopic
```sql
INSERT INTO CourseTopic VALUES
(1, 1),
(2, 1),
(3, 1),
(4, 2);
```
## 2.7 CourseProgram
```sql
INSERT INTO CourseProgram VALUES
(1, 1),
(2, 1),
(3, 2),
(4, 3);
```
## 2.8 CourseBook
```sql
INSERT INTO CourseBook VALUES
(1, 1),
(2, 2),
(3, 1),
(4, 3);
```
## 2.9 Instructor
```sql
INSERT INTO Instructor VALUES
(1, 'Andrew Ng', 'AI'),
(2, 'Dr Sharma', 'CSE'),
(3, 'Dr Rao', 'Data Science');
```
## 2.10 Teaches
```sql
INSERT INTO Teaches VALUES
(1, 1),
(1, 2),
(2, 4),
(3, 3);
```
## 2.11 Student
```sql
INSERT INTO Student VALUES
(1, 'Amit', '2010-05-10', 'School', 'Beginner', 'India'),
(2, 'Ravi', '1960-01-01', 'Retired', 'Beginner', 'India'),
(3, 'John', '1999-07-12', 'UG', 'Intermediate', 'USA'),
(4, 'Sara', '2001-09-20', 'UG', 'Advanced', 'UK');
```
## 2.12 Enrollment
```sql
INSERT INTO Enrollment VALUES
(1, 1, 85),
(2, 1, 78),
(3, 1, 88),
(4, 1, 90),

(1, 2, 70),
(3, 2, 75),

(3, 3, 82),

(2, 4, 65);
```
## 2.13 OnlineContent
```sql
INSERT INTO OnlineContent VALUES
(1, 'GenAI Intro Video', 'video', 'x.com/1'),
(2, 'AI Notes', 'pdf', 'x.com/2');
```
## 2.14 CourseOnlineContent
```sql
INSERT INTO CourseOnlineContent VALUES
(1, 1),
(2, 2);
```


# 3. SQL Queries

# 3.1. Names of all “certificate” courses on the topic of “AI” of duration less than or equal six months.
```sql
SELECT DISTINCT Course.name
FROM Course
JOIN CourseProgram ON Course.course_id=CourseProgram.course_id
JOIN Program ON Program.program_id=CourseProgram.program_id
JOIN CourseTopic ON Course.course_id=CourseTopic.topic_id
JOIN Topic ON Topic.topic_id=CourseTopic.topic_id
WHERE Program.type = "Certificate"
      AND Topic.name = "AI"
      AND Course.duration <= 6
```

## 3.2 Names of all “certificate” courses on the topic of “AI” of duration less than or equal six months that are offered
in partnership with “IITKGP”.
```sql
SELECT DISTINCT Course.name
FROM Course
JOIN CourseProgram ON Course.course_id = CourseProgram.course_id
JOIN Program ON Program.program_id = CourseProgram.program_id
JOIN CourseTopic ON Course.course_id = CourseTopic.topic_id
JOIN Topic ON Topic.topic_id = CourseTopic.topic_id
JOIN University ON University.university_id = Course.university_id
WHERE Program.type = "Certificate"
      AND Topic.name = "AI"
      AND University.name = "IITKGP"
      AND Course.duration <= 6
```
## 3.3 Names of all students having age less than 18 years or more than 60 years who have done the course named “GenAI”.
```sql
SELECT s.name
FROM Student s
JOIN Enrollment e ON s.student_id = e.student_id
JOIN Course c ON c.course_id = e.course_id
WHERE c.name = 'GenAI'
  AND (
      EXTRACT(YEAR FROM AGE(CURRENT_DATE, s.date_of_birth)) < 18
   OR EXTRACT(YEAR FROM AGE(CURRENT_DATE, s.date_of_birth)) > 60
  );
```
## 3.4 Names of all students who are not Indians and have done a course having the topic “AI” that was offered in partnership with “IITKGP”.
```sql
SELECT Student.name
FROM Student
JOIN Enrollment ON Student.student_id = Enrollment.student_id
JOIN Course ON Course.course_id = Enrollment.course_id
JOIN CourseTopic on Course.course_id = CourseTopic.course_id
JOIN Topic on Topic.topic_id = CourseTopic.topic_id
JOIN University on University.university_id = Course.university_id
WHERE Student.country <> "India"
      AND Topic.name = "AI"
      AND University.name = "IITKGP"
```
## 3.5 Names of all countries from where a student has done a course instructed by “Andrew Ng”.
```sql
SELECT DISTINCT Student.country
FROM Student
JOIN Enrollment ON Student.student_id = Enrollment.student_id
JOIN Course ON Course.course_id = Enrollment.course_id
JOIN Teaches ON Teaches.course_id = Course.course_id
JOIN Instructor ON Instructor.instructor_id = Teaches.instructor_id
WHERE Instructor.name = "Andrew Ng"
```
## 3.6 Names of all instructors who have taught courses where at least one student was from India.
```sql
SELECT DISTINCT Instructor.name
FROM Instructor
JOIN Teaches ON Teaches.instructor_id = Instructor.instructor_id
JOIN Course ON Course.course_id = Teaches.course_id
JOIN Enrollment ON Enrollment.course_id = Course.course_id
JOIN Student ON Student.student_id = Enrollment.student_id
WHERE Student.country = "India"
```
## 3.7 Name of courses such that at least one student who have taken this course has also taken the course named “GenAI”.
```sql
SELECT C.name
FROM Course C
WHERE C.course_id IN (
  SELECT E.course_id FROM Enrollment E
  WHERE E.student_id IN (
    SELECT S.student_id FROM Student S
    JOIN Enrollment ER ON S.student_id = ER.student_id
    JOIN Course CR ON ER.course_id = CR.course_id
    WHERE CR.name = 'GenAI'
))
```
## 3.8 Name of all courses such that all the students who have taken this course has taken the course named “GenAI”.
```sql
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
)
```
## 3.9 Name of the most popular course (in terms of number of students) that is offered in partnership with “IITKGP”.
```sql
SELECT Course.name
FROM Course
JOIN University ON Course.university_id = University.university_id
JOIN Enrollment ON Course.course_id = Enrollment.course_id
WHERE University.name = 'IITKGP'
GROUP BY Course.course_id, Course.name
ORDER BY COUNT(Enrollment.student_id) DESC
LIMIT 1
```
## 3.10 Name of the Indian student who has got the highest average marks considering all course on the topic “AI”.
```sql
SELECT Student.name, AVG(Enrollment.score) AS avg_score
FROM Student
JOIN Enrollment ON Student.student_id = Enrollment.student_id
JOIN Course ON Enrollment.course_id = Course.course_id
JOIN CourseTopic ON Course.course_id = CourseTopic.course_id
JOIN Topic ON CourseTopic.topic_id = Topic.topic_id
WHERE Student.country = "India"
AND Topic.name = "AI"
GROUP BY Student.student_id, Student.name
ORDER BY avg_score DESC
LIMIT 1
```

