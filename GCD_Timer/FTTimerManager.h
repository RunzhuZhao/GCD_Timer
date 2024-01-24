//
//  FTTimerManager.h
//  GCD_Semaphore
//
//  Created by Run on 2024/1/24.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface FTTimerManager : NSObject

+ (instancetype)sharedManager;

//添加定时器
- (void)addTimerWithName:(NSString *)timerName timeInterval:(NSTimeInterval)timeInterval repeats:(BOOL)repeats executeQueue:(dispatch_queue_t)executeQueue eventBlock:(dispatch_block_t)eventBlock;

//取消定时器
- (void)cancelTimerWithName:(NSString *)timerName;

@end

NS_ASSUME_NONNULL_END
