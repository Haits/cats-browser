//
//  IFInputVerificationController.h
//  iFree-Test-task
//
//  Created by Vladimir on 01/10/2017.
//  Copyright © 2017 Vladimir Pallo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IFInputVerificationController : NSObject

- (BOOL)verificationInput:(NSString *)text;
- (BOOL)verificationStringIsURL:(NSString *)path;

@end
