/* ---- CRUD QUERY BUS ---- */
USE Bus

GO
/* ------------------------ ROUTE ------------------------ */

/* ---- INSERT STORED PROCEDURE ---- */

CREATE PROCEDURE InsertRoute
	/* SET THE PARAMETERS FOR THIS PROCEDURE */
	@name VARCHAR(50),
	@description VARCHAR(100)
AS
	/* CREATE A TRANSACTION TO ENSURE THIS PROCESS */
	BEGIN TRANSACTION INSERTROUTE

		/* GENERATE A TRY CATCH BLOCK TO PREVENT ERRORS ALONG THE TRANSACTION */
		BEGIN TRY
			INSERT INTO [Route] VALUES (@name, @description)
		END TRY

		/* CATCH ALL TYPE OF ERRORS DURING THE PROCESS */
		BEGIN CATCH
				SELECT
				ERROR_NUMBER() AS ErrorNumber
				,ERROR_SEVERITY() AS ErrorSeverity
				,ERROR_STATE() AS ErrorState
				,ERROR_PROCEDURE() AS ErrorProcedure
				,ERROR_LINE() AS ErrorLine
				,ERROR_MESSAGE() AS ErrorMessage;
  
				/* IF SOMETHING HAPPENS DURING THE PROCESS, THIS TRANSACTION WILL BE ROLLBACK */
				IF @@TRANCOUNT > 0
					ROLLBACK TRANSACTION INSERTROUTE;
					PRINT('--------------------------------------------------------------------------------');
					PRINT(' THERE WAS AN UNEXPECTED ERROR DURING THIS PROCESS, CHECK THE DATA BEFORE RETRY ');
					PRINT('--------------------------------------------------------------------------------');
		END CATCH;

	/* IF EVERYTHING'S DONE, THIS RESULT WILL BE PERMANENT INTO THE DB */
	IF @@TRANCOUNT > 0
		COMMIT TRANSACTION INSERTROUTE;
		PRINT('------------------------------------------');
		PRINT(' ROUTE ADDED TO THE DATABASE SUCCESSFULLY ');
		PRINT('------------------------------------------');
		/* SHOWS THE DATA THAT WAS ADDED IN THIS PROCESS */
		SELECT Id, [name], [description]
		FROM [Route]
		WHERE [name] = @name AND [description] = @description
GO


GO
/* ---- UPDATE STORED PROCEDURE ---- */

CREATE PROCEDURE UpdateRoute
	/* SET THE PARAMETERS FOR THIS PROCEDURE */
	@Id INT,
	@name VARCHAR(50),
	@description VARCHAR(100)
AS
	/* VERIFY IF THE RECORD EXISTS INTO THE DB */
	IF @Id <= (SELECT Id FROM [Route] WHERE Id = @Id)
		BEGIN
			/* CREATE A TRANSACTION TO ENSURE THIS PROCESS */
			BEGIN TRANSACTION UPDATEROUTE
				/* GENERATE A TRY CATCH BLOCK TO PREVENT ERRORS ALONG THE TRANSACTION */
				BEGIN TRY
					UPDATE [Route]
					SET [name] = @name, [description] = @description
					WHERE Id = @Id
				END TRY

				/* CATCH ALL TYPE OF ERRORS DURING THE PROCESS */
				BEGIN CATCH
					SELECT
					ERROR_NUMBER() AS ErrorNumber
					,ERROR_SEVERITY() AS ErrorSeverity
					,ERROR_STATE() AS ErrorState
					,ERROR_PROCEDURE() AS ErrorProcedure
					,ERROR_LINE() AS ErrorLine
					,ERROR_MESSAGE() AS ErrorMessage;
  
					/* IF SOMETHING HAPPENS DURING THE PROCESS, THIS TRANSACTION WILL BE ROLLBACK */
					IF @@TRANCOUNT > 0
						ROLLBACK TRANSACTION UPDATEROUTE;
						PRINT('--------------------------------------------------------------------------------');
						PRINT(' THERE WAS AN UNEXPECTED ERROR DURING THIS PROCESS, CHECK THE DATA BEFORE RETRY ');
						PRINT('--------------------------------------------------------------------------------');
				END CATCH;

				/* IF EVERYTHING'S DONE, THIS RESULT WILL BE PERMANENT INTO THE DB */
				IF @@TRANCOUNT > 0
					COMMIT TRANSACTION UPDATEROUTE;
					PRINT('------------------------------------');
					PRINT(' THE ROUTE WAS UPDATED SUCCESSFULLY ');
					PRINT('------------------------------------');
					/* SHOWS THE DATA THAT WAS UPDATED IN THIS PROCESS */
					SELECT Id, [name], [description] 
					FROM [Route]
					WHERE Id = @Id
		END
	/* IF THE RECORD DOESNT EXIST INTO THE DB, THE CURRENT TRANSACTION WONT BE APPLIED */
	ELSE
		BEGIN
			PRINT('----------------------------------------------------------------------');
			PRINT(' THE RECORD ID DOESNT EXIST INTO THE DB, CHECK YOUR DATA BEFORE RETRY ');
			PRINT('----------------------------------------------------------------------');
		END
GO



GO
/* ---- DELETE STORED PROCEDURE ---- */

CREATE PROCEDURE DeleteRoute
	/* SET THE PARAMETERS FOR THIS PROCEDURE */
	@Id INT
AS
	/* VERIFY IF THE RECORD EXISTS INTO THE DB */
	IF @Id <= (SELECT Id FROM [Route] WHERE Id = @Id)
		BEGIN
			/* CREATE A TRANSACTION TO ENSURE THIS PROCESS */
			BEGIN TRANSACTION DELETEROUTE
				/* GENERATE A TRY CATCH BLOCK TO PREVENT ERRORS ALONG THE TRANSACTION */
				BEGIN TRY
					/* IF ROUTE ID EXISTS INTO THE BUS TABLE, SET NULL */
					IF EXISTS (SELECT routeId FROM Bus WHERE routeId = @Id)
						BEGIN
							UPDATE Bus
							SET routeId = NULL
							WHERE routeId = @Id
						END
					ELSE
						BEGIN
							PRINT(' NO DEPENDENCY FOUND INTO BUS TABLE')
						END

					/* IF ROUTE ID EXISTS INTO THE ROUTE JOURNEY TABLE, SET NULL */
					IF EXISTS (SELECT routeId FROM RouteJourney WHERE routeId = @Id)
						BEGIN
							UPDATE RouteJourney
							SET routeId = NULL
							WHERE routeId = @Id
						END
					ELSE
						BEGIN
							PRINT(' NO DEPENDENCY FOUND INTO ROUTE JOURNEY TABLE')
						END

					/* IF ROUTE ID EXISTS INTO THE ROUTE LOG TABLE, THEN DELETE IT */
					IF EXISTS (SELECT routeId FROM RouteLog WHERE routeId = @Id)
						BEGIN
							DELETE RouteLog
							WHERE routeId = @Id
						END
					ELSE
						BEGIN
							PRINT(' NO DEPENDENCY FOUND INTO ROUTE LOG TABLE')
						END

					/* THEN DELETE THE TARGET RECORD RESPECTIVELY */
					DELETE [Route]
					WHERE Id = @Id

				END TRY

				/* CATCH ALL TYPE OF ERRORS DURING THE PROCESS */
				BEGIN CATCH
					SELECT
					ERROR_NUMBER() AS ErrorNumber
					,ERROR_SEVERITY() AS ErrorSeverity
					,ERROR_STATE() AS ErrorState
					,ERROR_PROCEDURE() AS ErrorProcedure
					,ERROR_LINE() AS ErrorLine
					,ERROR_MESSAGE() AS ErrorMessage;
  
					/* IF SOMETHING HAPPENS DURING THE PROCESS, THIS TRANSACTION WILL BE ROLLBACK */
					IF @@TRANCOUNT > 0
						ROLLBACK TRANSACTION DELETEROUTE;
						PRINT('--------------------------------------------------------------------------------');
						PRINT(' THERE WAS AN UNEXPECTED ERROR DURING THIS PROCESS, CHECK THE DATA BEFORE RETRY ');
						PRINT('--------------------------------------------------------------------------------');
				END CATCH;

				/* IF EVERYTHING'S DONE, THIS RESULT WILL BE PERMANENT INTO THE DB */
				IF @@TRANCOUNT > 0
					COMMIT TRANSACTION DELETEROUTE;
					PRINT('----------------------------------------');
					PRINT('  THE ROUTE WAS DELETED SUCCESSFULLY    ');
					PRINT('----------------------------------------');
		END

	/* IF THE RECORD DOESNT EXIST INTO THE DB, THE CURRENT TRANSACTION WONT BE APPLIED */
	ELSE
		BEGIN
			PRINT('----------------------------------------------------------------------');
			PRINT(' THE RECORD ID DOESNT EXIST INTO THE DB, CHECK YOUR DATA BEFORE RETRY ');
			PRINT('----------------------------------------------------------------------');
		END
GO



GO
/* ---- SELECT STORED PROCEDURE ---- */

CREATE PROCEDURE SelectRoute
	@Id INT
AS
	IF @Id <= (SELECT Id FROM [Route] WHERE Id = @Id)
		BEGIN
			SELECT Id, [NAME], [DESCRIPTION] 
			FROM [Route]
			WHERE Id = @Id
		END
	ELSE
		BEGIN
			PRINT('----------------------------------------------------------------------');
			PRINT(' THE RECORD ID DOESNT EXIST INTO THE DB, CHECK YOUR DATA BEFORE RETRY ');
			PRINT('----------------------------------------------------------------------');
		END

GO



/* ------------------------ JOURNEY ------------------------ */

GO
/* ---- INSERT STORED PROCEDURE ---- */

CREATE PROCEDURE InsertJourney
	@name VARCHAR(50)
AS
	/* CREATE A TRANSACTION TO ENSURE THIS PROCESS */
	BEGIN TRANSACTION INSERTJOURNEY

		/* GENERATE A TRY CATCH BLOCK TO PREVENT ERRORS ALONG THE TRANSACTION */
		BEGIN TRY
			INSERT INTO Journey VALUES (@name)
		END TRY

		/* CATCH ALL TYPE OF ERRORS DURING THE PROCESS */
		BEGIN CATCH
				SELECT
				ERROR_NUMBER() AS ErrorNumber
				,ERROR_SEVERITY() AS ErrorSeverity
				,ERROR_STATE() AS ErrorState
				,ERROR_PROCEDURE() AS ErrorProcedure
				,ERROR_LINE() AS ErrorLine
				,ERROR_MESSAGE() AS ErrorMessage;
  
				/* IF SOMETHING HAPPENS DURING THE PROCESS, THIS TRANSACTION WILL BE ROLLBACK */
				IF @@TRANCOUNT > 0
					ROLLBACK TRANSACTION INSERTJOURNEY;
					PRINT('--------------------------------------------------------------------------------');
					PRINT(' THERE WAS AN UNEXPECTED ERROR DURING THIS PROCESS, CHECK THE DATA BEFORE RETRY ');
					PRINT('--------------------------------------------------------------------------------');
		END CATCH;

	/* IF EVERYTHING'S DONE, THIS RESULT WILL BE PERMANENT INTO THE DB */
	IF @@TRANCOUNT > 0
		COMMIT TRANSACTION INSERTJOURNEY;
		PRINT('--------------------------------------------');
		PRINT(' JOURNEY ADDED TO THE DATABASE SUCCESSFULLY ');
		PRINT('--------------------------------------------');
		/* SHOWS THE DATA THAT WAS ADDED IN THIS PROCESS */
		SELECT Id, [name]
		FROM Journey
		WHERE [name] = @name
