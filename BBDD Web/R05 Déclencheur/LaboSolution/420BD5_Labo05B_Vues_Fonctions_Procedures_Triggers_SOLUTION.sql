--	R�pondez aux questions suivantes, 
--  Faites des tests en ins�rant ou modifiant des donn�es. 
--  N�oubliez pas de laisser des traces de tes tests.



USE [ThesEtTisanes];


-- 1 A)   Cr�ez une vue pour voir tous les types de recettes, toutes les recettes et leurs ingr�dients avec leurs quantit�s dans chaque recette
--        Incluez tous les id des tables utilis�es.


GO
CREATE VIEW Recettes.vw_Recettes AS
	SELECT TR.NomTypeRecette, R.NomRecette, IR.Quantite, I.NomIngredientCommun, R.RecetteID, TR.TypeRecetteID, IR.IngredientID ,IR.IngredientRecetteID 
	FROM Recettes.TypeRecette TR
	INNER JOIN Recettes.Recette R
	ON R.TypeRecetteID = TR.TypeRecetteID
	INNER JOIN Recettes.IngredientRecette IR
	ON IR.RecetteID = R.RecetteID
	INNER JOIN Ingredients.Ingredient I
	ON I.IngredientID = IR.IngredientID
GO




----1 B)    Puis utilisez cette vue pour obtenir le r�sultat suivant:

----NomTypeRecette               NomRecette                                     Quantite               NomIngredientCommun
-------------------------------- ---------------------------------------------- ---------------------- --------------------------------------------------
----Th�s Indiens                 Th� d�Assam � la cardamone                     1/4 de tasse           Cassonade
----Th�s Indiens                 Th� d�Assam � la cardamone                     6                      fruits de cardamone
----Th�s Indiens                 Th� d�Assam � la cardamone                     3 1/2 tasses           eau
--...
----Tisanes aux fruits           Tisane de citron, d�anis et de fenouil         1 tasse, bouillante    eau
----Tisanes aux fruits           Tisane de citron, d�anis et de fenouil         1/2 c. � soupe         graines de fenouil
----Tisanes aux fruits           Tisane de citron, d�anis et de fenouil         1 c. � th�             framboisier

----(34�ligne(s) affect�e(s))

SELECT NomTypeRecette, NomRecette, Quantite, NomIngredientCommun 
FROM Recettes.vw_Recettes
GO




-- 2)	Cr�ez une proc�dure pour voir toutes les recettes qui contiennent un ingr�dient donn� en param�tre. 
--      Cette proc�dure devra utiliser la vue cr��e en 1).

--  Voici le r�sultat que vous devriez obtenir avec id 19 (cassonade)

----NomTypeRecette                                     NomRecette
------------------------------------------------------ -------------------------------------
----Th�s Indiens                                       Th� d�Assam � la cardamone
----Th�s Indiens                                       Th� �pic� de l�Himalaya

----(2�ligne(s) affect�e(s))

GO
CREATE PROCEDURE Recettes.usp_ListeRecettesIngredient
	@IngredientID int
AS

	SELECT DISTINCT NomTypeRecette, NomRecette 
	FROM Recettes.vw_Recettes
	WHERE IngredientID = @IngredientID 
GO





EXEC Recettes.usp_ListeRecettesIngredient
	@IngredientID = 18
GO





-- 3 A)	Faites une fonction qui calculera le nombre d�ingr�dients diff�rents qu�offre un fournisseur et retournera cette valeur.
GO
CREATE FUNCTION Fournisseurs.ufn_NBIngredientsDifferentsParFournisseur
(@FournisseurID int)
RETURNS int
AS
BEGIN
	DECLARE @NBIngredients int;

	SELECT @NBIngredients = ISNULL(COUNT(DISTINCT IngredientID), 0)
	FROM Fournisseurs.FournisseurIngredient
	WHERE FournisseurID = @FournisseurID

	RETURN @NBIngredients
END
GO
-- 3 B) Utilisez cette fonction pour obtenir le nombre d'ingr�dients diff�rents offerts par le fournisseur dont l'id est 1
SELECT Fournisseurs.ufn_NBIngredientsDifferentsParFournisseur(1) AS 'Nb ingr�dients diff�rents pour le fournisseur dont l''id est 1'
GO





   
-- 4 A)	Faites un ALTER TABLE pour ajouter � la table Fournisseur un champ entier NbIngredients 
--      qui contiendra le nombre d'ingr�dients diff�rents qu�offre un fournisseur
ALTER TABLE Fournisseurs.Fournisseur
ADD NbIngredients int;
GO



