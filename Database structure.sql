                   List of relations
 Schema |           Name            | Type  |  Owner
--------+---------------------------+-------+----------
 public | acad_object_groups        | table | z5239391
 public | academic_standing         | table | z5239391
 public | affiliations              | table | z5239391
 public | books                     | table | z5239391
 public | buildings                 | table | z5239391
 public | class_enrolment_waitlist  | table | z5239391
 public | class_enrolments          | table | z5239391
 public | class_teachers            | table | z5239391
 public | class_types               | table | z5239391
 public | classes                   | table | z5239391
 public | countries                 | table | z5239391
 public | course_books              | table | z5239391
 public | course_enrolment_waitlist | table | z5239391
 public | course_enrolments         | table | z5239391
 public | course_quotas             | table | z5239391
 public | course_staff              | table | z5239391
 public | courses                   | table | z5239391
 public | degree_types              | table | z5239391
 public | degrees_awarded           | table | z5239391
 public | external_subjects         | table | z5239391
 public | facilities                | table | z5239391
 public | orgunit_groups            | table | z5239391
 public | orgunit_types             | table | z5239391
 public | orgunits                  | table | z5239391
 public | people                    | table | z5239391
 public | program_degrees           | table | z5239391
 public | program_enrolments        | table | z5239391
 public | program_group_members     | table | z5239391
 public | programs                  | table | z5239391
 public | public_holidays           | table | z5239391
 public | room_facilities           | table | z5239391
 public | room_types                | table | z5239391
 public | rooms                     | table | z5239391
 public | semesters                 | table | z5239391
 public | staff                     | table | z5239391
 public | staff_role_classes        | table | z5239391
 public | staff_role_types          | table | z5239391
 public | staff_roles               | table | z5239391
 public | stream_enrolments         | table | z5239391
 public | stream_group_members      | table | z5239391
 public | stream_types              | table | z5239391
 public | streams                   | table | z5239391
 public | student_groups            | table | z5239391
 public | students                  | table | z5239391
 public | subject_group_members     | table | z5239391
 public | subjects                  | table | z5239391
 public | variations                | table | z5239391
(47 rows)



           Table "public.acad_object_groups"
   Column   |           Type           |   Modifiers
------------+--------------------------+---------------
 id         | integer                  | not null
 name       | longname                 |
 gtype      | acadobjectgrouptype      | not null
 glogic     | acadobjectgrouplogictype |
 gdefby     | acadobjectgroupdeftype   | not null
 negated    | boolean                  | default false
 parent     | integer                  |
 definition | textstring               |
Indexes:
    "acad_object_groups_pkey" PRIMARY KEY, btree (id)
Foreign-key constraints:
    "acad_object_groups_parent_fkey" FOREIGN KEY (parent) REFERENCES acad_object_groups(id)
Referenced by:
    TABLE "acad_object_groups" CONSTRAINT "acad_object_groups_parent_fkey" FOREIGN KEY (parent) REFERENCES acad_object_groups(id)
    TABLE "program_group_members" CONSTRAINT "program_group_members_ao_group_fkey" FOREIGN KEY (ao_group) REFERENCES acad_object_groups(id)
    TABLE "stream_group_members" CONSTRAINT "stream_group_members_ao_group_fkey" FOREIGN KEY (ao_group) REFERENCES acad_object_groups(id)
    TABLE "subject_group_members" CONSTRAINT "subject_group_members_ao_group_fkey" FOREIGN KEY (ao_group) REFERENCES acad_object_groups(id)
    TABLE "subjects" CONSTRAINT "subjects_equivalent_fkey" FOREIGN KEY (equivalent) REFERENCES acad_object_groups(id)
    TABLE "subjects" CONSTRAINT "subjects_excluded_fkey" FOREIGN KEY (excluded) REFERENCES acad_object_groups(id)



 Table "public.academic_standing"
  Column  |    Type    | Modifiers
----------+------------+-----------
 id       | integer    | not null
 standing | shortname  | not null
 notes    | textstring |
Indexes:
    "academic_standing_pkey" PRIMARY KEY, btree (id)
Referenced by:
    TABLE "program_enrolments" CONSTRAINT "program_enrolments_standing_fkey" FOREIGN KEY (standing) REFERENCES academic_standing(id)



   Table "public.affiliations"
  Column   |  Type   | Modifiers
-----------+---------+-----------
 staff     | integer | not null
 orgunit   | integer | not null
 role      | integer | not null
 isprimary | boolean |
 starting  | date    | not null
 ending    | date    |
Indexes:
    "affiliations_pkey" PRIMARY KEY, btree (staff, orgunit, role, starting)
Foreign-key constraints:
    "affiliations_orgunit_fkey" FOREIGN KEY (orgunit) REFERENCES orgunits(id)
    "affiliations_role_fkey" FOREIGN KEY (role) REFERENCES staff_roles(id)
    "affiliations_staff_fkey" FOREIGN KEY (staff) REFERENCES staff(id)



                 Table "public.books"
  Column   |         Type          | Modifiers
-----------+-----------------------+-----------
 id        | integer               | not null
 isbn      | character varying(20) |
 title     | longstring            | not null
 authors   | longstring            | not null
 publisher | longstring            | not null
 edition   | integer               |
 pubyear   | integer               | not null