GO



GO
/* ---- UPDATE STORED PROCEDURE ---- */

CREATE PROCEDURE UpdateJourney
	@Id INT,
	@name VARCHAR(50)
AS
	/* VERIFY IF THE RECORD EXISTS INTO THE DB */
	IF @Id <= (SELECT Id FROM Journey WHERE Id = @Id)
		BEGIN
			/* CREATE A TRANSACTION TO ENSURE THIS PROCESS */
			BEGIN TRANSACTION UPDATEJOURNEY
				/* GENERATE A TRY CATCH BLOCK TO PREVENT ERRORS ALONG THE TRANSACTION */
				BEGIN TRY
					UPDATE Journey
					SET [name] = @name
					WHERE Id = @Id
				END TRY

				/* CATCH ALL TYPE OF ERRORS DURING THE PROCESS */
				BEGIN CATCH
					SELECT
					ERROR_NUMBER() AS ErrorNumber
					,ERROR_SEVERITY() AS ErrorSeverity
					,ERROR_STATE() AS ErrorState
					,ERROR_PROCEDURE() AS ErrorProcedure
					,ERROR_LINE() AS ErrorLine
					,ERROR_MESSAGE() AS ErrorMessage;
  
					/* IF SOMETHING HAPPENS DURING THE PROCESS, THIS TRANSACTION WILL BE ROLLBACK */
					IF @@TRANCOUNT > 0
						ROLLBACK TRANSACTION UPDATEJOURNEY;
						PRINT('--------------------------------------------------------------------------------');
						PRINT(' THERE WAS AN UNEXPECTED ERROR DURING THIS PROCESS, CHECK THE DATA BEFORE RETRY ');
						PRINT('--------------------------------------------------------------------------------');
				END CATCH;

				/* IF EVERYTHING'S DONE, THIS RESULT WILL BE PERMANENT INTO THE DB */
				IF @@TRANCOUNT > 0
					COMMIT TRANSACTION UPDATEJOURNEY;
					PRINT('--------------------------------------');
					PRINT(' THE JOURNEY WAS UPDATED SUCCESSFULLY ');
					PRINT('--------------------------------------');
					/* SHOWS THE DATA THAT WAS UPDATED IN THIS PROCESS */
					SELECT Id, [name]
					FROM Journey
					WHERE Id = @Id
		END
	/* IF THE RECORD DOESNT EXIST INTO THE DB, THE CURRENT TRANSACTION WONT BE APPLIED */
	ELSE
		BEGIN
			PRINT('----------------------------------------------------------------------');
			PRINT(' THE RECORD ID DOESNT EXIST INTO THE DB, CHECK YOUR DATA BEFORE RETRY ');
			PRINT('----------------------------------------------------------------------');
		END
GO




GO
/* ---- DELETE STORED PROCEDURE ----*/

CREATE PROCEDURE DeleteJourney
	@Id INT
AS
	/* VERIFY IF THE RECORD EXISTS INTO THE DB */
	IF @Id <= (SELECT Id FROM Journey WHERE Id = @Id)
		BEGIN
			/* CREATE A TRANSACTION TO ENSURE THIS PROCESS */
			BEGIN TRANSACTION DELETEJOURNEY
				/* GENERATE A TRY CATCH BLOCK TO PREVENT ERRORS ALONG THE TRANSACTION */
				BEGIN TRY
					/* IF JOURNEY ID EXISTS INTO THE DRIVER TABLE, SET NULL */
					IF EXISTS (SELECT journeyId FROM Driver WHERE journeyId = @Id)
						BEGIN
							UPDATE Driver
							SET journeyId = NULL
							WHERE journeyId = @Id
						END
					ELSE
						BEGIN
							PRINT(' NO DEPENDENCY FOUND INTO BUS TABLE')
						END

					/* IF JOURNEY ID EXISTS INTO THE ROUTE JOURNEY TABLE, SET NULL */
					IF EXISTS (SELECT journeyId FROM RouteJourney WHERE journeyId = @Id)
						BEGIN
							UPDATE RouteJourney
							SET journeyId = NULL
							WHERE journeyId = @Id
						END
					ELSE
						BEGIN
							PRINT(' NO DEPENDENCY FOUND INTO ROUTE JOURNEY TABLE')
						END

					/* IF JOURNEY ID EXISTS INTO THE JOURNEY TOWN TABLE, SET NULL */
					IF EXISTS (SELECT journeyId FROM JourneyTown WHERE journeyId = @Id)
						BEGIN
							UPDATE JourneyTown
							SET journeyId = NULL
							WHERE journeyId = @Id
						END
					ELSE
						BEGIN
							PRINT(' NO DEPENDENCY FOUND INTO JOURNEY TOWN TABLE')
						END

					/* THEN DELETE THE TARGET RECORD RESPECTIVELY */
					DELETE Journey
					WHERE Id = @Id

				END TRY

				/* CATCH ALL TYPE OF ERRORS DURING THE PROCESS */
				BEGIN CATCH
					SELECT
					ERROR_NUMBER() AS ErrorNumber
					,ERROR_SEVERITY() AS ErrorSeverity
					,ERROR_STATE() AS ErrorState
					,ERROR_PROCEDURE() AS ErrorProcedure
					,ERROR_LINE() AS ErrorLine
					,ERROR_MESSAGE() AS ErrorMessage;
  
					/* IF SOMETHING HAPPENS DURING THE PROCESS, THIS TRANSACTION WILL BE ROLLBACK */
					IF @@TRANCOUNT > 0
						ROLLBACK TRANSACTION DELETEJOURNEY;
						PRINT('--------------------------------------------------------------------------------');
						PRINT(' THERE WAS AN UNEXPECTED ERROR DURING THIS PROCESS, CHECK THE DATA BEFORE RETRY ');
						PRINT('--------------------------------------------------------------------------------');
				END CATCH;

				/* IF EVERYTHING'S DONE, THIS RESULT WILL BE PERMANENT INTO THE DB */
				IF @@TRANCOUNT > 0
					COMMIT TRANSACTION DELETEJOURNEY;
					PRINT('------------------------------------------');
					PRINT('  THE JOURNEY WAS DELETED SUCCESSFULLY    ');
					PRINT('------------------------------------------');
		END

	/* IF THE RECORD DOESNT EXIST INTO THE DB, THE CURRENT TRANSACTION WONT BE APPLIED */
	ELSE
		BEGIN
			PRINT('----------------------------------------------------------------------');
			PRINT(' THE RECORD ID DOESNT EXIST INTO THE DB, CHECK YOUR DATA BEFORE RETRY ');
			PRINT('----------------------------------------------------------------------');
		END
GO



GO
/* ---- SELECT STORED PROCEDURE ----*/

CREATE PROCEDURE SelectJourney
	@Id INT
AS
	IF @Id <= (SELECT Id FROM Journey WHERE Id = @Id)
		BEGIN
			SELECT Id, [name]
			FROM Journey
			WHERE Id = @Id
		END
	ELSE
		BEGIN
			PRINT('----------------------------------------------------------------------');
			PRINT(' THE RECORD ID DOESNT EXIST INTO THE DB, CHECK YOUR DATA BEFORE RETRY ');
			PRINT('----------------------------------------------------------------------');
		END

GO



/* ------------------------ ROUTE JOURNEY ------------------------ */

GO
/* ---- INSERT STORED PROCEDURE ---- */

CREATE PROCEDURE InsertRouteJourney
	@RID INT,
	@JID INT
AS
	/* CREATE A TRANSACTION TO ENSURE THIS PROCESS */
	BEGIN TRANSACTION INSERTROUTEJOURNEY

		/* GENERATE A TRY CATCH BLOCK TO PREVENT ERRORS ALONG THE TRANSACTION */
		BEGIN TRY
			INSERT INTO RouteJourney VALUES (@RID, @JID)
		END TRY

		/* CATCH ALL TYPE OF ERRORS DURING THE PROCESS */
		BEGIN CATCH
				SELECT
				ERROR_NUMBER() AS ErrorNumber
				,ERROR_SEVERITY() AS ErrorSeverity
				,ERROR_STATE() AS ErrorState
				,ERROR_PROCEDURE() AS ErrorProcedure
				,ERROR_LINE() AS ErrorLine
				,ERROR_MESSAGE() AS ErrorMessage;
  
				/* IF SOMETHING HAPPENS DURING THE PROCESS, THIS TRANSACTION WILL BE ROLLBACK */
				IF @@TRANCOUNT > 0
					ROLLBACK TRANSACTION INSERTROUTEJOURNEY;
					PRINT('--------------------------------------------------------------------------------');
					PRINT(' THERE WAS AN UNEXPECTED ERROR DURING THIS PROCESS, CHECK THE DATA BEFORE RETRY ');
					PRINT('--------------------------------------------------------------------------------');
		END CATCH;

	/* IF EVERYTHING'S DONE, THIS RESULT WILL BE PERMANENT INTO THE DB */
	IF @@TRANCOUNT > 0
		COMMIT TRANSACTION INSERTROUTEJOURNEY;
		PRINT('--------------------------------------------------');
		PRINT(' ROUTE JOURNEY ADDED TO THE DATABASE SUCCESSFULLY ');
		PRINT('--------------------------------------------------');
		/* SHOWS THE DATA THAT WAS ADDED IN THIS PROCESS */
		SELECT routeId, journeyId
		FROM RouteJourney
		WHERE routeId = @RID AND journeyId = @JID
GO



GO
/* ---- UPDATE STORED PROCEDURE ---- */

CREATE PROCEDURE UpdateRouteJourney
	@RtargetId INT,
	@JtargetId INT,
	@RID INT,
	@JID INT
