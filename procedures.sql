---Procedura enrollment służy do wpisywania uczestników do participants lists, po zakupie produktu prodecurą buy_products

create procedure enrollment
	@participantID int,
	@productID int


as begin

IF @productID NOT IN (SELECT productID FROM products WHERE isAvailable = 1)
   BEGIN
       RAISERROR (N'Produkt już nie jest dostępny', 16,1)
   end

	declare @productType varchar(50) = (select top 1 typeName from products as p
                                	inner join productTypes as pt on p.typeID = pt.typeID
                                	where productID = @productID)


	IF 'Webinar' = @productType
    	BEGIN
    	INSERT INTO webinarParticipants(webinarID,participantID,accessUntil)
    	VALUES ((select top 1 webinarID from webinar where productID = @productID),@participantID,DATEADD(day,30,getdate()))
    	END
	IF 'Course' = @productType
    	BEGIN
    	INSERT INTO courseParticipants(courseID,participantID)
    	VALUES ((select top 1 courseID from course where productID = @productID),@participantID)
    	END
	IF 'Studies' = @productType
    	BEGIN
    	INSERT INTO students(classID,participantID)
    	VALUES ((select top 1 classID from class where productID = @productID),@participantID)
    	END
	IF 'Convention' = @productType
    	BEGIN
    	INSERT INTO students(classID,participantID)
    	VALUES ((select top 1 conventionID from convention where productID = @productID),@participantID)
    	END

end
--Procedura create_translator  tworzy nowego pracownika - tłumacza na podstawie wprowadzonych danych oraz zwraca jego identyfikator (@employeeID = translatorID).

/*Argumenty procedury:
@firstname - imię nowego pracownika
@middleName - drugię imię pracownika ( może być null)
@lastName - nazwisko pracownika
@phone - numer telefonu pracownika 
@email - adres email pracownika 
@address - adres zamieszkania pracownika 
@employeeID - zwracany identyfikator pracownika*/



CREATE PROCEDURE create_translator

	@firstName nvarchar(50),
	@middleName nvarchar(50) = NULL,
	@lastName nvarchar(50),
	@phone varchar(50),
	@email nvarchar(50),
	@address nvarchar(50),
	@translatorID INT OUTPUT

AS BEGIN

	DECLARE @inserted_translator TABLE (employeeID INT);

AS BEGIN
	IF EXISTS @email in (SELECT email FROM employee)
	BEGIN 
    	RAISERROR(Ten email już istnieje w bazie.);
RETURN
END

IF EXISTS @phone in (SELECT phoneFROM employee)
	BEGIN 
    	RAISERROR(Ten numer telefonu już istnieje w bazie.);
RETURN
END


	INSERT INTO employee (firstName,middleName,lastName,phone,email,[address])
	OUTPUT INSERTED.employeeID INTO @inserted_translator
	VALUES (@firstName,@middleName,@lastName,@phone,@email,@address);

	SELECT @translatorID = employeeID FROM @inserted_translator;

	INSERT INTO translator (translatorID)
	VALUES (@translatorID);

END;

--Przykładowe wywołanie procedury

DECLARE @newTranslatorID INT;

EXEC create_translator
	@firstName = 'Anna',
	@middleName = NULL,
	@lastName = 'Kowalska',
	@phone = '555123456',
	@email = 'anna.kowalska@example.com',
	@address = '123 Translator Lane',
	@translatorID = @newTranslatorID OUTPUT;

SELECT @newTranslatorID AS TranslatorID;


/*Procedura create_internshipSupervisor  tworzy nowego pracownika - nadzorcę praktyk na podstawie wprowadzonych danych oraz zwraca jego identyfikator (@employeeID = internshipSupervisorD).


Argumenty procedury:
@firstname - imię nowego pracownika
@middleName - drugię imię pracownika ( może być null)
@lastName - nazwisko pracownika
@phone - numer telefonu pracownika 
@email - adres email pracownika 
@address - adres zamieszkania pracownika 
@employeeID - zwracany identyfikator pracownika*/

CREATE PROCEDURE create_internshipSupervisor

	@firstName nvarchar(50),
	@middleName nvarchar(50) = NULL,
	@lastName nvarchar(50),
	@phone varchar(50),
	@email nvarchar(50),
	@address nvarchar(50),
	@internshipSupervisorID INT OUTPUT

AS BEGIN

	DECLARE @inserted_internshipSupervisor TABLE (employeeID INT);

AS BEGIN
	IF EXISTS @email in (SELECT email FROM employee)
	BEGIN 
    	RAISERROR(Ten email już istnieje w bazie.);
RETURN
END

IF EXISTS @phone in (SELECT phoneFROM employee)
	BEGIN 
    	RAISERROR(Ten numer telefonu już istnieje w bazie.);
RETURN
END


	INSERT INTO employee (firstName,middleName,lastName,phone,email,[address])
	OUTPUT INSERTED.employeeID INTO @inserted_internshipSupervisor
	VALUES (@firstName,@middleName,@lastName,@phone,@email,@address);

	SELECT @internshipSupervisorID = employeeID FROM @inserted_internshipSupervisor;

	INSERT INTO internshipSupervisor (internshipSupervisorID)
	VALUES (@internshipSupervisorID);

END;


/*Procedura create_new_title służy do dodania nowego tytułu naukowego do bazy danych, jeśli dany tytuł już istnieje, system pokaże błąd i nie doda go ponownie do bazy.

Argumenty procedury:
@titleName nvarchar(50) - nazwa wprowadzanego tytułu*/


CREATE PROCEDURE create_new_title
	@titleName NVARCHAR(50),
	@titleID INT OUTPUT
