#import <Foundation/Foundation.h>

@protocol NDDatepickerDelegate <NSObject>
- (void)newDateAvailable:(NSDate*) date;
@end
