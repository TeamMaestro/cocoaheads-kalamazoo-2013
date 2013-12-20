//
//  ServerRequest.h
//  JSONCocoaHeads
//
//  Created by John Pinkster on 12/3/13.
//  Copyright (c) 2013 JohnPinkster. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ServerRequest : NSObject

typedef void(^RequestCompletionHandler)(NSString*,NSError*);
typedef void(^RequestDictionaryCompletionHandler)(NSDictionary*);


+(void)requestPath:(NSString *)path
      onCompletion:(RequestCompletionHandler)complete;

+(void)retrieveJSONWithType:(NSString *)type
          onCompletion:(RequestDictionaryCompletionHandler)complete;


@end
