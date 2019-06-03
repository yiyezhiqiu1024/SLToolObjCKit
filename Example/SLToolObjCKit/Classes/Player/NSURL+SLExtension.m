//
//  NSURL+SLExtension.m
//  SLToolObjCKit
//
//  Created by CoderSLZeng on 2019/6/3.
//

#import "NSURL+SLExtension.h"

@implementation NSURL (SLExtension)

- (NSURL *)sl_sreamingURL {
    NSURLComponents *cmps = [NSURLComponents componentsWithString:self.absoluteString];
    cmps.scheme = @"sreaming";
    return cmps.URL;
}

- (NSURL *)sl_httpURL {
    NSURLComponents *cmps = [NSURLComponents componentsWithString:self.absoluteString];
    cmps.scheme = @"http";
    return cmps.URL;
}

@end
