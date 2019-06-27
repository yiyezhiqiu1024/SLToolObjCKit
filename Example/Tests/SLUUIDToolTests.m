//
//  SLUUIDToolTests.m
//  SLToolObjCKit_Tests
//
//  Created by CoderSLZeng on 2019/6/27.
//  Copyright © 2019 CoderSLZeng. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <SLToolObjCKit/SLUUIDTool.h>

@interface SLUUIDToolTests : XCTestCase

@end

@implementation SLUUIDToolTests

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

- (void)testUUID {
    NSLog(@"%@", [SLUUIDTool UUID]); // C9227083-A00D-4B23-9188-0A812406C5F7
    NSLog(@"%@", [SLUUIDTool UUID]); // 59D08CD7-FC09-40B2-B1EB-2D7434BFCC60
}

- (void)testUUIDByKeyChain {
    NSLog(@"%@", [SLUUIDTool UUIDByKeychainForClass:[self class]]); // 9B5ACE29-66AA-46DA-AC6D-C62556531154
    NSLog(@"%@", [SLUUIDTool UUIDByKeychainForClass:[self class]]); // 9B5ACE29-66AA-46DA-AC6D-C62556531154
}

@end
