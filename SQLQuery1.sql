DECLARE    @URL AS NVARCHAR(4000)= 'https://raw.githubusercontent.com/ozanerturk/covid19-turkey-api/master/dataset/timeline.json'
 
	DECLARE @status int
	DECLARE @responseText as table(responseText nvarchar(max))
	DECLARE @res as Int;
	DECLARE @JSON AS NVARCHAR(MAX)

	EXEC sp_OACreate 'MSXML2.ServerXMLHTTP', @res OUT
	EXEC sp_OAMethod @res, 'open', NULL, 'GET',@url,'false'
	EXEC sp_OAMethod @res, 'send'
	EXEC sp_OAGetProperty @res, 'status', @status OUT
	INSERT INTO @ResponseText (ResponseText) EXEC sp_OAGetProperty @res, 'responseText'
	EXEC sp_OADestroy @res
	SELECT  @JSON=CONVERT(NVARCHAR(MAX),responseText)   FROM @responseText 

	INSERT INTO COVIDDATATR
	([DATE_], [TotalTests], [totalPatients], [totalDeaths], [totalIntensiveCare], [totalIntubated], [totalRecovered], [tests], [cases], [patients], [critical_], [pneumoniaPercent], [deaths], [recovered])
	/* TÜM BÝLGÝLERÝ KALICI TABLOYA ATAN FONKSÝYON */
SELECT 
	JSON_VALUE(VALUE,'$.date') AS DATE_,
	JSON_VALUE(VALUE,'$.totalTests') AS totalTests,
	JSON_VALUE(VALUE,'$.totalPatients') AS totalPatients,
	JSON_VALUE(VALUE,'$.totalDeaths') AS totalDeaths,
	JSON_VALUE(VALUE,'$.totalIntensiveCare') AS totalIntensiveCare,
	JSON_VALUE(VALUE,'$.totalIntubated') AS totalIntubated,
	JSON_VALUE(VALUE,'$.totalRecovered') AS totalRecovered,
	JSON_VALUE(VALUE,'$.tests') tests,
	JSON_VALUE(VALUE,'$.cases') cases,
	JSON_VALUE(VALUE,'$.patients') patients,
	JSON_VALUE(VALUE,'$.critical') critical_,
	JSON_VALUE(VALUE,'$.pneumoniaPercent') pneumoniaPercent,
	JSON_VALUE(VALUE,'$.deaths') deaths,
	JSON_VALUE(VALUE,'$.recovered') recovered
	

  FROM OPENJSON (@JSON) 

  /*SELECT * FROM [dbo].[COVIDDATATR]
  ORDER BY id DESC
  TRUNCATE TABLE [dbo].[COVIDDATATR]*/