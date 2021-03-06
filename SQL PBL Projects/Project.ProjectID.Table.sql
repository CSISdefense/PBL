USE [DIIG]
GO
/****** Object:  Table [Project].[ProjectID]    Script Date: 3/13/2017 2:37:17 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [Project].[ProjectID](
	[ProjectID] [int] IDENTITY(1,1) NOT NULL,
	[ProjectName] [varchar](30) NULL,
	[ProjectPrettyName] [nvarchar](255) NULL,
	[ProjectAbbreviation] [varchar](4) NOT NULL,
	[IsJointDevelopmentCaseStudy] [bit] NULL,
	[CSISmodifiedDate] [datetime2](7) NOT NULL,
	[CSISmodifiedBy] [varchar](150) NOT NULL,
 CONSTRAINT [PK__ProjectI__761ABED0B116866B] PRIMARY KEY CLUSTERED 
(
	[ProjectID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [Project].[ProjectID] ADD  CONSTRAINT [DF__ProjectID__CSISm__1DF12CC8]  DEFAULT (getdate()) FOR [CSISmodifiedDate]
GO
ALTER TABLE [Project].[ProjectID] ADD  CONSTRAINT [DF__ProjectID__CSISm__1EE55101]  DEFAULT (suser_sname()) FOR [CSISmodifiedBy]
GO
