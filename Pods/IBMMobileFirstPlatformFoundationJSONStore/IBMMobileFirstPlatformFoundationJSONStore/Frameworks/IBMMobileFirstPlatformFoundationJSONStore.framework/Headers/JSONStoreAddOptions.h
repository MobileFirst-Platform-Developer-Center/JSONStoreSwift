/**
	Licensed Materials - Property of IBM

	(C) Copyright 2015 IBM Corp.

	Unless required by applicable law or agreed to in writing, software
	distributed under the License is distributed on an "AS IS" BASIS,
	WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
	See the License for the specific language governing permissions and
	limitations under the License.
*/

#import <Foundation/Foundation.h>

/**
 Contains JSONStore options for the add API.
 @since IBM Worklight V6.2.0
 */
@interface JSONStoreAddOptions : NSObject

/**
 Dictionary of additional search fields. 
 
 Example:
 
 		{@"name" : @"carlos"}.
 
 @since IBM Worklight V6.2.0
 */
@property (nonatomic, strong) NSDictionary* additionalSearchFields;

@end
