--	R�pondez aux questions suivantes, 
--  Faites des tests en ins�rant ou modifiant des donn�es. 
--  N�oubliez pas de laisser des traces de tes tests.



USE [ThesEtTisanes];


-- 1 A)   Cr�ez une vue pour voir tous les types de recettes, toutes les recettes et leurs ingr�dients avec leurs quantit�s dans chaque recette
--        Incluez tous les id des tables utilis�es.








----1 B)    Puis utilisez cette vue pour obtenir le r�sultat suivant:

----NomTypeRecette               NomRecette                                     Quantite               NomIngredientCommun
-------------------------------- ---------------------------------------------- ---------------------- --------------------------------------------------
----Th�s Indiens                 Th� d�Assam � la cardamone                     1/4 de tasse           Cassonade
----Th�s Indiens                 Th� d�Assam � la cardamone                     6                      fruits de cardamone
----Th�s Indiens                 Th� d�Assam � la cardamone                     3 1/2 tasses           eau
...
----Tisanes aux fruits           Tisane de citron, d�anis et de fenouil         1 tasse, bouillante    eau
----Tisanes aux fruits           Tisane de citron, d�anis et de fenouil         1/2 c. � soupe         graines de fenouil
----Tisanes aux fruits           Tisane de citron, d�anis et de fenouil         1 c. � th�             framboisier

----(34�ligne(s) affect�e(s))






-- 2)	Cr�ez une proc�dure pour voir toutes les recettes qui contiennent un ingr�dient donn� en param�tre. 
--      Cette proc�dure devra utiliser la vue cr��e en 1).

--  Voici le r�sultat que vous devriez obtenir avec id 19 (cassonade)

----NomTypeRecette                                     NomRecette
------------------------------------------------------ -------------------------------------
----Th�s Indiens                                       Th� d�Assam � la cardamone
----Th�s Indiens                                       Th� �pic� de l�Himalaya

----(2�ligne(s) affect�e(s))











-- 3 A)	Faites une fonction qui calculera le nombre d�ingr�dients diff�rents qu�offre un fournisseur et retournera cette valeur.

-- 3 B) Utilisez cette fonction pour obtenir le nombre d'ingr�dients diff�rents offerts par le fournisseur dont l'id est 1





   
-- 4 A)	Faites un ALTER TABLE pour ajouter � la table Fournisseur un champ entier NbIngredients 
--      qui contiendra le nombre d'ingr�dients diff�rents qu�offre un fournisseur


-- 4 B) Utilisez cette fonction pour mettre � jour le champs NbIngredients � l�entit� Fournisseur.	



-- 4 C) Faites ensuite un SELECT de la table Fournisseur pour v�rifier que vous obtenez le r�sultat suivant:
----FournisseurID NomFournisseur                   NbIngredients
----------------- ----------------------------- -- -------------
----1             Grossiste �pices Anatol          30
----2             Herboristerie Desjardins         5

----(2�ligne(s) affect�e(s))






-- 5)	Faites les scripts DDL pour  ajouter une entit� IngredientsTransaction dans le sch�ma Ingredients
--      qui enregistrera les modifications qui sont faites dans les quantit�s en inventaire des ingr�dients. 

--      Voici des exemples de donn�es que pourraient contenir 2 enregistrements de cette table :
--			IngredientsTransactionsID		IngredientID	QtyEnTransaction	Prix	DateEtHeureTransaction
--					1						1				10					4,25	2020215 8:00					
--                  2						1				-4					8,00	2020215 10:00

		 			

--      N'oubliez pas aussi de faire une contrainte de cl� �trang�re pour la relation Ingredient qui aura plusieurs IngredientsTransaction



-- 6)	Faites le script DDL pour cr�er une entit� qui s�appelera Fournisseurs.ContactHist qui sera utilis�e 
--      pour enregistrer les donn�es d�un contact qui quitte l�emploi d�un fournisseur.
--      Assurez-vous d'y inclure un champ pour la date de l'enregistrement de cette information



  
   
-- 7)	Faites le d�clencheur  pour que lors de la suppression d'un contact d'un fournisseur, 
--      on ajoutera ses donn�es dans l'entit� cr��e en 10 avec sa date de d�part.

-- Pour tester:
-- Ajoutez un nouveau contact pour un fournisseur
-- Affichez ce nouveau contact
-- Supprimez ce nouveau contact
-- V�rifiez que ce nouveau contact n'existe plus dans la table Contact
-- Faites la requ�te pour v�rifier le contenu de [Fournisseurs].[ContactHist] apr�s cette suppression



-- 8)	Ajoutez un sch�ma appell� Commandes.



-- 9)   Faites le script DDL pour  ajouter une entit� dans le sch�ma cr�� en 6) qui s�appellera Commande 
--      et qui sera utilis�e pour enregistrer la date et l�heure d�une commande qu�on voudrait faire � un fournisseur 
--      et son �tat qui peut prendre les diff�rentes valeurs suivantes  : ( Pass�e, AttenteDeLivraison, Livr�e,  AttenteDePaiement, Pay�e).  

---     Assurez-vous que seules les valeurs cit�es entre parenth�ses sont valides pour cet �tat de commande.

---     N'oubliez pas aussi de faire une contrainte de cl� �trang�re pour la relation  Un Fournisseur a plusieurs Commande 





-- 10)	Faites le script DDL pour ajouter une deuxi�me entit� dans le sch�ma cr�� en 6) qui s�appelera DetailsCommande 
--      et qui sera utilis�e pour enregistrer  les ingr�dients command�s dans une commande, leurs quantit�s et leurs prix de vente.
--      N'oubliez pas aussi de faire une contrainte de cl� �trang�re pour la relation  une Commande a plusieurs DetailsCommande





-- 11)	Faites un d�clencheur pour qu'� chaque fois qu�une commande est 'Livr�e',  
--      la quantit� en inventaire des ingr�dients de la commande est augment�e par la quantit� re�ue 

--      ATTENTION: On veut que le code du trigger s'ex�cute uniquement si on vient de modifier le champ ETAT de la table Commande

--                 On veut aussi v�rifier que la nouvelle valeur du champ ETAT est maintenant 'Livr�e'

--      Dans ce d�clencheur faites aussi des entr�es dans l�entit� cr��e en 5) 
--      avec les ingr�dients et les prix des ingr�dients des d�tails de la commande . 







--  Testez votre d�clencheur en ins�rant une commande avec un �tat initial de 'Pass�e'  et des d�tails pour cette commande (au moins 2 ing�dients)
--  V�rifiez la quantit� en inventaire actuelle des produits de cette commande
--  Modifiez l'�tat de la commande pour qu'elle devienne 'AttenteDeLivraison'
--  V�rifiez que la quantit� en inventaire actuelle des produits de cette commande n'a pas chang�
--  Modifiez l'�tat de la commande pour qu'elle devienne 'Livr�e'
--  V�rifiez que la quantit� en inventaire actuelle des produits de cette commande est maintenant augment�e
--  Faites la requ�te pour v�rifier le contenu de [Ingredients].[IngredientsTransaction] pour les ingr�dients de la commande
 






-- Remettez ce script avec les TESTS.
