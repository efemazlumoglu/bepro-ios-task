//
//  MyTableViewCell.swift
//  bepro-ios-task
//
//  Created by Efe Mazlumoğlu on 20.03.2022.
//

import Foundation
import UIKit

class MyTableViewCell: UITableViewCell {

    let title = UILabel()
    let name = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override func awakeFromNib() {
        super.awakeFromNib()

        title.translatesAutoresizingMaskIntoConstraints = false
        name.translatesAutoresizingMaskIntoConstraints = false

        contentView.addSubview(title)
        contentView.addSubview(name)
        
//        NSLayoutConstraint.activate([
//            
//        ])

    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }

}
