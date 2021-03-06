#import "NDPopoverDatepicker.h"
#import "DatepickerDelegate.h"

@implementation NDPopoverDatepicker

NSString * defaultTitle = @"Select date for data";


-(id) init
{
    self = [super init];
    self->title = defaultTitle;
    [self initHelper];
    
    return self;
}

-(id) initWithTitle:(NSString*) title_
{
    self = [super init];
    self->title = title_;
    [self initHelper];
    
    return self;
}

-(void) initHelper
{
    self.modalPresentationStyle = UIModalPresentationPopover;
    self.preferredContentSize = CGSizeMake(500, 500);
    // Turns off all arrows
    self.popoverPresentationController.permittedArrowDirections = 0;
    
    if (@available(iOS 13.0, *)) {
        self.view.backgroundColor = [UIColor systemBackgroundColor];
    }
    else {
        self.view.backgroundColor = [UIColor whiteColor];
    }
    
    topBar = [[UIStackView alloc] init];
    topBar.axis = UILayoutConstraintAxisHorizontal;
    topBar.distribution = UIStackViewDistributionEqualSpacing;
    topBar.alignment = UIStackViewAlignmentCenter;
    [topBar setLayoutMarginsRelativeArrangement:YES];
    [topBar setLayoutMargins: UIEdgeInsetsMake(10, 20, 10, 20)];
    
    UIButton* cancelBtn = [UIButton buttonWithType: UIButtonTypeSystem];
    [cancelBtn addTarget:self action:@selector(onTapCancel:) forControlEvents: UIControlEventTouchUpInside];
    [cancelBtn setTitle:@"Cancel" forState:UIControlStateNormal];
    
    titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    titleLabel.textColor = [UIColor systemBlueColor];
    titleLabel.alpha = 1.0f;
    titleLabel.text = title;
    titleLabel.numberOfLines = 1;
    titleLabel.textAlignment = NSTextAlignmentLeft;
    titleLabel.minimumScaleFactor = 10.0f/12.0f;
    titleLabel.clipsToBounds = YES;
    titleLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleHeadline];
    
    UIButton* doneBtn = [UIButton buttonWithType: UIButtonTypeSystem];
    [doneBtn addTarget:self action:@selector(onTapDone:) forControlEvents: UIControlEventTouchUpInside];
    [doneBtn setTitle:@"Set" forState:UIControlStateNormal];
    
    [topBar addArrangedSubview:cancelBtn];
    [topBar addArrangedSubview:titleLabel];
    [topBar addArrangedSubview:doneBtn];
    topBar.backgroundColor = [UIColor redColor];
    
    datepicker = [[UIDatePicker alloc] initWithFrame:CGRectZero];
    datepicker.datePickerMode = UIDatePickerModeDate;
    
    // Apparently we need to set the wheels style first and THEN change the color.
    // Otherwise the color change will be overriden on platforms that support preferedDatePickerStyle
    if (@available(iOS 13.4, *)) {
        datepicker.preferredDatePickerStyle = UIDatePickerStyleWheels;
    }
    
    if (@available(iOS 13.0, *)) {
        [datepicker setValue:[UIColor labelColor] forKeyPath:@"textColor"];
    }
    
    [datepicker setValue:[NSNumber numberWithBool:YES] forKeyPath:@"highlightsToday"];
    
    [datepicker addTarget:self action:@selector(dateChanged:)
         forControlEvents:UIControlEventValueChanged];
    
    [self.view addSubview:topBar];
    [self.view addSubview:datepicker];
    
    self.presentationController.delegate = self;
    
    dirty = NO;
}

- (void) presentationControllerDidDismiss: (UIPresentationController*) controller
{
    if (self->dirty)
    {
        [self notifyDelegate];
    }
}

- (void) notifyDelegate
{
    if (self.callbackTarget != nil && [self.callbackTarget conformsToProtocol:@protocol(NDDatepickerDelegate)])
    {
        [self.callbackTarget newDateAvailable:self.date];
    }
}

-(void) viewWillLayoutSubviews
{
    auto f = self.view.frame;
    
    CGRect labelSize = [title boundingRectWithSize:CGSizeMake(500, 20)
                                           options:NSStringDrawingUsesLineFragmentOrigin| NSStringDrawingUsesFontLeading
                                        attributes:@{NSFontAttributeName:titleLabel.font}
                                           context:nil];
    auto topBarHeight = MAX(labelSize.size.height + 20, 75);
    topBar.frame = CGRectMake(0, 0, f.size.width, topBarHeight);
    
//    titleLabel.frame = CGRectMake(0, 0, labelSize.size.width, labelSize.size.height);
    
    auto centeredY = (f.size.height / 2) - 100;
    
    auto actualY = (topBar.frame.size.height > centeredY) ? topBar.frame.size.height : centeredY;
    
    datepicker.frame = CGRectMake(0, actualY, f.size.width, 200);
}

-(void)onTapDone:(UIBarButtonItem*)item{
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
    if (self->dirty)
        [self notifyDelegate];
}

-(void)onTapCancel:(UIBarButtonItem*)item{
    [self dismissViewControllerAnimated:true completion:nil];
}

-(void) dateChanged:(UIDatePicker*) picker
{
    self->dirty = YES;
    self.date = picker.date;
}

- (void) selectDate:(NSDate *)date
{
    self.date = date;
    if (self->datepicker != nil)
        self->datepicker.date = date;
}

- (void) present:(UIViewController*) controller
{
    
    if (self.isBeingPresented)
        return;
    
    auto frame = controller.view.frame;
    
    self->dirty = NO;
    
    self.popoverPresentationController.permittedArrowDirections = 0;
    self.popoverPresentationController.sourceView = controller.view;
    self.popoverPresentationController.sourceRect = CGRectMake(frame.size.width / 2, frame.size.height /2 , 0, 0);
    [controller presentViewController:self animated:YES completion:nil];
}
@end
