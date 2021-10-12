/* ---- DDL QUERY BUS ---- */
CREATE DATABASE Bus;
go
USE Bus;
go
/* Route table */
CREATE TABLE [Route] (

	Id INT Identity(1,1),
	[name] VARCHAR(50),
	[description] VARCHAR(100),
	PRIMARY KEY(Id)

);
go
/* Journey table */
CREATE TABLE Journey (
	
	Id INT Identity(1,1),
	[name] VARCHAR(50),
	PRIMARY KEY(Id)

);
go
/* RouteJourney table */
CREATE TABLE RouteJourney (
	
	routeId INT,
	journeyId INT,
	PRIMARY KEY(routeId,journeyId),
	FOREIGN KEY(routeId) REFERENCES [Route](Id),
	FOREIGN KEY(journeyId) REFERENCES Journey(Id)

);
go
/* RouteLog table */
CREATE TABLE RouteLog (
	
	Id INT Identity(1,1),
	passAverage INT,
	[date] DATE,
	routeId INT,
	PRIMARY KEY(Id),
	FOREIGN KEY(routeId) REFERENCES [Route](Id)

);
go
/* Town table */
CREATE TABLE Town (
	
	Id INT Identity(1,1),
	[name] VARCHAR(50),
	PRIMARY KEY(Id),
	
);
go
/* Garage table */
CREATE TABLE Garage (
	
	Id INT Identity(1,1),
	[name] VARCHAR(50),
	capacity INT,
	townId INT,
	PRIMARY KEY(Id),
	FOREIGN KEY(townId) REFERENCES Town(Id)

);
go
/* JourneyTown table */
CREATE TABLE JourneyTown (
	
	townId INT,
	journeyId INT,
	PRIMARY KEY(townId,journeyId),
	FOREIGN KEY(townId) REFERENCES Town(Id),
	FOREIGN KEY(journeyId) REFERENCES Journey(Id),

);
go
/* Driver table */
CREATE TABLE Driver (
	
	Id INT Identity(1,1),
	[name] VARCHAR(50),
	[address] VARCHAR(100),
	telephone VARCHAR(50),
	journeyId INT,
	PRIMARY KEY(Id),
	FOREIGN KEY(journeyId) REFERENCES Journey(Id)

);
go
/* TypeBus table */
CREATE TABLE TypeBus (
	
	Id INT Identity(1,1),
	[description] VARCHAR(100),
	PRIMARY KEY(ID)

);
go
/* Bus table */
CREATE TABLE Bus (
	
	licencePlate VARCHAR(50),
	capacity INT,
	size VARCHAR(50),
	typeBusId INT,
	routeId INT,
	PRIMARY KEY(licencePlate),
	FOREIGN KEY(typeBusId) REFERENCES TypeBus(Id),
	FOREIGN KEY(routeId) REFERENCES [Route](Id)

);
