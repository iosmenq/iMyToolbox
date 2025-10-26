#import <UIKit/UIKit.h>
@interface ViewController : UIViewController
@property (strong, nonatomic) UIScrollView *scrollView;
@property (strong, nonatomic) UIView *contentView;
@property (strong, nonatomic) UISegmentedControl *themeControl;
@property (strong, nonatomic) UITextView *outputTextView;
@property (strong, nonatomic) NSUserDefaults *defaults;
@property (assign, nonatomic) BOOL isDarkMode;
@property (assign, nonatomic) NSInteger gameScore;
@property (strong, nonatomic) UILabel *scoreLabel;
@end