AS
	/* VERIFY IF THE RECORD EXISTS INTO THE DB */
	IF EXISTS (SELECT routeId, journeyId FROM RouteJourney WHERE routeId = @RtargetId AND journeyId = @JtargetId)
		BEGIN
			/* CREATE A TRANSACTION TO ENSURE THIS PROCESS */
			BEGIN TRANSACTION UPDATEROUTEJOURNEY
				/* GENERATE A TRY CATCH BLOCK TO PREVENT ERRORS ALONG THE TRANSACTION */
				BEGIN TRY
					UPDATE RouteJourney
					SET routeId = @RID, journeyId = @JID
					WHERE routeId = @RtargetId AND journeyId = @JtargetId
				END TRY

				/* CATCH ALL TYPE OF ERRORS DURING THE PROCESS */
				BEGIN CATCH
					SELECT
					ERROR_NUMBER() AS ErrorNumber
					,ERROR_SEVERITY() AS ErrorSeverity
					,ERROR_STATE() AS ErrorState
					,ERROR_PROCEDURE() AS ErrorProcedure
					,ERROR_LINE() AS ErrorLine
					,ERROR_MESSAGE() AS ErrorMessage;
  
					/* IF SOMETHING HAPPENS DURING THE PROCESS, THIS TRANSACTION WILL BE ROLLBACK */
					IF @@TRANCOUNT > 0
						ROLLBACK TRANSACTION UPDATEROUTEJOURNEY;
						PRINT('--------------------------------------------------------------------------------');
						PRINT(' THERE WAS AN UNEXPECTED ERROR DURING THIS PROCESS, CHECK THE DATA BEFORE RETRY ');
						PRINT('--------------------------------------------------------------------------------');
				END CATCH;

				/* IF EVERYTHING'S DONE, THIS RESULT WILL BE PERMANENT INTO THE DB */
				IF @@TRANCOUNT > 0
					COMMIT TRANSACTION UPDATEROUTEJOURNEY;
					PRINT('--------------------------------------------');
					PRINT(' THE ROUTE JOURNEY WAS UPDATED SUCCESSFULLY ');
					PRINT('--------------------------------------------');
					/* SHOWS THE DATA THAT WAS UPDATED IN THIS PROCESS */
					SELECT routeId, journeyId
					FROM RouteJourney
					WHERE routeId = @RID AND journeyId = @JID
		END
	/* IF THE RECORD DOESNT EXIST INTO THE DB, THE CURRENT TRANSACTION WONT BE APPLIED */
	ELSE
		BEGIN
			PRINT('----------------------------------------------------------------------');
			PRINT(' THE RECORD ID DOESNT EXIST INTO THE DB, CHECK YOUR DATA BEFORE RETRY ');
			PRINT('----------------------------------------------------------------------');
		END
GO



GO
/* ---- DELETE STORED PROCEDURE ----*/

CREATE PROCEDURE DeleteRouteJourney
	@RID INT,
	@JID INT
AS
	/* VERIFY IF THE RECORD EXISTS INTO THE DB */
	IF EXISTS (SELECT routeId, journeyId FROM RouteJourney WHERE routeId = @RID AND journeyId = @JID)
		BEGIN
			/* CREATE A TRANSACTION TO ENSURE THIS PROCESS */
			BEGIN TRANSACTION DELETEROUTEJOURNEY
				/* GENERATE A TRY CATCH BLOCK TO PREVENT ERRORS ALONG THE TRANSACTION */
				BEGIN TRY
					DELETE RouteJourney
					WHERE routeId = @RID AND journeyId = @JID
				END TRY

				/* CATCH ALL TYPE OF ERRORS DURING THE PROCESS */
				BEGIN CATCH
					SELECT
					ERROR_NUMBER() AS ErrorNumber
					,ERROR_SEVERITY() AS ErrorSeverity
					,ERROR_STATE() AS ErrorState
					,ERROR_PROCEDURE() AS ErrorProcedure
					,ERROR_LINE() AS ErrorLine
					,ERROR_MESSAGE() AS ErrorMessage;
  
					/* IF SOMETHING HAPPENS DURING THE PROCESS, THIS TRANSACTION WILL BE ROLLBACK */
					IF @@TRANCOUNT > 0
						ROLLBACK TRANSACTION DELETEROUTEJOURNEY;
						PRINT('--------------------------------------------------------------------------------');
						PRINT(' THERE WAS AN UNEXPECTED ERROR DURING THIS PROCESS, CHECK THE DATA BEFORE RETRY ');
						PRINT('--------------------------------------------------------------------------------');
				END CATCH;

				/* IF EVERYTHING'S DONE, THIS RESULT WILL BE PERMANENT INTO THE DB */
				IF @@TRANCOUNT > 0
					COMMIT TRANSACTION DELETEROUTEJOURNEY;
					PRINT('------------------------------------------------');
					PRINT('   THE ROUTE JOURNEY WAS DELETED SUCCESSFULLY   ');
					PRINT('------------------------------------------------');
		END

	/* IF THE RECORD DOESNT EXIST INTO THE DB, THE CURRENT TRANSACTION WONT BE APPLIED */
	ELSE
		BEGIN
			PRINT('----------------------------------------------------------------------');
			PRINT(' THE RECORD ID DOESNT EXIST INTO THE DB, CHECK YOUR DATA BEFORE RETRY ');
			PRINT('----------------------------------------------------------------------');
		END
GO




GO
/* ---- SELECT STORED PROCEDURE ----*/

CREATE PROCEDURE SelectRouteJourney
	@RID INT,
	@JID INT
AS
	IF EXISTS (SELECT routeId, journeyId FROM RouteJourney WHERE routeId = @RID AND journeyId = @JID)
		BEGIN
			SELECT routeId, journeyId
			FROM RouteJourney
			WHERE routeId = @RID AND journeyId = @JID
		END
	ELSE
		BEGIN
			PRINT('----------------------------------------------------------------------');
			PRINT(' THE RECORD ID DOESNT EXIST INTO THE DB, CHECK YOUR DATA BEFORE RETRY ');
			PRINT('----------------------------------------------------------------------');
		END
GO



/* ------------------------ ROUTE LOG ------------------------ */

GO
/* ---- INSERT STORED PROCEDURE ---- */

CREATE PROCEDURE InsertRouteLog
	@passAverage INT,
	@date DATE,
	@RID INT
AS
	IF EXISTS (SELECT Id FROM [Route] WHERE Id = @RID)
		BEGIN
			/* CREATE A TRANSACTION TO ENSURE THIS PROCESS */
			BEGIN TRANSACTION INSERTROUTELOG
				/* GENERATE A TRY CATCH BLOCK TO PREVENT ERRORS ALONG THE TRANSACTION */
				BEGIN TRY
					INSERT INTO RouteLog VALUES (@passAverage, @date, @RID)
				END TRY

				/* CATCH ALL TYPE OF ERRORS DURING THE PROCESS */
				BEGIN CATCH
					SELECT
					ERROR_NUMBER() AS ErrorNumber
					,ERROR_SEVERITY() AS ErrorSeverity
					,ERROR_STATE() AS ErrorState
					,ERROR_PROCEDURE() AS ErrorProcedure
					,ERROR_LINE() AS ErrorLine
					,ERROR_MESSAGE() AS ErrorMessage;
  
					/* IF SOMETHING HAPPENS DURING THE PROCESS, THIS TRANSACTION WILL BE ROLLBACK */
					IF @@TRANCOUNT > 0
						ROLLBACK TRANSACTION INSERTROUTELOG;
						PRINT('--------------------------------------------------------------------------------');
						PRINT(' THERE WAS AN UNEXPECTED ERROR DURING THIS PROCESS, CHECK THE DATA BEFORE RETRY ');
						PRINT('--------------------------------------------------------------------------------');
				END CATCH;

				/* IF EVERYTHING'S DONE, THIS RESULT WILL BE PERMANENT INTO THE DB */
				IF @@TRANCOUNT > 0
					COMMIT TRANSACTION INSERTROUTELOG;
					PRINT('----------------------------------------------');
					PRINT(' ROUTE LOG ADDED TO THE DATABASE SUCCESSFULLY ');
					PRINT('----------------------------------------------');
					/* SHOWS THE DATA THAT WAS ADDED IN THIS PROCESS */
					SELECT Id, passAverage, [date], routeId
					FROM RouteLog
					WHERE passAverage = @passAverage AND [date] = @date AND routeId = @RID
		END

	/* IF THE ROUTE ID DOESNT EXIST INTO THE DB, THE PROCESS WONT BE APPLIED (PREREQUISITE) */
	ELSE
		BEGIN
			PRINT('------------------------------------------------------------------------------------');
			PRINT(' THE ROUTE ID DOESNT EXIST INTO THE DB, CHECK YOUR DATA BEFORE RETRY (PREREQUISITE) ');
			PRINT('------------------------------------------------------------------------------------');
		END
GO



GO
/* ---- UPDATE STORED PROCEDURE ---- */

CREATE PROCEDURE UpdateRouteLog
	@RLID INT,
	@passAverage INT,
	@date DATE,
	@RID INT
AS
	/* VERIFY IF THE RECORD EXISTS INTO THE DB */
	IF @RLID <= (SELECT Id FROM RouteLog WHERE Id = @RLID)
		BEGIN
			/* CREATE A TRANSACTION TO ENSURE THIS PROCESS */
			BEGIN TRANSACTION UPDATEROUTELOG
				/* GENERATE A TRY CATCH BLOCK TO PREVENT ERRORS ALONG THE TRANSACTION */
				BEGIN TRY
					UPDATE RouteLog
					SET passAverage = @passAverage,
						[date] = @date,
						routeId = @RID
					WHERE Id = @RLID
				END TRY

				/* CATCH ALL TYPE OF ERRORS DURING THE PROCESS */
				BEGIN CATCH
					SELECT
					ERROR_NUMBER() AS ErrorNumber
					,ERROR_SEVERITY() AS ErrorSeverity
					,ERROR_STATE() AS ErrorState
					,ERROR_PROCEDURE() AS ErrorProcedure
					,ERROR_LINE() AS ErrorLine
					,ERROR_MESSAGE() AS ErrorMessage;
  
					/* IF SOMETHING HAPPENS DURING THE PROCESS, THIS TRANSACTION WILL BE ROLLBACK */
					IF @@TRANCOUNT > 0
						ROLLBACK TRANSACTION UPDATEROUTELOG;
						PRINT('--------------------------------------------------------------------------------');
						PRINT(' THERE WAS AN UNEXPECTED ERROR DURING THIS PROCESS, CHECK THE DATA BEFORE RETRY ');
						PRINT('--------------------------------------------------------------------------------');
				END CATCH;

				/* IF EVERYTHING'S DONE, THIS RESULT WILL BE PERMANENT INTO THE DB */
				IF @@TRANCOUNT > 0
					COMMIT TRANSACTION UPDATEROUTELOG;
					PRINT('----------------------------------------');
					PRINT(' THE ROUTE LOG WAS UPDATED SUCCESSFULLY ');
					PRINT('----------------------------------------');
					/* SHOWS THE DATA THAT WAS UPDATED IN THIS PROCESS */
					SELECT Id, passAverage, [DATE], routeId
					FROM RouteLog
					WHERE Id = @RLID
		END
	/* IF THE RECORD DOESNT EXIST INTO THE DB, THE CURRENT TRANSACTION WONT BE APPLIED */
	ELSE
		BEGIN
			PRINT('--------------------------------------------------------------------')
			PRINT('THE RECORD ID DOESNT EXIST INTO THE DB, CHECK YOUR DATA BEFORE RETRY')
			PRINT('--------------------------------------------------------------------')
		END
GO




GO
/* ---- DELETE STORED PROCEDURE ----*/

