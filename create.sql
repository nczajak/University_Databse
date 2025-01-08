-- Created by Vertabelo (http://vertabelo.com)
-- Last modification date: 2025-01-08 20:03:39.105

-- tables
-- Table: asyncMeetingDetails
CREATE TABLE asyncMeetingDetails (
    meetingID int  NOT NULL,
    participantID int  NOT NULL,
    dateWatched datetime  NULL,
    CONSTRAINT asyncMeetingDetails_pk PRIMARY KEY (meetingID,participantID)
);

-- Table: building
CREATE TABLE building (
    buildingID int  NOT NULL,
    address nvarchar(50)  NOT NULL,
    CONSTRAINT building_pk PRIMARY KEY (buildingID)
);

-- Table: class
CREATE TABLE class (
    classID int  NOT NULL,
    [year] int  NOT NULL,
    [limit] int  NOT NULL,
    majorID int  NOT NULL,
    productID int  NOT NULL,
    languageID int  NOT NULL,
    term int  NOT NULL,
    price decimal(7,2)  NOT NULL,
    CONSTRAINT class_pk PRIMARY KEY (classID)
);

-- Table: company
CREATE TABLE company (
    companIyD int  NOT NULL,
    companyName nvarchar(50)  NOT NULL,
    [address] nvarchar(50)  NOT NULL,
    email varchar(50)  NOT NULL,
    phone varchar(16)  NOT NULL,
    CONSTRAINT company_pk PRIMARY KEY (companIyD)
);

-- Table: convention
CREATE TABLE convention (
    conventionID int  NOT NULL,
    classID int  NOT NULL,
    productID int  NOT NULL,
    [limit] int  NOT NULL,
    price int  NOT NULL,
    priceForStudents int  NOT NULL,
    conventionTypeID int  NOT NULL,
    CONSTRAINT convention_pk PRIMARY KEY (conventionID)
);

-- Table: conventionDetails
CREATE TABLE conventionDetails (
    studentID int  NOT NULL,
    conventionID int  NOT NULL,
    paymentDate datetime  NOT NULL,
    CONSTRAINT conventionDetails_pk PRIMARY KEY (studentID,conventionID)
);

-- Table: conventionType
CREATE TABLE conventionType (
    typeID int  NOT NULL,
    typeName int  NOT NULL,
    CONSTRAINT conventionType_pk PRIMARY KEY (typeID)
);

-- Table: course
CREATE TABLE course (
    courseID int  NOT NULL,
    productID int  NOT NULL,
    courseName varchar(50)  NOT NULL,
    price decimal(7,2)  NOT NULL,
    advancePrice decimal(7,2)  NOT NULL,
    [limit] int  NULL,
    CONSTRAINT course_pk PRIMARY KEY (courseID)
);

-- Table: courseDetails
CREATE TABLE courseDetails (
    courseID int  NOT NULL,
    title nvarchar(50)  NOT NULL,
    [description] nvarchar(2000)  NOT NULL,
    languageID int  NOT NULL,
    CONSTRAINT courseDetails_pk PRIMARY KEY (courseID)
);

-- Table: employee
CREATE TABLE employee (
    employeeID int  NOT NULL,
    firstName nvarchar(50)  NOT NULL,
    middleName nvarchar(50)  NULL,
    lastName nvarchar(50)  NOT NULL,
    phone varchar(50)  NOT NULL,
    email nvarchar(50)  NOT NULL,
    [address] nvarchar(50)  NOT NULL,
    CONSTRAINT employee_pk PRIMARY KEY (employeeID)
);

-- Table: finalExam
CREATE TABLE finalExam (
    participantID int  NOT NULL,
    classID int  NOT NULL,
    examDate datetime  NOT NULL,
    passed bit  NOT NULL,
    CONSTRAINT finalExam_pk PRIMARY KEY (participantID,classID)
);

-- Table: instructor
CREATE TABLE instructor (
    instructorID int  NOT NULL,
    titleID int  NOT NULL,
    CONSTRAINT instructor_pk PRIMARY KEY (instructorID)
);

-- Table: instructorDetails
CREATE TABLE instructorDetails (
    subjectID int  NOT NULL,
    instructorID int  NOT NULL,
    CONSTRAINT instructorDetails_pk PRIMARY KEY (subjectID,instructorID)
);

-- Table: internship
CREATE TABLE internship (
    internshipID int  NOT NULL,
    companyID int  NOT NULL,
    startDate datetime  NOT NULL,
    supervisorID int  NOT NULL,
    CONSTRAINT internship_pk PRIMARY KEY (internshipID)
);

-- Table: internshipDetails
CREATE TABLE internshipDetails (
    internshipID int  NOT NULL,
    participantID int  NOT NULL,
    [date] date  NOT NULL,
    wasPresent bit  NOT NULL,
    CONSTRAINT internshipDetails_pk PRIMARY KEY (internshipID,participantID,date)
);

-- Table: internshipSupervisor
CREATE TABLE internshipSupervisor (
    internshipSupervisorID int  NOT NULL,
    CONSTRAINT internshipSupervisor_pk PRIMARY KEY (internshipSupervisorID)
);

-- Table: language
CREATE TABLE language (
    languageID int  NOT NULL,
    languageName nvarchar(50)  NOT NULL,
    CONSTRAINT language_pk PRIMARY KEY (languageID)
);

-- Table: major
CREATE TABLE major (
    majorID int  NOT NULL,
    [name] nvarchar(50)  NOT NULL,
    [description] nvarchar(50)  NOT NULL,
    supervisorID int  NOT NULL,
    CONSTRAINT major_pk PRIMARY KEY (majorID)
);

-- Table: meeting
CREATE TABLE meeting (
    meetingID int  NOT NULL,
    subjectID int  NOT NULL,
    instructorID int  NOT NULL,
    translatorID int  NULL,
    languageID int  NOT NULL,
    meetingModeID int  NOT NULL,
    CONSTRAINT meeting_pk PRIMARY KEY (meetingID)
);

-- Table: meetingMode
CREATE TABLE meetingMode (
    meetingModeID int  NOT NULL,
    modeName nvarchar(50)  NOT NULL,
    CONSTRAINT meetingMode_pk PRIMARY KEY (meetingModeID)
);

-- Table: meetingParticipants
CREATE TABLE meetingParticipants (
    meetingID int  NOT NULL,
    participantID int  NOT NULL,
    wasPresent bit  NOT NULL,
    CONSTRAINT meetingParticipants_pk PRIMARY KEY (meetingID)
);

-- Table: meetingTime
CREATE TABLE meetingTime (
    meetingID int  NOT NULL,
    startTime datetime  NOT NULL,
    endTime datetime  NOT NULL,
    CONSTRAINT meetingTime_pk PRIMARY KEY (meetingID)
);

-- Table: module
CREATE TABLE module (
    moduleID int  NOT NULL,
    courseID int  NOT NULL,
    [description] nvarchar(2047)  NOT NULL,
    moduleTypeID int  NOT NULL,
    CONSTRAINT module_pk PRIMARY KEY (moduleID)
);

-- Table: moduleSchedule
CREATE TABLE moduleSchedule (
    meetingID int  NOT NULL,
    moduleID int  NOT NULL,
    CONSTRAINT moduleSchedule_pk PRIMARY KEY (meetingID,moduleID)
);

-- Table: moduleTypes
CREATE TABLE moduleTypes (
    moduleTypeID int  NOT NULL,
    moduleName nvarchar(50)  NOT NULL,
    CONSTRAINT moduleTypes_pk PRIMARY KEY (moduleTypeID)
);

-- Table: onlineAsyncMeeting
CREATE TABLE onlineAsyncMeeting (
    meetingID int  NOT NULL,
    recordingLink nvarchar(2083)  NOT NULL,
    CONSTRAINT onlineAsyncMeeting_pk PRIMARY KEY (meetingID)
);

-- Table: onlineSyncMeeting
CREATE TABLE onlineSyncMeeting (
    meetingID int  NOT NULL,
    [date] datetime  NOT NULL,
    meetingLink varchar(2047)  NOT NULL,
    recordingLink varchar(2047)  NOT NULL,
    CONSTRAINT onlineSyncMeeting_pk PRIMARY KEY (meetingID)
);

-- Table: orderDetails
CREATE TABLE orderDetails (
    orderID int  NOT NULL,
    productID int  NOT NULL,
    fullPaymentDate datetime  NULL,
    advancePaymentDate datetime  NULL,
    statusID int  NOT NULL,
    price decimal(7,2)  NOT NULL,
    CONSTRAINT orderDetails_pk PRIMARY KEY (orderID)
);

-- Table: orderStatus
CREATE TABLE orderStatus (
    statusID int  NOT NULL,
    statusType nvarchar(32)  NOT NULL,
    CONSTRAINT orderStatus_pk PRIMARY KEY (statusID)
);

-- Table: orders
CREATE TABLE orders (
    orderID int  NOT NULL,
    participantID int  NOT NULL,
    paymentLink varchar(2047)  NOT NULL,
    orderDate datetime  NOT NULL,
    CONSTRAINT orders_pk PRIMARY KEY (orderID)
);

-- Table: participant
CREATE TABLE participant (
    participantID int  NOT NULL,
    firstName nvarchar(50)  NOT NULL,
    lastName nvarchar(50)  NOT NULL,
    email nvarchar(50)  NOT NULL,
    phone nvarchar(50)  NOT NULL,
    [address] nvarchar(50)  NOT NULL,
    CONSTRAINT participant_pk PRIMARY KEY (participantID)
);

-- Table: paymentDeferral
CREATE TABLE paymentDeferral (
    orderID int  NOT NULL,
    newDueDate datetime  NOT NULL,
    CONSTRAINT paymentDeferral_pk PRIMARY KEY (orderID)
);

-- Table: president
CREATE TABLE president (
    presidentID int  NOT NULL,
    titleID int  NOT NULL,
    CONSTRAINT president_pk PRIMARY KEY (presidentID)
);

-- Table: productTypes
CREATE TABLE productTypes (
    typeID int  NOT NULL,
    typeName varchar(50)  NOT NULL,
    CONSTRAINT productTypes_pk PRIMARY KEY (typeID)
);

-- Table: products
CREATE TABLE products (
    productID int  NOT NULL,
    isAvailable bit  NOT NULL,
    typeID int  NOT NULL,
    CONSTRAINT products_pk PRIMARY KEY (productID)
);

-- Table: roomDetails
CREATE TABLE roomDetails (
    roomID int  NOT NULL,
    startTime datetime  NOT NULL,
    endTime datetime  NOT NULL,
    usedBy int  NOT NULL,
    CONSTRAINT roomDetails_pk PRIMARY KEY (roomID)
);

-- Table: rooms
CREATE TABLE rooms (
    roomID int  NOT NULL,
    buildingID int  NOT NULL,
    roomNumber int  NOT NULL,
    size int  NOT NULL,
    CONSTRAINT rooms_pk PRIMARY KEY (roomID)
);

-- Table: stationaryMeeting
CREATE TABLE stationaryMeeting (
    meetingID int  NOT NULL,
    roomID int  NOT NULL,
    [date] datetime  NOT NULL,
    CONSTRAINT stationaryMeeting_pk PRIMARY KEY (meetingID)
);

-- Table: students
CREATE TABLE students (
    participantID int  NOT NULL,
    classID int  NOT NULL,
    CONSTRAINT students_pk PRIMARY KEY (participantID,classID)
);

-- Table: studySchedule
CREATE TABLE studySchedule (
    meetingID int  NOT NULL,
    conventionID int  NOT NULL,
    CONSTRAINT studySchedule_pk PRIMARY KEY (meetingID,conventionID)
);

-- Table: subject
CREATE TABLE subject (
    subjectID int  NOT NULL,
    subjectName nvarchar(50)  NOT NULL,
    [description] nvarchar(2000)  NOT NULL,
    CONSTRAINT subject_pk PRIMARY KEY (subjectID)
);

-- Table: syllabus
CREATE TABLE syllabus (
    majorID int  NOT NULL,
    subjectID int  NOT NULL,
    requiredHours int  NOT NULL,
    term int  NOT NULL,
    CONSTRAINT syllabus_pk PRIMARY KEY (majorID,subjectID)
);

-- Table: titles
CREATE TABLE titles (
    titleID int  NOT NULL,
    titleName int  NOT NULL,
    CONSTRAINT titles_pk PRIMARY KEY (titleID)
);

-- Table: translator
CREATE TABLE translator (
    translatorID int  NOT NULL,
    CONSTRAINT translator_pk PRIMARY KEY (translatorID)
);

-- Table: translatorDetails
CREATE TABLE translatorDetails (
    translatorID int  NOT NULL,
    languageID int  NOT NULL,
    CONSTRAINT translatorDetails_pk PRIMARY KEY (translatorID,languageID)
);

-- Table: webinar
CREATE TABLE webinar (
    webinarID int  NOT NULL,
    productID int  NOT NULL,
    price decimal(7,2)  NULL,
    webinarName nvarchar(50)  NOT NULL,
    CONSTRAINT webinar_pk PRIMARY KEY (webinarID)
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
    CONSTRAINT webinarDetails_pk PRIMARY KEY (webinarID)
);

-- Table: webinarParticipants
CREATE TABLE webinarParticipants (
    webinarID int  NOT NULL,
    participantID int  NOT NULL,
    accessUntill datetime  NOT NULL,
    CONSTRAINT webinarParticipants_pk PRIMARY KEY (webinarID,participantID)
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
    REFERENCES company (companIyD);

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

