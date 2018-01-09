//
//  Content.m
//  TestFramework
//
//  Created by 寒影 on 16/10/2017.
//  Copyright © 2017 xiaoi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Content.h"

#import "Constants.h"

static UILabel *label = nil;

@implementation Content


- (id) init
{
    if (self = [super init]) {
        if (label == nil) {
            label = [[UILabel alloc] init];
            [label setNumberOfLines:0];
            
        }
    }
    return self;
}


-(CGSize)answerSize{

    [label setAttributedText:_answer];
    return [label sizeThatFits:CGSizeMake(WIDTH_SCREEN * 0.8, MAXFLOAT)];

}


-(CGSize)questionSize{
    
    [label setAttributedText:_question];
    return [label sizeThatFits:CGSizeMake(WIDTH_SCREEN * 0.8, MAXFLOAT)];
    
}

-(CGSize)objectSize{
    
    [label setAttributedText:_object_name];
    return [label sizeThatFits:CGSizeMake(WIDTH_SCREEN * 0.8, MAXFLOAT)];
    
}

-(CGFloat)cellHeight{
    return self.questionSize.height + self.answerSize.height + self.objectSize.height + 50;
    
    
}


@end
