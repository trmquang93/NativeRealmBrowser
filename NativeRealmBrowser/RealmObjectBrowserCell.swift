//
//  RealmObjectBrowserCell.swift
//  Pods
//
//  Created by Quang Tran on 02/06/2017.
//
//

import UIKit
import RealmSwift

class RealmObjectBrowserCell: UITableViewCell {
    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var labelDetailText: UILabel!
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        initSetup()
        createConstraint()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setupCell(schema: ObjectSchema) {
        labelTitle.text = schema.className
        labelDetailText.text = "Objects in realm: \(resultsForObjectSchema(schema).count)"
    }
    
    func setupCell(realmObject: Object) {
        var text = ""
        for (index, property) in realmObject.objectSchema.properties.enumerated() {
            
            let value = RealmTools.stringForProperty(property, object: realmObject)
            if index == 0 {
                labelTitle.text = "\(property.name): \(value)"
            }
            else if index < 3 {
                text += text.isEmpty ? "" : "\n"
                text += "\(property.name): \(value)"
            }
            else {
                break
            }
        }
        labelDetailText.text = text
    }

    func createConstraint() {
        let viewsDict: [String: Any] = ["labelTitle":labelTitle, "labelDetailText":labelDetailText]
        let constraints: [NSLayoutConstraint] = [
            NSLayoutConstraint.constraints(withVisualFormat: "H:|-[labelTitle]-|", options: [], metrics: nil, views: viewsDict),
            NSLayoutConstraint.constraints(withVisualFormat: "H:|-[labelDetailText]-|", options: [], metrics: nil, views: viewsDict),
            
            NSLayoutConstraint.constraints(withVisualFormat: "V:|-[labelTitle][labelDetailText]-|", options: [], metrics: nil, views: viewsDict)
            ].flatMap{$0}
        
        NSLayoutConstraint.activate(constraints)
    }
    
    func initSetup() {
        var newLabel = UILabel()
        newLabel.translatesAutoresizingMaskIntoConstraints = false
        newLabel.font = .systemFont(ofSize: 16)
        newLabel.numberOfLines = 0
        addSubview(newLabel)
        labelTitle = newLabel
        
        newLabel = UILabel()
        newLabel.translatesAutoresizingMaskIntoConstraints = false
        newLabel.font = .systemFont(ofSize: 11)
        newLabel.numberOfLines = 0
        addSubview(newLabel)
        labelDetailText = newLabel
    }
    
    
    private func resultsForObjectSchema(_ schema: ObjectSchema)-> Results<DynamicObject> {
        let results = try! Realm().dynamicObjects(schema.className)
        return results
    }
}
