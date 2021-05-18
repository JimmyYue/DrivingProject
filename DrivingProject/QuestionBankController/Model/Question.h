//
//  Question.h
//  Driving
//
//  Created by JimmyYue on 2021/2/22.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Question : NSObject

@property (nonatomic, strong) NSString *question;  // 题目
@property (nonatomic, strong) NSString *answer;  // 答案
@property (nonatomic, strong) NSString *option_a;  // A
@property (nonatomic, strong) NSString *option_b;  // B
@property (nonatomic, strong) NSString *option_c;  // C
@property (nonatomic, strong) NSString *option_d;  // D
@property (nonatomic, strong) NSString *option_e;  // E
@property (nonatomic, strong) NSString *option_f;  // F
@property (nonatomic, strong) NSString *explain;  // 解释
@property (nonatomic, strong) NSString *option_type;  // 类型 0判断1单选2多选
@property (nonatomic, strong) NSString *media_url; // 图片
@property (nonatomic, assign) NSInteger index;  // 当前页数
@property (nonatomic, assign) NSInteger topicType;  //  答题模式1 背题模式2
@property (nonatomic, assign) BOOL correct;  // 选择是否正确
@property (nonatomic, strong) NSDictionary *choose;  // 选择项
@property (nonatomic, assign) BOOL state;  // 是否选择答题 已选择(YES)
@property (nonatomic, strong) NSMutableArray *chooseArray;  // 选择的答案
@property (nonatomic, strong) NSArray *answerS;  // 正确答案
@end

NS_ASSUME_NONNULL_END
