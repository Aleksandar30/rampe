//
//  ChangePasswordVC.swift
//  test
//
//  Created by ProSmart on 1.10.21..
//

import UIKit
import SwiftyJSON
import SwiftyUserDefaults
class ChangePasswordVC: UIViewController {
    
    @IBOutlet weak var trenutnaLozText: UITextField!
    @IBOutlet weak var novaLozText: UITextField!
    @IBOutlet weak var ponovljenaLozText: UITextField!
    
    var username = Defaults[\.username]!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        view.addGestureRecognizer(gestureRecognizer)
    }
    
    @IBAction func promeniClicked(_ sender: Any) {
        let currentPassword = trenutnaLozText.text!
        let newPassword = novaLozText.text!
        let repeatPassword = ponovljenaLozText.text!
        
        if currentPassword != Defaults[\.password] {
            makeAlert(alertTitle: "GRESKA", alertMessage: "Trenutna lozinka nije ispravna")
            return
        }
        
        if currentPassword == "" || newPassword == "" {
            makeAlert(alertTitle: "GRESKA", alertMessage: "Polje za lozinku ne moze biti prazno")
            return
        }
        if newPassword != repeatPassword {
            makeAlert(alertTitle: "GRESKA", alertMessage: "Nova i ponovljena lozinka se ne podudaraju")
            return
        }
        
        
        
        let url = URL(string: "http://rampe.institutdedinje.org/services/odrzavanje.php")!
        // Prepare URL Request Object
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
         
        //Poslati JSON je: data={"password":"rampa","param":"rampa123","id_obj":0,"action":18,"username":"rampa"}
        let postString = "data={\"password\":\"\(currentPassword)\",\"param\":\"\(newPassword)\",\"id_obj\":0,\"action\":18,\"username\":\"\(username)\"}"
        print(postString)
        
        request.httpBody = postString.data(using: String.Encoding.utf8);
        // Perform HTTP Request
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
                
                // Check for Error
                if let error = error {
                    print("Error took place \(error)")
                    return
                }
                if let data = data {
                    
                    let dataResponse = JSON(data)
                    if dataResponse["err"].intValue == 0 {
                        Defaults[\.password] = newPassword
                        
                        }
                    } else {
                            print("error")
                        }
                    }
                    //print(dataResponse)
                    task.resume()
                    makeAlert2(alertTitle: "OK", alertMessage: "Lozinka uspesno promenjena")
                    
                
        
            
    }
    
    @IBAction func odustaniClicked(_ sender: Any) {
        _ = navigationController?.popViewController(animated: true)
    }
    
    
    @objc func hideKeyboard(){
        view.endEditing(true)
    }
    
    func makeAlert(alertTitle : String, alertMessage : String) {
        let alert = UIAlertController(title: alertTitle, message: alertMessage, preferredStyle: UIAlertController.Style.alert)
        let buttonOK = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil)
        alert.addAction(buttonOK)
        
        self.present(alert, animated: true, completion: nil)
        
    }
    func makeAlert2(alertTitle : String, alertMessage : String) {
        let alert = UIAlertController(title: alertTitle, message: alertMessage, preferredStyle: UIAlertController.Style.alert)
        let buttonOK = UIAlertAction(title: "OK", style: UIAlertAction.Style.default) {_ in
            self.performSegue(withIdentifier: "toLoginVC", sender: nil)
        }
        alert.addAction(buttonOK)
        
        self.present(alert, animated: true, completion: nil)
        
    }
}
