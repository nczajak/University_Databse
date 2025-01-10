-- Created by Vertabelo (http://vertabelo.com)
-- Last modification date: 2025-01-08 20:03:39.105
-- nie zapomnieć dodać courseParticipants wraz z relacjami do bazy na serwerze agh
-- IDENTITY(1,1) działa jak AUTO INCREMENT
-- tables
-- Table: asyncMeetingDetails
CREATE TABLE asyncMeetingDetails (
    meetingID int  NOT NULL IDENTITY(1,1),
    participantID int  NOT NULL,
    dateWatched datetime  NULL,
    CONSTRAINT asyncMeetingDetails_pk PRIMARY KEY (meetingID,participantID),
	CONSTRAINT asyncMeetingDetails_chk_dateWatched_future CHECK (dateWatched <= GETDATE()),
    CONSTRAINT asyncMeetingDetails_chk_positive_ids CHECK (meetingID > 0 AND participantID > 0)
);

-- Table: building
CREATE TABLE building (
    buildingID int  NOT NULL IDENTITY(1,1),
    [address] nvarchar(50)  NOT NULL,
    CONSTRAINT building_pk PRIMARY KEY (buildingID),
	CONSTRAINT building_chk_positive_ids CHECK (buildingID > 0)

);

-- Table: class
CREATE TABLE class (
    classID int  NOT NULL IDENTITY(1,1),
    [year] int  NOT NULL,
    [limit] int  NOT NULL,
    majorID int  NOT NULL,
    productID int  NOT NULL,
    languageID int  NOT NULL,
    term int  NOT NULL,
    price decimal(7,2)  NOT NULL,
    CONSTRAINT class_pk PRIMARY KEY (classID),
	CONSTRAINT class_chk_positive_ids CHECK (classID > 0 AND majorID > 0  AND productID > 0 AND languageID > 0),
	CONSTRAINT class_chk_positive_limit CHECK ( [limit] >= 30 AND limit <= 100),
	CONSTRAINT class_chk_correct_term CHECK (0 < term AND term < 8),
	CONSTRAINT class_chk_correct_price CHECK (price > 0)

);

-- Table: company
CREATE TABLE company (
    companyID int  NOT NULL IDENTITY(1,1),
    companyName nvarchar(50)  NOT NULL,
    [address] nvarchar(50)  NOT NULL,
    email varchar(50)  NOT NULL,
    phone varchar(16)  NOT NULL,
    CONSTRAINT company_pk PRIMARY KEY (companyID),
	CONSTRAINT company_chk_positive_ids CHECK (companyID > 0),
	CONSTRAINT company_chk_correct_email CHECK (email LIKE '%@%.%'),
	CONSTRAINT company_chk_correct_phone CHECK (phone LIKE '%[0-9 ]%')


);

-- Table: convention
CREATE TABLE convention (
    conventionID int  NOT NULL IDENTITY(1,1),
    classID int  NOT NULL,
    productID int  NOT NULL,
    [limit] int  NOT NULL,
    price int  NOT NULL,
    priceForStudents int  NOT NULL,
    conventionTypeID int  NOT NULL,
    CONSTRAINT convention_pk PRIMARY KEY (conventionID),
	CONSTRAINT convention_chk_positive_ids CHECK (classID > 0 AND conventionID > 0  AND productID > 0 AND conventionTypeID > 0),
	CONSTRAINT convention_chk_positive_limit CHECK ( [limit] >= 30 AND limit <= 100),
	CONSTRAINT convention_chk_correct_price CHECK (price > 0),
	CONSTRAINT convention_chk_correct_priceForStudents CHECK (priceForStudents > 0)

);

-- Table: conventionDetails
CREATE TABLE conventionDetails (
    studentID int  NOT NULL,
    conventionID int  NOT NULL,
    paymentDate datetime  NOT NULL,
    CONSTRAINT conventionDetails_pk PRIMARY KEY (studentID,conventionID),
	CONSTRAINT conventionDetails_chk_positive_ids CHECK (conventionID > 0  AND studentID > 0)

);

-- Table: conventionType
CREATE TABLE conventionType (
    typeID int  NOT NULL IDENTITY(1,1),
    typeName int  NOT NULL,
    CONSTRAINT conventionType_pk PRIMARY KEY (typeID),
	CONSTRAINT conventionType_chk_positive_ids CHECK (typeID > 0)

);

-- Table: course
CREATE TABLE course (
    courseID int  NOT NULL IDENTITY(1,1),
    productID int  NOT NULL,
    courseName varchar(50)  NOT NULL,
    price decimal(7,2)  NOT NULL,
    advancePrice decimal(7,2)  NOT NULL,
    [limit] int  NULL,
    CONSTRAINT course_pk PRIMARY KEY (courseID),
	CONSTRAINT course_chk_positive_ids CHECK (courseID > 0  AND productID > 0),
	CONSTRAINT course_chk_correct_price CHECK (price > 0),
	CONSTRAINT course_chk_correct_advancePrice CHECK (advancePrice > 0),
	CONSTRAINT course_chk_positive_limit CHECK ( [limit] >= 30 AND limit <= 100)


);

-- Table: courseDetails
CREATE TABLE courseDetails (
    courseID int  NOT NULL,
    title nvarchar(50)  NOT NULL,
    [description] nvarchar(2000)  NOT NULL,
    languageID int  NOT NULL,
    CONSTRAINT courseDetails_pk PRIMARY KEY (courseID),
	CONSTRAINT courseDetails_chk_positive_ids CHECK (courseID > 0  AND languageID > 0)

);

-- Table: courseParticipants
CREATE TABLE courseParticipants (
    courseID int  NOT NULL,
    participantID int  NOT NULL,
    CONSTRAINT courseParticipants_pk PRIMARY KEY (courseID,participantID)
);

-- Table: employee
CREATE TABLE employee (
    employeeID int  NOT NULL IDENTITY(1,1),
    firstName nvarchar(50)  NOT NULL,
    middleName nvarchar(50)  NULL,
    lastName nvarchar(50)  NOT NULL,
    phone varchar(50)  NOT NULL,
    email nvarchar(50)  NOT NULL,
    [address] nvarchar(50)  NOT NULL,
    CONSTRAINT employee_pk PRIMARY KEY (employeeID),
	CONSTRAINT employee_chk_positive_ids CHECK (employeeID > 0),
	CONSTRAINT employee_chk_correct_email CHECK (email LIKE '%@%.%'),
	CONSTRAINT employee_chk_correct_phone CHECK (phone LIKE '%[0-9 ]%')

);

-- Table: finalExam
CREATE TABLE finalExam (
    participantID int  NOT NULL,
    classID int  NOT NULL,
    examDate datetime  NOT NULL,
    passed bit  NOT NULL,
    CONSTRAINT finalExam_pk PRIMARY KEY (participantID,classID),
	CONSTRAINT finalExam_chk_positive_ids CHECK (participantID > 0  AND classID > 0),
	CONSTRAINT finalExam_chk_dateWatched_future CHECK (examDate <= GETDATE())


);

-- Table: instructor
CREATE TABLE instructor (
    instructorID int  NOT NULL,
    titleID int  NOT NULL,
    CONSTRAINT instructor_pk PRIMARY KEY (instructorID),
	CONSTRAINT instructor_chk_positive_ids CHECK (instructorID > 0  AND titleID > 0)

);

-- Table: instructorDetails
CREATE TABLE instructorDetails (
    subjectID int  NOT NULL,
    instructorID int  NOT NULL,
    CONSTRAINT instructorDetails_pk PRIMARY KEY (subjectID,instructorID),
	CONSTRAINT instructorDetails_chk_positive_ids CHECK (instructorID > 0  AND subjectID > 0)

);

-- Table: internship
CREATE TABLE internship (
    internshipID int  NOT NULL IDENTITY(1,1),
    companyID int  NOT NULL,
    startDate datetime  NOT NULL,
    supervisorID int  NOT NULL,
    CONSTRAINT internship_pk PRIMARY KEY (internshipID),
	CONSTRAINT internship_chk_positive_ids CHECK (internshipID > 0  AND companyID > 0 AND supervisorID > 0)

);

-- Table: internshipDetails
CREATE TABLE internshipDetails (
    internshipID int  NOT NULL,
    participantID int  NOT NULL,
    [date] date  NOT NULL,
    wasPresent bit  NOT NULL,
    CONSTRAINT internshipDetails_pk PRIMARY KEY (internshipID,participantID,date),
	CONSTRAINT internshipDetails_chk_positive_ids CHECK (internshipID > 0  AND participantID > 0),
	CONSTRAINT internshipDetails_chk_dateWatched_future CHECK ([date] <= GETDATE())

);

-- Table: internshipSupervisor
CREATE TABLE internshipSupervisor (
    internshipSupervisorID int  NOT NULL,
    CONSTRAINT internshipSupervisor_pk PRIMARY KEY (internshipSupervisorID),
	CONSTRAINT internshipSupervisor_chk_positive_ids CHECK (internshipSupervisorID > 0)

);

-- Table: language
CREATE TABLE language (
    languageID int  NOT NULL IDENTITY(1,1),
    languageName nvarchar(50)  NOT NULL,
    CONSTRAINT language_pk PRIMARY KEY (languageID),
	CONSTRAINT language_chk_positive_ids CHECK (languageID > 0)

);

-- Table: major
CREATE TABLE major (
    majorID int  NOT NULL IDENTITY(1,1),
    [name] nvarchar(50)  NOT NULL,
    [description] nvarchar(50)  NOT NULL,
    supervisorID int  NOT NULL,
    CONSTRAINT major_pk PRIMARY KEY (majorID),
	CONSTRAINT major_chk_positive_ids CHECK (majorID > 0  AND supervisorID > 0)

);

-- Table: meeting
CREATE TABLE meeting (
    meetingID int  NOT NULL IDENTITY(1,1),
    subjectID int  NOT NULL,
    instructorID int  NOT NULL,
    translatorID int  NULL,
    languageID int  NOT NULL,
    meetingModeID int  NOT NULL,
    CONSTRAINT meeting_pk PRIMARY KEY (meetingID),
	CONSTRAINT meeting_chk_positive_ids CHECK (meetingID > 0  AND subjectID > 0 AND instructorID > 0 AND translatorID > 0 AND languageID > 0 AND meetingModeID > 0)

);

-- Table: meetingMode
CREATE TABLE meetingMode (
    meetingModeID int  NOT NULL IDENTITY(1,1),
    modeName nvarchar(50)  NOT NULL,
    CONSTRAINT meetingMode_pk PRIMARY KEY (meetingModeID),
	CONSTRAINT meetingMode_chk_positive_ids CHECK (meetingModeID > 0)

);

-- Table: meetingParticipants
CREATE TABLE meetingParticipants (
    meetingID int  NOT NULL,
    participantID int  NOT NULL,
    wasPresent bit  NOT NULL,
    CONSTRAINT meetingParticipants_pk PRIMARY KEY (meetingID),
	CONSTRAINT meetingParticipants_chk_positive_ids CHECK (meetingID > 0  AND participantID > 0)

);

-- Table: meetingTime
CREATE TABLE meetingTime (
    meetingID int  NOT NULL,
    startTime datetime  NOT NULL,
    endTime datetime  NOT NULL,
    CONSTRAINT meetingTime_pk PRIMARY KEY (meetingID),
	CONSTRAINT meetingTime_chk_positive_ids CHECK (meetingID > 0),
	CONSTRAINT meetingTime_chk_correct_startTime_and_endTime CHECK (endTime>startTime)

);

-- Table: module
CREATE TABLE module (
    moduleID int  NOT NULL IDENTITY(1,1),
    courseID int  NOT NULL,
    [description] nvarchar(2047)  NOT NULL,
    moduleTypeID int  NOT NULL,
    CONSTRAINT module_pk PRIMARY KEY (moduleID),
	CONSTRAINT module_chk_positive_ids CHECK (moduleID > 0  AND courseID > 0  AND moduleTypeID > 0)

);

-- Table: moduleSchedule
CREATE TABLE moduleSchedule (
    meetingID int  NOT NULL,
    moduleID int  NOT NULL,
    CONSTRAINT moduleSchedule_pk PRIMARY KEY (meetingID,moduleID),
	CONSTRAINT moduleSchedule_chk_positive_ids CHECK (meetingID > 0  AND moduleID > 0)

);

-- Table: moduleTypes
CREATE TABLE moduleTypes (
    moduleTypeID int  NOT NULL IDENTITY(1,1),
    moduleName nvarchar(50)  NOT NULL,
    CONSTRAINT moduleTypes_pk PRIMARY KEY (moduleTypeID),
	CONSTRAINT moduleTypes_chk_positive_ids CHECK (moduleTypeID > 0)

);

-- Table: onlineAsyncMeeting
CREATE TABLE onlineAsyncMeeting (
    meetingID int  NOT NULL,
    recordingLink nvarchar(2083)  NOT NULL,
    CONSTRAINT onlineAsyncMeeting_pk PRIMARY KEY (meetingID),
	CONSTRAINT onlineAsyncMeeting_chk_positive_ids CHECK (meetingID > 0)

);

-- Table: onlineSyncMeeting
CREATE TABLE onlineSyncMeeting (
    meetingID int  NOT NULL,
    [date] datetime  NOT NULL,
    meetingLink varchar(2047)  NOT NULL,
    recordingLink varchar(2047)  NOT NULL,
    CONSTRAINT onlineSyncMeeting_pk PRIMARY KEY (meetingID),
	CONSTRAINT onlineSyncMeeting_chk_positive_ids CHECK (meetingID > 0)

);

-- Table: orderDetails
CREATE TABLE orderDetails (
    orderID int  NOT NULL,
    productID int  NOT NULL,
    fullPaymentDate datetime  NULL,
    advancePaymentDate datetime  NULL,
    statusID int  NOT NULL,
    price decimal(7,2)  NOT NULL,
    CONSTRAINT orderDetails_pk PRIMARY KEY (orderID,productID),
	CONSTRAINT orderDetails_chk_positive_ids CHECK (orderID > 0  AND productID > 0  AND statusID > 0),
	CONSTRAINT orderDetails_chk_fullPaymentDate_and_advancePaymentDate CHECK (fullPaymentDate>advancePaymentDate),
	CONSTRAINT orderDetails_chk_price CHECK (price>0)

);

-- Table: orderStatus
CREATE TABLE orderStatus (
    statusID int  NOT NULL IDENTITY(1,1),
    statusType nvarchar(32)  NOT NULL,
    CONSTRAINT orderStatus_pk PRIMARY KEY (statusID),
	CONSTRAINT orderStatus_chk_positive_ids CHECK (statusID > 0)

);

-- Table: orders
CREATE TABLE orders (
    orderID int  NOT NULL IDENTITY(1,1),
    participantID int  NOT NULL,
    paymentLink varchar(2047)  NOT NULL,
    orderDate datetime  NOT NULL,
    CONSTRAINT orders_pk PRIMARY KEY (orderID),
	CONSTRAINT orders_chk_positive_ids CHECK (orderID > 0  AND participantID > 0)

);

-- Table: participant
CREATE TABLE participant (
    participantID int  NOT NULL IDENTITY(1,1),
    firstName nvarchar(50)  NOT NULL,
    lastName nvarchar(50)  NOT NULL,
    email nvarchar(50)  NOT NULL,
    phone nvarchar(50)  NOT NULL,
    [address] nvarchar(50)  NOT NULL,
    CONSTRAINT participant_pk PRIMARY KEY (participantID),
	CONSTRAINT participant_chk_positive_ids CHECK (participantID > 0),
	CONSTRAINT participant_chk_correct_email CHECK (email LIKE '%@%.%'),
	CONSTRAINT participant_chk_correct_phone CHECK (phone LIKE '%[0-9 ]%')

);

-- Table: paymentDeferral
CREATE TABLE paymentDeferral (
    orderID int  NOT NULL,
    newDueDate datetime  NOT NULL,
    CONSTRAINT paymentDeferral_pk PRIMARY KEY (orderID),
	CONSTRAINT paymentDeferral_chk_positive_ids CHECK (orderID > 0)
);

-- Table: president
CREATE TABLE president (
    presidentID int  NOT NULL,
    titleID int  NOT NULL,
    CONSTRAINT president_pk PRIMARY KEY (presidentID),
	CONSTRAINT president_chk_positive_ids CHECK (presidentID > 0 AND titleID > 0)

);

-- Table: productTypes
CREATE TABLE productTypes (
    typeID int  NOT NULL IDENTITY(1,1),
    typeName varchar(50)  NOT NULL,
    CONSTRAINT productTypes_pk PRIMARY KEY (typeID),
	CONSTRAINT productTypes_chk_positive_ids CHECK (typeID > 0)

);

-- Table: products
CREATE TABLE products (
    productID int  NOT NULL IDENTITY(1,1),
    isAvailable bit  NOT NULL,
    typeID int  NOT NULL,
    CONSTRAINT products_pk PRIMARY KEY (productID),
	CONSTRAINT products_chk_positive_ids CHECK (productID > 0 AND typeID > 0)

);

-- Table: roomDetails
CREATE TABLE roomDetails (
    roomID int  NOT NULL,
    startTime datetime  NOT NULL,
    endTime datetime  NOT NULL,
    usedBy int  NOT NULL,
    CONSTRAINT roomDetails_pk PRIMARY KEY (roomID),
	CONSTRAINT roomDetails_chk_positive_ids CHECK (roomID > 0 AND usedBy > 0),
	CONSTRAINT roomDetails_chk_sartTime_and_endTime CHECK (startTime<endTime)
);

-- Table: rooms
CREATE TABLE rooms (
    roomID int  NOT NULL IDENTITY(1,1),
    buildingID int  NOT NULL,
    roomNumber int  NOT NULL,
    size int  NOT NULL,
    CONSTRAINT rooms_pk PRIMARY KEY (roomID),
	CONSTRAINT rooms_chk_positive_ids CHECK (roomID > 0 AND buildingID > 0),
	CONSTRAINT rooms_chk_correct_size CHECK (size > 0 AND size <=40),
	CONSTRAINT rooms_chk_correct_roomNumber CHECK (roomNumber>0)

);

-- Table: stationaryMeeting
CREATE TABLE stationaryMeeting (
    meetingID int  NOT NULL,
    roomID int  NOT NULL,
    [date] datetime  NOT NULL,
    CONSTRAINT stationaryMeeting_pk PRIMARY KEY (meetingID),
	CONSTRAINT stationaryMeeting_chk_positive_ids CHECK (roomID > 0 AND meetingID > 0)
);

-- Table: students
CREATE TABLE students (
    participantID int  NOT NULL,
    classID int  NOT NULL,
    CONSTRAINT students_pk PRIMARY KEY (participantID,classID),
	CONSTRAINT students_chk_positive_ids CHECK (participantID > 0 AND classID > 0)
);

-- Table: studySchedule
CREATE TABLE studySchedule (
    meetingID int  NOT NULL,
    conventionID int  NOT NULL,
    CONSTRAINT studySchedule_pk PRIMARY KEY (meetingID,conventionID),
	CONSTRAINT studySchedule_chk_positive_ids CHECK (meetingID > 0 AND conventionID > 0)
);

-- Table: subject
CREATE TABLE subject (
    subjectID int  NOT NULL IDENTITY(1,1),
    subjectName nvarchar(50)  NOT NULL,
    [description] nvarchar(2000)  NOT NULL,
    CONSTRAINT subject_pk PRIMARY KEY (subjectID),
	CONSTRAINT subject_chk_positive_ids CHECK (subjectID > 0)
);

-- Table: syllabus
CREATE TABLE syllabus (
    majorID int  NOT NULL,
    subjectID int  NOT NULL,
    requiredHours int  NOT NULL,
    term int  NOT NULL,
    CONSTRAINT syllabus_pk PRIMARY KEY (majorID,subjectID),
	CONSTRAINT syllabus_chk_positive_ids CHECK (majorID > 0 AND subjectID > 0),
	CONSTRAINT syllabus_chk_requiredHour CHECK (requiredHours > 0),
	CONSTRAINT syllabus_chk_term CHECK ( term >=1 AND term <=7)
);

-- Table: titles
CREATE TABLE titles (
    titleID int  NOT NULL IDENTITY(1,1),
    titleName int  NOT NULL,
    CONSTRAINT titles_pk PRIMARY KEY (titleID),
	CONSTRAINT titles_chk_positive_ids CHECK (titleID > 0)
);

-- Table: translator
CREATE TABLE translator (
    translatorID int  NOT NULL,
    CONSTRAINT translator_pk PRIMARY KEY (translatorID),
	CONSTRAINT translator_chk_positive_ids CHECK (translatorID > 0)

);

-- Table: translatorDetails
CREATE TABLE translatorDetails (
    translatorID int  NOT NULL,
    languageID int  NOT NULL,
    CONSTRAINT translatorDetails_pk PRIMARY KEY (translatorID,languageID),
	CONSTRAINT translatorDetails_chk_positive_ids CHECK (translatorID > 0 AND languageID > 0)
);

-- Table: webinar
CREATE TABLE webinar (
    webinarID int  NOT NULL IDENTITY(1,1),
    productID int  NOT NULL,
    price decimal(7,2)  NULL,
    webinarName nvarchar(50)  NOT NULL,
    CONSTRAINT webinar_pk PRIMARY KEY (webinarID),
	CONSTRAINT webinar_chk_positive_ids CHECK (webinarID > 0 AND productID > 0),
	CONSTRAINT webinar_chk_price CHECK (price>0)
);

-- Table: webinarDetails
CREATE TABLE webinarDetails (
    webinarID int  NOT NULL,
    instructorID int  NOT NULL,
    meetingLink varchar(2083)  NOT NULL,
    recordingLink varchar(2083)  NULL,
    [description] nvarchar(2000)  NOT NULL,
    translatorID int  NULL,
    languageID int  NOT NULL,
    CONSTRAINT webinarDetails_pk PRIMARY KEY (webinarID),
	CONSTRAINT webinarDetails_chk_positive_ids CHECK (translatorID > 0 AND languageID > 0 AND webinarID > 0 AND instructorID > 0)

);

-- Table: webinarParticipants
CREATE TABLE webinarParticipants (
    webinarID int  NOT NULL,
    participantID int  NOT NULL,
    accessUntill datetime  NOT NULL,
    CONSTRAINT webinarParticipants_pk PRIMARY KEY (webinarID,participantID),
	CONSTRAINT webinarParticipants_chk_positive_ids CHECK (participantID > 0 AND webinarID > 0)
);

-- foreign keys
-- Reference: asyncMeetingDetails_onlineAsyncMeeting (table: asyncMeetingDetails)
ALTER TABLE asyncMeetingDetails ADD CONSTRAINT asyncMeetingDetails_onlineAsyncMeeting FOREIGN KEY (meetingID)
    REFERENCES onlineAsyncMeeting (meetingID);

-- Reference: asyncMeetingDetails_participant (table: asyncMeetingDetails)
ALTER TABLE asyncMeetingDetails ADD CONSTRAINT asyncMeetingDetails_participant FOREIGN KEY (participantID)
    REFERENCES participant (participantID);

-- Reference: class_finalExam (table: finalExam)
ALTER TABLE finalExam ADD CONSTRAINT class_finalExam FOREIGN KEY  (classID)
    REFERENCES class (classID);

-- Reference: class_language (table: class)
ALTER TABLE class ADD CONSTRAINT class_language FOREIGN KEY  (languageID)
    REFERENCES language (languageID);

-- Reference: class_major (table: class)
ALTER TABLE class ADD CONSTRAINT class_major FOREIGN KEY  (majorID)
    REFERENCES major (majorID);

-- Reference: class_products (table: class)
ALTER TABLE class ADD CONSTRAINT class_products FOREIGN KEY  (productID)
    REFERENCES products (productID);

-- Reference: conventionDetails_participant (table: conventionDetails)
ALTER TABLE conventionDetails ADD CONSTRAINT conventionDetails_participant FOREIGN KEY  (studentID)
    REFERENCES participant (participantID);

-- Reference: convention_conventionDetails (table: conventionDetails)
ALTER TABLE conventionDetails ADD CONSTRAINT convention_conventionDetails FOREIGN KEY  (conventionID)
    REFERENCES convention (conventionID);

-- Reference: convention_conventionType (table: convention)
ALTER TABLE convention ADD CONSTRAINT convention_conventionType FOREIGN KEY  (conventionTypeID)
    REFERENCES conventionType (typeID);

-- Reference: courseDetails_course (table: courseDetails)
ALTER TABLE courseDetails ADD CONSTRAINT courseDetails_course FOREIGN KEY  (courseID)
    REFERENCES course (courseID);

-- Reference: courseModule_meeting (table: moduleSchedule)
ALTER TABLE moduleSchedule ADD CONSTRAINT courseModule_meeting FOREIGN KEY  (meetingID)
    REFERENCES meeting (meetingID);

-- Reference: courseParticipants_participant (table: courseParticipants)
ALTER TABLE courseParticipants ADD CONSTRAINT courseParticipants_participant FOREIGN KEY (participantID)
    REFERENCES participant (participantID);

-- Reference: course_courseParticipants (table: courseParticipants)
ALTER TABLE courseParticipants ADD CONSTRAINT course_courseParticipants FOREIGN KEY (courseID)
    REFERENCES course (courseID);

-- Reference: course_language (table: courseDetails)
ALTER TABLE courseDetails ADD CONSTRAINT course_language FOREIGN KEY  (languageID)
    REFERENCES language (languageID);

-- Reference: course_products (table: course)
ALTER TABLE course ADD CONSTRAINT course_products FOREIGN KEY  (productID)
    REFERENCES products (productID);

-- Reference: finalExam_participant (table: finalExam)
ALTER TABLE finalExam ADD CONSTRAINT finalExam_participant FOREIGN KEY  (participantID)
    REFERENCES participant (participantID);

-- Reference: instructorCompetence_instructor (table: instructorDetails)
ALTER TABLE instructorDetails ADD CONSTRAINT instructorCompetence_instructor FOREIGN KEY  (instructorID)
    REFERENCES instructor (instructorID);

-- Reference: instructorDetails_subject (table: instructorDetails)
ALTER TABLE instructorDetails ADD CONSTRAINT instructorDetails_subject FOREIGN KEY  (subjectID)
    REFERENCES subject (subjectID);

-- Reference: instructor_employee (table: instructor)
ALTER TABLE instructor ADD CONSTRAINT instructor_employee FOREIGN KEY  (instructorID)
    REFERENCES employee (employeeID);

-- Reference: instructor_titles (table: instructor)
ALTER TABLE instructor ADD CONSTRAINT instructor_titles FOREIGN KEY  (titleID)
    REFERENCES titles (titleID);

-- Reference: internshipDetails_internship (table: internshipDetails)
ALTER TABLE internshipDetails ADD CONSTRAINT internshipDetails_internship FOREIGN KEY  (internshipID)
    REFERENCES internship (internshipID);

-- Reference: internshipDetails_participant (table: internshipDetails)
ALTER TABLE internshipDetails ADD CONSTRAINT internshipDetails_participant FOREIGN KEY  (participantID)
    REFERENCES participant (participantID);

-- Reference: internshipSupervisor_employee (table: internshipSupervisor)
ALTER TABLE internshipSupervisor ADD CONSTRAINT internshipSupervisor_employee FOREIGN KEY  (internshipSupervisorID)
    REFERENCES employee (employeeID);

-- Reference: internship_company (table: internship)
ALTER TABLE internship ADD CONSTRAINT internship_company FOREIGN KEY  (companyID)
    REFERENCES company (companyID);

-- Reference: internship_employee (table: internship)
ALTER TABLE internship ADD CONSTRAINT internship_employee FOREIGN KEY  (supervisorID)
    REFERENCES employee (employeeID);

-- Reference: major_employee (table: major)
ALTER TABLE major ADD CONSTRAINT major_employee FOREIGN KEY  (supervisorID)
    REFERENCES employee (employeeID);

-- Reference: meetingParticipants_meeting (table: meetingParticipants)
ALTER TABLE meetingParticipants ADD CONSTRAINT meetingParticipants_meeting FOREIGN KEY  (meetingID)
    REFERENCES meeting (meetingID);

-- Reference: meetingParticipants_participant (table: meetingParticipants)
ALTER TABLE meetingParticipants ADD CONSTRAINT meetingParticipants_participant FOREIGN KEY  (participantID)
    REFERENCES participant (participantID);

-- Reference: meetingTime_meeting (table: meetingTime)
ALTER TABLE meetingTime ADD CONSTRAINT meetingTime_meeting FOREIGN KEY  (meetingID)
    REFERENCES meeting (meetingID);

-- Reference: meeting_employee (table: meeting)
ALTER TABLE meeting ADD CONSTRAINT meeting_employee FOREIGN KEY  (instructorID)
    REFERENCES employee (employeeID);

-- Reference: meeting_language (table: meeting)
ALTER TABLE meeting ADD CONSTRAINT meeting_language FOREIGN KEY  (languageID)
    REFERENCES language (languageID);

-- Reference: meeting_meetingMode (table: meeting)
ALTER TABLE meeting ADD CONSTRAINT meeting_meetingMode FOREIGN KEY  (meetingModeID)
    REFERENCES meetingMode (meetingModeID);

-- Reference: meeting_subject (table: meeting)
ALTER TABLE meeting ADD CONSTRAINT meeting_subject FOREIGN KEY  (subjectID)
    REFERENCES subject (subjectID);

-- Reference: moduleSchedule_module (table: moduleSchedule)
ALTER TABLE moduleSchedule ADD CONSTRAINT moduleSchedule_module FOREIGN KEY  (moduleID)
    REFERENCES module (moduleID);

-- Reference: module_courseDetails (table: module)
ALTER TABLE module ADD CONSTRAINT module_courseDetails FOREIGN KEY  (courseID)
    REFERENCES courseDetails (courseID);

-- Reference: module_moduleTypes (table: module)
ALTER TABLE module ADD CONSTRAINT module_moduleTypes FOREIGN KEY  (moduleTypeID)
    REFERENCES moduleTypes (moduleTypeID);

-- Reference: onlineAsyncMeeting_meeting (table: onlineAsyncMeeting)
ALTER TABLE onlineAsyncMeeting ADD CONSTRAINT onlineAsyncMeeting_meeting FOREIGN KEY  (meetingID)
    REFERENCES meeting (meetingID);

-- Reference: onlineSyncMeeting_meeting (table: onlineSyncMeeting)
ALTER TABLE onlineSyncMeeting ADD CONSTRAINT onlineSyncMeeting_meeting FOREIGN KEY  (meetingID)
    REFERENCES meeting (meetingID);

-- Reference: orderDetails_products (table: orderDetails)
ALTER TABLE orderDetails ADD CONSTRAINT orderDetails_products FOREIGN KEY  (productID)
    REFERENCES products (productID);

-- Reference: orderStatus_orderDetails (table: orderDetails)
ALTER TABLE orderDetails ADD CONSTRAINT orderStatus_orderDetails FOREIGN KEY  (statusID)
    REFERENCES orderStatus (statusID);

-- Reference: orders_orderDetails (table: orderDetails)
ALTER TABLE orderDetails ADD CONSTRAINT orders_orderDetails FOREIGN KEY  (orderID)
    REFERENCES orders (orderID);

-- Reference: orders_participant (table: orders)
ALTER TABLE orders ADD CONSTRAINT orders_participant FOREIGN KEY  (participantID)
    REFERENCES participant (participantID);

-- Reference: orders_paymentDeferral (table: paymentDeferral)
ALTER TABLE paymentDeferral ADD CONSTRAINT orders_paymentDeferral FOREIGN KEY  (orderID)
    REFERENCES orders (orderID);

-- Reference: participant_students (table: students)
ALTER TABLE students ADD CONSTRAINT participant_students FOREIGN KEY  (participantID)
    REFERENCES participant (participantID);

-- Reference: president_employee (table: president)
ALTER TABLE president ADD CONSTRAINT president_employee FOREIGN KEY  (presidentID)
    REFERENCES employee (employeeID);

-- Reference: president_titles (table: president)
ALTER TABLE president ADD CONSTRAINT president_titles FOREIGN KEY  (titleID)
    REFERENCES titles (titleID);

-- Reference: products_convention (table: convention)
ALTER TABLE convention ADD CONSTRAINT products_convention FOREIGN KEY  (productID)
    REFERENCES products (productID);

-- Reference: products_productTypes (table: products)
ALTER TABLE products ADD CONSTRAINT products_productTypes FOREIGN KEY  (typeID)
    REFERENCES productTypes (typeID);

-- Reference: reunion_class (table: convention)
ALTER TABLE convention ADD CONSTRAINT reunion_class FOREIGN KEY  (classID)
    REFERENCES class (classID);

-- Reference: roomDetails_employee (table: roomDetails)
ALTER TABLE roomDetails ADD CONSTRAINT roomDetails_employee FOREIGN KEY  (usedBy)
    REFERENCES employee (employeeID);

-- Reference: roomDetails_rooms (table: roomDetails)
ALTER TABLE roomDetails ADD CONSTRAINT roomDetails_rooms FOREIGN KEY  (roomID)
    REFERENCES rooms (roomID);

-- Reference: rooms_building (table: rooms)
ALTER TABLE rooms ADD CONSTRAINT rooms_building FOREIGN KEY  (buildingID)
    REFERENCES building (buildingID);

-- Reference: stationaryMeeting_meeting (table: stationaryMeeting)
ALTER TABLE stationaryMeeting ADD CONSTRAINT stationaryMeeting_meeting FOREIGN KEY  (meetingID)
    REFERENCES meeting (meetingID);

-- Reference: stationaryMeeting_rooms (table: stationaryMeeting)
ALTER TABLE stationaryMeeting ADD CONSTRAINT stationaryMeeting_rooms FOREIGN KEY  (roomID)
    REFERENCES rooms (roomID);

-- Reference: students_class (table: students)
ALTER TABLE students ADD CONSTRAINT students_class FOREIGN KEY  (classID)
    REFERENCES class (classID);

-- Reference: studySchedule_meeting (table: studySchedule)
ALTER TABLE studySchedule ADD CONSTRAINT studySchedule_meeting FOREIGN KEY  (meetingID)
    REFERENCES meeting (meetingID);

-- Reference: studySchedule_reunion (table: studySchedule)
ALTER TABLE studySchedule ADD CONSTRAINT studySchedule_reunion FOREIGN KEY  (conventionID)
    REFERENCES convention (conventionID);

-- Reference: syllabus_major (table: syllabus)
ALTER TABLE syllabus ADD CONSTRAINT syllabus_major FOREIGN KEY  (majorID)
    REFERENCES major (majorID);

-- Reference: syllabus_subject (table: syllabus)
ALTER TABLE syllabus ADD CONSTRAINT syllabus_subject FOREIGN KEY  (subjectID)
    REFERENCES subject (subjectID);

-- Reference: translatorDetails_language (table: translatorDetails)
ALTER TABLE translatorDetails ADD CONSTRAINT translatorDetails_language FOREIGN KEY  (languageID)
    REFERENCES language (languageID);

-- Reference: translatorDetails_translator (table: translatorDetails)
ALTER TABLE translatorDetails ADD CONSTRAINT translatorDetails_translator FOREIGN KEY  (translatorID)
    REFERENCES translator (translatorID);

-- Reference: translator_employee (table: translator)
ALTER TABLE translator ADD CONSTRAINT translator_employee FOREIGN KEY  (translatorID)
    REFERENCES employee (employeeID);

-- Reference: translator_meeting (table: meeting)
ALTER TABLE meeting ADD CONSTRAINT translator_meeting FOREIGN KEY  (translatorID)
    REFERENCES translator (translatorID);

-- Reference: webinarDetails_employee (table: webinarDetails)
ALTER TABLE webinarDetails ADD CONSTRAINT webinarDetails_employee FOREIGN KEY  (instructorID)
    REFERENCES employee (employeeID);

-- Reference: webinarDetails_language (table: webinarDetails)
ALTER TABLE webinarDetails ADD CONSTRAINT webinarDetails_language FOREIGN KEY  (languageID)
    REFERENCES language (languageID);

-- Reference: webinarDetails_translator (table: webinarDetails)
ALTER TABLE webinarDetails ADD CONSTRAINT webinarDetails_translator FOREIGN KEY  (translatorID)
    REFERENCES translator (translatorID);

-- Reference: webinarDetails_webinar (table: webinarDetails)
ALTER TABLE webinarDetails ADD CONSTRAINT webinarDetails_webinar FOREIGN KEY  (webinarID)
    REFERENCES webinar (webinarID);

-- Reference: webinarParticipants_participant (table: webinarParticipants)
ALTER TABLE webinarParticipants ADD CONSTRAINT webinarParticipants_participant FOREIGN KEY  (participantID)
    REFERENCES participant (participantID);

-- Reference: webinarParticipants_webinarDetails (table: webinarParticipants)
ALTER TABLE webinarParticipants ADD CONSTRAINT webinarParticipants_webinarDetails FOREIGN KEY  (webinarID)
    REFERENCES webinarDetails (webinarID);

-- Reference: webinar_products (table: webinar)
ALTER TABLE webinar ADD CONSTRAINT webinar_products FOREIGN KEY  (productID)
    REFERENCES products (productID);

-- End of file.

