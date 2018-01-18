//
//  DPDelegateProxy.m
//  DelegateProxy
//
//  Created by Ryo Aoyama on 8/5/16.
//  Copyright © 2016 Ryo Aoyama. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DPDelegateProxy.h"
#import "DPRuntime.h"

@implementation DPDelegateProxy

- (instancetype)init {
    self = [super init];
    if (self) {
        self.allowsPlainDelegateCallbacks = true; // default to true
    }
    return self;
}

- (void)interceptedSelector:(SEL)selector arguments:(NSArray *)arguments {
    NSAssert(NO, @"Abstract method");
}

- (void)forwardInvocation:(NSInvocation *)anInvocation {
    if (DP_isMethodSignatureVoid(anInvocation.methodSignature)) {
        NSArray *arguments = DP_argumentsFromInvocation(anInvocation);
        [self interceptedSelector:anInvocation.selector arguments:arguments];
        
        if (self.allowsPlainDelegateCallbacks &&
            self.cachedPlainDelegate != nil &&
            [self.cachedPlainDelegate respondsToSelector:anInvocation.selector])
        {
            [anInvocation invokeWithTarget: self.cachedPlainDelegate];
        }
    }
}

@end
