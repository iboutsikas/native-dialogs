#import "NDPopoverDatepicker.h"
#import "DatepickerDelegate.h"

@implementation NDPopoverDatepicker

NSString * defaultTitle = @"Select date for data";


-(id) init
{
    self = [super init];
    title = defaultTitle;
    lastSelectedDate = nil;
    [self initHelper];
    
    return self;
}

-(id) initWithTitle:(NSString*) title_
{
    self = [super init];
    title = title_;
    [self initHelper];
    
    return self;
}

-(void) initHelper
{
    self.modalPresentationStyle = UIModalPresentationPopover;
    self.preferredContentSize = CGSizeMake(500, 500);
    // Turns off all arrows
    self.popoverPresentationController.permittedArrowDirections = 0;
    
    self.view.backgroundColor = [UIColor whiteColor];
    
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
    
    datepicker = [[UIDatePicker alloc] initWithFrame:CGRectZero];
    datepicker.datePickerMode = UIDatePickerModeDate;
    if (@available(iOS 13.4, *)) {
        datepicker.preferredDatePickerStyle = UIDatePickerStyleWheels;
    }
    
    [datepicker addTarget:self action:@selector(dateChanged:)
         forControlEvents:UIControlEventValueChanged];
    
    [self.view addSubview:topBar];
    [self.view addSubview:datepicker];
}

-(void) viewWillLayoutSubviews
{
    auto f = self.view.frame;
    
    CGRect labelSize = [title boundingRectWithSize:CGSizeMake(500, 20)
                                           options:NSStringDrawingUsesLineFragmentOrigin| NSStringDrawingUsesFontLeading
                                        attributes:@{NSFontAttributeName:titleLabel.font}
                                           context:nil];
    topBar.frame = CGRectMake(0, 0, f.size.width, labelSize.size.height + 20);
    
    titleLabel.frame = CGRectMake(0, 0, labelSize.size.width, labelSize.size.height);
    
    datepicker.frame = CGRectMake(0, (f.size.height / 2) - 100, f.size.width, 200);
}

-(void)onTapDone:(UIBarButtonItem*)item{
    [self dismissViewControllerAnimated:YES completion:nil];
    
    if (self.callbackTarget != nil && [self.callbackTarget conformsToProtocol:@protocol(NDDatepickerDelegate)])
    {
        [self.callbackTarget newDateAvailable:self.date];
    }
}

-(void)onTapCancel:(UIBarButtonItem*)item{
    [self dismissViewControllerAnimated:true completion:nil];
}

-(void) dateChanged:(UIDatePicker*) picker
{
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
    auto frame = controller.view.frame;
    
    self.popoverPresentationController.sourceView = controller.view;
    self.popoverPresentationController.sourceRect = CGRectMake(frame.size.width / 2, frame.size.height /2 , 0, 0);
    [controller presentViewController:self animated:YES completion:nil];
}
@end
