//
//  ViewController.m
//  TestFramework
//
//  Created by 寒影 on 20/09/2017.
//  Copyright © 2017 xiaoi. All rights reserved.
//

#import "ViewController.h"
#import <XiaoiKrypton/KryptonManager.h>
#import "AskKnowledge.h"
#import "Constants.h"

#import <QuartzCore/QuartzCore.h>

#import "ContentCell.h"
#import "Content.h"

@interface ViewController ()<KryptonDelegate,KBSDelegate,UITableViewDelegate,UITableViewDataSource,UITextViewDelegate>{
    
    AskKnowledge *ask;
    NSMutableArray *dataArray;
    NSMutableArray *heightArray;
    bool isRecording;
}


@property (weak, nonatomic) IBOutlet UITextField *text;
@property (weak, nonatomic) IBOutlet UIButton *button;
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *recordBtn;

@property (strong, nonatomic)  UILabel *defaultLable;

@property (strong, nonatomic)  UIView *defaultView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    ask = [[AskKnowledge alloc]init];
    ask.delegate = self;
    [KryptonManager share].url  = RECADDR;
    [KryptonManager share].appSecret = APPSECRET;
    [KryptonManager share].appKey = APPKEY;
    
    
    isRecording = false;
    
    _button.layer.cornerRadius = 5;
    _textView.layer.cornerRadius = 5;
    _recordBtn.layer.cornerRadius = 5;
    [KryptonManager share].delegate  = self;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _textView.delegate = self;
    
    self.view.backgroundColor = BACK_GRAY;
    _tableView.backgroundColor = BACK_GRAY;
    
    [_tableView setTableFooterView:[UIView new]];
    [_tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [_textView setFrame:CGRectMake(15, 35, WIDTH_SCREEN*0.65, 35)];
    
    [_button setFrame:CGRectMake(WIDTH_SCREEN * 0.65 + 30, 35, WIDTH_SCREEN*0.2, 35)];
    
    [_tableView setFrame:CGRectMake(15, 90, WIDTH_SCREEN-30, HEIGHT_SCREEN -160)];
    [_recordBtn setFrame:CGRectMake(15, HEIGHT_SCREEN  - 60, WIDTH_SCREEN-30, 40)];
    
    _recordBtn.layer.borderWidth = 1;
    _recordBtn.layer.borderColor = [LINE_GRAY CGColor];
    _recordBtn.tintColor = BUTTON_BLUE;
    
    
    
    _defaultLable = [[UILabel alloc]init];
    _defaultView = [[UIView alloc]init];
    
    dataArray = [[NSMutableArray alloc]init];
    
    _defaultLable.text = @"请输入搜索内容";
    _defaultLable.textColor = BUTTON_BLUE;
    
    _defaultLable.font = [UIFont systemFontOfSize:20];
    [_defaultView setFrame:CGRectMake(15, 90, WIDTH_SCREEN-30, HEIGHT_SCREEN -160)];
    
    _defaultView.layer.borderWidth = 1;
    _defaultView.layer.borderColor = [LINE_GRAY CGColor];
    _defaultView.backgroundColor = [UIColor whiteColor];
    
    
    [_defaultView addSubview:_defaultLable];
    
    
    [self.view addSubview:_defaultView];
    
    _defaultLable.translatesAutoresizingMaskIntoConstraints = NO;
    
    [NSLayoutConstraint constraintWithItem:_defaultLable
                                 attribute:NSLayoutAttributeCenterX
                                 relatedBy:NSLayoutRelationEqual
                                    toItem:_defaultView
                                 attribute:NSLayoutAttributeCenterX
                                multiplier:1.0
                                  constant:0.0].active = YES;
    
    [NSLayoutConstraint constraintWithItem:_defaultLable
                                 attribute:NSLayoutAttributeCenterY
                                 relatedBy:NSLayoutRelationEqual
                                    toItem:_defaultView
                                 attribute:NSLayoutAttributeCenterY
                                multiplier:1.0
                                  constant:0.0].active = YES;
    
    
    //    _tableView.estimatedRowHeight = 44.0;
    //    _tableView.rowHeight= UITableViewAutomaticDimension;
    
    _tableView.hidden = YES;
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}
- (IBAction)touchDown:(id)sender {
    
    //    [[KryptonManager share]stopRecord];
    //    [[KryptonManager share]startRecordWithWordset:nil withSentence:nil];
    
}
- (IBAction)touchUp:(id)sender {
    
    //    [self  performSelector:@selector(delayStopRecord) withObject:nil afterDelay:0.5f];
    if (isRecording){
        //结束录音
        [self stopRecord];
    }
    
    else {
        //开始录音
        [self startRecord];
    }
}


