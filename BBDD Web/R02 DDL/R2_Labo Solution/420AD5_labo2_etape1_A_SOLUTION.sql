
-- █▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀█
-- █          Création de la BD          █
-- █▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄█

USE master
GO
CREATE DATABASE Rencontre;
GO
USE Rencontre;
GO

-- █▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀█
-- █          Création des deux schémas        █
-- █▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄█

CREATE SCHEMA Utilisateurs;
GO
CREATE SCHEMA Messageries;
GO

-- █▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀█
-- █ Création des tables + contraintes de clé primaire █
-- █▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄█

CREATE TABLE Utilisateurs.Utilisateur(
-- À COMPLÉTER
	UtilisateurID int IDENTITY (1,1),
	Pseudo nvarchar(15) NOT NULL,
	Courriel nvarchar(40) NOT NULL,
	DateNaissance datetime NOT NULL,
	Description nvarchar(255) NULL,
	Ville nvarchar(50) NOT NULL,
	Pays nvarchar(50) NOT NULL,
	CONSTRAINT PK_Utilisateur_UtilisateurID PRIMARY KEY (UtilisateurID)
);

CREATE TABLE Messageries.Message(
-- À COMPLÉTER
	MessageID int IDENTITY (1,1),
	Texte text NOT NULL,
	DateEnvoi datetime NOT NULL,
	EstLu bit NOT NULL,
	ConversationID int NOT NULL,
	CONSTRAINT PK_Message_MessageID PRIMARY KEY (MessageID)

);

CREATE TABLE Messageries.Conversation(
-- À COMPLÉTER
	ConversationID int IDENTITY (1,1),
	DateDebut datetime NOT NULL,
	NbMessages int NOT NULL,
	CONSTRAINT PK_Conversation_ConversationID PRIMARY KEY (ConversationID)
);

CREATE TABLE Messageries.UtilisateurConversation(
-- À COMPLÉTER
	ConversationID int NOT NULL,
	UtilisateurID int NOT NULL,
	CONSTRAINT PK_UtilisateurConversation_UtilisateurConversationID PRIMARY KEY (ConversationID, UtilisateurID)
);
GO

-- █▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀█
-- █ Création des contraintes de clé étrangère █
-- █▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄█

-- Vous êtes censés avoir 3 contraintes ici.

-- À COMPLÉTER
ALTER TABLE Messageries.Message ADD CONSTRAINT FK_Message_ConversationID FOREIGN KEY (ConversationID) 
REFERENCES Messageries.Conversation(ConversationID)
ON DELETE CASCADE 
GO
ALTER TABLE Messageries.Message CHECK CONSTRAINT FK_Message_ConversationID
GO
ALTER TABLE Messageries.UtilisateurConversation ADD CONSTRAINT FK_UtilisateurConversation_ConversationID FOREIGN KEY (ConversationID) 
REFERENCES Messageries.Conversation(ConversationID)
ON DELETE CASCADE 
GO
ALTER TABLE Messageries.UtilisateurConversation CHECK CONSTRAINT FK_UtilisateurConversation_ConversationID
GO
ALTER TABLE Messageries.UtilisateurConversation ADD CONSTRAINT FK_UtilisateurConversation_UtilisateurID FOREIGN KEY (UtilisateurID) 
REFERENCES Utilisateurs.Utilisateur(UtilisateurID)
ON DELETE CASCADE 
GO
ALTER TABLE Messageries.UtilisateurConversation CHECK CONSTRAINT FK_UtilisateurConversation_UtilisateurID
GO

-- █▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀█
-- █      Création des autres contraintes      █
-- █▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄█

-- Vous êtes censés avoir 5 contraintes ici.

-- À COMPLÉTER
--  Pseudo utilisateur UNIQUE
ALTER TABLE Utilisateurs.Utilisateur ADD CONSTRAINT UC_Utilisateur_Pseudo UNIQUE (Pseudo)
GO
--	DateNaissance datetime NOT NULL,  que la différence entre GETDATE() et DateNaissance >=18
ALTER TABLE Utilisateurs.Utilisateur ADD CONSTRAINT CK_Utilisateur_Age CHECK ( DATEDIFF(YEAR,DateNaissance, GETDATE() ) >=18)
--	Le courriel doit respecter la forme « a@a.a » (C’est plus compliqué que ça en vrai, mais c’est pour tester LIKE)

ALTER TABLE Utilisateurs.Utilisateur ADD CONSTRAINT CK_Utilisateur_Courriel CHECK ( Courriel LIKE '_%@_%._%')
GO
-- 	Par défaut, Le nombre de messages dans une conversation est 0.
ALTER TABLE Messageries.Conversation ADD CONSTRAINT DF_Conversation_NbMessages DEFAULT 0 FOR NbMessages
GO
