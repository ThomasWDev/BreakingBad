//
//  BBCharecterListVC.swift
//  BreakingBad
//
//  Created by Thomas Woodfin on 1/12/21.
//  Copyright © 2021 Thomas Woodfin. All rights reserved.
//

import UIKit

class BBCharecterListVC: UIViewController {
    
    @IBOutlet weak private var searchFld: UITextField!
    @IBOutlet weak private var searchView: UIView!
    @IBOutlet weak private var tblView: UITableView!
    @IBOutlet weak private var appearanceSlider: UISlider!
    
    private let viewModel = BBCharecterListVM()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        style()
        getData()
    }
    
    private func style(){
        searchView.layer.cornerRadius = 8
        searchView.layer.borderWidth = 1
        searchView.layer.borderColor = UIColor.darkGray.cgColor
        
        tblView.estimatedRowHeight = 100
        
        searchFld.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
    }
    
    @IBAction func sliderValueChageAction(_ sender: UISlider) {
        let value = Int(sender.value)
        guard let list = viewModel.characterList else {return}
        viewModel.characterTempList = list.filter { (model) -> Bool in
            guard let appearance = model.appearance else {return false}
            return appearance.contains(value)
        }
        tblView.reloadData()
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        guard let txt = textField.text else {return}
        if txt.count == 0 {
            guard let list = viewModel.characterList else {return}
            viewModel.characterTempList = list
        }else{
            viewModel.characterTempList = viewModel.characterTempList.filter { (model) -> Bool in
                guard let name = model.name?.lowercased() else {return false}
                return name.contains(txt)
            }
        }
        
        tblView.reloadData()
    }
    
    private func getData(){
        viewModel.getCharacterList {[weak self] (success) in
            if success{
                self?.tblView.reloadData()
                self?.setSliderMinMax()
            }
        }
    }
    
    private func setSliderMinMax(){
        var maxArr = [Int]()
        var minArr = [Int]()
        
        for arr in viewModel.characterTempList{
            let max = arr.appearance?.max() ?? 0
            let min = arr.appearance?.min() ?? 0
            
            maxArr.append(max)
            minArr.append(min)
        }
        
        let finalMax = maxArr.max() ?? 0
        let finalMin = maxArr.min() ?? 0
        
        appearanceSlider.maximumValue = Float(finalMax)
        appearanceSlider.minimumValue = Float(finalMin)
        appearanceSlider.value = Float(finalMin)
    }
}

extension BBCharecterListVC: UITableViewDataSource, UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.characterTempList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: BBCharecterListCell.identifire, for: indexPath) as! BBCharecterListCell
        cell.configureCell(vm: viewModel, index: indexPath.row)
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        showDetailsView(index: indexPath.row)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    private func showDetailsView(index: Int){
        let storyboard = UIStoryboard(storyboard: .main)
        let vc = storyboard.instantiateViewController(withIdentifier: BBCharecterDetailsVC.self)
        vc.characterModel = viewModel.characterTempList[index]
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}
