
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
CREATE PROCEDURE SP_ListeArticlesCommande 
	@CommandeID int
AS

-- ♦♦♦ Ajoutez votre SELECT ici ♦♦♦

GO

-- ▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄
-- Utilisez ce code pour appeler et tester la procédure #1
-- ▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀

USE Labo04;
GO

EXEC SP_ListeArticlesCommande
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

CREATE PROCEDURE SP_NouvelArticle
	@ArticleID int,
	@Qte int,
	@UtilisateurID int,
	@AdresseID int
AS

DECLARE @CommandeID int;

IF EXISTS () -- ◄ Dans les parenthèses, mettez une requête pour vérifier si une commande convenable existe
	BEGIN
		-- Remplissez @CommandeID avec l'id de la commande appropriée la plus récente
	END
ELSE
	BEGIN
		-- Insérez une nouvelle commande avec les bonnes valeurs

		SELECT @CommandeID = SCOPE_IDENTITY(); -- Ceci va chercher la clé primaire (l'ID) de la commande que vous venez d'insérer !
	END

-- Insérez une rangée dans ArticleCommande avec les bonnes valeurs

GO

-- ▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄
-- Utilisez ce code pour appeler et tester la procédure #2
-- ▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀

-- Test #1 :

USE Labo04;
GO
EXEC SP_NouvelArticle
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

USE Labo04;
GO
EXEC SP_NouvelArticle
	@ArticleID = 1, -- Porte-bananes
	@Qte = 1, 
	@UtilisateurID = 1, -- Simone De Belleville
	@AdresseID = 1; -- 56 rue De Provence
GO

-- Test #2 : Est-ce qu'une rangée a SEULEMENT été ajoutée
--           dans la table ArticleCommande ?
--           La rangée doit être (?, 1, 1, 5)
