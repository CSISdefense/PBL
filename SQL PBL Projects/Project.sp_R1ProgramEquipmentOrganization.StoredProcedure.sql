USE [DIIG]
GO
/****** Object:  StoredProcedure [Project].[sp_R1ProgramEquipmentOrganization]    Script Date: 3/13/2017 2:37:17 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO




-- =============================================
-- Author:		Greg Sanders
-- Create date: 2013-03-13
-- Description:	Assign a parent ID to a dunsnumber for a range of years
-- =============================================
CREATE  PROCEDURE [Project].[sp_R1ProgramEquipmentOrganization]
	-- Add the parameters for the stored procedure here
	@Organization varchar(5)

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;


	--if @Organization is null
	--	raiserror('The value for @Organization should not be null.',15,1)

		--Verify that the parameter is already in the relevant type table.
	if(@Organization is null)
		begin
		SELECT pe.[ProgramElement]
			,pe.[ProgramElementTitle]
					,r.BudgetActivity
			,r.BudgetActivityTitle
			,pe.[classified]
			--,dsi.[DefenseServiceIdentifier]
			,dsi.Organization
			--,[ProgramElementNumber]
						,min(r.FiscalYear) as MinOfFiscalYear
			,max(r.FiscalYear) as MaxOfFiscalYear
			,sum(r.Actual) SumOfActual
			,sum(r.App) as SumOfApp
			,sum(r.CR) as SumOfCR
			,sum(r.CR_OCO) as SumOfCR_OCO
			,sum(r.OCO_App) as SumOfOCO_App
			,sum(r.OCO_PB) as SumOfOCO_PB
			,sum(r.OCO_Sup) as SumOfOCO_Sup
			,sum(r.PB) as SumOfPB
		FROM [DIIG].[Project].[ProgramElement] pe
		left outer join agency.[DefenseServiceIdentifier]  dsi
		on pe.DefenseServiceIdentifier=dsi.[DefenseServiceIdentifier]  
				left outer join budget.DefenseR1 r
		on pe.ProgramElement=r.ProgramElement
		group by  pe.[ProgramElement]
			,pe.[ProgramElementTitle]
					,r.BudgetActivity
			,r.BudgetActivityTitle
			,pe.[classified]
		,dsi.Organization
		end
	else
		begin
		SELECT pe.[ProgramElement]
			,pe.[ProgramElementTitle]
			,r.BudgetActivity
			,r.BudgetActivityTitle
			,pe.[classified]
			--,dsi.[DefenseServiceIdentifier]
			,dsi.Organization
			--,[ProgramElementNumber]
			,min(r.FiscalYear) as MinOfFiscalYear
			,max(r.FiscalYear) as MaxOfFiscalYear
			,sum(r.Actual) SumOfActual
			,sum(r.App) as SumOfApp
			,sum(r.CR) as SumOfCR
			,sum(r.CR_OCO) as SumOfCR_OCO
			,sum(r.OCO_App) as SumOfOCO_App
			,sum(r.OCO_PB) as SumOfOCO_PB
			,sum(r.OCO_Sup) as SumOfOCO_Sup
			,sum(r.PB) as SumOfPB
		FROM [DIIG].[Project].[ProgramElement] pe
		inner join agency.[DefenseServiceIdentifier]  dsi
		on pe.DefenseServiceIdentifier=dsi.[DefenseServiceIdentifier]  
		left outer join budget.DefenseR1 r
		on pe.ProgramElement=r.ProgramElement
		where @organization=dsi.Organization
			group by  pe.[ProgramElement]
			,pe.[ProgramElementTitle]
					,r.BudgetActivity
			,r.BudgetActivityTitle
			,pe.[classified]
		,dsi.Organization
 
 end


END


















GO
