
USE Labo05
GO

--  PARTIE 1  :
--  CRÉATION DU TRIGGER
IF OBJECT_ID('Biens.iutrg_BienInsertUpdate') IS NOT NULL DROP TRIGGER Biens.iutrg_BienInsertUpdate
GO
CREATE TRIGGER Biens.iutrg_BienInsertUpdate
ON Biens.Bien
AFTER INSERT, UPDATE
AS
BEGIN
	DECLARE @action CHAR(1);
	
	SET @action = 
	CASE
		WHEN EXISTS(SELECT * FROM inserted) AND EXISTS (SELECT * FROM deleted) THEN 'U'
		WHEN EXISTS(SELECT * FROM inserted) AND NOT EXISTS (SELECT * FROM deleted) THEN 'I'
	END

	IF @action = 'I'
		BEGIN
			INSERT INTO Biens.HistoriqueBienPrix (BienID, DatePrixDemande, PrixDemande)
			SELECT BienID, DateInscription, PrixDemande FROM inserted
		END
	ELSE
		BEGIN
			IF UPDATE(PrixDemande)
			BEGIN
				INSERT INTO Biens.HistoriqueBienPrix (BienID, DatePrixDemande, PrixDemande)
				SELECT BienID, GETDATE(), PrixDemande FROM inserted
			END

			IF UPDATE(DateVente)
			BEGIN
				INSERT INTO Biens.ArchivesBienVendu (BienID, AgentIDInscripteur, AnneeConstruction, DateInscription, PrixDemande, Statut, PrixVendu, DateVente, AdresseID,AgentIDVendeur, DateMAJ)
				SELECT BienID, AgentIDInscripteur, AnneeConstruction, DateInscription, PrixDemande, Statut, PrixVendu, DateVente, AdresseID,AgentIDVendeur, GetDate() FROM inserted
			
				DELETE FROM Biens.Visite WHERE BienID IN (SELECT BienID FROM inserted)
				
				DELETE FROM Biens.Bien WHERE BienID IN (SELECT BienID FROM inserted)

				INSERT INTO  Biens.HistoriqueBienPrix (BienID, DatePrixDemande, PrixDemande)
				SELECT BienID, DateVente, PrixVendu FROM inserted
			END
		END
END
GO

-- TESTS    TESTS    TESTS    TESTS
-- ATTENTION, il y a présentement 43 biens dans la base de données

-- 1er déclencheur
-- Sur la table Bien
-- Suite à un INSERT ou un UPDATE sur les champs PrixDemande et DateVente



-- TESTS    TESTS    TESTS    TESTS
-- ATTENTION, il y a présentement 43 biens dans la base de données

-- Normalement, on ne doit pas mettre * dans nos requêtes mais pour nos tests c'est correct car ils ne seront pas en ligne.


------ TEST: INSERT
--		Donc je vais dans mes tests insérer le 44ième bien
--		Je pourrai faire des tests bien ciblés avec la clause WHERE BienID = 44
--		Lors d'un INSERT, les tables Bien et HistoriqueBienPrix sont affectées
SELECT 'AVANT INSERT ', * FROM Biens.HistoriqueBienPrix WHERE BienID =44

SELECT 'AVANT INSERT', * FROM [Biens].[Bien] WHERE BienID = 44

--		Insertion du bien 44
INSERT INTO  Biens.Bien (AgentIDInscripteur, AdresseID, DateInscription, PrixDemande, Statut)
VALUES (1,  1,  GETDATE(), 450000, 'Affiché')
	   
SELECT  'APRES INSERT', * FROM Biens.HistoriqueBienPrix WHERE BienID = 44

SELECT 'APRES INSERT', * FROM [Biens].[Bien] WHERE BienID = 44


GO

------- TEST: UPDATE PrixDemande
--      On veut changer le prix demandé pour le bien 44
--      Je pourrai faire des tests bien ciblés avec la clause WHERE BienID = 44
--		Lors d'un INSERT, les tables Bien et HistoriqueBienPrix sont affectées


