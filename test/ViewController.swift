//
//  ViewController.swift
//  test
//
//  Created by ProSmart on 28.9.21..
//

import UIKit
import SwiftyJSON
import SwiftyUserDefaults


class ViewController: UIViewController {
    
    @IBOutlet weak var userText: UITextField!
    @IBOutlet weak var passwordText: UITextField!
    
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        view.addGestureRecognizer(gestureRecognizer)
    }
    
    @objc func hideKeyboard(){
        view.endEditing(true)
    }
    
    func toTestVC() {
        
    }
    
    @IBAction func logInClicked(_ sender: Any) {
        print("log in clicked")
        let url = URL(string: "http://rampe.institutdedinje.org/services/odrzavanje.php")!
        // Prepare URL Request Object
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
         
        // HTTP Request Parameters which will be sent in HTTP Request Body
        let postString = "data={\"password\":\"\(passwordText.text!)\",\"id_obj\":0,\"action\":0,\"username\":\"\(userText.text!)\"}"
        print("postString:" + postString)
        // Set HTTP Request Body
        request.httpBody = postString.data(using: String.Encoding.utf8);
        // Perform HTTP Request
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
                
                // Check for Error
                if let error = error {
                    print("Error took place \(error)")
                    return
                }
                // Convert HTTP Response Data to a String
                if let data = data {
                    //print("Response data string:\n \(dataString)")
                    let dataResponse = JSON(data)
                    if dataResponse["err"].intValue == 0 {
                        print("log in ok")
                        print(dataResponse)
                        //If ok to log in, set up auto log in for the next launch

                        
                        DispatchQueue.main.async {
                            Defaults[\.username] = self.userText.text!
                            Defaults[\.password] = self.passwordText.text!
                            Defaults[\.isLogin] = "true"
                            Defaults[\.id_obj] = dataResponse["id_obj"].stringValue
                            Defaults[\.role_id] = dataResponse["role_id"].stringValue
                            Defaults[\.devices_id] = dataResponse["devices_id"].stringValue
                            Defaults[\.devices_name] = dataResponse["devices_name"].stringValue
                            Defaults[\.devices_type] = dataResponse["devices_type"].stringValue
                            
                            //Provera da li su podaci upisani ispravno
                            /*
                            print("Username is " + Defaults[\.username]!)
                            print(Defaults[\.password]!)
                            print(Defaults[\.isLogin]!)
                            print(Defaults[\.id_obj]!)
                            print(Defaults[\.role_id]!)
                            print(Defaults[\.devices_id]!)
                            print(Defaults[\.devices_name]!)
                            print(Defaults[\.devices_type]!)
                            */
                            self.performSegue(withIdentifier: "toRampControllVC", sender: nil)
                        }
                    } else {
                        DispatchQueue.main.async {
                            self.makeAlert(alertTitle: "Greska", alertMessage: "Podaci o korisniku nisu ispravni")
                            print(dataResponse)
                        }
                        
                    }
                    //print(dataResponse)
                    
                }
        }
        task.resume()
        

        
    }
    
    func makeAlert(alertTitle : String, alertMessage : String) {
        let alert = UIAlertController(title: alertTitle, message: alertMessage, preferredStyle: UIAlertController.Style.alert)
        let buttonOK = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil)
        alert.addAction(buttonOK)
        
        self.present(alert, animated: true, completion: nil)
        
    }
    


}

