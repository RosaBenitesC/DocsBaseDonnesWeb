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


--  Q0)  Utilisation de la base de données BDCommerciale_R12



-----------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------- 
--
--  Q1)
-- Faites une vue qui servira à rechercher des Commandes par Nom du Client ou Nom du Représentant sans se préocupper de l'id de ces derniers.
-- Utilisez la vue

	-- Résultat attendu:

--NomClient               PrenomClient          DateCommande
------------------------- --------------------- -----------------------
--Boucher                 Pierre                2022-01-31 13:41:31.337
--Boucher                 Pierre                2022-02-01 05:57:46.803
--Boucher                 Pierre                2022-03-31 13:41:31.337
--Boucher                 Pierre                2022-04-01 05:57:46.803

--(4 lignes affectées)



--VOTRE RÉPONSE:
-- Partie 1 : Création de la vue









-- Partie 2: Utilisation de la vue pour obtenir le résultat attendu pour le représentant dont le nom de famille est Durant







-----------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------- 
--
	-- Q2 A) Création d'une fonction pour compter le nombre d'articles différents vendus pour une catégorie id donnée
	-- VOTRE RÉPONSE:










	-- Q2 B) Faites une requête pour voir le Nbre d'articles différents vendus pour la catégorie 1 en utilisant la fonction que vous venez de créer.
	-- Résultat attendu:

			--Nbre  d'articles différents vendus pour la categorie 1, Électroménagers
			-------------------------------------------------------------------------
			--2

			--(1 ligne affectée)
	
	--  VOTRE RÉPONSE: 







-----------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------- 
--
-- Q3 A) Création d'une fonction pour obtenir le nombre total d'articles vendus pour une catégorie donnée









	-- Q3 B) Faites une requête pour voir le nombre total  d'articles vendus pour la catégorie 1 en utilisant la fonction que vous venez de créer.
	-- Résultat attendu:

				--Nbre total d'articles vendus pour la categorie 1, Électroménagers
				-------------------------------------------------------------------
				--6

				--(1 ligne affectée)
	
	--  VOTRE RÉPONSE: 





-----------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------- 
--
	-- Q4 A) Faites une fonction pour calculer le total d'une commande, pour une commande id donnée en paramètre
	--  VOTRE RÉPONSE: 









	-- Q2 B) Faites un ALTER TABLE pour ajouter le champ TotalCommande, de type money, NULL dans la table Commande
	--  VOTRE RÉPONSE: 






	--Q2 C) Utilisez la fonction que vous venez de faire pour afficher la valeur totale des achats pour la commande ID 3
	
	-- Résultat attendu:

			--Total de la commande no 3
			---------------------------
			--1957,29

			--(1 ligne affectée)

	-- VOTRE RÉPONSE:







	--Q2 D) Utilisez la fonction que vous venez de faire pour initialiser la valeur totale  pour chaque achat
	-- VOTRE RÉPONSE






	--Q2 E) Vérifiez le contenu de la table dbo.Commande

	-- Résultat attendu:

			--CommandeID  NumCommande DateCommande            ClientID    TotalCommande
			------------- ----------- ----------------------- ----------- ---------------------
			--1           12489       2019-09-02 00:00:00.000 5           0,00
			--2           12500       2019-09-28 00:00:00.000 1           0,00
			--3           12504       2021-12-01 00:00:00.000 5           1957,29
			--4           12510       2022-01-31 13:41:31.337 11          125,70
			--5           12520       2022-02-01 05:57:46.803 11          801,97
			--6           12590       2022-03-31 13:41:31.337 11          1911,39
			--7           12580       2022-04-01 05:57:46.803 11          973,57

			--(7 lignes affectées)

	-- VOTRE RÉPONSE





-----------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------- 
--
-- Q5) Faites une procédure qui n'aura pas de paramètre mais qui changera les données dans 2 tables


--     Partie 1:  Commencez par faire une requête pour voir les ID des clients qui n'ont fait aucune commande 

-- Résultat attendu pour cette requête:
			--ClientID
			-------------
			--2
			--3
			--4
			--6
			--7
			--8
			--9
			--10

			--(8 lignes affectées)


