--	Répondez aux questions suivantes, 
--  Faites des tests en insérant ou modifiant des données. 
--  N’oubliez pas de laisser des traces de tes tests.



USE [ThesEtTisanes];


-- 1 A)   Créez une vue pour voir tous les types de recettes, toutes les recettes et leurs ingrédients avec leurs quantités dans chaque recette
--        Incluez tous les id des tables utilisées.


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




----1 B)    Puis utilisez cette vue pour obtenir le résultat suivant:

----NomTypeRecette               NomRecette                                     Quantite               NomIngredientCommun
-------------------------------- ---------------------------------------------- ---------------------- --------------------------------------------------
----Thés Indiens                 Thé d’Assam à la cardamone                     1/4 de tasse           Cassonade
----Thés Indiens                 Thé d’Assam à la cardamone                     6                      fruits de cardamone
----Thés Indiens                 Thé d’Assam à la cardamone                     3 1/2 tasses           eau
--...
----Tisanes aux fruits           Tisane de citron, d’anis et de fenouil         1 tasse, bouillante    eau
----Tisanes aux fruits           Tisane de citron, d’anis et de fenouil         1/2 c. à soupe         graines de fenouil
----Tisanes aux fruits           Tisane de citron, d’anis et de fenouil         1 c. à thé             framboisier

----(34 ligne(s) affectée(s))

SELECT NomTypeRecette, NomRecette, Quantite, NomIngredientCommun 
FROM Recettes.vw_Recettes
GO




-- 2)	Créez une procédure pour voir toutes les recettes qui contiennent un ingrédient donné en paramètre. 
--      Cette procédure devra utiliser la vue créée en 1).

--  Voici le résultat que vous devriez obtenir avec id 19 (cassonade)

----NomTypeRecette                                     NomRecette
------------------------------------------------------ -------------------------------------
----Thés Indiens                                       Thé d’Assam à la cardamone
----Thés Indiens                                       Thé épicé de l’Himalaya

----(2 ligne(s) affectée(s))

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





-- 3 A)	Faites une fonction qui calculera le nombre d’ingrédients différents qu’offre un fournisseur et retournera cette valeur.
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
-- 3 B) Utilisez cette fonction pour obtenir le nombre d'ingrédients différents offerts par le fournisseur dont l'id est 1
SELECT Fournisseurs.ufn_NBIngredientsDifferentsParFournisseur(1) AS 'Nb ingrédients différents pour le fournisseur dont l''id est 1'
GO





   
-- 4 A)	Faites un ALTER TABLE pour ajouter à la table Fournisseur un champ entier NbIngredients 
--      qui contiendra le nombre d'ingrédients différents qu’offre un fournisseur
ALTER TABLE Fournisseurs.Fournisseur
ADD NbIngredients int;
GO



-- 4 B) Utilisez cette fonction pour mettre à jour le champs NbIngredients à l’entité Fournisseur.	

UPDATE Fournisseurs.Fournisseur
SET NbIngredients =  Fournisseurs.ufn_NBIngredientsDifferentsParFournisseur(FournisseurID)
GO



-- 4 C) Faites ensuite un SELECT de la table Fournisseur pour vérifier que vous obtenez le résultat suivant:
----FournisseurID NomFournisseur                   NbIngredients
----------------- ----------------------------- -- -------------
----1             Grossiste Épices Anatol          30
----2             Herboristerie Desjardins         5

----(2 ligne(s) affectée(s))
SELECT FournisseurID, NomFournisseur, NbIngredients 
FROM Fournisseurs.Fournisseur
GO





-- 5)	Faites les scripts DDL pour  ajouter une entité IngredientsTransaction dans le schéma Ingredients
--      qui enregistrera les modifications qui sont faites dans les quantités en inventaire des ingrédients. 

--      Voici des exemples de données que pourraient contenir 2 enregistrements de cette table :
--			IngredientsTransactionsID		IngredientID	QtyEnTransaction	Prix	DateEtHeureTransaction
--					1						1				10					4,25	2020215 8:00					
--                  2						1				-4					8,00	2020215 10:00

		 			

--      N'oubliez pas aussi de faire une contrainte de clé étrangère pour la relation Ingredient qui aura plusieurs IngredientsTransaction
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


-- 6)	Faites le script DDL pour créer une entité qui s’appelera Fournisseurs.ContactHist qui sera utilisée 
--      pour enregistrer les données d’un contact qui quitte l’emploi d’un fournisseur.
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
   
-- 7)	Faites le déclencheur  pour que lors de la suppression d'un contact d'un fournisseur, 
--      on ajoutera ses données dans l'entité créée en 10 avec sa date de départ.
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
-- Vérifiez que ce nouveau contact n'existe plus dans la table Contact
-- Faites la requête pour vérifier le contenu de [Fournisseurs].[ContactHist] après cette suppression
SELECT 0 as 'AVANT DELETE', ContactID, Nom, Prenom, TelCell, Courriel, FournisseurID FROM Fournisseurs.Contact WHERE ContactID=3;
GO

