//
// Created by antoni on 3/11/13.
//
// To change the template use AppCode | Preferences | File Templates.
//

#import <Foundation/Foundation.h>


@interface PLGame : NSObject

@property (nonatomic, strong, readonly) NSString * gameId;
@property (nonatomic, strong, readonly) NSString * name;

-(void) loadFromDict:(NSDictionary *)dict;

@end