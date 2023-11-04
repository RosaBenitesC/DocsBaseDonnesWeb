
-- █▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀█
-- █  Création de vues  █
-- █▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄█

-- ▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄
-- Vue #1 : Les articles (nom, prix, quantité en stock) en ordre décroissant du nombre 
--          de copies de l’article vendues dans le dernier mois.
--
--          On ne veut voir ni les articles avec une quantité en stock supérieure à 
--          100, ni les articles vendus 0 fois dans le dernier mois.
-- ▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀

USE Labo04;
GO

CREATE VIEW VW_ArticlesPopulaires AS

-- ♦♦♦ Ajoutez votre SELECT ici ♦♦♦

GO

-- ▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄
-- Utilisez ce SELECT pour tester votre vue #1
-- ▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀

USE Labo04;
GO

SELECT * FROM VW_ArticlesPopulaires;
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

CREATE VIEW VW_CommandesNonTraitees AS

-- ♦♦♦ Ajoutez votre SELECT ici ♦♦♦

GO

-- ▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄
-- Utilisez ce SELECT pour tester votre vue #2
-- ▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀

USE Labo04;
GO

SELECT * FROM VW_CommandesNonTraitees;
GO