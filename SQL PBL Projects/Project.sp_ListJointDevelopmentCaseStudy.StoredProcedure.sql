USE [DIIG]
GO
/****** Object:  StoredProcedure [Project].[sp_ListJointDevelopmentCaseStudy]    Script Date: 3/13/2017 2:37:17 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO






-- =============================================
-- Author:		Greg Sanders
-- Create date: 2013-03-13
-- Description:	Assign a parent ID to a dunsnumber for a range of years
-- =============================================
CREATE  PROCEDURE [Project].[sp_ListJointDevelopmentCaseStudy]
	-- Add the parameters for the stored procedure here
	

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;


		SELECT p.[ProjectID]
      ,p.[ProjectName]
      ,p.[ProjectAbbreviation]
      --,p.[IsJointDevelopmentCaseStudy]
	  ,nullif(count(distinct sec.systemequipmentcode),0) as SystemEquipmentCodeCount
	  ,nullif(count(distinct clid.ContractLabelID),0) as ContractLabelIDcount
	  ,nullif(count(distinct r1.ProgramElement),0) as R1programElementCount
	,p1.LineItemCount as P1lineItemCount
  FROM [DIIG].[Project].[ProjectID] p
  left outer join Project.SystemEquipmentCodetoProjectIDhistory sec
  on sec.ProjectID=p.ProjectID
  left outer join Contract.ContractLabelID clid
on clid.PrimaryProjectID=p.ProjectID 
left outer join (SELECT p.ProjectID
      ,[AccountDSI]
      ,[AccountTitle]
      ,[BudgetActivity]
      ,[ProgramElement]

  FROM [DIIG].[budget].[DefenseR1consolidated] r1
  inner join Project.RDTEidToProjectIDmanyToMany  r2pid
  on r2pid.RDTEid=r1.RDTEid
	inner join [DIIG].[Project].[ProjectID] p
on p.ProjectID=r2pid.ProjectID
 where [IsJointDevelopmentCaseStudy]=1
 group by p.ProjectID
      ,[AccountDSI]
      ,[AccountTitle]
      ,[BudgetActivity]
      ,[ProgramElement]
) r1
on r1.ProjectID=p.ProjectID
left outer join (select projectId, count([LineItem]) as LineItemCount
from ( SELECT p.ProjectID
	  ,[AccountDSI]
      ,[BudgetActivity]
      ,[BSA]
      ,[LineItem]    
  FROM [DIIG].[budget].[DefenseP1consolidated] p1
  inner join project.ProcIDtoProjectIDmanyToMany l
  on l.ProcID=p1.ProcID
inner join project.projectid p
on l.ProjectID=p.ProjectID
where l.projectid in (select [ProjectID]
	FROM [DIIG].[Project].[ProjectID]
	 where [IsJointDevelopmentCaseStudy]=1) 	
group by p.ProjectID
	  ,[AccountDSI]
      ,[BudgetActivity]
      ,[BSA]
      ,[LineItem]    
)p1 group by projectId) p1
on p1.ProjectID=p.ProjectID
  where [IsJointDevelopmentCaseStudy]=1
  group by p.[ProjectID]
      ,p.[ProjectName]
      ,p.[ProjectAbbreviation]
      --,p.[IsJointDevelopmentCaseStudy]
	  ,p1.LineItemCount
  order by ProjectAbbreviation
  
	
  

  Select *
  from  Project.SystemEquipmentCodetoProjectIDhistory sec
inner join (select [ProjectID]
  FROM [DIIG].[Project].[ProjectID]
  where [IsJointDevelopmentCaseStudy]=1) p
  on sec.projectid=p.projectid


select [ContractLabelText]
      ,[ContractLabelID]
      ,[TFBSOoriginated]
      ,[TFBSOmentioned]
      ,[IsPerformanceBasedLogistics]
      ,[IsOrganicPBL]
      ,[IsOfficialPBL]
      ,[PrimaryProjectID]
from  Contract.ContractLabelID clid
inner join [DIIG].[Project].[ProjectID] o
on clid.PrimaryProjectID=o.ProjectID
 where [IsJointDevelopmentCaseStudy]=1
  order by ProjectAbbreviation


  		
  SELECT 'P1&R1 for consolidated' as TableName
  ,p.ProjectAbbreviation as ProjAbbr
,p.ProjectName
  , min([SourceFiscalYear]) as MinSourceFY
  , max([SourceFiscalYear]) as MaxSourceFY
  ,isnull([DefenseOrganization],[DefenseOrganizationEstimate]) as [DefOrg]
      
      --,[AccountTitle]
	  ,AccountDisplay
	  ,BAdisplay
	      --,[BudgetActivity] as BA
      --,[BudgetActivityTitle]
      --,[LineNumber]
	  --,[AccountDSI]
	  ,Comp.BSAdisplay
	  ,Comp.PEorLineItem
      ,Comp.PEorLineItemTitle
      --,[IncludeInTOA]
      --,[Classified]
      ,sum([PBtotal]) as [PBtotal]
      ,sum([PBtype]) as [PBtype]
      ,sum(EnactedTotal) as [EnactedTotalpe]
      ,sum(enactedType) as EnactedType
      ,sum([SpecialType]) as [SpecialType]
      ,sum([ActualTotal]) as [ActualTotal]
	  ,sum([QuantPBtotal]) as QuantPBtotal
      ,sum([QuantPBtype]) as [QuantPBtype]
      ,sum([QuantEnactedTotal]) as [QuantEnactedTotal]
      ,sum([QuantEnactedType]) as [QuantEnactedType]
      ,sum([QuantSpecialType]) as [QuantSpecialType]
      ,sum([QuantActualTotal]) as QuantActualTotal
  FROM [DIIG].[budget].[ComptrollerSourceFiscalYear] Comp
  left outer join Project.ProcIDToProjectIDmanyToMany  p2pid
    on p2pid.ProcID=Comp.ProcID
  left outer join Project.RDTEidToProjectIDmanyToMany r2pid
    on r2pid.RDTEid=Comp.RDTEid
  left outer join [DIIG].[Project].[ProjectID] p
on p.ProjectID=isnull(r2pid.ProjectID,p2pid.ProjectID)
 where [IsJointDevelopmentCaseStudy]=1
  group by  isnull([DefenseOrganization],[DefenseOrganizationEstimate]) 
  	  ,AccountDisplay
	  ,BAdisplay
	  ,BSAdisplay
      ,[AccountDSI]
      ,[AccountTitle]
      ,[BudgetActivity]
      ,[BudgetActivityTitle]
      --,[LineNumber]
      --,[IncludeInTOA]
      --,[Classified]
	  ,p.ProjectAbbreviation
,p.ProjectName
,Comp.BSA
,Comp.PEorLineItem
,Comp.PEorLineItemTitle
	  order by p.ProjectAbbreviation
	  ,isnull([DefenseOrganization],[DefenseOrganizationEstimate]) 
	  ,BudgetActivity
	  ,Comp.BSA
	  ,Comp.PEorLineItem
	  ,min(SourceFiscalYear)
	
	
  SELECT 'P1&R1 one per year' as TableName
  ,p.ProjectAbbreviation as ProjAbbr
,p.ProjectName
  ,isnull([DefenseOrganization],[DefenseOrganizationEstimate]) as [DefOrg]
      
      --,[AccountTitle]
	  ,AccountDisplay
	    ,[SourceFiscalYear] as SourceFY
	  ,BAdisplay
	      --,[BudgetActivity] as BA
      --,[BudgetActivityTitle]
      --,[LineNumber]
	  --,[AccountDSI]
	  ,Comp.BSAdisplay
	  ,Comp.PEorLineItem
      ,Comp.PEorLineItemTitle
      --,[IncludeInTOA]
      --,[Classified]
      ,sum([PBtotal]) as [PBtotal]
      ,sum([PBtype]) as [PBtype]
      ,sum(EnactedTotal) as [EnactedTotalpe]
      ,sum(enactedType) as EnactedType
      ,sum([SpecialType]) as [SpecialType]
      ,sum([ActualTotal]) as [ActualTotal]
	  ,sum([QuantPBtotal]) as QuantPBtotal
      ,sum([QuantPBtype]) as [QuantPBtype]
      ,sum([QuantEnactedTotal]) as [QuantEnactedTotal]
      ,sum([QuantEnactedType]) as [QuantEnactedType]
      ,sum([QuantSpecialType]) as [QuantSpecialType]
      ,sum([QuantActualTotal]) as QuantActualTotal
  FROM [DIIG].[budget].[ComptrollerSourceFiscalYear] Comp
  left outer join Project.ProcIDToProjectIDmanyToMany  p2pid
    on p2pid.ProcID=Comp.ProcID
  left outer join Project.RDTEidToProjectIDmanyToMany r2pid
    on r2pid.RDTEid=Comp.RDTEid
  left outer join [DIIG].[Project].[ProjectID] p
on p.ProjectID=isnull(r2pid.ProjectID,p2pid.ProjectID)
 where [IsJointDevelopmentCaseStudy]=1
  group by  isnull([DefenseOrganization],[DefenseOrganizationEstimate]) 
  	  ,AccountDisplay
	  ,BAdisplay
	  ,BSAdisplay
	  ,[SourceFiscalYear]
      ,[AccountDSI]
      ,[AccountTitle]
      ,[BudgetActivity]
      ,[BudgetActivityTitle]
      --,[LineNumber]
      --,[IncludeInTOA]
      --,[Classified]
	  ,p.ProjectAbbreviation
,p.ProjectName
,Comp.BSA
,Comp.PEorLineItem
,Comp.PEorLineItemTitle
	  order by p.ProjectAbbreviation
	  ,isnull([DefenseOrganization],[DefenseOrganizationEstimate]) 
	  ,BudgetActivity
	  ,Comp.BSA
	  ,Comp.PEorLineItem
	  ,SourceFiscalYear
	

SELECT 'R1 complete' as TableName
,p.ProjectAbbreviation as ProjAbbr
,p.ProjectName
      ,[SourceFiscalYear]
      ,[AccountDSI]
      --,[TreasuryAgencyCode]
      --,[MainAccountCode]
      ,[AccountTitle]
      ,isnull([DefenseOrganization],[DefenseOrganizationEstimate]) as [DefenseOrganization]
      ,[BudgetActivity]
      ,[BudgetActivityTitle]
      ,[LineNumber]
      ,[ProgramElement]
      ,r1.[ProgramElementNumber]
      ,[ProgramElementTitle]
      ,[IncludeInTOA]
      ,[Classified]
      --,r1.[RDTEid]
      ,[FiscalYear]
      ,[OriginType]
      ,[PBtotal]
      ,[PBtype]
      ,[EnactedTotal]
      ,[EnactedType]
      ,[SpecialType]
      ,[ActualTotal]
  FROM [DIIG].[budget].[DefenseR1consolidated] r1
  inner join Project.RDTEidToProjectIDmanyToMany  r2pid
  on r2pid.RDTEid=r1.RDTEid
	inner join [DIIG].[Project].[ProjectID] p
on p.ProjectID=r2pid.ProjectID
 where [IsJointDevelopmentCaseStudy]=1
  order by p.ProjectAbbreviation
  ,isnull([DefenseOrganization],[DefenseOrganizationEstimate]) 
	,r1.AccountDSI
	,r1.BudgetActivity
	,r1.ProgramElement
	,r1.SourceFiscalYear
	

	
  
  SELECT 'P1 complete' as TableName
  ,p.ProjectAbbreviation as ProjAbbr
,p.ProjectName
	,[SourceFiscalYear]
      ,[AccountDSI]
      ,[TreasuryAgencyCode]
      ,[MainAccountCode]
      ,[AccountTitle]
       ,isnull([DefenseOrganization],[DefenseOrganizationEstimate]) as [DefenseOrganization]
      --,[DefenseOrganizationEstimate]
      --,[SimpleDefenseServiceIndicator]
      ,[BudgetActivity]
      ,[BudgetActivityTitle]
      ,[LineNumber]
      ,[BSA]
      ,[BSAtitle]
      ,[LineItem]
      ,[LineItemTitle]
      ,[CostType]
      ,[CostTypeTitle]
      ,[AddOrNonAdd]
      ,[Classified]
      --,p1.[ProcID]
      ,[ProcurementCategory]
      ,[ProcurementCategoryEstimate]
      ,[FiscalYear]
      ,[OriginType]
      ,[PBtotal]
      ,[PBtype]
      ,[EnactedTotal]
      ,[EnactedType]
      ,[SpecialType]
      ,[ActualTotal]
      ,[QuantPBtotal]
      ,[QuantPBtype]
      ,[QuantEnactedTotal]
      ,[QuantEnactedType]
      ,[QuantSpecialType]
      ,[QuantActualTotal]
  FROM [DIIG].[budget].[DefenseP1consolidated] p1
  inner join project.ProcIDtoProjectIDmanyToMany l
  on l.ProcID=p1.ProcID
inner join project.projectid p
on l.ProjectID=p.ProjectID
where l.projectid in (select [ProjectID]
	FROM [DIIG].[Project].[ProjectID]
	 where [IsJointDevelopmentCaseStudy]=1) 	
order by p.ProjectAbbreviation
	,p1.TreasuryAgencyCode
	,p1.AccountDSI
	,p1.BudgetActivity
	,p1.BSA
	,p1.lineitem
	,p1.SourceFiscalYear

END




















GO