-(void)startRecord{
    
    isRecording = true;
    [_recordBtn setTitle:@"按一下结束录音" forState:UIControlStateNormal];
    _recordBtn.tintColor = [UIColor whiteColor];
    [_recordBtn setBackgroundColor:BUTTON_BLUE];
    [[KryptonManager share]stopRecord];
    [[KryptonManager share]startRecordWithWordset:nil withSentence:nil];
    
}


-(void)stopRecord{
    
    [self  performSelector:@selector(delayStopRecord) withObject:nil afterDelay:0.5f];
    
}


-(void)delayStopRecord {
    
    [[KryptonManager share]stopRecord];
    isRecording = false;
    [_recordBtn setTitle:@"按一下开始录音" forState:UIControlStateNormal];
    _recordBtn.tintColor = BUTTON_BLUE;
    [_recordBtn setBackgroundColor:[UIColor whiteColor]];
}


- (IBAction)request:(id)sender {
    
    [self stopRecord];
    
    NSString *question = _textView.text;
    
    
    question = [self handleString:question];
    [ask ask:question];
    
}

-(void)onReceiveLanguageModel:(NSMutableDictionary *)array{
    
    
    
}

-(void)onReceivePartialResult:(NSString *)result{
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        NSString *str = result;
        
        
        if (str.length > 15){
            
            str = [str substringWithRange:NSMakeRange(0, 15)];
            
        }
        
        [_textView setText:str];
        
    });
}

-(void)onReceiveFinalResult:(NSString *)result{
    
    result = [self handleString:result];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        NSString *str = result;
        
        
        if (str.length > 15){
            
            
            str = [str substringWithRange:NSMakeRange(0, 15)];
            
        }
        
        
        
        [_textView setText:str];
        
        [self stopRecord];
        
        
        NSString *question = _textView.text;
        
        
        question = [self handleString:question];
        [ask ask:question];
        
    });
    
}

-(void)onError:(NSString *)error{
    
    
}