-- 4 B) Utilisez cette fonction pour mettre � jour le champs NbIngredients � l�entit� Fournisseur.	

UPDATE Fournisseurs.Fournisseur
SET NbIngredients =  Fournisseurs.ufn_NBIngredientsDifferentsParFournisseur(FournisseurID)
GO



-- 4 C) Faites ensuite un SELECT de la table Fournisseur pour v�rifier que vous obtenez le r�sultat suivant:
----FournisseurID NomFournisseur                   NbIngredients
----------------- ----------------------------- -- -------------
----1             Grossiste �pices Anatol          30
----2             Herboristerie Desjardins         5

----(2�ligne(s) affect�e(s))
SELECT FournisseurID, NomFournisseur, NbIngredients 
FROM Fournisseurs.Fournisseur
GO





-- 5)	Faites les scripts DDL pour  ajouter une entit� IngredientsTransaction dans le sch�ma Ingredients
--      qui enregistrera les modifications qui sont faites dans les quantit�s en inventaire des ingr�dients. 

--      Voici des exemples de donn�es que pourraient contenir 2 enregistrements de cette table :
--			IngredientsTransactionsID		IngredientID	QtyEnTransaction	Prix	DateEtHeureTransaction
--					1						1				10					4,25	2020215 8:00					
--                  2						1				-4					8,00	2020215 10:00

		 			

--      N'oubliez pas aussi de faire une contrainte de cl� �trang�re pour la relation Ingredient qui aura plusieurs IngredientsTransaction
GO
CREATE TABLE Ingredients.IngredientsTransaction(
IngredientsTransactionID int IDENTITY (1,1),
IngredientID int NOT NULL,
QtyEnTransaction int NOT NULL,
Prix decimal(5,2) NOT NULL,
DateETHeureTransaction datetime NOT NULL,
CONSTRAINT PK_IngredientsTransaction_IngredientsTransactionID PRIMARY KEY (IngredientsTransactionID)
);
GO

ALTER TABLE Ingredients.IngredientsTransaction ADD CONSTRAINT FK_IngredientsTransaction_IngredientID
FOREIGN KEY (IngredientID) REFERENCES Ingredients.Ingredient(IngredientID)
GO

INSERT INTO Ingredients.IngredientsTransaction (IngredientID, QtyEnTransaction, Prix, DateETHeureTransaction)
VALUES
(1, 10, 4.25, GETDATE()),
(1, -4, 8.00, GETDATE());
GO


-- 6)	Faites le script DDL pour cr�er une entit� qui s�appelera Fournisseurs.ContactHist qui sera utilis�e 
--      pour enregistrer les donn�es d�un contact qui quitte l�emploi d�un fournisseur.
--      Assurez-vous d'y inclure un champ pour la date de l'enregistrement de cette information

GO
CREATE TABLE Fournisseurs.ContactHist(
	ContactHistID int IDENTITY (1,1),
	FournisseurID int NOT NULL,
	Nom varchar(50) NULL,
	Prenom varchar(50) NULL,
	TelCell varchar(20) NULL,
	Courriel varchar(50) NULL,
	ContactID int NOT NULL,
	DateMAJ datetime
	CONSTRAINT PK_ContactHist_ContactHistID PRIMARY KEY (ContactHistID)
);
GO
ALTER TABLE Fournisseurs.ContactHist ADD CONSTRAINT FK_ContactHist_FournisseurID
FOREIGN KEY (FournisseurID) REFERENCES Fournisseurs.Fournisseur(FournisseurID)
GO 
   
-- 7)	Faites le d�clencheur  pour que lors de la suppression d'un contact d'un fournisseur, 
--      on ajoutera ses donn�es dans l'entit� cr��e en 10 avec sa date de d�part.
GO
CREATE TRIGGER Fournisseurs.Contact_dtrSupprimerContact
ON Fournisseurs.Contact
AFTER DELETE
AS
BEGIN
	INSERT INTO Fournisseurs.ContactHist (FournisseurID, ContactID,  Nom, Prenom, TelCell, Courriel, DateMAJ)
	SELECT FournisseurID, ContactID,Nom, Prenom,TelCell,Courriel,GETDATE()  FROM deleted;
END
GO


