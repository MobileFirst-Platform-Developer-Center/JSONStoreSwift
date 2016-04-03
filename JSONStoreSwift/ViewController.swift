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

class ViewController: UIViewController {
    
    var people:JSONStoreCollection!
    //var pushDelegate:PushDelegate!
    //var loadDelegate:LoadDelegate!

    override func viewDidLoad() {
        super.viewDidLoad()

        consoleTextView.userInteractionEnabled = true
        consoleTextView.editable = false
        
        
        //pushDelegate = PushDelegate(controller: self)
        //loadDelegate = LoadDelegate(controller: self)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func logMessage(message: String) {
        consoleTextView.textColor = UIColor.init(colorLiteralRed: 1, green: 1, blue: 1, alpha: 1)
        consoleTextView.text = message
        
        self.view.endEditing(true)
    }
    
    func logError(error:String) {
        consoleTextView.textColor = UIColor.init(colorLiteralRed: 0.8, green: 0, blue: 0, alpha: 1)
        consoleTextView.text = error
        
        self.view.endEditing(true)
    }
    
    func resetFieldError(field: UITextField) {
        field.layer.cornerRadius = 5.0
        field.layer.masksToBounds = true
        field.layer.borderColor = UIColor.grayColor().CGColor
        field.layer.borderWidth = 0.5
    }

    func setTextFieldError(field: UITextField) {
        field.layer.cornerRadius = 5.0
        field.layer.masksToBounds = true
        field.layer.borderColor = UIColor.redColor().CGColor
        field.layer.borderWidth = 1.0
    }

    func logResults(results: NSArray) {
        logResults(results, message: nil)
    }
    
    func logResults(results: NSArray, message: String?) {
        var consoleMessage:String?
        
        if((message?.isEmpty) == nil || message?.characters.count == 0) {
            consoleMessage = String.init(format: "Results: %d\n", arguments: [results.count])
        } else {
            consoleMessage = String.init(format: "%@:\n", arguments: [message!])
        }
        
        for obj in results {
            consoleMessage = consoleMessage!.stringByAppendingFormat(" %@", obj.description)
        }
        
        
        logMessage(consoleMessage!)
    }
    
    @IBAction func initializeButtonClick(sender: UIButton!) {
        people = JSONStoreCollection(name: StringResource.COLLECTION_NAME)
        
        people.setSearchField("name", withType: JSONStore_String)
        people.setSearchField("age", withType: JSONStore_Integer)
        
        let options = JSONStoreOpenOptions()

        options.username = (userTextField.text?.isEmpty) != nil ? userTextField.text : StringResource.DEFAULT_USERNAME
        
        if((passwordTextField.text?.isEmpty) != nil) {
            options.password = passwordTextField.text!
        }
        
        do {
            try JSONStore.sharedInstance().openCollections([people], withOptions: options)

            logMessage(StringResource.INIT_MESSAGE)
            
            userTextField.text = nil
            passwordTextField.text = nil
        } catch let error as NSError {
            logMessage(error.description)
        }
        
    }

    @IBAction func closeButtonClick(sender: UIButton!) {
        
        do {
            try JSONStore.sharedInstance().closeAllCollections()
            
            logMessage(StringResource.CLOSE_MESSAGE)
            
        } catch let error as NSError {
            logError(error.description)
        }
    }

    @IBAction func destroyButtonClick(sender: UIButton) {
        
        do {
            try JSONStore.sharedInstance().destroyData()

            logMessage(StringResource.DESTROY_MESSAGE)
        } catch let error as NSError {
            logError(error.description)
        }
    }

    @IBAction func removeCollectionButtonClick(sender: UIButton) {
        
        do  {
            try people.removeCollection()
            
            logMessage(StringResource.REMOVE_COLLECTION_MESSAGE)
        } catch let error as NSError {
            logError(error.description)
        }
        
    }
    
    @IBAction func addDataButtonClick(sender: UIButton) {
        if(people == nil) {
            return logError(StringResource.INIT_FIRST_MESSAGE)
        }
        
        resetFieldError(enterNameTextField)
        resetFieldError(enterAgeTextField)
        
        let name:String? = enterNameTextField.text
        let age:Int? = Int(enterAgeTextField.text!)
        
        if(name?.characters.count == 0 || age <= 0) {
            if(name?.characters.count == 0) {
                setTextFieldError(enterNameTextField)
            }
            
            if(age <= 0) {
                setTextFieldError(enterAgeTextField)
            }
            
            return
        }

        let data = ["name" : name!, "age" : age!]
        
        do  {
            try people.addData([data], andMarkDirty: true, withOptions: nil)
            
            logMessage(StringResource.ADD_MESSAGE)

            enterNameTextField.text = nil
            enterAgeTextField.text = nil
        } catch let error as NSError {
            logError(error.description)
        }
    }
    
    @IBAction func findByNameButtonClick(sender: UIButton) {
        if(people == nil) {
            return logError(StringResource.INIT_FIRST_MESSAGE)
        }
        
        resetFieldError(searchTextField)
        
        let searchKeyword:String? = searchTextField.text
        let limit:Int? = Int(limitTextField.text!)
        let offset:Int? = Int(offsetTextField.text!)
        
        if(searchKeyword == nil) {
            return setTextFieldError(searchTextField)
        }
        
        let options:JSONStoreQueryOptions = JSONStoreQueryOptions()
        options.sortBySearchFieldAscending("name")
        options.sortBySearchFieldDescending("age")
        options.filterSearchField("_id")
        options.filterSearchField("json")
        
        if(limit > 0) {
            options.limit = limit
        }
        
        if(offset > 0) {
            options.offset = offset
        }
        
        let query:JSONStoreQueryPart = JSONStoreQueryPart()
        query.searchField("name", like: searchKeyword)
        
        do {
            let results = try people.findWithQueryParts([query], andOptions: options)

            logResults(results)
        } catch let error as NSError {
            logError(error.description)
        }
    }

    @IBAction func findByAgeButtonClick(sender: UIButton) {
        if(people == nil) {
            return logError(StringResource.INIT_FIRST_MESSAGE)
        }
        
        resetFieldError(searchTextField)
        
        let age:Int? = Int(searchTextField.text!)
        let limit:Int? = Int(limitTextField.text!)
        let offset:Int? = Int(offsetTextField.text!)
        
        if(age == nil) {
            return setTextFieldError(searchTextField)
        }
        
        let options:JSONStoreQueryOptions = JSONStoreQueryOptions()
        options.sortBySearchFieldAscending("name")
        options.sortBySearchFieldDescending("age")
        options.filterSearchField("_id")
        options.filterSearchField("json")
        
        if(limit > 0) {
            options.limit = limit
        }
        
        if(offset > 0) {
            options.offset = offset
        }
        
        let query:JSONStoreQueryPart = JSONStoreQueryPart()
        query.searchField("age", equal: age!.description)
        
        do {
            let results = try people.findWithQueryParts([query], andOptions: options)
            
            logResults(results)
        } catch let error as NSError {
            logError(error.description)
        }
        
    }
    
    @IBAction func findAllButtonClick(sender: UIButton) {
        if(people == nil) {
            return logError(StringResource.INIT_FIRST_MESSAGE)
        }
        
        resetFieldError(searchTextField)

        let limit:Int? = Int(limitTextField.text!)
        let offset:Int? = Int(offsetTextField.text!)
        
        let options:JSONStoreQueryOptions = JSONStoreQueryOptions()
        options.sortBySearchFieldAscending("name")
        options.sortBySearchFieldDescending("age")
        options.filterSearchField("_id")
        options.filterSearchField("json")
        
        if(limit > 0) {
            options.limit = limit
        }
        
        if(offset > 0) {
            options.offset = offset
        }
        
        do {
            let results = try people.findAllWithOptions(options)
            
            logResults(results)
        } catch let error as NSError {
            logError(error.description)
        }
    }
    
    @IBAction func findByIdButtonClick(sender: UIButton) {
        if(people == nil) {
            return logError(StringResource.INIT_FIRST_MESSAGE)
        }
        
        resetFieldError(findByIdTextField)
        
        let id:Int? = Int(findByIdTextField.text!)
        
        if(id < 0) {
            return setTextFieldError(findByIdTextField)
        }

        let options:JSONStoreQueryOptions = JSONStoreQueryOptions()
        options.sortBySearchFieldAscending("name")
        options.sortBySearchFieldDescending("age")
        options.filterSearchField("_id")
        options.filterSearchField("json")
        
        do {
            let results = try people.findWithIds([id!], andOptions: options)
            
            logResults(results)
        } catch let error as NSError {
            logError(error.description)
        }
    }

    @IBAction func replaceByIdButtonClick(sender: AnyObject) {
        if(people == nil) {
            return logError(StringResource.INIT_FIRST_MESSAGE)
        }

        resetFieldError(replaceIdTextField)
        resetFieldError(replaceNameTextField)
        resetFieldError(replaceAgeTextField)

        let id:Int? = Int(replaceIdTextField.text!)
        let name:String? = replaceNameTextField.text
        let age:Int? = Int(replaceAgeTextField.text!)

        
        if(name?.characters.count == 0 || age <= 0 || id <= 0) {
            if(name?.characters.count == 0) {
                setTextFieldError(replaceNameTextField)
            }
            
            if(age <= 0) {
                setTextFieldError(replaceAgeTextField)
            }
            
            if(id <= 0) {
                setTextFieldError(replaceIdTextField)
            }
            
            return
        }
        
        var document:Dictionary<String,AnyObject> = Dictionary()
        document["name"] = name
        document["age"] = age?.description
        
        
        var replacement:Dictionary<String,AnyObject> = Dictionary()
        replacement["_id"] = id
        replacement["json"] = document

        do {
            let count:Int = try Int(people.replaceDocuments([replacement], andMarkDirty: true))

            if(count > 0) {
                logMessage(String.init(format: StringResource.REPLACE_MESSAGE, arguments: [id!]))
            } else {
                logError(String.init(format: StringResource.NOT_FOUND_MESSAGE, arguments: [id!]))
            }
        } catch let error as NSError {
            logError(error.description)
        }
    }
    
    @IBAction func removeByIdButtonClick(sender: AnyObject) {
        if(people == nil) {
            return logError(StringResource.INIT_FIRST_MESSAGE)
        }

        resetFieldError(removeIdTextField)

        let id:Int? = Int(removeIdTextField.text!)
        
        
        if(id <= 0) {
            return setTextFieldError(removeIdTextField)
        }
        
        do {
            let count:Int = try Int(people.removeWithIds([id!], andMarkDirty: true))
            
            if(count > 0) {
                logMessage(String.init(format: StringResource.REMOVE_MESSAGE, arguments: [id!]))
            } else {
                logError(String.init(format: StringResource.NOT_FOUND_MESSAGE, arguments: [id!]))
            }
        }
        catch let error as NSError {
            logError(error.description)
        }
    }
    
    //---------------------------------------
    // Load Data From Adapter ButtonClick
    //---------------------------------------
    @IBAction func loadDataFromAdapterButtonClick(sender: AnyObject) {
        if(people == nil) {
            return logError(StringResource.INIT_FIRST_MESSAGE)
        }
        
        let request = WLResourceRequest(URL: NSURL(string: "/adapters/JSONStoreAdapter/getPeople"), method: WLHttpMethodGet)
        request.sendWithCompletionHandler { (response, error) -> Void in
            if(error == nil){
                //print("response.responseText: \(response.responseText)");
                let responsePayload:NSDictionary = response.getResponseJson()
                self.loadDataFromAdapter(responsePayload.objectForKey("peopleList") as! NSArray)
            }
            else{
                print(error.description);
                self.logError(error.description)
            }
        }
    }
    
    //---------------------------------------
    // Load Data From Adapter
    //---------------------------------------
    func loadDataFromAdapter(data:NSArray) {
        if(people == nil) {
            return logError(StringResource.INIT_FIRST_MESSAGE)
        }
        
        do {
            let change:Int = try Int(people.changeData(data as [AnyObject], withReplaceCriteria: nil, addNew: true, markDirty: false))
            logMessage(String.init(format: StringResource.LOAD_FROM_ADAPTER_MESSAGE, [change]))
            
        } catch let error as NSError {
            logError(error.description)
        }
        
    }
    
    //---------------------------------------
    // Get Dirty Documents
    //---------------------------------------
    @IBAction func getDirtyDocumentsButtonClick(sender: AnyObject) {
        if(people == nil) {
            return logError(StringResource.INIT_FIRST_MESSAGE)
        }

        do {
            let dirtyDocs:NSArray = try people.allDirty()

            logResults(dirtyDocs)
            
        } catch let error as NSError {
            logError(error.description)
        }
    }
    
    //---------------------------------------
    // Push Changes To Adapter
    //---------------------------------------
    @IBAction func pushChangesToAdapterButtonClick(sender: AnyObject) {
        if(people == nil) {
            return logError(StringResource.INIT_FIRST_MESSAGE)
        }
        
        let request = WLResourceRequest(URL: NSURL(string: "/adapters/JSONStoreAdapter/pushPeople"), method: WLHttpMethodPost)
        do {
            let dirtyDocs:NSArray = try self.people.allDirty()
            //let pushData:NSData = NSKeyedArchiver.archivedDataWithRootObject(dirtyDocs)
            print("dirtyDocs : \(dirtyDocs.description)");
            request.setQueryParameterValue(dirtyDocs.description, forName:"params")
        } catch let error as NSError {
            self.logError(error.description)
        }
        request.sendWithCompletionHandler { (response, error) -> Void in
            if(error == nil){
                self.logMessage(StringResource.PUSH_FINISH_MESSAGE)
            } else{
                    self.logError(error.description)
            }
        }
    }
    
    @IBAction func countAllButtonClick(sender: AnyObject) {
        if(people == nil) {
            return logError(StringResource.INIT_FIRST_MESSAGE)
        }
        
        do {
            let countAllByName:Int? = try Int(people.countAllDocuments())
            
            logMessage(String.init(format: StringResource.COUNT_ALL_MESSAGE, arguments: [countAllByName!]))
        } catch let error as NSError {
            logError(error.description)
        }
    }
    @IBAction func countByNameButtonClick(sender: AnyObject) {
        if(people == nil) {
            return logError(StringResource.INIT_FIRST_MESSAGE)
        }
        
        resetFieldError(countNameTextField)
        
        let name:String? = countNameTextField.text
        
        if((name?.isEmpty) != nil) {
            return setTextFieldError(countNameTextField)
        }
        
        let query:JSONStoreQueryPart = JSONStoreQueryPart()
        query.searchField("name", equal:name)
        
        do {
            let countAllByName:Int? = try Int(people.countWithQueryParts([query]))
            
            logMessage(String.init(format: StringResource.COUNT_ALL_BY_NAME_MESSAGE, arguments: [countAllByName!]))
        } catch let error as NSError {
            logError(error.description)
        }
    }
    @IBAction func changePasswordButtonClick(sender: AnyObject) {
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
            logError(error.description)
        }
    }
    @IBAction func getFileInfoButtonClick(sender: AnyObject) {
        do {
            let info = try JSONStore.sharedInstance().fileInfo()
            
            logResults(info, message: StringResource.FILE_INFO)
        } catch let error as NSError {
            logError(error.description)
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

