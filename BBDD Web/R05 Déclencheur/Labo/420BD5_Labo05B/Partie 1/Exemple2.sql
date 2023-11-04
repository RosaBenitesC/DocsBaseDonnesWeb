GO
CREATE TRIGGER ExTriggers.utrg_JoueursPointsEquipe
ON ExTriggers.Joueur
AFTER UPDATE
AS
BEGIN
	IF UPDATE(Points)
	BEGIN
		DECLARE @EquipeID int;
		SELECT @EquipeID = EquipeID FROM inserted;
		UPDATE ExTriggers.EquipeID
		SET Points = ( SELECT SUM(Points) 
		               FROM ExTriggers.Joueur
					   WHERE EquipeID = @EquipeID )
		WHERE EquipeID = @EquipeID;
    END
END
GO	


					 