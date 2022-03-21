//
//  TableViewCell.swift
//  Notes
//
//  Created by Анита Самчук on 06.02.2022.
//

import UIKit
import SnapKit

class TableViewCell: UITableViewCell {

    static let identifier = "TableViewCell"
    
    private let titleLabel: UILabel = {
        let title = UILabel()
        title.textColor = .label
        title.font = UIFont.boldSystemFont(ofSize: 20)
        return title
    }()
    
    private let noteLabel: UILabel = {
        let note = UILabel()
        note.textColor = .secondaryLabel
        note.font = UIFont.systemFont(ofSize: 15)
        return note
    }()
    
    func typeset() {
        contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(5)
            make.left.right.equalToSuperview().inset(20)
        }
        
        contentView.addSubview(noteLabel)
        noteLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(1)
            make.left.right.equalTo(titleLabel)
            
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        typeset()
    }
    
    func configure(row: Int) {
        let currentItem = noteItems[row]

        titleLabel.text = currentItem["title"]
        noteLabel.text = currentItem["note"]
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        typeset()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
