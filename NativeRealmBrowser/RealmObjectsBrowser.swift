//
//  RealmObjectsBrowser.swift
//  Pods
//
//  Created by Quang Tran on 02/06/2017.
//
//

import UIKit
import RealmSwift
import Realm
import Foundation

class RealmObjectsBrowser: UITableViewController, UIViewControllerPreviewingDelegate {
    
    private var objects: Results<DynamicObject>
    private var objectSchema: ObjectSchema
    private let cellIdentifier = "objectCell"
    private var isEditMode: Bool = false
    private var selectAll: Bool = false
    private var selectedIndexs: [Int] = []
    private var realmNotification: NotificationToken?
    
    private lazy var addButton: UIBarButtonItem = UIBarButtonItem(title: "Add", style: .plain, target: self, action: #selector(addObject(_:)))
    
    init(objects: Results<DynamicObject>, schema: ObjectSchema, title: String? = nil) {
        
        self.objects = objects
        self.objectSchema = schema
        super.init(nibName: nil, bundle: nil)
        self.title = title ?? "Objects"
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(RealmObjectBrowserCell.self, forCellReuseIdentifier: cellIdentifier)
        navigationItem.rightBarButtonItem = addButton
        
        realmNotification = objects.addNotificationBlock({ [weak self] (changes) in
            guard let tableView = self?.tableView else { return }
            switch changes {
            case .initial(_):
                tableView.reloadData()
                break
            case .update(_, deletions: let deletions, insertions: let insertions, modifications: let modifications):
                tableView.beginUpdates()
                tableView.deleteRows(at: deletions.map({IndexPath(row: $0, section: 0)}), with: .automatic)
                tableView.insertRows(at: insertions.map({IndexPath(row: $0, section: 0)}), with: .automatic)
                tableView.reloadRows(at: modifications.map({IndexPath(row: $0, section: 0)}), with: .automatic)
                tableView.endUpdates()
                break
            default: break
            }
        })
    }
    
    func setupCell(_ cell: UITableViewCell, indexPath: IndexPath) {
        if let objectCell = cell as? RealmObjectBrowserCell {
            let object = objects[indexPath.row]
            objectCell.setupCell(realmObject: object)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        if #available(iOS 9.0, *) {
            switch traitCollection.forceTouchCapability {
            case .available:
                registerForPreviewing(with: self, sourceView: tableView)
                break
            case .unavailable:
                break
            case .unknown:
                break
            }
        }
    }
    
    
    //MARK: TableView Datasource & Delegate
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
        setupCell(cell, indexPath: indexPath)
        return cell
    }
    
    override  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return objects.count
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    override func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let vc = RealmPropertyBrowser(object:self.objects[indexPath.row])
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
        return .delete
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            deleteObjectsAtIndexs([indexPath.row])
        }
    }
    
    //MARK: private Methods
    
    func addObject(_ button: UIBarButtonItem) {
        let realm = try! Realm()
        var value: [String: Any] = [:]
        var update = false
        if let primaryKey = objectSchema.primaryKeyProperty, objectSchema.properties.map({$0.name}).contains(primaryKey.name) {
            update = true
            switch primaryKey.type {
            case .int:
                value[primaryKey.name] = Int(Date().timeIntervalSince1970)
            case .string:
                value[primaryKey.name] = "\(Int(Date().timeIntervalSince1970))"
            default: break
            }
        }
        
        
        try! realm.write {
            if update {
                realm.dynamicCreate(objectSchema.className, value: value, update: true)
            }
            else {
                realm.dynamicCreate(objectSchema.className)
            }
        }
    }
    
    func actionTogglePreview(_ id: AnyObject) {
        
    }
    
    private func deleteObjectsAtIndexs(_ indexs: [Int]) {
        let realm = try! Realm()
        
        if indexs.count > 0 {
            let objectsToDelete = objects
                .enumerated()
                .filter{indexs.contains($0.offset)}
                .map{$0.element}
            
            try! realm.write {
                realm.delete(objectsToDelete)
            }
        }
    }
    
    //MARK: UIViewControllerPreviewingDelegate
    
    @available(iOS 9.0, *)
    public func previewingContext(_ previewingContext: UIViewControllerPreviewing, viewControllerForLocation location: CGPoint) -> UIViewController? {
        guard let indexPath = tableView?.indexPathForRow(at:location) else { return nil }
        
        guard let cell = tableView?.cellForRow(at:indexPath) else { return nil }
        
        let detailVC =  RealmPropertyBrowser(object:self.objects[indexPath.row])
        detailVC.preferredContentSize = CGSize(width: 0.0, height: 300)
        previewingContext.sourceRect = cell.frame
        
        return detailVC;
    }
    
    @available(iOS 9.0, *)
    public func previewingContext(_ previewingContext: UIViewControllerPreviewing, commit viewControllerToCommit: UIViewController) {
        navigationController?.pushViewController(viewControllerToCommit, animated: true)
    }
    
}
