//
//  ContentCell.m
//  TestFramework
//
//  Created by 寒影 on 16/10/2017.
//  Copyright © 2017 xiaoi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ContentCell.h"

#import "Constants.h"


@implementation ContentCell


- (void) setMessage:(Content *)message{
    
    
    
     self.backgroundColor = BACK_GRAY;
    
    
    NSMutableAttributedString *question = message.question;
    NSMutableAttributedString *answer = message.answer;
    NSMutableAttributedString *object_name = message.object_name;
    
    
    
    
    UILabel *questionLable = [[UILabel alloc]init];
    
    
    
    questionLable.attributedText = question;
    
    questionLable.numberOfLines = 0;
    
    [questionLable setFrame:CGRectMake(10, 15, message.questionSize.width, message.questionSize.height)];
    
    
    UILabel *answerLable = [[UILabel alloc]init];
    
    
    answerLable.attributedText = answer;
    
    
    answerLable.numberOfLines = 0;
    
    [answerLable setFrame:CGRectMake(10, message.questionSize.height + 25, message.answerSize.width, message.answerSize.height)];
    
    UILabel *objectLable = [[UILabel alloc]init];
    
    
    objectLable.attributedText = object_name;
    
    objectLable.numberOfLines = 0;
    
    
    [objectLable setFrame:CGRectMake(10, message.questionSize.height + 30 + message.answerSize.height, message.objectSize.width, message.objectSize.height)];
    
    
    
    UIView *background = [[UIView alloc]init];
    
    background.layer.borderWidth = 2;
    
    background.layer.borderColor = [LINE_GRAY CGColor];
    background.backgroundColor = [UIColor whiteColor];
    
    [background setFrame:CGRectMake(0, 0, WIDTH_SCREEN*0.87, message.cellHeight-5)];
    [self addSubview:background];
    
    
    
    [background addSubview:questionLable];
    [background addSubview:answerLable];
    [background addSubview:objectLable];
    
}



@end


