Indexes:
    "books_pkey" PRIMARY KEY, btree (id)
    "books_isbn_key" UNIQUE CONSTRAINT, btree (isbn)
Check constraints:
    "books_pubyear_check" CHECK (pubyear > 1900)
Referenced by:
    TABLE "course_books" CONSTRAINT "course_books_book_fkey" FOREIGN KEY (book) REFERENCES books(id)


      Table "public.buildings"
 Column  |     Type     | Modifiers
---------+--------------+-----------
 id      | integer      | not null
 unswid  | shortstring  | not null
 name    | longname     | not null
 campus  | campustype   |
 gridref | character(4) |
Indexes:
    "buildings_pkey" PRIMARY KEY, btree (id)
    "buildings_unswid_key" UNIQUE CONSTRAINT, btree (unswid)
Referenced by:
    TABLE "rooms" CONSTRAINT "rooms_building_fkey" FOREIGN KEY (building) REFERENCES buildings(id)


Table "public.class_enrolments"
 Column  |  Type   | Modifiers
---------+---------+-----------
 student | integer | not null
 class   | integer | not null
Indexes:
    "class_enrolments_pkey" PRIMARY KEY, btree (student, class)
Foreign-key constraints:
    "class_enrolments_class_fkey" FOREIGN KEY (class) REFERENCES classes(id)
    "class_enrolments_student_fkey" FOREIGN KEY (student) REFERENCES students(id)
    

      Table "public.class_enrolment_waitlist"
 Column  |            Type             | Modifiers
---------+-----------------------------+-----------
 student | integer                     | not null
 class   | integer                     | not null
 applied | timestamp without time zone | not null
Indexes:
    "class_enrolment_waitlist_pkey" PRIMARY KEY, btree (student, class)
Foreign-key constraints:
    "class_enrolment_waitlist_class_fkey" FOREIGN KEY (class) REFERENCES classes(id)
    "class_enrolment_waitlist_student_fkey" FOREIGN KEY (student) REFERENCES students(id)


     Table "public.class_teachers"
 Column  |  Type   | Modifiers
---------+---------+-----------
 class   | integer | not null
 teacher | integer | not null
Indexes:
    "class_teachers_pkey" PRIMARY KEY, btree (class, teacher)
Foreign-key constraints:
    "class_teachers_class_fkey" FOREIGN KEY (class) REFERENCES classes(id)
    "class_teachers_teacher_fkey" FOREIGN KEY (teacher) REFERENCES staff(id)



       Table "public.class_types"
   Column    |     Type     | Modifiers
-------------+--------------+-----------
 id          | integer      | not null
 unswid      | shortstring  | not null
 name        | mediumname   | not null
 description | mediumstring |
Indexes:
    "class_types_pkey" PRIMARY KEY, btree (id)
    "class_types_unswid_key" UNIQUE CONSTRAINT, btree (unswid)
Referenced by:
    TABLE "classes" CONSTRAINT "classes_ctype_fkey" FOREIGN KEY (ctype) REFERENCES class_types(id)



     Table "public.classes"
  Column   |  Type   | Modifiers
-----------+---------+-----------
 id        | integer | not null
 course    | integer | not null
 room      | integer | not null
 ctype     | integer | not null
 dayofwk   | integer | not null
 starttime | integer | not null
 endtime   | integer | not null
 startdate | date    | not null
 enddate   | date    | not null
 repeats   | integer |
Indexes:
    "classes_pkey" PRIMARY KEY, btree (id)
Check constraints:
    "classes_dayofwk_check" CHECK (dayofwk >= 0 AND dayofwk <= 6)
    "classes_endtime_check" CHECK (endtime >= 9 AND endtime <= 23)
    "classes_starttime_check" CHECK (starttime >= 8 AND starttime <= 22)
Foreign-key constraints:
    "classes_course_fkey" FOREIGN KEY (course) REFERENCES courses(id)
    "classes_ctype_fkey" FOREIGN KEY (ctype) REFERENCES class_types(id)
    "classes_room_fkey" FOREIGN KEY (room) REFERENCES rooms(id)
Referenced by:
    TABLE "class_enrolment_waitlist" CONSTRAINT "class_enrolment_waitlist_class_fkey" FOREIGN KEY (class) REFERENCES classes(id)
    TABLE "class_enrolments" CONSTRAINT "class_enrolments_class_fkey" FOREIGN KEY (class) REFERENCES classes(id)
    TABLE "class_teachers" CONSTRAINT "class_teachers_class_fkey" FOREIGN KEY (class) REFERENCES classes(id)


         Table "public.countries"
 Column |     Type     | Modifiers
--------+--------------+-----------
 id     | integer      | not null
 code   | character(3) | not null
 name   | longname     | not null
Indexes:
    "countries_pkey" PRIMARY KEY, btree (id)
    "countries_code_key" UNIQUE CONSTRAINT, btree (code)
Referenced by:
    TABLE "people" CONSTRAINT "people_country_fkey" FOREIGN KEY (country) REFERENCES countries(id)
    TABLE "people" CONSTRAINT "people_origin_fkey" FOREIGN KEY (origin) REFERENCES countries(id)


            Table "public.course_books"
 Column |         Type          | Modifiers
