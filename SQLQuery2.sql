USE onlinelibrary;
SELECT * FROM Kitaplar

CREATE FUNCTION booksnumber_bygenre(@kitapTuru INT)
RETURNS INT
	BEGIN
		DECLARE @Result INT
		SELECT @Result=COUNT(*) FROM Kitaplar WHERE kitapTuruId=@kitapTuru
		RETURN @Result
	END


SELECT dbo.booksnumber_bygenre(2) AS Result


CREATE FUNCTION maxBook_instock()
RETURNs NVARCHAR(50)
AS
BEGIN
	DECLARE @kitap VARCHAR(40), @kitapisbn INT;
	SELECT @kitapisbn=isbn FROM Stok WHERE adet=(SELECT MAX(adet) FROM Stok)
	SELECT @kitap=kitapAdi FROM Kitaplar WHERE isbn=@kitapisbn
	RETURN @kitap
END

SELECT dbo.maxBook_instock()


CREATE FUNCTION gecerliEPosta(@adres VARCHAR(50))
RETURNS bit
BEGIN
	DECLARE @atIndex INT, @comIndex INT, @mailCount INT, @sonuc bit
	SELECT @sonuc=1
	SELECT @atIndex=CHARINDEX('@',@adres)
	IF (@atIndex=0) SELECT @sonuc=0
	SELECT @comIndex=CHARINDEX('.com',@adres)
	IF ((@comIndex=0) OR (@atIndex>@comIndex)) SELECT @sonuc=0
	SELECT @mailCount=COUNT(*) FROM Kullanici WHERE @adres=email
	IF (@mailCount!=0) SELECT @sonuc=0
	RETURN @sonuc
END


CREATE PROCEDURE Kitaplar_ReadAll
AS
BEGIN
	SET NOCOUNT ON;
	SELECT * FROM Kitaplar;
END


EXEC Kitaplar_ReadAll

CREATE PROCEDURE ekleKullanici
(@ad VARCHAR(50), @soyad VARCHAR(50), @email VARCHAR(50), @adres NTEXT, @telno CHAR(15), @password CHAR(10))
AS BEGIN
	INSERT INTO Kullanici(ad,soyad,email,adres,telno,password) VALUES(@ad,@soyad,@email,@adres,@telno,@password)
END

EXEC ekleKullanici @ad='Faruk',@soyad='ERDEM',@email='omer.erdem@gmail.com',@adres='Istanbul',@telno='12345678912345',@password='omer123'

CREATE PROCEDURE getirTumKullanicilar
AS BEGIN
	SELECT * FROM Kullanici
END

ALTER PROCEDURE getirTumKullanicilar
AS BEGIN
	SELECT * FROM Kullanici ORDER BY id DESC
END

EXEC getirTumKullanicilar