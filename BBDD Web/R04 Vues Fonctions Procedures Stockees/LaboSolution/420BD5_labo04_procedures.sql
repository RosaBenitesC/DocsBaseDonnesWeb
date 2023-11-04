
-- █▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀█
-- █  Création de procédures stockées  █
-- █▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄█

-- ▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄
-- Procédure #1 : Avec @CommandeID en paramètre, (Qui contient l'id de la commande)
--                donner la liste des articles (nom, prix et la quantité achetée) 
--                de la commande. Le prix doit être le prix unitaire de l’article 
--                multiplié par la quantité achetée.
-- ▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀

USE Labo04;
GO
CREATE PROCEDURE Articles.usp_ListeArticlesCommande  
	@CommandeID int
AS
	SELECT A.Nom, AC.Qte, (A.Prix * AC.Qte) AS 'Prix' 
	FROM Articles.Article A
	INNER JOIN Commandes.ArticleCommande AC 
	ON A.ArticleID = AC.ArticleID
	INNER JOIN Commandes.Commande C 
	ON C.CommandeID = AC.CommandeID
	WHERE C.CommandeID = @CommandeID;

GO

-- ▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄
-- Utilisez ce code pour appeler et tester la procédure #1
-- ▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀

USE Labo04;
GO

EXEC Articles.usp_ListeArticlesCommande 
	@CommandeID = 5;
GO

-- ▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄
-- Procédure #2 : Avec le numéro d’article @ArticleID, la quantité @Qte, le numéro 
--                d’utilisateur @UtilisateurID et l’adresse @AdresseID insérez une 
--                rangée dans la table ArticleCommande. Pour déterminer l’id de la 
--                Commande, utilisez la règle suivante :
--
--                • S’il existe une commande non traitée pour cet utilisateur avec 
--                  l’adresse fournie, on utilise l’id de la commande la plus récente 
--                  qui respecte ces conditions pour la rangée qu’on insère dans 
--                  ArticleCommande.
--                • Sinon, créez (insérez) une nouvelle rangée dans la table Commande.
--                  La DateCommande est GETDATE() et EstTraite vaut 0. Utilisez ensuite 
--                  l’id de cette toute nouvelle commande pour insérer la nouvelle 
--                  rangée dans ArticleCommande.
-- ▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀

USE Labo04;
GO

CREATE PROCEDURE Commandes.usp_NouvelArticle
	@ArticleID int,
	@Qte int,
	@UtilisateurID int,
	@AdresseID int
AS

	DECLARE @CommandeID int;

	IF EXISTS (SELECT CommandeID FROM Commandes.Commande 
		WHERE UtilisateurID = @UtilisateurID AND AdresseID = @AdresseID AND EstTraite = 0)
		BEGIN
			SELECT TOP 1 @CommandeID = CommandeID FROM Commandes.Commande 
			WHERE UtilisateurID = @UtilisateurID AND AdresseID = @AdresseID AND EstTraite = 0 
			ORDER BY DateCommande DESC
		END
	ELSE
		BEGIN
			INSERT INTO Commandes.Commande (DateCommande, EstTraite, UtilisateurID, AdresseID)
			VALUES (GETDATE(), 0, @UtilisateurID, @AdresseID);

			SELECT @CommandeID = SCOPE_IDENTITY();
		END

	INSERT INTO Commandes.ArticleCommande (Qte, ArticleID, CommandeID)
	VALUES (@Qte, @ArticleID, @CommandeID);

GO


-- ▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄
-- Utilisez ce code pour appeler et tester la procédure #2
-- ▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀

-- Test #1 :

USE Labo04;
GO
EXEC Commandes.usp_NouvelArticle
	@ArticleID = 1, -- Porte-bananes
	@Qte = 1, 
	@UtilisateurID = 4, -- Paul Robidoux
	@AdresseID = 6; -- 163321 Apt. 391 rue Nadepaute
GO

-- Test #1 : Est-ce qu'une rangée a bien été ajouté dans les
--			 tables ArticleCommande ET Commande ?
--           À la fin dans ArticleCommande on doit avoir → (?, 1, 1, X)
--           À la fin dans Commande on doit avoir        → (X, ?, 0, 4, 6)
--           ? = n'importe quelle valeur
--           X = n'importe quelle valeur, mais la même pour les deux X

-- Test #2 :

USE Labo05demi;
GO
EXEC Commandes.usp_NouvelArticle
	@ArticleID = 1, -- Porte-bananes
	@Qte = 1, 
	@UtilisateurID = 1, -- Simone De Belleville
	@AdresseID = 1; -- 56 rue De Provence
	
-- Test #2 : Est-ce qu'une rangée a SEULEMENT été ajoutée
--           dans la table ArticleCommande ?
--           La rangée doit être (?, 1, 1, 5)
