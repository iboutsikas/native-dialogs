#import <Foundation/Foundation.h>

@protocol DatePickerDelegate <NSObject>
- (void)newDateAvailable:(NSDate*) date;
@end
