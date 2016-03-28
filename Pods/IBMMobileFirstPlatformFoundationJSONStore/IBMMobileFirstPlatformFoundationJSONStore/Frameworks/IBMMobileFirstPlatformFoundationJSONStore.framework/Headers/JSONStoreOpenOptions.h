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
 Contains JSONStore options that are used to open collections.
 @since IBM Worklight V6.2.0
 */
@interface JSONStoreOpenOptions : NSObject

/**
 The user name.
 @since IBM Worklight V6.2.0
 */
@property (nonatomic, strong) NSString* username;

/**
 The password.
 @since IBM Worklight V6.2.0
 */
@property (nonatomic, strong) NSString* password;

/**
 The secure random that is used for the Data Protection Key (DPK).
 @since IBM Worklight V6.2.0
 */
@property (nonatomic, strong) NSString* secureRandom;

/**
 Determines if we log analytics data for JSONStore operations.
 @since IBM Worklight V6.2.0
 */
@property (nonatomic) BOOL analytics;

@end
