USE [DIIG]
GO
/****** Object:  View [Project].[VehicleHistoryBucketProjectSubCustomerClassification]    Script Date: 3/13/2017 2:37:17 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO








CREATE VIEW [Project].[VehicleHistoryBucketProjectSubCustomerClassification]
AS
select 
	fiscal_year
	,Customer
	,ServicesCategory
	,IsService
	 ,iif(addmodified=1 and ismodified=1,'Modified ','')+
		case
			when addmultipleorsingawardidc=1 
			then case 
				when multipleorsingleawardidc is null
				then 'Unlabeled '+AwardOrIDVcontractactiontype
				else multipleorsingleawardidc+' '+AwardOrIDVcontractactiontype
				--Blank multipleorsingleawardIDC
			end
			else AwardOrIDVcontractactiontype 
	end		as VehicleClassification
	,sum(SumOfobligatedAmount) as SumOfobligatedAmount
	,sum(SumOfnumberOfActions) as SumOfnumberOfActions
FROM SystemEquipment.VehicleHistoryBucketSubCustomerPartial
group by 
	fiscal_year
	,Customer
	,ServicesCategory
	,IsService
	 ,iif(addmodified=1 and ismodified=1,'Modified ','')+
		case
			when addmultipleorsingawardidc=1 
			then case 
				when multipleorsingleawardidc is null
				then 'Unlabeled '+AwardOrIDVcontractactiontype
				else multipleorsingleawardidc+' '+AwardOrIDVcontractactiontype
				--Blank multipleorsingleawardIDC
			end
			else AwardOrIDVcontractactiontype 
	end	









GO