-- Pour tester:
-- Ajoutez un nouveau contact pour un fournisseur
INSERT INTO Fournisseurs.Contact ( Nom, Prenom, TelCell, Courriel, FournisseurID) VALUES ('Tremblay', 'Mario', '123-123-1234','mario.tremblay@anatolspices.com',1);
GO

-- Affichez ce nouveau contact
-- Supprimez ce nouveau contact
-- V�rifiez que ce nouveau contact n'existe plus dans la table Contact
-- Faites la requ�te pour v�rifier le contenu de [Fournisseurs].[ContactHist] apr�s cette suppression
SELECT 0 as 'AVANT DELETE', ContactID, Nom, Prenom, TelCell, Courriel, FournisseurID FROM Fournisseurs.Contact WHERE ContactID=3;
GO

SELECT 0 as 'AVANT DELETE', ContactHistID, FournisseurID, ContactID,  Nom, Prenom, TelCell, Courriel, DateMAJ FROM Fournisseurs.ContactHist
ORDER BY ContactHistID DESC
GO

DELETE FROM Fournisseurs.Contact
WHERE ContactID=3;
GO


SELECT 1 as 'APR�S DELETE', ContactID, Nom, Prenom, TelCell, Courriel, FournisseurID FROM Fournisseurs.Contact WHERE ContactID=3;
GO

SELECT 1 as 'APR�S DELETE', ContactHistID, FournisseurID, ContactID,  Nom, Prenom, TelCell, Courriel, DateMAJ FROM Fournisseurs.ContactHist
ORDER BY ContactHistID DESC
GO




-- 8)	Ajoutez un sch�ma appell� Commandes.

GO
CREATE SCHEMA Commandes;
GO



-- 9)   Faites le script DDL pour  ajouter une entit� dans le sch�ma cr�� en 6) qui s�appellera Commande 
--      et qui sera utilis�e pour enregistrer la date et l�heure d�une commande qu�on voudrait faire � un fournisseur 
--      et son �tat qui peut prendre les diff�rentes valeurs suivantes  : ( Pass�e, AttenteDeLivraison, Livr�e,  AttenteDePaiement, Pay�e).  

---     Assurez-vous que seules les valeurs cit�es entre parenth�ses sont valides pour cet �tat de commande.

---     N'oubliez pas aussi de faire une contrainte de cl� �trang�re pour la relation  Un Fournisseur a plusieurs Commande 

O
CREATE TABLE Commandes.Commande(
CommandeID int IDENTITY (1,1),
Etat nvarchar(20) NOT NULL,
DateHeureCommande datetime NOT NULL,
FournisseurID int NOT NULL,
CONSTRAINT PK_Commandes_CommandeID PRIMARY KEY (CommandeID)
);
GO

ALTER TABLE Commandes.Commande
ADD CONSTRAINT FK_Commande_FournisseurID
FOREIGN KEY (FournisseurID) REFERENCES Fournisseurs.Fournisseur(FournisseurID)
GO

ALTER TABLE Commandes.Commande
ADD CONSTRAINT CK_Commande_Etat CHECK
(Etat in ('pass�e', 'attenteDeLivraison', 'livr�e', 'enPaiement', 'pay�e'))
GO



-- 10)	Faites le script DDL pour ajouter une deuxi�me entit� dans le sch�ma cr�� en 6) qui s�appelera DetailsCommande 
--      et qui sera utilis�e pour enregistrer  les ingr�dients command�s dans une commande, leurs quantit�s et leurs prix de vente.
--      N'oubliez pas aussi de faire une contrainte de cl� �trang�re pour la relation  une Commande a plusieurs DetailsCommande

GO
CREATE TABLE Commandes.DetailsCommande(
DetailsCommandeID int IDENTITY (1,1),
Quantite int NOT NULL,
PrixVente decimal(5,2) NOT NULL,
CommandeID int NOT NULL,
IngredientID int NOT NULL,
CONSTRAINT PK_Commandes_DetailsCommandeID PRIMARY KEY (DetailsCommandeID)
);
GO

ALTER TABLE Commandes.DetailsCommande
ADD CONSTRAINT FK_Commande_CommandeID FOREIGN KEY (CommandeID) REFERENCES Commandes.Commande(CommandeID)
GO

ALTER TABLE Commandes.DetailsCommande
ADD CONSTRAINT FK_Commande_IngredientID FOREIGN KEY (IngredientID) REFERENCES Ingredients.Ingredient(IngredientID)
GO



