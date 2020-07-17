//
//  ViewController.swift
//  CoreDataDemo5New
//
//  Created by Alex Nagy on 17/07/2020.
//  Copyright © 2020 Alex Nagy. All rights reserved.
//

import UIKit
import SparkUI
import Layoutless

import CoreData

// MARK: - Protocols

class ViewController: SViewController {
    
    // MARK: - Navigator
    
    // MARK: - Dependencies
    
    var coreDataStack: CoreDataStack!
    
    // MARK: - Delegates
    
    // MARK: - Properties
    
    //    var cats = [Cat]()
    
//    lazy var fetchedResultsController: NSFetchedResultsController<Cat> = {
//
//        let fetchRequest: NSFetchRequest<Cat> = Cat.fetchRequest()
//
//        //        let sort = NSSortDescriptor(key: #keyPath(Cat.name), ascending: true)
//        //        fetchRequest.sortDescriptors = [sort]
//
//        let citySort = NSSortDescriptor(key: #keyPath(Cat.city), ascending: true)
//        let votesSort = NSSortDescriptor(key: #keyPath(Cat.votes), ascending: false)
//        let nameSort = NSSortDescriptor(key: #keyPath(Cat.name), ascending: true)
//        fetchRequest.sortDescriptors = [citySort, votesSort, nameSort]
//
//        let fetchedResultsController = NSFetchedResultsController(
//            fetchRequest: fetchRequest,
//            managedObjectContext: coreDataStack.managedContext,
//            sectionNameKeyPath: #keyPath(Cat.city),
//            cacheName: "catlection")
//
//        fetchedResultsController.delegate = self
//
//        return fetchedResultsController
//    }()
    