--VOTRE RÉPONSE:










--     Partie 2:  Faites une procédure qui insérera dans la table ClientSansAchat les données des clients qui n'ont fait aucune commande
--                Ensuite, votre procédure supprimera de la table Client ces clients qui n'ont fait aucune commande

-- VOTRE RÉPONSE:








--     Partie 3:  Exécutez votre procédure avec les requêtes AVANT et APRÈS l'exécution de votre procédure pour voir le contenu de la table Client et de la table ClientSansAchat

--Résultat attendu:

			--ClientID    NumClient Nom                                                                              Prenom                                                                           NoCivique NoApp Rue                                                                                                  Ville                                              Province                                           CodePostal           Solde                 LimiteCredit          RepresentantID
			------------- --------- -------------------------------------------------------------------------------- -------------------------------------------------------------------------------- --------- ----- ---------------------------------------------------------------------------------------------------- -------------------------------------------------- -------------------------------------------------- -------------------- --------------------- --------------------- --------------
			--1           124       Moulineau                                                                        Paul                                                                             368       NULL  rue du Campanile                                                                                     Québec                                             Qc                                                 G1X 4G6              818,75                1000,00               1
			--2           256       Allard                                                                           Martine                                                                          996       NULL  St-Michel                                                                                            Montréal-Nord                                      Qc                                                 H1H 5G7              21,50                 1500,00               2
			--3           311       Boucher                                                                          Camille                                                                          540       NULL  Bd des Galeries                                                                                      Québec                                             Qc                                                 G2K 1N4              825,75                1000,00               3
			--4           315       Beaulieu                                                                         Alicia                                                                           220       NULL  Bd Le Corbusier                                                                                      Laval                                              Qc                                                 H7S 2C9              770,75                750,00                1
			--5           405       Bédard                                                                           Bertrand                                                                         573       NULL  Ferncroft                                                                                            Hampstead                                          Qc                                                 H3X 1C4              402,75                1500,00               2
			--6           412       Caver                                                                            Christine                                                                        120       NULL  Av. de Germain-des-Prés                                                                              Québec                                             Qc                                                 G1V 3M7              1817,50               2000,00               3
			--7           522       Chavant                                                                          Denise                                                                           444       NULL  Bd R. Lévesque Ouest                                                                                 Montréal                                           Qc                                                 H2Z 1Z6              98,75                 1500,00               2
			--8           567       Clovis                                                                           Eugène                                                                           91        NULL  rue Champlain                                                                                        Dieppe                                             N.-B.                                              E1A 1N4              402,40                750,00                2
			--9           587       Côté                                                                             Jacques                                                                          30        NULL  Barkoff                                                                                              Cap-de-la-Madeleine                                Qc                                                 G8T 2A3              114,60                1000,00               2
			--10          622       Ernest                                                                           Andrée                                                                           27        NULL  Av. des Pionniers                                                                                    Balmoral                                           N.-B.                                              E4S 3J5              1045,75               1000,00               3
			--11          745       Boucher                                                                          Pierre                                                                           540       NULL  Bd des Galeries                                                                                      Québec                                             Qc                                                 G2K 1N4              825,75                1000,00               3

			--(11 lignes affectées)

			--ClientSansCommandeID ClientID    NumClient Nom                                                                              Prenom                                                                           NoCivique NoApp Rue                                                                                                  Ville                                              Province                                           CodePostal           Solde                 LimiteCredit          RepresentantID DateSuppressionListeClient
			---------------------- ----------- --------- -------------------------------------------------------------------------------- -------------------------------------------------------------------------------- --------- ----- ---------------------------------------------------------------------------------------------------- -------------------------------------------------- -------------------------------------------------- -------------------- --------------------- --------------------- -------------- --------------------------

			--(0 lignes affectées)


			--(8 lignes affectées)

			--(8 lignes affectées)
			--ClientID    NumClient Nom                                                                              Prenom                                                                           NoCivique NoApp Rue                                                                                                  Ville                                              Province                                           CodePostal           Solde                 LimiteCredit          RepresentantID
			------------- --------- -------------------------------------------------------------------------------- -------------------------------------------------------------------------------- --------- ----- ---------------------------------------------------------------------------------------------------- -------------------------------------------------- -------------------------------------------------- -------------------- --------------------- --------------------- --------------
			--1           124       Moulineau                                                                        Paul                                                                             368       NULL  rue du Campanile                                                                                     Québec                                             Qc                                                 G1X 4G6              818,75                1000,00               1
			--5           405       Bédard                                                                           Bertrand                                                                         573       NULL  Ferncroft                                                                                            Hampstead                                          Qc                                                 H3X 1C4              402,75                1500,00               2
			--11          745       Boucher                                                                          Pierre                                                                           540       NULL  Bd des Galeries                                                                                      Québec                                             Qc                                                 G2K 1N4              825,75                1000,00               3

			--(3 lignes affectées)

			--ClientSansCommandeID ClientID    NumClient Nom                                                                              Prenom                                                                           NoCivique NoApp Rue                                                                                                  Ville                                              Province                                           CodePostal           Solde                 LimiteCredit          RepresentantID DateSuppressionListeClient
			---------------------- ----------- --------- -------------------------------------------------------------------------------- -------------------------------------------------------------------------------- --------- ----- ---------------------------------------------------------------------------------------------------- -------------------------------------------------- -------------------------------------------------- -------------------- --------------------- --------------------- -------------- --------------------------
			--1                    2           256       Allard                                                                           Martine                                                                          996       NULL  St-Michel                                                                                            Montréal-Nord                                      Qc                                                 H1H 5G7              21,50                 1500,00               2              2022-12-05 12:47:36.197
			--2                    3           311       Boucher                                                                          Camille                                                                          540       NULL  Bd des Galeries                                                                                      Québec                                             Qc                                                 G2K 1N4              825,75                1000,00               3              2022-12-05 12:47:36.197
			--3                    4           315       Beaulieu                                                                         Alicia                                                                           220       NULL  Bd Le Corbusier                                                                                      Laval                                              Qc                                                 H7S 2C9              770,75                750,00                1              2022-12-05 12:47:36.197
			--4                    6           412       Caver                                                                            Christine                                                                        120       NULL  Av. de Germain-des-Prés                                                                              Québec                                             Qc                                                 G1V 3M7              1817,50               2000,00               3              2022-12-05 12:47:36.197
			--5                    7           522       Chavant                                                                          Denise                                                                           444       NULL  Bd R. Lévesque Ouest                                                                                 Montréal                                           Qc                                                 H2Z 1Z6              98,75                 1500,00               2              2022-12-05 12:47:36.197
			--6                    8           567       Clovis                                                                           Eugène                                                                           91        NULL  rue Champlain                                                                                        Dieppe                                             N.-B.                                              E1A 1N4              402,40                750,00                2              2022-12-05 12:47:36.197
			--7                    9           587       Côté                                                                             Jacques                                                                          30        NULL  Barkoff                                                                                              Cap-de-la-Madeleine                                Qc                                                 G8T 2A3              114,60                1000,00               2              2022-12-05 12:47:36.197
			--8                    10          622       Ernest                                                                           Andrée                                                                           27        NULL  Av. des Pionniers                                                                                    Balmoral                                           N.-B.                                              E4S 3J5              1045,75               1000,00               3              2022-12-05 12:47:36.197

			--(8 lignes affectées)

-- VOTRE RÉPONSE:








-----------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------- 
--

-- Q6)  Faites une procédure pour obtenir la liste des commandes faites entre deux dates


-- VOTRE RÉPONSE:







	--     puis exécutez-la en utilisant les dates du premier janvier 2021 au premier janvier 2022


--Résultat attendu:

			--CommandeID  DateCommande Nom Client               TotalCommande
			------------- ------------ ------------------------ ---------------------
			--3           2021-12-01   Bédard, Bertrand         1957,29

			--(1 ligne affectée)

-- VOTRE RÉPONSE:



