#import <XCTest/XCTest.h>
#import "RELTransformerUtilities.h"

@interface ValueTransformerTests : XCTestCase

@end


@implementation ValueTransformerTests

- (void)setUp
{
    [super setUp];
    putchar('\n');
}

- (void)tearDown
{
    putchar('\n');
    [super tearDown];
}

- (void)testTransformURLStringToNSURLInstance
{
    NSString *URLString = @"http://www.aboutobjects.com";
    NSURL *expectedURL = [NSURL URLWithString:URLString];
    NSValueTransformer *transformer = [NSValueTransformer valueTransformerForName:RELTransformerNameForClass([NSURL class])];
    
    NSURL *actualURL = [transformer transformedValue:URLString];
    XCTAssertEqualObjects(actualURL, expectedURL,
                          @"Value transformer of type %@ should have transformed string \"%@\" into an instance of NSURL containing \"%@\".",
                          [transformer class], URLString, expectedURL);
}

- (void)testTransformNilURLStringToNSURLInstance
{
    NSString *URLString = nil;
    NSURL *expectedURL = [NSURL URLWithString:URLString];
    NSValueTransformer *transformer = [NSValueTransformer valueTransformerForName:RELTransformerNameForClass([NSURL class])];
    
    NSURL *actualURL = [transformer transformedValue:URLString];
    XCTAssertEqualObjects(actualURL, expectedURL,
                          @"Value transformer of type %@ should have transformed string \"%@\" into an instance of NSURL containing \"%@\".",
                          [transformer class], URLString, expectedURL);
}

- (void)testTransformNumericStringToNSNumberInstance
{
    NSString *numericString = @"123.45";
    NSNumber *expectedValue = [NSDecimalNumber decimalNumberWithString:numericString];
    NSValueTransformer *transformer = [NSValueTransformer valueTransformerForName:RELTransformerNameForClass([NSNumber class])];
    
    NSNumber *actualValue = [transformer transformedValue:numericString];
    XCTAssertEqualObjects(actualValue, expectedValue,
                          @"Value transformer of type %@ should have transformed string \"%@\" into an instance of NSNumber containing \"%@\".",
                          [transformer class], numericString, expectedValue);
}


@end
