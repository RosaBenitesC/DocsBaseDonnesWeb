using System;
using System.Collections.Generic;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata;
using _4204D5_labo12.Models;

namespace _4204D5_labo12.Data
{
    public partial class Labo12Context : DbContext
    {
        public Labo12Context()
        {
        }

        public Labo12Context(DbContextOptions<Labo12Context> options)
            : base(options)
        {
        }

        public virtual DbSet<Changelog> Changelogs { get; set; } = null!;
        public virtual DbSet<Etudiant> Etudiants { get; set; } = null!;
        public virtual DbSet<EtudiantFruit> EtudiantFruits { get; set; } = null!;
        public virtual DbSet<Fruit> Fruits { get; set; } = null!;

        protected override void OnConfiguring(DbContextOptionsBuilder optionsBuilder)
        {
            if (!optionsBuilder.IsConfigured)
            {
                optionsBuilder.UseSqlServer("Name=Labo12");
            }
        }

        protected override void OnModelCreating(ModelBuilder modelBuilder)
        {
            modelBuilder.Entity<Changelog>(entity =>
            {
                entity.Property(e => e.InstalledOn).HasDefaultValueSql("(getdate())");
            });

            modelBuilder.Entity<Etudiant>(entity =>
            {
                entity.Property(e => e.Classe).IsFixedLength();
            });

            modelBuilder.Entity<EtudiantFruit>(entity =>
            {
                entity.HasOne(d => d.Etudiant)
                    .WithMany(p => p.EtudiantFruits)
                    .HasForeignKey(d => d.EtudiantId)
                    .HasConstraintName("FK_EtudiantFruit_EtudiantID");

                entity.HasOne(d => d.Fruit)
                    .WithMany(p => p.EtudiantFruits)
                    .HasForeignKey(d => d.FruitId)
                    .HasConstraintName("FK_EtudiantFruit_FruitID");
            });

            modelBuilder.Entity<Fruit>(entity =>
            {
                entity.Property(e => e.Identifiant).HasDefaultValueSql("(newid())");
            });

            OnModelCreatingPartial(modelBuilder);
        }

        partial void OnModelCreatingPartial(ModelBuilder modelBuilder);
    }
}
