//
//  TableCell.swift
//  test
//
//  Created by ProSmart on 30.9.21..
//

import UIKit
import SwiftyUserDefaults
import SwiftyJSON
class TableCell: UITableViewCell {
    
    //let listaID = JSON(Defaults[\.devices_id]).stringValue.components(separatedBy: ",")
    
    

    @IBOutlet weak var buttonOutlet: UIButton!
    @IBOutlet weak var rampImageView: UIImageView!
    @IBOutlet weak var rampNameView: UILabel!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        self.buttonOutlet.layer.cornerRadius = 10
        

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        
    }
    
    
    @IBAction func otvoriClicked(_ sender: Any) {
        
        
        
    }
    

}
