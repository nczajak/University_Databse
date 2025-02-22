--Uprawnienia goœcia ( osoby niebêd¹cej uczestnikiem ani pracownikiem systemu)

GRANT SELECT ON webinar TO guest
GRANT SELECT ON webinarDetails TO guest
GRANT SELECT ON course TO guest
GRANT SELECT ON courseDetails TO guest
GRANT SELECT ON class TO guest
GRANT SELECT ON products TO guest
GRANT SELECT ON major TO guest


GRANT INSERT, SELECT ON dbo.participant TO guest;
GRANT EXECUTE ON create_new_participant TO guest
GRANT SELECT ON studies_for_sale TO guest
GRANT SELECT ON courses_for_sale TO guest
GRANT SELECT ON webinars_for_sale TO guest
GRANT SELECT ON conventions_for_sale TO guest
GRANT SELECT ON available_products TO guest
GRANT SELECT ON class_syllabus TO guest


--Uprawnienia uczestnika

CREATE ROLE participant


-- Wszystkie uprawnienia dla goœcia
GRANT EXECUTE ON create_new_participant TO guest
GRANT SELECT ON studies_for_sale TO participant
GRANT SELECT ON courses_for_sale TO participant
GRANT SELECT ON webinars_for_sale TO participant
GRANT SELECT ON conventions_for_sale TO participant
GRANT SELECT ON available_products TO participant
GRANT SELECT ON class_syllabus TO participant

GRANT SELECT ON cart TO participant

GRANT SELECT, INSERT ON orders TO participant
GRANT SELECT, INSERT ON orderDetails TO participant
GRANT SELECT ON orderStatus to participant

GRANT EXECUTE ON add_product_to_order TO participant
GRANT EXECUTE ON create_order TO participant
GRANT EXECUTE ON buy_product TO participant
GRANT EXECUTE ON GetOrderValue TO participant
GRANT EXECUTE ON WasPresentOn TO participant
GRANT EXECUTE ON StudentPresence TO participant

GRANT SELECT ON course TO participant
GRANT SELECT ON courseDetails TO participant
GRANT SELECT ON webinar TO participant
GRANT SELECT ON webinarDetails TO participant
GRANT SELECT ON class TO participant
GRANT SELECT ON convention TO participant
GRANT SELECT ON meeting TO participant
GRANT SELECT ON meetingTime TO participant
GRANT SELECT ON asyncMeetingDetails TO participant
GRANT SELECT ON stationaryMeeting TO participant
GRANT SELECT ON onlineAsyncMeeting TO participant
GRANT SELECT ON internship TO participant
GRANT SELECT ON meetingMode to participant
GRANT SELECT ON studySchedule TO participant
GRANT SELECT ON moduleSchedule TO participant

/*Mo¿liwoœæ tworzenia zamówieñ, dodawania produktów do koszyka, ogl¹dania koszyka i kupowania produktów
Mo¿liwoœæ przegl¹dania danych dotycz¹cych kursów, studiów, webinarów i zjazdów*/

--Uprawnienia instruktora

CREATE ROLE instructor

-- wszystkie uprawnienia poprzednich ról –

GRANT SELECT ON future_meetings_participants TO instructor
GRANT SELECT ON meeting_attendance TO instructor
GRANT SELECT ON meeting_attendance_details TO instructor
GRANT SELECT ON meeting_information_report TO instructor

GRANT EXECUTE ON AccesToCourse TO instructor
GRANT EXECUTE ON AccesToWebinar TO instructor
GRANT EXECUTE ON create_student TO instructor
GRANT EXECUTE ON delete_student TO instructor
GRANT EXECUTE ON create_finalExam TO instructor
GRANT EXECUTE ON change_finalExam TO instructor
GRANT EXECUTE ON HowManyStudyVacancies TO instructor
GRANT EXECUTE ON SignedForMeeting TO instructor
GRANT EXECUTE ON StudentPresence TO instructor
GRANT EXECUTE ON WasPresentOn TO instructor
GRANT EXECUTE ON UpcomingMeetings TO instructor
GRANT EXECUTE ON assign_new_subject_to_instructor TO instructor
GRANT EXECUTE ON create_internship TO instructor