--  Comme je viens de voir les valeurs pour le BienID 44 dans ces deux tables, je peux tout de suite changer le prix demandé


UPDATE Biens.Bien SET PrixDemande=1000000 WHERE BienID=44

SELECT 'APRES UPDATE PrixDemande', * FROM Biens.HistoriqueBienPrix  WHERE BienID = 44

SELECT 'APRES UPDATE PrixDemande', * FROM [Biens].[Bien] WHERE BienID = 44



------- TEST: UPDATE DateVente
--      On veut changer la DateVente, le PrixVendu et le Statut  pour le bien 44
--      Je pourrai faire des tests bien ciblés avec la clause WHERE BienID = 44
--		Lors d'un INSERT, les tables Bien , HistoriqueBienPrix, ArchivesBienVendu et Visite sont affectées


--      Je viens de voir les valeurs de Bien et HistoriqueBienPrix pour le bien ID 44
--      Par contre, je dois montrer qu'il n'y a rien pour le moment dans la table ArchivesBienVendu pour le bien ID 44
SELECT 'AVANT UPDATE DateVente', * FROM Biens.ArchivesBienVendu WHERE BienID=44

--      Et je dois montrer s'il y a des visites pour ce bien. Je sais qu'il n'y en a pas car je viens de créer ce bien.
--      Je vais ajouter avant mon test 2 visites pour ce bien.
INSERT INTO Biens.Visite (DateVisite, BienID, AgentIDVisiteur, CommentaireAgent, ReactionClient)
VALUES (GETDATE(), 44, 3, 'Super propre','Wow'),(GETDATE(), 44,4 , 'Le gros luxe','Yack')

SELECT 'AVANT UPDATE DateVente',* FROM Biens.Visite WHERE BienID = 44 ORDER BY DateVisite DESC


GO

UPDATE Biens.Bien
SET Statut = 'Vendu', 
DateVente = GETDATE(),
PrixVendu = 1555555,
AgentIDVendeur = 1
WHERE BienID = 44
GO


SELECT 'APRES UPDATE DateVente',* FROM Biens.Bien WHERE BienID = 44
SELECT 'APRES UPDATE DateVente',* FROM Biens.HistoriqueBienPrix WHERE BienID = 44 ORDER BY DatePrixDemande DESC
SELECT 'APRES UPDATE DateVente',* FROM Biens.Visite WHERE BienID = 44 ORDER BY DateVisite DESC
SELECT 'APRES UPDATE DateVente',* FROM Biens.ArchivesBienVendu WHERE BienID = 44
GO

------- TEST: UPDATE qui n'est pas sur les champs PrixDemande ET DateVente

--     Comme le bien 44 a été vendu, je vais modifier le bien 43 et je ferai des tests ciblés avec WHERE BienID = 43
--     Je vais montrer que seule la table Bien est affectée par le changement
SELECT 'AVANT UPDATE AUTRE QUE PrixDemande ET DateVente', * FROM Biens.HistoriqueBienPrix WHERE BienID=43

SELECT 'AVANT UPDATE AUTRE QUE PrixDemande ET DateVente', * FROM [Biens].[Bien] WHERE BienID=43

SELECT 'AVANT UPDATE AUTRE QUE PrixDemande ET DateVente', * FROM Biens.ArchivesBienVendu WHERE BienID=43

SELECT 'AVANT UPDATE AUTRE QUE PrixDemande ET DateVente',* FROM Biens.Visite WHERE BienID = 43 ORDER BY DateVisite DESC

UPDATE Biens.Bien SET AnneeConstruction=2023 WHERE BienID=43

SELECT 'APRES UPDATE AUTRE QUE PrixDemande ET DateVente', * FROM Biens.HistoriqueBienPrix WHERE BienID=43

SELECT 'APRES UPDATE AUTRE QUE PrixDemande ET DateVente', * FROM [Biens].[Bien] WHERE BienID=43

