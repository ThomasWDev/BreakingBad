//
//  BBCharecterListVM.swift
//  BreakingBad
//
//  Created by Thomas Woodfin on 1/12/21.
//  Copyright © 2021 Thomas Woodfin. All rights reserved.
//

import Foundation
import SVProgressHUD

class BBCharecterListVM{
    
    var characterList: [CharecterResponse]?
    var characterTempList = [CharecterResponse]()
    
    func getCharacterList (completion: @escaping (_ success: Bool) -> Void) {
        SVProgressHUD.show()
        APIClient.shared.objectAPICall(apiEndPoint: CharecterDataEndPoint.getCharacterData, modelType: [CharecterResponse].self) { (result) in
            switch result {
            case .success(let data):
                SVProgressHUD.dismiss()
                self.characterList = data
                self.characterTempList = self.characterList ?? [CharecterResponse]()
                completion(true)
            case .failure((let code, let data, let err)):
                SVProgressHUD.dismiss()
                print("code = \(code)")
                print("data = \(String(describing: data))")
                print("error = \(err.localizedDescription)")
                completion(false)
            }
        }
    }
}
