
	CREATE DATABASE Labo11;
	GO
	
	-- Configurer un nouveau filegroup ici
	EXEC sp_configure filestream_access_level, 2 RECONFIGURE

	ALTER DATABASE Labo11
	ADD FILEGROUP FG_Images CONTAINS FILESTREAM;
	GO

	ALTER DATABASE Labo11
	ADD FILE (
		NAME = FG_Images,
		FILENAMe = 'C:\EspaceLabo\FG_Images'
	)
	TO FILEGROUP FG_Images
	GO