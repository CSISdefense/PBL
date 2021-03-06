USE [DIIG]
GO
/****** Object:  Table [Project].[RDTEid]    Script Date: 3/13/2017 2:37:17 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [Project].[RDTEid](
	[RDTEid] [int] IDENTITY(1,1) NOT NULL,
	[TopProgramElement] [varchar](10) NULL,
	[TopProgramElementTitle] [varchar](80) NULL,
	[DefenseServiceIdentifier] [varchar](3) NULL,
	[Classified] [varchar](20) NULL,
	[isHarrisonID] [bit] NULL,
PRIMARY KEY CLUSTERED 
(
	[RDTEid] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
