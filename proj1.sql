-- comp9311 19T3 Project 1
--
-- MyMyUNSW Solutions


-- Q1:
create or replace view Q1(unswid, longname)
as
select distinct unswid, longname
from rooms, room_facilities, facilities
where rooms.id = room_facilities.room
and room_facilities.facility = facilities.id
and facilities.description = 'Air-conditioned'
;

-- Q2:
create or replace view Q2(unswid,name)
as
select distinct pt.unswid, pt.name
from people pt, course_staff, course_enrolments, people ps
where pt.id = course_staff.staff
and course_staff.course = course_enrolments.course
and course_enrolments.student = ps.id
and ps.family = 'Margareta' and ps.given = 'Hemma'
;

-- Q3:
create or replace view int_stu_HD_COMP9311(id,semester) 
as
select students.id, courses.semester
from students, course_enrolments, courses, subjects
where students.id = course_enrolments.student
and students.stype = 'intl'
and course_enrolments.mark >= 85
and course_enrolments.course = courses.id
and courses.subject = subjects.id
and subjects.code = 'COMP9311'
;

create or replace view int_stu_HD_COMP9024(id,semester) 
as
select students.id, courses.semester
from students, course_enrolments, courses, subjects
where students.id = course_enrolments.student
and students.stype = 'intl'
and course_enrolments.mark >= 85
and course_enrolments.course = courses.id
and courses.subject = subjects.id
and subjects.code = 'COMP9024'
;

create or replace view Q3(unswid, name)
as 
select distinct unswid, name
from people, int_stu_HD_COMP9311, int_stu_HD_COMP9024
where people.id = int_stu_HD_COMP9311.id
and int_stu_HD_COMP9311.id = int_stu_HD_COMP9024.id
and int_stu_HD_COMP9311.semester = int_stu_HD_COMP9024.semester
;

-- Q4:
create or replace view stu_notnull(id)
as
select distinct course_enrolments.student
from course_enrolments
where course_enrolments is not null
;

create or replace view stu_HD_num(id, num)
as
select stu_notnull.id, sum(case when course_enrolments.grade = 'HD' then 1 else 0 end) as num
from course_enrolments, stu_notnull
where course_enrolments.student = stu_notnull.id
group by stu_notnull.id
order by num
;

create or replace view avg(avg)
as
select avg(stu_HD_num.num)
from stu_HD_num
;

create or replace view Q4(num_student)
as
select count(*)
from stu_HD_num,avg
where stu_HD_num.num > avg.avg
;

--Q5:

create or replace view course_valid_mark_num(id,valid_mark_num)
as
select course, count(*)
from course_enrolments
where course_enrolments.mark is not null
group by course
;

create or replace view semester_valid_courses_num(semester, valid_courses_num)
as
select semester, count(*)
from courses, course_valid_mark_num
where courses.id = course_valid_mark_num.id
group by semester
;

create or replace view valid_course_max_mark(id, max_mark)
as
select course, max(mark)
from course_enrolments, course_valid_mark_num
where course_enrolments.course = course_valid_mark_num.id
and course_valid_mark_num.valid_mark_num >= 20
group by course
;

create or replace view semester_min_mark(semester, mark)
as
select courses.semester, min(valid_course_max_mark.max_mark)
from courses, semester_valid_courses_num, valid_course_max_mark
where courses.semester = semester_valid_courses_num.semester
and courses.id = valid_course_max_mark.id
and semester_valid_courses_num.valid_courses_num > 0
group by courses.semester
;

create or replace view semester_min_course(semester, subject)
as
select courses.semester, courses.subject
from courses, semester_min_mark, valid_course_max_mark
where courses.semester = semester_min_mark.semester
and courses.id = valid_course_max_mark.id
and valid_course_max_mark.max_mark = semester_min_mark.mark
;

create or replace view Q5(code, name, semester)
as
select subjects.code, subjects.name, semesters.name
from subjects, semesters, semester_min_course
where semester_min_course.subject = subjects.id 
and semester_min_course.semester = semesters.id 
;

-- Q6:
create or replace view students_enrol_FOE(unswid)
as
select distinct people.unswid
from people, course_enrolments, courses, subjects, orgunits
where people.id = course_enrolments.student
and course_enrolments.course = courses.id
and courses.subject = subjects.id
and subjects.offeredby = orgunits.id
and orgunits.name = 'Faculty of Engineering'
;

create or replace view local_students_enrol_10S1_MANG(unswid)
as
select distinct people.unswid
from people, Program_enrolments, Stream_enrolments, streams, semesters, students
where people.id = program_enrolments.student
and program_enrolments.id = stream_enrolments.partof
and stream_enrolments.stream = streams.id
and streams.name = 'Management'
and program_enrolments.semester = semesters.id
and semesters.year = 2010
and semesters.term = 'S1'
and people.id = students.id
and students.stype = 'local'
;

create or replace view the_diff_Q6(unswid)
as
select unswid
from local_students_enrol_10S1_MANG
except
select unswid
from students_enrol_FOE
;

create or replace view Q6(num)
as
select count(*)
from the_diff_Q6
;

-- Q7:
create or replace view DS_mark(year, term, mark)
as
select semesters.year, semesters.term, course_enrolments.mark
from course_enrolments, courses, subjects, semesters
where course_enrolments.course = courses.id
and courses.subject = subjects.id
and courses.semester = semesters.id
and subjects.name = 'Database Systems'
and course_enrolments.mark > 0
;

create or replace view Q7(year, term, average_mark)
as
select year, term, avg(mark)::numeric(4,2)
from DS_mark
group by year, term
;

