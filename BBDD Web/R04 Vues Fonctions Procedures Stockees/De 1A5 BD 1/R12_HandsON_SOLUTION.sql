-----------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------- 
--
--      VOTRE NOM, VOTRE PRÉNOM
--
--      R12 Les vues, fonctions et procédures stockées
--
--		Notions: 
-- 
--      Une vue:
--				GO
--				CREATE VIEW dbo.vw_NomDeLaVue
--				AS
--				-- requête ici	   
--				GO
--		
--      Une fonction:
--				GO
--				CREATE FUNCTION dbo.udf_NomDeLaFonction
--				(@param1 type, [@param2 type]...)
--				RETURNS typeDeRetour
--				AS
--              BEGIN
--	                DECLARE @Resultat typeDeRetour;
--                  SELECT @Resultat = .......
--                  RETURN @Resultat;
--              END
--              GO
--
--      Une procédure Stockée:
--				GO
--				CREATE PROCEDURE dbo.usp_NomDeLaProcedure
--				(@param1 type, [@param2 type]...)
--				AS
--              BEGIN
--	                ...
--              END
--              GO
--
--     Les vues sont utilisées comme une table
--     Les fonctions sont utilisées comme un champ, dans des SELECT, WHERE, HAVING, UPDATE SET =....
--     Les procédures sont exécutées avec EXECUTE
--
-----------------------------------------------------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------------------------------------


--  Q0)  Utilisation de la base de données LibrairieABC
	USE LibrairieABC;

-----------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------- 
--
--  Q1)
-- Faites une vue qui servira à rechercher des livres par categorie ou auteur sans se préocupper du numéro de ces deux derniers.
-- Utilisez la vue

-- Résultat attendu:

--Titre                 Categorie      ISBN                 PrixVente             NomCompletAuteur
----------------------- -------------- -------------------- --------------------- -----------------------------------------------------------------------------------------------------
--The Lincoln Lawyer    Policier       1455516341           44,00                 Connelly,Michael
--The Poet              Policier       446602612            7,00                  Connelly,Michael

--(2 lignes affectées)



--Votre réponse:
-- Partie 1 : Création de la vue
	GO
	CREATE VIEW dbo.vw_LivreAvecAuteurCategorie
	AS
	SELECT LivreID, A.AuteurID ,NomAuteur, PrenomAuteur, NomAuteur + ',' + PrenomAuteur AS 'NomCompletAuteur', Titre, L.CategorieID , Categorie, Editeur, DateParution, ISBN, PrixVente
	FROM dbo.Livre L
	INNER JOIN dbo.Categorie C 
	ON L.CategorieID = C.CategorieID
	INNER JOIN dbo.Auteur A 
	ON A.AuteurID = L.AuteurID
	GO

-- Partie 2: Utilisation de la vue pour obtenir le résultat attendu
	SELECT Titre, Categorie, ISBN, PrixVente, NomCompletAuteur
	FROM dbo.vw_LivreAvecAuteurCategorie
	WHERE NomAuteur = 'Connelly'
	GO
-----------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------- 
--
	-- Q2 A) Création d'une fonction pour compter le nombre de livres différents vendus pour une catégorie id donnée
	-- VOTRE RÉPONSE:
	
	GO
	CREATE FUNCTION dbo.ufn_NBLivresDifferentPourUneCategorie
	(@CategorieID int)
	RETURNS int
	AS 
	BEGIN
		DECLARE @answer int;

		SELECT @answer = COUNT( qty)
		FROM DetailsAchat DA
		INNER JOIN dbo.Livre L
		ON DA.LivreID = L.LivreID
		WHERE CategorieID = @CategorieID;

		RETURN @answer;
	END
	GO

	-- Q2 B) Faites une requête pour voir le Nbre de livres différents vendus pour la catégorie 4 en utilisant la fonction que vous venez de créer.
	-- Résultat attendu:

			--Nbre de livres différents vendus pour la categorie 4, policiers
-----------------------------------------------------------------
			--		2

			--(1 ligne affectée)
	
	--  VOTRE RÉPONSE: 

	SELECT dbo.ufn_NBLivresDifferentPourUneCategorie(4) AS 'Nbre de livres différents vendus pour la categorie 4, policiers'
	go
-----------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------- 
--
-- Q3 A) Création d'une fonction pour obtenir le nombre total de livres vendus pour une catégorie donnée
		GO
	CREATE FUNCTION dbo.ufn_NbTotalLivresPourUneCategorie
	(@CategorieID int)
	RETURNS int
	AS 
	BEGIN
		DECLARE @answer int;

		SELECT @answer = SUM( qty)
		FROM DetailsAchat DA
		INNER JOIN dbo.Livre L
		ON DA.LivreID = L.LivreID
		WHERE CategorieID = @CategorieID;

		RETURN @answer;
	END
	GO

	-- Q3 B) Faites une requête pour voir le nombre total  de livres vendus pour la catégorie 4 en utilisant la fonction que vous venez de créer.
	-- Résultat attendu:

			--Nbre total de livres vendus pour la categorie 4, policiers
