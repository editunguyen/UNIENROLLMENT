USE FinalProject;

---Task 1: List Students Enrolled After 2018:
SELECT * FROM Students WHERE enrollmentYear > 2018;


#Task 2: Majors with Highest Average GPA:
SELECT M.MajorID, M.MajorName, AVG(S.GPA) as AvgGPA
FROM Students S
JOIN StudentMajors SM ON S.studentID = SM.StudentID
JOIN Majors M ON SM.MajorID = M.MajorID
GROUP BY M.MajorID, M.MajorName
ORDER BY AvgGPA DESC
LIMIT 5;


#Task 3: Instructors Teaching Most Credits:
SELECT I.InstructorID, I.Name as InstructorName, SUM(C.Credits) as TotalCredits
FROM CourseInstructors CI
JOIN Courses C ON CI.CourseID = C.CourseID
JOIN Instructors I ON CI.InstructorID = I.InstructorID
GROUP BY I.InstructorID, I.Name
ORDER BY TotalCredits DESC
LIMIT 3;


#Task 4: Department Wise Enrollment Trends:
SELECT Departments.DepartmentName, COUNT(*) as TotalEnrollments FROM Departments
JOIN Majors ON Departments.DepartmentID = Majors.DepartmentID
JOIN StudentMajors ON Majors.MajorID = StudentMajors.MajorID
GROUP BY Departments.DepartmentName;


#Task 5: Courses with Lowest Enrollment:
SELECT C.CourseID, C.CourseTitle as CourseName, COUNT(*) as EnrollmentCount 
FROM Enrollments E
JOIN Courses C ON E.CourseID = C.CourseID
GROUP BY C.CourseID, C.CourseTitle 
ORDER BY EnrollmentCount ASC 
LIMIT 5;



#Task 6: Students with Multiple Majors:
SELECT S.StudentID, S.Name as StudentName, COUNT(*) as MajorCount 
FROM StudentMajors SM
JOIN Students S ON SM.StudentID = S.StudentID
GROUP BY S.StudentID, S.Name 
HAVING MajorCount > 1
ORDER BY MajorCount DESC;



#Task 7: Popular Courses in Each Department:
SELECT DepartmentName, Cours    eTitle, COUNT(Enrollments.CourseID) as Enrollments
FROM Courses JOIN Enrollments ON Courses.CourseID = Enrollments.CourseID
JOIN Departments ON Courses.DepartmentID = Departments.DepartmentID
GROUP BY Courses.CourseID, DepartmentName
ORDER BY DepartmentName, Enrollments DESC;


#Task 8: Student Gender Distribution in Each Major:
SELECT MajorName, Gender, COUNT(*) as StudentCount FROM Majors
JOIN StudentMajors ON Majors.MajorID = StudentMajors.MajorID
JOIN Students ON StudentMajors.StudentID = Students.studentID
GROUP BY MajorName, Gender;


#Task 9: Course Schedule Conflicts:
SELECT a.CourseID as Course1, b.CourseID as Course2, a.Day, a.Time, a.RoomNumber 
FROM CourseSchedule a
JOIN CourseSchedule b ON a.Day = b.Day AND a.Time = b.Time AND a.CourseID != b.CourseID;


#Task 10: Instructors Not Assigned to Any Course:
SELECT * FROM Instructors WHERE instructorID NOT IN (SELECT InstructorID FROM CourseInstructors);



#Task 11: Departments with Most Courses:
SELECT D.DepartmentID, D.DepartmentName, COUNT(*) as CourseCount 
FROM Departments D
JOIN Courses C ON D.DepartmentID = C.DepartmentID
GROUP BY D.DepartmentID, D.DepartmentName 
ORDER BY CourseCount DESC;



#Task 12: Students with Above-Average GPA:
SELECT S.*, (SELECT AVG(GPA) FROM Students) as UniversityAvgGPA 
FROM Students S
WHERE S.GPA > (SELECT AVG(GPA) FROM Students);



