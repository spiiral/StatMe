//
//  ViewController.swift
//  StatMe
//
//  Created by spiiral on 4/28/23.
//

import UIKit

class HomeViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let switchControl = UISwitch()
        if UserDefaults.standard.integer(forKey: "interfaceStyle") == 0{
            self.view.backgroundColor = .white
        } else{
            self.view.backgroundColor = .black
            switchControl.setOn(true, animated: false)
        }
        self.title = "Home"
        
       
        switchControl.center = view.center
        switchControl.addTarget(self, action: #selector(switchValueChanged(_ :)), for: .valueChanged)
      
        self.view.addSubview(switchControl)
        
    }
    
    @objc func switchValueChanged(_ sender: UISwitch) {
        
        let selectedStyle = sender.isOn ? 1 : 0
        
        if selectedStyle == 1{
            self.view.backgroundColor = .black
        }else{
            self.view.backgroundColor = .white
        }
        self.view.reloadInputViews()
        UserDefaults.standard.set(selectedStyle, forKey: "interfaceStyle")
        
        if #available(iOS 13.0, *){
            overrideUserInterfaceStyle = sender.isOn ? .dark : .light
            
            self.view.window?.overrideUserInterfaceStyle = overrideUserInterfaceStyle
        }else{
            
        }
    }


}

