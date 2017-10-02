//
//  IFLoadingProtocol.h
//  iFree-Test-task
//
//  Created by Vladimir on 01/10/2017.
//  Copyright © 2017 Vladimir Pallo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IFLoadingProtocol : NSURLProtocol

- (instancetype)initWithRequest:(NSURLRequest *)request cachedResponse:(NSCachedURLResponse *)cachedResponse client:(id<NSURLProtocolClient>)client;

@end
