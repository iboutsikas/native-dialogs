#import <UIKit/UIKit.h>
#include "DatepickerDelegate.h"

@interface NDPopoverDatepicker : UIViewController <UIAdaptivePresentationControllerDelegate> {
    NSString* title;
    UILabel* titleLabel;
    UIDatePicker* datepicker;
    UIStackView* topBar;
    BOOL dirty;
}
@property() NSDate* date;
@property(weak) id<NDDatepickerDelegate> callbackTarget;

- (void) selectDate:(NSDate *)date;
- (void) present:(UIViewController*) controller;
@end
