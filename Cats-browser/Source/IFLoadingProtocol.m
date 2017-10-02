//
//  IFLoadingProtocol.m
//  iFree-Test-task
//
//  Created by Vladimir on 01/10/2017.
//  Copyright © 2017 Vladimir Pallo. All rights reserved.
//

#import "IFLoadingProtocol.h"

@interface IFLoadingProtocol() <NSURLSessionDataDelegate, NSURLSessionTaskDelegate>

@property (nonatomic, strong) NSURLSessionDataTask *dataTask;
@property (nonatomic, strong) NSURLResponse *urlResponse;
@property (nonatomic, strong) NSMutableData *receivedData;

@property (nonatomic) BOOL replaceImage;

@end

@implementation IFLoadingProtocol

+ (BOOL)canInitWithRequest:(NSURLRequest *)request {
    return YES;
}

+ (NSURLRequest *)canonicalRequestForRequest:(NSURLRequest *)request {
    return request;
}

- (instancetype)initWithTask:(NSURLSessionTask *)task cachedResponse:(NSCachedURLResponse *)cachedResponse client:(id<NSURLProtocolClient>)client {
    self = [super initWithTask:task cachedResponse:cachedResponse client:client];
    if ( self ) {
        
    }
    return self;
}

- (instancetype)initWithRequest:(NSURLRequest *)request cachedResponse:(NSCachedURLResponse *)cachedResponse client:(id<NSURLProtocolClient>)client {
    self = [super initWithRequest:request cachedResponse:cachedResponse client:client];
    if ( self ) {
        
    }
    return self;
}

- (void)startLoading {
    if ([self.request.allHTTPHeaderFields[@"Accept"] containsString:@"image"] || [self.request.allHTTPHeaderFields[@"Content-Type"] containsString:@"image"]) {
        [self loadImageWithCat];
    } else {
        NSMutableURLRequest *newRequest = self.request.mutableCopy;
        NSURLSessionConfiguration *config =  [NSURLSessionConfiguration defaultSessionConfiguration];
        NSURLSession *session = [NSURLSession sessionWithConfiguration:config delegate:self delegateQueue:nil];
        self.dataTask = [session dataTaskWithRequest:newRequest];
        [self.dataTask resume];
    }
}

- (void)stopLoading {
    if (self.dataTask) {
        [self.dataTask cancel];
    }
    self.dataTask = nil;
    self.receivedData = nil;
    self.urlResponse = nil;
}

#pragma mark - NSURLSessionDataDelegate
#pragma mark -

- (void)URLSession:(NSURLSession *)session
          dataTask:(nonnull NSURLSessionDataTask *)dataTask
didReceiveResponse:(nonnull NSURLResponse *)response
 completionHandler:(nonnull void (^)(NSURLSessionResponseDisposition))completionHandler {
    if ([response.MIMEType containsString:@"gif"] || [response.MIMEType containsString:@"jpeg"] ||    [response.MIMEType containsString:@"pjpeg"] || [response.MIMEType containsString:@"png"] || [response.MIMEType containsString:@"svg+xml"] || [response.MIMEType containsString:@"tiff"] ||
        [response.MIMEType containsString:@"vnd.microsoft.icon"] || [response.MIMEType containsString:@"vnd.wap.wbmp"] || [response.MIMEType containsString:@"webp"]) {
        [self.dataTask cancel];
        [self loadImageWithCat];
    } else {
        if ([response.MIMEType containsString:@"html"]) {
            self.replaceImage = YES;
        } else {
            self.replaceImage = NO;
        }
        [self.client URLProtocol:self didReceiveResponse:response cacheStoragePolicy:NSURLCacheStorageNotAllowed];
        self.urlResponse = response;
        self.receivedData = [NSMutableData new];
        completionHandler(NSURLSessionResponseAllow);
    }
}

- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveData:(NSData *)data {
    if (!self.replaceImage) {
        [self.client URLProtocol:self didLoadData:data];
    }
    [self.receivedData appendData:data];
}

#pragma mark - NSURLSessionTaskDelegate
#pragma mark -

- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error {
    if (error != nil && error.code != NSURLErrorCancelled) {
        [self.client URLProtocol:self didFailWithError:error];
    } else {
        if ([task.response.MIMEType containsString:@"html"]) {
            NSString *html = [[NSString alloc] initWithData:self.receivedData encoding:NSUTF8StringEncoding];
            
            NSString *pattern = @"<img[^>]*>";
            NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:pattern
                                                                                   options:0
                                                                                     error:NULL];
            NSMutableString *replacedHtml = [html mutableCopy];
            __block NSInteger offset = 0;
            [regex enumerateMatchesInString:html
                                    options:0
                                      range:NSMakeRange(0, html.length)
                                 usingBlock:^(NSTextCheckingResult *result, NSMatchingFlags flags, BOOL *stop) {
                                     NSRange range = [result range];
                                     range.location += offset;
                                     NSString *value = [NSString stringWithFormat:@"<img src=\"%@.jpg\"/>", [self getRandomCatName]];
                                     [replacedHtml replaceCharactersInRange:range withString:value];
                                     offset += value.length - range.length;
                                 }];
            [[self client] URLProtocol:self didReceiveResponse:task.response cacheStoragePolicy:NSURLCacheStorageAllowedInMemoryOnly];
            [[self client] URLProtocol:self didLoadData:[replacedHtml dataUsingEncoding:NSUTF8StringEncoding]];
        }
        [self.client URLProtocolDidFinishLoading:self];
    }
}

- (void)URLSession:(NSURLSession *)session
              task:(NSURLSessionTask *)task
willPerformHTTPRedirection:(NSHTTPURLResponse *)redirectResponse
        newRequest:(NSURLRequest *)request
 completionHandler:(void (^)(NSURLRequest *))completionHandler {
    [self.client URLProtocol:self wasRedirectedToRequest:request redirectResponse:redirectResponse];
}

#pragma mark - Private methods
#pragma mark -

- (void)loadImageWithCat {
    NSURLResponse *response = [[NSURLResponse alloc] initWithURL:[self.request URL]
                                                        MIMEType:@"image/jpeg"
                                           expectedContentLength:-1
                                                textEncodingName:nil];
    NSString *imagePath = [[NSBundle mainBundle] pathForResource:[self getRandomCatName] ofType:@"jpg"];
    NSData *data = [NSData dataWithContentsOfFile:imagePath];
    [[self client] URLProtocol:self didReceiveResponse:response cacheStoragePolicy:NSURLCacheStorageAllowedInMemoryOnly];
    [[self client] URLProtocol:self didLoadData:data];
    [[self client] URLProtocolDidFinishLoading:self];
}

- (NSString *)getRandomCatName {
    NSUInteger randomNumber = arc4random_uniform(10);
    return [NSString stringWithFormat:@"cat-%lu", (unsigned long)randomNumber];
}

@end
