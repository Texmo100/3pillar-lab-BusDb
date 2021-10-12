/* ---------------- TEST QUERY BUS ---------------- */
USE Bus

GO

/* -------- ROUTE -------- */

/* ----  INSERT ---- */
EXECUTE InsertRoute 'columbus', 'nigth city to Dallas'

/* ---- UPDATE ---- */
EXECUTE UpdateRoute 33, 'columbus', 'night city'

/* ---- DELETE ---- */
EXECUTE DeleteRoute 8

/* ---- SELECT ----- */
EXECUTE SelectRoute 26


GO
/* -------- JOURNEY -------- */

/* ----  INSERT ---- */
EXECUTE InsertJourney 'Rafalos Journey'

/* ---- UPDATE ---- */
EXECUTE UpdateJourney 27, 'Galagos Journey'

/* ---- DELETE ---- */
EXECUTE DeleteJourney 27

/* ---- SELECT ----- */
EXECUTE SelectJourney 27


GO
/* -------- ROUTE JOURNEY -------- */


/* ---- INSERT ---- */
EXECUTE InsertRouteJourney 2, 6

/* ---- UPDATE (THE FIRST TWO PARAMETERS ARE THE TARGET RECORD ID, THEREFORE THE LAST TWO PARAMETERS ARE THE VALUES WHAT YOU WANT TO UPDATE OR CHANGE) ---- */
/* EXAMPLE: UpdateRouteJourney 2,6,2,25 */
EXECUTE UpdateRouteJourney 2,6,2,25

/* ---- DELETE ----- */
EXECUTE DeleteRouteJourney 2,25

/* ---- SELECT ---- */
EXECUTE SelectRouteJourney 2, 2


GO
/* -------- ROUTE LOG -------- */


/* ---- INSERT ---- */
EXECUTE InsertRouteLog 30, '10-11-2021', 5

/* ---- UPDATE ---- */
EXECUTE UpdateRouteLog 27, 31, '10-11-2021', 34

/* ----  DELETE ---- */
EXECUTE DeleteRouteLog 27

/* ---- SELECT ---- */
EXECUTE SelectRouteLog 26



GO
/* -------- TOWN -------- */

/* ---- INSERT ---- */
EXECUTE InsertTown 'Rondow town'

/* ---- UPDATE ---- */
EXECUTE UpdateTown 27, 'Glass town'

/* ---- DELETE ---- */
EXECUTE DeleteTown 27

/* ---- SELECT ---- */
EXECUTE SelectTown 26



GO
/* -------- GARAGE -------- */


/* ---- INSERT ---- */
EXECUTE InsertGarage 'Valerias garage', 24, 26

/* ---- UPDATE ---- */
EXECUTE UpdateGarage 26, 'Valerys garage', 24, 26

/* ---- DELETE ---- */
EXECUTE DeleteGarage 26

/* ---- SELECT ---- */
EXECUTE SelectGarage 25



GO
/* -------- JOURNEY TOWN -------- */

/* ---- INSERT ---- */
EXECUTE InsertJourneyTown 20,6

/* ---- UPDATE (THE FIRST TWO PARAMETERS ARE THE TARGET RECORD ID, THEREFORE THE LAST TWO PARAMETERS ARE THE VALUES WHAT YOU WANT TO UPDATE OR CHANGE) ---- */
/* EXAMPLE: UpdateJourneyTown 20,6,20,5 */
EXECUTE UpdateJourneyTown 20,6,20,5

/* ---- DELETE ---- */
EXECUTE DeleteJourneyTown 20,5

/* ---- SELECT ---- */
EXECUTE SelectJourneyTown 20,20

GO
/* -------- DRIVER -------- */

/* ---- INSERT ---- */
EXECUTE InsertDriver 'Charles', 'rondon town #21', '6621903456', 28

/* ---- UPDATE ----- */
EXECUTE UpdateDriver 26,'Charles Darwin', 'rondon town #21', '6621903456', 28

/* ---- DELETE ---- */
EXECUTE DeleteDriver 26

/* ---- SELECT ---- */
EXECUTE SelectDriver 25


GO
/* -------- TYPEBUS -------- */

/* ---- INSERT ---- */
EXECUTE InsertTypeBus 'SUPER BUS'

/* ---- UPDATE ---- */
EXECUTE UpdateTypeBus 11, 'ULTRA BUS'

/* ---- DELETE ---- */
EXECUTE DeleteTypeBus 11

/* ---- SELECT ---- */
EXECUTE SelectTypeBus 10


GO
/* -------- BUS -------- */

/* ---- INSERT ---- */
EXECUTE InsertBus 'Y3890-YYY', 90, 'small', 10, 35

/*  ---- UPDATE ---- */
EXECUTE UpdateBus 'YBTU-289', 90, 'HUGE', 10, 35

/* ---- DELETE ---- */
EXECUTE DeleteBus 'YBTU-289'

/* ---- SELECT ---- */
EXECUTE SelectBus 'YBTU-289'


