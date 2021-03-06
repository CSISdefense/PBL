USE [DIIG]
GO
/****** Object:  View [Project].[CSIScontractIDwithMultipleProjectIDs]    Script Date: 3/13/2017 2:37:17 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO





CREATE VIEW [Project].[CSIScontractIDwithMultipleProjectIDs]
AS

SELECT [ProjectID]
      ,[ProjectName]
      ,[ProjectAbbreviation]
      ,[UnmodifiedSystemEquipmentCode]
      ,idse.[CSIScontractID]
      ,[LastUltimateCompletionDate]
      ,[MinofsignedDate]
  FROM (select Interior.CSIScontractID
from (SELECT [ProjectID]
      ,[ProjectName]
      ,[ProjectAbbreviation]
      ,[UnmodifiedSystemEquipmentCode]
      ,[CSIScontractID]
      ,[LastUltimateCompletionDate]
      ,[MinofsignedDate]
  FROM [DIIG].[Project].[CSIScontractIDforIdentifiedSystemEquipment]
  where projectid is not null) as Interior 
  group by Interior.CSIScontractID
  having count(projectID) >1) as DuplicateList
  inner join [DIIG].[Project].[CSIScontractIDforIdentifiedSystemEquipment] idse
  on idse.csiscontractid =duplicatelist.CsisContractID 




GO