AS
BEGIN
	IF EXISTS (SELECT 1 FROM titles WHERE titleName = @titleName)
	BEGIN
   	RAISERROR('Tytuł o nazwie "%s" już istnieje w bazie danych.', 16, 1, @titleName);
   	RETURN;
	END
	ELSE
	BEGIN
    	DECLARE @inserted_title TABLE (titleID INT);

    	INSERT INTO titles (titleName)
    	OUTPUT INSERTED.titleID INTO @inserted_title
    	VALUES (@titleName);

    	SELECT @titleID = titleID FROM @inserted_title;
	END
END;


/*Procedura create_president dodaje do bazy nowego pracownika - rektora oraz od razu określa jego tytuł naukowy. Jeśli danego tytułu nie ma w bazie, ta procedura doda go automatycznie.

Argumenty procedury:
@firstname - imię nowego pracownika
@middleName - drugię imię pracownika ( może być null)
@lastName - nazwisko pracownika
@phone - numer telefonu pracownika 
@email - adres email pracownika 
@address - adres zamieszkania pracownika 
@titleName - tytuł naukowy pracownika
@employeeID - zwracany identyfikator pracownika
@titleID - zwracany identyfikator tytułu*/

CREATE PROCEDURE create_president

	@firstName nvarchar(50),
	@middleName nvarchar(50) = NULL,
	@lastName nvarchar(50),
	@phone varchar(50),
	@email nvarchar(50),
	@address nvarchar(50),
	@titleName nvarchar(50),
	@presidentID INT OUTPUT,
	@titleID INT OUTPUT

AS BEGIN

	DECLARE @inserted_president TABLE (employeeID INT);

 	AS BEGIN
	IF EXISTS @email in (SELECT email FROM employee)
	BEGIN 
    	RAISERROR(Ten email już istnieje w bazie.);
RETURN
END

IF EXISTS @phone in (SELECT phoneFROM employee)
	BEGIN 
    	RAISERROR(Ten numer telefonu już istnieje w bazie.);
RETURN
END


	INSERT INTO employee (firstName,middleName,lastName,phone,email,[address])
	OUTPUT INSERTED.employeeID INTO @inserted_president
	VALUES (@firstName,@middleName,@lastName,@phone,@email,@address);

	SELECT @presidentID = employeeID FROM @inserted_president;

	IF EXISTS (select 1 from titles where titleName=@titleName)
    	BEGIN
        	SELECT @titleID = titleID FROM titles WHERE titleName = @titleName;
    	END
	ELSE
    	BEGIN
        	INSERT INTO titles (titleName)
        	VALUES (@titleName);

        	SELECT @titleID = SCOPE_IDENTITY();
    	END


	INSERT INTO president (presidentID,titleID)
	VALUES (@presidentID,@titleID);

END 

/*Procedura create_instructor dodaje do bazy nowego pracownika - nauczyciela oraz od razu określa jego tytuł naukowy. Jeśli danego tytułu nie ma w bazie, ta procedura doda go automatycznie.


Argumenty procedury:
@firstname - imię nowego pracownika
@middleName - drugię imię pracownika ( może być null)
@lastName - nazwisko pracownika
@phone - numer telefonu pracownika 
@email - adres email pracownika 
@address - adres zamieszkania pracownika 
@titleName - tytuł naukowy pracownika
@employeeID - zwracany identyfikator pracownika
@titleID - zwracany identyfikator tytułu*/


CREATE PROCEDURE create_instructor

	@firstName nvarchar(50),
	@middleName nvarchar(50) = NULL,
	@lastName nvarchar(50),
	@phone varchar(50),
	@email nvarchar(50),
	@address nvarchar(50),
	@titleName nvarchar(50),
	@instructorID INT OUTPUT,
	@titleID INT OUTPUT

AS BEGIN

	DECLARE @inserted_instructor TABLE (employeeID INT);

AS BEGIN
	IF EXISTS @email in (SELECT email FROM employee)
	BEGIN 
    	RAISERROR(Ten email już istnieje w bazie.);
RETURN
END

IF EXISTS @phone in (SELECT phoneFROM employee)
	BEGIN 
    	RAISERROR(Ten numer telefonu już istnieje w bazie.);
RETURN
END


	INSERT INTO employee (firstName,middleName,lastName,phone,email,[address])
	OUTPUT INSERTED.employeeID INTO @inserted_instructor
	VALUES (@firstName,@middleName,@lastName,@phone,@email,@address);

	SELECT @instructorID = employeeID FROM @inserted_instructor;

	IF EXISTS (select 1 from titles where titleName=@titleName)
    	BEGIN
        	SELECT @titleID = titleID FROM titles WHERE titleName = @titleName;
    	END
	ELSE
    	BEGIN
        	INSERT INTO titles (titleName)
        	VALUES (@titleName);

        	SELECT @titleID = SCOPE_IDENTITY();
    	END


	INSERT INTO instructor (instructorID,titleID)
	VALUES (@instructorID,@titleID);

END


/*Procedura change_instructor_title służy do zmiany tytułu naukowego instruktora.

Argumenty procedury:
@instructorID - identyfikator instruktora, którego tytuł chcemy zaktualizować
@titleID - identyfikator nowego tytułu*/



CREATE PROCEDURE change_instructor_title
	@instructorID INT,
	@newTitleID INT
AS
BEGIN
	IF NOT EXISTS (SELECT 1 FROM instructor WHERE instructorID = @instructorID)
	BEGIN
    	RAISERROR('Instruktor o ID %d nie istnieje w bazie. Możesz go dodać korzystając z procedury create_instructor.', 16, 1, @instructorID);
    	RETURN;
	END

	IF NOT EXISTS (SELECT 1 FROM titles WHERE titleID = @newTitleID)
	BEGIN
    	RAISERROR('Tytuł o ID %d nie istnieje w tabeli tytułów. Możesz go dodać korzystając z procedury create_new_title.', 16, 1, @newTitleID);
    	RETURN;
	END

	UPDATE instructor
	SET titleID = @newTitleID
	WHERE instructorID = @instructorID;
END;

