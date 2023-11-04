-----------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------- 
--
--      VOTRE NOM, VOTRE PR�NOM
--
--      R12 Les vues, fonctions et proc�dures stock�es
--
--		Notions: 
-- 
--      Une vue:
--				GO
--				CREATE VIEW dbo.vw_NomDeLaVue
--				AS
--				-- requ�te ici	   
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
--      Une proc�dure Stock�e:
--				GO
--				CREATE PROCEDURE dbo.usp_NomDeLaProcedure
--				(@param1 type, [@param2 type]...)
--				AS
--              BEGIN
--	                ...
--              END
--              GO
--
--     Les vues sont utilis�es comme une table
--     Les fonctions sont utilis�es comme un champ, dans des SELECT, WHERE, HAVING, UPDATE SET =....
--     Les proc�dures sont ex�cut�es avec EXECUTE
--
-----------------------------------------------------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------------------------------------


--  Q0)  Utilisation de la base de donn�es LibrairieABC
	USE LibrairieABC;

-----------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------- 
--
--  Q1)
-- Faites une vue qui servira � rechercher des livres par categorie ou auteur sans se pr�ocupper du num�ro de ces deux derniers.
-- Utilisez la vue

-- R�sultat attendu:

--Titre                 Categorie      ISBN                 PrixVente             NomCompletAuteur
----------------------- -------------- -------------------- --------------------- -----------------------------------------------------------------------------------------------------
--The Lincoln Lawyer    Policier       1455516341           44,00                 Connelly,Michael
--The Poet              Policier       446602612            7,00                  Connelly,Michael

--(2�lignes affect�es)



--Votre r�ponse:
-- Partie 1 : Cr�ation de la vue
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

-- Partie 2: Utilisation de la vue pour obtenir le r�sultat attendu
	SELECT Titre, Categorie, ISBN, PrixVente, NomCompletAuteur
	FROM dbo.vw_LivreAvecAuteurCategorie
	WHERE NomAuteur = 'Connelly'
	GO
-----------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------- 
--
	-- Q2 A) Cr�ation d'une fonction pour compter le nombre de livres diff�rents vendus pour une cat�gorie id donn�e
	-- VOTRE R�PONSE:
	
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

	-- Q2 B) Faites une requ�te pour voir le Nbre de livres diff�rents vendus pour la cat�gorie 4 en utilisant la fonction que vous venez de cr�er.
	-- R�sultat attendu:

			--Nbre de livres diff�rents vendus pour la categorie 4, policiers
-----------------------------------------------------------------
			--		2

			--(1 ligne affect�e)
	
	--  VOTRE R�PONSE: 

	SELECT dbo.ufn_NBLivresDifferentPourUneCategorie(4) AS 'Nbre de livres diff�rents vendus pour la categorie 4, policiers'
	go
-----------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------- 
--
-- Q3 A) Cr�ation d'une fonction pour obtenir le nombre total de livres vendus pour une cat�gorie donn�e
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

	-- Q3 B) Faites une requ�te pour voir le nombre total  de livres vendus pour la cat�gorie 4 en utilisant la fonction que vous venez de cr�er.
	-- R�sultat attendu:

			--Nbre total de livres vendus pour la categorie 4, policiers
-----------------------------------------------------------------
			--		2

			--(1 ligne affect�e)
	
	--  VOTRE R�PONSE: 

	SELECT dbo.ufn_NbTotalLivresPourUneCategorie(4) AS 'Nbre total de livres vendus pour la categorie 4, policiers'
	go
-----------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------- 
--
	-- Q4 A) Faites une fonction pour calculer le total d'un achat, pour un achat donn� en param�tre
	--  VOTRE R�PONSE: 
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
	--  VOTRE R�PONSE: 
	ALTER TABLE dbo.Achat
	ADD TotalAchat money NULL;

	--Q2 C) Utilisez la fonction que vous venez de faire pour afficher la valeur totale des achats pour le NoAchat 1
	
	-- R�sultat attendu:

			--	Total des achats pour l'achat no 1
			------------------------------------
			--121,70

			--(1 ligne affect�e)

	-- VOTRE R�PONSE:

	SELECT dbo.ufn_CalculerTotalPourUneCommande(1) AS 'Total des achats pour l''achat no 1';




	--Q2 D) Utilisez la fonction que vous venez de faire pour initialiser la valeur totale  pour chaque achat
	-- VOTRE R�PONSE

	UPDATE dbo.Achat
	SET TotalAchat = dbo.ufn_CalculerTotalPourUneCommande(AchatID);

	--Q2 E) V�rifiez le contenu de la table dbo.Achat

	-- R�sultat attendu:

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

				--(12�lignes affect�es)

	-- VOTRE R�PONSE
	SELECT AchatID, OrderDate, DueDate, CLientID, TotalAchat FROM dbo.Achat
