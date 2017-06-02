//
//  RealmBrowserObjectViewController.swift
//  Pods
//
//  Created by Quang Tran on 02/06/2017.
//
//

import UIKit
import RealmSwift
import Realm

class RealmPropertyBrowser: UITableViewController, RealmPropertyCellDelegate {
    
    private var object: Object
    private var schema: ObjectSchema
    private var properties: Array <Property>
    private let cellIdentifier = "objectCell"
    private var isEditMode = false
    
    init(object: Object) {
        self.object = object
        schema = object.objectSchema
        properties = schema.properties
        
        super.init(nibName: nil, bundle: nil)
        
        self.title = self.schema.className
        
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        let bbi = UIBarButtonItem(title: "Edit", style: .plain, target: self, action: #selector(RealmPropertyBrowser.actionToggleEdit(_:)))
        navigationItem.rightBarButtonItem = bbi
        tableView.register(RealmPropertyCell.self, forCellReuseIdentifier: cellIdentifier)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: TableView Datasource & Delegate
    
    func setupCell(_ cell: UITableViewCell, indexPath: IndexPath) {
        if let cell = cell as? RealmPropertyCell {
            let property = properties[indexPath.row]
            let stringvalue = RealmTools.stringForProperty(property, object: object)
            var isArray = false
            if property.type == .array {
                isArray = true
            }
            let canEdit = isEditMode && property.name != schema.primaryKeyProperty?.name
            cell.cellWithAttributes(property.name, propertyValue: stringvalue, editMode: canEdit, property: property, isArray: isArray)
            cell.delegate = self
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier)
        if cell == nil {
            cell = UITableViewCell(style: UITableViewCellStyle.value1, reuseIdentifier: cellIdentifier) as! RealmPropertyCell
        }
        cell?.isUserInteractionEnabled = true
        setupCell(cell!, indexPath: indexPath)
        return cell!
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return properties.count
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if !isEditMode {
            let property = properties[indexPath.row]
            if property.type == .array {
                let results = object.dynamicList(property.name)
                if results.count > 0 {
                    let schema = results.first!.objectSchema
                    let pkName = schema.primaryKeyProperty?.name ?? schema.properties.first!.name
                    let objectsViewController = RealmObjectsBrowser(objects: results.sorted(byKeyPath: pkName), schema: schema, title: schema.className)
                    navigationController?.pushViewController(objectsViewController, animated: true)
                }
                else {
                    
                }
            } else if property.type == .object {
                guard let obj = object[property.name] else {
                    print("failed getting object for property")
                    return
                }
                let objectsViewController = RealmPropertyBrowser(object: obj as! Object)
                navigationController?.pushViewController(objectsViewController, animated: true)
            }
        }
        
    }
    
    func textFieldDidFinishEdit(_ input: String, property: Property) {
        self.savePropertyChangesInRealm(input, property: property)
        
        //        self.actionToggleEdit((self.navigationItem.rightBarButtonItem)!)
    }
    
    //MARK: private Methods
    
    private func savePropertyChangesInRealm(_ newValue: String, property: Property) {
        let letters = CharacterSet.letters

        switch property.type {
        case .bool:
            let propertyValue = Int(newValue)!
            saveValueForProperty(value: propertyValue, propertyName: property.name)
            break
        case .int:
            let range = newValue.rangeOfCharacter(from: letters)
            if  range == nil {
                let propertyValue = Int(newValue)!
                saveValueForProperty(value: propertyValue, propertyName: property.name)
            }
            break
        case .float:
            let propertyValue = Float(newValue)!
            saveValueForProperty(value: propertyValue, propertyName: property.name)
            break
        case .double:
            let propertyValue:Double = Double(newValue)!
            saveValueForProperty(value: propertyValue, propertyName: property.name)
            break
        case .string:
            let propertyValue:String = newValue as String
            saveValueForProperty(value: propertyValue, propertyName: property.name)
            break
        case .array:
            
            break
        case .object:
            
            break
        default:
            break
        }
        
    }
    
    private func saveValueForProperty(value:Any, propertyName:String) {
        do {
            let realm = try Realm()
            try realm.write {
            object.setValue(value, forKey: propertyName)
            }
        }catch {
            print("saving failed")
        }
    }
    
    func actionToggleEdit(_ id: UIBarButtonItem) {
        isEditMode = !isEditMode
        if isEditMode {
            id.title = "Finish"
        } else {
            id.title = "Edit"
        }
        tableView.reloadData()
    }
    
}
