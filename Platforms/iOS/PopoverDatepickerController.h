#import <UIKit/UIKit.h>
#include "DatepickerDelegate.h"

@interface PopoverDatepickerController : UIViewController {
    NSDate* fuckingDate;
    
    NSString* title;
    UILabel* titleLabel;
    UIDatePicker* datepicker;
    UIStackView* topBar;
    NSDate* lastSelectedDate;
}

@property(weak) id<DatePickerDelegate> callbackTarget;

@end
