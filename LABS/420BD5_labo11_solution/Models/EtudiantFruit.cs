using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using Microsoft.EntityFrameworkCore;

namespace _4204D5_labo12.Models
{
    [Table("EtudiantFruit", Schema = "Fruits")]
    [Index("EtudiantId", "FruitId", Name = "IX_EtudiantFruit_EtudiantIDFruiteID")]
    public partial class EtudiantFruit
    {
        [Key]
        [Column("EtudiantFruitID")]
        public int EtudiantFruitId { get; set; }
        [Column("EtudiantID")]
        public int EtudiantId { get; set; }
        [Column("FruitID")]
        public int FruitId { get; set; }

        [ForeignKey("EtudiantId")]
        [InverseProperty("EtudiantFruits")]
        public virtual Etudiant Etudiant { get; set; } = null!;
        [ForeignKey("FruitId")]
        [InverseProperty("EtudiantFruits")]
        public virtual Fruit Fruit { get; set; } = null!;
    }
}