--------+-----------------------+-----------
 course | integer               | not null
 book   | integer               | not null
 bktype | character varying(10) | not null
Indexes:
    "course_books_pkey" PRIMARY KEY, btree (course, book)
Check constraints:
    "course_books_bktype_check" CHECK (bktype::text = ANY (ARRAY['Text'::character varying::text, 'Reference'::character varying::text]))
Foreign-key constraints:
    "course_books_book_fkey" FOREIGN KEY (book) REFERENCES books(id)
    "course_books_course_fkey" FOREIGN KEY (course) REFERENCES courses(id)

         Table "public.course_enrolment_waitlist"
 Column  |            Type             | Modifiers
---------+-----------------------------+-----------
 student | integer                     | not null
 course  | integer                     | not null
 applied | timestamp without time zone | not null
Indexes:
    "course_enrolment_waitlist_pkey" PRIMARY KEY, btree (student, course)
Foreign-key constraints:
    "course_enrolment_waitlist_course_fkey" FOREIGN KEY (course) REFERENCES courses(id)
    "course_enrolment_waitlist_student_fkey" FOREIGN KEY (student) REFERENCES students(id)

    Table "public.course_enrolments"
 Column  |   Type    | Modifiers
---------+-----------+-----------
 student | integer   | not null
 course  | integer   | not null
 mark    | integer   |
 grade   | gradetype |
 stueval | integer   |
Indexes:
    "course_enrolments_pkey" PRIMARY KEY, btree (student, course)
Check constraints:
    "course_enrolments_mark_check" CHECK (mark >= 0 AND mark <= 100)
    "course_enrolments_stueval_check" CHECK (stueval >= 1 AND stueval <= 6)
Foreign-key constraints:
    "course_enrolments_course_fkey" FOREIGN KEY (course) REFERENCES courses(id)
    "course_enrolments_student_fkey" FOREIGN KEY (student) REFERENCES students(id)


     Table "public.course_quotas"
 Column |  Type   | Modifiers
--------+---------+-----------
 course | integer | not null
 sgroup | integer | not null
 quota  | integer | not null
Indexes:
    "course_quotas_pkey" PRIMARY KEY, btree (course, sgroup)
Foreign-key constraints:
    "course_quotas_course_fkey" FOREIGN KEY (course) REFERENCES courses(id)
    "course_quotas_sgroup_fkey" FOREIGN KEY (sgroup) REFERENCES student_groups(id)


     Table "public.course_staff"
 Column |  Type   | Modifiers
--------+---------+-----------
 course | integer | not null
 staff  | integer | not null
 role   | integer | not null
Indexes:
    "course_staff_pkey" PRIMARY KEY, btree (course, staff, role)
Foreign-key constraints:
    "course_staff_course_fkey" FOREIGN KEY (course) REFERENCES courses(id)
    "course_staff_role_fkey" FOREIGN KEY (role) REFERENCES staff_roles(id)
    "course_staff_staff_fkey" FOREIGN KEY (staff) REFERENCES staff(id)


          Table "public.courses"
  Column  |   Type    | Modifiers
----------+-----------+-----------
 id       | integer   | not null
 subject  | integer   | not null
 semester | integer   | not null
 homepage | urlstring |
Indexes:
    "courses_pkey" PRIMARY KEY, btree (id)
Foreign-key constraints:
    "courses_semester_fkey" FOREIGN KEY (semester) REFERENCES semesters(id)
    "courses_subject_fkey" FOREIGN KEY (subject) REFERENCES subjects(id)
Referenced by:
    TABLE "classes" CONSTRAINT "classes_course_fkey" FOREIGN KEY (course) REFERENCES courses(id)
    TABLE "course_books" CONSTRAINT "course_books_course_fkey" FOREIGN KEY (course) REFERENCES courses(id)
    TABLE "course_enrolment_waitlist" CONSTRAINT "course_enrolment_waitlist_course_fkey" FOREIGN KEY (course) REFERENCES courses(id)
    TABLE "course_enrolments" CONSTRAINT "course_enrolments_course_fkey" FOREIGN KEY (course) REFERENCES courses(id)
    TABLE "course_quotas" CONSTRAINT "course_quotas_course_fkey" FOREIGN KEY (course) REFERENCES courses(id)
    TABLE "course_staff" CONSTRAINT "course_staff_course_fkey" FOREIGN KEY (course) REFERENCES courses(id)



     Table "public.degree_types"
  Column   |     Type     | Modifiers
-----------+--------------+-----------
 id        | integer      | not null
 unswid    | shortname    | not null
 name      | mediumstring | not null
 prefix    | mediumstring |
 career    | careertype   |
 aqf_level | integer      |
Indexes:
    "degree_types_pkey" PRIMARY KEY, btree (id)
    "degree_types_unswid_key" UNIQUE CONSTRAINT, btree (unswid)
Check constraints:
    "degree_types_aqf_level_check" CHECK (aqf_level > 0)
Referenced by:
    TABLE "program_degrees" CONSTRAINT "program_degrees_dtype_fkey" FOREIGN KEY (dtype) REFERENCES degree_types(id)


     Table "public.degrees_awarded"
  Column   |  Type   | Modifiers