-----------------------------------------------------------------
			--		2

			--(1 ligne affectée)
	
	--  VOTRE RÉPONSE: 

	SELECT dbo.ufn_NbTotalLivresPourUneCategorie(4) AS 'Nbre total de livres vendus pour la categorie 4, policiers'
	go
-----------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------- 
--
	-- Q4 A) Faites une fonction pour calculer le total d'un achat, pour un achat donné en paramètre
	--  VOTRE RÉPONSE: 
	GO
	CREATE FUNCTION dbo.ufn_CalculerTotalPourUneCommande
	(@AchatID int)
	RETURNS money
	AS 
	BEGIN
		DECLARE @TotalAchat money;

		SELECT @TotalAchat = SUM( qty * PrixVendu)
		FROM DetailsAchat
		WHERE AchatID= @AchatID;

		RETURN @TotalAchat;
	END
	GO


	-- Q2 B) Faites un ALTER TABLE pour ajouter le champ TotalAchat, de type money, NULL dans la table Achat
	--  VOTRE RÉPONSE: 
	ALTER TABLE dbo.Achat
	ADD TotalAchat money NULL;

	--Q2 C) Utilisez la fonction que vous venez de faire pour afficher la valeur totale des achats pour le NoAchat 1
	
	-- Résultat attendu:

			--	Total des achats pour l'achat no 1
			------------------------------------
			--121,70

			--(1 ligne affectée)

	-- VOTRE RÉPONSE:

	SELECT dbo.ufn_CalculerTotalPourUneCommande(1) AS 'Total des achats pour l''achat no 1';




	--Q2 D) Utilisez la fonction que vous venez de faire pour initialiser la valeur totale  pour chaque achat
	-- VOTRE RÉPONSE

	UPDATE dbo.Achat
	SET TotalAchat = dbo.ufn_CalculerTotalPourUneCommande(AchatID);

	--Q2 E) Vérifiez le contenu de la table dbo.Achat

	-- Résultat attendu:

				--AchatID     OrderDate                   DueDate                     CLientID    TotalAchat
				------------- --------------------------- --------------------------- ----------- ---------------------
				--1           2021-02-23 00:00:00.0000000 2021-02-26 00:00:00.0000000 1           121,70
				--2           2021-10-10 00:00:00.0000000 2021-10-24 00:00:00.0000000 2           23,90
				--3           2022-01-10 00:00:00.0000000 2022-01-24 00:00:00.0000000 2           40,00
				--4           2021-10-10 00:00:00.0000000 2021-10-24 00:00:00.0000000 3           45,98
				--5           2020-01-10 00:00:00.0000000 2020-01-24 00:00:00.0000000 4           6,99
				--6           2020-08-10 00:00:00.0000000 2020-08-24 00:00:00.0000000 4           40,00
				--7           2021-10-10 00:00:00.0000000 2021-10-24 00:00:00.0000000 4           58,85
				--8           2022-02-10 00:00:00.0000000 2022-02-24 00:00:00.0000000 5           67,69
				--9           2021-10-10 00:00:00.0000000 2021-10-24 00:00:00.0000000 6           NULL
				--10          2021-11-10 00:00:00.0000000 2021-11-24 00:00:00.0000000 6           NULL
				--11          2021-12-10 00:00:00.0000000 2021-12-24 00:00:00.0000000 2           NULL
				--12          2022-03-10 00:00:00.0000000 2022-03-24 00:00:00.0000000 2           NULL

				--(12 lignes affectées)

	-- VOTRE RÉPONSE
	SELECT AchatID, OrderDate, DueDate, CLientID, TotalAchat FROM dbo.Achat
-----------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------- 
--
-- Q5) Faites une procédure qui n'aura pas de paramètre mais qui changera les données dans 2 tables

--     Partie 1:  Commencez par faire une requête pour voir quels clients n'ont fait aucun achat
--     Partie 2:  Faites une procédure qui insérera dans la table ClientSansAchat les données des clients qui n'ont fait aucun achat
--                (Vous utiliserez la requête faite dans la Partie 1 comme sous-requête à votre INSERT)
--                Ensuite, votre procédure supprimera de la table Client ces clients qui n'ont fait aucun achat
--     Partie 3:  Exécutez votre procédure avec les requêtes AVANT et APRÈS l'exécution de votre procédure pour voir le contenu de la table ClientSansAchat
--     


--ClientIDSansAchat ClientID    NomClient                                          PrenomClient                                       Courriel                                           Telephone      NoClivique Rue                                                Appartement Ville                                              Province                                           CodePostal DateSuppression
------------------- ----------- -------------------------------------------------- -------------------------------------------------- -------------------------------------------------- -------------- ---------- -------------------------------------------------- ----------- -------------------------------------------------- -------------------------------------------------- ---------- ---------------------------

--(0 lignes affectées)