GRANT SELECT ON instructor TO instructor
GRANT SELECT ON building TO instructor
GRANT SELECT ON company TO instructor
GRANT SELECT ON employee TO instructor
GRANT SELECT, INSERT, ALTER ON finalExam TO instructor
GRANT SELECT ON instructor TO instructor
GRANT SELECT ON instructorDetails TO instructor
GRANT SELECT, INSERT ON courseParticipants TO instructor
GRANT SELECT, INSERT ON internshipDetails TO instructor
GRANT SELECT, INSERT ON webinarParticipants TO instructor
GRANT SELECT, INSERT, DELETE ON students TO instructor
GRANT SELECT ON internshipSupervisor TO instructor
GRANT SELECT ON language TO instructor
GRANT SELECT ON president TO instructor
GRANT SELECT ON rooms to instructor
GRANT SELECT, INSERT ON roomDetails TO instructor
GRANT SELECT ON translator TO instructor
GRANT SELECT ON translatorDetails TO instructor



/*dostêp do informacji o listach uczestników kursów, studiów, webinarów
mo¿liwoœæ dodawania uczestników kursów, webinarów, studiów
mo¿liwoœæ dodawania obecnoœci do wydarzeñ
mo¿liwoœæ dodawania informacji o ocenach 
dostêp do odczytu wiêkszoœci tabel
rola instruktor jest przypisywana prowadz¹cym zajêcia, wyk³adowcom oraz kierownikom praktyk.*/

--Uprawnienia t³umacza

CREATE ROLE translator

-- Wszystkie uprawnienia dla uczestnika ---

GRANT SELECT ON translator TO instructor
GRANT SELECT, INSERT ON translatorDetails TO instructor

--T³umacz, oprócz uprawnieñ uczestnika ma równie¿ dostêp do danych o t³umaczach oraz zmiany kompetencji t³umacza

--Uprawnienia koordynatora zajêæ 

--Koordynator zajêæ posiada uprawnienia do dodawania kursów, webinarów, zjazdów, oraz studiów do wszystkich niezbêdnych czynnoœci aby mieæ kontrolê nad zajêciami.

create role products_coordinator

GRANT SELECT, INSERT ON webinar TO products_coordinator
GRANT SELECT, INSERT ON webinarDetails TO products_coordinator
GRANT SELECT, INSERT ON course TO products_coordinator
GRANT SELECT, INSERT ON courseDetails TO products_coordinator
GRANT SELECT, INSERT ON class TO products_coordinator
GRANT SELECT, INSERT ON products TO products_coordinator
GRANT SELECT ON major TO products_coordinator
GRANT SELECT, INSERT ON course TO products_coordinator
GRANT SELECT, INSERT ON courseDetails TO products_coordinator
GRANT SELECT, INSERT ON class TO products_coordinator
GRANT SELECT, INSERT ON convention TO products_coordinator
GRANT SELECT, INSERT ON meeting TO products_coordinator
GRANT SELECT, INSERT ON meetingTime TO products_coordinator
GRANT SELECT, INSERT ON asyncMeetingDetails TO products_coordinator
GRANT SELECT, INSERT ON stationaryMeeting TO products_coordinator
GRANT SELECT, INSERT ON onlineAsyncMeeting TO products_coordinator
GRANT SELECT, INSERT ON internship TO products_coordinator
GRANT SELECT ON meetingMode to products_coordinator
GRANT SELECT, INSERT ON studySchedule TO products_coordinator
GRANT SELECT, INSERT ON moduleSchedule TO products_coordinator
GRANT SELECT ON instructor TO products_coordinator
GRANT SELECT ON building TO products_coordinator
GRANT SELECT ON company TO products_coordinator
GRANT SELECT ON instructor TO products_coordinator
GRANT SELECT, INSERT ON instructorDetails TO products_coordinator
GRANT SELECT ON internshipSupervisor TO products_coordinator
GRANT SELECT ON language TO products_coordinator
GRANT SELECT ON president TO products_coordinator
GRANT SELECT ON rooms to products_coordinator
GRANT SELECT ON roomDetails TO products_coordinator
GRANT SELECT ON translator TO products_coordinator
GRANT SELECT, INSERT ON translatorDetails TO products_coordinator
GRANT SELECT ON conventionType TO products_coordinator
GRANT SELECT, INSERT ON module TO products_coordinator
GRANT SELECT ON moduleTypes TO products_coordinator
GRANT SELECT ON productTypes TO products_coordinator
GRANT SELECT ON subject TO products_coordinator
GRANT SELECT, INSERT ON syllabus TO products_coordinator
GRANT SELECT ON titles TO products_coordinator
GRANT SELECT ON studies_for_sale TO products_coordinator
GRANT SELECT ON courses_for_sale TO products_coordinator
GRANT SELECT ON webinars_for_sale TO products_coordinator
GRANT SELECT ON conventions_for_sale TO products_coordinator
GRANT SELECT ON available_products TO products_coordinator
GRANT SELECT ON class_syllabus TO products_coordinator
GRANT EXECUTE ON create_syllabus TO products_coordinator
GRANT EXECUTE ON create_internship TO products_coordinator
GRANT EXECUTE ON create_class TO products_coordinator
GRANT EXECUTE ON create_webinar TO products_coordinator
GRANT EXECUTE ON create_course TO products_coordinator
GRANT EXECUTE ON create_convention TO products_coordinator
GRANT EXECUTE ON create_module TO products_coordinator
GRANT EXECUTE ON create_stationary_meeting TO products_coordinator
GRANT EXECUTE ON HowManyStudyVacancies TO products_coordinator