-----------+---------+-----------
 student   | integer | not null
 program   | integer | not null
 graduated | date    |
Indexes:
    "degrees_awarded_pkey" PRIMARY KEY, btree (student, program)
Foreign-key constraints:
    "degrees_awarded_program_fkey" FOREIGN KEY (program) REFERENCES programs(id)
    "degrees_awarded_student_fkey" FOREIGN KEY (student) REFERENCES students(id)


         Table "public.external_subjects"
   Column    |      Type      | Modifiers
-------------+----------------+-----------
 id          | integer        | not null
 extsubj     | longname       | not null
 institution | longname       | not null
 yearoffered | courseyeartype |
 equivto     | integer        | not null
Indexes:
    "external_subjects_pkey" PRIMARY KEY, btree (id)
Foreign-key constraints:
    "external_subjects_equivto_fkey" FOREIGN KEY (equivto) REFERENCES subjects(id)
Referenced by:
    TABLE "variations" CONSTRAINT "variations_extequiv_fkey" FOREIGN KEY (extequiv) REFERENCES external_subjects(id)


           Table "public.facilities"
   Column    |     Type     | Modifiers
-------------+--------------+-----------
 id          | integer      | not null
 description | mediumstring | not null
Indexes:
    "facilities_pkey" PRIMARY KEY, btree (id)
Referenced by:
    TABLE "room_facilities" CONSTRAINT "room_facilities_facility_fkey" FOREIGN KEY (facility) REFERENCES facilities(id)


    Table "public.orgunit_groups"
 Column |  Type   | Modifiers
--------+---------+-----------
 owner  | integer | not null
 member | integer | not null
Indexes:
    "orgunit_groups_pkey" PRIMARY KEY, btree (owner, member)
Foreign-key constraints:
    "orgunit_groups_member_fkey" FOREIGN KEY (member) REFERENCES orgunits(id)
    "orgunit_groups_owner_fkey" FOREIGN KEY (owner) REFERENCES orgunits(id)


      Table "public.orgunit_types"
 Column |   Type    | Modifiers
--------+-----------+-----------
 id     | integer   | not null
 name   | shortname | not null
Indexes:
    "orgunit_types_pkey" PRIMARY KEY, btree (id)
Referenced by:
    TABLE "orgunits" CONSTRAINT "orgunits_utype_fkey" FOREIGN KEY (utype) REFERENCES orgunit_types(id)



            Table "public.orgunits"
  Column  |     Type     | Modifiers
----------+--------------+-----------
 id       | integer      | not null
 utype    | integer      | not null
 name     | mediumstring | not null
 longname | longstring   |
 unswid   | shortstring  |
 phone    | phonenumber  |
 email    | emailstring  |
 website  | urlstring    |
 starting | date         |
 ending   | date         |
Indexes:
    "orgunits_pkey" PRIMARY KEY, btree (id)
Foreign-key constraints:
    "orgunits_utype_fkey" FOREIGN KEY (utype) REFERENCES orgunit_types(id)
Referenced by:
    TABLE "affiliations" CONSTRAINT "affiliations_orgunit_fkey" FOREIGN KEY (orgunit) REFERENCES orgunits(id)
    TABLE "orgunit_groups" CONSTRAINT "orgunit_groups_member_fkey" FOREIGN KEY (member) REFERENCES orgunits(id)
    TABLE "orgunit_groups" CONSTRAINT "orgunit_groups_owner_fkey" FOREIGN KEY (owner) REFERENCES orgunits(id)
    TABLE "programs" CONSTRAINT "programs_offeredby_fkey" FOREIGN KEY (offeredby) REFERENCES orgunits(id)
    TABLE "streams" CONSTRAINT "streams_offeredby_fkey" FOREIGN KEY (offeredby) REFERENCES orgunits(id)
    TABLE "subjects" CONSTRAINT "subjects_offeredby_fkey" FOREIGN KEY (offeredby) REFERENCES orgunits(id)



            Table "public.people"
  Column   |     Type     | Modifiers
-----------+--------------+-----------
 id        | integer      | not null
 unswid    | integer      |
 password  | shortstring  | not null
 family    | longname     |
 given     | longname     | not null
 title     | shortname    |
 sortname  | longname     | not null
 name      | longname     | not null
 street    | longstring   |
 city      | mediumstring |
 state     | mediumstring |
 postcode  | shortstring  |
 country   | integer      |
 homephone | phonenumber  |
 mobphone  | phonenumber  |
 email     | emailstring  | not null
 homepage  | urlstring    |
 gender    | character(1) |
 birthday  | date         |
 origin    | integer      |
Indexes:
    "people_pkey" PRIMARY KEY, btree (id)
    "people_unswid_key" UNIQUE CONSTRAINT, btree (unswid)
Check constraints:
    "people_gender_check" CHECK (gender = ANY (ARRAY['m'::bpchar, 'f'::bpchar]))
Foreign-key constraints:
    "people_country_fkey" FOREIGN KEY (country) REFERENCES countries(id)
    "people_origin_fkey" FOREIGN KEY (origin) REFERENCES countries(id)