    let citySort = NSSortDescriptor(key: #keyPath(Cat.city), ascending: true)
    let votesSort = NSSortDescriptor(key: #keyPath(Cat.votes), ascending: false)
    let nameSort = NSSortDescriptor(key: #keyPath(Cat.name), ascending: true)
    lazy var sortDescriptors = [citySort, votesSort, nameSort]
    
    lazy var coreDataFetchedResults = CoreDataFetchedResults(ofType: Cat.self, entityName: "Cat", sortDescriptors: sortDescriptors, managedContext: coreDataStack.managedContext, delegate: self, sectionNameKeyPath: #keyPath(Cat.city), cacheName: "catlection")
    
    // MARK: - Buckets
    
    // MARK: - Navigation items
    
    lazy var addBarButtonItem = UIBarButtonItem(title: "Add", style: .done) {
        self.addCat()
    }
    
    // MARK: - Views
    
    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(CatCell.self, forCellReuseIdentifier: CatCell.reuseIdentifier)
        tableView.register(CatHeader.self, forHeaderFooterViewReuseIdentifier: CatHeader.reuseIdentifier)
        tableView.rowHeight = 100
        tableView.sectionHeaderHeight = 50
        return tableView
    }()
    
    // MARK: - init - deinit
    
    // MARK: - Lifecycle
    
    override func preLoad() {
        super.preLoad()
    }
    
    override func onLoad() {
        super.onLoad()
        
        let predicate = NSPredicate(format: "%K != %@", #keyPath(Cat.imageName), "dog")
        coreDataFetchedResults.controller.fetchRequest.predicate = predicate
//        coreDataFetchedResults.controller.fetchRequest.fetchLimit = 2
        
        coreDataFetchedResults.performFetch()
    }
    
    override func onAppear() {
        super.onAppear()
    }
    
    override func onDisappear() {
        super.onDisappear()
    }
    
    // MARK: - Configure
    
    override func configureNavigationBar() {
        super.configureNavigationBar()
        
        title = "Catlection"
        navigationItem.setRightBarButton(addBarButtonItem, animated: false)
    }
    
    override func configureViews() {
        super.configureViews()
    }
    
    // MARK: - Layout
    
    override func layoutViews() {
        super.layoutViews()
        
        stack(.vertical)(
            tableView
        ).fillingParent().layout(in: container)
    }
    
    // MARK: - Interaction
    
    override func addActions() {
        super.addActions()
    }
    
    override func subscribe() {
        super.subscribe()
    }
    
    // MARK: - internal
    
    // MARK: - private
    
    // MARK: - fileprivate
    
    fileprivate func addCat() {
        
        let imageTextField = UITextField()
        imageTextField.autocapitalizationType = .none
        imageTextField.placeholder = "Image (cat0...9)"
        
        let nameTextField = UITextField()
        nameTextField.autocapitalizationType = .words
        nameTextField.placeholder = "Name"
        
        let cityTextField = UITextField()
        cityTextField.autocapitalizationType = .words
        cityTextField.placeholder = "City"
        
        Alert.show(.alert, title: "Add cat representative", message: nil, textFields: [imageTextField, nameTextField, cityTextField]) { (texts) in
            guard let texts = texts else { return }
            let imageName = texts[0]
            let name = texts[1]
            let city = texts[2]
            
            let cat = Cat(context: self.coreDataStack.managedContext)
            cat.imageName = imageName
            cat.name = name
            cat.city = city
            
            self.coreDataStack.saveContext()
        }
        
    }
    
    // MARK: - public
    
    // MARK: - open
    
    // MARK: - @objc Selectors
    
}

// MARK: - Delegates

extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = tableView.dequeueReusableHeaderFooterView(withIdentifier: CatHeader.reuseIdentifier) as! CatHeader
        //        let header = "Header"
        let sectionInfo = coreDataFetchedResults.controller.sections?[section]
        let header = sectionInfo?.name
        view.item = header
        return view
    }
}

// MARK: - Datasources

extension ViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        //        1
        coreDataFetchedResults.controller.sections?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //        cats.count
        guard let sectionInfo = coreDataFetchedResults.controller.sections?[section] else {
            return 0
        }
        
        return sectionInfo.numberOfObjects
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CatCell.reuseIdentifier, for: indexPath) as! CatCell
        //        let cat = cats[indexPath.row]
        let cat = coreDataFetchedResults.controller.object(at: indexPath)
        cell.item = cat
        return cell
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete", handler: { (action, view, success) in
            let cat = self.coreDataFetchedResults.controller.object(at: indexPath)
//            self.coreDataStack.managedContext.delete(cat)
//            self.coreDataStack.saveContext()
            self.coreDataFetchedResults.managedContext.delete(cat)
        })
        deleteAction.backgroundColor = .red
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cat = coreDataFetchedResults.controller.object(at: indexPath)
        cat.votes = cat.votes + 1
//        coreDataStack.saveContext()
        self.coreDataFetchedResults.saveContext()
    }
    
}

// MARK: - Extensions

// MARK: - NSFetchedResultsControllerDelegate
extension ViewController: NSFetchedResultsControllerDelegate {
    
    //    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
    //        tableView.reloadData()
    //    }
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>,
                    didChange anObject: Any,
                    at indexPath: IndexPath?,
                    for type: NSFetchedResultsChangeType,
                    newIndexPath: IndexPath?) {
        
        switch type {
        case .insert:
            tableView.insertRows(at: [newIndexPath!], with: .automatic)
        case .delete:
            tableView.deleteRows(at: [indexPath!], with: .automatic)
        case .update:
            let cell = tableView.cellForRow(at: indexPath!) as! CatCell
            let cat = coreDataFetchedResults.controller.object(at: indexPath!)
            cell.item = cat
        case .move:
            tableView.deleteRows(at: [indexPath!], with: .automatic)
            tableView.insertRows(at: [newIndexPath!], with: .automatic)
        @unknown default:
            print("Unexpected NSFetchedResultsChangeType")
        }
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>,
                    didChange sectionInfo: NSFetchedResultsSectionInfo,
                    atSectionIndex sectionIndex: Int,
                    for type: NSFetchedResultsChangeType) {
        
        let indexSet = IndexSet(integer: sectionIndex)
        
        switch type {
        case .insert:
            tableView.insertSections(indexSet, with: .automatic)
        case .delete:
            tableView.deleteSections(indexSet, with: .automatic)
        default: break
        }
    }
}