--Uprawnienia dyrektora 

--Dyrektor posiada uprawnienia do przegl¹dania wszystkich tabel oraz wstawiania do nich danych.
--Mo¿e tak¿e korzystaæ z wszystkich funkcji oraz procedur.


create role president

GRANT SELECT, INSERT ON webinar TO president
GRANT SELECT, INSERT ON webinarDetails TO president
GRANT SELECT, INSERT ON course TO president
GRANT SELECT, INSERT ON courseDetails TO president
GRANT SELECT, INSERT ON class TO president
GRANT SELECT, INSERT ON products TO president
GRANT SELECT, INSERT ON major TO president
GRANT SELECT, INSERT ON course TO president
GRANT SELECT, INSERT ON courseDetails TO president
GRANT SELECT, INSERT ON class TO president
GRANT SELECT, INSERT ON convention TO president
GRANT SELECT, INSERT ON meeting TO president
GRANT SELECT, INSERT ON meetingTime TO president
GRANT SELECT, INSERT ON asyncMeetingDetails TO president
GRANT SELECT, INSERT ON stationaryMeeting TO president
GRANT SELECT, INSERT ON onlineAsyncMeeting TO president
GRANT SELECT, INSERT ON internship TO president
GRANT SELECT, INSERT ON meetingMode to president
GRANT SELECT, INSERT ON studySchedule TO president
GRANT SELECT, INSERT ON moduleSchedule TO president
GRANT SELECT, INSERT ON instructor TO president
GRANT SELECT, INSERT ON building TO president
GRANT SELECT, INSERT ON company TO president
GRANT SELECT, INSERT ON employee TO president
GRANT SELECT, INSERT ON finalExam TO president
GRANT SELECT, INSERT ON instructor TO president
GRANT SELECT, INSERT ON instructorDetails TO president
GRANT SELECT, INSERT ON courseParticipants TO president
GRANT SELECT, INSERT ON internshipDetails TO president
GRANT SELECT, INSERT ON webinarParticipants TO president
GRANT SELECT, INSERT ON internshipSupervisor TO president
GRANT SELECT, INSERT ON language TO president
GRANT SELECT, INSERT ON president TO president
GRANT SELECT, INSERT ON rooms to president
GRANT SELECT, INSERT ON roomDetails TO president
GRANT SELECT, INSERT ON translator TO president
GRANT SELECT, INSERT ON translatorDetails TO president
GRANT SELECT, INSERT ON conventionDetails TO president
GRANT SELECT, INSERT ON conventionType TO president
GRANT SELECT, INSERT ON courseParticipants TO president
GRANT SELECT, INSERT ON module TO president
GRANT SELECT, INSERT ON moduleTypes TO president
GRANT SELECT, INSERT ON orderDetails TO president
GRANT SELECT, INSERT ON orderStatus TO president
GRANT SELECT, INSERT ON orders TO president
GRANT SELECT, INSERT ON participant TO president
GRANT SELECT, INSERT ON paymentDeferral TO president
GRANT SELECT, INSERT ON productTypes TO president
GRANT SELECT, INSERT ON students TO president
GRANT SELECT, INSERT ON subject TO president
GRANT SELECT, INSERT ON syllabus TO president
GRANT SELECT, INSERT ON titles TO president
GRANT SELECT ON studies_for_sale TO president
GRANT SELECT ON courses_for_sale TO president
GRANT SELECT ON webinars_for_sale TO president
GRANT SELECT ON conventions_for_sale TO president
GRANT SELECT ON available_products TO president
GRANT SELECT ON class_syllabus TO president
GRANT SELECT ON future_meetings_participants TO president
GRANT SELECT ON meeting_attendance TO president
GRANT SELECT ON meeting_attendance_details TO president
GRANT SELECT ON meeting_information_report TO president
GRANT SELECT ON cart TO president
GRANT SELECT ON list_of_all_debtors TO president
GRANT SELECT ON webinar_income_list TO president
GRANT SELECT ON courses_income_list_with_status TO president
GRANT SELECT ON courses_income_list TO president
GRANT SELECT ON class_income_list TO president
GRANT SELECT ON convention_income_list TO president
GRANT SELECT ON collision_list TO president
GRANT EXECUTE ON create_new_participant TO president
GRANT EXECUTE ON add_product_to_order TO president
GRANT EXECUTE ON create_order TO president
GRANT EXECUTE ON buy_product TO president
GRANT EXECUTE ON GetOrderValue TO president
GRANT EXECUTE ON AccesToCourse TO president
GRANT EXECUTE ON AccesToWebinar TO president
GRANT EXECUTE ON create_student TO president
GRANT EXECUTE ON create_finalExam TO president
GRANT EXECUTE ON create_translator TO president
GRANT EXECUTE ON create_internshipSupervisor TO president
GRANT EXECUTE ON create_new_title TO president
GRANT EXECUTE ON create_president TO president
GRANT EXECUTE ON create_instructor TO president
GRANT EXECUTE ON change_instructor_title TO president
GRANT EXECUTE ON create_new_language TO president
GRANT EXECUTE ON assign_new_language_to_translator TO president
GRANT EXECUTE ON assign_new_subject_to_instructor TO president
GRANT EXECUTE ON create_new_subject TO president
GRANT EXECUTE ON change_president_title TO president
GRANT EXECUTE ON delete_student TO president
GRANT EXECUTE ON create_new_major TO president
GRANT EXECUTE ON create_syllabus TO president
GRANT EXECUTE ON create_company TO president
GRANT EXECUTE ON create_internship TO president
GRANT EXECUTE ON create_class TO president
GRANT EXECUTE ON change_finalExam TO president
GRANT EXECUTE ON create_webinar TO president
GRANT EXECUTE ON create_webinarParticipants TO president
GRANT EXECUTE ON create_course TO president
GRANT EXECUTE ON create_convention TO president
GRANT EXECUTE ON create_module TO president
GRANT EXECUTE ON create_stationary_meeting TO president
GRANT EXECUTE ON GetOrderValue TO president
GRANT EXECUTE ON HowManyStudyVacancies TO president
GRANT EXECUTE ON WasPresentOn  TO president
GRANT EXECUTE ON StudentPresence TO president
GRANT EXECUTE ON ProductIncome TO president
GRANT EXECUTE ON SignedForMeeting TO president
GRANT EXECUTE ON AccesToWebinar TO president

