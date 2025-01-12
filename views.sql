--Widoki
--p�ki co przepisane z dokumentu

--1 Wy�wietlenie uczestnik�w przysz�ych wydarze� wraz typem wydarzenia(stacjonarne/niestacjonarne) i ID wydarzenia
Create view future_meetings_participants as
Select distinct  p.participantID as ID ,p.firstName + ' ' + p.lastName as Name, m.meetingID as 'ID spotkania' , 'stationary' as type
from meetingTime as mt
inner join meeting as m on mt.meetingID = m.meetingID
inner join meetingParticipants as mp on m.meetingID = mp.meetingID
inner join participant as p on p.participantID = mp.participantID
where mt.startTime > GETDATE() and m.meetingID in (select meetingID from stationaryMeeting)
union
Select distinct p.participantID as ID ,p.firstName + ' ' + p.lastName as Name, m.meetingID as 'ID spotkania' , 'online syn' as type
from meetingTime as mt
inner join meeting as m on mt.meetingID = m.meetingID
inner join meetingParticipants as mp on m.meetingID = mp.meetingID
inner join participant as p on p.participantID = mp.participantID
where mt.startTime > GETDATE() and m.meetingID in (select meetingID from onlineSyncMeeting)
go

--2 Wyswietlenie listy os�b kt�re jeszcze nie zap�aci�y
Create view list_of_all_debtors as
select distinct p.participantID as ID, p.firstName + ' ' + p.lastName as Name
from orderDetails as od
inner join orderStatus as os on os.statusID = od.statusID
inner join orders as o on o.orderID = od.OrderID
inner join participant as p on p.participantID = o.participantID
where os.statusType = 'ordered'
go

--3 Lista wszystkich z zaleg�ymi p�atno�ciami
Create view list_of_all_overdue_debtors as
select p.participantID as ID, p.firstName + ' ' + p.lastName as Name
from orderDetails as od
inner join orderStatus as os on os.statusID = od.statusID
inner join orders as o on o.orderID = od.OrderID
inner join participant as p on p.participantID = o.participantID
left outer join paymentDeferral as pd on o.orderID=pd.orderID
where os.statusType = 'ordered' and GETDATE() > isnull(pd.newDueDate,od.fullPaymentDate)
go

--4 przychoody z webinar�w
create view webinar_income_list as
select w.productID as ID, w.webinarName as name, sum(od.price) as income
from webinar as w
inner join products as p on w.productID = p.productID
inner join orderDetails as od on od.productID = p.productID
inner join orderStatus as os on os.statusID = od.statusID
where os.statusType = 'paid'
group by w.productID, w.webinarName
go

--5 przychody z kurs�w z podzia�em na przychody za pe�ne kwoty i zaliczki
create view courses_income_list_with_status as
select 
c.productID as ID,
c.courseName as Name,
sum(od.price) as income,
'full paid' as status
from course as c
inner join products as p on c.productID = p.productID
inner join orderDetails as od on od.productID = p.productID
inner join orderStatus as os on os.statusID = od.statusID
where os.statusType = 'paid'
group by  c.productID , c.courseName
union
select 
c.productID as ID,
c.courseName as Name,
sum(c.advancePrice) as income,
'advance paid' as status
from course as c
inner join products as p on c.productID = p.productID
inner join orderDetails as od on od.productID = p.productID
inner join orderStatus as os on os.statusID = od.statusID
where os.statusType = 'ordered'
group by  c.productID , c.courseName
go

--6 przychody z kursow
create view courses_income_list as
select ID, name, sum(income) as income
from courses_income_list_with_status
group by ID,name
go

--7 przychody ze studi�w(major, nie class) podzia� na wpisowe i zjazdy
create view studies_income_list_with_division as
select c.productID as ID, m.name as name, sum(od.price) as income, 'entry fee' as type
from class as c
inner join products as p on c.productID = p.productID
inner join orderDetails as od on od.productID = p.productID
inner join orderStatus as os on od.statusID = os.statusID
inner join major as m on c.majorID = m.majorID
where os.statusType = 'paid'
group by  c.productID, m.name 
union
select c.productID as ID, m.name as name, sum(od.price) as income, 'convention fee' as type
from class as c
inner join convention as con on con.classID = c.classID
inner join products as p on p.productID = c.productID
inner join orderDetails as od on od.productID = p.productID
inner join orderStatus as os on od.statusID = os.statusID
inner join major as m on c.majorID = m.majorID
where os.statusType = 'paid'
group by  c.productID, m.name 
go

--8 pe�ne zyski ze studi�w
create view studies_income_list as
select ID, name, sum(income) as income
from studies_income_list_with_division 
group by ID,name
go

--9 Sylabus dla ka�dych studi�w
create view class_syllabus as
select 
c.classID as 'ID Rocznika',
c.year as 'Class beginning',
m.name as Studies,
sub.subjectName as subject,
syl.term as semester,
syl.requiredHours as Hours
from class as c
inner join major as m on c.majorID = m.majorID
inner join syllabus as syl on syl.majorID = m.majorID
inner join subject as sub on sub.subjectID = syl.subjectID
order by c.classID,semester
go