#Task 13: Instructor Course Load by Semester:
SELECT InstructorID, Semester, COUNT(*) as CoursesTaught FROM CourseInstructors
JOIN Enrollments ON CourseInstructors.CourseID = Enrollments.CourseID
GROUP BY InstructorID, Semester;
### Method 2
SELECT I.InstructorID, I.Name as InstructorName, E.Semester, COUNT(DISTINCT E.CourseID) as CoursesTaught 
FROM CourseInstructors CI
JOIN Instructors I ON CI.InstructorID = I.InstructorID
JOIN Enrollments E ON CI.CourseID = E.CourseID
GROUP BY I.InstructorID, I.Name, E.Semester;


#Task 14: Course Schedules by Room:
SELECT RoomNumber, COUNT(*) as ScheduledClasses FROM CourseSchedule
GROUP BY RoomNumber;

#Task 15: Find the Semester with Highest Average GPA:
SELECT E.Semester, AVG(GM.NumericGrade) as AverageGrade
FROM Enrollments E
JOIN GradeMapping GM ON E.Grade = GM.LetterGrade
GROUP BY E.Semester
ORDER BY AverageGrade DESC
LIMIT 1;


#Task 16: Course Popularity Growth Over Years:
SELECT CourseID, YEAR(EnrollmentDate), COUNT(*) as EnrollmentCount
FROM Enrollments
GROUP BY CourseID, YEAR(EnrollmentDate)
ORDER BY CourseID, YEAR(EnrollmentDate);


#Task 17: Instructor Impact on Course Grades:****
SELECT CI.InstructorID, CI.CourseID, AVG(GM.NumericGrade) as AverageGrade
FROM CourseInstructors CI
JOIN Enrollments E ON CI.CourseID = E.CourseID
JOIN GradeMapping GM ON E.Grade = GM.LetterGrade
GROUP BY CI.InstructorID, CI.CourseID
ORDER BY AverageGrade DESC;



#Task 18: Department Funding Needs Based on Course Popularity:
SELECT D.DepartmentName, 
       DE.TotalEnrollments, 
       (SELECT AVG(TotalEnrollment) 
        FROM (SELECT COUNT(*) as TotalEnrollment 
              FROM Enrollments E 
              JOIN Courses C ON E.CourseID = C.CourseID 
              GROUP BY C.DepartmentID) AS AvgEnrollments) AS AverageEnrollment
FROM Departments D
JOIN (
    SELECT C.DepartmentID, COUNT(*) as TotalEnrollments
    FROM Enrollments E
    JOIN Courses C ON E.CourseID = C.CourseID
    GROUP BY C.DepartmentID
) AS DE ON D.DepartmentID = DE.DepartmentID
GROUP BY D.DepartmentName, DE.TotalEnrollments
ORDER BY DE.TotalEnrollments DESC;


#Task 19: Faculty Utilization and Course Assignment:
SELECT CI.InstructorID, COUNT(DISTINCT CI.CourseID) as CoursesTaught, AVG(C.Credits) as AverageCredits
FROM CourseInstructors CI
JOIN Courses C ON CI.CourseID = C.CourseID
GROUP BY CI.InstructorID
ORDER BY CoursesTaught DESC;


#Task 20: Student Performance Comparison by Country:
SELECT Country, AVG(GPA) as AverageGPA, COUNT(*) as NumberOfStudents
FROM Students
GROUP BY Country;

#Task 21: Time-Based Analysis of Course Schedule Density:
SELECT Day, Time, COUNT(*) as CourseCount FROM CourseSchedule
GROUP BY Day, Time ORDER BY CourseCount DESC;


#Task 22: Analysis of Departmental Head Influence on Department Performance:
SELECT DepartmentName, AVG(GPA) as AvgDepartmentGPA FROM Students
JOIN StudentMajors ON Students.StudentID = StudentMajors.StudentID
JOIN Majors ON StudentMajors.MajorID = Majors.MajorID
JOIN Departments ON Majors.DepartmentID = Departments.DepartmentID
GROUP BY DepartmentName, HeadInstructorID;