--(4 lignes affectées)

--(4 lignes affectées)
--ClientIDSansAchat ClientID    NomClient                                          PrenomClient                                       Courriel                                           Telephone      NoClivique Rue                                                Appartement Ville                                              Province                                           CodePostal DateSuppression
------------------- ----------- -------------------------------------------------- -------------------------------------------------- -------------------------------------------------- -------------- ---------- -------------------------------------------------- ----------- -------------------------------------------------- -------------------------------------------------- ---------- ---------------------------
--1                 7           English                                            Lucian                                             Donec@arcu.com                                     1-563-106-0311 NULL       NULL                                               NULL        NULL                                               NULL                                               H2C3D5     2022-11-30 01:31:33.3500000
--2                 8           Vaughn                                             Sopoline                                           lobortis.nisi.nibh@nibhenimgravida.ca              1-600-836-1114 NULL       NULL                                               NULL        NULL                                               NULL                                               H3C2W3     2022-11-30 01:31:33.3500000
--3                 9           Gibbs                                              Fredericka                                         Sed@nec.co.uk                                      1-385-836-3282 NULL       NULL                                               NULL        NULL                                               NULL                                               J3B2D3     2022-11-30 01:31:33.3500000
--4                 10          Pittman                                            Jonas                                              mollis.Integer@commodo.ca                          1-279-574-3930 NULL       NULL                                               NULL        NULL                                               NULL                                               J3B2V4     2022-11-30 01:31:33.3500000

--(4 lignes affectées)



--     Partie 1:  Commencez par faire une requête pour voir les ID des clients qui n'ont fait aucun achat

-- Résultat attendu pour cette requête:
-----------
--7
--8
--9
--10

--(4 lignes affectées)


--Votre réponse:
SELECT C.ClientID
FROM dbo.Client C
LEFT JOIN dbo.Achat A
ON C.ClientID = A.ClientID
WHERE A.ClientID IS NULL


--     Partie 2:  Faites une procédure qui insérera dans la table ClientSansAchat les données des clients qui n'ont fait aucun achat
--                Ensuite, votre procédure supprimera de la table Client ces clients qui n'ont fait aucun achat
GO
CREATE PROCEDURE dbo.usp_SupprimerClientsSansAchat
AS
BEGIN
	INSERT INTO [dbo].[ClientSansAchat]
	SELECT CLientID, NomClient, PrenomClient, Courriel, Telephone, NoClivique, Rue, Appartement, Ville, Province, CodePostal, GETDATE()
	FROM dbo.Client 
	WHERE ClientID IN (	SELECT C.ClientID
						FROM dbo.Client C
						LEFT JOIN dbo.Achat A
						ON C.ClientID = A.ClientID
						WHERE A.ClientID IS NULL);
	
	DELETE FROM dbo.Client
	WHERE ClientID IN (	SELECT C.ClientID
						FROM dbo.Client C
						LEFT JOIN dbo.Achat A
						ON C.ClientID = A.ClientID
						WHERE A.ClientID IS NULL);
END
GO
--     Partie 3:  Exécutez votre procédure avec les requêtes AVANT et APRÈS l'exécution de votre procédure pour voir le contenu de la table ClientSansAchat
SELECT * FROM [dbo].[ClientSansAchat];
GO
EXECUTE dbo.usp_SupprimerClientsSansAchat;
GO
SELECT * FROM [dbo].[ClientSansAchat]
GO

-----------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------- 
--

-- Q6)  Faites une procédure pour obtenir la liste des achats faits entre deux dates
--     puis exécutez-la en utilisant les dates du premier janvier 2021 au premier janvier 2022

--Résultat attendu:
--AchatID     orderDate  Nom acheteur                telephone
------------- ---------- --------------------------- --------------
--1           2021-02-23 Farrell, Barclay            1-395-412-8775
--2           2021-10-10 Gordon, Ila                 1-249-246-5309
--4           2021-10-10 Mccoy, Nora                 1-754-328-0811
--7           2021-10-10 Vaughn, Haley               1-244-871-9462
--9           2021-10-10 Love, Ray                   1-475-377-3861
--10          2021-11-10 Love, Ray                   1-475-377-3861
--11          2021-12-10 Gordon, Ila                 1-249-246-5309

--(7 lignes affectées)

-- Votre réponse:
	GO
	CREATE PROCEDURE dbo.usp_AchatIntervalle
	(@dateStart datetime2, @dateEnd datetime2)
	AS
	BEGIN
		SELECT AchatID, cast(OrderDate as date) AS 'OrderDate', NomClient +', '+ PrenomClient AS 'Nom acheteur' , Telephone 
		FROM [dbo].[Achat] A
		INNER JOIN [dbo].[Client] C 
		ON C.ClientID = A.ClientID
		WHERE OrderDate BETWEEN @dateStart AND @dateEnd
	END
	GO
	EXECUTE dbo.usp_AchatIntervalle @dateStart = '20210101' , @dateEnd = '20220101'
	go