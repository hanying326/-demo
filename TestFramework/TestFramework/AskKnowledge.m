//
//  AskKnowledge.m
//  TestFramework
//
//  Created by 寒影 on 29/09/2017.
//  Copyright © 2017 xiaoi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AskKnowledge.h"
#import "Constants.h"


@interface AskKnowledge()
{
    
    NSInteger dataCount;
}


@property (nonatomic, strong) NSMutableData *data;

@end

@implementation AskKnowledge

-(void) ask:(NSString *)question{
    
    _data = [[NSMutableData alloc]init];
    
    NSURLCache *URLCache = [[NSURLCache alloc] initWithMemoryCapacity:4 * 1024 * 1024 diskCapacity:0 diskPath:nil];
    [NSURLCache setSharedURLCache:URLCache];
    
    NSString *urlStr = [NSString stringWithFormat:ASKADDR,question];

    urlStr = [urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *url = [NSURL URLWithString:urlStr];
    
    NSMutableURLRequest * request = [NSMutableURLRequest requestWithURL:url];
    
    [request setCachePolicy:NSURLRequestUseProtocolCachePolicy];
    
    NSURLConnection *connection  = [[NSURLConnection alloc]initWithRequest:request delegate:self];
    
    [connection start];
    
    
}


-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data{
    
    
    
    [_data appendData:data];
    
//    NSString *result = [[NSString alloc] initWithData:_data  encoding:NSUTF8StringEncoding];
    
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:_data
                                                        options:NSJSONReadingMutableContainers
                                                          error:&err];
    
    
    if (dic != nil){
         [[self delegate]onReceiveData:dic];
    }
}


- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response{
    
    
    
}


- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error{
    
}

-(NSString *)returnFormatString:(NSString *)str
{
    
    return [str stringByReplacingOccurrencesOfString:@" " withString:@" "];
    
}


-(void)onReceiveData:(NSDictionary *)result{
    
}

@end

































