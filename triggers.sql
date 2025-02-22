--Po usuni�ciu studenta z listy student�w, usuwamy go z list uczestnik�w zjazd�w tych studi�w i ich spotka� 

CREATE TRIGGER delete_student_trigger
 ON students
 AFTER DELETE
 AS 
	BEGIN
		DECLARE @studentID INT;
		DECLARE @classID INT;
		SELECT @studentID = participantID FROM deleted;
		SELECT @classID = classID FROM deleted;
		DELETE conventionDetails WHERE studentID = @studentID and conventionID in(select c.conventionID from convention as c where classID = @classID);
		DELETE meetingParticipants WHERE participantID = @studentID and meetingID in	(select ss.meetingID from studySchedule as ss
																								inner join convention as con on con.conventionID = ss.conventionID
																								where classID = @classID)
		DELETE asyncMeetingDetails WHERE participantID = @studentID and meetingID in	(select ss.meetingID from studySchedule as ss
																								inner join convention as con on con.conventionID = ss.conventionID
																								where classID = @classID)
	END
GO

 --Po dodaniu do listy student�w dodajemy do listy uczestnik�w zjazdu i uczestnik�w spotka�

CREATE TRIGGER insert_student_trigger
ON students
AFTER INSERT
AS
   BEGIN
      DECLARE @studentID INT;
      DECLARE @classID INT;
      SELECT @studentID = participantID FROM inserted;
      SELECT @classID = classID FROM inserted;
      INSERT INTO conventionDetails(conventionID,studentID,paymentDate)
      SELECT conventionID, @studentID, GETDATE() FROM convention WHERE classID = @classID
      INSERT INTO meetingParticipants(meetingID,participantID,wasPresent)
      SELECT ss.meetingID, @studentID, CAST(0 AS bit) FROM studySchedule AS ss
                                          INNER JOIN convention AS con ON con.conventionID = ss.conventionID
                                          WHERE con.classID = @classID AND ss.meetingID NOT IN (SELECT oam.meetingID FROM onlineAsyncMeeting AS oam)
      INSERT INTO asyncMeetingDetails(meetingID,participantID,dateWatched)
      SELECT oam.meetingID, @studentID, NULL FROM onlineAsyncMeeting AS oam
                                    INNER JOIN studySchedule AS ss ON ss.meetingID = oam.meetingID
                                    INNER JOIN convention AS con ON con.conventionID = ss.conventionID
                                    WHERE con.classID = @classID


   END
GO


--Po usuni�ciu t�umacza z tabeli translator dla wszystkich webinar�w i spotka�, kt�re by�y przez niego t�umaczone, ustawiane s� warto�ci NULL.
CREATE TRIGGER delete_translator_trigger
ON translator
AFTER DELETE
AS BEGIN
	declare @translatorID int;
	UPDATE meeting
	SET translatorID = NULL
	WHERE translatorID = @translatorID;

	UPDATE webinarDetails
	SET translatorID = NULL
	WHERE translatorID = @translatorID
END