CREATE PROCEDURE DeleteRouteLog
	@RLID INT
AS
	/* VERIFY IF THE RECORD EXISTS INTO THE DB */
	IF @RLID <= (SELECT Id FROM RouteLog WHERE Id = @RLID)
		BEGIN
			/* CREATE A TRANSACTION TO ENSURE THIS PROCESS */
			BEGIN TRANSACTION DELETEROUTELOG
				/* GENERATE A TRY CATCH BLOCK TO PREVENT ERRORS ALONG THE TRANSACTION */
				BEGIN TRY
					DELETE RouteLog
					WHERE Id = @RLID
				END TRY

				/* CATCH ALL TYPE OF ERRORS DURING THE PROCESS */
				BEGIN CATCH
					SELECT
					ERROR_NUMBER() AS ErrorNumber
					,ERROR_SEVERITY() AS ErrorSeverity
					,ERROR_STATE() AS ErrorState
					,ERROR_PROCEDURE() AS ErrorProcedure
					,ERROR_LINE() AS ErrorLine
					,ERROR_MESSAGE() AS ErrorMessage;
  
					/* IF SOMETHING HAPPENS DURING THE PROCESS, THIS TRANSACTION WILL BE ROLLBACK */
					IF @@TRANCOUNT > 0
						ROLLBACK TRANSACTION DELETEROUTELOG;
						PRINT('--------------------------------------------------------------------------------');
						PRINT(' THERE WAS AN UNEXPECTED ERROR DURING THIS PROCESS, CHECK THE DATA BEFORE RETRY ');
						PRINT('--------------------------------------------------------------------------------');
				END CATCH;

				/* IF EVERYTHING'S DONE, THIS RESULT WILL BE PERMANENT INTO THE DB */
				IF @@TRANCOUNT > 0
					COMMIT TRANSACTION DELETEROUTELOG;
					PRINT('--------------------------------------------');
					PRINT('  THE ROUTE LOG WAS DELETED SUCCESSFULLY    ');
					PRINT('--------------------------------------------');
		END

	/* IF THE RECORD DOESNT EXIST INTO THE DB, THE CURRENT TRANSACTION WONT BE APPLIED */
	ELSE
		BEGIN
			PRINT('----------------------------------------------------------------------');
			PRINT(' THE RECORD ID DOESNT EXIST INTO THE DB, CHECK YOUR DATA BEFORE RETRY ');
			PRINT('----------------------------------------------------------------------');
		END
GO




GO
/* ---- SELECT STORED PROCEDURE ----*/

CREATE PROCEDURE SelectRouteLog
	@RLID INT
AS
	IF @RLID <= (SELECT Id FROM RouteLog WHERE Id = @RLID)
		BEGIN
			SELECT Id, passAverage, [DATE], routeId
			FROM RouteLog
			WHERE Id = @RLID
		END
	ELSE
		BEGIN
			PRINT('----------------------------------------------------------------------');
			PRINT(' THE RECORD ID DOESNT EXIST INTO THE DB, CHECK YOUR DATA BEFORE RETRY ');
			PRINT('----------------------------------------------------------------------');
		END
GO



/* ------------------------ TOWN ------------------------ */

GO
/* ---- INSERT STORED PROCEDURE ---- */

CREATE PROCEDURE InsertTown
	@name VARCHAR(50)
AS
	/* CREATE A TRANSACTION TO ENSURE THIS PROCESS */
	BEGIN TRANSACTION INSERTTOWN

		/* GENERATE A TRY CATCH BLOCK TO PREVENT ERRORS ALONG THE TRANSACTION */
		BEGIN TRY
			INSERT INTO Town VALUES (@name)
		END TRY

		/* CATCH ALL TYPE OF ERRORS DURING THE PROCESS */
		BEGIN CATCH
				SELECT
				ERROR_NUMBER() AS ErrorNumber
				,ERROR_SEVERITY() AS ErrorSeverity
				,ERROR_STATE() AS ErrorState
				,ERROR_PROCEDURE() AS ErrorProcedure
				,ERROR_LINE() AS ErrorLine
				,ERROR_MESSAGE() AS ErrorMessage;
  
				/* IF SOMETHING HAPPENS DURING THE PROCESS, THIS TRANSACTION WILL BE ROLLBACK */
				IF @@TRANCOUNT > 0
					ROLLBACK TRANSACTION INSERTTOWN;
					PRINT('--------------------------------------------------------------------------------');
					PRINT(' THERE WAS AN UNEXPECTED ERROR DURING THIS PROCESS, CHECK THE DATA BEFORE RETRY ');
					PRINT('--------------------------------------------------------------------------------');
		END CATCH;

	/* IF EVERYTHING'S DONE, THIS RESULT WILL BE PERMANENT INTO THE DB */
	IF @@TRANCOUNT > 0
		COMMIT TRANSACTION INSERTTOWN;
		PRINT('-----------------------------------------');
		PRINT(' TOWN ADDED TO THE DATABASE SUCCESSFULLY ');
		PRINT('-----------------------------------------');
		/* SHOWS THE DATA THAT WAS ADDED IN THIS PROCESS */
		SELECT Id, [name]
		FROM Town
		WHERE [name] = @name
GO




GO
/* ---- UPDATE STORED PROCEDURE ---- */

CREATE PROCEDURE UpdateTown
	@TID INT,
	@name VARCHAR(50)
AS
	/* VERIFY IF THE RECORD EXISTS INTO THE DB */
	IF @TID <= (SELECT Id FROM Town WHERE Id = @TID)
		BEGIN
			/* CREATE A TRANSACTION TO ENSURE THIS PROCESS */
			BEGIN TRANSACTION UPDATETOWN
				/* GENERATE A TRY CATCH BLOCK TO PREVENT ERRORS ALONG THE TRANSACTION */
				BEGIN TRY
					UPDATE Town
					SET [name] = @name
					WHERE Id = @TID
				END TRY

				/* CATCH ALL TYPE OF ERRORS DURING THE PROCESS */
				BEGIN CATCH
					SELECT
					ERROR_NUMBER() AS ErrorNumber
					,ERROR_SEVERITY() AS ErrorSeverity
					,ERROR_STATE() AS ErrorState
					,ERROR_PROCEDURE() AS ErrorProcedure
					,ERROR_LINE() AS ErrorLine
					,ERROR_MESSAGE() AS ErrorMessage;
  
					/* IF SOMETHING HAPPENS DURING THE PROCESS, THIS TRANSACTION WILL BE ROLLBACK */
					IF @@TRANCOUNT > 0
						ROLLBACK TRANSACTION UPDATETOWN;
						PRINT('--------------------------------------------------------------------------------');
						PRINT(' THERE WAS AN UNEXPECTED ERROR DURING THIS PROCESS, CHECK THE DATA BEFORE RETRY ');
						PRINT('--------------------------------------------------------------------------------');
				END CATCH;

				/* IF EVERYTHING'S DONE, THIS RESULT WILL BE PERMANENT INTO THE DB */
				IF @@TRANCOUNT > 0
					COMMIT TRANSACTION UPDATETOWN;
					PRINT('-----------------------------------');
					PRINT(' THE TOWN WAS UPDATED SUCCESSFULLY ');
					PRINT('-----------------------------------');
					/* SHOWS THE DATA THAT WAS UPDATED IN THIS PROCESS */
					SELECT Id, [name] 
					FROM Town
					WHERE Id = @TID
		END
	/* IF THE RECORD DOESNT EXIST INTO THE DB, THE CURRENT TRANSACTION WONT BE APPLIED */
	ELSE
		BEGIN
			PRINT('----------------------------------------------------------------------');
			PRINT(' THE RECORD ID DOESNT EXIST INTO THE DB, CHECK YOUR DATA BEFORE RETRY ');
			PRINT('----------------------------------------------------------------------');
		END
GO




GO
/* ---- DELETE STORED PROCEDURE ----*/

CREATE PROCEDURE DeleteTown
	@TID INT
AS
	/* VERIFY IF THE RECORD EXISTS INTO THE DB */
	IF @TID <= (SELECT Id FROM Town WHERE Id = @TID)
		BEGIN
			/* CREATE A TRANSACTION TO ENSURE THIS PROCESS */
			BEGIN TRANSACTION DELETETOWN
				/* GENERATE A TRY CATCH BLOCK TO PREVENT ERRORS ALONG THE TRANSACTION */
				BEGIN TRY
					/* IF TOWN ID EXISTS INTO THE GARAGE TABLE, SET NULL */
					IF EXISTS (SELECT townId FROM Garage WHERE townId = @TID)
						BEGIN
							UPDATE Garage
							SET townId = NULL
							WHERE townId = @TID
						END
					ELSE
						BEGIN
							PRINT(' NO DEPENDENCY FOUND INTO GARAGE TABLE')
						END

					/* IF TOWN ID EXISTS INTO THE JOURNEY TOWN TABLE, SET NULL */
					IF EXISTS (SELECT townId FROM JourneyTown WHERE townId = @TID)
						BEGIN
							UPDATE JourneyTown
							SET townId = NULL
							WHERE townId = @TID
						END
					ELSE
						BEGIN
							PRINT(' NO DEPENDENCY FOUND INTO JOURNEY TOWN TABLE')
						END

					/* THEN DELETE THE TARGET RECORD RESPECTIVELY */
					DELETE Town
					WHERE Id = @TID

				END TRY

				/* CATCH ALL TYPE OF ERRORS DURING THE PROCESS */
				BEGIN CATCH
					SELECT
					ERROR_NUMBER() AS ErrorNumber
					,ERROR_SEVERITY() AS ErrorSeverity
					,ERROR_STATE() AS ErrorState
					,ERROR_PROCEDURE() AS ErrorProcedure
					,ERROR_LINE() AS ErrorLine
					,ERROR_MESSAGE() AS ErrorMessage;
  
					/* IF SOMETHING HAPPENS DURING THE PROCESS, THIS TRANSACTION WILL BE ROLLBACK */
					IF @@TRANCOUNT > 0
						ROLLBACK TRANSACTION DELETETOWN;
						PRINT('--------------------------------------------------------------------------------');
						PRINT(' THERE WAS AN UNEXPECTED ERROR DURING THIS PROCESS, CHECK THE DATA BEFORE RETRY ');
						PRINT('--------------------------------------------------------------------------------');
				END CATCH;

				/* IF EVERYTHING'S DONE, THIS RESULT WILL BE PERMANENT INTO THE DB */
				IF @@TRANCOUNT > 0
					COMMIT TRANSACTION DELETETOWN;
					PRINT('---------------------------------------');
					PRINT('  THE TOWN WAS DELETED SUCCESSFULLY    ');
					PRINT('---------------------------------------');
		END

	/* IF THE RECORD DOESNT EXIST INTO THE DB, THE CURRENT TRANSACTION WONT BE APPLIED */
	ELSE
		BEGIN
			PRINT('----------------------------------------------------------------------');
			PRINT(' THE RECORD ID DOESNT EXIST INTO THE DB, CHECK YOUR DATA BEFORE RETRY ');
			PRINT('----------------------------------------------------------------------');
		END
