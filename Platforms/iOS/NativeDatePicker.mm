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
    return (char*)[str UTF8String];
}
@end

// Helper method to create C string copy
char* MakeStringCopy (const char* string)
{
	if (string == NULL)
		return NULL;
	
	char* res = (char*)malloc(strlen(string) + 1);
	strcpy(res, string);
	return res;
}

extern "C"
{
    char* NativeDatePicker_speak() {
        return MakeStringCopy([[NativeDatePicker sharedInstance] getGreeting]);
    }
}
