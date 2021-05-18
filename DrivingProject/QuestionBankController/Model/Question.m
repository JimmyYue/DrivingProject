//
//  Question.m
//  Driving
//
//  Created by JimmyYue on 2021/2/22.
//

#import "Question.h"

@implementation Question
- (void)setValue:(id)value forUndefinedKey:(NSString *)key{
    if ([key isEqualToString:@"question"]){
        self.question = value;
    }
    if ([key isEqualToString:@"answer"]){
        self.answer = value;
    }
    if ([key isEqualToString:@"option_a"]){
        self.option_a = value;
    }
    if ([key isEqualToString:@"option_b"]){
        self.option_b = value;
    }
    if ([key isEqualToString:@"option_c"]){
        self.option_c = value;
    }
    if ([key isEqualToString:@"option_d"]){
        self.option_d = value;
    }
    if ([key isEqualToString:@"option_e"]){
        self.option_e = value;
    }
    if ([key isEqualToString:@"option_f"]){
        self.option_f = value;
    }
    if ([key isEqualToString:@"explain"]){
        self.explain = value;
    }
    if ([key isEqualToString:@"option_type"]){
        self.option_type = value;
    }
    if ([key isEqualToString:@"media_url"]){
        self.media_url = value;
    }
    
}
@end
