USE [Coltur_Viajes_Dllo_Dllo]
GO
/****** Object:  UserDefinedFunction [dbo].[fnstrSplitLinea]    Script Date: 22/03/2015 10:38:01 a.m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER FUNCTION [dbo].[fnstrSplitLinea]
(
    @Expression NVARCHAR(max)
  , @Delimiter  NVARCHAR(max)
  , @INDEX      INT
)
RETURNS NVARCHAR(max)
AS
BEGIN
         DECLARE @RETURN  NVARCHAR(max)
                          ,@Pos     INT
                          ,@PrevPos INT
                          ,@I       INT
 

         IF       @Expression IS NULL 
                 OR @Delimiter IS NULL 
                 OR LEN(@Delimiter) = 0 OR @INDEX < 1
         BEGIN
                          SET @RETURN = NULL
         END
         ELSE IF @INDEX = 1 
                 BEGIN
                          SET @Pos = CHARINDEX(@Delimiter, @Expression, 1)
                          IF @Pos > 0 
                                   BEGIN
                                            SET @RETURN = LEFT(@Expression, @Pos - 1)
                          END
                 END 
         ELSE 
                 BEGIN
                          SET @Pos = 0
                          SET @I = 0
                               
                          WHILE (@Pos > 0 AND @I < @INDEX) OR @I = 0 
                                   BEGIN
                                            SET @PrevPos = @Pos
                                            SET @Pos = CHARINDEX(@Delimiter, @Expression, @Pos + LEN(@Delimiter))
                                            SET @I = @I + 1
                                   END
                          IF @Pos = 0 AND @I = @INDEX
                                   BEGIN
                                            SET @RETURN = SUBSTRING(@Expression, @PrevPos + LEN(@Delimiter), LEN(@Expression))
                                   END
                          ELSE IF @Pos = 0 AND @I <> @INDEX
                                   BEGIN
                                            SET @RETURN = NULL
                                   END
                          ELSE 
                                   BEGIN
                                            SET @RETURN = SUBSTRING(@Expression, @PrevPos + LEN(@Delimiter), @Pos - @PrevPos - LEN(@Delimiter))
                                   END
                 END
 
         RETURN @RETURN
END

