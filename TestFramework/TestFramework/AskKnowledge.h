//
//  AskKnowledge.h
//  TestFramework
//
//  Created by 寒影 on 29/09/2017.
//  Copyright © 2017 xiaoi. All rights reserved.
//

#ifndef AskKnowledge_h
#define AskKnowledge_h

#endif /* AskKnowledge_h */


@protocol KBSDelegate <NSObject>

@optional
-(void)onReceiveData:(NSDictionary *)result;

@end

@interface AskKnowledge :NSObject<NSURLConnectionDelegate,NSURLConnectionDataDelegate>

@property (nonatomic, strong)NSString *url;

@property (nonatomic, weak) id <KBSDelegate> delegate;

-(void) ask:(NSString *)question;

@end
