drop Procedure [dbo].[sp_TaoTaiKhoan]
go

SET QUOTED_IDENTIFIER ON
go
SET ANSI_NULLS ON
go
CREATE PROCEDURE [dbo].[sp_TaoTaiKhoan] @login varchar(50),
	@pass varchar(50),
	@username varchar(50),
	@role varchar(50)
AS
BEGIN
	DECLARE @RET INT
	EXEC @RET = SP_ADDLOGIN @login,@pass,'QLNHAPDOTHETHAO'
	
	IF(@RET =1) --LOGIN NAME TRUNG
	RETURN 1
	
	EXEC @RET = SP_GRANTDBACCESS @login,@username
	IF (@RET =1) --USER TRUNG
	BEGIN
		EXEC SP_DROPLOGIN @login
		RETURN 2
	END
	EXEC sp_addrolemember @role,@username
	IF(@ROLE='CONGTY')
		BEGIN
			
			EXEC sp_addsrvrolemember @login,'SecurityAdmin'
			EXEC sp_addsrvrolemember @login, 'ProcessAdmin'
		END

	IF (@role ='CHINHANH')
		BEGIN
			EXEC sp_addsrvrolemember @login,'sysadmin'
			EXEC sp_addsrvrolemember @login,'SecurityAdmin'
			EXEC sp_addsrvrolemember @login, 'ProcessAdmin'
		END
	IF(@ROLE ='USER')
		BEGIN
			EXEC sp_addsrvrolemember @login,'ProcessAdmin'
		END
	END
	
go