-- Q8: 
create or replace view CSE_courses_data(id,year_term)
as
select subjects.code, concat(semesters.year, semesters.term)
from courses, subjects, semesters
where courses.subject = subjects.id
and courses.semester = semesters.id
and subjects.code like 'COMP93%'
;

create or replace view major_semester(year_term)
as
select distinct concat(semesters.year, semesters.term)
from semesters
where semesters.year >= 2004
and semesters.year <= 2013
and semesters.term like 'S%'
;

create or replace view CSE_courses_div_data(id) as
select distinct CA.id from CSE_courses_data CA 
where not exists(select major_semester.year_term from major_semester 
	where not exists(select * from CSE_courses_data CC where CC.id = CA.id and CC.year_term = major_semester.year_term));

create or replace view stu_fall_course(id,course_id) 
as
select course_enrolments.student, subjects.code
from course_enrolments, courses, subjects, CSE_courses_div_data
where subjects.code = CSE_courses_div_data.id
and subjects.id = courses.subject
and courses.id = course_enrolments.course
and course_enrolments.mark <50
;

create or replace view stu_fall(id) as
select distinct SA.id from stu_fall_course SA 
where not exists(select CSE_courses_div_data.id from CSE_courses_div_data 
  where not exists(select * from stu_fall_course SC where SC.id = SA.id and SC.course_id = CSE_courses_div_data.id));


create or replace view Q8(zid, name)
as
select distinct concat('z', cast(People.unswid as varchar(10))), People.name
from people, stu_fall
where people.id = stu_fall.id
;


-- Q9:
create or replace view stu_in_bsc(student_id, program_id, semester)
as
select distinct program_enrolments.student, programs.id, program_enrolments.semester
from program_enrolments, programs, program_degrees
where program_enrolments.program = programs.id
and programs.id = program_degrees.program
and program_degrees.abbrev = 'BSc'
;

create or replace view stu_pass_course(student_id, program_id)
as
select distinct stu_in_bsc.student_id, stu_in_bsc.program_id
from stu_in_bsc, course_enrolments, courses, semesters
where stu_in_bsc.student_id = course_enrolments.student
and course_enrolments.course = courses.id
and courses.semester = semesters.id
and semesters.year = 2010
and semesters.term = 'S2'
and course_enrolments.mark >= 50
;

create or replace view stu_mark_uoc(student_id, program_id, course, mark, uoc)
as
select distinct stu_in_bsc.student_id, stu_in_bsc.program_id, course_enrolments.course, course_enrolments.mark, subjects.uoc
from stu_pass_course, stu_in_bsc, course_enrolments, courses, semesters, subjects
where stu_pass_course.student_id = stu_in_bsc.student_id
and course_enrolments.student = stu_in_bsc.student_id
and course_enrolments.course = courses.id
and courses.semester = stu_in_bsc.semester
and stu_in_bsc.semester = semesters.id
and semesters.year < 2011
and course_enrolments.mark >= 50
and courses.subject = subjects.id
;


create or replace view stu_avg_mark(student_id, program_id, avg_mark)
as
select stu_mark_uoc.student_id, stu_mark_uoc.program_id, avg(stu_mark_uoc.mark)
from stu_mark_uoc
group by stu_mark_uoc.student_id, stu_mark_uoc.program_id
;


create or replace view stu_over_avg_mark(student_id, program_id)
as
select stu_avg_mark.student_id, stu_avg_mark.program_id
from stu_avg_mark
where stu_avg_mark.avg_mark >= 80
;

create or replace view stu_uoc(student_id, program_id, uoc)
as
select stu_over_avg_mark.student_id, stu_over_avg_mark.program_id, sum(stu_mark_uoc.uoc)
from stu_over_avg_mark, stu_mark_uoc
where stu_over_avg_mark.student_id = stu_mark_uoc.student_id
group by stu_over_avg_mark.student_id, stu_over_avg_mark.program_id
order by stu_over_avg_mark.student_id
;

create or replace view stu_over_uoc(student_id)
as
select distinct stu_uoc.student_id
from stu_uoc, programs
where stu_uoc.program_id = programs.id
and stu_uoc.uoc >= programs.uoc
;

create or replace view Q9(unswid, name)
as
select distinct people.unswid, people.name
from people, stu_over_uoc
where people.id = stu_over_uoc.student_id
;

-- Q10:
create or replace view All_theatre(room_id)
as
select distinct rooms.id
from rooms, room_types
where rooms.rtype = room_types.id
and room_types.description = 'Lecture Theatre'
;

create or replace view All_calsses(calss_id, room_id)
as
select distinct classes.id, All_theatre.room_id
from classes, All_theatre, courses, semesters
where classes.course = courses.id
and courses.semester = semesters.id
and semesters.year = 2011
and semesters.term = 'S1'
and classes.room = All_theatre.room_id
;

create or replace view AllTC(room_id,calss_id)
as
select All_theatre.room_id, All_calsses.calss_id
from All_theatre
left join All_calsses
on All_calsses.room_id = All_theatre.room_id
;


create or replace view Theatre_classesnum(roomid, class_num)
as
select AllTC.room_id, sum(case when AllTC.calss_id is not null then 1 else 0 end) as class_num
from AllTC
group by AllTC.room_id
;

create or replace view Q10(unswid, longname, num, rank)
as
select distinct Rooms.unswid, Rooms.longname, Theatre_classesnum.class_num, rank()
over (order by Theatre_classesnum.class_num desc) rank
from rooms, Theatre_classesnum
where rooms.id = Theatre_classesnum.roomid
order by rank
;

