#import "DatepickerBridge.h"
#import "NDPopoverDatepicker.h"
#import "DataConvert.h"

DateCallbackFunction __CSharp_Delegate = NULL;

@implementation NDDatepickerBridge
static NDDatepickerBridge* _instance;

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

+(NDDatepickerBridge*) sharedInstance
{
    static dispatch_once_t dispatchToken;

    dispatch_once(&dispatchToken, ^{
        NSLog(@"Creating native iOS singleton");

        _instance = [[NDDatepickerBridge alloc] init];
    });

    return _instance;
}

-(void) makeInline:(float) x y: (float) y width: (float) width height: (float) height
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

-(void) showPopover: (NSDate*) date
{
    if (self->popoverController == nil)
    {
        self->popoverController = [[NDPopoverDatepicker alloc] init];
        self->popoverController.callbackTarget = self;
    }
    
    [self->popoverController setDate:date];
    
    [self->popoverController present:UnityGetGLViewController()];
}

- (void) newDateAvailable:(NSDate*)date
{
    if (__CSharp_Delegate != NULL){
        __CSharp_Delegate((long)[date timeIntervalSince1970]);
    }
}

@end

extern "C"
{
void __ND__DatePicker_initialize(DateCallbackFunction callback){
    __CSharp_Delegate = callback;
    (void*) [NDDatepickerBridge sharedInstance];
}

void __ND__DatePicker_makeInline(float x_, float y_, float width_, float height_) {
    [[NDDatepickerBridge sharedInstance] makeInline: x_ y: y_ width: width_ height: height_];
}

void __ND__DatePicker_setPosition(float x, float y, float width, float height) {
    [[NDDatepickerBridge sharedInstance] setPosition: x y:y width:width height:height];
}

void __ND__DatePicker_popover(long dateUTC) {
    NSDate* date = dateUTC >= 0 ? [NSDate dateWithTimeIntervalSince1970:dateUTC] : [NSDate date];
    [[NDDatepickerBridge sharedInstance] showPopover: date];
}

}