GO




GO
/* ---- SELECT STORED PROCEDURE ----*/

CREATE PROCEDURE SelectTown
	@TID INT
AS
	IF @TID <= (SELECT Id FROM Town WHERE Id = @TID)
		BEGIN
			SELECT Id, [NAME] 
			FROM Town
			WHERE Id = @TID
		END
	ELSE
		BEGIN
			PRINT('----------------------------------------------------------------------');
			PRINT(' THE RECORD ID DOESNT EXIST INTO THE DB, CHECK YOUR DATA BEFORE RETRY ');
			PRINT('----------------------------------------------------------------------');
		END
GO




/* ------------------------ GARAGE ------------------------ */

GO
/* ---- INSERT STORED PROCEDURE ---- */

CREATE PROCEDURE InsertGarage
	@name VARCHAR(50),
	@capacity INT,
	@TID INT
AS
	IF EXISTS (SELECT Id FROM Town WHERE Id = @TID)
		BEGIN
			/* CREATE A TRANSACTION TO ENSURE THIS PROCESS */
			BEGIN TRANSACTION INSERTGARAGE
				/* GENERATE A TRY CATCH BLOCK TO PREVENT ERRORS ALONG THE TRANSACTION */
				BEGIN TRY
					INSERT INTO Garage VALUES (@name, @capacity, @TID)
				END TRY

				/* CATCH ALL TYPE OF ERRORS DURING THE PROCESS */
				BEGIN CATCH
					SELECT
					ERROR_NUMBER() AS ErrorNumber
					,ERROR_SEVERITY() AS ErrorSeverity
					,ERROR_STATE() AS ErrorState
					,ERROR_PROCEDURE() AS ErrorProcedure
					,ERROR_LINE() AS ErrorLine
					,ERROR_MESSAGE() AS ErrorMessage;
  
					/* IF SOMETHING HAPPENS DURING THE PROCESS, THIS TRANSACTION WILL BE ROLLBACK */
					IF @@TRANCOUNT > 0
						ROLLBACK TRANSACTION INSERTGARAGE;
						PRINT('--------------------------------------------------------------------------------');
						PRINT(' THERE WAS AN UNEXPECTED ERROR DURING THIS PROCESS, CHECK THE DATA BEFORE RETRY ');
						PRINT('--------------------------------------------------------------------------------');
				END CATCH;

				/* IF EVERYTHING'S DONE, THIS RESULT WILL BE PERMANENT INTO THE DB */
				IF @@TRANCOUNT > 0
					COMMIT TRANSACTION INSERTGARAGE;
					PRINT('-------------------------------------------');
					PRINT(' GARAGE ADDED TO THE DATABASE SUCCESSFULLY ');
					PRINT('-------------------------------------------');
					/* SHOWS THE DATA THAT WAS ADDED IN THIS PROCESS */
					SELECT Id, [name], capacity, townId
					FROM Garage
					WHERE [name] = @name AND capacity = @capacity AND townId = @TID
		END

	/* IF THE TOWN ID DOESNT EXIST INTO THE DB, THE PROCESS WONT BE APPLIED (PREREQUISITE) */
	ELSE
		BEGIN
			PRINT('-----------------------------------------------------------------------------------');
			PRINT(' THE TOWN ID DOESNT EXIST INTO THE DB, CHECK YOUR DATA BEFORE RETRY (PREREQUISITE) ');
			PRINT('-----------------------------------------------------------------------------------');
		END
GO



GO
/* ---- UPDATE STORED PROCEDURE ---- */

CREATE PROCEDURE UpdateGarage
	@GID INT,
	@name VARCHAR(50),
	@capacity INT,
	@TID INT
AS
	/* VERIFY IF THE RECORD EXISTS INTO THE DB */
	IF @GID <= (SELECT Id FROM Garage WHERE Id = @GID)
		BEGIN
			/* CREATE A TRANSACTION TO ENSURE THIS PROCESS */
			BEGIN TRANSACTION UPDATEGARAGE
				/* GENERATE A TRY CATCH BLOCK TO PREVENT ERRORS ALONG THE TRANSACTION */
				BEGIN TRY
					UPDATE Garage
					SET [name] = @name,
						capacity = @capacity,
						townId = @TID
					WHERE Id = @GID
				END TRY

				/* CATCH ALL TYPE OF ERRORS DURING THE PROCESS */
				BEGIN CATCH
					SELECT
					ERROR_NUMBER() AS ErrorNumber
					,ERROR_SEVERITY() AS ErrorSeverity
					,ERROR_STATE() AS ErrorState
					,ERROR_PROCEDURE() AS ErrorProcedure
					,ERROR_LINE() AS ErrorLine
					,ERROR_MESSAGE() AS ErrorMessage;
  
					/* IF SOMETHING HAPPENS DURING THE PROCESS, THIS TRANSACTION WILL BE ROLLBACK */
					IF @@TRANCOUNT > 0
						ROLLBACK TRANSACTION UPDATEGARAGE;
						PRINT('--------------------------------------------------------------------------------');
						PRINT(' THERE WAS AN UNEXPECTED ERROR DURING THIS PROCESS, CHECK THE DATA BEFORE RETRY ');
						PRINT('--------------------------------------------------------------------------------');
				END CATCH;

				/* IF EVERYTHING'S DONE, THIS RESULT WILL BE PERMANENT INTO THE DB */
				IF @@TRANCOUNT > 0
					COMMIT TRANSACTION UPDATEGARAGE;
					PRINT('-------------------------------------');
					PRINT(' THE GARAGE WAS UPDATED SUCCESSFULLY ');
					PRINT('-------------------------------------');
					/* SHOWS THE DATA THAT WAS UPDATED IN THIS PROCESS */
					SELECT Id, [name], capacity, townId
					FROM Garage
					WHERE Id = @GID
		END
	/* IF THE RECORD DOESNT EXIST INTO THE DB, THE CURRENT TRANSACTION WONT BE APPLIED */
	ELSE
		BEGIN
			PRINT('----------------------------------------------------------------------');
			PRINT(' THE RECORD ID DOESNT EXIST INTO THE DB, CHECK YOUR DATA BEFORE RETRY ');
			PRINT('----------------------------------------------------------------------');
		END
GO




GO
/* ---- DELETE STORED PROCEDURE ----*/

CREATE PROCEDURE DeleteGarage
	@GID INT
AS
	/* VERIFY IF THE RECORD EXISTS INTO THE DB */
	IF @GID <= (SELECT Id FROM Garage WHERE Id = @GID)
		BEGIN
			/* CREATE A TRANSACTION TO ENSURE THIS PROCESS */
			BEGIN TRANSACTION DELETEGARAGE
				/* GENERATE A TRY CATCH BLOCK TO PREVENT ERRORS ALONG THE TRANSACTION */
				BEGIN TRY
					DELETE Garage
					WHERE Id = @GID
				END TRY

				/* CATCH ALL TYPE OF ERRORS DURING THE PROCESS */
				BEGIN CATCH
					SELECT
					ERROR_NUMBER() AS ErrorNumber
					,ERROR_SEVERITY() AS ErrorSeverity
					,ERROR_STATE() AS ErrorState
					,ERROR_PROCEDURE() AS ErrorProcedure
					,ERROR_LINE() AS ErrorLine
					,ERROR_MESSAGE() AS ErrorMessage;
  
					/* IF SOMETHING HAPPENS DURING THE PROCESS, THIS TRANSACTION WILL BE ROLLBACK */
					IF @@TRANCOUNT > 0
						ROLLBACK TRANSACTION DELETEGARAGE;
						PRINT('--------------------------------------------------------------------------------');
						PRINT(' THERE WAS AN UNEXPECTED ERROR DURING THIS PROCESS, CHECK THE DATA BEFORE RETRY ');
						PRINT('--------------------------------------------------------------------------------');
				END CATCH;

				/* IF EVERYTHING'S DONE, THIS RESULT WILL BE PERMANENT INTO THE DB */
				IF @@TRANCOUNT > 0
					COMMIT TRANSACTION DELETEGARAGE;
					PRINT('-----------------------------------------');
					PRINT('  THE GARAGE WAS DELETED SUCCESSFULLY    ');
					PRINT('-----------------------------------------');
		END

	/* IF THE RECORD DOESNT EXIST INTO THE DB, THE CURRENT TRANSACTION WONT BE APPLIED */
	ELSE
		BEGIN
			PRINT('----------------------------------------------------------------------');
			PRINT(' THE RECORD ID DOESNT EXIST INTO THE DB, CHECK YOUR DATA BEFORE RETRY ');
			PRINT('----------------------------------------------------------------------');
		END
GO




GO
/* ---- SELECT STORED PROCEDURE ----*/

CREATE PROCEDURE SelectGarage
	@GID INT
AS
	IF @GID <= (SELECT Id FROM Garage WHERE Id = @GID)
		BEGIN
			SELECT Id, [name], capacity, townId
			FROM Garage
			WHERE Id = @GID
		END
	ELSE
		BEGIN
			PRINT('----------------------------------------------------------------------');
			PRINT(' THE RECORD ID DOESNT EXIST INTO THE DB, CHECK YOUR DATA BEFORE RETRY ');
			PRINT('----------------------------------------------------------------------');
		END
GO



/* ------------------------ JOURNEY TOWN  ------------------------ */

GO
/* ---- INSERT STORED PROCEDURE ---- */

CREATE PROCEDURE InsertJourneyTown
	@TID INT,
	@JID INT
AS
	/* CREATE A TRANSACTION TO ENSURE THIS PROCESS */
	BEGIN TRANSACTION INSERTJOURNEYTOWN

		/* GENERATE A TRY CATCH BLOCK TO PREVENT ERRORS ALONG THE TRANSACTION */
		BEGIN TRY
			INSERT INTO JourneyTown VALUES (@TID, @JID)
		END TRY

		/* CATCH ALL TYPE OF ERRORS DURING THE PROCESS */
		BEGIN CATCH
				SELECT
				ERROR_NUMBER() AS ErrorNumber
				,ERROR_SEVERITY() AS ErrorSeverity
				,ERROR_STATE() AS ErrorState
				,ERROR_PROCEDURE() AS ErrorProcedure
				,ERROR_LINE() AS ErrorLine
				,ERROR_MESSAGE() AS ErrorMessage;
  
				/* IF SOMETHING HAPPENS DURING THE PROCESS, THIS TRANSACTION WILL BE ROLLBACK */
				IF @@TRANCOUNT > 0
					ROLLBACK TRANSACTION INSERTJOURNEYTOWN;
					PRINT('--------------------------------------------------------------------------------');
					PRINT(' THERE WAS AN UNEXPECTED ERROR DURING THIS PROCESS, CHECK THE DATA BEFORE RETRY ');
					PRINT('--------------------------------------------------------------------------------');
		END CATCH;

	/* IF EVERYTHING'S DONE, THIS RESULT WILL BE PERMANENT INTO THE DB */
	IF @@TRANCOUNT > 0
		COMMIT TRANSACTION INSERTJOURNEYTOWN;
		PRINT('-------------------------------------------------');
		PRINT(' JOURNEY TOWN ADDED TO THE DATABASE SUCCESSFULLY ');
		PRINT('-------------------------------------------------');
		/* SHOWS THE DATA THAT WAS ADDED IN THIS PROCESS */
		SELECT townId, journeyId
		FROM JourneyTown
		WHERE townId = @TID AND journeyId = @JID
