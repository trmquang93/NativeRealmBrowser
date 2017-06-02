//
//  RealmBrowser.swift
//  Pods
//
//  Created by Quang Tran on 02/06/2017.
//
//

import UIKit
import RealmSwift

    /**

    RealmBrowser is a lightweight database browser for RealmSwift based on
    NBNRealmBrowser by Nerdish by Nature.
    Use one of the three methods below to get an instance of RealmBrowser and
    use it for debug pruposes.

    RealmBrowser displays objects and their properties as well as their properties'
    values.

    Easily modify properties by switching into 'Edit' mode. Your changes will be commited
    as soon as you finish editing.
    Currently only Bool, Int, Float, Double and String are editable with an option to expand.

    - warning: This browser only works with RealmSwift because Realm (Objective-C) and RealmSwift
    'are not interoperable and using them together is not supported.'

    */

public class RealmBrowser: UITableViewController {

    private let cellIdentifier = "RBSREALMBROWSERCELL"
    private var objectsSchema: Array<ObjectSchema> = []
    private var ascending = false

    /**
     Initialises the UITableViewController, sets title, registers datasource & delegates & cells

     -parameter realm: Realm
     */

    private init(realm: Realm) {
        super.init(nibName: nil, bundle: nil)

        self.title = "Realm Browser"
        self.tableView.delegate = self
        self.tableView.dataSource = self
        tableView.tableFooterView = UIView()
        self.tableView.register(RealmObjectBrowserCell.self, forCellReuseIdentifier: cellIdentifier)
        
        objectsSchema = try! Realm().schema.objectSchema
        
        let bbiDismiss = UIBarButtonItem(barButtonSystemItem: .stop, target: self, action: #selector(RealmBrowser.dismissBrowser))
        let bbiSort = UIBarButtonItem(title: "Sort A-Z", style: .plain, target: self, action: #selector(RealmBrowser.sortObjects))
        self.navigationItem.rightBarButtonItems = [bbiDismiss, bbiSort]
    }

    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
        
    }
    /**
     required initializer
     Returns an object initialized from data in a given unarchiver.
     self, initialized using the data in decoder.

     - parameter coder:NSCoder
     - returns self, initialized using the data in decoder.
     */

    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    //MARK: Realm browser convenience method(s)

    /**
     Instantiate the browser using default Realm.

     - return an instance of realmBrowser
     */
    public static func realmBrowser() -> UINavigationController? {
        do {
            let realm = try Realm()
            return self.realmBrowserForRealm(realm)
        }catch {
            print("realm init failed")
            return nil
        }
    }

    /**
     Instantiate the browser using a specific version of Realm.

     - parameter realm: Realm
     - returns an instance of realmBrowser
     */
    public static func realmBrowserForRealm(_ realm: Realm) -> UINavigationController? {
        let rbsRealmBrowser = RealmBrowser(realm:realm)
        let navigationController = UINavigationController(rootViewController: rbsRealmBrowser)
        return navigationController
    }

    /**
     Instantiate the browser using a specific version of Realm at a specific path.
     init(path: String) is deprecated.

     realmBroswerForRealmAtPath now uses the convenience initialiser init(fileURL: NSURL)

     - parameter url: URL
     - returns an instance of realmBrowser
     */
    public static func realmBroswerForRealmURL(_ url: URL) -> UINavigationController? {
        do {
            let realm = try Realm(fileURL: url)
            return self.realmBrowserForRealm(realm)
        }catch {
            print("realm instacne at url not found.")
            return nil
        }
    }

    /**
     Dismisses the browser
     
     - parameter id: a UIBarButtonItem
     */
    func dismissBrowser(_ id:UIBarButtonItem) {
        self.dismiss(animated: true)
    }
    
    /**
     Sorts the objects classes by name
     
     - parameter id: a UIBarButtonItem
     */
    func sortObjects(_ id:UIBarButtonItem) {
        id.title = ascending == false ?"Sort Z-A": "Sort A-Z"
        ascending = !ascending
        objectsSchema = objectsSchema.sorted(by: {($0.className < $1.className) == ascending})
        tableView.reloadData()
    }

    //MARK: TableView Datasource & Delegate

    /**
     TableView DataSource method
     Asks the data source for a cell to insert in a particular location of the table view.

     - parameter tableView: UITableView
     - parameter indexPath: NSIndexPath

     - returns a UITableViewCell
     */
    override public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as! RealmObjectBrowserCell

        let schema = objectsSchema[indexPath.row]
        
        cell.setupCell(schema: schema)
        return cell
    }

    /**
     TableView DataSource method
     Tells the data source to return the number of rows in a given section of a table view.

     - parameter tableView: UITableView
     - parameter section: Int

     - return number of cells per section
     */
    override public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return objectsSchema.count
    }

    /**
     TableView Delegate method

     Asks the delegate for the height to use for a row in a specified location.
     A nonnegative floating-point value that specifies the height (in points) that row should be.

     - parameter tableView: UITableView
     - parameter indexPath: NSIndexPath

     - return height of a single tableView row
     */
    override public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }

    /**
     TableView Delegate method to handle cell selection

     - parameter tableView: UITableView
     - parameter indexPath: NSIndexPath

     */
    public override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let results = resultsForObjectSchemaAtIndex(indexPath)
        let vc = RealmObjectsBrowser(objects: results, schema: objectsSchema[indexPath.row], title: objectsSchema[indexPath.row].className)
        self.navigationController?.pushViewController(vc, animated: true)
    }

    //MARK: private Methods

    /**
     Used to get all objects for a specific object type in Realm

     - parameter index: Int
     - return all objects for a an Realm object at an index
     */
    
    private func resultsForObjectSchemaAtIndex(_ indexPath: IndexPath)-> Results<DynamicObject> {
        let schema = objectsSchema[indexPath.row]
        let results = try! Realm().dynamicObjects(schema.className)
        return results
    }
    
    public static func showBrowser() {
        if let vc = UIApplication.topViewController(), let browserVC = realmBrowser() {
            vc.present(browserVC, animated: true, completion: nil)
        }
    }
}