Referenced by:
    TABLE "staff" CONSTRAINT "staff_id_fkey" FOREIGN KEY (id) REFERENCES people(id)
    TABLE "students" CONSTRAINT "students_id_fkey" FOREIGN KEY (id) REFERENCES people(id)



       Table "public.program_degrees"
 Column  |     Type     | Modifiers
---------+--------------+-----------
 id      | integer      | not null
 program | integer      |
 dtype   | integer      |
 name    | longstring   | not null
 abbrev  | mediumstring |
Indexes:
    "program_degrees_pkey" PRIMARY KEY, btree (id)
Foreign-key constraints:
    "program_degrees_dtype_fkey" FOREIGN KEY (dtype) REFERENCES degree_types(id)
    "program_degrees_program_fkey" FOREIGN KEY (program) REFERENCES programs(id)


     Table "public.program_enrolments"
  Column  |    Type    | Modifiers
----------+------------+-----------
 id       | integer    | not null
 student  | integer    | not null
 semester | integer    | not null
 program  | integer    | not null
 wam      | real       |
 standing | integer    |
 advisor  | integer    |
 notes    | textstring |
Indexes:
    "program_enrolments_pkey" PRIMARY KEY, btree (id)
Foreign-key constraints:
    "program_enrolments_advisor_fkey" FOREIGN KEY (advisor) REFERENCES staff(id)
    "program_enrolments_program_fkey" FOREIGN KEY (program) REFERENCES programs(id)
    "program_enrolments_semester_fkey" FOREIGN KEY (semester) REFERENCES semesters(id)
    "program_enrolments_standing_fkey" FOREIGN KEY (standing) REFERENCES academic_standing(id)
    "program_enrolments_student_fkey" FOREIGN KEY (student) REFERENCES students(id)
Referenced by:
    TABLE "stream_enrolments" CONSTRAINT "stream_enrolments_partof_fkey" FOREIGN KEY (partof) REFERENCES program_enrolments(id)



    Table "public.program_group_members"
  Column  |  Type   | Modifiers
----------+---------+-----------
 program  | integer | not null
 ao_group | integer | not null
Indexes:
    "program_group_members_pkey" PRIMARY KEY, btree (program, ao_group)
Foreign-key constraints:
    "program_group_members_ao_group_fkey" FOREIGN KEY (ao_group) REFERENCES acad_object_groups(id)
    "program_group_members_program_fkey" FOREIGN KEY (program) REFERENCES programs(id)



            Table "public.programs"
   Column    |     Type     | Modifiers
-------------+--------------+-----------
 id          | integer      | not null
 code        | character(4) | not null
 name        | longname     | not null
 uoc         | integer      |
 offeredby   | integer      |
 career      | careertype   |
 duration    | integer      |
 description | textstring   |
 firstoffer  | integer      |
 lastoffer   | integer      |
Indexes:
    "programs_pkey" PRIMARY KEY, btree (id)
Check constraints:
    "programs_uoc_check" CHECK (uoc >= 0)
Foreign-key constraints:
    "programs_firstoffer_fkey" FOREIGN KEY (firstoffer) REFERENCES semesters(id)
    "programs_lastoffer_fkey" FOREIGN KEY (lastoffer) REFERENCES semesters(id)
    "programs_offeredby_fkey" FOREIGN KEY (offeredby) REFERENCES orgunits(id)
Referenced by:
    TABLE "degrees_awarded" CONSTRAINT "degrees_awarded_program_fkey" FOREIGN KEY (program) REFERENCES programs(id)
    TABLE "program_degrees" CONSTRAINT "program_degrees_program_fkey" FOREIGN KEY (program) REFERENCES programs(id)
    TABLE "program_enrolments" CONSTRAINT "program_enrolments_program_fkey" FOREIGN KEY (program) REFERENCES programs(id)
    TABLE "program_group_members" CONSTRAINT "program_group_members_program_fkey" FOREIGN KEY (program) REFERENCES programs(id)
    TABLE "variations" CONSTRAINT "variations_program_fkey" FOREIGN KEY (program) REFERENCES programs(id)



         Table "public.public_holidays"
   Column    |     Type     | Modifiers
-------------+--------------+-----------
 semester    | integer      |
 description | mediumstring |
 day         | date         |
Foreign-key constraints:
    "public_holidays_semester_fkey" FOREIGN KEY (semester) REFERENCES semesters(id)


     Table "public.room_facilities"
  Column  |  Type   | Modifiers
----------+---------+-----------
 room     | integer | not null
 facility | integer | not null
Indexes:
    "room_facilities_pkey" PRIMARY KEY, btree (room, facility)
Foreign-key constraints:
    "room_facilities_facility_fkey" FOREIGN KEY (facility) REFERENCES facilities(id)
    "room_facilities_room_fkey" FOREIGN KEY (room) REFERENCES rooms(id)


           Table "public.room_types"
   Column    |     Type     | Modifiers
-------------+--------------+-----------
 id          | integer      | not null
 description | mediumstring | not null
Indexes:
    "room_types_pkey" PRIMARY KEY, btree (id)
Referenced by:
    TABLE "rooms" CONSTRAINT "rooms_rtype_fkey" FOREIGN KEY (rtype) REFERENCES room_types(id)



           Table "public.rooms"
  Column  |    Type     | Modifiers
