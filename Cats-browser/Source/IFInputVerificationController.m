//
//  IFInputVerificationController.m
//  iFree-Test-task
//
//  Created by Vladimir on 01/10/2017.
//  Copyright © 2017 Vladimir Pallo. All rights reserved.
//

#import "IFInputVerificationController.h"

@implementation IFInputVerificationController

#pragma mark - Public

- (BOOL)verificationInput:(NSString *)path {
    if ([path stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]].length <= 0 || path == nil) {
        return NO;
    }
    return YES;
}

- (BOOL)verificationStringIsURL:(NSString *)path {
    NSURL *url = [NSURL URLWithString:path];
    if (url && url.scheme && url.host) {
        return YES;
    }
    return NO;
}

@end
