//
//  MainViewController.swift
//  test
//
//  Created by ProSmart on 29.9.21..
//

import UIKit
import SwiftyUserDefaults
import SwiftyJSON
import SDWebImage
class MainViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var username = Defaults[\.username]!
    var password = Defaults[\.password]!
    var id_obj = Defaults[\.id_obj]!
    var role_id = Defaults[\.role_id]!
    var device_id = Defaults[\.devices_id]!

    var entities = [RampaPodaci]()
    
    //Liste za pravljenje tabele
    var rampNamesArray = [String]()
    var rampIconArray = [UIImage]()
    

    @IBOutlet weak var tableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initializeMeni()
        inicijalizujRampe()
        

        tableView.delegate = self
        tableView.dataSource = self
        if username != "" {
            _ = Timer.scheduledTimer(withTimeInterval: 2, repeats: true) { (timer) in
                if !self.rampIconArray.isEmpty {
                    self.tableView.reloadData()
                }
                if Defaults[\.isLogin] == "false"{
                    return
                } else {
                    self.assertConnection()
                }
                
            }
        }
        
        
    }

    
    func assertConnection(){
        let url = URL(string: "http://rampe.institutdedinje.org/services/odrzavanje.php")!
        // Prepare URL Request Object
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        var username = Defaults[\.username]!
        var password = Defaults[\.password]!
        // HTTP Request Parameters which will be sent in HTTP Request Body
        let postString = "data={\"password\":\"\(password)\",\"id_obj\":0,\"action\":1,\"username\":\"\(username)\"}"
        //print(postString)
        // Set HTTP Request Body
        request.httpBody = postString.data(using: String.Encoding.utf8);
        
        // Perform HTTP Request
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
                // Check for Error
                if let error = error {
                    print("Nema Internet konekcije")
                    print(error.localizedDescription)
                    return
                }
                // Convert HTTP Response Data to a String
                if let data = data {
                    let dataResponse = JSON(data)
                    if dataResponse["err"].intValue == 0 {
                        let statuses = dataResponse["statuses"].stringValue.components(separatedBy: ",")
                        //Pokusaj da se ispravi greska da aplikacija pukne pri
                        //promeni sa usera koji ima kontrolu nad 5 rampi na usera koji ima kontrolu nad 2
                        if self.entities.count > statuses.count {
                            print("Ovde nastaje problem: " + String(self.entities.count) + ":" + String(statuses.count))
                            self.entities.removeAll()
                            username = Defaults[\.username]!
                            password = Defaults[\.password]!
                            self.id_obj = Defaults[\.id_obj]!
                            self.role_id = Defaults[\.role_id]!
                            self.device_id = Defaults[\.devices_id]!
                            self.inicijalizujRampe()
                            return
                        }
                        
                        
                        for i in 0...(self.entities.count - 1)  {
                            self.entities[i].setStatus(newStatus: Int(statuses[i]) ?? 0)
                        }
                        //print("sve ok, statusi postavljeni")
                        self.rampIconArray.removeAll()
                        
                        for entity in self.entities {
                            //Test sta ako je rampa neispravna
                            //entity.setStatus(newStatus: 15)
                            if entity.getStatus() == 10 || entity.getStatus() == 11 || entity.getStatus() == 12 {
                                if entity.getType() > 27 {
                                    self.rampIconArray.append(UIImage(named: "exitblack")!)
                                } else {
                                    self.rampIconArray.append(UIImage(named: "enterblack")!)
                                }
                            } else {
                                if entity.getType() > 27 {
                                    self.rampIconArray.append(UIImage(named: "exitred")!)
                                } else {
                                    self.rampIconArray.append(UIImage(named: "enterred")!)
                                }
                            }
                        }
                        

                        //If ok to log in, set up auto log in for the next launch
                    } else {
                        print("Greska pri konekciji: " + dataResponse["err"].stringValue)
                        
                    }
                    //print(dataResponse)
                    
                }
        }
        task.resume()
        
        

    }

    
    //Okida se cim se uloguje, postavlja Rampe u listu entities
    func inicijalizujRampe(){
        let txtRampeIds = device_id
        
        if txtRampeIds != "" {
            let ids = txtRampeIds.components(separatedBy: ",")
            let names = Defaults[\.devices_name]!.components(separatedBy: ",")
            let type = Defaults[\.devices_type]!.components(separatedBy: ",")
            rampNamesArray.removeAll()
            for i in 0...(ids.count - 1) {
                
                entities.append(RampaPodaci(id: Int(ids[i])!, name: String(names[i]), status: 0, type: Int(type[i])!))
                rampNamesArray.append(names[i])
            }
            
            
            
            
        }
        
        
    }
    //Podesavanje tabele
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return entities.count
    }
    //podesavanje tabele i uvodjenje klika na dugme koji okida buttonClicked()
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! TableCell
        cell.rampNameView.text = rampNamesArray[indexPath.row]
        if rampIconArray.isEmpty {
            cell.rampImageView.image = UIImage(named: "waiting")
        } else {
            cell.rampImageView.image = rampIconArray[indexPath.row]
        }
        
        cell.buttonOutlet.tag = indexPath.row
        cell.buttonOutlet.addTarget(self, action: #selector(buttonClicked(sender:)) , for: UIControl.Event.touchDown)
        //cell.rampImageView.image =  rampIconArray[indexPath.row] ?? UIImage(named: "Unknown")
        return cell
        
    }
    
    //Funkcija koja otvara rampu
    @objc func buttonClicked(sender:UIButton) {

        let buttonRow = sender.tag
        
        
        
        let deviceIDArray = JSON(device_id).stringValue.components(separatedBy: ",")
        //print("Otvaranje rampe:" + String(entities[buttonRow].getId()))
        
        let url = URL(string: "http://rampe.institutdedinje.org/services/odrzavanje.php")!
        //Dummy url for testing:
        //let url = URL(string: "www.nekisajt.com")!
        // Prepare URL Request Object
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
         
        // HTTP Request Parameters which will be sent in HTTP Request Body
        let postString = "data={\"password\":\"\(password)\",\"device_id\":\(deviceIDArray[buttonRow]),\"id_obj\":0,\"action\":4,\"username\":\"\(username)\"}"
        print(postString)
        // Set HTTP Request Body
        request.httpBody = postString.data(using: String.Encoding.utf8);
        
        // Perform HTTP Request
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            
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
                    
                    
                } else {
                    print(dataResponse["err"].stringValue)
                    
                }
                //print(dataResponse)
                
            }
            
            
            
        }
        task.resume()
        
    }

    
    func initializeMeni() {
        //Meni za log out i promenu lozinke
        var menuItems: [UIAction] {
            return [
                UIAction(title: "Log Out", image: UIImage(systemName: "sun.max"), handler: { (_) in
                    Defaults[\.isLogin] = "false"
                    self.performSegue(withIdentifier: "toLogInVC", sender: nil)
                }),
                UIAction(title: "Change password", image: UIImage(systemName: "sun.max"), handler: { (_) in
                    self.performSegue(withIdentifier: "toPaswordChangeVC", sender: nil)
                })
            ]
        }
        var demoMenu: UIMenu {
            return UIMenu(title: "My menu", image: nil, identifier: nil, options: [], children: menuItems)
        }
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Menu", image: nil, primaryAction: nil, menu: demoMenu)
    }
    func makeAlert(alertTitle : String, alertMessage : String) {
        let alert = UIAlertController(title: alertTitle, message: alertMessage, preferredStyle: UIAlertController.Style.alert)
        let buttonOK = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil)
        alert.addAction(buttonOK)
        
        self.present(alert, animated: true, completion: nil)
        
    }
}