--Uprawnienia administratora systemu 

create role admin

--Administrator systemu posiada uprawnienia takie jak dyrektor.

--Uprawnienia ksiêgowego

--Ksiêgowy posiada uprawnienia pozwalaj¹ce na kontrolowania transakcji w systemie oraz przychodów firmy.

create role accountant

GRANT SELECT ON products TO accountant
GRANT SELECT, UPDATE ON orderDetails TO accountant
GRANT SELECT ON orderStatus TO accountant
GRANT SELECT ON orders TO accountant
GRANT SELECT ON class TO accountant
GRANT SELECT ON major TO accountant
GRANT SELECT ON course TO accountant
GRANT SELECT ON webinar TO accountant
GRANT SELECT ON convention TO accountant
GRANT SELECT ON participant TO accountant
GRANT SELECT ON paymentDeferral TO accountant
GRANT SELECT ON studies_for_sale TO accountant
GRANT SELECT ON courses_for_sale TO accountant
GRANT SELECT ON webinars_for_sale TO accountant
GRANT SELECT ON conventions_for_sale TO accountant
GRANT SELECT ON available_products TO accountant
GRANT SELECT ON cart TO accountant
GRANT SELECT ON list_of_all_debtors TO accountant
GRANT SELECT ON webinar_income_list TO accountant
GRANT SELECT ON courses_income_list_with_status TO accountant
GRANT SELECT ON courses_income_list TO accountant
GRANT SELECT ON class_income_list TO accountant
GRANT SELECT ON convention_income_list TO accountant
GRANT EXECUTE ON GetOrderValue TO accountant

