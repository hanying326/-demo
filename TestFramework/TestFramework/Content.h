//
//  Content.h
//  TestFramework
//
//  Created by 寒影 on 16/10/2017.
//  Copyright © 2017 xiaoi. All rights reserved.
//

#ifndef Content_h
#define Content_h


#endif /* Content_h */

#import <UIKit/UIKit.h>

@interface Content : NSObject


@property (nonatomic, strong) NSMutableAttributedString *question;
@property (nonatomic, strong) NSMutableAttributedString *answer;
@property (nonatomic, strong) NSMutableAttributedString *object_name;
@property (nonatomic, strong) NSMutableAttributedString *bh_name;

@property (nonatomic, assign) CGFloat cellHeight;


@property (nonatomic, assign) CGSize answerSize;
@property (nonatomic, assign) CGSize questionSize;
@property (nonatomic, assign) CGSize objectSize;



@end
