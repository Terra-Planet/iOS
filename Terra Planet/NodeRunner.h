//
//  NodeRunner.h
//  native-xcode-node-folder
//
//  Created by Jaime Bernardo on 08/03/2018.
//  Copyright © 2018 Janea Systems. All rights reserved.
//

#ifndef NodeRunner_h
#define NodeRunner_h
#import <Foundation/Foundation.h>

@interface NodeRunner : NSObject {}
+ (void) runNode:(NSString*) httpUsername withPassword:(NSString*) httpPassword;
+ (void) stopHttpServer;
+ (void) startHttpServer;
@end

#endif
