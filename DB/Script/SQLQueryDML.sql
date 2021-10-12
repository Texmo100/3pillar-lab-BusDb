/* ---- DML QUERY BUS ---- */
USE [Bus]
GO

/* INSERT INTO TOWN TABLE */
INSERT INTO [dbo].[Town]
           ([name])
     VALUES
			('Waverly'),
			('Riverside'),
			('Oakland'),
			('Kingston'),
			('Dayland'),
			('Carrozzeria Viotti'),
			('Stabilimento'),
			('Basso'),
			('Bottega Veneta'),
			('Artsana'),
			('Dahlonega'),
			('Taos'),
			('Stowe'),
			('Clinton'),
			('Cooperstown'),
			('Fresno'),
			('Anaheim'), 
			('Berkeley'),
			('Irvine'),
			('Santa Clara'),
			('randam'),
			('trampisko'),
			('dolthem'),
			('furu'),
			('binsu');

GO

/* INSERT INTO GARAGE TABLE */
INSERT INTO [dbo].[Garage]
           ([Name]
           ,[capacity]
           ,[townId])
     VALUES
			('Lucy`s Garage', 8, 1),
			('Cars', 20, 2),
			('Super Lot', 30, 3),
			('Car Farm', 16, 4),
			('Parker', 20, 5),
			('Rialto Garage', 15, 6),
			('Ponte Rosso Garage', 10, 7),
			('Doge Garage', 20, 8),
			('La Spezia Garage', 8, 7),
			('Perugia Garage', 10, 9),
			('Star Garage', 15, 12),
			('Rusell Garage', 11, 13),
			('Jey`s Garage', 13, 14),
			('Jhon`s Garage', 13, 14),
			('Cristal Garage', 13, 14),
			('North Garage',10,16),
			('Louisa`s Garage',20,11),
			('Mars Garage', 20, 1),
			('Dio Garage', 20, 5),
			('Jhonathan Garage', 10, 15),
			('roys garage', 13, 2),
			('laras garage', 16, 11),
			('hans garage', 12, 15),
			('davids garage', 10, 2),
			('jorges garage', 14, 22);

GO

/* INSERT INTO TYPEBUS TABLE */
INSERT INTO [dbo].[TypeBus]
           ([description])
     VALUES
			('Single deck'),
			('Double deck'),
			('Triple deck'),
			('VIP'),
			('Basic'),
			('Classic'),
			('Vintage'),
			('Modern'),
			('Classic VIP'),
			('Vintage VIP');
GO

/* INSERT INTO ROUTE TABLE */
INSERT INTO [dbo].[Route]
           ([name]
           ,[description])
     VALUES
			('Route 10', 'From Waverly to Oakland'),
			('Route 15', 'From Riverside to Kingston'),
			('Route 13', 'From Waverly to Riverside'),
			('Route 30', 'From Oakland to Dayland'),
			('Route 50', 'From Kingston to Dayland'),
			('Route 53', 'From Riverside to Basso'),
			('Route 17', 'From Artsana to Basso'),
			('Route 22', 'From Basso to Stabilimento'),
			('Route 31', 'From Basso to Bottega Veneta'),
			('Route 40', 'From Artsana to Carrozzeria Viotti'),
			('Route 25', 'From Bottega Veneta to Carrozzeria Viotti'),
			('Route 101', 'From Dahlonega to Carrozzeria Viotti'),
			('Route 55', 'From Dahlonega to  Taos'),
			('Route 35', 'From Cooperstown to Clinton'),
			('Route 05', 'From Taos to Dayland'),
			('Route 69', 'From Stabilimento to Riverside'),
			('Ruote 47', 'From Fresno to Anaheim'),
			('Ruote 43','From Berkeley to Basso'),
			('Route 100','From Irvine to Santa Clara'),
			('Ruote 02','From Berkeley to Oakland'),
			('Route 27','From Irvine to Dayland'),
			('Route 120', 'From red flame to landscape'),
			('Route 121','From water fall island to western jr'),
			('Route 122','From grand canion to cranston'),
			('Route 123','From ratland to low-thor'),
			('Route 124','From california to miami');

GO

/* INSERT INTO JOURNEY TABLE */
INSERT INTO [dbo].[Journey]
           ([name])
     VALUES
			('Waverly-Riverside'),
			('Riverside-Oakland'),
			('Oakland-Kingston'),
			('Kingston-Dayland'),
			('Waverly-Riverside-Oakland'),
			('Kingston-Basso'),
			('Basso-Bottega Veneta'),
			('Waverly-Artsana'),
			('Stabilimento-Riverside-Basso'),
			('Basso-Dayland-Oakland'),
			('Stabilimento-Riverside'),
			('Bottega Veneta-Dayland-Waverly'),
			('Stabilimento-Dayland-Basso'),
			('Taos-Riverside'),
			('Kingston- Carrozzeria Viotti'),
			('Freno-Anaheim'),
			('Berkeley-Basso'),
			('Irvine-SantaClara'),
			('Berkely-Oakland'),
			('Irvine-Dayland'),
			('Cranston-ray'),
			('bus-torn'),
			('water-cloud'),
			('Clinton-land'),
			('Forest-gum');
GO

/* INSERT INTO ROUTE JOURNEY TABLE */
INSERT INTO [dbo].[RouteJourney]
           (routeId
           ,journeyId)
     VALUES
			(1,1),
			(1,2),
			(1,5),
			(2,2),
			(2,3),
			(3,1),
			(4,3),
			(4,4),
			(5,4),
			(16, 11),
			(13, 12),
			(11, 10),
			(15, 14),
			(14, 13),
			(17,6),
			(18,8),
			(19,9),
			(20,3),
			(12,4),
			(10,5),
			(20,8),
			(14,1),
			(25,3),
			(13,4);

