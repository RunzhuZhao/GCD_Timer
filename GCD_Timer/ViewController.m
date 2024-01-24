//
//  ViewController.m
//  GCD_Semaphore
//
//  Created by Run on 2024/1/24.
//

#import "ViewController.h"
#import "FTTimerManager.h"

static NSString *const kViewControllerTimer = @"kViewControllerTimer";

@interface ViewController ()

@property (nonatomic, strong) dispatch_semaphore_t semaphore;
@property (nonatomic, strong) UILabel *showLabel;
@property (nonatomic, strong) dispatch_source_t timer;
@property (nonatomic, assign) NSInteger remainTime;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.showLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 30)];
    self.showLabel.textColor = [[UIColor redColor] colorWithAlphaComponent:0.6];
    self.showLabel.center = CGPointMake(self.view.center.x, self.view.center.y-100);
    self.showLabel.text = @"显示倒计时";
    [self.view addSubview:self.showLabel];
    
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 130, 40)];
    button.layer.cornerRadius = 12;
    button.clipsToBounds = YES;
    button.backgroundColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.2];
    [button setTitle:@"开启倒计时" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    button.center = CGPointMake(self.view.center.x-85, self.view.center.y);
    [button addTarget:self action:@selector(testAddTimer) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    
    UIButton *button2 = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 130, 40)];
    button2.layer.cornerRadius = 12;
    button2.clipsToBounds = YES;
    button2.backgroundColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.2];
    
    [button2 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    button2.center = CGPointMake(self.view.center.x + 85, self.view.center.y);
    [button2 setTitle:@"取消倒计时" forState:UIControlStateNormal];
    [button2 addTarget:self action:@selector(cancelTimer) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button2];
    
    
    
}

- (void)testAddTimer {
    self.remainTime = 60;
    [[FTTimerManager sharedManager] addTimerWithName:kViewControllerTimer timeInterval:2 repeats:YES executeQueue:dispatch_get_main_queue() eventBlock:^{
        self.remainTime--;
        if (self.remainTime == 0) {
            [self cancelTimer];
        } else {
            self.showLabel.text = [NSString stringWithFormat:@"倒计时：%lds", self.remainTime];
        }
    }];
}

- (void)cancelTimer {
    [[FTTimerManager sharedManager] cancelTimerWithName:kViewControllerTimer];
    self.showLabel.text = @"倒计时结束";
    
}

@end
