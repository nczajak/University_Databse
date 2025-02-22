---Widok cart służy do wyświetlania listy użytkowników i produktów, które są dodane do ich koszyków.

CREATE VIEW cart AS
   WITH productDetails (productName, productID, price) AS
       (SELECT major.name, productID, price
           FROM class
           INNER JOIN major ON class.majorID = major.majorID
           UNION
           SELECT title, productID, price
           FROM course
           INNER JOIN courseDetails ON course.courseID = courseDetails.courseID
           UNION
           SELECT webinar.webinarName, webinar.productID, webinar.price
           FROM webinar)


   SELECT p.firstName + p.lastName AS Participant, productName AS 'Product Name'
       FROM orderDetails AS od
       INNER JOIN Orders AS o ON od.orderID = o.orderID
       INNER JOIN participant AS p ON o.participantID = p.participantID
       INNER JOIN orderStatus AS os ON od.statusID = os.statusID
       INNER JOIN productDetails AS pd ON od.productID = pd.productID
       WHERE statusType = 'in cart'

	
---Widok future_meetings_participants służy do wyświetlenia listy użytkowników zapisanych na na przyszłe wydarzenia z informacją, czy   wydarzenie jest stacjonarnie, czy zdalnie

CREATE VIEW future_meetings_participants AS
SELECT DISTINCT m.meetingID , 'stationary' AS type, COUNT(p.participantID) AS 'Number of participants'
FROM meetingTime AS mt
INNER JOIN meeting AS m ON mt.meetingID = m.meetingID
INNER JOIN meetingParticipants AS mp ON m.meetingID = mp.meetingID
INNER JOIN participant AS p ON p.participantID = mp.participantID
WHERE mt.startTime > '2024-12-31 23:59:59' AND m.meetingID in (SELECT meetingID FROM stationaryMeeting)
group by m.meetingID
UNION
SELECT DISTINCT m.meetingID , 'Online sync' AS type, COUNT(p.participantID) AS 'Number of participants'
FROM meetingTime AS mt
INNER JOIN meeting AS m ON mt.meetingID = m.meetingID
INNER JOIN meetingParticipants AS mp ON m.meetingID = mp.meetingID
INNER JOIN participant AS p ON p.participantID = mp.participantID
WHERE mt.startTime > GETDATE() AND m.meetingID in (SELECT meetingID FROM onlineSyncMeeting)
group by m.meetingID

	
---Widok students_pending_payment służy do wyświetlenia nazwisk użytkowników, oraz kwoty jaką każdy użytkownik musi zapłacić, aby ukończyć proces składania zamówienia.

CREATE VIEW students_pending_payment AS
SELECT p.firstName + ' '+ p.lastName AS Name, price
FROM orderDetails AS od
INNER JOIN orderStatus AS os ON os.statusID = od.statusID
INNER JOIN orders AS o ON o.orderID = od.OrderID
INNER JOIN participant AS p ON p.participantID = o.participantID
WHERE os.statusType = 'in progress'

	
---Widok list_of_all_debtors służy do wyświetlenia listy użytkowników, którzy dostali zgodę od dyrektora, na umorzenie płatności w późniejszym terminie.

CREATE VIEW list_of_all_debtors AS
   SELECT firstName + ' ' + lastName AS Name, price AS [Money Owned]
       FROM paymentDeferral
       INNER JOIN orders ON paymentDeferral.orderID = orders.orderID
       INNER JOIN participant ON orders.participantID = participant.participantID
       INNER JOIN orderDetails ON orders.orderID = orderDetails.orderID


---Widok webinar_income_list służy do wyświetlania przychodów z konkretnych webinarów.

create view webinar_income_list as
select w.webinarName as webinarName, sum(od.price) as income
from webinar as w
inner join products as p on w.productID = p.productID
inner join orderDetails as od on od.productID = p.productID
inner join orderStatus as os on os.statusID = od.statusID
where os.statusType = 'completed'
group by w.webinarID, w.webinarName



---Widok courses_income_list_with_status służy do wyświetlania Przychodów z kursów podział na zaliczki i pełne kwoty.

create view courses_income_list_with_status as
select
cd.title as Name,
sum(od.price) as income,
'full paid' as status
from course as c
inner join products as p on c.productID = p.productID
inner join orderDetails as od on od.productID = p.productID
inner join orderStatus as os on os.statusID = od.statusID
inner join courseDetails as cd on c.courseID = cd.courseID
where os.statusType = 'completed'
group by  c.productID, cd.title
union
select
cd.title as Name,
sum(c.advancePrice) as income,
'advance paid' as status
from course as c
inner join products as p on c.productID = p.productID
inner join orderDetails as od on od.productID = p.productID
inner join orderStatus as os on os.statusID = od.statusID
inner join courseDetails as cd on c.courseID = cd.courseID
where os.statusType = 'in progress'
group by  c.productID, cd.title
	

Widok courses_income_list służy do wyświetlania przychodów z konkretnych kursów.


create view courses_income_list as
select cd.title as Name,sum(od.price) as income
from course as c
inner join products as p on c.productID = p.productID
inner join orderDetails as od on od.productID = p.productID
inner join orderStatus as os on os.statusID = od.statusID
inner join courseDetails as cd on c.courseID = cd.courseID
where os.statusType = 'completed'
group by c.courseID, cd.title


---Widok meeting_information_report służy do wyświetlania identyfikatora spotkania, prowadzącego spotkanie, typ spotkania oraz liczbę uczestników zapisanych na spotkanie.

