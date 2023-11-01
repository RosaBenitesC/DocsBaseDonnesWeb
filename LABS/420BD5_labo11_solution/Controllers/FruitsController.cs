using _4204D5_labo12.Data;
using _4204D5_labo12.Models;
using _4204D5_labo12.ViewModels;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;

namespace _4204D5_labo12.Controllers
{
    public class FruitsController : Controller
    {
        private readonly Labo12Context _context;

        public FruitsController(Labo12Context context)
        {
            _context = context;
        }

        public IActionResult Index()
        {
            return View();
        }

        public IActionResult AjouterImage()
        {
            return View();
        }

        [HttpPost]
        public async Task<IActionResult> AjouterImage(ImageUploadVM iuvm)
        {
            if(_context.Fruits == null)
            {
                return Problem("Entity set 'Labo12Context.Fruits' is null.");
            }

            if (ModelState.IsValid)
            {
                MemoryStream stream = new MemoryStream();
                await iuvm.FormFile.CopyToAsync(stream);
                byte[] photo = stream.ToArray();

                Fruit? fruit = await _context.Fruits.FirstOrDefaultAsync(x => x.Nom == iuvm.NomFruit);
                if(fruit == null)
                {
                    ModelState.AddModelError("NomFruit", "Ce fruit n'existe pas.");
                    return View();
                }

                fruit.Photo = photo;
                await _context.SaveChangesAsync();
                ViewData["message"] = "Image ajoutée pour " + iuvm.NomFruit + " !";
                return View("Index");
            }
            ModelState.AddModelError("", "Il y a un problème avec le fichier fourni");
            return View();
        }

        public IActionResult PreferenceEtudiant()
        {
            return View(new FruitsPreferesVM() { Prenom = "", Nom = ""});
        }

        [HttpPost]
        public async Task<IActionResult> PreferenceEtudiant(FruitsPreferesVM fpvm)
        {
            DateTime tempsAvant = DateTime.Now;

            // Si la BD n'existe pas
            if (_context.Fruits == null || _context.Etudiants == null || _context.EtudiantFruits == null)
            {
                return Problem("An entity set from 'Labo12Context' is null.");
            }

            // On recherche l'étudiant par son prénom et son nom
            Etudiant? etudiant = await _context.Etudiants.FirstOrDefaultAsync(x => x.Prenom == fpvm.Prenom && x.Nom == fpvm.Nom);
            if(etudiant == null)
            {
                ModelState.AddModelError("", "Cet étudiant n'existe pas.");
                return View();
            }

            // Cette liste contient les trois fruits préférés de l'étudiant
            List<Fruit> fruitsPreferes = etudiant.EtudiantFruits.Select(x => x.Fruit).ToList();

            // On remplit la liste qui contient les NOMS des fruits
            fpvm.NomsFruits = fruitsPreferes.Select(x => x.Nom).ToList();

            // On remplit la liste qui contient les PHOTOS des fruits
            fpvm.PhotosFruits = fruitsPreferes
								.Select(x => x.Photo == null ? null : $"data:image/png;base64, {Convert.ToBase64String(x.Photo)}")
								.ToList();

            DateTime tempsApres = DateTime.Now;
            ViewData["temps"] = tempsApres.Subtract(tempsAvant).TotalMilliseconds;

            return View(fpvm);
        }
    }
}