-- 11)	Faites un d�clencheur pour qu'� chaque fois qu�une commande est 'Livr�e',  
--      la quantit� en inventaire des ingr�dients de la commande est augment�e par la quantit� re�ue 

--      ATTENTION: On veut que le code du trigger s'ex�cute uniquement si on vient de modifier le champ ETAT de la table Commande

--                 On veut aussi v�rifier que la nouvelle valeur du champ ETAT est maintenant 'Livr�e'

--      Dans ce d�clencheur faites aussi des entr�es dans l�entit� cr��e en 5) 
--      avec les ingr�dients et les prix des ingr�dients des d�tails de la commande . 



GO
CREATE TRIGGER Commandes.Commande_utrgAugmenterQtyEnInventaire
ON Commandes.Commande
AFTER UPDATE
AS
BEGIN
	IF(UPDATE(Etat))
	BEGIN
		DECLARE @CommandeID int, @Etat nvarchar(20);
		SELECT @CommandeID=CommandeID, @Etat=Etat FROM inserted;

		IF(@Etat = 'Livr�e')
		BEGIN
		
			UPDATE Ingredients.Ingredient
			SET QtyEnInventaire += DC.Quantite
			FROM Ingredients.Ingredient I 
			INNER JOIN Commandes.DetailsCommande DC 
			ON DC.IngredientID = I.IngredientID
			WHERE CommandeID=@CommandeID

			INSERT INTO Ingredients.IngredientsTransaction (IngredientID, QtyEnTransaction, Prix, DateETHeureTransaction)
			SELECT IngredientID, Quantite, PrixVente, GETDATE() 
			FROM Commandes.DetailsCommande
			WHERE CommandeID=@CommandeID
		END					
	END
END
GO








--  Testez votre d�clencheur en ins�rant une commande avec un �tat initial de 'Pass�e'  et des d�tails pour cette commande (au moins 2 ing�dients)
--  V�rifiez la quantit� en inventaire actuelle des produits de cette commande
--  Modifiez l'�tat de la commande pour qu'elle devienne 'AttenteDeLivraison'
--  V�rifiez que la quantit� en inventaire actuelle des produits de cette commande n'a pas chang�
--  Modifiez l'�tat de la commande pour qu'elle devienne 'Livr�e'
--  V�rifiez que la quantit� en inventaire actuelle des produits de cette commande est maintenant augment�e
--  Faites la requ�te pour v�rifier le contenu de [Ingredients].[IngredientsTransaction] pour les ingr�dients de la commande
 

 --TESTS    TESTS    TESTS    TESTS
--  testez votre d�clencheur en ins�rant une commande avec l'�tat 'pass�e' et des d�tails pour cette commande
INSERT INTO Commandes.Commande (Etat, DateHeureCommande, FournisseurID)
VALUES ('pass�e', GETDATE(),1)
GO
INSERT INTO Commandes.DetailsCommande ( Quantite, PrixVente, CommandeID, IngredientID)
VALUES (10, 50, 1, 1),
       (100, 50, 1, 2)
--  Montrez la quantit� en inventaire des produits de la commande (qu'on n''a pas encore re�us)
SELECT IngredientID, QtyEnInventaire
FROM Ingredients.Ingredient
WHERE IngredientID IN (1,2)
--  Faites un UPDATE sur Commandes.Commande pour changer l'�tat de la commande � 'attenteDeLivraison' 
UPDATE Commandes.Commande
SET Etat = 'attenteDeLivraison'
WHERE CommandeID = 1
--  Montrez la quantit� en inventaire des produits de la commande n'ont pas chang�s (car on ne les a pas encore re�us) 
SELECT IngredientID, QtyEnInventaire
FROM Ingredients.Ingredient
WHERE IngredientID IN (1,2)
--  Faites un UPDATE sur Commandes.Commande pour changer l'�tat de la commande � 'Livr�e'
UPDATE Commandes.Commande
SET Etat = 'Livr�e'
WHERE CommandeID = 1
-- Montrez la quantit� en inventaire des produits de la commande ont  chang�s(car on les a re�us)  
SELECT IngredientID, QtyEnInventaire
FROM Ingredients.Ingredient
WHERE IngredientID IN (1,2)
--  Faites la requ�te pour v�rifier le contenu de Ingredients.IngredientsTransaction par la suite
SELECT *
FROM Ingredients.IngredientsTransaction
WHERE IngredientID IN (1,2)