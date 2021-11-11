#import <Foundation/Foundation.h>
#import "NDPopoverDatepicker.h"
#import "DatepickerDelegate.h"

@interface NDDatepickerBridge: NSObject <NDDatepickerDelegate>
{
    UIDatePicker* datePicker;
    NDPopoverDatepicker* popoverController;
}

+(NDDatepickerBridge*) sharedInstance;

-(void) makeInline:(float) x y: (float) y width: (float) width height: (float) height;
-(void) setPosition:(float) x y: (float) y width: (float) width height: (float) height;
-(void) showPopover:(NSDate*)date;
-(void) newDateAvailable:(NSString*)date;
@end
typedef void (*DateCallbackFunction)(long dateUTC);
