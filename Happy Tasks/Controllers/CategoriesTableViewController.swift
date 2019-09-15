//
//  CategoriesTableViewController.swift
//  Happy Tasks
//
//  Created by Jean martin Kyssama on 10/09/2019.
//  Copyright © 2019 Jean martin Kyssama. All rights reserved.
//

import UIKit
import CoreData

class CategoriesTableViewController: UITableViewController {
    // on cree le context
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    // on cree ici le tableau qui contient les differentes categories
    var tableauCategorie = [Categorie]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        listeCategories()
        //chargementCategories()

        
    }

    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableauCategorie.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "celluleCategorie", for: indexPath)
        
        let indexPathVariable = tableauCategorie[indexPath.row]
        
        cell.textLabel?.text = indexPathVariable.nom
        // se charge de la taille du texte
        cell.textLabel?.font = UIFont(name: (cell.textLabel?.font.fontName)!, size: 25)
        
        cell.imageView?.image = UIImage(named: indexPathVariable.image!)
        
        return cell
    }
    

    // MARK: - table view delegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "versTaches", sender: self)
    }
    
    
    // MARK: - data manipulation methods
    
    func sauvegardeCategories() {
        
        do {
            try context.save()
        } catch {
            print("Erreur dans la sauvegarde du contexte\(error)")
        }
    }
    
    //
    
    func chargementCategories() {
        let request : NSFetchRequest<Categorie> = Categorie.fetchRequest()
        do {
            tableauCategorie = try context.fetch(request)
            
        } catch {
            print("Erreur dans le chargement des données sauvegardées\(error)")
        }
        
        tableView.reloadData()
    }
    
    // MARK: - Liste des categories
    func listeCategories() {
        // on cree les differents objets et on les ajoute au tableau de categories
        let premiereCategorie = Categorie(context: context)
        premiereCategorie.nom = "Travail"
        premiereCategorie.image = "1"
        tableauCategorie.append(premiereCategorie)
        //
        let secondeCategorie = Categorie(context: context)
        secondeCategorie.nom = "Courses"
        secondeCategorie.image = "2"
        tableauCategorie.append(secondeCategorie)
        //
        let troisiemeCategorie = Categorie(context: context)
        troisiemeCategorie.nom = "Famille"
        troisiemeCategorie.image = "3"
        tableauCategorie.append(troisiemeCategorie)
        //
        let quatriemeCategorie = Categorie(context: context)
        quatriemeCategorie.nom = "Miscelanous"
        quatriemeCategorie.image = "4"
        tableauCategorie.append(quatriemeCategorie)
        
        // une fois cela fait, on enregistre le contexte
//        do {
//            try context.save()
//
//        } catch {
//            print("Impossible de sauvegarder les données dans le contexte\(error)")
//        }
//
//        tableView.reloadData()
        
    }
    
    
    
}
