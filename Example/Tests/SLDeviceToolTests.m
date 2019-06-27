//
//  SLDeviceToolTests.m
//  SLToolObjCKit_Tests
//
//  Created by CoderSLZeng on 2019/6/27.
//  Copyright © 2019 CoderSLZeng. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <SLToolObjCKit/SLDeviceTool.h>

@interface SLDeviceToolTests : XCTestCase

@end

@implementation SLDeviceToolTests

- (void)setUp {
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
}

- (void)testExample {
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

- (void)testAppVersion {
    NSLog(@"%s - %@", __func__, [SLDeviceTool appVersionWithBundleForClass:[self class]]);
}

- (void)testBundleIdentifier {
    NSLog(@"%s - %@", __func__, [SLDeviceTool bundleIdentifierWithBundleForClass:[self class]]);
}

- (void)testGetDateByInt {
    NSLog(@"%s - %d", __func__, [SLDeviceTool getDateByInt]);
}

- (void)testDeviceInfo {
    NSLog(@"%s - %@", __func__, [SLDeviceTool deviceInfo]);
}

- (void)testMacAddress {
    NSLog(@"%s - %@", __func__, [SLDeviceTool macAddress]);
}

- (void)testIpAddressIsV4 {
    NSLog(@"%s - %@", __func__, [SLDeviceTool ipAddressIsV4:YES]);
}

- (void)testDeviceName {
    NSLog(@"%s - %@", __func__, [SLDeviceTool deviceName]); // Amass+
}

- (void)testDeviceModel {
    NSLog(@"%s - %@", __func__, [SLDeviceTool deviceModel]); // iPhone7,1
}

- (void)testDeviceModelName {
    NSLog(@"%s - %@", __func__, [SLDeviceTool deviceModelName]); // iPhone 6
}

- (void)testJailbroken {
    BOOL isJailbroken = [SLDeviceTool jailbroken];
    if (isJailbroken) {
        NSLog(@"%s - 已越狱", __func__);
    } else  {
        NSLog(@"%s - 未越狱", __func__);
    }
}

- (void)testChinaMobileModel {
    NSLog(@"%s - %@", __func__, [SLDeviceTool chinaMobileModel]);
}

- (void)testSystemVersion {
    NSLog(@"%s - %@", __func__, [SLDeviceTool systemVersion]);
}

- (void)testNetWorkStates {
    NSLog(@"%s - %@", __func__, [SLDeviceTool netWorkStates]);
}

@end