----------+-------------+-----------
 id       | integer     | not null
 unswid   | shortstring | not null
 rtype    | integer     |
 name     | shortname   | not null
 longname | longname    |
 building | integer     |
 capacity | integer     |
Indexes:
    "rooms_pkey" PRIMARY KEY, btree (id)
    "rooms_unswid_key" UNIQUE CONSTRAINT, btree (unswid)
Check constraints:
    "rooms_capacity_check" CHECK (capacity >= 0)
Foreign-key constraints:
    "rooms_building_fkey" FOREIGN KEY (building) REFERENCES buildings(id)
    "rooms_rtype_fkey" FOREIGN KEY (rtype) REFERENCES room_types(id)
Referenced by:
    TABLE "classes" CONSTRAINT "classes_room_fkey" FOREIGN KEY (room) REFERENCES rooms(id)
    TABLE "room_facilities" CONSTRAINT "room_facilities_room_fkey" FOREIGN KEY (room) REFERENCES rooms(id)
    TABLE "staff" CONSTRAINT "staff_office_fkey" FOREIGN KEY (office) REFERENCES rooms(id)


           Table "public.semesters"
  Column  |      Type      | Modifiers
----------+----------------+-----------
 id       | integer        | not null
 unswid   | integer        | not null
 year     | courseyeartype |
 term     | character(2)   | not null
 name     | shortname      | not null
 longname | longname       | not null
 starting | date           | not null
 ending   | date           | not null
 startbrk | date           |
 endbrk   | date           |
 endwd    | date           |
 endenrol | date           |
 census   | date           |
Indexes:
    "semesters_pkey" PRIMARY KEY, btree (id)
    "semesters_unswid_key" UNIQUE CONSTRAINT, btree (unswid)
Check constraints:
    "semesters_term_check" CHECK (term = ANY (ARRAY['S1'::bpchar, 'S2'::bpchar, 'X1'::bpchar, 'X2'::bpchar]))
Referenced by:
    TABLE "courses" CONSTRAINT "courses_semester_fkey" FOREIGN KEY (semester) REFERENCES semesters(id)
    TABLE "program_enrolments" CONSTRAINT "program_enrolments_semester_fkey" FOREIGN KEY (semester) REFERENCES semesters(id)
    TABLE "programs" CONSTRAINT "programs_firstoffer_fkey" FOREIGN KEY (firstoffer) REFERENCES semesters(id)
    TABLE "programs" CONSTRAINT "programs_lastoffer_fkey" FOREIGN KEY (lastoffer) REFERENCES semesters(id)
    TABLE "public_holidays" CONSTRAINT "public_holidays_semester_fkey" FOREIGN KEY (semester) REFERENCES semesters(id)
    TABLE "streams" CONSTRAINT "streams_firstoffer_fkey" FOREIGN KEY (firstoffer) REFERENCES semesters(id)
    TABLE "streams" CONSTRAINT "streams_lastoffer_fkey" FOREIGN KEY (lastoffer) REFERENCES semesters(id)
    TABLE "subjects" CONSTRAINT "subjects_firstoffer_fkey" FOREIGN KEY (firstoffer) REFERENCES semesters(id)
    TABLE "subjects" CONSTRAINT "subjects_lastoffer_fkey" FOREIGN KEY (lastoffer) REFERENCES semesters(id)


             Table "public.staff"
   Column   |    Type     | Modifiers
------------+-------------+-----------
 id         | integer     | not null
 office     | integer     |
 phone      | phonenumber |
 employed   | date        | not null
 supervisor | integer     |
Indexes:
    "staff_pkey" PRIMARY KEY, btree (id)
Foreign-key constraints:
    "staff_id_fkey" FOREIGN KEY (id) REFERENCES people(id)
    "staff_office_fkey" FOREIGN KEY (office) REFERENCES rooms(id)
    "staff_supervisor_fkey" FOREIGN KEY (supervisor) REFERENCES staff(id)
Referenced by:
    TABLE "affiliations" CONSTRAINT "affiliations_staff_fkey" FOREIGN KEY (staff) REFERENCES staff(id)
    TABLE "class_teachers" CONSTRAINT "class_teachers_teacher_fkey" FOREIGN KEY (teacher) REFERENCES staff(id)
    TABLE "course_staff" CONSTRAINT "course_staff_staff_fkey" FOREIGN KEY (staff) REFERENCES staff(id)
    TABLE "program_enrolments" CONSTRAINT "program_enrolments_advisor_fkey" FOREIGN KEY (advisor) REFERENCES staff(id)
    TABLE "staff" CONSTRAINT "staff_supervisor_fkey" FOREIGN KEY (supervisor) REFERENCES staff(id)
    TABLE "variations" CONSTRAINT "variations_approver_fkey" FOREIGN KEY (approver) REFERENCES staff(id)


       Table "public.staff_role_classes"
   Column    |     Type     | Modifiers
-------------+--------------+-----------
 id          | character(1) | not null
 description | shortstring  |
Indexes:
    "staff_role_classes_pkey" PRIMARY KEY, btree (id)