SELECT 0 as 'AVANT DELETE', ContactHistID, FournisseurID, ContactID,  Nom, Prenom, TelCell, Courriel, DateMAJ FROM Fournisseurs.ContactHist
ORDER BY ContactHistID DESC
GO

DELETE FROM Fournisseurs.Contact
WHERE ContactID=3;
GO


SELECT 1 as 'APRÈS DELETE', ContactID, Nom, Prenom, TelCell, Courriel, FournisseurID FROM Fournisseurs.Contact WHERE ContactID=3;
GO

SELECT 1 as 'APRÈS DELETE', ContactHistID, FournisseurID, ContactID,  Nom, Prenom, TelCell, Courriel, DateMAJ FROM Fournisseurs.ContactHist
ORDER BY ContactHistID DESC
GO




-- 8)	Ajoutez un schéma appellé Commandes.

GO
CREATE SCHEMA Commandes;
GO



-- 9)   Faites le script DDL pour  ajouter une entité dans le schéma créé en 6) qui s’appellera Commande 
--      et qui sera utilisée pour enregistrer la date et l’heure d’une commande qu’on voudrait faire à un fournisseur 
--      et son état qui peut prendre les différentes valeurs suivantes  : ( Passée, AttenteDeLivraison, Livrée,  AttenteDePaiement, Payée).  

---     Assurez-vous que seules les valeurs citées entre parenthèses sont valides pour cet état de commande.

---     N'oubliez pas aussi de faire une contrainte de clé étrangère pour la relation  Un Fournisseur a plusieurs Commande 

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
(Etat in ('passée', 'attenteDeLivraison', 'livrée', 'enPaiement', 'payée'))
GO



-- 10)	Faites le script DDL pour ajouter une deuxième entité dans le schéma créé en 6) qui s’appelera DetailsCommande 
--      et qui sera utilisée pour enregistrer  les ingrédients commandés dans une commande, leurs quantités et leurs prix de vente.
--      N'oubliez pas aussi de faire une contrainte de clé étrangère pour la relation  une Commande a plusieurs DetailsCommande

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



-- 11)	Faites un déclencheur pour qu'à chaque fois qu’une commande est 'Livrée',  
--      la quantité en inventaire des ingrédients de la commande est augmentée par la quantité reçue 

--      ATTENTION: On veut que le code du trigger s'exécute uniquement si on vient de modifier le champ ETAT de la table Commande

--                 On veut aussi vérifier que la nouvelle valeur du champ ETAT est maintenant 'Livrée'

--      Dans ce déclencheur faites aussi des entrées dans l’entité créée en 5) 
--      avec les ingrédients et les prix des ingrédients des détails de la commande . 



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

		IF(@Etat = 'Livrée')
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








--  Testez votre déclencheur en insérant une commande avec un état initial de 'Passée'  et des détails pour cette commande (au moins 2 ingédients)
--  Vérifiez la quantité en inventaire actuelle des produits de cette commande
--  Modifiez l'état de la commande pour qu'elle devienne 'AttenteDeLivraison'
--  Vérifiez que la quantité en inventaire actuelle des produits de cette commande n'a pas changé
--  Modifiez l'état de la commande pour qu'elle devienne 'Livrée'
--  Vérifiez que la quantité en inventaire actuelle des produits de cette commande est maintenant augmentée
--  Faites la requête pour vérifier le contenu de [Ingredients].[IngredientsTransaction] pour les ingrédients de la commande
 

 --TESTS    TESTS    TESTS    TESTS
--  testez votre déclencheur en insérant une commande avec l'état 'passée' et des détails pour cette commande
INSERT INTO Commandes.Commande (Etat, DateHeureCommande, FournisseurID)
VALUES ('passée', GETDATE(),1)
GO
INSERT INTO Commandes.DetailsCommande ( Quantite, PrixVente, CommandeID, IngredientID)
VALUES (10, 50, 1, 1),
       (100, 50, 1, 2)
--  Montrez la quantité en inventaire des produits de la commande (qu'on n''a pas encore reçus)
SELECT IngredientID, QtyEnInventaire
FROM Ingredients.Ingredient
WHERE IngredientID IN (1,2)
--  Faites un UPDATE sur Commandes.Commande pour changer l'état de la commande à 'attenteDeLivraison' 
UPDATE Commandes.Commande
SET Etat = 'attenteDeLivraison'
WHERE CommandeID = 1
--  Montrez la quantité en inventaire des produits de la commande n'ont pas changés (car on ne les a pas encore reçus) 
SELECT IngredientID, QtyEnInventaire
FROM Ingredients.Ingredient
WHERE IngredientID IN (1,2)
--  Faites un UPDATE sur Commandes.Commande pour changer l'état de la commande à 'Livrée'
UPDATE Commandes.Commande
SET Etat = 'Livrée'
WHERE CommandeID = 1
-- Montrez la quantité en inventaire des produits de la commande ont  changés(car on les a reçus)  
SELECT IngredientID, QtyEnInventaire
FROM Ingredients.Ingredient
WHERE IngredientID IN (1,2)
--  Faites la requête pour vérifier le contenu de Ingredients.IngredientsTransaction par la suite
SELECT *
FROM Ingredients.IngredientsTransaction
WHERE IngredientID IN (1,2)