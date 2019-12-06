//
//  DrugsViewController.swift
//  DrugBook
//
//  Created by Maksim Pisaryk on 11/26/19.
//  Copyright © 2019 cecs. All rights reserved.
//

import UIKit

class DrugsViewController: UIViewController {
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @IBAction func changeMode(_ sender: Any) {
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.registerKeyboardNotifications()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.unregisterKeyboardNotifications()
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
