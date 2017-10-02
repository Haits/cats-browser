//
//  IFBrowserViewController.m
//  iFree-Test-task
//
//  Created by Vladimir on 01/10/2017.
//  Copyright © 2017 Vladimir Pallo. All rights reserved.
//

#import "IFBrowserViewController.h"

#import "IFInputVerificationController.h"
#import "IFLoadingProtocol.h"

#import <WebKit/WebKit.h>
#import "NJKWebViewProgress.h"

@interface IFBrowserViewController () <UISearchBarDelegate, UIWebViewDelegate, NJKWebViewProgressDelegate>

@property (nonatomic, weak) IBOutlet UISearchBar *urlSearchBar;
@property (nonatomic, weak) IBOutlet UIProgressView *htmlLoadingProgressBar;

@property (nonatomic, strong) UIWebView *uiWebView;
@property (nonatomic, strong) NJKWebViewProgress *progressProxy;

@end

static NSString * const IFUserAgent = @"Mozilla/5.0 (iPhone; CPU iPhone OS 8_4 like Mac OS X) AppleWebKit/600.1.4 (KHTML, like Gecko) Version/8.0 Mobile/12H141 Safari/600.1.4";

@implementation IFBrowserViewController

#pragma mark - View Lifecycle
#pragma mark -

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupVariables];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self configureUI];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    [self.uiWebView setFrame:CGRectMake(0, self.urlSearchBar.frame.origin.y + self.urlSearchBar.frame.size.height , [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - self.urlSearchBar.frame.origin.x - self.urlSearchBar.frame.size.height)];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Action
#pragma mark -

#pragma mark - Public Methods
#pragma mark -

#pragma mark - Private Methods
#pragma mark -

- (void)openUrlWithInputText:(NSString *)path {
    if ([[IFInputVerificationController alloc] verificationInput:path]) {
        [self.htmlLoadingProgressBar setHidden:NO];
        self.htmlLoadingProgressBar.progress = 0;
        NSURL *loadURL;
        if ([[IFInputVerificationController alloc] verificationStringIsURL:path]) {
            loadURL = [[NSURL alloc] initWithString:path];
        } else {
            path = [path stringByReplacingOccurrencesOfString:@" " withString:@"+"];
            loadURL = [NSURL URLWithString:[NSString stringWithFormat:@"https://www.google.ru/search?q=%@", path]];
            if (loadURL == nil) {
                path = [path stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLPathAllowedCharacterSet]];
                loadURL = [NSURL URLWithString:[NSString stringWithFormat:@"https://www.google.ru/search?q=%@", path]];
            }
        }
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:loadURL];
        [request setValue:IFUserAgent forHTTPHeaderField:@"UserAgent"];
        [self loadWebViewWithRequest:request];
    } else {
        [self showAlertWithTitle:@"Information" message:@"Please input url or text" cancelButtonTitle:@"OK"];
    }
}

- (void)loadWebViewWithRequest:(NSURLRequest *)request {
    [self.uiWebView loadRequest:request];
}

#pragma mark - Init function
#pragma mark -

- (void)setupVariables {
    [NSURLProtocol registerClass:[IFLoadingProtocol class]];
    self.progressProxy = [[NJKWebViewProgress alloc] init];
    self.progressProxy.webViewProxyDelegate = self;
    self.progressProxy.progressDelegate = self;
    
    self.uiWebView = [[UIWebView alloc] initWithFrame:CGRectZero];
    self.uiWebView.delegate = self.progressProxy;
    [self.view addSubview:self.uiWebView];
}

- (void)configureUI {
    
}

#pragma mark - Support UI Function
#pragma mark -

#pragma mark - Support Function
#pragma mark -

#pragma mark - Notifications & Observers
#pragma mark -

#pragma mark - Protocols Implementation
#pragma mark -

#pragma mark - UISearchBarDelegate

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [self openUrlWithInputText:searchBar.text];
    [searchBar resignFirstResponder];
}

#pragma mark - NJKWebViewProgressDelegate

- (void)webViewProgress:(NJKWebViewProgress *)webViewProgress updateProgress:(float)progress {
    [self.htmlLoadingProgressBar setProgress:progress animated:YES];
    if (self.htmlLoadingProgressBar.progress >= 1.0) {
        [self.htmlLoadingProgressBar setHidden:YES];
    } else {
        if (self.htmlLoadingProgressBar.isHidden) {
            [self.htmlLoadingProgressBar setHidden:YES];
        }
    }
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    self.urlSearchBar.text = webView.request.URL.absoluteString;
}

@end
