#import "NativeDatePicker.h"
#import "PopoverDatepickerController.h"
#import "DataConvert.h"

DateCallbackFunction __CSharp_Delegate = NULL;

@implementation NativeDatePicker
static NativeDatePicker* _instance;

-(id) init
{
    self = [super init];
    
    return self;
}

-(CGFloat) getScale:(UIView*) view
{
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
    {
        return view.window.screen.nativeScale;
    }
    return view.contentScaleFactor;
}

+(NativeDatePicker*) sharedInstance
{
    static dispatch_once_t dispatchToken;

    dispatch_once(&dispatchToken, ^{
        NSLog(@"Creating native iOS singleton");

        _instance = [[NativeDatePicker alloc] init];
    });

    return _instance;
}



-(NSString*) getGreeting
{
    NSString* str = @"Hello from the iOS side of the moon";
    NSLog(@"%@", str);
    return str;
}

-(void) initializeDatePicker:(float) x y: (float) y width: (float) width height: (float) height
{

    if (self->datePicker == nil)
        self->datePicker = [[UIDatePicker alloc] initWithFrame:CGRectZero]; 


    [self setPosition:x y:y width:width height:height];
    
    self->datePicker.backgroundColor = [UIColor redColor];
    [self->datePicker sizeToFit];

    UIView* view = UnityGetGLViewController().view;
    [view addSubview: self->datePicker];
}

-(void) setPosition:(float) x y: (float) y width: (float) width height: (float) height
{
    if (self->datePicker == nil)
        return;

    UIView* view = UnityGetGLViewController().view;

    CGFloat scale = 1.0 / [self getScale:view];

    CGRect frame = CGRectZero;

    frame.origin.x = x * scale;
    frame.origin.y = y * scale;
    frame.size.width = (width - x) * scale;
    frame.size.height = (height - y) * scale;

    [self->datePicker setFrame: frame];
}

-(void) showPopoverDatePicker
{
    auto unityView = UnityGetGLView();
    auto unityFrame = unityView.frame;
    
    if (self->popoverController == nil)
    {
        self->popoverController = [[PopoverDatepickerController alloc] init];
        self->popoverController.callbackTarget = self;
    }
    
//    self->popoverController.dateSetCallback = &dateCallback;
    UIPopoverPresentationController* ctr = self->popoverController.popoverPresentationController;
    
    ctr.sourceView = unityView;
    ctr.sourceRect = CGRectMake(unityFrame.size.width / 2, unityFrame.size.height /2 , 0, 0);
    [UnityGetGLViewController() presentViewController:self->popoverController animated:YES completion:nil];
}

- (void) newDateAvailable:(NSDate*)date
{
    if (__CSharp_Delegate != NULL){
        auto formatter = [[NSISO8601DateFormatter alloc] init];
        auto string = [formatter stringFromDate:date];
        __CSharp_Delegate(MakeStringCopy(string));
    }
}

@end

extern "C"
{
char* _TAG_NativeDatePicker_getGreeting() {
    return MakeStringCopy([[NativeDatePicker sharedInstance] getGreeting]);
}

void _TAG_NativeDatePicker_initialize(float x_, float y_, float width_, float height_) {
    [[NativeDatePicker sharedInstance] initializeDatePicker: x_ y: y_ width: width_ height: height_];
}

void _TAG_NativeDatePicker_setPosition(float x, float y, float width, float height) {
    [[NativeDatePicker sharedInstance] setPosition: x y:y width:width height:height];
}

void _TAG_NativeDatePicker_popover(DateCallbackFunction callback) {
    __CSharp_Delegate = callback;
    [[NativeDatePicker sharedInstance] showPopoverDatePicker];
}

}
