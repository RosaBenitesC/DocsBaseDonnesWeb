using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using Microsoft.EntityFrameworkCore;

namespace _4204D5_labo12.Models
{
    [Table("Etudiant", Schema = "Etudiants")]
    [Index("Prenom", "Nom", Name = "IX_Etudiant_PrenomNom")]
    public partial class Etudiant
    {
        public Etudiant()
        {
            EtudiantFruits = new HashSet<EtudiantFruit>();
        }

        [Key]
        [Column("EtudiantID")]
        public int EtudiantId { get; set; }
        [StringLength(50)]
        [Unicode(false)]
        public string Prenom { get; set; } = null!;
        [StringLength(50)]
        [Unicode(false)]
        public string Nom { get; set; } = null!;
        [Column(TypeName = "date")]
        public DateTime DateNaissance { get; set; }
        [StringLength(2)]
        [Unicode(false)]
        public string Classe { get; set; } = null!;

        [InverseProperty("Etudiant")]
        public virtual ICollection<EtudiantFruit> EtudiantFruits { get; set; }
    }
}