/*Procedura create_new_language służy do dodania nowego tytułu naukowego do bazy danych, jeśli dany tytuł już istnieje, system pokaże błąd i nie doda go ponownie do bazy.

Argumenty procedury:
@languageName nvarchar(50) - nazwa wprowadzanego języka*/


CREATE PROCEDURE create_new_language
	@languageName NVARCHAR(50),
	@languageID INT OUTPUT
AS
BEGIN
	IF EXISTS (SELECT 1 FROM language WHERE languageName = @languageName)
	BEGIN
   	RAISERROR('Język o nazwie "%s" już istnieje w bazie danych.', 16, 1, @languageName);
   	RETURN;
	END
	ELSE
	BEGIN
    	DECLARE @inserted_language TABLE (languageID INT);

    	INSERT INTO language (languageName)
    	OUTPUT INSERTED.languageID INTO @inserted_language
    	VALUES (@languageName);

    	SELECT @languageID = languageID FROM @inserted_language;
	END
END;

/*Procedura assign_new_language_to_translator służy do przypisania nowego języka do tłumacza.


Argumenty procedury:
@transtaltorID - identyfikator tłumacz, któremu przypisujemy nowy język
@newLanguage - nazwa nowego języka */

CREATE PROCEDURE assign_new_language_to_translator

@transtaltorID INT,
@newLanguage NVARCHAR(50)

AS BEGIN

	DECLARE @languageID INT

IF NOT EXISTS (SELECT 1 FROM translator WHERE translatorID = @translatorID) 	
BEGIN 	
RAISERROR('Tłumacz o podanym ID (%d) nie istnieje w bazie danych.', 16, 1, @translator ID); 	     
RETURN; 
END


	IF EXISTS ( select 1 from language where languageName=@newLanguage)
	BEGIN
    	select @languageID = languageID from language where languageName=@newLanguage;
	END

	ELSE
    
	BEGIN
    	RAISERROR('Języka o takiej nazwie nie ma w bazie danych, możesz go dodać używając procedury create_new_language', 16, 1, @newLanguage);
    	RETURN;
	END

	INSERT INTO translatorDetails (translatorID,languageID)
	VALUES (@transtaltorID,@languageID)

END

--Przykład użycia procedury assign_new_language_to_translator

EXEC assign_new_language_to_translator
@transtaltorID = 0,
@newLanguage = 'Spanish'

/*Procedura assign_new_subject_to_insructor służy do przypisania nowego przedmiotu do nauczyciela.


Argumenty procedury:
@instructorID - identyfikator nauczyciela
@newSubject - nazwa przypisywanego przedmiotu*/

CREATE PROCEDURE assign_new_subject_to_instructor

@instructorID INT,
@newSubject NVARCHAR(50)

AS BEGIN

	DECLARE @subjectID INT

IF NOT EXISTS (SELECT 1 FROM instructor WHERE instructorID = @instructorID) 	
BEGIN 	
RAISERROR('Instruktor o podanym ID (%d) nie istnieje w bazie danych.', 16, 1, @instructorID); 	     
RETURN; 
END

	IF EXISTS ( select 1 from subject where subjectName=@newSubject)
	BEGIN
    	select @subjectID = subjectID from subject where subjectName=@newSubject;
	END

	ELSE
    
	BEGIN
    	RAISERROR('Przedmiotu o takiej nazwie nie ma w bazie danych, możesz go dodać używając procedury create_new_subject', 16, 1, @newSubject);
    	RETURN;
	END

	INSERT INTO instructorDetails (instructorID,subjectID)
	VALUES (@instructorID,@subjectID)

END

--Przykładowe użycie procedury assign_new_subject_to_insructor 

EXEC assign_new_subject_to_instructor
@instructorID = 4,
@newSubject = 'Math'



/*Procedura create_new_subject służy do dodawania do bazy danych nowego przedmiotu.

Argumenty procedury:
@subjectName - nazwa nowego przedmiotu
@description - opis przedmiotu*/


CREATE PROCEDURE create_new_subject
	@subjectName NVARCHAR(50),
	@description nvarchar(2000)

AS
BEGIN
	IF EXISTS (SELECT 1 FROM subject WHERE subjectName = @subjectName)
	BEGIN
   	RAISERROR('Przedmiot o nazwie "%s" już istnieje w bazie danych.', 16, 1, @subjectName);
   	RETURN;
	END
	ELSE
	BEGIN
    	INSERT INTO subject (subjectName,description)
    	VALUES (@subjectName,@description);
    	PRINT 'Przedmiot o nazwie "' + @subjectName + '" został pomyślnie dodany do bazy danych.';
	END
END

--Przykładowe użycie procedury create_new_subject

EXEC create_new_subject
@subjectName = 'Math',
@description = 'Elements of algebra and mathematical analysis.'



/*Procedura change_president_title służy do zmiany tytułu naukowego rektora.


Argumenty procedury:
@presidentID - identyfikator instruktora, którego tytuł chcemy zaktualizować
@titleID - identyfikator nowego tytułu*/



CREATE PROCEDURE change_president_title
	@presidentID INT,
	@newTitleID INT
AS
BEGIN
	IF NOT EXISTS (SELECT 1 FROM president WHERE presidentID = @presidentID)
	BEGIN
    	RAISERROR('rektor o ID %d nie istnieje w bazie. Możesz go dodać korzystając z procedury create_president.', 16, 1, @presdentID);
    	RETURN;
	END

	IF NOT EXISTS (SELECT 1 FROM titles WHERE titleID = @newTitleID)
	BEGIN
    	RAISERROR('Tytuł o ID %d nie istnieje w tabeli tytułów. Możesz go dodać korzystając z procedury create_new_title.', 16, 1, @newTitleID);
    	RETURN;
	END

	UPDATE president
	SET titleID = @newTitleID
	WHERE presidentID = @presidentID;
END;


--Przykładowe wywołanie procedury change_president_title

EXEC change_president_title
@presidentID = 1,
@newTitleID = 3;



