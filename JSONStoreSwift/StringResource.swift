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

class StringResource {
    static var COLLECTION_NAME:String = "people"
    static var DEFAULT_USERNAME:String = "jsonstore"
    static var INIT_FIRST_MESSAGE:String = "PERSISTENT_STORE_NOT_OPEN"
    static var INIT_MESSAGE:String = "Collection initialized"
    static var DESTROY_MESSAGE:String = "Destroy finished successfully"
    static var CLOSE_MESSAGE:String = "JSONStore closed"
    static var REMOVE_COLLECTION_MESSAGE:String = "Removed all data in the collection"
    static var ADD_MESSAGE:String = "Data added to the collection"
    static var REMOVE_MESSAGE:String = "Document with id:%d removed"
    static var REPLACE_MESSAGE:String = "Document with id:%d replaced successfully"
    static var NOT_FOUND_MESSAGE:String = "Document with id:%d NOT FOUND"
    static var LOAD_FROM_ADAPTER_MESSAGE:String = "New documents loaded from adapter: %d"
    static var PUSH_FINISH_MESSAGE:String = "Push finished"
    static var COUNT_ALL_MESSAGE:String = "Documents in the collection: %d"
    static var COUNT_ALL_BY_NAME_MESSAGE:String = "Documents in the collection with name(%) : %d"
    static var PASSWORD_CHANGE_MESSAGE:String = "Password changed successfully"
    static var FILE_INFO:String = "FileInfo"
    static var DEFAULT_LIMIT:String = "0"
    static var DEFAULT_OFFSET:String = "0"
    
}
