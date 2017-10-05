library(ggplot2)
library(stringr)
library(plyr)
library(Hmisc)
library(lubridate)
library(csis360)
options(error=recover)


Path<-"K:\\2007-01 PROFESSIONAL SERVICES\\R scripts and data\\"
if (!file.exists(paste(Path,"lookups.r",sep=""))){
  Path<-"C:\\Users\\gsand_000.ALPHONSE\\Documents\\Development\\R-scripts-and-data\\"
  if (!file.exists(paste(Path,"lookups.r",sep=""))){
    stop("Don't know where to find lookups.r")
  }
} 

source(paste(Path,"lookups.r",sep=""))
source(paste(Path,"helper.r",sep=""))


PBLscore  <- read.csv(
  paste("Data\\Contract_SP_ContractPBLscoreSubCustomerProdServ.txt", sep = ""),
  header = TRUE, sep = "\t", dec = ".", strip.white = TRUE, 
  na.strings = c("NULL","NA",""),
  stringsAsFactors = TRUE
)

PBLscore<-csis360::standardize_variable_names(PBLscore)
  View(ddply(PBLscore,
        .(Fiscal.Year,Customer,SubCustomer),
        plyr::summarise,
        Action.Obligation=sum(Action.Obligation)))


#Automated topline checking
#By default, read or join error on NA in input column
  
  
PBLscore<-apply_lookups(Path,PBLscore)

View(ddply(PBLscore,
           .(Fiscal.Year,Customer,SubCustomer),
           plyr::summarise,
           Action.Obligation=sum(Action.Obligation),
           Obligation.2016=sum(Obligation.2016)))

names(PBLscore)
str(PBLscore)


Coloration<-read.csv(
  paste("https://raw.githubusercontent.com/CSISdefense/Lookup-Tables/master/data/style/",
        "Lookup_Coloration.csv",sep=""),
  header=TRUE, sep=",", na.strings="", dec=".", strip.white=TRUE, 
  stringsAsFactors=FALSE
)


# debug(LatticePercentLineWrapper)
PBLscore$Graph<-TRUE





PBLscore$MaxOfIsPerformanceBasedLogistics<-factor(PBLscore$MaxOfIsPerformanceBasedLogistics,
                                                  levels=c(0
                                                           ,1
                                                  ),
                                                  labels=c("Not PBL"
                                                           ,"All PBL"
                                                  ),
                                                  ordered=TRUE)

PBLscore$MaxOfIsPerformanceBasedLogistics[is.na(PBLscore$MaxOfIsPerformanceBasedLogistics)]<-"Not PBL"


PBLscore$MaxOfIsOfficialPBL<-factor(PBLscore$MaxOfIsOfficialPBL,
                                    exclude=NULL,
                                    levels=c(1,
                                             0,
                                             NA
                                    ),
                                    labels=c("Official PBL"
                                             ,"Other"
                                             ,"Not PBL"
                                    ),
                                    ordered=TRUE)

PBLscore$MaxOfIsOfficialPBL[is.na(PBLscore$MaxOfIsOfficialPBL)]<-"Not PBL"
# 
# PBLscorePSC  <- read.csv(
#     paste("Data\\Contract_SP_ContractPBLscoreSubCustomerProdServ.txt", sep = ""),
#     header = TRUE, sep = "\t", dec = ".", strip.white = TRUE, 
#     na.strings = c("NULL","NA",""),
#     stringsAsFactors = TRUE
#     )
# 
# PBLscorePSC<-apply_lookups(Path,PBLscorePSC)
# names(PBLscorePSC)
# 
# PBLscorePSC$Graph<-TRUE
# 
# 
# PBLscorePSC$SubCustomer.component<-droplevels(PBLscorePSC$SubCustomer.component)
# PBLscorePSC$SubCustomer.component<-factor(PBLscorePSC$SubCustomer.component,
#                                                levels=c("Army","Navy","Air Force","DLA",
#                                                         "MDA","MilitaryHealth","Additional DoD Components"),
#                                                labels=c("Army","Navy","Air Force","DLA",
#                                                         "MDA","Military\nHealth","Additional\nDoD\nComponents"),
#                                                ordered=TRUE)
# 
# 
# PBLscorePSC$SubCustomer.detail<-droplevels(PBLscorePSC$SubCustomer.detail)
# PBLscorePSC$SubCustomer.detail<-factor(PBLscorePSC$SubCustomer.detail,
#                                                levels=c("Army","Navy","Air Force","DLA",
#                                                         "Other DoD"),
#                                                labels=c("Army","Navy","Air Force","DLA",
#                                                         "Other DoD"),
#                                                ordered=TRUE)
# 
# 
# 
# PBLscorePSC$MaxOfIsPerformanceBasedLogistics<-factor(PBLscorePSC$MaxOfIsPerformanceBasedLogistics,
#                                         levels=c(0
#                                                  ,1
#                                                  ),
#                                         labels=c("Not PBL"
#                                                  ,"All PBL"
#                                                  ),
#                                         ordered=TRUE)
# 
# PBLscorePSC$MaxOfIsPerformanceBasedLogistics[is.na(PBLscorePSC$MaxOfIsPerformanceBasedLogistics)]<-"Not PBL"
# 
# 
# PBLscorePSC$MaxOfIsOfficialPBL<-factor(PBLscorePSC$MaxOfIsOfficialPBL,
#                                     exclude=NULL,
#                                         levels=c(1,
#                                                  0,
#                                                  NA
#                                                  ),
#                                         labels=c("Official PBL"
#                                                  ,"Other"
#                                                  ,"Not PBL"
#                                                  ),
#                                         ordered=TRUE)
# 
# PBLscorePSC$MaxOfIsOfficialPBL[is.na(PBLscorePSC$MaxOfIsOfficialPBL)]<-"Not PBL"
# 
# 
# DLAPBLscorePSC<-PBLscorePSC[PBLscorePSC$SubCustomer=="DLA",]
# 
# 
# 
#   VAR.long.DF<-ddply(VAR.long.DF, .("Fiscal.Year","Customer","ProductOrServiceArea","ProductOrServiceCode" ,"ProductOrServiceCodeText"   ), transform, p=y.variable/sum(y.variable))

PBLscore$MaxOfPSCscore[is.na(PBLscore$MaxOfPSCscore)]<-0
PBLscore$LengthSingleScore<-PBLscore$LengthScore+PBLscore$MaxOfIsSingleAward
PBLscore$LengthSingleScore[PBLscore$LengthSingleScore==3]<-2

PBLscore<-replace_nas_with_unlabeled(PBLscore,"MajorCommandName")#,"Uncategorized"

PBLscore<-replace_nas_with_unlabeled(PBLscore,"ContractingOfficeName")#,"Uncategorized"


labels_and_colors<-prepare_labels_and_colors(PBLscore)
column_key<-csis360::get_column_key(PBLscore)
save(PBLscore,labels_and_colors,column_key,file="PBLscore.Rdata")