/*Procedura create_new_participant służy do dodawania nowego użytkownika - uczestnika programu naukowego oferowanego przez firmę. Procedura zwraca identyfikator nowego użytkownika.

Argumenty procedury:
@firstname - imię nowego użytkownika
@lastName - nazwisko użytkownika
@email - adres email użytkownika
@phone - numer telefonu użytkownika
@address - adres zamieszkania użytkownika
@participantID - zwracany identyfikator użytkownika*/

CREATE PROCEDURE create_new_participant

	@firstName nvarchar(50),
	@lastName nvarchar(50),
	@email nvarchar(50),
	@phone nvarchar(50),
	@address nvarchar(50),
	@participantID int OUTPUT

	AS BEGIN
	IF EXISTS @email in (SELECT email FROM participant)
	BEGIN 
    	RAISERROR(Ten email już istnieje w bazie.);
RETURN
END

IF EXISTS @phone in (SELECT phoneFROM participant)
	BEGIN 
    	RAISERROR(Ten numer telefonu już istnieje w bazie.);
RETURN
END



	DECLARE @inserted_participant TABLE (participantID int)
	INSERT INTO participant (firstName,lastName,phone,email,[address])
	OUTPUT INSERTED.participantID INTO @inserted_participant
	VALUES (@firstName,@lastName,@phone,@email,@address)

	END 	

--Przykładowe wywołanie procedury create_new_participant

DECLARE @newParticipantID int;
EXEC create_new_participant


@firstName = 'Maciej',
@lastName = 'Sawiec',
@email = 'msawiec@agh.pl',
@phone = '123-123-1234',
@address = 'akademicka 23',
@participantID = @newParticipantID OUTPUT



/*Procedura create_student służy do dodania użytkownika na listę studentów.

Argumenty procedury:
@participantID - identyfikator użytkownika
@classID - identyfikator grupy (konkretny rocznik i kierunek studiów)*/

CREATE PROCEDURE create_student
	@participantID INT,
	@classID INT


AS BEGIN

	declare @actual_amount int
	declare @limit int

	select @actual_amount = count(*) from students where classID = @classID
	select @limit = limit from class where classID = @classID

	if @actual_amount=@limit
	BEGIN	 
   	RAISERROR('Ta grupa jest już pełna.', 16, 1);
	RETURN;
	END


	IF NOT EXISTS (SELECT 1 FROM participant WHERE participantID = @participantID)	 
	BEGIN	 
   	RAISERROR('Użytkownika o takim identyfikatorze nie ma w bazie danych', 16, 1);
	RETURN;
	END

	IF NOT EXISTS (SELECT 1 FROM class WHERE classID = @classID)	 
	BEGIN	 
   	RAISERROR('Grupy o takim identyfikatorze nie ma w bazie danych', 16, 1);
	RETURN;
	END

	INSERT INTO students (participantID,classID)
	VALUES (@participantID,@classID)

END

--Przykładowe wywołanie procedury create_student

EXEC create_student

@participantID = 2,
@classID = 7


/*Procedura delete_student służy do usunięcia użytkownika z listy studentów z konkretnego kierunku.

Argumenty procedury:
@participantID - identyfikator użytkownika
@classID - identyfikator grupy (konkretny rocznik i kierunek studiów)*/

CREATE PROCEDURE delete_student
	@participantID INT,
	@classID INT


AS BEGIN

	IF NOT EXISTS (SELECT 1 FROM participant WHERE participantID = @participantID)	 
    	BEGIN	 
       	RAISERROR('Użytkownika o takim identyfikatorze nie ma w bazie danych', 16, 1);
    	RETURN;
    	END

    	IF NOT EXISTS (SELECT 1 FROM class WHERE classID = @classID)	 
    	BEGIN	 
       	RAISERROR('Grupy o takim identyfikatorze nie ma w bazie danych', 16, 1);
    	RETURN;
    	END

	IF NOT EXISTS (SELECT 1 FROM students WHERE participantID = @participantID and classID=@classID)	 
    	BEGIN	 
       	RAISERROR('Użytkownik o takim identyfikatorze nie należy do tej grupy', 16, 1);
    	RETURN;
    	END


	delete from students where participantID = @participantID AND classID = @classID

END

--Przykładowe wywołanie procedury delete_student

EXEC delete_student


@participantID = 2,
@classID = 7



/*Procedura create_new_major służy do dodawania do bazy danych nowych kierunków studiów.


Argumenty procedury:
@name - nazwa kierunku
@description - opis kierunku 
@supervisorID - identyfikator opiekuna kierunku*/

CREATE PROCEDURE create_new_major

	@name nvarchar(50),
	@description nvarchar(50),
	@supervisorID int

AS BEGIN

	IF NOT EXISTS (SELECT 1 FROM instructor WHERE instructorID = @supervisorID)	 
    	BEGIN	 
       	RAISERROR('Użytkownika o takim identyfikatorze nie ma w bazie danych', 16, 1);
    	RETURN;
    	END


	INSERT INTO major (name,description,supervisorID)
	VALUES (@name,@description,@supervisorID)

END

--Przykładowe wywołanie procedury create_new_major

EXEC create_new_major
      
@name = 'Data Science',
@description = ' Students learn to solve complex problems using computational thinking and modern technologies, preparing them for careers in software development, IT and data science.',
@supervisorId = 4



/*Procedura create_syllabus służy do dodawania przedmiotu do listy zajęć dla danego kierunku studiów w danym semestrze.


Argumenty procedury:
@majorID - identyfikator kierunku studiów
@subjectID - identyfikator przedmiotu
@requiredHours - liczba godzin przedmiotu
@term - numer semestru, na którym dane zajęcia będą się odbywać */


CREATE PROCEDURE create_syllabus

	@majorID int,
	@subjectID int,
	@requiredHours int,
	@term int