GO

/* INSERT INTO JOURNEY TOWN TABLE */
INSERT INTO [dbo].[JourneyTown]
           (townId
           ,journeyId)
     VALUES
			(1,1),
			(1,5),
			(2,1),
			(2,2),
			(2,5),
			(3,2),
			(3,3),
			(4,3),
			(4,4),
			(5,4), 
			(11,11),
			(12,15),
			(13,12),
			(15,13),
			(14,14),
			(16,16),
			(17,17),
			(18,18),
			(19,19),
			(20,20),
			(20,14),
			(13,2),
			(10,15),
			(12,13),
			(11,15);

GO

/* INSERT INTO DRIVER TABLE */
INSERT INTO [dbo].[Driver]
           ([name]
           ,[address]
           ,[telephone]
           ,journeyId)
     VALUES
            ('Jose Perez', 'R St. 123', '585-5674', 1),
			('Mike H.', 'Ju Ave. 4', '435-9342', 2),
			('Luis X.', 'Las UT. 128', '364-0786', 3),
			('Sam Y.', 'Kuh 54', '585-3701', 4),
			('Fer I.', 'Pul St. 02', '585-1958', 5),
			('Giorno', 'Via del Corso #200', '352-14789', 6),
			('Guido', 'La Mercerie #5061', '152-47845', 7),
			('Luigi', 'Via Rizzoli #104', '198-45680', 7),
			('Mariella', 'Siena #34-B', '123-45678', 8),
			('Stella', 'Pescara #1057', '999-57420', 9),
			('Jhon', 'MO Ave. 7', '888-563', 11),
			('Michelle', 'KO Ave. 4', '555-589', 15),
			('Rogelio', 'Curt #556', '235-129', 12),
			('Jesus', 'LOL St. 11', '263-874', 13),
			('Evelyn', 'Dos St. 489', '647-545', 14),
			('Dimitier', 'German St. 124', '999-952679' ,16),
			('Nebraka', 'Lucas Ave. 152', '55-39526791' ,17),	
			('Dimitri', 'Pul St. 08', '999-952672', 18),
			('Svetlana', 'Maria Ave. 123', '55-526793', 19),
			('Vladimir', 'Main Ave. 01', '999-526794', 20),
			('adam', 'jordon 21', '1291902156', 15),
			('aaron', 'random 56', '1291902159', 4),
			('lara', 'fibes 104', '1291902134', 19),
			('zara', 'rothom 34', '1291902121', 15),
			('michael', 'mentos 89', '1291902167', 1);


GO

/* INSERT INTO ROUTE LOG TABLE */
INSERT INTO [dbo].[RouteLog]
           ([passAverage]
           ,[date]
           ,routeId)
     VALUES
	 		(15,'07-01-2021',6),
		   	(30,'07-15-2021',7),
		   	(17,'07-30-2021',8),
		   	(28,'08-16-2021',9),
		   	(15,'08-31-2021',4),
		   	(30, '09-10-2021', 1),
		   	(40, '09-10-2021', 2),
		   	(35, '09-11-2021', 3),
		   	(25, '09-12-2021', 4),
		   	(70, '09-13-2021', 5), 
			(50, '12-24-2021', 15),
			(35, '02-03-2021', 11),
			(60, '08-30-2021', 12),
			(33, '10-27-2021', 13),
			(46, '04-07-2021', 14),
			(49, '01-27-2021', 16),
			(36, '10-20-2021', 17),
			(50, '07-16-2021', 18),
			(60, '09-08-2021', 19),
			(40, '11-03-2021', 20),
			(35,'09-10-2021',15),
		    (25,'09-11-2021',4),
			(26,'09-12-2021',13),
			(27,'09-13-2021',12),
			(30,'09-14-2021',11);

GO

/* INSERT INTO BUS TABLE */
INSERT INTO [dbo].[Bus]
           ([licencePlate]
           ,[capacity]
           ,[size]
           ,typeBusId
           ,routeId)
     VALUES
			('B12-KU78' , 40, 'Medium', 1, 1),
		   	('B08-HV4' , 80, 'Big', 2, 2),
		   	('B2-NH2' , 120, 'Huge', 3, 3),
		   	('B83-LQ9' , 15, 'Small', 4, 4),
		   	('B02-WH43' , 25, 'Small', 5, 5),
		   	('C12-KT76' , 45, 'Medium', 1, 6),
		   	('C18-HV3' , 75, 'Big', 2, 7),
		   	('C51-NH2A' , 110, 'Huge', 3, 8),
		   	('C89-LMQ9' , 18, 'Small', 4, 9),
		   	('C52-WT43' , 22, 'Small', 5, 10), 
		   	('M09-HT90' , 100, 'Big', 5, 16),
		   	('T09-GG0' , 110, 'Big', 2, 11),
		   	('UY7-523' , 20, 'Small', 5, 13),
		   	('PI8-F32' , 50, 'Medium', 1, 14), 
		   	('KKL-896' , 50, 'Medium', 1, 12),
		   	('AFC-N21', 20, 'Small',1, 17),
		   	('ABD-K19', 60, 'Big', 2, 18),
		   	('NDM-ZH7', 10, 'Huge', 3, 19),
		   	('HGF-S22', 40, 'Meium', 4, 20),
		   	('RHT-MF8', 20, 'Big', 5, 21),
			('RHT-MF4', 44, 'Medium', 5, 5),
			('RHT-MN5', 44, 'Medium', 7, 6),
			('M09-HT95', 44, 'Medium', 8, 11),
			('RHT-MK9', 44, 'Medium', 3, 19),
			('B02-WH56', 44, 'Medium', 6, 17);

GO






