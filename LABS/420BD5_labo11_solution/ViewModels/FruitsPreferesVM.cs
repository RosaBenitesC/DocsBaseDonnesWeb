using System.ComponentModel.DataAnnotations;

namespace _4204D5_labo12.ViewModels
{
    public class FruitsPreferesVM
    {
        public string Prenom { get; set; } = null!;

        public string Nom { get; set; } = null!;

        public List<string>? NomsFruits { get; set; }

        // On a ici une liste qui contient des strings et des NULL
        // NULL signifie qu'aucune image n'a été trouvée pour un fruit
        // Un string signifie qu'une image a été trouvée pour un fruit
        public List<string?>? PhotosFruits { get; set; }
    }
}