AS BEGIN

	IF NOT EXISTS (SELECT 1 FROM major WHERE majorID = @majorID)	 
    	BEGIN	 
       	RAISERROR('Kierunek studiów o takim identyfikatorze nie istnieje w bazie danych', 16, 1);
    	RETURN;
    	END

	IF NOT EXISTS (SELECT 1 FROM subject WHERE subjectID = @subjectID)	 
    	BEGIN	 
       	RAISERROR('Przedmiot o takim identyfikatorze nie istnieje w bazie danych', 16, 1);
    	RETURN;
    	END
	IF @term NOT BETWEEN 1 AND 7
    	BEGIN	 
       	RAISERROR('Numer semestru musi być nie większy niż 7 i nie mniejszy niż 1. ', 16, 1);
    	RETURN;
    	END

	INSERT INTO syllabus (majorID,subjectID,requiredHours,term)
	VALUES (@majorID,@subjectID,@requiredHours,@term)

END

--Przykładowe wywołanie procedury create_syllabus

EXEC create_syllabus

	@majorID = 1,
	@subjectID = 4,
	@requiredHours = 56,
	@term = 3


/*Procedura create_company służy do wprowadzenia nowej firmy oferującej praktyki do bazy danych.

Argumenty procedury:
@companyName - nazwa firmy
@address - adres firmy
@email - email firmy
@phone - numer telefonu */

CREATE PROCEDURE create_company

	@companyName nvarchar(50),
	@address nvarchar(50),
	@email varchar(50),
	@phone varchar(16)

	AS BEGIN

	IF EXISTS (select 1 from company where companyName=@companyName and address=@address and email=@email and phone=@phone)
    
	BEGIN
	RAISERROR('Firma istnieje już w bazie danych.', 16, 1);
	RETURN;
	END

	ELSE

	BEGIN
	INSERT INTO company(companyName,[address],email,phone)
	VALUES (@companyName,@address,@email,@phone)
	END

	END

--Przykładowe użycie procedury create_company
EXEC create_company


   @companyName = 'agh company',
   @address = 'Krakowska 33',
   @email = 'agh@edu.pl',
   @phone = 111222333



/*Procedura create_internship służy do wprowadzenia do bazy nowych praktyk dla studentów.

Argumenty procedury:
@companyID - identyfikator firmy oferującej praktyki
@startDate - data rozpoczęcia praktyk
@supervisorID - identyfikator opiekuna praktyk */


CREATE PROCEDURE create_internship

	@companyID int,
	@startDate datetime,
	@supervisorID int

	AS BEGIN

	IF NOT EXISTS (select 1 from company where companyID=@companyID)
	BEGIN
	RAISERROR('Firma o podanym identyfikatorze nie istnieje w bazie danych.', 16, 1);
	RETURN;
	END

	IF NOT EXISTS (select 1 from internshipSupervisor where internshipSupervisorID=@supervisorID)
	BEGIN
	RAISERROR('Opiekun praktyk o podanym identyfikatorze nie istnieje w bazie danych.', 16, 1);
	RETURN;
	END

	IF EXISTS (select 1 from internship where supervisorID=@supervisorID and DAY(startDate) = DAY(@startDate) and MONTH(startDate) = MONTH(@startDate) and YEAR(startDate) = YEAR(@startDate))
	BEGIN
	RAISERROR('Opiekun praktyk o podanym identyfikatorze prowadzi w tym terminie inne praktyki.', 16, 1);
	RETURN;
	END

	ELSE

	BEGIN
	INSERT INTO internship(companyID,startDate,supervisorID)
	VALUES (@companyID,@startDate,@supervisorID)
	END

	END

--Przykładowe użycie create_internship

EXEC create_internship
	@companyID = 1,
	@startDate = '2025-01-13 15:45:30',
	@supervisorID = 2 


/*Procedura create_class służy do dodawania grup (konkretny rocznik na konkretnym kierunku studiów). Procedura jednocześnie dodaje class jako produkt do tabeli products.

Argumenty procedury:
@year - rok rozpoczęcia studiów
@limit - maksymalna ilość zapisanych osób
@majorID - identyfikator kierunku studiów
@languageID - identyfikator języka, w którym prowadzone jest nauczanie 
@price money - wpisowe na studia
@isAvailable - czy do grupy można aktualnie się zapisywać*/

CREATE PROCEDURE create_class
    
	@year int,
	@limit int,
	@majorID int,
	@languageID int,
	@price money,
	@isAvailable bit,
	@productID int output

	AS BEGIN


	IF NOT EXISTS (select 1 from major where majorID=@majorID)
	BEGIN
	RAISERROR('Kierunek studiów o podanym identyfikatorze nie istnieje w bazie danych.', 16, 1);
	RETURN;
	END

	IF NOT EXISTS (select 1 from language where languageID=@languageID)
	BEGIN
	RAISERROR('Języka o podanym identyfikatorze nie istnieje w bazie danych.', 16, 1);
	RETURN;
	END


	declare @inserted_product TABLE (productID INT);
	declare @typeID int;

	select @typeID = typeID from productTypes where typeName='Studies';
	BEGIN
	INSERT INTO products (isAvailable,typeID)
	OUTPUT INSERTED.productID INTO @inserted_product
	VALUES (@isAvailable,@typeID)
	END

	select @productID = productID from @inserted_product;


	INSERT INTO class([year],[limit],majorID,productID,languageID,term,price)
	VALUES (@year,@limit,@majorID,@productID,@languageID,1,@price)
END
GO

EXEC create_class
   @year =1,
   @limit= 40,
   @majorID= 1,
   @languageID= 1,
   @price= 1,
   @isAvailable= 1,
   @productID = 1



--Procedura create_finalExam służy dodawania wyników egzaminów dla konkretnego studenta na konkretnych studiach

CREATE PROCEDURE create_finalExam

	@participantID INT,
	@classID INT,
	@passed BIT

