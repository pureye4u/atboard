//
//  ViewController.swift
//  atboard
//
//  Created by pureye4u on 08/03/2017.
//  Copyright © 2017 slowslipper. All rights reserved.
//

import UIKit
import Material
import Alamofire
import AlamofireXmlToObjects
import EVReflection
import NVActivityIndicatorView

class ServiceInfo: EVObject {
    var version: Int = 0
    var version_new: Int = 0
    var http_main_url: String?
    var https_main_url: String?
    var http_img_url: String?
}

class ViewController: UIViewController {
    
    let control = Switch(state: .off, style: .light, size: .small)
    let identifierField = ErrorTextField()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        
        // Button
        let button = RaisedButton(title: "Go", titleColor: .white)
        button.pulseColor = .white
        button.backgroundColor = Color.blue.base
        button.addTarget(self, action: #selector(ViewController.goNext), for: .touchUpInside)
        
        self.view.layout(button).center(offsetY: -50).left(20).right(20)
        
        // Label
        let label = UILabel()
        label.text = "Remember"
        
        self.view.layout(label).center(offsetX: -50)
        
        // Switch
        if UserDefaults.standard.bool(forKey: "switch_state_remember_identifier") {
            self.control.switchState = .on
        }
        self.control.delegate = self
        
        
        self.view.layout(self.control).center(offsetX: 50)
        
        // TextField
        self.identifierField.placeholder = "Identifier"
        self.identifierField.detail = "Unique ID"
        self.identifierField.isClearIconButtonEnabled = true
        if let storedIdentifier = UserDefaults.standard.string(forKey: "stored_identifier") {
            self.identifierField.text = storedIdentifier
        }
//        self.identifierField.text = "1948996-5bef0ad88581aeb55cbef9da91a7c72b-416362600e9c2c7fa13b0dbff9559917-2b53eb5ca531baaf37c0de7cbbe371c1"
        self.identifierField.delegate = self
        
        self.view.layout(self.identifierField).center(offsetY: -100).left(20).right(20)
        
        
        self.loadServerInfo()
    }
    
    func showProgress() {
        var frame = self.view.frame
        frame.origin = .zero
        let indicator = NVActivityIndicatorView(frame: frame, type: .ballPulse, color: .black, padding: 200)
        indicator.backgroundColor = .white
//        self.view.layout(indicator).center()
        self.view.addSubview(indicator)
        indicator.startAnimating()
    }
    
    func hideProgress() {
        
    }
    
    func loadServerInfo() {
        self.showProgress()
        let parameters = ["version": "68",
                          "locale": "ko_KR",
                          "platform": "iOS"]
        
        Alamofire.request("http://www.angtalk.co.kr/server_info.php", method: .post, parameters: parameters)
            .responseObject { (response: DataResponse<ServiceInfo>)in
                if let result = response.value {
                    print("Result: \(result)")
                }
        }
    }
    
    func goNext() {
        guard let identifier = self.identifierField.text,
            identifier.characters.count > 0 else {
            return
        }
        
        if self.control.switchState == .on {
            UserDefaults.standard.set(self.identifierField.text, forKey: "stored_identifier")
        }
        
        print("launch")
//            .response { response in
//            print("Request: \(response.request)")
//            print("Response: \(response.response)")
//            print("Error: \(response.error)")
//            
//            if let data = response.data, let utf8Text = String(data: data, encoding: .utf8) {
//                print("Data: \(utf8Text)")
//            }
//        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension ViewController: TextFieldDelegate {
    
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        print("Return")
        self.goNext()
        return true
    }

}

extension ViewController: SwitchDelegate {
    func switchDidChangeState(control: Switch, state: SwitchState) {
        UserDefaults.standard.set(.on == state, forKey: "switch_state_remember_identifier")
    }
}
