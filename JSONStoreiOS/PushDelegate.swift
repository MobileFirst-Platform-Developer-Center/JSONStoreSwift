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
import Foundation

class PushDelegate: NSObject, WLDelegate {
    
    var controller:ViewController?
    var collection:JSONStoreCollection?
    var data:NSArray?
    
    init(controller: ViewController) {
        self.controller = controller
    }
    
    func setDataCollection(collection: JSONStoreCollection) {
        self.collection = collection
    }
    
    func setDataList(data:NSArray) {
        self.data = data
    }
    
    func onSuccess(response: WLResponse!) {
        do {
            try collection?.markDocumentsClean(data! as [AnyObject])
            
            controller?.logMessage(StringResource.PUSH_FINISH_MESSAGE)

        } catch let error as NSError {
            controller?.logError(error.description)
        }
    }
    
    func onFailure(response: WLFailResponse!) {
        controller?.logError(response.description)
    }
}