Referenced by:
    TABLE "staff_roles" CONSTRAINT "staff_roles_rclass_fkey" FOREIGN KEY (rclass) REFERENCES staff_role_classes(id)


        Table "public.staff_role_types"
   Column    |     Type     | Modifiers
-------------+--------------+-----------
 id          | character(1) | not null
 description | shortstring  |
Indexes:
    "staff_role_types_pkey" PRIMARY KEY, btree (id)
Referenced by:
    TABLE "staff_roles" CONSTRAINT "staff_roles_rtype_fkey" FOREIGN KEY (rtype) REFERENCES staff_role_types(id)



           Table "public.staff_roles"
   Column    |     Type     | Modifiers
-------------+--------------+-----------
 id          | integer      | not null
 rtype       | character(1) |
 rclass      | character(1) |
 name        | longstring   | not null
 description | longstring   |
Indexes:
    "staff_roles_pkey" PRIMARY KEY, btree (id)
Foreign-key constraints:
    "staff_roles_rclass_fkey" FOREIGN KEY (rclass) REFERENCES staff_role_classes(id)
    "staff_roles_rtype_fkey" FOREIGN KEY (rtype) REFERENCES staff_role_types(id)
Referenced by:
    TABLE "affiliations" CONSTRAINT "affiliations_role_fkey" FOREIGN KEY (role) REFERENCES staff_roles(id)
    TABLE "course_staff" CONSTRAINT "course_staff_role_fkey" FOREIGN KEY (role) REFERENCES staff_roles(id)



    Table "public.stream_enrolments"
 Column |  Type   | Modifiers
--------+---------+-----------
 partof | integer | not null
 stream | integer | not null
Indexes:
    "stream_enrolments_pkey" PRIMARY KEY, btree (partof, stream)
Foreign-key constraints:
    "stream_enrolments_partof_fkey" FOREIGN KEY (partof) REFERENCES program_enrolments(id)
    "stream_enrolments_stream_fkey" FOREIGN KEY (stream) REFERENCES streams(id)



    Table "public.stream_group_members"
  Column  |  Type   | Modifiers
----------+---------+-----------
 stream   | integer | not null
 ao_group | integer | not null
Indexes:
    "stream_group_members_pkey" PRIMARY KEY, btree (stream, ao_group)
Foreign-key constraints:
    "stream_group_members_ao_group_fkey" FOREIGN KEY (ao_group) REFERENCES acad_object_groups(id)
    "stream_group_members_stream_fkey" FOREIGN KEY (stream) REFERENCES streams(id)


          Table "public.stream_types"
   Column    |     Type     | Modifiers
-------------+--------------+-----------
 id          | integer      | not null
 career      | careertype   | not null
 code        | character(1) | not null
 description | shortstring  | not null
Indexes:
    "stream_types_pkey" PRIMARY KEY, btree (id)
Referenced by:
    TABLE "streams" CONSTRAINT "streams_stype_fkey" FOREIGN KEY (stype) REFERENCES stream_types(id)


             Table "public.streams"
   Column    |     Type     | Modifiers
-------------+--------------+-----------
 id          | integer      | not null
 code        | character(6) | not null
 name        | longname     | not null
 offeredby   | integer      |
 stype       | integer      |
 description | textstring   |
 firstoffer  | integer      |
 lastoffer   | integer      |
Indexes:
    "streams_pkey" PRIMARY KEY, btree (id)
Foreign-key constraints:
    "streams_firstoffer_fkey" FOREIGN KEY (firstoffer) REFERENCES semesters(id)
    "streams_lastoffer_fkey" FOREIGN KEY (lastoffer) REFERENCES semesters(id)
    "streams_offeredby_fkey" FOREIGN KEY (offeredby) REFERENCES orgunits(id)
    "streams_stype_fkey" FOREIGN KEY (stype) REFERENCES stream_types(id)
Referenced by:
    TABLE "stream_enrolments" CONSTRAINT "stream_enrolments_stream_fkey" FOREIGN KEY (stream) REFERENCES streams(id)
    TABLE "stream_group_members" CONSTRAINT "stream_group_members_stream_fkey" FOREIGN KEY (stream) REFERENCES streams(id)



        Table "public.student_groups"
   Column   |    Type    | Modifiers
------------+------------+-----------
 id         | integer    | not null
 name       | longname   | not null
 definition | textstring | not null
Indexes:
    "student_groups_pkey" PRIMARY KEY, btree (id)
    "student_groups_name_key" UNIQUE CONSTRAINT, btree (name)
Referenced by:
    TABLE "course_quotas" CONSTRAINT "course_quotas_sgroup_fkey" FOREIGN KEY (sgroup) REFERENCES student_groups(id)


              Table "public.students"
 Column |         Type         | Modifiers
--------+----------------------+-----------
 id     | integer              | not null
 stype  | character varying(5) |
Indexes:
    "students_pkey" PRIMARY KEY, btree (id)
Check constraints:
    "students_stype_check" CHECK (stype::text = ANY (ARRAY['local'::character varying::text, 'intl'::character varying::text]))
Foreign-key constraints:
    "students_id_fkey" FOREIGN KEY (id) REFERENCES people(id)
