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
 Contains JSONStore query options.
 @since IBM Worklight V6.2.0
 */
@interface JSONStoreQueryOptions : NSObject

/**
 Private. Flag to turn a find into a count.
 @since IBM Worklight V6.2.0
 @private
 */
@property (nonatomic) BOOL _count;

/**
 Private. NSArray with sort criteria (e.g. [{name: @"ASC"}]).
 @since IBM Worklight V6.2.0
 */
@property (nonatomic,strong) NSMutableArray* _sort;

/**
 Private. NSArray with filter criteria (e.g. [@"name", @"age"]).
 @since IBM Worklight V6.2.0
 */
@property (nonatomic,strong) NSMutableArray* _filter;

/**
 Determines the maximum number of results to return.
 @since IBM Worklight V6.2.0
 */
@property (nonatomic,strong) NSNumber* limit;

/**
 Determines the maximum number of documents to skip from the result.
 @since IBM Worklight V6.2.0
 */
@property (nonatomic,strong) NSNumber* offset;

/**
 Sorts by search field ascending.
 @param searchField Search field
 @since IBM Worklight V6.2.0
 */
-(void) sortBySearchFieldAscending:(NSString*) searchField;

/**
 Sorts by search field descending.
 @param searchField Search field
 @since IBM Worklight V6.2.0
 */
-(void) sortBySearchFieldDescending:(NSString*) searchField;

/**
 Filter by search field.
 @param searchField Search field
 @since IBM Worklight V6.2.0
 */
-(void) filterSearchField:(NSString*) searchField;

/**
 String representation of the object.
 @since IBM Worklight V6.2.0
 */
-(NSString*) description;

@end
