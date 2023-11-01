USE Labo11
GO
CREATE NONCLUSTERED INDEX IX_Etudiant_PrenomNom
ON Etudiants.Etudiant(Prenom, Nom)
GO

CREATE NONCLUSTERED INDEX IX_EtudiantFruit_EtudiantIDFruitID
ON Fruits.EtudiantFruit(EtudiantID,FruitID)