SELECT 'APRES UPDATE AUTRE QUE PrixDemande ET DateVente', * FROM Biens.ArchivesBienVendu WHERE BienID=43

SELECT 'APRES UPDATE AUTRE QUE PrixDemande ET DateVente',* FROM Biens.Visite WHERE BienID = 43 ORDER BY DateVisite DESC


-- PARTIE 2  :



-- Créez en premier une fonction qui retournera l'id de l'agent le plus ancien qui a le  moins de biens à gérer mais qui n'est pas l'agent à remplacer
--  IMPORTANT  un bien à gérer est un bien qui n'est pas vendu

IF OBJECT_ID('Agences.ufn_agentPlusAncienMoinsDeBiens') IS NOT NULL DROP FUNCTION Agences.ufn_agentPlusAncienMoinsDeBiens
GO
CREATE FUNCTION Agences.ufn_agentPlusAncienMoinsDeBiens(@saufAgentId INT) RETURNS INT
BEGIN
	DECLARE @AgentID INT

	SET @AgentID = 
	(SELECT TOP (1) AgentIDVendeur
	FROM Biens.Bien B
	inner join Agences.Agent A
	ON B.AgentIDVendeur = A.agentID
	WHERE prixVendu IS NULL AND AgentIDVendeur != @saufAgentID AND A.EstActif = 1
	GROUP BY AgentIDVendeur
	ORDER BY COUNT(BienID), AgentIDVendeur)
	
	RETURN @AgentID
END
GO

-- Test fonction
SELECT Agences.ufn_agentPlusAncienMoinsDeBiens(1)

-- CRÉATION DU TRIGGER 
-- Votre trigger devra utiliser la fonction que vous venez de créer
IF OBJECT_ID('Agences.trg_AgentDelete') IS NOT NULL DROP TRIGGER Agences.trg_AgentDelete
GO
CREATE TRIGGER Agences.trg_AgentDelete 
ON Agences.Agent
INSTEAD OF DELETE 
AS
BEGIN
	DECLARE @AgentIDQuiPart INT, @AgentPlusAncienMoinsBiens INT
	SELECT @AgentIDQuiPart = AgentID FROM deleted


	SELECT @AgentPlusAncienMoinsBiens = Agences.ufn_agentPlusAncienMoinsDeBiens(@AgentIDQuiPart)

	UPDATE Biens.Bien
	SET AgentIDVendeur = @AgentPlusAncienMoinsBiens
	WHERE AgentIDVendeur = @AgentIDQuiPart

	UPDATE Agences.Agent
	SET EstActif = 0
	WHERE AgentID = @AgentIDQuiPart
END
GO


-- TESTS    TESTS     TESTS     TESTS     TESTS
-- Nous allons faire le test que l'agentID 1 quitte l'agence
-- Test pre-trigger
-- Nous allons faire le test que l'agentID 1 quitte l'agence

DECLARE @AgentPlusAncienMoinsBiens int
SELECT @AgentPlusAncienMoinsBiens = Agences.ufn_agentPlusAncienMoinsDeBiens(1)
SELECT @AgentPlusAncienMoinsBiens

SELECT AgentIDVendeur, COUNT(BienID) AS NbBiens
FROM Biens.Bien
WHERE prixVendu IS NULL AND AgentIDVendeur IN (1, @AgentPlusAncienMoinsBiens)
GROUP BY AgentIDVendeur
ORDER BY COUNT(BienID) DESC


DELETE FROM Agences.Agent
WHERE AgentID = 1


-- Test post-trigger
SELECT AgentIDVendeur, COUNT(BienID) AS NbBiens
FROM Biens.Bien
WHERE prixVendu IS NULL AND AgentIDVendeur IN (1, @AgentPlusAncienMoinsBiens)
GROUP BY AgentIDVendeur
ORDER BY COUNT(BienID) DESC
GO