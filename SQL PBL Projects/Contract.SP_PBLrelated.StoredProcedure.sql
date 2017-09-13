USE [DIIG]
GO

/****** Object:  StoredProcedure [Contract].[SP_PBLrelated]    Script Date: 9/13/2017 1:51:16 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO





ALTER PROCEDURE [Contract].[SP_PBLrelated]


AS

--List all Contract Labels
select *
from contract.ContractLabelID

--List labeled transactions
  select  ContractLabelText, count(*) as tCount
  from contract.CSIStransactionID t
  left outer join contract.ContractLabelID l
  on t.ContractLabelID=l.ContractLabelID
  group by ContractLabelText

--List labeled contracts
  select  ContractLabelText, count(*) as cCount
  from contract.CSIScontractID c
  left outer join contract.ContractLabelID l
  on c.ContractLabelID=l.ContractLabelID
  group by ContractLabelText


--List labeled IDVs
  select  ContractLabelText, count(*) as iCount
  from contract.CSISidvpiidID i
  left outer join contract.ContractLabelID l
  on i.ContractLabelID=l.ContractLabelID
  group by ContractLabelText



  --United list of all PBLs and related contracts
select ccid.CSIScontractID
  ,ccid.idvpiid
  ,ccid.piid
  ,ilabel.ContractLabelText as ILabel
  ,clabel.ContractLabelText as CLabel
  ,tlabel.ContractLabelText as TLabel
  ,count(ctid.CSIStransactionID) as CountOfTransactions
  from contract.CSIStransactionID ctid
  inner join contract.CSIScontractID ccid
	on ctid.CSIScontractID=ccid.CSIScontractID
  left outer join contract.CSISidvpiidID icid
	on ccid.CSISidvpiidID=icid.CSISidvpiidID
  left outer join contract.ContractLabelID tlabel
	on ctid.ContractLabelID=tlabel.ContractLabelID
  left outer join contract.ContractLabelID clabel
	on ccid.ContractLabelID=clabel.ContractLabelID
  left outer join contract.ContractLabelID ilabel
	on icid.ContractLabelID=ilabel.ContractLabelID
  where ccid.csiscontractid in (
	select   ctid.CSIScontractID
	from contract.CSIScontractID ccid
	left outer join contract.CSIStransactionID ctid
		on ctid.csiscontractid=ccid.csiscontractid
	left outer join contract.CSISidvpiidID ciid
		on ciid.CSISidvpiidID=ccid.CSISidvpiidID
	left outer join contract.ContractLabelID l
		on ctid.ContractLabelID=l.ContractLabelID
	left outer join contract.ContractLabelID c
		on ccid.ContractLabelID=c.ContractLabelID
	left outer join contract.ContractLabelID i
		on ciid.ContractLabelID=i.ContractLabelID
	group by ccid.idvpiid
		, ccid.piid
		, ctid.CSIScontractID
	having max(cast(l.IsPerformanceBasedLogistics as int))=1 or
		max(cast(c.IsPerformanceBasedLogistics as int))=1 or
		max(cast(i.IsPerformanceBasedLogistics as int))=1
  )
  group by  ccid.CSIScontractID
  ,ccid.idvpiid
  ,ccid.piid
  ,clabel.ContractLabelText
  ,tlabel.ContractLabelText
  ,ilabel.ContractLabelText 
  order by idvpiid
  ,piid
  ,tlabel.ContractLabelText
  
	
--United list, PBLs only
  select ccid.CSIScontractID
	,ccid.idvpiid
	,ccid.piid
	,ctid.CSIStransactionID
	,coalesce(tlabel.ContractLabelText,
		clabel.ContractLabelText,
		ilabel.ContractLabelText) as Label
	,tlabel.ContractLabelText as tLabel
	,clabel.ContractLabelText as cLabel
	,ilabel.ContractLabelText as iLabel
  from contract.CSIStransactionID ctid
  left outer join contract.ContractLabelID tlabel
	on ctid.ContractLabelID=tlabel.ContractLabelID
  inner join contract.CSIScontractID ccid
	on ctid.CSIScontractID=ccid.CSIScontractID
  left outer join contract.ContractLabelID clabel
	on ccid.ContractLabelID=clabel.ContractLabelID
  inner join contract.CSIScontractID ciid
	on ccid.CSISidvpiidID=ciid.CSISidvpiidID
  left outer join contract.ContractLabelID ilabel
	on ciid.ContractLabelID=ilabel.ContractLabelID
  where clabel.IsPerformanceBasedLogistics=1 or 
	tlabel.IsPerformanceBasedLogistics=1 or
	ilabel.IsPerformanceBasedLogistics=1 
  order by idvpiid
	,piid

--Update list of entries directly labeled ZBL in FPDS
  update ctid
  set [ContractLabelID]=6
,CSISmodifiedBy=left('ZBL from FPDS by '+SYSTEM_USER,128)
,CSISmodifiedDate=getdate()

  from contract.fpds f
  inner join contract.CSIStransactionID ctid
  on f.CSIStransactionID=ctid.CSIStransactionID
  where f.systemequipmentcode='ZBL'

  --United list of official PBLs
   select ccid.CSIScontractID
	,ccid.idvpiid
	,ccid.piid
	,ctid.CSIStransactionID
	,coalesce(tlabel.ContractLabelText,
		clabel.ContractLabelText,
		ilabel.ContractLabelText) as Label
	,tlabel.ContractLabelText as tLabel
	,clabel.ContractLabelText as cLabel
	,ilabel.ContractLabelText as iLabel
  from contract.CSIStransactionID ctid
  left outer join contract.ContractLabelID tlabel
	on ctid.ContractLabelID=tlabel.ContractLabelID
  inner join contract.CSIScontractID ccid
	on ctid.CSIScontractID=ccid.CSIScontractID
  left outer join contract.ContractLabelID clabel
	on ccid.ContractLabelID=clabel.ContractLabelID
  inner join contract.CSIScontractID ciid
	on ccid.CSISidvpiidID=ciid.CSISidvpiidID
  left outer join contract.ContractLabelID ilabel
	on ciid.ContractLabelID=ilabel.ContractLabelID
  where clabel.IsOfficialPBL=1 or 
	tlabel.IsOfficialPBL=1 or
	ilabel.IsOfficialPBL=1 
  order by idvpiid
	,piid
 
--List official PBLs
select  ccid.idvpiid
	, ccid.piid
	, ctid.CSIScontractID
	, sum(iif(l.IsOfficialPBL=1,1,0)) as OfficialPBLtransaction
	, sum(iif(l.IsPerformanceBasedLogistics=1 and isnull(l.IsOfficialPBL,0)=0,1,0)) as UnofficialPBLtransaction
	, sum(iif(isnull(l.IsPerformanceBasedLogistics,0)=0,1,0)) as UnlabeledTransaction
from contract.CSIScontractID ccid
inner join contract.CSIStransactionID ctid
	on ctid.csiscontractid=ccid.csiscontractid
left outer join contract.ContractLabelID l
	on ctid.ContractLabelID=l.ContractLabelID
group by ccid.idvpiid
	, ccid.piid
	, ctid.CSIScontractID
having max(cast(l.IsOfficialPBL as int))=1
order by idvpiid
  ,piid

  

update ccid
set ccid.ContractLabelID=6
,CSISmodifiedBy=left('ZBL from consistent transactions by '+SYSTEM_USER,128)
,CSISmodifiedDate=getdate()

from contract.CSIScontractID ccid
where ccid.ContractLabelID is null
and csiscontractid in
(select   ctid.CSIScontractID
from contract.CSIScontractID ccid
left outer join contract.CSIStransactionID ctid
	on ctid.csiscontractid=ccid.csiscontractid
left outer join contract.ContractLabelID l
	on ctid.ContractLabelID=l.ContractLabelID
group by ccid.idvpiid
	, ccid.piid
	, ctid.CSIScontractID
having min(isnull(cast(l.IsOfficialPBL as int),0))=1
)

--List all Govini transaction matches
select [contract id]
	,[Task Order ID]
	,[Award Number]
	, ip.idvpiid
	,isnull(cp.piid,ip.piid) as piid
	,isnull( cp.ContractLabelID, ip.ContractLabelID) as ContractLabelID
	--,right('0000'+ g.[Task Order ID],4) as alt
from contract.GoviniPBLbyDescriptionOrTitle g
left outer join contract.CSIScontractID cp
on nullif(g.[Award Number],'')=cp.piid
left outer join contract.CSIScontractID ip
on nullif(g.[Contract ID],'')=ip.idvpiid
and right('0000'+ g.[Task Order ID],4) = ip.piid


--Label Contracts that mention PBLs in the transaction according to Govini
update c
set ContractLabelID=14
from contract.CSIScontractID c
left outer join contract.GoviniPBLbyDescriptionOrTitle gp
on  nullif(gp.[Award Number],'')=c.piid
left outer join contract.GoviniPBLbyDescriptionOrTitle gi
on nullif(gi.[Contract ID],'')=c.idvpiid 
and right('0000'+ gi.[Task Order ID],4) = c.piid
where c.ContractLabelID is null
and (nullif(gp.[Award Number],'') is not null
or nullif(gi.[Contract ID],'') is not null)

--Label IDVs that mention PBLs in the transaction according to Govini
update i
set ContractLabelID=14
,CSISmodifiedBy=left('Govini Transaction by '+SYSTEM_USER,128)
,CSISmodifiedDate=getdate()

from contract.CSISidvpiidID i
left outer join contract.GoviniPBLbyDescriptionOrTitle gi
on nullif(gi.[Contract ID],'')=i.idvpiid 
where 
i.ContractLabelID is null and 
nullif(gi.[Contract ID],'') is not null
and [Task Order ID]='0'


--List all Govini solicitation matches
select distinct [contract id]
	,[Task Order ID]
	,[Award Number]
	, coalesce(ip1.idvpiid,ip2.idvpiid) as idvpiid
	,coalesce(cp.piid,ip1.piid,ip2.piid) as piid
	,coalesce( cp.ContractLabelID, ip1.ContractLabelID, ip2.ContractLabelID) as ContractLabelID
	,cp.CSIScontractID as cid
	,ip1.CSIScontractID as pid1
	,ip2.CSIScontractID as pid2
	--,right('0000'+ g.[Task Order ID],4) as alt
from contract.GoviniPBLbySolicitationID g
left outer join contract.CSIScontractID cp
on nullif(g.[Award Number],'')=cp.piid and [contract id]=''
left outer join contract.CSIScontractID ip1
on nullif(g.[Contract ID],'')=ip1.idvpiid
and ((right('0000'+ g.[Task Order ID],4) = ip1.piid) 
or g.[Task Order ID]=ip1.piid)
left outer join contract.CSIScontractID ip2
on nullif(g.[Contract ID],'')=ip2.idvpiid
and ((right('0000'+ nullif(g.[Award Number],''),4) = ip2.piid)
or g.[Award Number]=ip2.piid)


--Label contracts that are mention PBLs in the solicitation according to Govini
update c
set ContractLabelID=15
,CSISmodifiedBy=left('Govini Solicitation by '+SYSTEM_USER,128)
,CSISmodifiedDate=getdate()

from contract.CSIScontractID c
left outer join contract.GoviniPBLbySolicitationID gp
on nullif(gp.[Award Number],'')=c.piid and  [contract id]=''
left outer join contract.GoviniPBLbySolicitationID gi1
on nullif(gi1.[Contract ID],'')=c.idvpiid
and ((right('0000'+ gi1.[Task Order ID],4) = c.piid) 
or gi1.[Task Order ID]=c.piid)
left outer join contract.GoviniPBLbySolicitationID gi2
on nullif(gi2.[Contract ID],'')=c.idvpiid
and ((right('0000'+ nullif(gi2.[Award Number],''),4) = c.piid)
or gi2.[Award Number]=c.piid)
where c.ContractLabelID is null and 
(nullif(gp.[Award Number],'') is not null
or nullif(gi1.[Contract ID],'') is not null
or nullif(gi2.[Contract ID],'') is not null)

--Label contracts that are mention PBLs in the solicitation according to Govini
update i
set ContractLabelID=15
,CSISmodifiedBy=left('Govini Solicitation by '+SYSTEM_USER,128)
,CSISmodifiedDate=getdate()

--select distinct CSISidvpiidID
--,i.idvpiid
----,i.piid
--,i.ContractLabelID
--,gi.[Contract ID]
--,gi.[Award Number]
--,gi.[Task Order ID]
from contract.CSISidvpiidID i
left outer join contract.GoviniPBLbySolicitationID gi
on nullif(gi.[Contract ID],'')=i.idvpiid 
where 
i.ContractLabelID is null and 
nullif(gi.[Contract ID],'') is not null
and ([Task Order ID]='0' or [Task Order ID]='')
and (gi.[Award Number]='0' or gi.[Award Number]='')

--List count of transactions that match the official PBL list
select l.ContractLabelText,count(*) as NumberOfTransactions
	from contract.CSIStransactionID t
	left outer join contract.ContractLabelID l
	on t.ContractLabelID=l.ContractLabelID
where CSIStransactionID in (
	SELECT [csistransactionid]
		FROM [DIIG].[SystemEquipment].[ZBLmatches]
  )
  group by l.ContractLabelText


  select l.ContractLabelText,count(*) as NumberOfTransactions
	from contract.CSIStransactionID t
	left outer join contract.ContractLabelID l
	on t.ContractLabelID=l.ContractLabelID
where CSIStransactionID in (
	SELECT [csistransactionid]
		FROM [DIIG].[SystemEquipment].[ZBLmatches]
  )
  group by l.ContractLabelText




  --Label transactions that match the official PBL list
update t
set ContractlabelID=6
,CSISmodifiedBy=left('ZBL via list by '+SYSTEM_USER,128)
,CSISmodifiedDate=getdate()
	from contract.CSIStransactionID t
left outer join contract.ContractLabelID l
	on t.ContractLabelID=l.ContractLabelID
where CSIStransactionID in (
	SELECT [csistransactionid]
		FROM [DIIG].[SystemEquipment].[ZBLmatches]
  ) and isnull(l.IsOfficialPBL,0)=0 and 
	(t.ContractLabelID is null or l.IsPerformanceBasedLogistics=1)

  --Label contracts that match the official PBL list
update t
set ContractlabelID=6
,CSISmodifiedBy=left('ZBL via list by '+SYSTEM_USER,128)
,CSISmodifiedDate=getdate()
	from contract.CSIStransactionID t
left outer join contract.ContractLabelID l
	on t.ContractLabelID=l.ContractLabelID
where CSIStransactionID in (
	SELECT [csistransactionid]
		FROM [DIIG].[SystemEquipment].[ZBLmatches]
  ) and isnull(l.IsOfficialPBL,0)=0 and 
	(t.ContractLabelID is null or l.IsPerformanceBasedLogistics=1)

--Compare CSIS labeled contract totals spend and count with OSD's
  select osd.ContractNumber
  ,osd.Done
  ,osd.NumberOfActions as OSDnumberOfActions
  ,match.NumberOfActions as FPDSnumberOfActions
  ,osd.ObligatedAmount as OSDobligatedAmount
  ,match.ObligatedAmount as FPDSobligatedamount
  from [Contract].[PBLlistOSDdetails] osd
  left outer join (select contractnumber
	,sum(numberofactions) as NumberOfActions
	,sum(obligatedamount) as ObligatedAmount
	from [SystemEquipment].[ZBLmatches] 
	group by contractnumber
	) match
  on osd.ContractNumber=match.ContractNumber
  where osd.IsTotal=1
  
--Compare CSIS labeled contract *and PSE* spend and count with OSD's
  select osd.ContractNumber
  ,osd.PSEcode
  ,osd.PSEtext
  ,osd.Done
  ,osd.NumberOfActions as OSDnumberOfActions
  ,match.NumberOfActions as FPDSnumberOfActions
  ,osd.ObligatedAmount as OSDobligatedAmount
  ,match.ObligatedAmount as FPDSobligatedamount
  from [Contract].[PBLlistOSDdetails] osd
  left outer join (select contractnumber
	,PSE
	,sum(numberofactions) as NumberOfActions
	,sum(obligatedamount) as ObligatedAmount
	from [SystemEquipment].[ZBLmatches] 
	group by contractnumber
	,pse
	) match
  on osd.ContractNumber=match.ContractNumber and
	osd.PSEcode=match.PSE
  where osd.IsTotal=0

  --Keeping this around in case I need it again in the future
    --update p
  --set 
  --contractnumber=left(contractnumber,len(contractnumber)-6) 
  --  , istotal=1
  --from [DIIG].[Contract].[PBLlistOSDdetails] p
  --where right(contractnumber,6)=' Total' and PSEcode is nu

  --Label ZBL contracts
  update ccid
  set ccid.ContractLabelID=6
  ,CSISmodifiedBy=left('ZBL OSD contract by CSIScontractID by '+SYSTEM_USER,128)
,CSISmodifiedDate=getdate()
  from [Contract].[PBLlistOSDdetails] osd
  left outer join contract.csiscontractid ccid
  on osd.CSIScontractID=ccid.CSIScontractID
  left outer join contract.ContractLabelID cl
  on cl.ContractLabelID=ccid.contractlabelid
  where osd.IsTotal=1
  and (cl.ContractLabelText ='PBL-Government-Identified' or cl.IsOfficialPBL =0)

  --Label ZBL IDVs
  update ciid
  set ContractLabelID=iif(ciid.ContractLabelID=7,8,6)
  ,CSISmodifiedBy=left('ZBL OSD IDV by CSIScontractID by '+SYSTEM_USER,128)
,CSISmodifiedDate=getdate()
--select cl.ContractLabelText
--,iif(ciid.ContractLabelID=7,8,6)
  from [Contract].[PBLlistOSDdetails] osd
  left outer join contract.CSISidvpiidid ciid
  on osd.CSISidvpiidID=ciid.CSISidvpiidID
  left outer join contract.ContractLabelID cl
  on cl.ContractLabelID=ciid.contractlabelid
  
  where osd.IsTotal=1
  and (cl.ContractLabelText ='PBL-Government-Identified' or cl.IsOfficialPBL =0)


  
--Compare CSIS labeled contract *and PSE* spend and count with OSD's
  select osd.ContractNumber
  ,osd.PSEcode
  ,osd.PSEtext
  ,osd.Done
  ,osd.NumberOfActions as OSDnumberOfActions
  ,match.NumberOfActions as FPDSnumberOfActions
  ,osd.ObligatedAmount as OSDobligatedAmount
  ,match.ObligatedAmount as FPDSobligatedamount
  from [Contract].[PBLlistOSDdetails] osd
  left outer join (select contractnumber
	,PSE
	,sum(numberofactions) as NumberOfActions
	,sum(obligatedamount) as ObligatedAmount
	from [SystemEquipment].[ZBLmatches] 
	group by contractnumber
	,pse
	) match
  on osd.ContractNumber=match.ContractNumber and
	osd.PSEcode=match.PSE
  where osd.IsTotal=0

  --Keeping this around in case I need it again in the future
    --update p
  --set 
  --contractnumber=left(contractnumber,len(contractnumber)-6) 
  --  , istotal=1
  --from [DIIG].[Contract].[PBLlistOSDdetails] p
  --where right(contractnumber,6)=' Total' and PSEcode is nu






GO


