USE [DIIG]
GO
/****** Object:  Table [Project].[SystemEquipmentCodetoProjectIDhistory]    Script Date: 3/13/2017 2:37:17 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [Project].[SystemEquipmentCodetoProjectIDhistory](
	[systemequipmentcode] [varchar](4) NOT NULL,
	[systemequipmentcodeText] [nvarchar](255) NULL,
	[Unseperated] [varchar](255) NULL,
	[StartFiscalYear] [smallint] NULL,
	[EndFiscalYear] [smallint] NULL,
	[ProjectID] [int] NULL,
	[CSISmodifiedDate] [datetime2](7) NOT NULL,
	[CSISmodifiedBy] [varchar](150) NOT NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [Project].[SystemEquipmentCodetoProjectIDhistory] ADD  DEFAULT (getdate()) FOR [CSISmodifiedDate]
GO
ALTER TABLE [Project].[SystemEquipmentCodetoProjectIDhistory] ADD  DEFAULT (suser_sname()) FOR [CSISmodifiedBy]
GO
ALTER TABLE [Project].[SystemEquipmentCodetoProjectIDhistory]  WITH CHECK ADD  CONSTRAINT [FK__SystemEqu__Proje__6557CDEA] FOREIGN KEY([ProjectID])
REFERENCES [Project].[ProjectID] ([ProjectID])
GO
ALTER TABLE [Project].[SystemEquipmentCodetoProjectIDhistory] CHECK CONSTRAINT [FK__SystemEqu__Proje__6557CDEA]
GO
ALTER TABLE [Project].[SystemEquipmentCodetoProjectIDhistory]  WITH CHECK ADD  CONSTRAINT [FK__SystemEqu__Proje__71BDA4CF] FOREIGN KEY([ProjectID])
REFERENCES [Project].[ProjectID] ([ProjectID])
GO
ALTER TABLE [Project].[SystemEquipmentCodetoProjectIDhistory] CHECK CONSTRAINT [FK__SystemEqu__Proje__71BDA4CF]
GO
ALTER TABLE [Project].[SystemEquipmentCodetoProjectIDhistory]  WITH CHECK ADD  CONSTRAINT [FK__SystemEqu__Proje__749A117A] FOREIGN KEY([ProjectID])
REFERENCES [Project].[ProjectID] ([ProjectID])
GO
ALTER TABLE [Project].[SystemEquipmentCodetoProjectIDhistory] CHECK CONSTRAINT [FK__SystemEqu__Proje__749A117A]
GO
ALTER TABLE [Project].[SystemEquipmentCodetoProjectIDhistory]  WITH CHECK ADD  CONSTRAINT [FK__SystemEqu__Proje__758E35B3] FOREIGN KEY([ProjectID])
REFERENCES [Project].[ProjectID] ([ProjectID])
GO
ALTER TABLE [Project].[SystemEquipmentCodetoProjectIDhistory] CHECK CONSTRAINT [FK__SystemEqu__Proje__758E35B3]
GO
ALTER TABLE [Project].[SystemEquipmentCodetoProjectIDhistory]  WITH CHECK ADD  CONSTRAINT [FK__SystemEqu__Proje__795EC697] FOREIGN KEY([ProjectID])
REFERENCES [Project].[ProjectID] ([ProjectID])
GO
ALTER TABLE [Project].[SystemEquipmentCodetoProjectIDhistory] CHECK CONSTRAINT [FK__SystemEqu__Proje__795EC697]
GO
ALTER TABLE [Project].[SystemEquipmentCodetoProjectIDhistory]  WITH CHECK ADD  CONSTRAINT [FK__SystemEqu__Proje__7A52EAD0] FOREIGN KEY([ProjectID])
REFERENCES [Project].[ProjectID] ([ProjectID])
GO
ALTER TABLE [Project].[SystemEquipmentCodetoProjectIDhistory] CHECK CONSTRAINT [FK__SystemEqu__Proje__7A52EAD0]
GO
ALTER TABLE [Project].[SystemEquipmentCodetoProjectIDhistory]  WITH CHECK ADD FOREIGN KEY([systemequipmentcode])
REFERENCES [Project].[SystemEquipmentCode] ([systemequipmentcode])
GO
ALTER TABLE [Project].[SystemEquipmentCodetoProjectIDhistory]  WITH CHECK ADD FOREIGN KEY([systemequipmentcode])
REFERENCES [Project].[SystemEquipmentCode] ([systemequipmentcode])
GO
ALTER TABLE [Project].[SystemEquipmentCodetoProjectIDhistory]  WITH CHECK ADD FOREIGN KEY([systemequipmentcode])
REFERENCES [Project].[SystemEquipmentCode] ([systemequipmentcode])
GO
ALTER TABLE [Project].[SystemEquipmentCodetoProjectIDhistory]  WITH CHECK ADD FOREIGN KEY([systemequipmentcode])
REFERENCES [Project].[SystemEquipmentCode] ([systemequipmentcode])
GO
ALTER TABLE [Project].[SystemEquipmentCodetoProjectIDhistory]  WITH CHECK ADD FOREIGN KEY([systemequipmentcode])
REFERENCES [Project].[SystemEquipmentCode] ([systemequipmentcode])
GO
ALTER TABLE [Project].[SystemEquipmentCodetoProjectIDhistory]  WITH CHECK ADD FOREIGN KEY([systemequipmentcode])
REFERENCES [Project].[SystemEquipmentCode] ([systemequipmentcode])
GO
