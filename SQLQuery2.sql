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