--10 Produkty na sprzedaz
create view products_for_sale as
select
p.productID as ID,
pt.typeName as type,
case
	when pt.typeName = 'course'
	then co.courseName
	when pt.typeName = 'webinar'
	then webinarName
	when pt.typeName = 'convention'
	then 'convention of ' + conmaj.name
	when pt.typeName = 'studies'
	then maj.name
end as name,
case
	when pt.typeName = 'course'
	then co.price
	when pt.typeName = 'webinar'
	then w.price
	when pt.typeName = 'convention'
	then con.price
	when pt.typeName = 'studies'
	then cl.price
end as price
from products as p
inner join productTypes as pt on pt.typeID = p.typeID
inner join course as co on co.productID = p.productID
inner join webinar as w on w.productID = p.productID
inner join convention as con on con.productID = p.productID
inner join class as concl on con.classID = concl.classID
inner join major as conmaj on concl.majorID = conmaj.majorID
inner join class as cl  on cl.productID = p.productID
inner join major as maj on maj.majorId = cl.majorID
where p.isAvailable = 1
go

--11 Oferowane studia
create view studies_for_sale as
select ID,name,price
from products_for_sale
where type = 'studies'
go

--12 Oferowane kursy
create view courses_for_sale as
select ID,name,price
from products_for_sale
where Type = 'course'
go

--13 Oferowane webinary
create view webinars_for_sale as
select ID,name,price
from products_for_sale
where Type = 'webinar'
go

--14 Oferowane zjazdy
create view conventions_for_sale as
select ID,name,price
from products_for_sale
where Type = 'convention'
go

--15 rodzaje spotka�
create view meeting_type as
select
m.meetingID,
mm.modeName,
case
	when m.meetingID in (select meetingID from studySchedule)
	then 'Studies'
	when m.meetingID in (select meetingID from moduleSchedule)
	then 'Course'
end as partOf
from meeting as m
inner join meetingMode as mm on m.meetingModeID= mm.meetingModeID
go

-- 16.1 obecno�� na spotkaniach
create view meeting_attendance as
select
m.meetingID as ID,
(select count(*) from meetingParticipants as mpar where mpar.meetingID = m.meetingID) as allParticipants,
(select count(*) from meetingParticipants as mpar where mpar.meetingID = m.meetingID and mpar.wasPresent = 1) as attendedParticipants 
from meeting as m
inner join meetingTime as mt on mt.meetingID = m.meetingID
where mt.endTime < GETDATE()
go

-- 16.2 wy�wietlenia nagra� spotka� asynchronicznych
create view async_meeting_attendance as
select
m.meetingID as ID,
(select count(*) from asyncMeetingDetails as mpar where mpar.meetingID = m.meetingID) as allParticipants,
(select count(*) from asyncMeetingDetails as mpar where mpar.meetingID = m.meetingID and mpar.dateWatched is not null) as participantsWatched 
from asyncMeetingDetails as m
go

--17 raport bilokacji
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

--18 ramy czasowe kursu
create view course_time_frame as
select c.courseID, c.courseName,min(mt.startTime) as 'start',max(mt.endTime) as 'end' from course as c
inner join module as md on c.courseID=md.courseID
inner join moduleSchedule as ms on ms.moduleID=ms.moduleID
inner join meeting as m on ms.meetingID = m.meetingID
inner join meetingTime as mt on mt.meetingID=m.meetingID
go

--19 lista sta�ych klient�w(tych kt�rzy kupili du�o produkt�w)
create view regular_customer as
select p.participantID,COUNT(*) as products 
from participant as p
inner join orders as o on p.participantID=o.participantID
inner join orderDetails as od on o.orderID = od.orderID
group by p.participantID
having Count(*) > 10
go

--20 lista sta�ych klient�w(tych kt�rzy kupili du�o produkt�w w ci�gu ostatniego roku)
create view recent_regular_customer as
select p.participantID,COUNT(*) as products 
from participant as p
inner join orders as o on p.participantID=o.participantID
inner join orderDetails as od on o.orderID = od.orderID
where od.fullPaymentDate > dateadd(year,-1,GETDATE())
group by p.participantID
having Count(*) > 10
go

--21 dla ka�dego meetingu stacjonarnego ilo�� miejsc i ilo�� zaj�tych miejsc
create view meeting_places_available as
select mp.meetingID,r.size as 'room size',count(mp.participantID) as 'places occupied'
from meetingParticipants as mp
--inner join meeting as m on m.meetingID=mp.meetingID
inner join stationaryMeeting as sm on sm.meetingID = mp.meetingID
inner join rooms as r on sm.roomID=r.roomID
group by mp.meetingID,r.size
go

--22 szczeg�owy raport frekwencji
create view attendace_details as
select
m.meetingID,cast(mt.startTime as date) as 'date', p.participantID,p.firstName + ' ' + p.lastName as 'name' ,mp.wasPresent
from participant as p
inner join meetingParticipants as mp on p.participantID=mp.participantID
inner join meeting as m on m.meetingID=mp.meetingID
inner join meetingTime as mt on mt.meetingID = m.meetingID
where mt.endTime < GETDATE()
order by m.meetingID,p.participantID
go

--dla ka�dego produktu liczba os�b ktore go zakupi�y
--dla ka�dych studi�w liczba zjazd�w spotka� i sta�y
--ramy czasowe studiow
--ramy czasowe zjazd�w
--uzytkownicy i produkty w ich koszykach
--raport bilokacji dla pokojów
