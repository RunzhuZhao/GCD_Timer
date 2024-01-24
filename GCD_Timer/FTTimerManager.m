//
//  FTTimerManager.m
//  GCD_Semaphore
//
//  Created by Run on 2024/1/24.
//

#import "FTTimerManager.h"

@interface FTTimerManager ()<NSCopying, NSMutableCopying>

@property (nonatomic, strong) dispatch_semaphore_t semaphore;
@property (nonatomic, strong) NSMutableDictionary<NSString *, dispatch_source_t> *timerDict;

@end

@implementation FTTimerManager

+ (instancetype)sharedManager {
    static FTTimerManager *instance;
    static dispatch_once_t onceToken;
    _dispatch_once(&onceToken, ^{
        instance = [[super allocWithZone:NULL] init];
        instance.timerDict = [NSMutableDictionary dictionary];
        instance.semaphore = dispatch_semaphore_create(1);
    });
    return instance;
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    return [FTTimerManager sharedManager];
}

- (id)mutableCopyWithZone:(NSZone *)zone {
    return self;
}

- (id)copyWithZone:(NSZone *)zone {
    return self;
}

#pragma mark - Public Methods

- (void)addTimerWithName:(NSString *)timerName timeInterval:(NSTimeInterval)timeInterval repeats:(BOOL)repeats executeQueue:(dispatch_queue_t)executeQueue eventBlock:(dispatch_block_t)eventBlock {
    if (timerName.length == 0) {
        return;
    }
    dispatch_queue_t targetQueue = executeQueue;
    if (!targetQueue) {
        targetQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    }
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    dispatch_source_t timer = self.timerDict[timerName];
    if (timer) {
        //把同名存在的定时器取消
        dispatch_source_cancel(timer);
        timer = nil;
    }
    if (!timer) {
        timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, targetQueue);
        self.timerDict[timerName] = timer;
    }
    dispatch_semaphore_signal(self.semaphore);
    /* 设置定时器参数
     * 参数2：开始时间
     * 参数3：定时器间隔时间
     * 参数4：允许误差时间
     */
    dispatch_source_set_timer(timer, DISPATCH_TIME_NOW, timeInterval * NSEC_PER_SEC, 0.1*NSEC_PER_SEC);
    //__typeof(self)获取类型
    __weak __typeof(self) weakSelf = self;
    //block中执行定时处理的事件
    dispatch_source_set_event_handler(timer, ^{
        __strong __typeof(weakSelf) strongSelf = weakSelf;
        if (eventBlock) {
            eventBlock();
        }
        if (!repeats) {
            //不重复执行，取消定时器
            [strongSelf cancelTimerWithName:timerName];
        }
    });
    //开启定时器
    dispatch_resume(timer);
}

//取消定时器
- (void)cancelTimerWithName:(NSString *)timerName {
    if (timerName.length == 0) {
        return;
    }
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    dispatch_source_t timer = self.timerDict[timerName];
    if (timer) {
        [self.timerDict removeObjectForKey:timerName];
    }
    dispatch_semaphore_signal(self.semaphore);
    if (timer) {
        dispatch_source_cancel(timer);
    }
}

@end