GO




GO
/* ---- UPDATE STORED PROCEDURE ---- */

CREATE PROCEDURE UpdateJourneyTown
	@TtargetId INT,
	@JtargetId INT,
	@TID INT,
	@JID INT
AS
	/* VERIFY IF THE RECORD EXISTS INTO THE DB */
	IF EXISTS (SELECT townId, journeyId FROM JourneyTown WHERE townId = @TtargetId AND journeyId = @JtargetId)
		BEGIN
			/* CREATE A TRANSACTION TO ENSURE THIS PROCESS */
			BEGIN TRANSACTION UPDATEJOURNEYTOWN
				/* GENERATE A TRY CATCH BLOCK TO PREVENT ERRORS ALONG THE TRANSACTION */
				BEGIN TRY
					UPDATE JourneyTown
					SET townId = @TID, journeyId = @JID
					WHERE townId = @TtargetId AND journeyId = @JtargetId
				END TRY

				/* CATCH ALL TYPE OF ERRORS DURING THE PROCESS */
				BEGIN CATCH
					SELECT
					ERROR_NUMBER() AS ErrorNumber
					,ERROR_SEVERITY() AS ErrorSeverity
					,ERROR_STATE() AS ErrorState
					,ERROR_PROCEDURE() AS ErrorProcedure
					,ERROR_LINE() AS ErrorLine
					,ERROR_MESSAGE() AS ErrorMessage;
  
					/* IF SOMETHING HAPPENS DURING THE PROCESS, THIS TRANSACTION WILL BE ROLLBACK */
					IF @@TRANCOUNT > 0
						ROLLBACK TRANSACTION UPDATEJOURNEYTOWN;
						PRINT('--------------------------------------------------------------------------------');
						PRINT(' THERE WAS AN UNEXPECTED ERROR DURING THIS PROCESS, CHECK THE DATA BEFORE RETRY ');
						PRINT('--------------------------------------------------------------------------------');
				END CATCH;

				/* IF EVERYTHING'S DONE, THIS RESULT WILL BE PERMANENT INTO THE DB */
				IF @@TRANCOUNT > 0
					COMMIT TRANSACTION UPDATEJOURNEYTOWN;
					PRINT('-------------------------------------------');
					PRINT(' THE JOURNEY TOWN WAS UPDATED SUCCESSFULLY ');
					PRINT('-------------------------------------------');
					/* SHOWS THE DATA THAT WAS UPDATED IN THIS PROCESS */
					SELECT townId, journeyId
					FROM JourneyTown
					WHERE townId = @TID AND journeyId = @JID
		END
	/* IF THE RECORD DOESNT EXIST INTO THE DB, THE CURRENT TRANSACTION WONT BE APPLIED */
	ELSE
		BEGIN
			PRINT('----------------------------------------------------------------------');
			PRINT(' THE RECORD ID DOESNT EXIST INTO THE DB, CHECK YOUR DATA BEFORE RETRY ');
			PRINT('----------------------------------------------------------------------');
		END
GO




GO
/* ---- DELETE STORED PROCEDURE ----*/

CREATE PROCEDURE DeleteJourneyTown
	@TID INT,
	@JID INT
AS
	/* VERIFY IF THE RECORD EXISTS INTO THE DB */
	IF EXISTS (SELECT townId, journeyId FROM JourneyTown WHERE townId = @TID AND journeyId = @JID)
		BEGIN
			/* CREATE A TRANSACTION TO ENSURE THIS PROCESS */
			BEGIN TRANSACTION DELETEJOURNEYTOWN
				/* GENERATE A TRY CATCH BLOCK TO PREVENT ERRORS ALONG THE TRANSACTION */
				BEGIN TRY
					DELETE JourneyTown
					WHERE townId = @TID AND journeyId = @JID
				END TRY

				/* CATCH ALL TYPE OF ERRORS DURING THE PROCESS */
				BEGIN CATCH
					SELECT
					ERROR_NUMBER() AS ErrorNumber
					,ERROR_SEVERITY() AS ErrorSeverity
					,ERROR_STATE() AS ErrorState
					,ERROR_PROCEDURE() AS ErrorProcedure
					,ERROR_LINE() AS ErrorLine
					,ERROR_MESSAGE() AS ErrorMessage;
  
					/* IF SOMETHING HAPPENS DURING THE PROCESS, THIS TRANSACTION WILL BE ROLLBACK */
					IF @@TRANCOUNT > 0
						ROLLBACK TRANSACTION DELETEJOURNEYTOWN;
						PRINT('--------------------------------------------------------------------------------');
						PRINT(' THERE WAS AN UNEXPECTED ERROR DURING THIS PROCESS, CHECK THE DATA BEFORE RETRY ');
						PRINT('--------------------------------------------------------------------------------');
				END CATCH;

				/* IF EVERYTHING'S DONE, THIS RESULT WILL BE PERMANENT INTO THE DB */
				IF @@TRANCOUNT > 0
					COMMIT TRANSACTION DELETEJOURNEYTOWN;
					PRINT('-----------------------------------------------');
					PRINT('   THE JOURNEY TOWN WAS DELETED SUCCESSFULLY   ');
					PRINT('-----------------------------------------------');
		END

	/* IF THE RECORD DOESNT EXIST INTO THE DB, THE CURRENT TRANSACTION WONT BE APPLIED */
	ELSE
		BEGIN
			PRINT('----------------------------------------------------------------------');
			PRINT(' THE RECORD ID DOESNT EXIST INTO THE DB, CHECK YOUR DATA BEFORE RETRY ');
			PRINT('----------------------------------------------------------------------');
		END
GO




GO
/* ---- SELECT STORED PROCEDURE ----*/
CREATE PROCEDURE SelectJourneyTown
	@TID INT,
	@JID INT
AS
	IF EXISTS (SELECT townId, journeyId FROM JourneyTown WHERE townId = @TID AND journeyId = @JID)
		BEGIN
			SELECT townId, journeyId
			FROM JourneyTown
			WHERE townId = @TID AND journeyId = @JID
		END
	ELSE
		BEGIN
			PRINT('----------------------------------------------------------------------');
			PRINT(' THE RECORD ID DOESNT EXIST INTO THE DB, CHECK YOUR DATA BEFORE RETRY ');
			PRINT('----------------------------------------------------------------------');
		END
GO



/* ------------------------ DRIVER ------------------------ */

GO
/* ---- INSERT STORED PROCEDURE ---- */

CREATE PROCEDURE InsertDriver
	@name VARCHAR(50),
	@address VARCHAR(100),
	@telephone VARCHAR(50),
	@JID INT
AS
	IF EXISTS (SELECT Id FROM Journey WHERE Id = @JID)
		BEGIN
			/* CREATE A TRANSACTION TO ENSURE THIS PROCESS */
			BEGIN TRANSACTION INSERTDRIVER
				/* GENERATE A TRY CATCH BLOCK TO PREVENT ERRORS ALONG THE TRANSACTION */
				BEGIN TRY
					INSERT INTO Driver VALUES (@name, @address, @telephone, @JID)
				END TRY

				/* CATCH ALL TYPE OF ERRORS DURING THE PROCESS */
				BEGIN CATCH
					SELECT
					ERROR_NUMBER() AS ErrorNumber
					,ERROR_SEVERITY() AS ErrorSeverity
					,ERROR_STATE() AS ErrorState
					,ERROR_PROCEDURE() AS ErrorProcedure
					,ERROR_LINE() AS ErrorLine
					,ERROR_MESSAGE() AS ErrorMessage;
  
					/* IF SOMETHING HAPPENS DURING THE PROCESS, THIS TRANSACTION WILL BE ROLLBACK */
					IF @@TRANCOUNT > 0
						ROLLBACK TRANSACTION INSERTDRIVER;
						PRINT('--------------------------------------------------------------------------------');
						PRINT(' THERE WAS AN UNEXPECTED ERROR DURING THIS PROCESS, CHECK THE DATA BEFORE RETRY ');
						PRINT('--------------------------------------------------------------------------------');
				END CATCH;

				/* IF EVERYTHING'S DONE, THIS RESULT WILL BE PERMANENT INTO THE DB */
				IF @@TRANCOUNT > 0
					COMMIT TRANSACTION INSERTDRIVER;
					PRINT('-------------------------------------------');
					PRINT(' DRIVER ADDED TO THE DATABASE SUCCESSFULLY ');
					PRINT('-------------------------------------------');
					/* SHOWS THE DATA THAT WAS ADDED IN THIS PROCESS */
					SELECT Id, [name], [address], telephone, journeyId
					FROM Driver
					WHERE [name] = @name AND [address] = @address AND journeyId = @JID
		END

	/* IF THE JOURNEY ID DOESNT EXIST INTO THE DB, THE PROCESS WONT BE APPLIED (PREREQUISITE) */
	ELSE
		BEGIN
			PRINT('--------------------------------------------------------------------------------------')
			PRINT(' THE JOURNEY ID DOESNT EXIST INTO THE DB, CHECK YOUR DATA BEFORE RETRY (PREREQUISITE) ')
			PRINT('--------------------------------------------------------------------------------------')
		END
GO




GO
/* ---- UPDATE STORED PROCEDURE ---- */

CREATE PROCEDURE UpdateDriver
	@DID INT,
	@name VARCHAR(50),
	@address VARCHAR(100),
	@telephone VARCHAR(50),
	@JID INT
