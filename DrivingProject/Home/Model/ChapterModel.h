//
//  ChapterModel.h
//  DrivingProject
//
//  Created by JimmyYue on 2021/2/25.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ChapterModel : NSObject

@property (nonatomic, strong) NSString *title;  // 题目
@property (nonatomic, strong) NSString *chapter_id;  // id
@property (nonatomic, strong) NSString *count;  // 题数
@end

NS_ASSUME_NONNULL_END
