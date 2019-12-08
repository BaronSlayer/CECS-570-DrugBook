//
//  DrugsViewController.swift
//  DrugBook
//
//  Created by Maksim Pisaryk on 11/26/19.
//  Copyright © 2019 cecs. All rights reserved.
//

import UIKit
import CoreData

class DrugsViewController: UIViewController, UITextFieldDelegate, DateControllerDelegate {
    
    var selectedDrug: Drug?
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var sgmtChangeMode: UISegmentedControl!
    @IBOutlet weak var textDrugName: UITextField!
    @IBOutlet weak var textDrugType: UITextField!
    @IBOutlet weak var textHalfLife: UITextField!
    @IBOutlet weak var textProteinBinding: UITextField!
    @IBOutlet weak var textVolumeOfDistribution: UITextField!
    @IBOutlet weak var textDoseOfNRF: UITextField!
    @IBOutlet weak var textUrinaryExcretion: UITextField!
    @IBOutlet weak var textManufactName: UITextField!
    @IBOutlet weak var textManufactAddress: UITextField!
    @IBOutlet weak var textManufactCity: UITextField!
    @IBOutlet weak var textManufactState: UITextField!
    @IBOutlet weak var textManufactZip: UITextField!
    @IBOutlet weak var labelDateAvailable: UILabel!
    @IBOutlet weak var buttonChangeDate: UIButton!
    
    @IBAction func changeMode(_ sender: Any) {
        let textFields: [UITextField] = [textDrugName, textDrugType, textHalfLife, textProteinBinding, textVolumeOfDistribution, textDoseOfNRF, textUrinaryExcretion, textManufactName, textManufactAddress, textManufactCity, textManufactState, textManufactZip]
        if sgmtChangeMode.selectedSegmentIndex == 0 {
            for textField in textFields {
                textField.isEnabled = false
                textField.borderStyle = UITextField.BorderStyle.none
            }
            buttonChangeDate.isHidden = true
            navigationItem.rightBarButtonItem = nil
        }
        else if sgmtChangeMode.selectedSegmentIndex == 1 {
            for textField in textFields {
                textField.isEnabled = true
                textField.borderStyle = UITextField.BorderStyle.roundedRect
            }
            buttonChangeDate.isHidden = false
            navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(self.saveDrug))
        }
    }
    
    @objc func saveDrug() {
        if selectedDrug == nil {
            let context = appDelegate.persistentContainer.viewContext
            selectedDrug = Drug(context: context)
        }
        appDelegate.saveContext()
        sgmtChangeMode.selectedSegmentIndex = 0
        changeMode(self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "segueDateAvailable") {
            let dateController = segue.destination as! DateViewController
            dateController.delegate = self
        }
    }
        
    override func viewDidLoad() {
        super.viewDidLoad()
        self.changeMode(self)
        
        let textFields: [UITextField] = [textDrugName, textDrugType, textHalfLife, textProteinBinding, textVolumeOfDistribution, textDoseOfNRF, textUrinaryExcretion, textManufactName, textManufactAddress, textManufactCity, textManufactState, textManufactZip]
        for textfield in textFields {
            textfield.addTarget(self,
                                action: #selector(UITextFieldDelegate.textFieldShouldEndEditing(_:)),
                                for: UIControl.Event.editingDidEnd)
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.registerKeyboardNotifications()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.unregisterKeyboardNotifications()
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if selectedDrug == nil {
            let context = appDelegate.persistentContainer.viewContext
            selectedDrug = Drug(context: context)
        }
        
        selectedDrug?.drugName = textDrugName.text
        selectedDrug?.drugType = textDrugType.text
        selectedDrug?.halfLife = textHalfLife.text
        selectedDrug?.proteinBinding = (textProteinBinding.text! as NSString).doubleValue
        selectedDrug?.volumeOfDistribution = (textVolumeOfDistribution.text! as NSString).doubleValue
        selectedDrug?.doseOfNormalRenalFunction = textDoseOfNRF.text
        selectedDrug?.urinaryExcretion = textUrinaryExcretion.text
        selectedDrug?.manufacturerName = textManufactName.text
        selectedDrug?.streetAddress = textManufactAddress.text
        selectedDrug?.city = textManufactCity.text
        selectedDrug?.state = textManufactState.text
        selectedDrug?.zip = textManufactZip.text
        
        return true
        
    }
    
    func dateChanged(date: Date) {
        if selectedDrug == nil {
            let context = appDelegate.persistentContainer.viewContext
            selectedDrug = Drug(context: context)
        }
        
        selectedDrug?.dateAvailable = date
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        labelDateAvailable.text = formatter.string(from: date)
    }
    
    func registerKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(DrugsViewController.keyboardDidShow(notification:)), name:
            UIResponder.keyboardDidShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector:
            #selector(DrugsViewController.keyboardWillHide(notification:)), name:
            UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func unregisterKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func keyboardDidShow(notification: NSNotification) {
        let userInfo: NSDictionary = notification.userInfo! as NSDictionary
        let keyboardInfo = userInfo[UIResponder.keyboardFrameBeginUserInfoKey] as! NSValue
        let keyboardSize = keyboardInfo.cgRectValue.size

        var contentInset = self.scrollView.contentInset
        contentInset.bottom = keyboardSize.height
        
        self.scrollView.contentInset = contentInset
        self.scrollView.scrollIndicatorInsets = contentInset
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        var contentInset = self.scrollView.contentInset
        contentInset.bottom = 0
        
        self.scrollView.contentInset = contentInset
        self.scrollView.scrollIndicatorInsets = UIEdgeInsets.zero
    }

}
