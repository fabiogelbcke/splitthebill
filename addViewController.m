//
//  addViewController.m
//  Split The Bill
//
//  Created by Fábio Gelbcke Work on 4/2/13.
//  Copyright (c) 2013 Fábio Gelbcke Work. All rights reserved.
//

#import "addViewController.h"
#import "CustomCell.h"

@interface addViewController ()

@end

@implementation addViewController{
    BOOL lastButtonPressed;
    NSInteger n;
    NSString *aid;
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
    n=1;
    aid=@"";
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(dismissKeyboard)];
    
    [self.view addGestureRecognizer:tap];
    lastButtonPressed=YES;
    _itemTable.separatorColor = [UIColor blackColor];
    self.view.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"GreyBackground2-568h"]];
    
    

}

-(void)dismissKeyboard{
    
    [_itemTable endEditing:YES];
    [_tipPercentage resignFirstResponder];
    [_numberOfPeople resignFirstResponder];
    
    
    
}
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 2;
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    

    if (section==0) return n;
    return 5;
    
    
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section ==0){
       static NSString *CellIdentifier= @"Cell";
       
       CustomCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
       if (cell == nil) {
           cell = [[CustomCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
           
       }
        if ([indexPath row]%2==0){
            [cell setBackgroundColor:[UIColor colorWithRed:0.85 green:0.85 blue:0.85 alpha:0.8]];
        }
        else{
            [cell setBackgroundColor:[UIColor colorWithRed:0.94 green:0.94 blue:0.94 alpha:0.9]];
        }
       
       cell.itemNumber.text=[NSString stringWithFormat:@"Item %d",indexPath.row+1];
       if (lastButtonPressed){if (indexPath.row==n-1){
           cell.qty.text=@"1";
           cell.itemValue.text=@"R$ 0.00";
       }}
       return cell;
    }
    else{
        static NSString *CellIdentifier= @"CustomCell";
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CustomCell"];
            cell.backgroundColor=[UIColor blackColor];
            
        }
        return cell;

    }

}
- (IBAction)addItem:(UIButton *)sender {
    lastButtonPressed=YES;
    ++n;
    [_itemTable reloadData];
    [_itemTable scrollToRowAtIndexPath:[NSIndexPath indexPathForItem:n-1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    [_itemTable endEditing:YES];
    [_tipPercentage resignFirstResponder];
    [_numberOfPeople resignFirstResponder];
}
- (IBAction)removeItem:(UIButton *)sender {
    lastButtonPressed=NO;
    if (n>=1)--n;
    [self updateLabels];
    [_itemTable reloadData];
    [_itemTable endEditing:YES];
    [_tipPercentage resignFirstResponder];
    [_numberOfPeople resignFirstResponder];
    
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    for(NSInteger i = 0; i < n; i++) {
        
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:i inSection:0];
        CustomCell *cell = (CustomCell *)[self.itemTable cellForRowAtIndexPath:indexPath];
        
    
        if([textField isEqual:cell.itemValue]){
            
    if ([string length]==0 && [aid length]!=0) {
        aid=[aid substringToIndex:[aid length]-1];
    }
    if (aid.length !=7){
    aid=[aid stringByAppendingString:string];
    textField.text=[@"R$ " stringByAppendingString:[NSString stringWithFormat:@"%.02lf",[aid doubleValue]/100]];
    [self performSelector:@selector(updateLabels)];
                return NO;}
            else return NO;}}
    if (textField.text.length==3 && string.length!=0) return NO;
    [self performSelector:@selector(updateLabels) withObject:nil afterDelay:0.0001];
    return YES;
    
    
}

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    aid=@"";
    return YES;
}

- (NSArray *)returnPricesArray {
    
    NSMutableArray *cellTextArray = [[NSMutableArray alloc] initWithCapacity:n];
    for(NSInteger i = 0; i < n; i++) {
        
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:i inSection:0];
        CustomCell *cell = (CustomCell *)[self.itemTable cellForRowAtIndexPath:indexPath];
        
        NSString *item = [cell.itemValue.text substringFromIndex:3];
        
        if(item)[cellTextArray insertObject:item atIndex:i];
        else [cellTextArray insertObject:@"0" atIndex:i];
    }
    
    return cellTextArray;
    
}

-(NSArray *)returnQtyArray{
    
    NSMutableArray *qtyArray = [[NSMutableArray alloc] initWithCapacity:n];for(NSInteger i = 0; i < n; i++) {
        
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:i inSection:0];
        CustomCell *cell = (CustomCell *)[self.itemTable cellForRowAtIndexPath:indexPath];
     
        
        NSString *itemQty = cell.qty.text;
        if (itemQty)[qtyArray insertObject:itemQty atIndex:i];
        else [qtyArray insertObject:@"0" atIndex:i];
    }
    return qtyArray;

    
}

-(void)updateLabels{
    
    double totalValue=0;
    for(NSInteger i = 0; i < n; i++) {
        totalValue += ([[[self returnPricesArray] objectAtIndex:i] doubleValue] * [[[self returnQtyArray] objectAtIndex:i]doubleValue]);
        }
    _totalValue.text = [NSString stringWithFormat:@"R$ %.02lf", totalValue];
    _tip.text= [NSString stringWithFormat:@"R$ %.02lf", totalValue*(([_tipPercentage.text doubleValue]/100))];
_addedValue.text= [NSString stringWithFormat:@"R$ %.02lf",([[_tip.text substringFromIndex:3] doubleValue]+totalValue) ];
    if(_numberOfPeople.text.length==0 || _numberOfPeople.text.doubleValue == 0){
        _perPerson.text=@"R$ 0.00";
    }
    else{
        _perPerson.text =[NSString stringWithFormat:@"R$ %.02lf",[[_addedValue.text substringFromIndex:3] doubleValue]/[_numberOfPeople.text doubleValue]];
        
    }


}
@end
