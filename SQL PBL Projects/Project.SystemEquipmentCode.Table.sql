USE [DIIG]
GO
/****** Object:  Table [Project].[SystemEquipmentCode]    Script Date: 3/13/2017 2:37:17 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [Project].[SystemEquipmentCode](
	[Unseperated] [varchar](255) NULL,
	[systemequipmentcode] [varchar](4) NOT NULL,
	[systemequipmentcodeText] [nvarchar](255) NULL,
	[IsIdentifiedSystemEquipment] [bit] NOT NULL,
	[IsJointDevelopmentCaseStudy] [bit] NULL,
 CONSTRAINT [PK_systemequipmentcode NO PK] PRIMARY KEY CLUSTERED 
(
	[systemequipmentcode] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [Project].[SystemEquipmentCode] ADD  DEFAULT ((1)) FOR [IsIdentifiedSystemEquipment]
GO
ALTER TABLE [Project].[SystemEquipmentCode] ADD  DEFAULT ((0)) FOR [IsJointDevelopmentCaseStudy]
GO
