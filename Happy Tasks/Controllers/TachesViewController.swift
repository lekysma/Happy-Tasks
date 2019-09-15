//
//  ViewController.swift
//  Happy Tasks
//
//  Created by Jean martin Kyssama on 10/09/2019.
//  Copyright © 2019 Jean martin Kyssama. All rights reserved.
//

import UIKit
import CoreData

class TachesViewController: UITableViewController {
    
    // on cree un tableau qui enregistre tous les elements
    var tableauTaches = [Tache]()
    // on cree le contexte
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    //gere la relation entre la categorie cliquée et les taches affichees
    var categorieSelectionnee : Categorie? {
        didSet {
            chargementTaches()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    // MARK: - Table view delegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Chaque fois qu'on clique sur une cellule on s'assure que sa proprieté 'done' change
        tableauTaches[indexPath.row].done.toggle()
        
        // on ajoute une animation
        tableView.deselectRow(at: indexPath, animated: true)
        
        // et on sauvegarde les donnees
        sauvegardeTaches()
        
    }
   
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableauTaches.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "celluleTache", for: indexPath)
        let tacheIndexPathRow = tableauTaches[indexPath.row]
        
        cell.textLabel?.text = tacheIndexPathRow.nom
        cell.textLabel?.font = UIFont(name: (cell.textLabel?.font.fontName)!, size: 18)
        
        // ici on gere le fait d'affecter un checkmark a une cellule dont la propriete done est positive et vice versa
        if tacheIndexPathRow.done == true {
            cell.accessoryType = .checkmark
        } else {
            cell.accessoryType = .none
        }
        
        return cell
    }
    
    
    // MARK: - Data manipulation methods
    
    //Sauvegarde
    func sauvegardeTaches() {
        do {
            try context.save()
            
        } catch {
            print("Impossible de sauvegarder les données\(error)")
        }
        // et on recharge la table view
        tableView.reloadData()
        
    }
    //Chargement
    func chargementTaches(avec request: NSFetchRequest<Tache> = Tache.fetchRequest(), predicate: NSPredicate? = nil) {
        //gere le fait de charger uniquement les taches de la categorie selectionnee
        let categoriePredicate = NSPredicate(format: "categorieParent.nom MATCHES %@", categorieSelectionnee!.nom!)
        
        if let additionalPredicate = predicate {
            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoriePredicate, additionalPredicate])
        } else {
            request.predicate = categoriePredicate
        }
        //gestion du chargement des donnees
        
        do {
            tableauTaches = try context.fetch(request)
        } catch {
            print("Impossible de charger les tâches\(error)")
        }
        tableView.reloadData()
    }
    
    // MARK: - Ajout d'une nouvelle tache
    
    @IBAction func ajoutNouvelleTache(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        let alert = UIAlertController(title: "Nouvelle tâche", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Ajouter la tâche", style: .default) { (UIAlertAction) in
            // quand on clique sur le bouton, toute l'action se passe ici
            
            let nouvelleTache = Tache(context: self.context)
            nouvelleTache.nom = textField.text
            nouvelleTache.done = false
            //on lui affecte une categorie parent
            nouvelleTache.categorieParent = self.categorieSelectionnee
            self.tableauTaches.append(nouvelleTache)
            
            // on sauvegarde
            self.sauvegardeTaches()
            
        }
        // action et textField
        alert.addAction(action)
        alert.addTextField { (UITextField) in
            UITextField.placeholder = "Tapez ici"
            textField = UITextField
        }
        
        // presentation
        present(alert, animated: true, completion: nil)
    }
    


}