Referenced by:
    TABLE "class_enrolment_waitlist" CONSTRAINT "class_enrolment_waitlist_student_fkey" FOREIGN KEY (student) REFERENCES students(id)
    TABLE "class_enrolments" CONSTRAINT "class_enrolments_student_fkey" FOREIGN KEY (student) REFERENCES students(id)
    TABLE "course_enrolment_waitlist" CONSTRAINT "course_enrolment_waitlist_student_fkey" FOREIGN KEY (student) REFERENCES students(id)
    TABLE "course_enrolments" CONSTRAINT "course_enrolments_student_fkey" FOREIGN KEY (student) REFERENCES students(id)
    TABLE "degrees_awarded" CONSTRAINT "degrees_awarded_student_fkey" FOREIGN KEY (student) REFERENCES students(id)
    TABLE "program_enrolments" CONSTRAINT "program_enrolments_student_fkey" FOREIGN KEY (student) REFERENCES students(id)
    TABLE "variations" CONSTRAINT "variations_student_fkey" FOREIGN KEY (student) REFERENCES students(id)


    Table "public.subject_group_members"
  Column  |  Type   | Modifiers
----------+---------+-----------
 subject  | integer | not null
 ao_group | integer | not null
Indexes:
    "subject_group_members_pkey" PRIMARY KEY, btree (subject, ao_group)
Foreign-key constraints:
    "subject_group_members_ao_group_fkey" FOREIGN KEY (ao_group) REFERENCES acad_object_groups(id)
    "subject_group_members_subject_fkey" FOREIGN KEY (subject) REFERENCES subjects(id)



              Table "public.subjects"
   Column    |       Type       | Modifiers
-------------+------------------+-----------
 id          | integer          | not null
 code        | character(8)     | not null
 name        | mediumname       | not null
 longname    | longname         |
 uoc         | integer          |
 offeredby   | integer          |
 eftsload    | double precision |
 career      | careertype       |
 syllabus    | textstring       |
 contacthpw  | double precision |
 _excluded   | text             |
 excluded    | integer          |
 _equivalent | text             |
 equivalent  | integer          |
 _prereq     | text             |
 prereq      | integer          |
 replaces    | integer          |
 firstoffer  | integer          |
 lastoffer   | integer          |
Indexes:
    "subjects_pkey" PRIMARY KEY, btree (id)
Check constraints:
    "subjects_uoc_check" CHECK (uoc >= 0)
Foreign-key constraints:
    "subjects_equivalent_fkey" FOREIGN KEY (equivalent) REFERENCES acad_object_groups(id)
    "subjects_excluded_fkey" FOREIGN KEY (excluded) REFERENCES acad_object_groups(id)
    "subjects_firstoffer_fkey" FOREIGN KEY (firstoffer) REFERENCES semesters(id)
    "subjects_lastoffer_fkey" FOREIGN KEY (lastoffer) REFERENCES semesters(id)
    "subjects_offeredby_fkey" FOREIGN KEY (offeredby) REFERENCES orgunits(id)
    "subjects_replaces_fkey" FOREIGN KEY (replaces) REFERENCES subjects(id)
Referenced by:
    TABLE "courses" CONSTRAINT "courses_subject_fkey" FOREIGN KEY (subject) REFERENCES subjects(id)
    TABLE "external_subjects" CONSTRAINT "external_subjects_equivto_fkey" FOREIGN KEY (equivto) REFERENCES subjects(id)
    TABLE "subject_group_members" CONSTRAINT "subject_group_members_subject_fkey" FOREIGN KEY (subject) REFERENCES subjects(id)
    TABLE "subjects" CONSTRAINT "subjects_replaces_fkey" FOREIGN KEY (replaces) REFERENCES subjects(id)
    TABLE "variations" CONSTRAINT "variations_intequiv_fkey" FOREIGN KEY (intequiv) REFERENCES subjects(id)
    TABLE "variations" CONSTRAINT "variations_subject_fkey" FOREIGN KEY (subject) REFERENCES subjects(id)



            Table "public.variations"
   Column   |      Type      | Modifiers
------------+----------------+-----------
 student    | integer        | not null
 program    | integer        | not null
 subject    | integer        | not null
 vtype      | variationtype  | not null
 intequiv   | integer        |
 extequiv   | integer        |
 yearpassed | courseyeartype |
 mark       | integer        |
 approver   | integer        | not null
 approved   | date           | not null
Indexes:
    "variations_pkey" PRIMARY KEY, btree (student, program, subject)
Check constraints:
    "twocases" CHECK (intequiv IS NULL AND extequiv IS NOT NULL OR intequiv IS NOT NULL AND extequiv IS NULL)
    "variations_mark_check" CHECK (mark > 0)
Foreign-key constraints:
    "variations_approver_fkey" FOREIGN KEY (approver) REFERENCES staff(id)
    "variations_extequiv_fkey" FOREIGN KEY (extequiv) REFERENCES external_subjects(id)
    "variations_intequiv_fkey" FOREIGN KEY (intequiv) REFERENCES subjects(id)
    "variations_program_fkey" FOREIGN KEY (program) REFERENCES programs(id)
    "variations_student_fkey" FOREIGN KEY (student) REFERENCES students(id)
    "variations_subject_fkey" FOREIGN KEY (subject) REFERENCES subjects(id)


