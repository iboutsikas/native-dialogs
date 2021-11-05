#import <Foundation/Foundation.h>

@interface NativeDatePicker: NSObject 
{

}
@end

@implementation NativeDatePicker
static NativeDatePicker* _instance;

+(NativeDatePicker*) sharedInstance
{
    static dispatch_once_t dispatchToken;

    dispatch_once(&dispatchToken, ^{
        NSLog(@"Creating native iOS singleton");

        _instance = [[NativeDatePicker alloc] init];
    });

    return _instance;
}

-(id) init
{
    self = [super init];
    
    return self;
}

-(char*) getGreeting
{
    NSString* str = @"Hello from the iOS side of the moon";
    NSLog(str);
    return [str UTF8String];
}
@end


extern "C"
{
    char* speak() {
        return [[NativeDatePicker sharedInstance] getGreeting];
    }
}
