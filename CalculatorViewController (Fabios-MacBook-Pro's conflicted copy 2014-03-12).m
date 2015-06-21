//
//  CalculatorViewController.m
//  Split The Bill
//
//  Created by Fábio Gelbcke Work on 5/3/13.
//  Copyright (c) 2013 Fábio Gelbcke Work. All rights reserved.
//

#import "CalculatorViewController.h"
#import "CalculatorBrain.h"

@interface CalculatorViewController ()
@property (nonatomic) BOOL enteredSomeNumber;
@property (nonatomic) BOOL userPressedEnter;
@property (nonatomic) BOOL alreadyUsedDot;
@property (strong, nonatomic) IBOutlet UIImageView *visor;
@property (nonatomic,strong) CalculatorBrain *brain;
@property(nonatomic,strong) NSNumber *finalResult;
@end

@implementation CalculatorViewController{
     NSString *operation;
}


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated{
    _displayOperation.adjustsFontSizeToFitWidth=YES;
    _displayOperation.minimumScaleFactor=0.5;
    [self.view bringSubviewToFront:self.display];
    [self.view bringSubviewToFront:self.displayOperation];
  
    
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    [numberFormatter setNumberStyle: NSNumberFormatterDecimalStyle];
	// Do any additional setup after loading the view.
}



-(CalculatorBrain *)brain{
    if(!_brain) _brain=[[CalculatorBrain alloc] init];
    return _brain;
}

-(NSNumber *)finalResult{
    if(!_finalResult)_finalResult=[[NSNumber alloc]init];
    return _finalResult;
}
- (IBAction)digitPressed:(UIButton*)sender {
   
        if(_userPressedEnter && [[self.brain operandStack] count]==1) [self clearPressed];
        _userPressedEnter=NO;
        
        NSString * myDigit = [sender currentTitle];
        
        if(self.enteredSomeNumber && self.display.text.length<9){
            if ([myDigit isEqualToString:@"."]&& !self.alreadyUsedDot){
                self.display.text=[self.display.text stringByAppendingString:myDigit];
                NSLog(@"!");
                self.displayOperation.text = [self.displayOperation.text stringByAppendingString:@"."];
                self.alreadyUsedDot=YES;
            }
            else if ([myDigit isEqualToString:@"."]);
            else self.display.text=[self.display.text stringByAppendingString:myDigit];
        }
        else if ([myDigit isEqualToString:@"." ]&& [self.display.text isEqualToString:@"0"] && !self.alreadyUsedDot){
            self.display.text = @"0.";
            self.enteredSomeNumber=YES;
            self.alreadyUsedDot=YES;
        }
        else if ([myDigit isEqualToString:@"00" ] || [myDigit isEqualToString:@"0"])self.display.text = @"0";
        else if (self.display.text.length==9 && !self.enteredSomeNumber){
            self.display.text = myDigit;
            self.enteredSomeNumber = YES;
        }
        else if (self.display.text.length != 9){
            self.display.text = myDigit;
            self.enteredSomeNumber = YES;
        }

        //FIX FOR 00 AND 0
        if ([myDigit isEqualToString:@"." ]&& [self.displayOperation.text isEqualToString:@"0"]){
        self.displayOperation.text = @"0.";
        }
        else if ([myDigit isEqualToString:@"."] && self.alreadyUsedDot==YES);
        else if (!self.enteredSomeNumber && [[self.displayOperation.text substringFromIndex:self.displayOperation.text.length-1] isEqualToString:@"0"]){
            if ([myDigit isEqualToString:@"0"]);
            else if ([myDigit isEqualToString:@"00"]);
            //!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
            else{
                self.displayOperation.text=[[self.displayOperation.text substringToIndex:self.displayOperation.text.length-2] stringByAppendingString:myDigit];
            }
        }
        
        else if ([self.displayOperation.text isEqualToString:@"0"]) self.displayOperation.text = myDigit;
    
        //else if ([myDigit isEqualToString:@"0"] && !self.enteredSomeNumber);
        else if ([myDigit isEqualToString:@"00"] && !self.enteredSomeNumber) self.displayOperation.text = [self.displayOperation.text stringByAppendingString:@"0"];
        else if (self.display.text.length<9)self.displayOperation.text = [self.displayOperation.text stringByAppendingString:myDigit];
    
    

}


- (IBAction)operationPressed:(UIButton*)sender {
    if ([[self.display.text substringFromIndex:self.display.text.length-1] isEqualToString:@"."]) self.display.text = [self.display.text stringByAppendingString:@"0"];
    
    if (self.enteredSomeNumber || self.userPressedEnter){
        if ([[sender currentTitle] isEqualToString:@"*"]|| [[sender currentTitle] isEqualToString:@"/"]){
            self.displayOperation.text = [self.displayOperation.text stringByAppendingString:@")"];
            self.displayOperation.text = [@"("stringByAppendingString:self.displayOperation.text];
        }
        self.displayOperation.text= [self.displayOperation.text stringByAppendingString:[sender currentTitle]];
    }
    else if(!self.enteredSomeNumber && !self.userPressedEnter){
        self.displayOperation.text = [self.displayOperation.text substringToIndex:self.displayOperation.text.length-1];
        self.displayOperation.text = [self.displayOperation.text stringByAppendingString:[sender currentTitle]];
    }
    if(self.enteredSomeNumber)[self.brain pushOperand:[self.display.text doubleValue]];
    if(!self.enteredSomeNumber && [self.display.text isEqualToString:@"0"])[self.brain pushOperand:[self.display.text doubleValue]];
    self.enteredSomeNumber = NO;
    if ([_brain.operandStack count]==2) [self enterPressed];
    operation = [sender currentTitle];
    self.userPressedEnter=NO;
    self.alreadyUsedDot=NO;

}
- (IBAction)enterPressed {
    
    
    if ([operation isEqualToString:@"/"] && [self.display.text isEqualToString:@"0"]){
        self.display.text = @"Can't Divide By Zero";
        self.displayOperation.text = @"ERROR";
        [self performSelector:@selector(clearPressed) withObject:nil afterDelay:2];
    }
    else{
        if (self.enteredSomeNumber)[self.brain pushOperand:[self.display.text doubleValue]];
        if ([_brain.operandStack count]==2){
            _finalResult = [NSNumber numberWithDouble:[_brain performOperation:operation]];
            self.display.text=[NSString stringWithFormat:@"%@",_finalResult];
        }
    }
    self.userPressedEnter = YES;
    self.enteredSomeNumber = NO;
    self.alreadyUsedDot=NO;
}

- (IBAction)backspacePressed {
    
    if([[self.display.text substringFromIndex:self.display.text.length-1] isEqualToString:@"."]) self.alreadyUsedDot=NO;
    if (self.display.text.length==1 && self.enteredSomeNumber){
        self.display.text=@"0";
        if(self.displayOperation.text.length>1)self.displayOperation.text=[self.displayOperation.text substringToIndex:(self.displayOperation.text.length-1)];
        else self.displayOperation.text=@"0";
        self.enteredSomeNumber=NO;
    }
    if(self.display.text.length==1){
        
    }
    if (self.display.text.length>1 && self.enteredSomeNumber) self.display.text = [self.display.text substringToIndex:(self.display.text.length-1)];
    NSString *lastChar;
    if (self.displayOperation.text.length>1){
        lastChar = [[NSString alloc] initWithString:[self.displayOperation.text substringFromIndex:self.displayOperation.text.length-1]];}
    if ([lastChar isEqualToString:@"*" ]||[lastChar isEqualToString:@"/" ]||[lastChar isEqualToString:@"+" ]||[lastChar isEqualToString:@"-" ]);
    else if (self.enteredSomeNumber) {
            self.displayOperation.text=[self.displayOperation.text substringToIndex:(self.displayOperation.text.length-1)];}
    }


- (IBAction)clearPressed {
    
    self.displayOperation.text=@"0";
    self.display.text=@"0";
    self.alreadyUsedDot=NO;
    [_brain popOperand];
    [_brain popOperand];
    self.enteredSomeNumber=NO;
}


@end
