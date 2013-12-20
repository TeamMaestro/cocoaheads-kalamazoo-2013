//
//  ServerRequest.m
//  JSONCocoaHeads
//
//  Created by John Pinkster on 12/3/13.
//  Copyright (c) 2013 JohnPinkster. All rights reserved.
//

#import "ServerRequest.h"

@implementation ServerRequest


+(void)requestPath:(NSString *)path onCompletion:(RequestCompletionHandler)complete {
    // Background Queue
    NSOperationQueue *backgroundQueue = [[NSOperationQueue alloc] init];
    
    // URL Request
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:path]
                                                  cachePolicy:NSURLCacheStorageAllowedInMemoryOnly
                                              timeoutInterval:10];
    
    // Send Request
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:backgroundQueue
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                               
                               NSString *result = [[NSString alloc] initWithData:data
                                                                        encoding:NSUTF8StringEncoding];
                               if (complete) complete(result,error);
                           
                           }
     ];
}
+(void)retrieveJSONWithType:(NSString *)type
               onCompletion:(RequestDictionaryCompletionHandler)complete{

    NSString *basePath = @"http://pinksterdesign.com/random/cocoaheads.php?";
    NSString *fullPath = [basePath stringByAppendingFormat:@"t=%@",type];
    NSLog(@"%@",fullPath);
    
    //Creating request
    [ServerRequest requestPath:fullPath
                  onCompletion:^(NSString *result, NSError *error) {
                      
                      NSLog(@"%@",result);
                      
                      //If error or empty return nil
                      if (error || [result isEqualToString:@""]) {
                          NSLog(@"%@", error.description);
                          if (complete) complete(nil);
                      }
                      else {
                          NSData *data = [result dataUsingEncoding:NSUTF8StringEncoding];
                          
                          
                          //JSON Serialization to the UTF8 encoded response
                          NSDictionary *myJSON = [NSJSONSerialization JSONObjectWithData:data
                                                                                 options:kNilOptions
                                                                                   error:nil];
                          
                          //return NSDictionary
                          if (complete) complete(myJSON);
                      }
                  }
     ];
}


@end