-----------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------- 
--
-- Q5) Faites une proc�dure qui n'aura pas de param�tre mais qui changera les donn�es dans 2 tables

--     Partie 1:  Commencez par faire une requ�te pour voir quels clients n'ont fait aucun achat
--     Partie 2:  Faites une proc�dure qui ins�rera dans la table ClientSansAchat les donn�es des clients qui n'ont fait aucun achat
--                (Vous utiliserez la requ�te faite dans la Partie 1 comme sous-requ�te � votre INSERT)
--                Ensuite, votre proc�dure supprimera de la table Client ces clients qui n'ont fait aucun achat
--     Partie 3:  Ex�cutez votre proc�dure avec les requ�tes AVANT et APR�S l'ex�cution de votre proc�dure pour voir le contenu de la table ClientSansAchat
--     


--ClientIDSansAchat ClientID    NomClient                                          PrenomClient                                       Courriel                                           Telephone      NoClivique Rue                                                Appartement Ville                                              Province                                           CodePostal DateSuppression
------------------- ----------- -------------------------------------------------- -------------------------------------------------- -------------------------------------------------- -------------- ---------- -------------------------------------------------- ----------- -------------------------------------------------- -------------------------------------------------- ---------- ---------------------------

--(0�lignes affect�es)


--(4�lignes affect�es)

--(4�lignes affect�es)
--ClientIDSansAchat ClientID    NomClient                                          PrenomClient                                       Courriel                                           Telephone      NoClivique Rue                                                Appartement Ville                                              Province                                           CodePostal DateSuppression
------------------- ----------- -------------------------------------------------- -------------------------------------------------- -------------------------------------------------- -------------- ---------- -------------------------------------------------- ----------- -------------------------------------------------- -------------------------------------------------- ---------- ---------------------------
--1                 7           English                                            Lucian                                             Donec@arcu.com                                     1-563-106-0311 NULL       NULL                                               NULL        NULL                                               NULL                                               H2C3D5     2022-11-30 01:31:33.3500000
--2                 8           Vaughn                                             Sopoline                                           lobortis.nisi.nibh@nibhenimgravida.ca              1-600-836-1114 NULL       NULL                                               NULL        NULL                                               NULL                                               H3C2W3     2022-11-30 01:31:33.3500000
--3                 9           Gibbs                                              Fredericka                                         Sed@nec.co.uk                                      1-385-836-3282 NULL       NULL                                               NULL        NULL                                               NULL                                               J3B2D3     2022-11-30 01:31:33.3500000
--4                 10          Pittman                                            Jonas                                              mollis.Integer@commodo.ca                          1-279-574-3930 NULL       NULL                                               NULL        NULL                                               NULL                                               J3B2V4     2022-11-30 01:31:33.3500000

--(4�lignes affect�es)



--     Partie 1:  Commencez par faire une requ�te pour voir les ID des clients qui n'ont fait aucun achat

-- R�sultat attendu pour cette requ�te:
-----------
--7
--8
--9
--10

--(4�lignes affect�es)


--Votre r�ponse:
SELECT C.ClientID
FROM dbo.Client C
LEFT JOIN dbo.Achat A
ON C.ClientID = A.ClientID
WHERE A.ClientID IS NULL


--     Partie 2:  Faites une proc�dure qui ins�rera dans la table ClientSansAchat les donn�es des clients qui n'ont fait aucun achat
--                Ensuite, votre proc�dure supprimera de la table Client ces clients qui n'ont fait aucun achat
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
--     Partie 3:  Ex�cutez votre proc�dure avec les requ�tes AVANT et APR�S l'ex�cution de votre proc�dure pour voir le contenu de la table ClientSansAchat
SELECT * FROM [dbo].[ClientSansAchat];
GO
EXECUTE dbo.usp_SupprimerClientsSansAchat;
GO
SELECT * FROM [dbo].[ClientSansAchat]
GO

-----------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------- 
--

-- Q6)  Faites une proc�dure pour obtenir la liste des achats faits entre deux dates
--     puis ex�cutez-la en utilisant les dates du premier janvier 2021 au premier janvier 2022

--R�sultat attendu:
--AchatID     orderDate  Nom acheteur                telephone
------------- ---------- --------------------------- --------------
--1           2021-02-23 Farrell, Barclay            1-395-412-8775
--2           2021-10-10 Gordon, Ila                 1-249-246-5309
--4           2021-10-10 Mccoy, Nora                 1-754-328-0811
--7           2021-10-10 Vaughn, Haley               1-244-871-9462
--9           2021-10-10 Love, Ray                   1-475-377-3861
--10          2021-11-10 Love, Ray                   1-475-377-3861
--11          2021-12-10 Gordon, Ila                 1-249-246-5309

--(7�lignes affect�es)

-- Votre r�ponse:
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