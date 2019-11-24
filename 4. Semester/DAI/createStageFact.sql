USE StageNorthwind
CREATE TABLE [dbo].[stage_fact_sales](
[C_ID] [int] NULL,
[E_ID] [int] NULL,
[P_ID] [int] NULL,
[D_ID] [int] NULL,
[CustomerID] [nchar](5) NULL,
[ProductID] [int] NULL,
[EmployeeID] [int] NULL,
[OrderDate] [datetime] NULL,
[Quantity] [bigint] NULL,
[SalesAmount] [decimal](18, 2) NULL
)