#Task 23: Impact of Course Load on Student GPA:
SELECT S.StudentID, COUNT(E.CourseID) as CourseLoad, AVG(S.GPA) as AverageGPA
FROM Enrollments E
JOIN Students S ON E.StudentID = S.StudentID
GROUP BY S.StudentID
ORDER BY CourseLoad DESC;

#Task 24: Instructors Departmental Diversity in Teaching:
SELECT InstructorID, COUNT(DISTINCT DepartmentID) as DepartmentsTaught
FROM CourseInstructors
JOIN Courses ON CourseInstructors.CourseID = Courses.CourseID
GROUP BY InstructorID
ORDER BY DepartmentsTaught DESC;



#Task 25: Room Utilization Efficiency Analysis:
SELECT RoomNumber, COUNT(*) as ClassesScheduled, AVG(EnrollmentCount) as AverageEnrollment
FROM CourseSchedule
JOIN (
    SELECT CourseID, COUNT(*) as EnrollmentCount
    FROM Enrollments
    GROUP BY CourseID
) as CourseEnrollments ON CourseSchedule.CourseID = CourseEnrollments.CourseID
GROUP BY RoomNumber
ORDER BY ClassesScheduled DESC;

#Task 26: Analysis of Grade Improvement Over Semesters for Each Major:
SELECT SM.MajorID, E.Semester, AVG(GM.NumericGrade) as AverageGrade
FROM Enrollments E
JOIN GradeMapping GM ON E.Grade = GM.LetterGrade
JOIN Students S ON E.StudentID = S.StudentID
JOIN StudentMajors SM ON S.StudentID = SM.StudentID
GROUP BY SM.MajorID, E.Semester
ORDER BY SM.MajorID, E.Semester;

#Task 27: Distribution of Grades Across Different Departments:
SELECT D.DepartmentID, GM.LetterGrade, COUNT(*) as Total, 
       COUNT(*) * 100.0 / (SELECT COUNT(*) FROM Enrollments E2 
                           JOIN Students S2 ON E2.StudentID = S2.StudentID
                           JOIN StudentMajors SM2 ON S2.StudentID = SM2.StudentID
                           JOIN Majors M2 ON SM2.MajorID = M2.MajorID
                           WHERE M2.DepartmentID = D.DepartmentID) as Percentage
FROM Enrollments E
JOIN Students S ON E.StudentID = S.StudentID
JOIN StudentMajors SM ON S.StudentID = SM.StudentID
JOIN Majors M ON SM.MajorID = M.MajorID
JOIN Departments D ON M.DepartmentID = D.DepartmentID
JOIN GradeMapping GM ON E.Grade = GM.LetterGrade
GROUP BY D.DepartmentID, GM.LetterGrade
ORDER BY D.DepartmentID, GM.LetterGrade;


#Task 28: Optimization Analysis for Classroom Utilization and Scheduling:
SELECT cs1.RoomNumber, cs1.Day, cs1.Time, COUNT(cs1.CourseID) as ConcurrentCourses,
       (SELECT SUM(EnrollmentCount) 
        FROM (SELECT CourseID, COUNT(*) as EnrollmentCount 
              FROM Enrollments 
              GROUP BY CourseID) as CourseEnrollments 
        WHERE CourseID IN (SELECT CourseID 
                           FROM CourseSchedule cs2 
                           WHERE cs2.RoomNumber = cs1.RoomNumber 
                           AND cs2.Day = cs1.Day 
                           AND cs2.Time = cs1.Time)) as TotalEnrollments
FROM CourseSchedule cs1
GROUP BY cs1.RoomNumber, cs1.Day, cs1.Time
HAVING ConcurrentCourses > 1;