AS	
	BEGIN
	IF NOT EXISTS (select 1 from students where participantID=@participantID and classID=@classID)
		BEGIN
		RAISERROR('Brak uczestnika na liście studentów.', 16, 1); 
		RETURN;
		END
	ELSE
		BEGIN
		IF EXISTS (select 1 from finalExam where participantID=@participantID and classID=@classID)
			BEGIN
			RAISERROR('Wynik już został zatwierdzony.', 16, 1); 
			RETURN;
			END
		ELSE
			BEGIN
			INSERT INTO finalExam(participantID,classID,passed)
			VALUES (@participantID,@classID,@passed)
			END
		END
	END
GO


--Procedura pay_advance służy do aktualizowania danych w przypadku zapłaconej zaliczki - zmienia status zamówienia oraz datę wpłacenia zaliczki

DROP PROCEDURE pay_advance
CREATE PROCEDURE pay_advance
   @OrderID INT

AS
      BEGIN
      IF NOT EXISTS (select 1 from orders where orderID = @OrderID)
         BEGIN
         RAISERROR(N'Zamówienie o podanym ID nie istnieje', 16, 1);
         END
      ELSE
         BEGIN
             UPDATE orderDetails
             SET advancePaymentDate = GETDATE()
             WHERE orderID = @OrderID
         END
       END
GO


--Procedura change_finalExam służy do zmiany wyniku egzaminu studenta (np. po II terminie egzaminów)

CREATE PROCEDURE change_finalExam

	@participantID INT,
	@classID INT,
	@passed BIT

AS	
	BEGIN
	IF NOT EXISTS (select 1 from finalExam where participantID=@participantID and classID=@classID)
		BEGIN
		RAISERROR('Brak wyniku do zmiany, użyj create_finalExam.', 16, 1); 
		RETURN;
		END
	ELSE
		BEGIN
		IF EXISTS (select 1 from finalExam where participantID=@participantID and classID=@classID and passed=@passed)
			BEGIN
			RAISERROR('Wynik taki sam jak poprzedni.', 16, 1); 
			RETURN;
			END
		ELSE
			BEGIN
			UPDATE finalExam
			SET	passed = @passed
			WHERE participantID=@participantID and classID=@classID
			END
		END
	END
GO

--Procedura create_webinar dodaje webinar i odpowiadające mu webinarDetails i products

CREATE PROCEDURE create_webinar
	
	@price decimal(7,2) = NULL,
	@webinarName nvarchar(50),
	@instructorID int,
    @meetingLink varchar(2083),
    @recordingLink varchar(2083) = NULL,
    @description nvarchar(2000),
    @translatorID int = NULL,
    @languageID int

AS
	BEGIN
	IF NOT EXISTS (select 1 from employee where employeeID = @instructorID)
		BEGIN
		RAISERROR('Brak takiego pracownika.', 16, 1); 
		RETURN;
		END
	IF NOT EXISTS (select 1 from language where languageID = @languageID)
		BEGIN
		RAISERROR('Brak takiego języka.', 16, 1); 
		RETURN;
		END
	IF @translatorID IS NOT NULL
		BEGIN
		IF NOT EXISTS (select 1 from translator where translatorID = @translatorID)
			BEGIN
			RAISERROR('Brak takiego tłumacza.', 16, 1); 
			RETURN;
			END
		ELSE
			BEGIN
			IF NOT EXISTS (select 1 from translatorDetails where translatorID = @translatorID and languageID = @languageID)
				BEGIN
				RAISERROR('Ten tłumacz nie ma takiej kompetencji.', 16, 1); 
				RETURN;
				END
			END
		END

	declare @inserted_product TABLE (prodID INT);
	INSERT INTO products(isAvailable,typeID)
		OUTPUT INSERTED.productID INTO @inserted_product
	VALUES (1,(select typeID from productTypes where typeName = 'Webinar' ))
	declare @productID INT = (select top 1 prodID from @inserted_product);

	declare @inserted_webinar TABLE (webinarID INT);
	INSERT INTO webinar(productID,price,webinarName)
	OUTPUT INSERTED.webinarID INTO @inserted_webinar
	VALUES (@productID,@price,@webinarName)
	declare @webinarID INT = (select top 1 webinarID from @inserted_webinar);
	
	INSERT INTO webinarDetails (webinarID,instructorID,meetingLink,recordingLink,[description],translatorID,languageID)
	VALUES(@webinarID,@instructorID,@meetingLink,@recordingLink,@description,@translatorID,@languageID)
	
	END
GO

--Procedura create_webinarParticipants dodaje uczestników do webinaru
CREATE PROCEDURE create_webinarParticipants

	@webinarID INT,
	@participantID INT,
	@accesUntil datetime = NULL

AS	
	BEGIN
	IF NOT EXISTS (select 1 from participant where participantID=@participantID)
		BEGIN
		RAISERROR('Brak uczestnika na liście uczestników.', 16, 1); 
		RETURN;
		END
	IF NOT EXISTS (select 1 from webinar where webinarID=@webinarID)
		BEGIN
		RAISERROR('Brak takiego webinaru.', 16, 1); 
		RETURN;
		END
	IF @accesUntil IS NULL
		BEGIN
		SET @accesUntil = DATEADD(day,30,getdate())
		END
	IF EXISTS (select 1 from webinarParticipants where participantID=@participantID and webinarID=@webinarID)
		BEGIN
		UPDATE webinarParticipants
		SET	accessUntil = @accesUntil
		WHERE participantID=@participantID and webinarID=@webinarID
		END
	ELSE
		BEGIN
		INSERT INTO webinarParticipants(participantID,webinarID,accessUntill)
		VALUES (@participantID,@webinarID,@accesUntil)
		END
	END
GO

--Procedura create_course dodaje nowy kurs wraz z products i courseDetails

CREATE PROCEDURE create_course
	
    @price decimal(7,2) ,
    @advancePrice decimal(7,2) ,
    @limit int = NULL,
    @title nvarchar(50),
    @description nvarchar(2000),
    @languageID int 

