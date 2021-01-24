//
//  BBCharecterListCell.swift
//  BreakingBad
//
//  Created by Thomas Woodfin on 1/12/21.
//  Copyright © 2021 Thomas Woodfin. All rights reserved.
//

import UIKit
import SDWebImage

class BBCharecterListCell: UITableViewCell {
    
    static let identifire = "BBCharecterListCell"
    @IBOutlet weak private var charecterImageView: UIImageView!
    @IBOutlet weak private var charecterNameLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func configureCell(vm: BBCharecterListVM, index: Int){
        let imageUrl = vm.characterTempList[index].img ?? ""
        let name = vm.characterTempList[index].name ?? ""
        charecterImageView.sd_setImage(with: URL(string: imageUrl), placeholderImage: UIImage(named: "placeholder"))
        charecterNameLbl.text = name
    }

}