CREATE VIEW meeting_information_report AS
SELECT meeting.meetingID,employee.lastName + ' ' + employee.lastName AS leadBy, meetingMOde.modeName, COUNT(participantID)  AS [Number of participants]
FROM meeting
INNER JOIN meetingParticipants on meeting.meetingID = meetingParticipants.meetingID
INNER JOIN employee on meeting.instructorID = employee.employeeID
INNER JOIN meetingMode on meeting.meetingModeID = meetingMode.meetingModeID
GROUP BY meeting.meetingID, employee.lastName, meetingMOde.modeName


---Widok class_income_list służy do wyświetlenia przychodów, z wpisowych, z podziałem na kierunki studiów i roczniki.

create view class_income_list as
select [year],[name], sum(od.price) as income
from class as c
inner join products as p on c.productID = p.productID
inner join major as m on m.majorID = c.majorID
inner join orderDetails as od on od.productID = p.productID
inner join orderStatus as os on os.statusID = od.statusID
where os.statusType = 'completed'
group by [year],[name]

	
---Widok convention_income_list służy do wyświetlenia przychodów ze zjazdów, z podziałem na to, do jakiego kierunku studiów i rocznika studiów był przypisany.

create view convention_income_list as
select conventionID,[year],[name],sum(od.price) as income
from convention as c
inner join products as p on c.productID = p.productID
inner join class as cl on cl.classID=c.classID
inner join major as m on m.majorID = c.classID
inner join orderDetails as od on od.productID = p.productID
inner join orderStatus as os on os.statusID = od.statusID
where os.statusType = 'completed'
group by conventionID,[year],[name]


---Widok class_syllabus służy do wyświetlenia nazwy kierunku studiów, rocznika studiów, numer semestru, przedmiotu przypisanego na ten semestr do tego rocznika, liczba godzin do zrealizowania w ramach zajęć.

create view class_syllabus as
select
m.name as Studies,
c.year as 'Class beginning',
sub.subjectName as subject,
syl.term as semester,
syl.requiredHours as Hours
from class as c
inner join major as m on c.majorID = m.majorID
inner join syllabus as syl on syl.majorID = m.majorID
inner join subject as sub on sub.subjectID = syl.subjectID


---Widok available_products służy do wyświetlenia listy wszystkich dostępnych w ofercie produktów wraz z typem produktu (studia, kurs, webinar, zjazd) oraz ceną za produkt.

create view available_products as
   with productDetails (productName, productID, price) AS (
   select major.name, productID, price
   from class
   inner join major on class.majorID = major.majorID
   union 
   select title, productID, price
   from course
   inner join  courseDetails on course.courseID = courseDetails.courseID
   union
   select webinar.webinarName, webinar.productID, webinar.price
   from webinar
)
   select  productDetails.productName, productTypes.typeName, price
   from productTypes
   inner join products on products.typeID = productTypes.typeID and products.isAvailable = 1
   inner join productDetails on productDetails.productID = products.productID

studies for sale

---Widok  studies_for_sale służy do wyświetlenia wszystkich dostępnych w aktualnej ofercie kierunków studiów wraz z rocznikami.

create view studies_for_sale as
select [name],[year], productTypes.typeName
from productTypes
inner join products on products.typeID = productTypes.typeID and products.isAvailable = 1
inner join class on class.productID = products.productID
inner join major on class.majorID = major.majorID
where productTypes.typeName = 'studies'


--- Widok oferowane kursy słóży do wyswitlenia wszystkich aktualnych w ofercie kursów

create view courses_for_sale as
select products.productID, productTypes.typeName
from productTypes
inner join products on products.typeID = productTypes.typeID and products.isAvailable = 1
where productTypes.typeName = 'course'
oferowane webinary
create view webinars_for_sale as
select products.productID, productTypes.typeName
from productTypes
inner join products on products.typeID = productTypes.typeID and products.isAvailable = 1
where productTypes.typeName = 'webinar'
oferowane spotkania (zjazdy)
create view conventions_for_sale as
select products.productID, productTypes.typeName
from productTypes
inner join products on products.typeID = productTypes.typeID and products.isAvailable = 1
where productTypes.typeName = 'convention'


---Raport bilokacji

	
create view collision_list as
with participantMeeting as (
select mp.participantID as participant,
mp.meetingID as meeting,
mt.startTime as startTime,
mt.endTime as endTime
from meetingParticipants as mp
inner join meetingTime as mt on mp.meetingID = mt.meetingID
)
select	tba.participant, tba.meeting as 'first meeting',tba.startTime as 'first meeting start' ,tba.endTime as 'first meeting end',
    	tbb.meeting as 'second meeting',tbb.startTime as 'second meeting start' ,tbb.endTime as 'second meeting end'
from participantMeeting as tba
inner join participantMeeting as tbb on tba.participant = tbb.participant
where	tba.meeting <> tbb.meeting and
    	((tba.startTime < tbb.startTime and tba.endTime > tbb.endTime) or
    	(tba.startTime > tbb.startTime and tba.endTime > tbb.endTime and tba.startTime < tbb.endTime))
go


	
---Ogólny raport dotyczący frekwencji na zakończonych już wydarzeniach.

create view meeting_attendance as
select
m.meetingID as ID,
(select count(*) from meetingParticipants as mpar where mpar.meetingID = m.meetingID) as allParticipants,
(select count(*) from meetingParticipants as mpar where mpar.meetingID = m.meetingID and mpar.wasPresent = 1) as attendedParticipants
from meeting as m
inner join meetingTime as mt on mt.meetingID = m.meetingID
where mt.endTime < GETDATE()
go





