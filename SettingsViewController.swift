//
//  SettingsViewController.swift
//  DrugBook
//
//  Created by Maksim Pisaryk on 11/26/19.
//  Copyright © 2019 cecs. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    @IBOutlet weak var sortOrderPicker: UIPickerView!
    @IBOutlet weak var sortOrderSwitch: UISwitch!
    
    let sortOrderItems: Array<String> = ["Drug Name", "Manufacturer", "Date Available"]
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return sortOrderItems.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return sortOrderItems[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        print("Selected item: \(sortOrderItems[row])")
        let sortField = sortOrderItems[row]
        let settings = UserDefaults.standard
        settings.set(sortField, forKey: Constants.kSortField)
        settings.synchronize()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let settings = UserDefaults.standard
        sortOrderSwitch.setOn(settings.bool(forKey: Constants.kSortDirectionAscending), animated: true)
        
        let sortField = settings.string(forKey: Constants.kSortField)
        var i = 0
        for field in sortOrderItems {
            if field == sortField {
                sortOrderPicker.selectRow(i, inComponent: 0, animated: false)
            }
            i += 1
        }
        sortOrderPicker.reloadComponent(0)
    }
    
    @IBAction func sortDirection(_ sender: Any) {
        let settings = UserDefaults.standard
        settings.set(sortOrderSwitch.isOn, forKey: Constants.kSortDirectionAscending)
        settings.synchronize()
    }
        
    override func viewDidLoad() {
        super.viewDidLoad()

        sortOrderPicker.dataSource = self
        sortOrderPicker.delegate = self
    }
}
