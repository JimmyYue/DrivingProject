//
//  MyTopView.h
//  Driving
//
//  Created by JimmyYue on 2021/2/22.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MyTopView : UIView

@property (strong, nonatomic) IBOutlet UILabel *versionLabel;

@property (strong, nonatomic) IBOutlet UIButton *clearBtn;

@property (strong, nonatomic) IBOutlet UIButton *agreementBtn;

@property (strong, nonatomic) IBOutlet UIButton *policyBtn;


@end

NS_ASSUME_NONNULL_END
