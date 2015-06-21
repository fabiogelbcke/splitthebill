//
//  splitViewController.m
//  Split The Bill
//
//  Created by Fábio Gelbcke Work on 3/26/13.
//  Copyright (c) 2013 Fábio Gelbcke Work. All rights reserved.
//

#import "splitViewController.h"

@interface splitViewController ()

@end

@implementation splitViewController{
    double valorTotal,gorjeta,numero,valorIndividual;
    NSString *aid;
}

@synthesize totalValue=_totalValue,tip=_tip,totalPeople=_totalPeople, finalValue=_finalValue, tipIncluded=_tipIncluded;

-(void)viewWillAppear:(BOOL)animated{
    
    _finalValue.text=@"";
    _totalValue.text=@"$0.00";
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(dismissKeyboard)];
    
    [self.view addGestureRecognizer:tap];
    aid=@"";
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)calculate:(UIButton *)sender {
    
    valorTotal= [_totalValue.text doubleValue];
    gorjeta = [_tip.text doubleValue]/100 + 1;
    numero = [_totalPeople.text doubleValue];
    
    valorIndividual=valorTotal*gorjeta/numero;
    
    _finalValue.text = [NSString stringWithFormat:@"%.02lf", valorIndividual];
}

- (void) dismissKeyboard {
    
    [_totalPeople resignFirstResponder];
    [_tip resignFirstResponder];
    [_totalValue resignFirstResponder];
    
}

-(void)divide{
    _totalValue.text=[@"$" stringByAppendingString:[NSString stringWithFormat:@"%.02lf",[aid doubleValue]/100]];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    if ([textField isEqual:_totalValue]){
        if ([string length]==0 && [aid length]!=0) {
            aid=[aid substringToIndex:[aid length]-1];
        }
        aid=[aid stringByAppendingString:string];
        _totalValue.text=[@"$" stringByAppendingString:[NSString stringWithFormat:@"%.02lf",[aid doubleValue]/100]];
        return NO;
    }
    if([textField isEqual:_tip]){
        if ([textField.text length]>1 && [string length]!=0){
            return NO;
        }
        else{
            return YES;
        }
    }
    if(textField==_totalPeople){
        if ([textField.text length]>1 && [string length]!=0){
            return NO;
        }
        else{
        return YES;
        }
    }
    return YES;
}

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    
    if ([textField isEqual:_tip] && _tipIncluded.isOn==YES){
        return NO;
    }
    else{
        return YES;
    }
}




- (IBAction)isTipIncluded:(UISwitch *)sender {
    NSLog(@"aconteceu");
    if (!_tipIncluded.on){
        NSLog(@"2");
        _tip.text=@"";
        _tip.backgroundColor = [UIColor blackColor];
        _tip.textColor = [UIColor redColor];
        
    }
    if (_tipIncluded.on){
        NSLog(@"1");
        _tip.text=@"0";
        _tip.backgroundColor = [UIColor lightGrayColor];
        _tip.textColor = [UIColor blackColor];
    }
    
}

@end
