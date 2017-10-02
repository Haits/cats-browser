//
//  IFViewController.m
//  iFree-Test-task
//
//  Created by Vladimir on 01/10/2017.
//  Copyright © 2017 Vladimir Pallo. All rights reserved.
//

#import "IFViewController.h"

@interface IFViewController ()

@end

@implementation IFViewController

#pragma mark - Init Methods & Superclass Overriders
#pragma mark -

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.view endEditing:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (BOOL)prefersStatusBarHidden {
    return NO;
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Show Alert

- (void)showAlertWithError:(NSError *)error {
    NSString *message;
    if (error) {
        message = error.localizedFailureReason;
    }
    if (error && (message == nil || message.length == 0)) {
        message = error.localizedDescription;
    }
    if (message == nil || message.length == 0) {
        message = @"Unexpected error";
    }
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Error has occurred" message:message preferredStyle:UIAlertControllerStyleAlert];
    NSArray *alertButtons = @[[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil]];
    
    [self showAlertController:alertController withButtons:alertButtons];
}

- (void)showAlertWithTitle:(NSString *)title message:(NSString *)message cancelButtonTitle:(NSString *)cancelButtonTitle {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    NSArray *alertButtons = @[[UIAlertAction actionWithTitle:cancelButtonTitle style:UIAlertActionStyleCancel handler:nil]];
    
    [self showAlertController:alertController withButtons:alertButtons];
}

- (void)showAlertWithTitle:(NSString *)title message:(NSString *)message buttons:(NSArray<UIAlertAction *> *)buttons {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    
    [self showAlertController:alertController withButtons:buttons];
}

- (void)showAlertWithTitle:(NSString *)title message:(NSString *)message buttons:(NSArray<UIAlertAction *> *)buttons cancelButtonTitle:(NSString *)cancelButtonTitle {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    
    NSMutableArray *alertButtons = [NSMutableArray arrayWithArray:buttons];
    [alertButtons addObject:[UIAlertAction actionWithTitle:cancelButtonTitle style:UIAlertActionStyleCancel handler:nil]];
    
    [self showAlertController:alertController withButtons:alertButtons];
}

- (void)showActionSheetWithTitle:(NSString *)title message:(NSString *)message buttons:(NSArray<UIAlertAction *> *)buttons {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleActionSheet];
    [self showAlertController:alertController withButtons:buttons];
}

#pragma mark - Private Methods
#pragma mark -

- (void)showAlertController:(UIAlertController *)alertController withButtons:(NSArray<UIAlertAction *> *)buttons {
    for (id object in buttons) {
        if ([object isKindOfClass:[UIAlertAction class]]) {
            [alertController addAction:object];
        }
    }
    [[self currentViewController] presentViewController:alertController animated:YES completion:nil];
}

- (UIViewController *)currentViewController {
    UIViewController *viewController = [UIApplication sharedApplication].keyWindow.rootViewController;
    return [self findTopViewController:viewController];
}

- (UIViewController *)findTopViewController:(UIViewController *)vc {
    if (vc.presentedViewController) {
        return [self findTopViewController:vc.presentedViewController];
    } else if ([vc isKindOfClass:[UISplitViewController class]]) {
        UISplitViewController *svc = (UISplitViewController*) vc;
        if (svc.viewControllers.count > 0) {
            return [self findTopViewController:svc.viewControllers.lastObject];
        } else {
            return vc;
        }
    } else if ([vc isKindOfClass:[UINavigationController class]]) {
        UINavigationController *svc = (UINavigationController*) vc;
        if (svc.viewControllers.count > 0) {
            return [self findTopViewController:svc.topViewController];
        } else {
            return vc;
        }
    } else if ([vc isKindOfClass:[UITabBarController class]]) {
        UITabBarController *svc = (UITabBarController*) vc;
        if (svc.viewControllers.count > 0) {
            return [self findTopViewController:svc.selectedViewController];
        } else {
            return vc;
        }
    } else {
        return vc;
    }
}

@end
