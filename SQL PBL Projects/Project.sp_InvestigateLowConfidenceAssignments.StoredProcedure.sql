USE [DIIG]
GO
/****** Object:  StoredProcedure [Project].[sp_InvestigateLowConfidenceAssignments]    Script Date: 3/13/2017 2:37:17 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



-- =============================================
-- Author:		Greg Sanders
-- Create date: 2013-03-13
-- Description:	Assign a parent ID to a dunsnumber for a range of years
-- =============================================
CREATE  PROCEDURE [Project].[sp_InvestigateLowConfidenceAssignments]
	-- Add the parameters for the stored procedure here
	--@systemequipmentcodetext nvarchar(255)

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	SELECT s.[IDVPIID]
	  ,s.[PIID]
	  ,f.modnumber
	  ,cid.CSISidvpiidID
	  ,tid.CSIScontractID
	  ,tid.csistransactionid 
      ,[Comments]
      ,s.[PrimaryProjectID]
	  ,p.projectname
      ,s.[ContractLabelID]
	  ,psc.productorservicearea
	  ,psc.ProductOrServiceCodeText
	  ,cpc.ClaimantProgramCodeText
	  ,isnull(cpc.PlatformPortfolio,psc.PlatformPortfolio) as PlatformPortfolio
	  ,f.descriptionofcontractrequirement
	  --,count(tid.csistransactionid  )
	  --,sum(f.obligatedamount)
	  --,sum(f.numberofactions)
	  
	  ,f.obligatedamount
	  ,f.numberofactions
  FROM contract.fpds f
  inner join contract.csistransactionid  tid
  on f.csistransactionid=tid.csistransactionid
  inner join contract.CSIScontractID cid
  on tid.csiscontractid=cid.csiscontractid
  inner join [Contract].[ContractIDtoSystemEquipmentCodeWeak] s
  on cid.piid=s.piid and cid.idvpiid=s.idvpiid
  inner join project.projectid p
  on s.PrimaryProjectID=p.projectid
  inner join fpdstypetable.productorservicecode psc
  on f.productorservicecode = psc.productorservicecode
  inner join fpdstypetable.claimantprogramcode cpc
  on f.claimantprogramcode = cpc.claimantprogramcode 
  --group by s.[IDVPIID]
	 -- ,s.[PIID]
  --    ,[Comments]
  --    ,s.[PrimaryProjectID]
	 -- ,p.projectname
  --    ,s.[ContractLabelID]
  order by contractlabelid, idvpiid, piid, f.modnumber

	--if @systemequipmentcodetext is null
	--	raiserror('The value for @systemequipmentcodetext should not be null.',15,1)

	--	--Verify that the parameter is already in the relevant type table.
	--if(select p.systemequipmentcodeText
	--	from FPDSTypeTable.systemequipmentcode as p
	--	where p.systemequipmentcodeText=@systemequipmentcodetext) is null 
	--begin
	--	--If there's a similar value to the missing one, suggest that instead.
	--	if (select top 1 p.systemequipmentcodeText
	--			from FPDSTypeTable.systemequipmentcode as p
	--			where p.systemequipmentcodeText like '%'+@systemequipmentcodetext+'%') is not null 
	--	begin
	--		select  p.systemequipmentcodeText
	--			from FPDSTypeTable.systemequipmentcode as p
	--			where p.systemequipmentcodeText like '%'+@systemequipmentcodetext+'%'
	--		select 'The value for @systemequipmentcodetext is not found in FPDSTypeTable.systemequipmentcode. Did you mean one of the above?' as ErrorDescription
	--		return -1
	--	end
	--	--If there's no similar value, return an error, they'll have to check the table themselves.
	--	else
	--	begin
	--			select s.systemequipmentcodeText
	--			, s.systemequipmentcode
	--from FPDSTypeTable.systemequipmentcode as s
	--order by s.systemequipmentcodeText
	----where [systemequipmentcodeText] =@systemequipmentcodetext

	--		select 'The value for @systemequipmentcodetext is not found in FPDSTypeTable.systemequipmentcode. Above is a complete listing' as ErrorDescription
			
	--		--raiserror('The value for @systemequipmentcodetext is not found in FPDSTypeTable.systemequipmentcode.',15,1)
	--	end
	--end
	----End input protection

	--else
	--begin


	--select *
	--from FPDSTypeTable.systemequipmentcode as s
	--where [systemequipmentcodeText] =@systemequipmentcodetext

	--SELECT [systemequipmentcodeText]
 --     ,[Customer]
 --     ,[ServicesCategory]
 --     ,[SumOfobligatedAmount]
 --     ,[SumOfnumberOfActions]
 --     ,[SumOfbaseandexercisedoptionsvalue]
 --     ,[SumOfbaseandalloptionsvalue]
 -- FROM [DIIG].[SystemEquipment].[SystemEquipmentHistoryBucketCustomer]
	--where [systemequipmentcodeText] =@systemequipmentcodetext

 
 --end


END

















GO
