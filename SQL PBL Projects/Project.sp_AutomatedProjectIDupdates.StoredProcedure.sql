USE [DIIG]
GO
/****** Object:  StoredProcedure [Project].[sp_AutomatedProjectIDupdates]    Script Date: 3/13/2017 2:37:17 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO







-- =============================================
-- Author:		Greg Sanders
-- Create date: 2013-03-13
-- Description:	Assign a parent ID to a dunsnumber for a range of years
-- =============================================
CREATE PROCEDURE [Project].[sp_AutomatedProjectIDupdates]
	-- Add the parameters for the stored procedure here

	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	
	insert into  project.SystemEquipmentCodetoProjectIDhistory
	(systemequipmentcode
	,systemequipmentcodeText
	,Unseperated
	,StartFiscalYear
	,EndFiscalYear)
	select s.systemequipmentcode
	,s.systemequipmentcodeText
	,s.Unseperated
	,min(f.Fiscal_Year) as StartFiscalYear
	,NULL --Intentionally not bounding the end year otherwise would be max(f.Fiscal_Year) as StartFiscalYear
	from project.SystemEquipmentCode s
	left outer join project.SystemEquipmentCodetoProjectIDhistory s2p
	on s.systemequipmentcode=s2p.systemequipmentcode
	inner join contract.fpds f
	on s.SystemEquipmentCode=f.systemequipmentcode
	where s2p.systemequipmentcode is null
	group by s.systemequipmentcode
	,s.systemequipmentcodeText
	,s.Unseperated


	insert into project.projectid
	(ProjectAbbreviation
	,ProjectName)
	select distinct s2p.systemequipmentcode, s2p.systemequipmentcodeText	
	from project.SystemEquipmentCodetoProjectIDhistory s2p
	left outer join Project.SystemEquipmentCode s
	on s2p.systemequipmentcode=s.systemequipmentcode
	left outer join Project.ProjectID p
	on s2p.systemequipmentcode=p.ProjectAbbreviation
	where IsIdentifiedSystemEquipment=1 and s2p.ProjectID is null and p.ProjectID is null

	update s2p
	set ProjectID=p.projectid
	,CSISmodifiedDate=getdate()
	,CSISmodifiedby=System_user
	from project.SystemEquipmentCodetoProjectIDhistory s2p
	left outer join Project.ProjectID p
	on s2p.systemequipmentcode=p.ProjectAbbreviation
	where s2p.ProjectID is null and p.ProjectID is not null



	--Adjust SystemEquipmentCodetoProjectIDhistory values aut
	update s2p
	set startfiscalyear=NewStartFiscalYear
	,endfiscalyear=NewEndfiscalYear
	,CSISmodifiedBy=left('Automatic fiscalyear adjustment by '+system_user,150)
	,CSISmodifiedDate=getdate()
	from project.SystemEquipmentCodetoProjectIDhistory  s2p
	inner join (select s2pmismatch.SystemEquipmentCode
	,s2pmismatch.startfiscalyear
	,s2pmismatch.endfiscalyear
	,min(iif(f.fiscal_year<s2pMismatch.StartFiscalYear or s2pmismatch.startfiscalyear is null,f.fiscal_year,s2pMismatch.StartFiscalYear)) as NewStartFiscalYear
	,max(iif(f.fiscal_year>s2pMismatch.EndFiscalYear or s2pMismatch.endfiscalyear is null,NULL,s2pMismatch.StartFiscalYear)) as NewEndFiscalYear
	from contract.fpds f
	inner join project.SystemEquipmentCode s
	on s.SystemEquipmentCode=f.systemequipmentcode
	left outer join project.SystemEquipmentCodetoProjectIDhistory s2pMatch
	on s2pMatch.systemequipmentcode=s.systemequipmentcode
	and s2pMatch.StartFiscalYear<=f.fiscal_year
	and (s2pMatch.EndFiscalYear>=f.fiscal_year or s2pMatch.EndFiscalYear is null)
	inner join project.SystemEquipmentCodetoProjectIDhistory s2pMismatch
	on s2pMismatch.systemequipmentcode=s.systemequipmentcode
	left outer join project.ProjectID p
	on p.ProjectID=s2pMismatch.ProjectID
	where s2pMatch.ProjectID is null 
		and s.IsIdentifiedSystemEquipment=1 
		and s2pMismatch.ProjectID is not null
		and s2pMismatch.systemequipmentcode in (select systemequipmentcode
			from project.SystemEquipmentCodetoProjectIDhistory
			group by systemequipmentcode 
			having count(*)=1) 
	group by s.systemequipmentcode
	,s.systemequipmentcodeText
	,s.Unseperated
	,s2pMismatch.systemequipmentcode
	,s2pMismatch.ProjectID
	,s2pMismatch.systemequipmentcodeText 
	,s2pMismatch.StartFiscalYear 
	,s2pMismatch.EndFiscalYear 
	,p.ProjectAbbreviation 
	,p.ProjectName 
	,s.systemequipmentcodeText
	,s.Unseperated
	) s2pmismatch
	on s2pmismatch.systemequipmentcode=s2p.systemequipmentcode
	and (s2pmismatch.startfiscalyear=s2p.startfiscalyear or (s2pmismatch.startfiscalyear is null and s2p.startfiscalyear is null))
	and (s2pmismatch.endfiscalyear=s2p.endfiscalyear or (s2pmismatch.endfiscalyear is null and s2p.endfiscalyear is null))

	--List remaining projects which will have to be managed by hand
	select s.systemequipmentcode
	,s.systemequipmentcodeText
	,s.Unseperated	
	,min(f.Fiscal_Year) as MinOfFiscalYear
	,max(f.Fiscal_Year) as MaxOfFiscalYear
	,s2pMismatch.ProjectID as PossibleProjectID
	,s2pMismatch.systemequipmentcodeText as PossibleSECtext
	,s2pMismatch.StartFiscalYear as PossibleStartFiscalYear
	,s2pMismatch.EndFiscalYear as PossibleEndFiscalYear
	,p.ProjectAbbreviation as PossibleProjectAbbreviation
	,p.ProjectName as PossibleProjectName
	from contract.fpds f
	inner join project.SystemEquipmentCode s
	on s.SystemEquipmentCode=f.systemequipmentcode
	left outer join project.SystemEquipmentCodetoProjectIDhistory s2pMatch
	on s2pMatch.systemequipmentcode=s.systemequipmentcode
	and s2pMatch.StartFiscalYear<=f.fiscal_year
	and (s2pMatch.EndFiscalYear>=f.fiscal_year or s2pMatch.EndFiscalYear is null)
	inner join project.SystemEquipmentCodetoProjectIDhistory s2pMismatch
	on s2pMismatch.systemequipmentcode=s.systemequipmentcode
	left outer join project.ProjectID p
	on p.ProjectID=s2pMismatch.ProjectID
	where s2pMatch.ProjectID is null and s.IsIdentifiedSystemEquipment=1 and s2pMismatch.ProjectID is not null
	group by s.systemequipmentcode
	,s.systemequipmentcodeText
	,s.Unseperated
	,s2pMismatch.ProjectID
	,s2pMismatch.systemequipmentcodeText 
	,s2pMismatch.StartFiscalYear 
	,s2pMismatch.EndFiscalYear 
	,p.ProjectAbbreviation 
	,p.ProjectName 
	,s.systemequipmentcodeText
	,s.Unseperated
	order by s.systemequipmentcode
	,s2pMismatch.ProjectID
	
END








GO
