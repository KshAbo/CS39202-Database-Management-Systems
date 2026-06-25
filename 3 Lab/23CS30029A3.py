import psycopg2 as ps
import pandas as pd

def fetch_results(query, conn):
    cur = conn.cursor()
    cur.execute(query)
    cols = [desc[0] for desc in cur.description]
    df = pd.DataFrame(cur.fetchall(), columns=cols)
    cur.close()
    return df


def run_query(query, conn, commit=False):
    cur = conn.cursor()
    cur.execute(query)
    res = cur.fetchall()
    print(res)
    if commit:
        conn.commit()
    cur.close()

def query_answer(question, query, conn):

    print(question)
    df = fetch_results(query, conn)
    print("Response: ")
    print(df)
    print()

def main():
    conn = ps.connect(
                dbname="23CS30029",
                user="23CS30029",
                password="23CS30029"
            )


    """
    1. Names of all “certificate” courses on the topic of “AI” of duration less than or equal six months.
    """

    question = "1. Names of all “certificate” courses on the topic of “AI” of duration less than or equal six months."
    query = """
    SELECT DISTINCT Course.name
    FROM Course
    JOIN CourseProgram ON Course.course_id=CourseProgram.course_id
    JOIN Program ON Program.program_id=CourseProgram.program_id
    JOIN CourseTopic ON Course.course_id=CourseTopic.topic_id
    JOIN Topic ON Topic.topic_id=CourseTopic.topic_id
    WHERE Program.type = 'Certificate'
          AND Topic.name = 'AI'
          AND Course.duration <= 6
    """
    query_answer(question, query, conn)

    
    """
    2. Names of all “certificate” courses on the topic of “AI” of duration less than or equal six months that are offered in partnership with “IITKGP”.
    """

    question = "2. Names of all “certificate” courses on the topic of “AI” of duration less than or equal six months that are offered in partnership with “IITKGP”."

    query = """
    SELECT DISTINCT Course.name
    FROM Course
    JOIN CourseProgram ON Course.course_id = CourseProgram.course_id
    JOIN Program ON Program.program_id = CourseProgram.program_id
    JOIN CourseTopic ON Course.course_id = CourseTopic.topic_id
    JOIN Topic ON Topic.topic_id = CourseTopic.topic_id
    JOIN University ON University.university_id = Course.university_id
    WHERE Program.type = 'Certificate'
          AND Topic.name = 'AI'
          AND University.name = 'IITKGP'
          AND Course.duration <= 6
    """
    query_answer(question, query, conn)
    

    """
    3. Names of all students having age less than 18 years or more than 60 years who have done the course named “GenAI”.
    """

    question = "3. Names of all students having age less than 18 years or more than 60 years who have done the course named “GenAI”."
    query = """
    SELECT s.name
    FROM Student s
    JOIN Enrollment e ON s.student_id = e.student_id
    JOIN Course c ON c.course_id = e.course_id
    WHERE c.name = 'GenAI'
      AND (
              EXTRACT(YEAR FROM AGE(CURRENT_DATE, s.date_of_birth)) < 18
              OR EXTRACT(YEAR FROM AGE(CURRENT_DATE, s.date_of_birth)) > 60
              );
    """
    query_answer(question, query, conn)


    """
    4. Names of all students who are not Indians and have done a course having the topic “AI” that was offered in partnership with “IITKGP”.
    """

    question = "4. Names of all students who are not Indians and have done a course having the topic “AI” that was offered in partnership with “IITKGP”."
    query = """
    SELECT Student.name
    FROM Student
    JOIN Enrollment ON Student.student_id = Enrollment.student_id
    JOIN Course ON Course.course_id = Enrollment.course_id
    JOIN CourseTopic on Course.course_id = CourseTopic.course_id
    JOIN Topic on Topic.topic_id = CourseTopic.topic_id
    JOIN University on University.university_id = Course.university_id
    WHERE Student.country <> 'India'
          AND Topic.name = 'AI'
          AND University.name = 'IITKGP'
    """
    query_answer(question, query, conn)


    """
    5. Names of all countries from where a student has done a course instructed by “Andrew Ng”.
    """

    question = "5. Names of all countries from where a student has done a course instructed by “Andrew Ng”."
    query = """
    SELECT DISTINCT Student.country
    FROM Student
    JOIN Enrollment ON Student.student_id = Enrollment.student_id
    JOIN Course ON Course.course_id = Enrollment.course_id
    JOIN Teaches ON Teaches.course_id = Course.course_id
    JOIN Instructor ON Instructor.instructor_id = Teaches.instructor_id
    WHERE Instructor.name = 'Andrew Ng'
    """
    query_answer(question, query, conn)


    """
    6. Names of all instructors who have taught courses where at least one student was from India.
    """

    question = "6. Names of all instructors who have taught courses where at least one student was from India."
    query = """
    SELECT DISTINCT Instructor.name
    FROM Instructor
    JOIN Teaches ON Teaches.instructor_id = Instructor.instructor_id
    JOIN Course ON Course.course_id = Teaches.course_id
    JOIN Enrollment ON Enrollment.course_id = Course.course_id
    JOIN Student ON Student.student_id = Enrollment.student_id
    WHERE Student.country = 'India'
    """
    query_answer(question, query, conn)


    """
    7. Name of courses such that at least one student who have taken this course has also taken the course named “GenAI”.
    """

    question = "7. Name of courses such that at least one student who have taken this course has also taken the course named “GenAI”."
    query = """
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
    """
    query_answer(question, query, conn)


    """
    8. Name of all courses such that all the students who have taken this course has taken the course named “GenAI”.
    """

    question = "8. Name of all courses such that all the students who have taken this course has taken the course named “GenAI”."
    query = """
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
    """
    query_answer(question, query, conn)


    """
    9. Name of the most popular course (in terms of number of students) that is offered in partnership with “IITKGP”.
    """

    question = "9. Name of the most popular course (in terms of number of students) that is offered in partnership with “IITKGP”."
    query = """
    SELECT Course.name
    FROM Course
    JOIN University ON Course.university_id = University.university_id
    JOIN Enrollment ON Course.course_id = Enrollment.course_id
    WHERE University.name = 'IITKGP'
    GROUP BY Course.course_id, Course.name
    ORDER BY COUNT(Enrollment.student_id) DESC
    LIMIT 1
    """
    query_answer(question, query, conn)


    """
    10. Name of the Indian student who has got the highest average marks considering all course on the topic “AI”.
    """

    question = "10. Name of the Indian student who has got the highest average marks considering all course on the topic “AI”."
    query = """
    SELECT Student.name, AVG(Enrollment.score) AS avg_score
    FROM Student
    JOIN Enrollment ON Student.student_id = Enrollment.student_id
    JOIN Course ON Enrollment.course_id = Course.course_id
    JOIN CourseTopic ON Course.course_id = CourseTopic.course_id
    JOIN Topic ON CourseTopic.topic_id = Topic.topic_id
    WHERE Student.country = 'India'
    AND Topic.name = 'AI'
    GROUP BY Student.student_id, Student.name
    ORDER BY avg_score DESC
    LIMIT 1
    """
    query_answer(question, query, conn)


if __name__ == '__main__':
    main()
