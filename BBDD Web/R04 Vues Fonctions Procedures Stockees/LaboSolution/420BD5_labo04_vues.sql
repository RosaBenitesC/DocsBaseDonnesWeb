
-- █▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀█
-- █  Création de vues  █
-- █▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄█

-- ▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄
-- Vue #1 : On veut voir le TOP 10 des articles (nom, prix, quantité en stock) en ordre décroissant du nombre 
--          de copies de l’article vendues dans le dernier mois.
--
--          On ne veut voir ni les articles avec une quantité en stock supérieure à 
--          100, ni les articles vendus 0 fois dans le dernier mois.
-- ▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀

USE Labo04;
GO


CREATE VIEW Articles.vw_ArticlesPopulaires AS

SELECT TOP 10 A.Nom, A.Prix, A.QteStock, SUM(AC.Qte) AS NbCopiesVendues 
FROM Articles.Article A
INNER JOIN Commandes.ArticleCommande AC ON A.ArticleID = AC.ArticleID
INNER JOIN Commandes.Commande C ON AC.CommandeID = C.CommandeID
WHERE A.QteStock <= 100 AND DATEDIFF(MONTH, GETDATE(), C.DateCommande) < 1
GROUP BY A.Nom, A.Prix, A.QteStock
HAVING SUM(AC.Qte) > 0
ORDER BY SUM(AC.Qte) DESC;
GO

-- ▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄
-- Utilisez ce SELECT pour tester votre vue #1
-- ▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀

USE Labo04;
GO

SELECT Nom, Prix, QteStock, NbCopiesVendues 
FROM Articles.vw_ArticlesPopulaires;
GO

-- ▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄
-- Vue #2 : Le top 10 des commandes non traitées en ordre croissant de date.
--          On veut la date et l'id de la commande.
--          On veut toutes les données de l'adresse de livraison.
--          On veut l'id, le prénom, le nom, le courriel et le numéro de téléphone de l'utilisateur.
--
--          Pas besoin de la liste des articles, une procédure stockée s'en occupera.
-- ▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀

USE Labo04;
GO

CREATE VIEW Commandes.vw_CommandesNonTraitees AS

WITH
Q1 AS 
(
	SELECT COUNT(ArticleID) AS NbArticlesDiff, CommandeID FROM Commandes.ArticleCommande
	GROUP BY CommandeID
)
SELECT TOP 10 C.DateCommande, C.CommandeID, U.UtilisateurID, U.Prenom, U.Nom, U.Courriel, A.NoCivique, A.NoAPT, A.Rue, A.Ville, A.Region, A.Pays, A.CodePostal, Q1.NbArticlesDiff
FROM Commandes.Commande C
INNER JOIN Utilisateurs.Utilisateur U 
ON U.UtilisateurID = C.UtilisateurID
INNER JOIN Utilisateurs.Adresse A 
ON C.AdresseID = A.AdresseID
INNER JOIN Q1
ON Q1.CommandeID = C.CommandeID
WHERE C.EstTraite = 0
ORDER BY C.DateCommande ASC

GO

-- ▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄
-- Utilisez ce SELECT pour tester votre vue #2
-- ▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀

USE Labo04;
GO

SELECT DateCommande, CommandeID, UtilisateurID, Prenom, Nom, Courriel, NoCivique, NoAPT, Rue, Ville, Region, Pays, CodePostal, NbArticlesDiff 
FROM Commandes.vw_CommandesNonTraitees;
GO