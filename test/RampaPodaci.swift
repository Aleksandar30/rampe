import Foundation


class RampaPodaci {
    /*
     private int id;
     private String name;
     private int status;
     private int type;
     */
    
    

    private var id : Int
    private var name : String
    private var status : Int
    private var type : Int
    
    internal init(id: Int, name: String, status: Int, type: Int) {
        self.id = id
        self.name = name
        self.status = status
        self.type = type
    }
    
    
        
    func getId() -> Int {
        return self.id
    }
    func setId(newId : Int){
        self.id = newId
    }
    func getname() -> String {
        return self.name
    }
    
    func setName(newName : String){
        self.name = newName
    }
    
    func getStatus() -> Int {
        return self.status
    }
    func setStatus(newStatus : Int){
        self.status = newStatus
    }
    
    func getType() -> Int {
        return self.type
    }
    func setType(newType : Int){
        self.type = newType
    }
    
    
}
