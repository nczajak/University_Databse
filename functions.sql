--obliczanie obecnoœci studenta na studiach w formie u³amka 

CREATE FUNCTION student_attendance(@classID int, @studentID int) RETURNS DECIMAL(5,2)
   AS
   BEGIN
       DECLARE @wasPresent INT = (SELECT COUNT(*)
                                  FROM class AS c
                                  INNER JOIN convention AS con ON c.classID = con.classID
                                  INNER JOIN studySchedule AS ss ON con.conventionID = ss.conventionID
                                  INNER JOIN meetingParticipants AS mp ON ss.meetingID = mp.meetingID
                                  WHERE c.classID = @classID AND participantID = @studentID AND wasPresent = 1
                                  )
       DECLARE @allMeetings INT = (SELECT COUNT(*)
                                  FROM class AS c
                                  INNER JOIN convention AS con ON c.classID = con.classID
                                  INNER JOIN studySchedule AS ss ON con.conventionID = ss.conventionID
                                  WHERE c.classID = @classID
                                  )
       RETURN ROUND((CAST(@wasPresent AS DECIMAL(5,2)) / CAST(@allMeetings AS DECIMAL(5,2))) * 100, 2);
   end

--Obliczanie wartoœci zamówienia

CREATE FUNCTION GetOrderValue(@OrderID int)
RETURNS money
AS
BEGIN
	declare @sum_money MONEY = (select sum(ISNULL(price,0)) from orderDetails where orderID = @OrderID);
	RETURN @sum_money;
END
GO


--Wyœwietlanie iloœci wolnych miejsc na studiach


CREATE FUNCTION HowManyStudyVacancies(@classID int)
RETURNS int
AS
	BEGIN
		DECLARE @MaximumCapacity int =	(select limit from class 
										where classID = @classID);

		DECLARE @CurrentCapacity int =	(select count(*) from students 
										where classID = @classID);
		
		RETURN @MaximumCapacity - @CurrentCapacity;
	END
GO

--Zwracanie czy student by³ na zajêciach lub czy je obejrza³ dla asynchronicznych

CREATE FUNCTION WasPresentOn (@meetingID INT, @studentID INT)
RETURNS BIT
AS
	BEGIN
	DECLARE @result BIT
	IF @meetingID in (select meetingID from onlineAsyncMeeting)
		BEGIN
		IF exists (select * from asyncMeetingDetails where meetingID = @meetingID and participantID = @studentID and dateWatched is not NULL)
			BEGIN
			set @result = CAST(1 as bit)
			END
		ELSE
			BEGIN
			set @result = CAST(0 as bit)
			END
		END
	ELSE
		BEGIN
		IF exists (select * from meetingParticipants where meetingID = @meetingID and participantID = @studentID and wasPresent = CAST(1 as bit))
			BEGIN
			set @result = CAST(1 as bit)
			END
		ELSE
			BEGIN
			set @result = CAST(0 as bit)
			END
		END
		RETURN @result;
	END
GO

--Obecnoœæ studenta na studiach

CREATE FUNCTION StudentPresence(@classID int, @studentID INT)
RETURNS REAL
AS
BEGIN
	declare @allMeetings int = (select COUNT(*) from meetingParticipants as mp
												inner join studySchedule as ss on ss.meetingID = mp.meetingID
												inner join convention as c on c.conventionID = ss.conventionID
												where c.classID = @classID and mp.participantID = @studentID)
	declare @attendedMeetings int = (select COUNT(*) from meetingParticipants as mp
												inner join studySchedule as ss on ss.meetingID = mp.meetingID
												inner join convention as c on c.conventionID = ss.conventionID
												where c.classID = @classID and mp.participantID = @studentID and wasPresent = CAST(1 as bit))
	set @allMeetings = @allMeetings + (select COUNT(*) from asyncMeetingDetails as mp
												inner join studySchedule as ss on ss.meetingID = mp.meetingID
												inner join convention as c on c.conventionID = ss.conventionID
												where c.classID = @classID and mp.participantID = @studentID)
	set @attendedMeetings = @attendedMeetings + (select COUNT(*) from asyncMeetingDetails as mp
												inner join studySchedule as ss on ss.meetingID = mp.meetingID
												inner join convention as c on c.conventionID = ss.conventionID
												where c.classID = @classID and mp.participantID = @studentID and dateWatched is not NULL)
	RETURN @attendedMeetings / @allMeetings;
END
GO

-- Wyœwietlanie przysz³ych zajêæ uczestnika

CREATE FUNCTION UpcomingMeetings(@participantID int)
RETURNS TABLE
AS
	Return	(select mt.meetingID, mt.startTime from meetingParticipants as mp
			inner join meetingTime as mt on mt.meetingID = mp.meetingID
			where startTime>GETDATE() and mp.participantID = @participantID
			order by startTime)
GO


-- Przychody z konkretnego produktu

CREATE FUNCTION ProductIncome(@productID int)
RETURNS INT
AS
BEGIN
	declare @result money = (select sum(isnull(price,0)) from orderDetails as od
														inner join orderStatus as os on os.statusID = od.statusID
														where productID = @productID and os.statusType = 'Completed')
	
	Return @result
END
GO


--Uczestnicy zapisani na zajêcia

CREATE FUNCTION SignedForMeeting(@meetingID int)
RETURNS INT
AS
BEGIN
	declare @result table(participant int)

	IF exists (select meetingID from onlineAsyncMeeting where meetingID = @meetingID)
		BEGIN
		insert into @result(participant)
		select participantID from asyncMeetingDetails where meetingID = @meetingID
		END
	ELSE
		BEGIN
		insert into @result(participant)
		select participantID from meetingParticipants where meetingID = @meetingID
		END
	
	return (select * from @result)
END
GO


--Uczestnicy zapisani na webinar

CREATE FUNCTION AccesToWebinar(@webinarID int)
RETURNS INT
AS
BEGIN
	declare @result table(participant int)

		insert into @result(participant)
		select participantID from webinarParticipants where webinarID = @webinarID
	
	return (select * from @result)
END
GO

--Uczestnicy zapisani na kurs

CREATE FUNCTION AccesToCourse(@courseID int)
RETURNS INT
AS
BEGIN
	declare @result table(participant int)

		insert into @result(participant)
		select participantID from courseParticipants where courseID = @courseID
	
	return (select * from @result)
END
GO
