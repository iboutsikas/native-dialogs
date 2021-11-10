#import <Foundation/Foundation.h>
#import "PopoverDatepickerController.h"
#import "DatepickerDelegate.h"

@interface NativeDatePicker: NSObject <DatePickerDelegate>
{
    UIDatePicker* datePicker;
    PopoverDatepickerController* popoverController;
}

+(NativeDatePicker*) sharedInstance;

-(NSString*) getGreeting;
-(void) initializeDatePicker:(float) x y: (float) y width: (float) width height: (float) height;
-(void) setPosition:(float) x y: (float) y width: (float) width height: (float) height;
-(void) showPopoverDatePicker;
-(void) newDateAvailable:(NSString*)date;
@end
typedef void (*DateCallbackFunction)(char* dateString);