AS
	BEGIN
	IF NOT EXISTS (select 1 from language where languageID = @languageID)
		BEGIN
		RAISERROR('Brak takiego języka.', 16, 1); 
		RETURN;
		END

	declare @inserted_product TABLE (prodID INT);
	INSERT INTO products(isAvailable,typeID)
		OUTPUT INSERTED.productID INTO @inserted_product
	VALUES (1,(select typeID from productTypes where typeName = 'Course' ))
	declare @productID INT = (select top 1 prodID from @inserted_product);

	declare @inserted_course TABLE (courseID INT);
	INSERT INTO course(productID,price,advancePrice,[limit])
	OUTPUT INSERTED.courseID INTO @inserted_course
	VALUES (@productID,@price,@advancePrice,@limit)
	declare @courseID INT = (select top 1 courseID from @inserted_course);
	
	INSERT INTO courseDetails (courseID,title,[description],languageID)
	VALUES(@courseID,@title,@description,@languageID)
	
	END
GO

--Procedura create_convention tworzy nowy zjazd i dodaje go do studiów

CREATE PROCEDURE create_convention

    @classID int,
    @limit int,
    @price decimal(7,2),
    @priceForStudents decimal(7,2),
    @conventionTypeID int

AS
	BEGIN
	IF NOT EXISTS (select 1 from class where classID = @classID)
		BEGIN
		RAISERROR('Brak takich studiów.', 16, 1); 
		RETURN;
		END
	IF @limit < (select top 1 limit from class where classID = @classID)
		BEGIN
		RAISERROR('Za niski limit osob.', 16, 1); 
		RETURN;
		END
	IF @priceForStudents > @price
		BEGIN
		RAISERROR('Ceny dla studentów wyższe od normalnych.', 16, 1); 
		RETURN;
		END
	IF NOT EXISTS (select 1 from conventionType where @conventionTypeID = typeID)
		BEGIN
		RAISERROR('Nie istnieje taki typ zjazdu.', 16, 1); 
		RETURN;
		END

	declare @inserted_product TABLE (prodID INT);
	INSERT INTO products(isAvailable,typeID)
	OUTPUT INSERTED.productID INTO @inserted_product
	VALUES (1,(select typeID from productTypes where typeName = 'Convention' ))
	declare @productID INT = (select top 1 prodID from @inserted_product);

	INSERT INTO convention(classID,productID,[limit],price,priceForStudents,conventionTypeID)
	VALUES (@classID,@productID,@limit,@price,@priceForStudents,@conventionTypeID)

	END
GO

--Procedura create_module tworzy moduł dla konkretnego kursu
CREATE PROCEDURE create_module
	
    @courseID int  ,
    @description nvarchar(2047) ,
    @moduleTypeID int

AS
	BEGIN
	IF NOT EXISTS (select 1 from course where courseID = @courseID)
		BEGIN
		RAISERROR('Brak takich kursów.', 16, 1); 
		RETURN;
		END
	IF NOT EXISTS (select 1 from moduleTypes where moduleTypeID = @moduleTypeID)
		BEGIN
		RAISERROR('Nie ma takiego rodzaju modułów.', 16, 1); 
		RETURN;
		END

	INSERT INTO module(courseID,[description],moduleTypeID)
	VALUES (@courseID,@description,@moduleTypeID)

	END
GO

--Procedura create_stationary_meeting dodaje spotkanie stacjonarne do tabeli meeting, ponadto dodaje odpowiadające mu wiersze w stationaryMeeting, meetingTime, roomDetails i zależnie od podanych argumentów dodaje do zjazdu lub modułu

CREATE PROCEDURE create_stationary_meeting
	
	@subjectID int,
    @instructorID int,
    @translatorID int = NULL,
    @languageID int,
	@conventionID int = NULL,
	@moduleID int = NULL,
	@roomID int,
	@startTime Datetime,
	@endTime Datetime