-(void)onReceiveData:(NSDictionary *)result{
    
    
    
    if ([[result allKeys]containsObject:@"items"]){
        

        [dataArray removeAllObjects];
        
        
        for (NSDictionary *dic in [result objectForKey:@"items"]){
            
            Content *temp = [[Content alloc]init];
            
            NSString *question = [dic objectForKey:@"question"];
            NSString *answer = [dic objectForKey:@"answer"];
            NSString *object_name = [dic objectForKey:@"object_name"];
            NSString *bh_name = [dic objectForKey:@"bh_name"];
            
            
            
            if ([question containsString:@"<highlight>"]){
                
                question = [question stringByReplacingOccurrencesOfString:@"</highlight>" withString:@"</font>"];
                question = [question stringByReplacingOccurrencesOfString:@"<highlight>" withString:@"<font color='red'>"];
            }
            
            NSMutableAttributedString * questionStr = [[NSMutableAttributedString alloc] initWithData:[question dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType } documentAttributes:nil error:nil];
            
            [questionStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:17] range:NSMakeRange(0, questionStr.length)];
            
            if ([answer containsString:@"<highlight>"]){
                
                answer = [answer stringByReplacingOccurrencesOfString:@"</highlight>" withString:@"</font>"];
                answer = [answer stringByReplacingOccurrencesOfString:@"<highlight>" withString:@"<font color='red'>"];
            }
            
            NSMutableAttributedString * answerStr = [[NSMutableAttributedString alloc] initWithData:[answer dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType } documentAttributes:nil error:nil];
            
            [answerStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:16] range:NSMakeRange(0, answerStr.length)];
            
            NSMutableString *total = [NSMutableString stringWithFormat:@"%@>%@",object_name,bh_name];
            
            if ([total containsString:@"<highlight>"]){
                
                total = [total stringByReplacingOccurrencesOfString:@"</highlight>" withString:@""];
                total = [total stringByReplacingOccurrencesOfString:@"<highlight>" withString:@""];
            }
            
            NSMutableAttributedString *objectStr = [[NSMutableAttributedString alloc]initWithString:total];
            
            [objectStr addAttribute:NSForegroundColorAttributeName value:GREEN_COLOR range:NSMakeRange(0,objectStr.length)];
            
            
            temp.question = questionStr;
            temp.answer = answerStr;
            temp.object_name = objectStr;
            
            
            [dataArray addObject:temp];
            
        }
        
    }
    
    
    
    [_tableView reloadData];
    
    
    [self scrollToTop];
    
    
    if (dataArray != nil && [dataArray count] > 0){
        
        _defaultView.hidden = YES;
        _tableView.hidden = NO;
        
    }
    
    else {
        
        _defaultLable.text = @"搜索内容为空";
        _defaultView.hidden = NO;
        _tableView.hidden = YES;
        
    }
}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return  [dataArray count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    Content *message = [dataArray objectAtIndex:indexPath.row];
    
    ContentCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    if (cell == nil) {
        cell = [[ContentCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
    }
    
    
    [cell setMessage:message];
    
    
    return cell;
}




//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
//
//    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
//
//    if (cell == nil) {
//        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
//    }
//
//    if ([dataArray count] > indexPath.row){
//        NSDictionary *dic = [dataArray objectAtIndex:indexPath.row];
//        NSString *question = [dic objectForKey:@"question"] ;
//        NSString *answer = [dic objectForKey:@"answer"] ;
//        NSString *object_name = [dic objectForKey:@"object_name"] ;
//        NSString *bh_name = [dic objectForKey:@"bh_name"];
//
//        cell.backgroundColor = BACK_GRAY;
//
//        UILabel *questionLable = [[UILabel alloc]init];
//
//        if ([question containsString:@"<highlight>"]){
//
//
//            question = [question stringByReplacingOccurrencesOfString:@"</highlight>" withString:@"</font>"];
//            question = [question stringByReplacingOccurrencesOfString:@"<highlight>" withString:@"<font color='red'>"];
//        }
//
//        NSMutableAttributedString * questionStr = [[NSMutableAttributedString alloc] initWithData:[question dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType } documentAttributes:nil error:nil];
//
//
//        [questionStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:17] range:NSMakeRange(0, questionStr.length)];
//
//        questionLable.attributedText = questionStr;
//
//        questionLable.numberOfLines = 0;
//        CGSize questionSize = [questionLable sizeThatFits:CGSizeMake(WIDTH_SCREEN * 0.8, MAXFLOAT)];
//        [questionLable setFrame:CGRectMake(10, 15, questionSize.width, questionSize.height)];
//
//
//        UILabel *answerLable = [[UILabel alloc]init];
//        if ([answer containsString:@"<highlight>"]){
//
//            answer = [answer stringByReplacingOccurrencesOfString:@"</highlight>" withString:@"</font>"];
//            answer = [answer stringByReplacingOccurrencesOfString:@"<highlight>" withString:@"<font color='red'>"];
//        }
//
//        NSMutableAttributedString * answerStr = [[NSMutableAttributedString alloc] initWithData:[answer dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType } documentAttributes:nil error:nil];
//
//        [answerStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:16] range:NSMakeRange(0, answerStr.length)];
//
//        answerLable.attributedText = answerStr;
//
//
//        answerLable.numberOfLines = 0;
//        CGSize answerSize = [answerLable sizeThatFits:CGSizeMake(WIDTH_SCREEN * 0.8, MAXFLOAT)];
//        [answerLable setFrame:CGRectMake(10, questionSize.height + 25, answerSize.width, answerSize.height)];
//
//        UILabel *objectLable = [[UILabel alloc]init];
//
//        NSMutableString *total = [NSMutableString stringWithFormat:@"%@>%@",object_name,bh_name];
//
//        if ([total containsString:@"<highlight>"]){
//
//            total = [total stringByReplacingOccurrencesOfString:@"</highlight>" withString:@""];
//            total = [total stringByReplacingOccurrencesOfString:@"<highlight>" withString:@""];
//        }
//
//        NSMutableAttributedString *objectStr = [[NSMutableAttributedString alloc]initWithString:total];
//
//        [objectStr addAttribute:NSForegroundColorAttributeName value:GREEN_COLOR range:NSMakeRange(0,objectStr.length)];
//        objectLable.attributedText = objectStr;
//
//        objectLable.numberOfLines = 0;
//        CGSize objectSize = [objectLable sizeThatFits:CGSizeMake(WIDTH_SCREEN * 0.8, MAXFLOAT)];
//
//        [objectLable setFrame:CGRectMake(10, questionSize.height + 30 + answerSize.height, objectSize.width, objectSize.height)];
//
//        CGFloat height = questionSize.height + answerSize.height + objectSize.height + 45;
//
//        UIView *background = [[UIView alloc]init];
//
//        background.layer.borderWidth = 2;
//
//        background.layer.borderColor = [LINE_GRAY CGColor];
//        background.backgroundColor = [UIColor whiteColor];
//
//        [cell addSubview:background];
//        [background addSubview:questionLable];
//        [background addSubview:answerLable];
//        [background addSubview:objectLable];
//
//        HeightStruct h;
//        h.height = height+5;
//
//        NSValue *value = nil;
//        value = [NSValue valueWithBytes:&h objCType:@encode(HeightStruct)];
//
//        [heightArray addObject:value];
////        [heightArray insertObject:value atIndex:indexPath.row];
//
//        [background setFrame:CGRectMake(0, 0, WIDTH_SCREEN*0.87, height)];
//        cell.selectionStyle = UITableViewCellSelectionStyleNone;
//    }
//
//    return  cell;
//
//}




-(BOOL)textView:(UITextView *)input shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    
    if ([text isEqualToString:@"\n"]) {
        [input resignFirstResponder];
        return NO;
    }
    return YES;
}


- (void)textViewDidChange:(UITextView *)textView{
    
    if ([textView.text length] > 15) {
        textView.text = [textView.text substringWithRange:NSMakeRange(0, 15)];
        [textView.undoManager removeAllActions];
        [textView becomeFirstResponder];
        return;
    }
}


//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
//
//    if ([heightArray count] > indexPath.row){
//
//        NSValue *value  = [heightArray objectAtIndex:indexPath.row];
//        HeightStruct h ;
//        [value getValue:&h];
//        return h.height;
//    }
//
//    return  0;
//}



- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    Content *cell = [dataArray objectAtIndex:indexPath.row];
    return cell.cellHeight;
    
    
    
}



-(NSString *)handleString :(NSString *)str {
    
    str = [str stringByReplacingOccurrencesOfString:@"，" withString:@""];
    str = [str stringByReplacingOccurrencesOfString:@"。" withString:@""];
    str = [str stringByReplacingOccurrencesOfString:@"？" withString:@""];
    str = [str stringByReplacingOccurrencesOfString:@"！" withString:@""];
    
    str = [str stringByReplacingOccurrencesOfString:@"," withString:@""];
    str = [str stringByReplacingOccurrencesOfString:@"." withString:@""];
    str = [str stringByReplacingOccurrencesOfString:@"?" withString:@""];
    str = [str stringByReplacingOccurrencesOfString:@"!" withString:@""];
    str = [str stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    return  str;
    
}


- (void) scrollToTop
{
    if (dataArray.count > 2) {
        [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
    }
}

@end
























