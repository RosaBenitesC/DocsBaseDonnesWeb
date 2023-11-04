--	Répondez aux questions suivantes, 
--  Faites des tests en insérant ou modifiant des données. 
--  N’oubliez pas de laisser des traces de tes tests.



USE [ThesEtTisanes];


-- 1 A)   Créez une vue pour voir tous les types de recettes, toutes les recettes et leurs ingrédients avec leurs quantités dans chaque recette
--        Incluez tous les id des tables utilisées.








----1 B)    Puis utilisez cette vue pour obtenir le résultat suivant:

----NomTypeRecette               NomRecette                                     Quantite               NomIngredientCommun
-------------------------------- ---------------------------------------------- ---------------------- --------------------------------------------------
----Thés Indiens                 Thé d’Assam à la cardamone                     1/4 de tasse           Cassonade
----Thés Indiens                 Thé d’Assam à la cardamone                     6                      fruits de cardamone
----Thés Indiens                 Thé d’Assam à la cardamone                     3 1/2 tasses           eau
...
----Tisanes aux fruits           Tisane de citron, d’anis et de fenouil         1 tasse, bouillante    eau
----Tisanes aux fruits           Tisane de citron, d’anis et de fenouil         1/2 c. à soupe         graines de fenouil
----Tisanes aux fruits           Tisane de citron, d’anis et de fenouil         1 c. à thé             framboisier

----(34 ligne(s) affectée(s))






-- 2)	Créez une procédure pour voir toutes les recettes qui contiennent un ingrédient donné en paramètre. 
--      Cette procédure devra utiliser la vue créée en 1).

--  Voici le résultat que vous devriez obtenir avec id 19 (cassonade)

----NomTypeRecette                                     NomRecette
------------------------------------------------------ -------------------------------------
----Thés Indiens                                       Thé d’Assam à la cardamone
----Thés Indiens                                       Thé épicé de l’Himalaya

----(2 ligne(s) affectée(s))











-- 3 A)	Faites une fonction qui calculera le nombre d’ingrédients différents qu’offre un fournisseur et retournera cette valeur.

-- 3 B) Utilisez cette fonction pour obtenir le nombre d'ingrédients différents offerts par le fournisseur dont l'id est 1





   
-- 4 A)	Faites un ALTER TABLE pour ajouter à la table Fournisseur un champ entier NbIngredients 
--      qui contiendra le nombre d'ingrédients différents qu’offre un fournisseur


-- 4 B) Utilisez cette fonction pour mettre à jour le champs NbIngredients à l’entité Fournisseur.	



-- 4 C) Faites ensuite un SELECT de la table Fournisseur pour vérifier que vous obtenez le résultat suivant:
----FournisseurID NomFournisseur                   NbIngredients
----------------- ----------------------------- -- -------------
----1             Grossiste Épices Anatol          30
----2             Herboristerie Desjardins         5

----(2 ligne(s) affectée(s))






-- 5)	Faites les scripts DDL pour  ajouter une entité IngredientsTransaction dans le schéma Ingredients
--      qui enregistrera les modifications qui sont faites dans les quantités en inventaire des ingrédients. 

--      Voici des exemples de données que pourraient contenir 2 enregistrements de cette table :
--			IngredientsTransactionsID		IngredientID	QtyEnTransaction	Prix	DateEtHeureTransaction
--					1						1				10					4,25	2020215 8:00					
--                  2						1				-4					8,00	2020215 10:00

		 			

--      N'oubliez pas aussi de faire une contrainte de clé étrangère pour la relation Ingredient qui aura plusieurs IngredientsTransaction



-- 6)	Faites le script DDL pour créer une entité qui s’appelera Fournisseurs.ContactHist qui sera utilisée 
--      pour enregistrer les données d’un contact qui quitte l’emploi d’un fournisseur.
--      Assurez-vous d'y inclure un champ pour la date de l'enregistrement de cette information



  
   
-- 7)	Faites le déclencheur  pour que lors de la suppression d'un contact d'un fournisseur, 
--      on ajoutera ses données dans l'entité créée en 10 avec sa date de départ.

-- Pour tester:
-- Ajoutez un nouveau contact pour un fournisseur
-- Affichez ce nouveau contact
-- Supprimez ce nouveau contact
-- Vérifiez que ce nouveau contact n'existe plus dans la table Contact
-- Faites la requête pour vérifier le contenu de [Fournisseurs].[ContactHist] après cette suppression



-- 8)	Ajoutez un schéma appellé Commandes.



-- 9)   Faites le script DDL pour  ajouter une entité dans le schéma créé en 6) qui s’appellera Commande 
--      et qui sera utilisée pour enregistrer la date et l’heure d’une commande qu’on voudrait faire à un fournisseur 
--      et son état qui peut prendre les différentes valeurs suivantes  : ( Passée, AttenteDeLivraison, Livrée,  AttenteDePaiement, Payée).  

---     Assurez-vous que seules les valeurs citées entre parenthèses sont valides pour cet état de commande.

---     N'oubliez pas aussi de faire une contrainte de clé étrangère pour la relation  Un Fournisseur a plusieurs Commande 





-- 10)	Faites le script DDL pour ajouter une deuxième entité dans le schéma créé en 6) qui s’appelera DetailsCommande 
--      et qui sera utilisée pour enregistrer  les ingrédients commandés dans une commande, leurs quantités et leurs prix de vente.
--      N'oubliez pas aussi de faire une contrainte de clé étrangère pour la relation  une Commande a plusieurs DetailsCommande





-- 11)	Faites un déclencheur pour qu'à chaque fois qu’une commande est 'Livrée',  
--      la quantité en inventaire des ingrédients de la commande est augmentée par la quantité reçue 

--      ATTENTION: On veut que le code du trigger s'exécute uniquement si on vient de modifier le champ ETAT de la table Commande

--                 On veut aussi vérifier que la nouvelle valeur du champ ETAT est maintenant 'Livrée'

--      Dans ce déclencheur faites aussi des entrées dans l’entité créée en 5) 
--      avec les ingrédients et les prix des ingrédients des détails de la commande . 







--  Testez votre déclencheur en insérant une commande avec un état initial de 'Passée'  et des détails pour cette commande (au moins 2 ingédients)
--  Vérifiez la quantité en inventaire actuelle des produits de cette commande
--  Modifiez l'état de la commande pour qu'elle devienne 'AttenteDeLivraison'
--  Vérifiez que la quantité en inventaire actuelle des produits de cette commande n'a pas changé
--  Modifiez l'état de la commande pour qu'elle devienne 'Livrée'
--  Vérifiez que la quantité en inventaire actuelle des produits de cette commande est maintenant augmentée
--  Faites la requête pour vérifier le contenu de [Ingredients].[IngredientsTransaction] pour les ingrédients de la commande
 






-- Remettez ce script avec les TESTS.