AS
	BEGIN
	IF NOT EXISTS (select 1 from subject where subjectID = @subjectID)
		BEGIN
		RAISERROR('Brak takiego przedmiotu.', 16, 1); 
		RETURN;
		END
	IF NOT EXISTS (select 1 from instructor where instructorID = @instructorID)
		BEGIN
		RAISERROR('Brak takiego nauczyciela.', 16, 1); 
		RETURN;
		END
	IF NOT EXISTS (select 1 from instructorDetails where instructorID = @instructorID and subjectID = @subjectID)
		BEGIN
		RAISERROR('Ten nauczyciel nie może uczyć tego przedmiotu.', 16, 1); 
		RETURN;
		END
	IF NOT EXISTS (select 1 from language where languageID = @languageID)
		BEGIN
		RAISERROR('Nie ma takiego języka na liście.', 16, 1); 
		RETURN;
		END
	IF @translatorID IS NOT NULL
		BEGIN
		IF NOT EXISTS (select 1 from translator where translatorID = @translatorID)
			BEGIN
			RAISERROR('Brak takiego tłumacza.', 16, 1); 
			RETURN;
			END
		ELSE
			BEGIN
			IF NOT EXISTS (select 1 from translatorDetails where translatorID = @translatorID and languageID = @languageID)
				BEGIN
				RAISERROR('Ten tłumacz nie ma takiej kompetencji.', 16, 1); 
				RETURN;
				END
			END
		END
	IF (@conventionID IS NULL and @moduleID IS NULL) OR (@conventionID IS NOT NULL and @moduleID IS NOT NULL)
		BEGIN
		RAISERROR('Spotkanie powinno być przydzielone albo do modułu albo do zjazdu.', 16, 1);
		RETURN;
		END
	IF @moduleID IS NOT NULL
		BEGIN
		IF NOT EXISTS (select 1 from module where moduleID = @moduleID and (moduleTypeID = (select 1 from moduleTypes where moduleName = 'stationary') or moduleTypeID = (select 1 from moduleTypes where moduleName = 'hybrid')))
			BEGIN
			RAISERROR('Brak takiego modułu lub zły tryb modułu.', 16, 1); 
			RETURN;
			END
		END
	IF @conventionID IS NOT NULL
		BEGIN
		IF NOT EXISTS (select 1 from convention where conventionID = @conventionID and (conventionTypeID = (select 1 from conventionType where typeName = 'stationary') or conventionTypeID = (select 1 from conventionType where typeName = 'hybrid')))
			BEGIN
			RAISERROR('Brak takiego zjazdu lub zły tryb zjazdu.', 16, 1); 
			RETURN;
			END
		END
	IF NOT EXISTS (select 1 from rooms where roomID = @roomID)
		BEGIN
		RAISERROR('Nie ma takiego pokoju.', 16, 1); 
		RETURN;
		END

	declare @inserted_meeting TABLE (meetingID INT);
	INSERT INTO meeting(subjectID,instructorID,translatorID,languageID,meetingModeID)
	OUTPUT INSERTED.meetingID INTO @inserted_meeting
	VALUES (@subjectID, @instructorID, @translatorID, @languageID, (select 1 from meetingMode where modeName = 'stationary'))
	declare @meetingID INT = (select top 1 meetingID from @inserted_meeting);

	INSERT INTO stationaryMeeting(meetingID,roomID)
	VALUES (@meetingID,@roomID)

	INSERT INTO meetingTime(meetingID,startTime,endTime)
	VALUES (@meetingID, @startTime, @endTime)

	INSERT INTO roomDetails(roomID,usedBy,startTime,endTime)
	VALUES (@roomID,@instructorID,@startTime,@endTime)

	IF @moduleID IS NOT NULL
		BEGIN
		INSERT INTO moduleSchedule(moduleID,meetingID)
		VALUES (@moduleID,@meetingID)
		END

	IF @conventionID IS NOT NULL
		BEGIN
		INSERT INTO studySchedule(conventionID,meetingID)
		VALUES (@conventionID,@meetingID)
		END

	END
GO

--Procedura create_order tworzy listę zakupów (koszyk na produkty)
CREATE PROCEDURE create_order 
    @participantID int,
    @paymentLink varchar(2047),
    @orderDate datetime = NULL

AS
	BEGIN
		IF NOT EXISTS (select * from participant where participantID = @participantID)
			BEGIN
			RAISERROR('Nie ma takiego uczestnika.', 16, 1);
			RETURN;
			END
		IF @orderDate IS NULL
			BEGIN
			SET @orderDate = GETDATE()
			END

		INSERT INTO orders(participantID,paymentLink,orderDate)
		VALUES (@participantID,@paymentLink,@orderDate)
	END
GO

--Procedura add_product_to_order dodaje produkt do listy zakupów

CREATE PROCEDURE add_product_to_order
	
	@orderID int,
    @productID int

AS
	BEGIN
	IF NOT EXISTS (select * from orders where orderID = @orderID)
		BEGIN
		RAISERROR('Nie ma takiego takiego koszyka.', 16, 1);
		RETURN;
		END
	IF NOT EXISTS (select * from products where productID = @productID)
		BEGIN
		RAISERROR('Nie ma takiego takiego koszyka.', 16, 1);
		RETURN;
		END
	
	declare @price int
	declare @productType int = (select top 1 typeID from products where productID = @productID)
	IF 'Webinar' = (select top 1 typeName from productTypes where typeID = @productType)
		BEGIN
		SET @price = (select top 1 price from webinar where productID = @productID)
		END
	IF 'Course' = (select top 1 typeName from productTypes where typeID = @productType)
		BEGIN
		SET @price = (select top 1 price from course where productID = @productID)
		END
	IF 'Studies' = (select top 1 typeName from productTypes where typeID = @productType)
		BEGIN
		SET @price = (select top 1 price from class where productID = @productID)
		END
	IF 'Convention' = (select top 1 typeName from productTypes where typeID = @productType)
		BEGIN
		declare @classID int = (select top 1 classID from convention where productID = @productID)
		declare @studentID int = (select top 1 participantID from orders where orderID = @orderID)
		IF EXISTS (select 1 from students where participantID = @studentID and classID = @classID)
			BEGIN
			SET @price = (select top 1 priceForStudents from convention where productID = @productID)
			END
		ELSE
			BEGIN
			SET @price = (select top 1 price from convention where productID = @productID)
			END
		END
	INSERT INTO orderDetails(orderID,productID,price,statusID)
	VALUES (@orderID,@productID,@price,(select top 1 statusID from orderStatus where statusType = 'in cart'))
	END
GO

--Procedura buy_product zmienia status produktu z listy zakupów na zakupiony i dodaje uczestnika który dokonał zakupu do odpowiedniej listy uczestników

CREATE PROCEDURE buy_product

	@orderID int,
	@productID int
    
AS
	BEGIN
	IF NOT EXISTS (select 1 from orders where orderID = @orderID)
    	BEGIN
    	RAISERROR('Nie ma takiego takiego koszyka.', 16, 1);
    	RETURN;
    	END
	IF NOT EXISTS (select 1
	from products where productID = @productID)
    	BEGIN
    	RAISERROR('Nie ma takiego takiego koszyka.', 16, 1);
    	RETURN;
    	END
	IF 'in cart' <>  (select top 1 statusType from orderStatus as os
                    	inner join orderDetails as od on od.statusID = os.statusID
                    	where od.productID = @productID and od.orderID=@orderID)
    	BEGIN
    	RAISERROR('Produkt nie jest w koszyku.', 16, 1);
    	RETURN;
    	END

	UPDATE orderDetails
	SET statusID = (select top 1 os.statusID from orderStatus as os where os.statusType = 'completed'), fullPaymentDate = GETDATE()
	WHERE productID = @productID
	END
GO
