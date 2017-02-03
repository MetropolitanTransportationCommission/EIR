select
Distinct  
FID_Counties,
FID_TPAs,
FID_Alt,
COUNTYNAME,
CountyFIP,
parcel_id,
Estimated_Population,
total_residential_units,
total_job_spaces,
Acres,
People_Per_Acre,
Jobs_Per_Acre
from UrbanSim.COUNTIES_TPAS_ALT_4_OVERLAY
Order By parcel_id
Go
create view UrbanSim.Alt_4_Counties_TPAs_Density as
SELECT  Top 50000      UrbanSim.COUNTIES_TPAS_ALT_4_OVERLAY.FID_Counties, UrbanSim.COUNTIES_TPAS_ALT_4_OVERLAY.FID_TPAs, 
                         UrbanSim.COUNTIES_TPAS_ALT_4_OVERLAY.COUNTYNAME, UrbanSim.COUNTIES_TPAS_ALT_4_OVERLAY.CountyFIP, 
                         UrbanSim.COUNTIES_TPAS_ALT_4_OVERLAY.parcel_id, MAX(UrbanSim.COUNTIES_TPAS_ALT_4_OVERLAY.Estimated_Population) AS Estimated_Population,
                          MAX(UrbanSim.COUNTIES_TPAS_ALT_4_OVERLAY.total_residential_units) AS total_residential_units, 
                         MAX(UrbanSim.COUNTIES_TPAS_ALT_4_OVERLAY.total_job_spaces) AS total_job_spaces, MAX(UrbanSim.COUNTIES_TPAS_ALT_4_OVERLAY.Acres) 
                         AS Acres, MAX(UrbanSim.COUNTIES_TPAS_ALT_4_OVERLAY.People_Per_Acre) AS People_Per_Acre, 
                         MAX(UrbanSim.COUNTIES_TPAS_ALT_4_OVERLAY.Jobs_Per_Acre) AS Jobs_Per_Acre, UrbanSim.Dup_GrowthParcels.Total_Dups
FROM            UrbanSim.COUNTIES_TPAS_ALT_4_OVERLAY LEFT OUTER JOIN
                         UrbanSim.Dup_GrowthParcels ON UrbanSim.COUNTIES_TPAS_ALT_4_OVERLAY.parcel_id = UrbanSim.Dup_GrowthParcels.parcel_id
GROUP BY UrbanSim.COUNTIES_TPAS_ALT_4_OVERLAY.FID_Counties, UrbanSim.COUNTIES_TPAS_ALT_4_OVERLAY.FID_TPAs, 
                         UrbanSim.COUNTIES_TPAS_ALT_4_OVERLAY.COUNTYNAME, UrbanSim.COUNTIES_TPAS_ALT_4_OVERLAY.CountyFIP, 
                         UrbanSim.COUNTIES_TPAS_ALT_4_OVERLAY.parcel_id, UrbanSim.Dup_GrowthParcels.Total_Dups
HAVING        (UrbanSim.COUNTIES_TPAS_ALT_4_OVERLAY.FID_TPAs = 1) AND (UrbanSim.Dup_GrowthParcels.Total_Dups > 1)
ORDER BY UrbanSim.COUNTIES_TPAS_ALT_4_OVERLAY.parcel_id
Go
--Drop view UrbanSim.Dup_GrowthParcels 
create view UrbanSim.Dup_GrowthParcels as
SELECT        parcel_id, COUNT(parcel_id) AS Total_Dups
FROM            UrbanSim.COUNTIES_TPAS_ALT_4_OVERLAY
GROUP BY parcel_id
HAVING        (COUNT(parcel_id) > 1)
ORDER BY Total_Dups DESC

--Need to fix parcels that cross county borders. The list below identifies those parcels that cross county borders.  This occurs due to the differences in the geometry between the parcel dataset and the TomTom Basemap County boundaries.
--There are 10 parcels that fit this condition.
SELECT        parcel_id, COUNT(parcel_id) AS Total_Dups
FROM            UrbanSim.Alt_4_Counties_TPAs_Density
GROUP BY parcel_id
HAVING        (COUNT(parcel_id) > 1)
ORDER BY Total_Dups DESC

select * From UrbanSim.Alt_4_Counties_TPAs_Density
Where parcel_id = '1019099'

--create a view that removes the duplicates

CREATE VIEW UrbanSim.Alt_4_Counties_TPAs_Density_NoDups AS
select * FROM UrbanSim.Alt_4_Counties_TPAs_Density 
WHERE NOT 
( (PARCEL_ID = 389059 AND countyFIP <> 1) OR
	(PARCEL_ID = 389065 AND countyFIP <> 1) OR
	(PARCEL_ID = 728181 AND countyFIP <> 13)  OR
	(PARCEL_ID = 729197 AND countyFIP <> 13)  OR
	(PARCEL_ID = 1019099 AND countyFIP <> 75)  OR
	(PARCEL_ID = 1038093 AND countyFIP <> 81)  OR
	(PARCEL_ID = 1050874 AND countyFIP <> 81)  OR
	(PARCEL_ID = 1196423 AND countyFIP <> 81)  OR
	(PARCEL_ID = 1311949 AND countyFIP <> 85)  OR
	(PARCEL_ID = 1311950 AND countyFIP <> 85) )