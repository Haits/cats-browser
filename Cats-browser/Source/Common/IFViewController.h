//
//  IFViewController.h
//  iFree-Test-task
//
//  Created by Vladimir on 01/10/2017.
//  Copyright © 2017 Vladimir Pallo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IFViewController : UIViewController

- (void)showAlertWithError:(NSError *)error;
- (void)showAlertWithTitle:(NSString *)title message:(NSString *)message cancelButtonTitle:(NSString *)cancelButtonTitle;
- (void)showAlertWithTitle:(NSString *)title message:(NSString *)message buttons:(NSArray<UIAlertAction *> *)buttons;
- (void)showAlertWithTitle:(NSString *)title message:(NSString *)message buttons:(NSArray<UIAlertAction *> *)buttons cancelButtonTitle:(NSString *)cancelButtonTitle;

- (void)showActionSheetWithTitle:(NSString *)title message:(NSString *)message buttons:(NSArray<UIAlertAction *> *)buttons;

@end
