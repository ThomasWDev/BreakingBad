//
//  BBCharecterDetailsVC.swift
//  BreakingBad
//
//  Created by Thomas Woodfin on 1/12/21.
//  Copyright © 2021 Thomas Woodfin. All rights reserved.
//

import UIKit

class BBCharecterDetailsVC: UIViewController {
    
    @IBOutlet weak private var characterImageView: UIImageView!
    @IBOutlet weak private var nameLbl: UILabel!
    @IBOutlet weak private var occupationLbl: UILabel!
    @IBOutlet weak private var statusLbl: UILabel!
    @IBOutlet weak private var nickNameLbl: UILabel!
    @IBOutlet weak private var appearanceLbl: UILabel!
    
    
    var characterModel: CharecterResponse?

    override func viewDidLoad() {
        super.viewDidLoad()

        setData()
    }
    
    private func setData(){
        let name = characterModel?.name ?? ""
        let status = characterModel?.status ?? ""
        let nickName = characterModel?.nickname ?? ""
        let imageUrl = characterModel?.img ?? ""
        
        
        let nameAttributed = "Name: \(name)".attributedStringWithColor(["Name:"], color: UIColor.black)
        let statusAttributed = "Status: \(status)".attributedStringWithColor(["Status:"], color: UIColor.black)
        let nickNameAttributed = "Nickname: \(nickName)".attributedStringWithColor(["Nickname:"], color: UIColor.black)
        
        nameLbl.attributedText = nameAttributed
        statusLbl.attributedText = statusAttributed
        nickNameLbl.attributedText = nickNameAttributed
        
        characterImageView.sd_setImage(with: URL(string: imageUrl), placeholderImage: UIImage(named: "placeholder"))
        
        setOccupation()
        setAppearanceLbl()
    }
    
    private func setOccupation(){
        guard let occupation = characterModel?.occupationList else {return}
        let arr = occupation.joined(separator: ",\n")
        let occupationAttributed = "occupation: \(arr)".attributedStringWithColor(["occupation:"], color: UIColor.black)
        occupationLbl.attributedText = occupationAttributed
    }
    
    private func setAppearanceLbl(){
        guard let appearance = characterModel?.appearance else {return}
        let arr = appearance.map { (int) -> String in
            return String(int)
            }.joined(separator: ", ")
        let occupationAttributed = "appearance: \(arr)".attributedStringWithColor(["appearance:"], color: UIColor.black)
        appearanceLbl.attributedText = occupationAttributed
    }
}
