/**
 * Copyright 2016 IBM Corp.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
import UIKit
import IBMMobileFirstPlatformFoundation
import IBMMobileFirstPlatformFoundationJSONStore

class ViewController: UIViewController {
    
    var people:JSONStoreCollection!
    //var pushDelegate:PushDelegate!
    //var loadDelegate:LoadDelegate!

    override func viewDidLoad() {
        super.viewDidLoad()

    consoleTextView.isUserInteractionEnabled = true
 consoleTextView.isEditable = false
        
        
        //pushDelegate = PushDelegate(controller: self)
        //loadDelegate = LoadDelegate(controller: self)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //---------------------------------------
    // logMessage
    //---------------------------------------
    func logMessage(_ message: String) {
        consoleTextView.textColor = UIColor.init(colorLiteralRed: 1, green: 1, blue: 1, alpha: 1)
        consoleTextView.text = message
        
        self.view.endEditing(true)
    }
    
    //---------------------------------------
    // logError
    //---------------------------------------
    func logError(_ error:String) {
        consoleTextView.textColor = UIColor.init(colorLiteralRed: 0.8, green: 0, blue: 0, alpha: 1)
        consoleTextView.text = error
        
        self.view.endEditing(true)
    }
    
    //---------------------------------------
    // resetFieldError
    //---------------------------------------
    func resetFieldError(_ field: UITextField) {
        field.layer.cornerRadius = 5.0
        field.layer.masksToBounds = true
        field.layer.borderColor = UIColor.gray.cgColor
        field.layer.borderWidth = 0.5
    }

    //---------------------------------------
    // setTextFieldError
    //---------------------------------------
    func setTextFieldError(_ field: UITextField) {
        field.layer.cornerRadius = 5.0
        field.layer.masksToBounds = true
        field.layer.borderColor = UIColor.red.cgColor
        field.layer.borderWidth = 1.0
    }
    
    //---------------------------------------
    // logResults
    //---------------------------------------
    func logResults(_ results: NSArray) {
        logResults(results, message: nil)
    }
    
    //---------------------------------------
    // logResults
    //---------------------------------------
    func logResults(_ results: NSArray, message: String?) {
        var consoleMessage:String?
        
        if((message?.isEmpty) == nil || message?.characters.count == 0) {
            consoleMessage = String.init(format: "Results: %d\n", arguments: [results.count])
        } else {
            consoleMessage = String.init(format: "%@:\n", arguments: [message!])
        }
        
        for obj in results {
            consoleMessage = consoleMessage!.appendingFormat(" %@", (obj as AnyObject).description)
        }
        
        
        logMessage(consoleMessage!)
    }
    
    
    //---------------------------------------
    // Register For Touch ID
    //---------------------------------------
    
    
    
      @IBAction func registerButtonClick(_ sender: UIButton!)
      {
        
        
        self.performSegue(withIdentifier: "ToRegisterPage", sender: nil)
        
        
    }
    //---------------------------------------
    // Initialize
    //---------------------------------------
    @IBAction func initializeButtonClick(_ sender: UIButton!) {
        people = JSONStoreCollection(name: StringResource.COLLECTION_NAME)
        
        people.setSearchField("name", with: JSONStore_String)
        people.setSearchField("age", with: JSONStore_Integer)
        
        let options = JSONStoreOpenOptions()

        options.username = (userTextField.text?.isEmpty) != nil ? userTextField.text : StringResource.DEFAULT_USERNAME
        
        if((passwordTextField.text?.isEmpty) != nil) {
            options.password = passwordTextField.text!
        }
        
        do {
            try JSONStore.sharedInstance().openCollections([people], with: options)

            logMessage(StringResource.INIT_MESSAGE)
            
            userTextField.text = nil
            passwordTextField.text = nil
        } catch let error as NSError {
            logMessage(error.debugDescription)
        }
        
    }
    
    //---------------------------------------
    // Close
    //---------------------------------------
    @IBAction func closeButtonClick(_ sender: UIButton) {
        
        do {
            try JSONStore.sharedInstance().closeAllCollections()
            
            logMessage(StringResource.CLOSE_MESSAGE)
            
        } catch let error as NSError {
            logError(error.debugDescription)
        }
    }

    //---------------------------------------
    // Destroy
    //---------------------------------------
    @IBAction func destroyButtonClick(_ sender: UIButton) {
        
        do {
            try JSONStore.sharedInstance().destroyData()

            logMessage(StringResource.DESTROY_MESSAGE)
        } catch let error as NSError {
            logError(error.description)
        }
    }
    
    //---------------------------------------
    // Remove Collection
    //---------------------------------------
    @IBAction func removeCollectionButtonClick(_ sender: UIButton) {
        
        do  {
            try people.remove()
            
            logMessage(StringResource.REMOVE_COLLECTION_MESSAGE)
        } catch let error as NSError {
            logError(error.description)
        }
        
    }
    
    //---------------------------------------
    // Add Data
    //---------------------------------------
    @IBAction func addDataButtonClick(_ sender: UIButton) {
        if(people == nil) {
            return logError(StringResource.INIT_FIRST_MESSAGE)
        }
        
        resetFieldError(enterNameTextField)
        resetFieldError(enterAgeTextField)
        
        let name:String? = enterNameTextField.text
      //let age:Int? = Int(enterAgeTextField.text!)
        
        guard let age = Int(enterAgeTextField.text!),age > 0
        else
        {
            
            setTextFieldError(enterAgeTextField)
            return
        }

        
        if((name?.characters.count)! == 0 || age <= 0) {
            if(name?.characters.count == 0) {
                setTextFieldError(enterNameTextField)
            
            }
            
            
            return
        }

        let data = ["name" : name!, "age" : age] as [String : Any]
        
        do  {
            try people.addData([data], andMarkDirty: true, with: nil)
            
            logMessage(StringResource.ADD_MESSAGE)

            enterNameTextField.text = nil
            enterAgeTextField.text = nil
        } catch let error as NSError {
            logError(error.description)
        }
    }
    
    //---------------------------------------
    // Find By Name
    //---------------------------------------
    @IBAction func findByNameButtonClick(_ sender: UIButton) {
        if(people == nil) {
            return logError(StringResource.INIT_FIRST_MESSAGE)
        }
        
        resetFieldError(searchTextField)
        
        let searchKeyword:String? = searchTextField.text
        
             if(searchKeyword == nil) {
            return setTextFieldError(searchTextField)
        }
        
        let options:JSONStoreQueryOptions = JSONStoreQueryOptions()
        options.sort(bySearchFieldAscending: "name")
        options.sort(bySearchFieldDescending: "age")
        options.filterSearchField("_id")
        options.filterSearchField("json")
        if let limit = Int(limitTextField.text!),limit > 0
        {
            options.limit = limit as NSNumber!
        }
       
        
        if let offset = Int(offsetTextField.text!),offset > 0
        {
            options.offset = offset as NSNumber!
        }
        
        let query:JSONStoreQueryPart = JSONStoreQueryPart()
        query.searchField("name", like: searchKeyword)
        
        do {
            let results = try people.find(withQueryParts: [query], andOptions: options)

            logResults(results as NSArray)
        } catch let error as NSError {
            logError(error.description)
        }
    }
    
    //---------------------------------------
    // Find By Age
    //---------------------------------------
    @IBAction func findByAgeButtonClick(_ sender: UIButton) {
        if(people == nil) {
            return logError(StringResource.INIT_FIRST_MESSAGE)
        }
        
        resetFieldError(searchTextField)
        
        let age:Int? = Int(searchTextField.text!)

        if(age == nil) {
            return setTextFieldError(searchTextField)
        }
        
        let options:JSONStoreQueryOptions = JSONStoreQueryOptions()
        options.sort(bySearchFieldAscending: "name")
        options.sort(bySearchFieldDescending: "age")
        options.filterSearchField("_id")
        options.filterSearchField("json")
        
        if let limit = Int(limitTextField.text!),limit > 0
        {
            options.limit = limit as NSNumber!
        }
        
        
        if let offset = Int(offsetTextField.text!),offset > 0
        {
            options.offset = offset as NSNumber!
        }
        
        let query:JSONStoreQueryPart = JSONStoreQueryPart()
        query.searchField("age", equal: age!.description)
        
        do {
            let results = try people.find(withQueryParts: [query], andOptions: options)
            
            logResults(results as NSArray)
        } catch let error as NSError {
            logError(error.description)
        }
        
    }
    
    //---------------------------------------
    // Find All
    //---------------------------------------
    @IBAction func findAllButtonClick(_ sender: UIButton) {
        if(people == nil) {
            return logError(StringResource.INIT_FIRST_MESSAGE)
        }
        
        resetFieldError(searchTextField)

        
        let options:JSONStoreQueryOptions = JSONStoreQueryOptions()
        options.sort(bySearchFieldAscending: "name")
        options.sort(bySearchFieldDescending: "age")
        options.filterSearchField("_id")
        options.filterSearchField("json")
        
        if let limit = Int(limitTextField.text!),limit > 0
        {
            options.limit = limit as NSNumber!
        }

        
        if let offset = Int(offsetTextField.text!),offset > 0
        {
            options.offset = offset as NSNumber!
        }
        
        
        do {
            let results = try people.findAll(with: options)
            
            logResults(results as NSArray)
        } catch let error as NSError {
            logError(error.debugDescription)
        }
    }
    
    //---------------------------------------
    // Find By Id
    //---------------------------------------
    @IBAction func findByIdButtonClick(_ sender: UIButton) {
        if(people == nil) {
            return logError(StringResource.INIT_FIRST_MESSAGE)
        }
        
        resetFieldError(findByIdTextField)
        
//      let id:Int? = Int(findByIdTextField.text!)
        // validating if valid text entered.
        
        guard let id = Int(findByIdTextField.text!),id > 0
        else {
            return setTextFieldError(findByIdTextField)
           
        }

        let options:JSONStoreQueryOptions = JSONStoreQueryOptions()
        options.sort(bySearchFieldAscending: "name")
        options.sort(bySearchFieldDescending: "age")
        options.filterSearchField("_id")
        options.filterSearchField("json")
        
        do {
            let results = try people.find(withIds: [id], andOptions: options)
            
            logResults(results as NSArray)
        } catch let error as NSError {
            logError(error.description)
        }
    }
    
    //---------------------------------------
    // Replace By Id
    //---------------------------------------
    @IBAction func replaceByIdButtonClick(_ sender: AnyObject) {
        if(people == nil) {
            return logError(StringResource.INIT_FIRST_MESSAGE)
        }

        resetFieldError(replaceIdTextField)
        resetFieldError(replaceNameTextField)
        resetFieldError(replaceAgeTextField)

       let id:Int? = Int(replaceIdTextField.text!)
        let name:String? = replaceNameTextField.text
        let age:Int? = Int(replaceAgeTextField.text!)

        
        if((name?.characters.count)! == 0 || age! <= 0 || id! <= 0) {
            if(name?.characters.count == 0) {
                setTextFieldError(replaceNameTextField)
            }
            
            if(age! <= 0) {
                setTextFieldError(replaceAgeTextField)
            }
            
            if(id! <= 0) {
                setTextFieldError(replaceIdTextField)
            }
            
            return
        }
        
        var document:Dictionary<String,AnyObject> = Dictionary()
        document["name"] = name as AnyObject?
        document["age"] = age?.description as AnyObject?
        
        
        var replacement:Dictionary<String,AnyObject> = Dictionary()
        replacement["_id"] = id as AnyObject?
        replacement["json"] = document as AnyObject?

        do {
            let count:Int = try Int(people.replaceDocuments([replacement], andMarkDirty: true))

            if(count > 0) {
                logMessage(String.init(format: StringResource.REPLACE_MESSAGE, arguments: [id!]))
            } else {
                logError(String.init(format: StringResource.NOT_FOUND_MESSAGE, arguments: [id!]))
            }
        } catch let error as NSError {
            logError(error.debugDescription)
        }
    }
    
    //---------------------------------------
    // Remove By Id
    //---------------------------------------
    @IBAction func removeByIdButtonClick(_ sender: AnyObject) {
        if(people == nil) {
            return logError(StringResource.INIT_FIRST_MESSAGE)
        }

        resetFieldError(removeIdTextField)

        
        guard let id = Int(removeIdTextField.text!),id > 0
            else {
                return setTextFieldError(removeIdTextField)
                
        }
        do {
            let count:Int = try Int(people.remove(withIds: [id], andMarkDirty: true))
            
            if(count > 0) {
                logMessage(String.init(format: StringResource.REMOVE_MESSAGE, arguments: [id]))
            } else {
                logError(String.init(format: StringResource.NOT_FOUND_MESSAGE, arguments: [id]))
            }
        }
        catch let error as NSError {
            logError(error.debugDescription)
        }
    }
    
    //---------------------------------------
    // Load Data From Adapter ButtonClick
    //---------------------------------------
    @IBAction func loadDataFromAdapterButtonClick(_ sender: AnyObject) {
        if(people == nil) {
            return logError(StringResource.INIT_FIRST_MESSAGE)
        }
        
        let request = WLResourceRequest(url: URL(string: "/adapters/JSONStoreAdapter/getPeople"), method: WLHttpMethodGet)
        request?.send { (response, error) -> Void in
            if(error == nil){
                let responsePayload:NSDictionary = response!.getJson() as NSDictionary
                self.loadDataFromAdapter(responsePayload.object(forKey: "peopleList") as! NSArray)
            }
            else{
                print(error.debugDescription);
                self.logError(error.debugDescription)
            }
        }
    }
    
    //---------------------------------------
    // Load Data From Adapter
    //---------------------------------------
    func loadDataFromAdapter(_ data:NSArray) {
        if(people == nil) {
            return logError(StringResource.INIT_FIRST_MESSAGE)
        }
        
        do {
            let change:Int = try Int(people.changeData(data as [AnyObject], withReplaceCriteria: nil, addNew: true, markDirty: false))
            logMessage("New documents loaded from adapter: \(change)")
            
        } catch let error as NSError {
            logError(error.debugDescription)
        }
        
    }
    
    //---------------------------------------
    // Get Dirty Documents
    //---------------------------------------
    @IBAction func getDirtyDocumentsButtonClick(_ sender: AnyObject) {
        if(people == nil) {
            return logError(StringResource.INIT_FIRST_MESSAGE)
        }

        do {
            let dirtyDocs:NSArray = try people.allDirty() as NSArray

            logResults(dirtyDocs)
            
        } catch let error as NSError {
            logError(error.debugDescription)
        }
    }
    
    //---------------------------------------
    // Push Changes To Adapter ButtonClick
    //---------------------------------------
    @IBAction func pushChangesToAdapterButtonClick(_ sender: AnyObject) {
        if(people == nil) {
            return logError(StringResource.INIT_FIRST_MESSAGE)
        }
        
        
        do {
            let dirtyDocs:NSArray = try self.people.allDirty() as NSArray
            print("dirtyDocs : \(dirtyDocs.description)");
            
            let request = WLResourceRequest(url: NSURL(string: "/adapters/JSONStoreAdapter/pushPeople") as URL!, method: WLHttpMethodPost)
            let formParams = ["params": dirtyDocs]
            request?.send(withFormParameters: formParams) { (response, error) -> Void in
                if(error == nil){
                    self.pushChangesToAdapter(dirtyDocs)
                }
                else{
                    NSLog(error.debugDescription)
                }
            }
        } catch let error as NSError {
            self.logError(error.debugDescription)
        }
        
    }
    
    //---------------------------------------
    // Push Changes To Adapter
    //---------------------------------------
    func pushChangesToAdapter(_ data:NSArray){
        do{
            try self.people.markDocumentsClean(data as [AnyObject])
            self.logMessage(StringResource.PUSH_FINISH_MESSAGE)
        } catch let error as NSError {
            self.logError(error.debugDescription)
        }
    }
    
    //---------------------------------------
    // Count All
    //---------------------------------------
    @IBAction func countAllButtonClick(_ sender: AnyObject) {
        if(people == nil) {
            return logError(StringResource.INIT_FIRST_MESSAGE)
        }
        
        do {
            let countAllByName:Int? = try Int(people.countAllDocuments())
            logMessage(String.init(format: StringResource.COUNT_ALL_MESSAGE, arguments: [countAllByName!]))
        } catch let error as NSError {
            logError(error.debugDescription)
        }
    }
    
    //---------------------------------------
    // Count By Name
    //---------------------------------------
    @IBAction func countByNameButtonClick(_ sender: AnyObject) {
        if(people == nil) {
            return logError(StringResource.INIT_FIRST_MESSAGE)
        }
        let searchName: String = self.countNameTextField.text!
        //name;: String = self.countNameTextField.text!
        print("Value of name is \(searchName)")

        if(searchName.isEmpty) {
            return setTextFieldError(countNameTextField)
        }
        
        let query:JSONStoreQueryPart = JSONStoreQueryPart()
        query.searchField("name", equal:searchName)
        
        do {
            let countAllByName:Int? = try Int(people.count(withQueryParts: [query]))
            logMessage("Documents in the collection with name(\(searchName)) : \(countAllByName!)")
        } catch let error as NSError {
            logError(error.debugDescription)
        }
    }
    
    //---------------------------------------
    // Change Password
    //---------------------------------------
    @IBAction func changePasswordButtonClick(_ sender: AnyObject) {
        if(people == nil) {
            return logError(StringResource.INIT_FIRST_MESSAGE)
        }
        
        var username:String? = changePasswordUserTextField.text
        
        if(username?.characters.count == 0) {
            username = StringResource.DEFAULT_USERNAME
        }
        
        let oldPassword:String? = changePasswordOldTextField.text
        let newPassword:String? = changePasswordNewTextField.text

        do {
            try JSONStore.sharedInstance().changeCurrentPassword(oldPassword, withNewPassword: newPassword, forUsername: username)

            logMessage(StringResource.PASSWORD_CHANGE_MESSAGE)

            changePasswordOldTextField.text = nil
            changePasswordNewTextField.text = nil
            changePasswordUserTextField.text = nil
        } catch let error as NSError {
            logError(error.debugDescription)
        }
    }
    
    //---------------------------------------
    // Get File Info
    //---------------------------------------
    @IBAction func getFileInfoButtonClick(_ sender: AnyObject) {
        do {
            let info = try JSONStore.sharedInstance().fileInfo()
            
            logResults(info as NSArray, message: StringResource.FILE_INFO)
        } catch let error as NSError {
            logError(error.debugDescription)
        }
    }

    @IBOutlet weak var consoleTextView: UITextView!
    @IBOutlet weak var userTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var enterNameTextField: UITextField!
    @IBOutlet weak var enterAgeTextField: UITextField!
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var limitTextField: UITextField!
    @IBOutlet weak var offsetTextField: UITextField!
    @IBOutlet weak var findByIdTextField: UITextField!
    @IBOutlet weak var replaceNameTextField: UITextField!
    @IBOutlet weak var replaceAgeTextField: UITextField!
    @IBOutlet weak var replaceIdTextField: UITextField!
    @IBOutlet weak var removeIdTextField: UITextField!
    @IBOutlet weak var countNameTextField: UITextField!
    @IBOutlet weak var changePasswordOldTextField: UITextField!
    @IBOutlet weak var changePasswordNewTextField: UITextField!
    @IBOutlet weak var changePasswordUserTextField: UITextField!
}

