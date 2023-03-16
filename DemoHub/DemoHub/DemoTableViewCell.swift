//
//  DemoTableViewCell.swift
//  DemoHub
//
//  Created by zhouluyao on 3/16/23.
//

import UIKit

class DemoTableViewCell: UITableViewCell {
    
    var demoNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.accessoryType = .disclosureIndicator

        contentView.addSubview(demoNameLabel) // Add the demoNameLabel as a subview of the cell's contentView
        
        NSLayoutConstraint.activate([
            demoNameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            demoNameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            demoNameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            demoNameLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8)
        ])
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
