
-- FAITES UN GROUPE D'INSERTIONS À LA FOIS !
-- L'ORDRE DE CES INSERTIONS DOIT ABSOLUMENT ÊTRE RESPECTÉ ! N'avancez pas si une insertion est mal gérée.

-- À TOUT MOMENT : Si votre BD est dans un état inattendu, supprimez votre BD, recréez-la à partir de 
-- votre script et finalement refaites toutes les insertions qui "Doivent fonctionner ✅".

-- INSERTION #1 (Doit fonctionner ✅)
-- ▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀

USE Rencontre

INSERT INTO Utilisateurs.Utilisateur (Pseudo, Courriel, DateNaissance, Description, Ville, Pays)
VALUES 
('Loveboy22', 'loveboy@gmail.com', '2000-01-01', NULL, 'Longueuil', 'Canada'), 
('Karen_BZ', 'k@k.com', '1985-02-28', 'Je cherche une relation à long terme avec le manager', 'La Prairie', 'Canada'), 
('Gabar69', 'gabarou@hotmail.com', '2002-10-12', 'J''aime bien Netflix et relaxer', 'Boucherville', 'Canada'), 
('BasicWB', 'bwb@gmail.com', '2001-11-14', 'Voyages, restaurants, expériences, cinéma !', 'Repentigny', 'Canada'), 
('KoopToo_Daz', 'koop12@hotmail.ca', '1997-03-14', NULL, 'Terrebonne', 'Canada');

-- Ça ne fonctionne pas ? Vérifier vos datatypes, vos NOT NULL, votre IDENTITY(1,1), etc.

-- INSERTION #2 (Doit échouer 🚫)
-- ▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀



INSERT INTO Utilisateurs.Utilisateur (Pseudo, Courriel, DateNaissance, Description, Ville, Pays)
VALUES
('Loveboy22', 'duplicateusername@gmail.com', '2000-01-02', NULL, 'Longueuil', 'Canada');

-- Ça fonctionne ? Vérifiez votre contrainte UNIQUE de pseudo

-- INSERTION #3 (Doit échouer 🚫)
-- ▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀



INSERT INTO Utilisateurs.Utilisateur (Pseudo, Courriel, DateNaissance, Description, Ville, Pays)
VALUES
('TooYOUNG', 'tooyoungforlove@gmail.com', '2020-01-02', NULL, 'Longueuil', 'Canada');

-- Ça fonctione ? Vérifiez votre contrainte CHECK d'âge...

-- INSERTION #4 (Doit échouer 🚫)
-- ▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀



INSERT INTO Utilisateurs.Utilisateur (Pseudo, Courriel, DateNaissance, Description, Ville, Pays)
VALUES
('wrongEmail', '@gmail.com', '2002-01-02', NULL, 'Longueuil', 'Canada');

-- Ça fonctionne ? Vérifiez votre contrainte CHECK de courriel.

-- INSERTION #5 (Doit échouer 🚫)
-- ▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀



INSERT INTO Utilisateurs.Utilisateur (Pseudo, Courriel, DateNaissance, Description, Ville, Pays)
VALUES
(NULL, 'null@gmail.com', '2002-01-02', NULL, NULL, NULL);

-- Ça fonctionne ? Il vous manque des NOT NULL ...

-- INSERTION #6 (Doit fonctionner ✅)
-- ▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀

BEGIN TRANSACTION;


INSERT INTO Messageries.Conversation (DateDebut)
VALUES (GETDATE());

INSERT INTO Messageries.UtilisateurConversation (ConversationID, UtilisateurID)
VALUES
((SELECT MAX(ConversationID) FROM Messageries.Conversation), (SELECT UtilisateurID FROM Utilisateurs.Utilisateur WHERE Pseudo = 'Loveboy22')),
((SELECT MAX(ConversationID) FROM Messageries.Conversation), (SELECT UtilisateurID FROM Utilisateurs.Utilisateur WHERE Pseudo = 'BasicWB'))

IF @@ERROR <> 0 BEGIN ROLLBACK TRANSACTION; RETURN; END

COMMIT TRANSACTION;

-- Ça ne fonctionne pas ? Vous avez bien mis la valeur 0 PAR DÉFAUT à NbMessages ? Et IDENTITY(1,1) pour ConversationID ?

-- Si ça a fonctionné, ça veut dire qu'on a créé une conversation entre Loveboy22 et BasicWB. Place à l'amour !

-- INSERTION #7 (Doit échouer 🚫)
-- ▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀


INSERT INTO Messageries.UtilisateurConversation (ConversationID, UtilisateurID)
VALUES
((SELECT MAX(ConversationID) FROM Messageries.Conversation), (SELECT UtilisateurID FROM Utilisateurs.Utilisateur WHERE Pseudo = 'Loveboy22'))

