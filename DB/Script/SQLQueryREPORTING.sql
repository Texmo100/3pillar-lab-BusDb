/* ---- REPORTING QUERY BUS ---- */
USE Bus

GO
-- 1: How many drivers per journey there are?
CREATE VIEW DriversJourneyCounter
AS
	SELECT j.[name], COUNT(d.ID) AS numberDrivers 
	FROM journey j
	JOIN Driver d
	ON j.ID = d.journeyId
	GROUP BY j.[name]

GO


-- 2: How many garages per town there are?
CREATE VIEW GarageTownCounter
AS
	SELECT t.[name], COUNT(g.ID) AS numberGarages 
	FROM Town t
	JOIN Garage g
	ON t.ID = g.townId
	GROUP BY t.[name]

GO


-- 3: How many busses per route there are?
CREATE VIEW BusRouteCounter
AS
	SELECT r.[name], COUNT(b.licencePlate) AS numberBusses 
	FROM [Route] r
	JOIN Bus b
	ON r.ID = b.routeId
	GROUP BY r.[name]

GO

-- 4: How many double deck busses there are?
CREATE VIEW DoubleDeckBusCounter
AS
	SELECT  TB.[description], COUNT(B.licencePlate) AS busses 
	FROM TypeBus TB
	JOIN Bus B
	ON TB.ID = typeBusId
	WHERE TB.Description = 'Double deck'
	GROUP BY TB.Description

GO

-- 5: How many VIP busses per route there are?
CREATE VIEW VipBusRouteCounter
AS
	SELECT R.[NAME], COUNT(B.typeBusId) AS vipBusses 
	FROM [Route] R
	JOIN Bus B
	ON R.ID = B.routeId
	WHERE B.typeBusId = 4
	GROUP BY R.[Name]

GO

-- 6: How many Classic busses per route there are?
CREATE VIEW ClassicBusRouteCounter
AS
	SELECT R.[NAME], COUNT(B.typeBusId) AS classicBusses 
	FROM [Route] R
	JOIN Bus B
	ON R.ID = B.routeId
	WHERE B.typeBusId = 6
	GROUP BY R.[Name]

GO

-- 7: How many routes passes through Irvine?
CREATE VIEW RouteIrvine
AS
	SELECT R.[Name], R.[Description] 
	FROM [Route] R
	WHERE [Description]
	LIKE '%Irvine%'

GO

-- 8: What is the passenger's average per route?
CREATE VIEW PassAverageRouteCounter
AS
	SELECT R.[NAME], RL.passAverage 
	FROM [Route] R
	JOIN RouteLog RL
	ON R.ID = RL.routeId

GO

-- 9: Which are the routes who have more than one route log? Display the route's name and number of logs
CREATE VIEW ActiveRoute
AS
	SELECT R.[NAME], COUNT(RL.routeId) AS logs 
	FROM [Route] R
	JOIN RouteLog RL
	ON R.ID = RL.routeId
	GROUP BY R.[Name]
	HAVING COUNT(RL.routeId) > 1

GO

-- 10: Which are the routes who only have one route log? Display the route's name, passengers average and date
CREATE VIEW InactiveRoute
AS
	SELECT R.[NAME], RL.passAverage, RL.[Date], COUNT(RL.routeId) AS logs 
	FROM [Route] R
	JOIN RouteLog RL
	ON R.ID = RL.routeId
	GROUP BY R.[NAME], RL.passAverage, RL.[Date]
	HAVING COUNT(RL.routeId) = 1

GO

-- 11: What is the most popular journey? Considering the routes per journey, display journey's name and number of routes
CREATE VIEW PopularJourney
AS
	SELECT J.[NAME] AS journeyName, COUNT(RJ.journeyId) AS numberRoutes
	FROM Journey J
	JOIN RouteJourney RJ
	ON J.ID = RJ.journeyId
	GROUP BY J.[NAME]
	HAVING COUNT(RJ.journeyId) > 3

GO

-- 12: What is the less popular journey? Considering the routes per journey, display journey's name and the number of times that appears
CREATE VIEW LessPopularJourney
AS
	SELECT J.[NAME] AS journeyName, COUNT(RJ.journeyId) AS numberRoutes
	FROM Journey J
	JOIN RouteJourney RJ
	ON J.ID = RJ.journeyId
	GROUP BY J.[NAME]
	HAVING COUNT(RJ.journeyId) < 2

GO

-- 13: Which is the most popular journey bus? Display the bus name and number of times the bus appears in journey
CREATE VIEW PopularBusJourney
AS
	SELECT B.licencePlate, COUNT(RJ.journeyId) AS journeys
	FROM Bus B
	JOIN [Route] R
	ON B.routeId = R.ID
	JOIN RouteJourney RJ
	ON R.ID = RJ.routeId
	GROUP BY B.licencePlate
	HAVING COUNT(RJ.journeyId) > 2

GO

-- 14: What is the most popular journey town? Display town's name and the number of times that appears per journey
CREATE VIEW PopularJourneyTown
AS
	SELECT T.[NAME], COUNT(JT.journeyId) AS journeys
	FROM Town T
	JOIN JourneyTown JT
	ON T.ID = JT.townId
	GROUP BY T.[NAME]
	HAVING COUNT(JT.journeyId) > 2

GO

-- 15: Which is the biggest garage? Display the garage's name and town's name that belongs to
CREATE VIEW BigGarage
AS
	SELECT G.[Name] AS garageName, G.Capacity, T.[Name] AS townName
	FROM Garage G
	JOIN Town T
	ON G.townId = T.ID
	WHERE G.Capacity > 20

GO