AS
	/* VERIFY IF THE RECORD EXISTS INTO THE DB */
	IF @DID <= (SELECT Id FROM Driver WHERE Id = @DID)
		BEGIN
			/* CREATE A TRANSACTION TO ENSURE THIS PROCESS */
			BEGIN TRANSACTION UPDATEDRIVER
				/* GENERATE A TRY CATCH BLOCK TO PREVENT ERRORS ALONG THE TRANSACTION */
				BEGIN TRY
					UPDATE Driver
					SET [name] = @name,
						[address] = @address,
						telephone = @telephone,
						journeyId = @JID
					WHERE Id = @DID
				END TRY

				/* CATCH ALL TYPE OF ERRORS DURING THE PROCESS */
				BEGIN CATCH
					SELECT
					ERROR_NUMBER() AS ErrorNumber
					,ERROR_SEVERITY() AS ErrorSeverity
					,ERROR_STATE() AS ErrorState
					,ERROR_PROCEDURE() AS ErrorProcedure
					,ERROR_LINE() AS ErrorLine
					,ERROR_MESSAGE() AS ErrorMessage;
  
					/* IF SOMETHING HAPPENS DURING THE PROCESS, THIS TRANSACTION WILL BE ROLLBACK */
					IF @@TRANCOUNT > 0
						ROLLBACK TRANSACTION UPDATEDRIVER;
						PRINT('--------------------------------------------------------------------------------');
						PRINT(' THERE WAS AN UNEXPECTED ERROR DURING THIS PROCESS, CHECK THE DATA BEFORE RETRY ');
						PRINT('--------------------------------------------------------------------------------');
				END CATCH;

				/* IF EVERYTHING'S DONE, THIS RESULT WILL BE PERMANENT INTO THE DB */
				IF @@TRANCOUNT > 0
					COMMIT TRANSACTION UPDATEDRIVER;
					PRINT('-------------------------------------');
					PRINT(' THE DRIVER WAS UPDATED SUCCESSFULLY ');
					PRINT('-------------------------------------');
					/* SHOWS THE DATA THAT WAS UPDATED IN THIS PROCESS */
					SELECT Id, [name], [address], telephone, journeyId
					FROM Driver
					WHERE Id = @DID
		END
	/* IF THE RECORD DOESNT EXIST INTO THE DB, THE CURRENT TRANSACTION WONT BE APPLIED */
	ELSE
		BEGIN
			PRINT('----------------------------------------------------------------------');
			PRINT(' THE RECORD ID DOESNT EXIST INTO THE DB, CHECK YOUR DATA BEFORE RETRY ');
			PRINT('----------------------------------------------------------------------');
		END
GO




GO
/* ---- DELETE STORED PROCEDURE ----*/

CREATE PROCEDURE DeleteDriver
	@DID INT
AS
	/* VERIFY IF THE RECORD EXISTS INTO THE DB */
	IF @DID <= (SELECT Id FROM Driver WHERE Id = @DID)
		BEGIN
			/* CREATE A TRANSACTION TO ENSURE THIS PROCESS */
			BEGIN TRANSACTION DELETEDRIVER
				/* GENERATE A TRY CATCH BLOCK TO PREVENT ERRORS ALONG THE TRANSACTION */
				BEGIN TRY
					DELETE Driver
					WHERE Id = @DID
				END TRY

				/* CATCH ALL TYPE OF ERRORS DURING THE PROCESS */
				BEGIN CATCH
					SELECT
					ERROR_NUMBER() AS ErrorNumber
					,ERROR_SEVERITY() AS ErrorSeverity
					,ERROR_STATE() AS ErrorState
					,ERROR_PROCEDURE() AS ErrorProcedure
					,ERROR_LINE() AS ErrorLine
					,ERROR_MESSAGE() AS ErrorMessage;
  
					/* IF SOMETHING HAPPENS DURING THE PROCESS, THIS TRANSACTION WILL BE ROLLBACK */
					IF @@TRANCOUNT > 0
						ROLLBACK TRANSACTION DELETEDRIVER;
						PRINT('--------------------------------------------------------------------------------');
						PRINT(' THERE WAS AN UNEXPECTED ERROR DURING THIS PROCESS, CHECK THE DATA BEFORE RETRY ');
						PRINT('--------------------------------------------------------------------------------');
				END CATCH;

				/* IF EVERYTHING'S DONE, THIS RESULT WILL BE PERMANENT INTO THE DB */
				IF @@TRANCOUNT > 0
					COMMIT TRANSACTION DELETEDRIVER;
					PRINT('-----------------------------------------');
					PRINT('  THE DRIVER WAS DELETED SUCCESSFULLY    ');
					PRINT('-----------------------------------------');
		END

	/* IF THE RECORD DOESNT EXIST INTO THE DB, THE CURRENT TRANSACTION WONT BE APPLIED */
	ELSE
		BEGIN
			PRINT('----------------------------------------------------------------------');
			PRINT(' THE RECORD ID DOESNT EXIST INTO THE DB, CHECK YOUR DATA BEFORE RETRY ');
			PRINT('----------------------------------------------------------------------');
		END
GO




GO
/* ---- SELECT STORED PROCEDURE ----*/

CREATE PROCEDURE SelectDriver
	@DID INT
AS
	IF @DID <= (SELECT Id FROM Driver WHERE Id = @DID)
		BEGIN
			SELECT Id, [name], [address], telephone, journeyId
			FROM Driver
			WHERE Id = @DID
		END
	ELSE
		BEGIN
			PRINT('----------------------------------------------------------------------');
			PRINT(' THE RECORD ID DOESNT EXIST INTO THE DB, CHECK YOUR DATA BEFORE RETRY ');
			PRINT('----------------------------------------------------------------------');
		END
GO



/* ------------------------ TYPE BUS ------------------------ */

GO
/* ---- INSERT STORED PROCEDURE ---- */

CREATE PROCEDURE InsertTypeBus
	@description VARCHAR(100)
AS
	/* CREATE A TRANSACTION TO ENSURE THIS PROCESS */
	BEGIN TRANSACTION INSERTTYPEBUS

		/* GENERATE A TRY CATCH BLOCK TO PREVENT ERRORS ALONG THE TRANSACTION */
		BEGIN TRY
			INSERT INTO TypeBus VALUES (@description)
		END TRY

		/* CATCH ALL TYPE OF ERRORS DURING THE PROCESS */
		BEGIN CATCH
				SELECT
				ERROR_NUMBER() AS ErrorNumber
				,ERROR_SEVERITY() AS ErrorSeverity
				,ERROR_STATE() AS ErrorState
				,ERROR_PROCEDURE() AS ErrorProcedure
				,ERROR_LINE() AS ErrorLine
				,ERROR_MESSAGE() AS ErrorMessage;
  
				/* IF SOMETHING HAPPENS DURING THE PROCESS, THIS TRANSACTION WILL BE ROLLBACK */
				IF @@TRANCOUNT > 0
					ROLLBACK TRANSACTION INSERTTYPEBUS;
					PRINT('--------------------------------------------------------------------------------');
					PRINT(' THERE WAS AN UNEXPECTED ERROR DURING THIS PROCESS, CHECK THE DATA BEFORE RETRY ');
					PRINT('--------------------------------------------------------------------------------');
		END CATCH;

	/* IF EVERYTHING'S DONE, THIS RESULT WILL BE PERMANENT INTO THE DB */
	IF @@TRANCOUNT > 0
		COMMIT TRANSACTION INSERTTYPEBUS;
		PRINT('---------------------------------------------');
		PRINT(' TYPE BUS ADDED TO THE DATABASE SUCCESSFULLY ');
		PRINT('---------------------------------------------');
		/* SHOWS THE DATA THAT WAS ADDED IN THIS PROCESS */
		SELECT Id, [description]
		FROM TypeBus
		WHERE [description] = @description
GO




GO
/* ---- UPDATE STORED PROCEDURE ---- */

CREATE PROCEDURE UpdateTypeBus
	@TBID INT,
	@description VARCHAR(100)
AS
	/* VERIFY IF THE RECORD EXISTS INTO THE DB */
	IF @TBID <= (SELECT Id FROM TypeBus WHERE Id = @TBID)
		BEGIN
			/* CREATE A TRANSACTION TO ENSURE THIS PROCESS */
			BEGIN TRANSACTION UPDATETYPEBUS
				/* GENERATE A TRY CATCH BLOCK TO PREVENT ERRORS ALONG THE TRANSACTION */
				BEGIN TRY
					UPDATE TypeBus
					SET [description] = @description
					WHERE Id = @TBID
				END TRY

				/* CATCH ALL TYPE OF ERRORS DURING THE PROCESS */
				BEGIN CATCH
					SELECT
					ERROR_NUMBER() AS ErrorNumber
					,ERROR_SEVERITY() AS ErrorSeverity
					,ERROR_STATE() AS ErrorState
					,ERROR_PROCEDURE() AS ErrorProcedure
					,ERROR_LINE() AS ErrorLine
					,ERROR_MESSAGE() AS ErrorMessage;
  
					/* IF SOMETHING HAPPENS DURING THE PROCESS, THIS TRANSACTION WILL BE ROLLBACK */
					IF @@TRANCOUNT > 0
						ROLLBACK TRANSACTION UPDATETYPEBUS;
						PRINT('--------------------------------------------------------------------------------');
						PRINT(' THERE WAS AN UNEXPECTED ERROR DURING THIS PROCESS, CHECK THE DATA BEFORE RETRY ');
						PRINT('--------------------------------------------------------------------------------');
				END CATCH;

				/* IF EVERYTHING'S DONE, THIS RESULT WILL BE PERMANENT INTO THE DB */
				IF @@TRANCOUNT > 0
					COMMIT TRANSACTION UPDATETYPEBUS;
					PRINT('---------------------------------------');
					PRINT(' THE TYPE BUS WAS UPDATED SUCCESSFULLY ');
					PRINT('---------------------------------------');
					/* SHOWS THE DATA THAT WAS UPDATED IN THIS PROCESS */
					SELECT Id, [description] 
					FROM TypeBus
					WHERE Id = @TBID
		END
	/* IF THE RECORD DOESNT EXIST INTO THE DB, THE CURRENT TRANSACTION WONT BE APPLIED */
	ELSE
		BEGIN
			PRINT('----------------------------------------------------------------------');
			PRINT(' THE RECORD ID DOESNT EXIST INTO THE DB, CHECK YOUR DATA BEFORE RETRY ');
			PRINT('----------------------------------------------------------------------');
		END
GO



GO
/* ---- DELETE STORED PROCEDURE ----*/

CREATE PROCEDURE DeleteTypeBus
	@TBID INT
AS
	/* VERIFY IF THE RECORD EXISTS INTO THE DB */
	IF @TBID <= (SELECT Id FROM TypeBus WHERE Id = @TBID)
		BEGIN
			/* CREATE A TRANSACTION TO ENSURE THIS PROCESS */
			BEGIN TRANSACTION DELETETYPEBUS
				/* GENERATE A TRY CATCH BLOCK TO PREVENT ERRORS ALONG THE TRANSACTION */
				BEGIN TRY
					/* IF TOWN ID EXISTS INTO THE GARAGE TABLE, SET NULL */
					IF EXISTS (SELECT typeBusId FROM Bus WHERE typeBusId = @TBID)
						BEGIN
							UPDATE Bus
							SET typeBusId = NULL
							WHERE typeBusId = @TBID
						END
					ELSE
						BEGIN
							PRINT(' NO DEPENDENCY FOUND INTO BUS TABLE')
						END

					/* THEN DELETE THE TARGET RECORD RESPECTIVELY */
					DELETE TypeBus
					WHERE Id = @TBID

				END TRY

				/* CATCH ALL TYPE OF ERRORS DURING THE PROCESS */
				BEGIN CATCH
					SELECT
					ERROR_NUMBER() AS ErrorNumber
					,ERROR_SEVERITY() AS ErrorSeverity
					,ERROR_STATE() AS ErrorState
					,ERROR_PROCEDURE() AS ErrorProcedure
					,ERROR_LINE() AS ErrorLine
					,ERROR_MESSAGE() AS ErrorMessage;
  
					/* IF SOMETHING HAPPENS DURING THE PROCESS, THIS TRANSACTION WILL BE ROLLBACK */
					IF @@TRANCOUNT > 0
						ROLLBACK TRANSACTION DELETETYPEBUS;
						PRINT('--------------------------------------------------------------------------------');
						PRINT(' THERE WAS AN UNEXPECTED ERROR DURING THIS PROCESS, CHECK THE DATA BEFORE RETRY ');
						PRINT('--------------------------------------------------------------------------------');
				END CATCH;

				/* IF EVERYTHING'S DONE, THIS RESULT WILL BE PERMANENT INTO THE DB */
				IF @@TRANCOUNT > 0
					COMMIT TRANSACTION DELETETYPEBUS;
					PRINT('-------------------------------------------');
					PRINT('  THE TYPE BUS WAS DELETED SUCCESSFULLY    ');
					PRINT('-------------------------------------------');
		END

	/* IF THE RECORD DOESNT EXIST INTO THE DB, THE CURRENT TRANSACTION WONT BE APPLIED */
	ELSE
		BEGIN
			PRINT('----------------------------------------------------------------------');
			PRINT(' THE RECORD ID DOESNT EXIST INTO THE DB, CHECK YOUR DATA BEFORE RETRY ');
			PRINT('----------------------------------------------------------------------');
		END