-- Ça fonctionne ? La contrainte UNIQUE est manquante ou invalide.

-- INSERTION #8 (Doit échouer 🚫)
-- ▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀

BEGIN TRANSACTION;


INSERT INTO Messageries.Conversation (DateDebut)
VALUES (GETDATE());

INSERT INTO Messageries.UtilisateurConversation (ConversationID, UtilisateurID)
VALUES
(1000, (SELECT UtilisateurID FROM Utilisateurs.Utilisateur WHERE Pseudo = 'Loveboy22')),
((SELECT MAX(ConversationID) FROM Messageries.Conversation), 1000)

IF @@ERROR <> 0 BEGIN ROLLBACK TRANSACTION; RETURN; END

COMMIT TRANSACTION;

-- Ça fonctionne ? Vos contraintes de clés étrangères sont manquantes ou mauvaises pour UtilisateurConversation.

-- INSERTION #9 (Doit fonctionner ✅)
-- ▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀



INSERT INTO Messageries.Message (Texte, DateEnvoi, EstLu, ConversationID)
VALUES
('Slt cv', GETDATE(), 0, (
SELECT TOP 1 ConversationID FROM Messageries.UtilisateurConversation as UC1
WHERE UtilisateurID = (SELECT TOP 1 UtilisateurID FROM Utilisateurs.Utilisateur WHERE Pseudo = 'Loveboy22') AND 
EXISTS (SELECT ConversationID FROM Messageries.UtilisateurConversation as UC2 
WHERE UtilisateurID = (SELECT TOP 1 UtilisateurID FROM Utilisateurs.Utilisateur WHERE Pseudo = 'BasicWB') AND
UC1.ConversationID = UC2.ConversationID)
))

-- Ça ne fonctionne pas ? Ceci est censé ajouté un message dans la conversation partagée par Loveboy22 et BasicWB.
-- L'insertion #9 avait-elle vraiment fonctionné ? Vos Datatype sont-ils les bons ?

-- INSERTION #10 (Doit échouer 🚫)
-- ▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀


INSERT INTO Messageries.Message (Texte, DateEnvoi, EstLu, ConversationID)
VALUES
(NULL, NULL, NULL, (
SELECT TOP 1 ConversationID FROM Messageries.UtilisateurConversation as UC1
WHERE UtilisateurID = (SELECT TOP 1 UtilisateurID FROM Utilisateurs.Utilisateur WHERE Pseudo = 'Loveboy22') AND 
EXISTS (SELECT ConversationID FROM Messageries.UtilisateurConversation as UC2 
WHERE UtilisateurID = (SELECT TOP 1 UtilisateurID FROM Utilisateurs.Utilisateur WHERE Pseudo = 'BasicWB') AND
UC1.ConversationID = UC2.ConversationID)
))

-- Ça fonctionne ? Il vous manque un ou des NOT NULL pour la table Message.

-- INSERTION #11 (Doit échouer 🚫)
-- ▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀


INSERT INTO Messageries.Message (Texte, DateEnvoi, EstLu, ConversationID)
VALUES
('Slt cv', GETDATE(), 0, (
SELECT TOP 1 ConversationID FROM Messageries.UtilisateurConversation as UC1
WHERE UtilisateurID = (SELECT TOP 1 UtilisateurID FROM Utilisateurs.Utilisateur WHERE Pseudo = 'Loveboy22') AND 
EXISTS (SELECT ConversationID FROM Messageries.UtilisateurConversation as UC2 
WHERE UtilisateurID = (SELECT TOP 1 UtilisateurID FROM Utilisateurs.Utilisateur WHERE Pseudo = 'Karen_BZ') AND
UC1.ConversationID = UC2.ConversationID)
))

-- Ça fonctionne ? Il vous manque un NOT NULL pour ConversationID. Loveboy22 et Karen_BZ ne sont pas censé partager une conversation.

-- █▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀█
-- █          FIN DES INSERTIONS !             █
-- █▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄█

-- Après toutes ces insertions, vous êtes censés avoir : 5 utilisateurs, 1 conversation, 2 utilisateurConversations, 1 message.
-- Nous allons maintenant tenter une suppression de données pour vérifier que vous avez bien fait vos ON DELETE CASCADE.

-- SUPPRESSION #1 (Doit fonctionner ✅)
-- ▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀


DELETE FROM Messageries.Conversation WHERE ConversationID = (SELECT MAX (ConversationID) FROM Messageries.Conversation)

-- Les tables Conversation, Message et UtilisateurConversation sont toutes les trois censées être vides maintenant !!!