GO



GO
/* ---- SELECT STORED PROCEDURE ----*/

CREATE PROCEDURE SelectTypeBus
	@TBID INT
AS
	IF @TBID <= (SELECT Id FROM TypeBus WHERE Id = @TBID)
		BEGIN
			SELECT Id, [description]
			FROM TypeBus
			WHERE Id = @TBID
		END
	ELSE
		BEGIN
			PRINT('----------------------------------------------------------------------');
			PRINT(' THE RECORD ID DOESNT EXIST INTO THE DB, CHECK YOUR DATA BEFORE RETRY ');
			PRINT('----------------------------------------------------------------------');
		END
GO




/* ------------------------ BUS ------------------------ */

GO
/* ---- INSERT STORED PROCEDURE ---- */

CREATE PROCEDURE InsertBus
	@Lplate VARCHAR(50),
	@capacity INT,
	@size VARCHAR(50),
	@TBID INT,
	@RID INT
AS
	IF EXISTS (SELECT Id FROM TypeBus WHERE Id = @TBID) AND EXISTS (SELECT Id FROM [Route] WHERE Id = @RID)
		BEGIN
			/* CREATE A TRANSACTION TO ENSURE THIS PROCESS */
			BEGIN TRANSACTION INSERTBUS
				/* GENERATE A TRY CATCH BLOCK TO PREVENT ERRORS ALONG THE TRANSACTION */
				BEGIN TRY
					INSERT INTO Bus VALUES (@Lplate, @capacity, @size, @TBID, @RID)
				END TRY

				/* CATCH ALL TYPE OF ERRORS DURING THE PROCESS */
				BEGIN CATCH
					SELECT
					ERROR_NUMBER() AS ErrorNumber
					,ERROR_SEVERITY() AS ErrorSeverity
					,ERROR_STATE() AS ErrorState
					,ERROR_PROCEDURE() AS ErrorProcedure
					,ERROR_LINE() AS ErrorLine
					,ERROR_MESSAGE() AS ErrorMessage;
  
					/* IF SOMETHING HAPPENS DURING THE PROCESS, THIS TRANSACTION WILL BE ROLLBACK */
					IF @@TRANCOUNT > 0
						ROLLBACK TRANSACTION INSERTBUS;
						PRINT('--------------------------------------------------------------------------------');
						PRINT(' THERE WAS AN UNEXPECTED ERROR DURING THIS PROCESS, CHECK THE DATA BEFORE RETRY ');
						PRINT('--------------------------------------------------------------------------------');
				END CATCH;

				/* IF EVERYTHING'S DONE, THIS RESULT WILL BE PERMANENT INTO THE DB */
				IF @@TRANCOUNT > 0
					COMMIT TRANSACTION INSERTBUS;
					PRINT('----------------------------------------');
					PRINT(' BUS ADDED TO THE DATABASE SUCCESSFULLY ');
					PRINT('----------------------------------------');
					/* SHOWS THE DATA THAT WAS ADDED IN THIS PROCESS */
					SELECT licencePlate, capacity, size, typeBusId, routeId
					FROM Bus
					WHERE licencePlate = @Lplate
		END

	/* IF THE TYPE BUS ID DOESNT EXIST INTO THE DB, THE PROCESS WONT BE APPLIED (PREREQUISITE) */
	ELSE
		BEGIN
			PRINT('---------------------------------------------------------------------------------------------------');
			PRINT(' THE TYPE BUS ID OR ROUTE ID DOESNT EXIST INTO THE DB, CHECK YOUR DATA BEFORE RETRY (PREREQUISITE) ');
			PRINT('---------------------------------------------------------------------------------------------------');
		END
GO




GO
/* ---- UPDATE STORED PROCEDURE ---- */

CREATE PROCEDURE UpdateBus
	@Lplate VARCHAR(50),
	@capacity INT,
	@size VARCHAR(50),
	@TBID INT,
	@RID INT
AS
	/* VERIFY IF THE RECORD EXISTS INTO THE DB */
	IF @Lplate <= (SELECT licencePlate FROM Bus WHERE licencePlate = @Lplate)
		BEGIN
			/* CREATE A TRANSACTION TO ENSURE THIS PROCESS */
			BEGIN TRANSACTION UPDATEBUS
				/* GENERATE A TRY CATCH BLOCK TO PREVENT ERRORS ALONG THE TRANSACTION */
				BEGIN TRY
					UPDATE Bus
					SET licencePlate = @Lplate,
						capacity = @capacity,
						size = @size,
						typeBusId = @TBID,
						routeId = @RID
					WHERE licencePlate = @Lplate
				END TRY

				/* CATCH ALL TYPE OF ERRORS DURING THE PROCESS */
				BEGIN CATCH
					SELECT
					ERROR_NUMBER() AS ErrorNumber
					,ERROR_SEVERITY() AS ErrorSeverity
					,ERROR_STATE() AS ErrorState
					,ERROR_PROCEDURE() AS ErrorProcedure
					,ERROR_LINE() AS ErrorLine
					,ERROR_MESSAGE() AS ErrorMessage;
  
					/* IF SOMETHING HAPPENS DURING THE PROCESS, THIS TRANSACTION WILL BE ROLLBACK */
					IF @@TRANCOUNT > 0
						ROLLBACK TRANSACTION UPDATEBUS;
						PRINT('--------------------------------------------------------------------------------');
						PRINT(' THERE WAS AN UNEXPECTED ERROR DURING THIS PROCESS, CHECK THE DATA BEFORE RETRY ');
						PRINT('--------------------------------------------------------------------------------');
				END CATCH;

				/* IF EVERYTHING'S DONE, THIS RESULT WILL BE PERMANENT INTO THE DB */
				IF @@TRANCOUNT > 0
					COMMIT TRANSACTION UPDATEBUS;
					PRINT('----------------------------------');
					PRINT(' THE BUS WAS UPDATED SUCCESSFULLY ');
					PRINT('----------------------------------');
					/* SHOWS THE DATA THAT WAS UPDATED IN THIS PROCESS */
					SELECT licencePlate, capacity, size, typeBusId, routeId
					FROM Bus
					WHERE licencePlate = @Lplate
		END
	/* IF THE RECORD DOESNT EXIST INTO THE DB, THE CURRENT TRANSACTION WONT BE APPLIED */
	ELSE
		BEGIN
			PRINT('----------------------------------------------------------------------');
			PRINT(' THE RECORD ID DOESNT EXIST INTO THE DB, CHECK YOUR DATA BEFORE RETRY ');
			PRINT('----------------------------------------------------------------------');
		END
GO



GO
/* ---- DELETE STORED PROCEDURE ----*/

CREATE PROCEDURE DeleteBus
	@Lplate VARCHAR(50)
AS
	/* VERIFY IF THE RECORD EXISTS INTO THE DB */
	IF @Lplate <= (SELECT licencePlate FROM Bus WHERE licencePlate = @Lplate)
		BEGIN
			/* CREATE A TRANSACTION TO ENSURE THIS PROCESS */
			BEGIN TRANSACTION DELETEBUS
				/* GENERATE A TRY CATCH BLOCK TO PREVENT ERRORS ALONG THE TRANSACTION */
				BEGIN TRY
					DELETE Bus
					WHERE licencePlate = @Lplate
				END TRY

				/* CATCH ALL TYPE OF ERRORS DURING THE PROCESS */
				BEGIN CATCH
					SELECT
					ERROR_NUMBER() AS ErrorNumber
					,ERROR_SEVERITY() AS ErrorSeverity
					,ERROR_STATE() AS ErrorState
					,ERROR_PROCEDURE() AS ErrorProcedure
					,ERROR_LINE() AS ErrorLine
					,ERROR_MESSAGE() AS ErrorMessage;
  
					/* IF SOMETHING HAPPENS DURING THE PROCESS, THIS TRANSACTION WILL BE ROLLBACK */
					IF @@TRANCOUNT > 0
						ROLLBACK TRANSACTION DELETEBUS;
						PRINT('--------------------------------------------------------------------------------');
						PRINT(' THERE WAS AN UNEXPECTED ERROR DURING THIS PROCESS, CHECK THE DATA BEFORE RETRY ');
						PRINT('--------------------------------------------------------------------------------');
				END CATCH;

				/* IF EVERYTHING'S DONE, THIS RESULT WILL BE PERMANENT INTO THE DB */
				IF @@TRANCOUNT > 0
					COMMIT TRANSACTION DELETEBUS;
					PRINT('--------------------------------------');
					PRINT('  THE BUS WAS DELETED SUCCESSFULLY    ');
					PRINT('--------------------------------------');
		END

	/* IF THE RECORD DOESNT EXIST INTO THE DB, THE CURRENT TRANSACTION WONT BE APPLIED */
	ELSE
		BEGIN
			PRINT('----------------------------------------------------------------------');
			PRINT(' THE RECORD ID DOESNT EXIST INTO THE DB, CHECK YOUR DATA BEFORE RETRY ');
			PRINT('----------------------------------------------------------------------');
		END
GO



GO
/* ---- SELECT STORED PROCEDURE ----*/

CREATE PROCEDURE SelectBus
	@Lplate VARCHAR(50)
AS
	IF @Lplate <= (SELECT licencePlate FROM Bus WHERE licencePlate = @Lplate)
		BEGIN
			SELECT licencePlate, capacity, size, typeBusId, routeId
			FROM Bus
			WHERE licencePlate = @Lplate
		END
	ELSE
		BEGIN
			PRINT('----------------------------------------------------------------------');
			PRINT(' THE RECORD ID DOESNT EXIST INTO THE DB, CHECK YOUR DATA BEFORE RETRY ');
			PRINT('----------------------------------------------------------------------');
		END
GO