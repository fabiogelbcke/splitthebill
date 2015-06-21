//
//  SplitBillViewController.m
//  Split The Bill
//
//  Created by Fábio Gelbcke Work on 4/25/13.
//  Copyright (c) 2013 Fábio Gelbcke Work. All rights reserved.
//

#import "SplitBillViewController.h"
#import "CustomCell.h"

@interface SplitBillViewController ()

@property (strong, nonatomic) IBOutlet UIImageView *splitBar;
@property (weak, nonatomic) IBOutlet UIButton *addButton;
@property (weak, nonatomic) IBOutlet UIButton *deleteButton;
@property (nonatomic) NSMutableArray *defPricesArray;
@property (nonatomic) NSMutableArray *defQtyArray;
@property (nonatomic) NSMutableArray *defTickArray;
@property (nonatomic) NSMutableArray *defImageArray;
@property (nonatomic) NSDictionary *imageFromName;
@property (strong, nonatomic) NSArray *itemNames;
@property (strong, nonatomic) NSArray *selectedItemNames;
@property (strong, nonatomic) NSArray *itemsForString;
@property (strong, nonatomic) IBOutlet UIScrollView *itemList;
@property (weak, nonatomic) IBOutlet UITextField *qtyInput;
@property (weak, nonatomic) IBOutlet UITextField *valueInput;
@property (weak, nonatomic) IBOutlet UITextField *peopleInput;
@property (strong, nonatomic) IBOutlet UILabel *itemName;
@property (strong, nonatomic) IBOutlet UILabel *foodName;
@property (strong, nonatomic) IBOutlet UIImageView *valueCell;
@property (strong, nonatomic) IBOutlet UIImageView *tipCell;
@property (strong, nonatomic) IBOutlet UIImageView *addingScreen;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *addY;
@property (strong, nonatomic) IBOutlet UIImageView *subtitles;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *subtitlesY;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *tableY;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *noItemsY;
@property (strong, nonatomic) IBOutlet UIImageView *noItems;
@property (strong, nonatomic) IBOutlet UILabel *addTip;

@property (nonatomic) NSMutableArray *defPeopleArray;
@end

@implementation SplitBillViewController{
    BOOL lastButtonPressed;
    NSInteger n;
    NSString *aid;
    NSNumber *a;
    NSIndexPath *tickedPath;
}

- (void)viewDidLoad{

    [super viewDidLoad];
    [self.view insertSubview:self.noItems belowSubview:self.addingScreen];
    [self.view bringSubviewToFront:self.itemTable];
    [self.view bringSubviewToFront:self.splitBar];
    [self.view bringSubviewToFront:self.addButton];
    [self.view bringSubviewToFront:self.deleteButton];
    self.addTip.alpha=0;
    self.noItemsY.constant=64.04f;
    n=0;
    self.itemTable.alpha=0;
    self.valueCell.alpha=0;
    self.perPerson.minimumScaleFactor=0;
    self.perPerson.textColor = [UIColor colorWithRed:0.99 green:0.976 blue:0.82 alpha:1];
    //self.perPerson.font = [UIFont fontWithName:@"Bariol_Regular" size:40];
    self.tipCell.alpha=0;
    self.subtitles.alpha=0;
    self.tipPercentage.alpha=0;
    self.addY.constant=-148.0f;
    self.tableY.constant=44.0f;
    NSNumberFormatter *currencyFormat= [NSNumberFormatter new];
    [currencyFormat setNumberStyle:NSNumberFormatterCurrencyStyle];
    self.perPerson.text = [currencyFormat stringFromNumber:[NSNumber numberWithInt:0]];
    self.valueInput.text = [currencyFormat stringFromNumber:[NSNumber numberWithInt:0]];
    [self defineItemArrays];
    [self setupHorizontalScrollView];
    aid=@"";
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(dismissTipPercentage)];
    
    [self.view addGestureRecognizer:tap];
    lastButtonPressed=YES;
    self.view.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"bg"]];
    [self.valueCell addSubview:self.perPerson];
    [self.itemTable setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"bg"]]];
    [self setNeedsStatusBarAppearanceUpdate];
}

-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}




- (void)setupHorizontalScrollView
{
    self.itemList.delegate = self;
    
    [self.itemList setBackgroundColor:[UIColor clearColor]];
    [self.itemList setCanCancelContentTouches:NO];
    
    self.itemList.indicatorStyle = UIScrollViewIndicatorStyleWhite;
    self.itemList.clipsToBounds = NO;
    self.itemList.scrollEnabled = YES;
    self.itemList.pagingEnabled = NO;
    
    NSInteger tot=0;
    CGFloat cx = 0;
    for (; ; tot++) {
        if (tot==20) {
            break;
        }
        
        UIButton *foodButton = [[UIButton alloc]  init];
        [foodButton setBackgroundImage:[UIImage imageNamed:[self.itemNames objectAtIndex:tot]] forState:UIControlStateNormal];
        foodButton.tag= tot;
        [foodButton setBackgroundImage:[UIImage imageNamed:[self.selectedItemNames objectAtIndex:tot]] forState:UIControlStateSelected];
        [foodButton setBackgroundImage:[UIImage imageNamed:[self.selectedItemNames objectAtIndex:tot]] forState:UIControlStateHighlighted];
        [foodButton addTarget:self action:@selector(selectRightButton:) forControlEvents:UIControlEventTouchDown];
        if (tot==0) {
            [self selectRightButton:foodButton];
        }
        CGRect rect = foodButton.frame;
        rect.size.height = 40;
        rect.size.width = 40;
        rect.origin.x = cx;
        rect.origin.y = 0;
        
        foodButton.frame = rect;
        [self.itemList addSubview:foodButton];
        cx += foodButton.frame.size.width;
    }

    [self.itemList setContentSize:CGSizeMake(cx, [self.itemList bounds].size.height)];
}

-(void)selectRightButton:(UIButton *) sender{
    if (sender.selected==YES){
    }
    else if (sender.selected==NO){
                UIButton *buttons;
        for (buttons in [self.itemList subviews]){
           if ([buttons isKindOfClass:[UIButton class]]) buttons.selected=NO;
        }
        sender.selected=YES;
        NSInteger tag;
        tag= sender.tag;
        self.foodName.text=[self.itemsForString objectAtIndex:tag];
        
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    // This will create a "invisible" footer
    return 0.01f;
}
-(NSMutableArray *)defPeopleArray{
    if(!_defPeopleArray){
        _defPeopleArray=[[NSMutableArray alloc] init];
    }
    return _defPeopleArray;
}
-(NSMutableArray *)defQtyArray{
    if(!_defQtyArray){
        _defQtyArray=[[NSMutableArray alloc] init];
    }
    return _defQtyArray;
}
-(NSMutableArray *)defPricesArray{
    if(!_defPricesArray){
        _defPricesArray=[[NSMutableArray alloc] init];
    }
    return _defPricesArray;
}
-(NSMutableArray *)defTickArray{
    if(!_defTickArray){
        _defTickArray = [[NSMutableArray alloc] init];
    }
    return _defTickArray;
}
-(NSMutableArray *)defImageArray{
    if(!_defImageArray){
        _defImageArray= [[NSMutableArray alloc] init];
    }
    return _defImageArray;
}


-(void)dismissTipPercentage{
   if ([self.tipPercentage isFirstResponder])[UIView animateWithDuration:0.4 animations:^{[self.view setFrame:CGRectMake(0, 0, 320, 460)];}];
    [_tipPercentage resignFirstResponder];
    [self.valueInput resignFirstResponder];
    [self.qtyInput resignFirstResponder];
    [self.peopleInput resignFirstResponder];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return n;
}

- (void)textFieldDidEndEditing: (UITextField *)textField{
    
        if ([textField isEqual:self.valueInput] && [textField.text isEqual:@""]){
            NSNumberFormatter *currencyFormat= [NSNumberFormatter new];
            [currencyFormat setNumberStyle:NSNumberFormatterCurrencyStyle];
            textField.text=[currencyFormat stringFromNumber:[NSNumber numberWithInt:0]];
        }
        else if ([textField isEqual:self.qtyInput] && [textField.text isEqual:@""]){
            textField.text=@"1";
            [self updateLabels];
        }
        else if ([textField isEqual:self.peopleInput]&& [textField.text isEqual:@""]){
            textField.text=@"1";
            [self updateLabels];
             }

}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
        static NSString *CellIdentifier= @"Cell";
        
        CustomCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (!cell) {
            cell = [[CustomCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
        }
        NSNumberFormatter *currencyFormat= [NSNumberFormatter new];
        [currencyFormat setNumberStyle:NSNumberFormatterCurrencyStyle];
        cell.tickButton.tag=indexPath.row;
    [cell.tickButton addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
    cell.contentView.backgroundColor=[UIColor whiteColor];
        if(indexPath.row<n){
            cell.qtyLabel.text=[self.defQtyArray objectAtIndex:indexPath.row];
            cell.valueLabel.text=[currencyFormat stringFromNumber:[NSNumber numberWithDouble:[[self.defPricesArray objectAtIndex:indexPath.row] doubleValue]]];
            [cell.tickButton setImage:[UIImage imageNamed:@"check_vazio"] forState:UIControlStateDisabled];
            cell.peopleLabel.text=[self.defPeopleArray objectAtIndex:indexPath.row];
            if([self.defTickArray objectAtIndex:indexPath.row] ==[NSNumber numberWithInt:1]){
                cell.tickButton.selected=YES;
            }
            else{
                cell.tickButton.selected=NO;
            }
            [cell adjustButton:[self.defTickArray objectAtIndex:indexPath.row]];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.accessoryView = [UIView new];
    cell.selectedImage.image=[UIImage imageNamed:[self.defImageArray objectAtIndex:indexPath.row]];
        return cell;
    
}

-(void)buttonPressed:(UIButton *)sender{
    if([sender isSelected]){
        sender.selected=NO;
        NSLog(@"%d", sender.tag);
        [self.defTickArray replaceObjectAtIndex:sender.tag withObject:[NSNumber numberWithInt:0]];
    }
    else{
        sender.selected=YES;
        [self.defTickArray replaceObjectAtIndex:sender.tag withObject:[NSNumber numberWithInt:1]];
    }
    [self updateLabels];
}

-(void)eraseText:(UITextField *)sender{
    NSLog(@"@@");
    sender.text=@"";
}


- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section==0)return YES;
    else return NO;
}

-(void)tableView:(UITableView *)tableView willBeginEditingRowAtIndexPath:(NSIndexPath *)indexPath{
    CustomCell *cell = (CustomCell *) [self.itemTable cellForRowAtIndexPath:indexPath];
    [UIView animateWithDuration:0.25 animations:^{cell.tickButton.alpha = 0.0;}];
    [UIView animateWithDuration:0.25 animations:^{cell.peopleLabel.alpha = 0.0;}];

}

-(void)tableView:(UITableView *)tableView didEndEditingRowAtIndexPath:(NSIndexPath *)indexPath{
    CustomCell *cell= (CustomCell *) [self.itemTable cellForRowAtIndexPath:indexPath];
    [UIView animateWithDuration:0.5 animations:^{cell.tickButton.alpha = 1.0;}];
    [UIView animateWithDuration:0.5 animations:^{cell.peopleLabel.alpha = 1.0;}];
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        if (n==1) {
            CustomCell *cell= (CustomCell *) [self.itemTable cellForRowAtIndexPath:indexPath];
            [UIView animateWithDuration:0.5 animations:^{cell.tickButton.alpha = 1.0;}];
            [UIView animateWithDuration:0.5 animations:^{cell.peopleLabel.alpha = 1.0;}];
            [self clearAll];
        }
        else{lastButtonPressed=NO;
        [self.defPricesArray removeObjectAtIndex:indexPath.row];
        [self.defQtyArray removeObjectAtIndex:indexPath.row];
        [self.defPeopleArray removeObjectAtIndex:indexPath.row];
        [self.defTickArray removeObjectAtIndex:indexPath.row];
        [self.defImageArray removeObjectAtIndex:indexPath.row];
            --n;
            CustomCell *cell= (CustomCell *) [self.itemTable cellForRowAtIndexPath:indexPath];
            [UIView animateWithDuration:0.5 animations:^{cell.tickButton.alpha = 1.0;}];
            [UIView animateWithDuration:0.5 animations:^{cell.peopleLabel.alpha = 1.0;}];
        }
        [_itemTable reloadData];
        [self updateLabels];
        
    }
}
- (IBAction)addItem:(UIButton *)sender {
    NSNumberFormatter *currencyFormat= [NSNumberFormatter new];
    [currencyFormat setNumberStyle:NSNumberFormatterCurrencyStyle];
    if ([sender isSelected]){
        if (![aid isEqualToString:@""]){
            [UIView animateWithDuration:0.15 animations:^{
                self.noItems.alpha=0;
                self.itemTable.alpha=1;
                self.valueCell.alpha=1;
                self.subtitles.alpha=1;
                self.tipCell.alpha=1;
                self.addTip.alpha=1;
                self.tipPercentage.alpha=1;}];
            lastButtonPressed=YES;
    
            [self.defPricesArray addObject:self.valueInput.text];
            [self.defQtyArray addObject:self.qtyInput.text];
            [self.defPeopleArray addObject:self.peopleInput.text];
            [self.defImageArray addObject:[self.imageFromName objectForKey:self.foodName.text]];
            [self.defTickArray addObject:[NSNumber numberWithInt:1]];
            n++;
            [self.itemTable reloadData];
            [self.itemTable scrollToRowAtIndexPath:[NSIndexPath indexPathForItem:n-1 inSection:0] atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
    aid=@"";
    self.qtyInput.text=@"1";
    self.peopleInput.text=@"1";
    self.valueInput.text= [currencyFormat stringFromNumber:[NSNumber numberWithInt:0]];
    [self.tipPercentage resignFirstResponder];
    [self.peopleInput resignFirstResponder];
    [self.qtyInput resignFirstResponder];
    [self.valueInput resignFirstResponder];
            [self updateLabels];}
        else{
            self.addY.constant= -148.0f;
            self.subtitlesY.constant=0.0f;
            self.tableY.constant=74.0f;
            sender.selected=NO;
            [self.addingScreen setNeedsUpdateConstraints];
            [self.subtitles setNeedsUpdateConstraints];
            [self.itemTable setNeedsUpdateConstraints];
            [UIView animateWithDuration:0.4f animations:^{
                [self.view layoutIfNeeded];
            }];
        }
    }
    else{
                self.addY.constant = 44.0f;
        self.subtitlesY.constant=120.0f;
        self.tableY.constant=214.0f;
        sender.selected=YES;
        [self.addingScreen setNeedsUpdateConstraints];
        [UIView animateWithDuration:0.4f animations:^{
            [self.view layoutIfNeeded];
        }];
        
        
        
    }

}


- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
        if([textField isEqual:self.valueInput]){
            
            if ([string length]==0 && [aid length]!=0) {
                aid=[aid substringToIndex:[aid length]-1];
                [NSString stringWithFormat:@"%.02lf",[aid doubleValue]/100];
            }
            if (aid.length !=7){
                aid=[aid stringByAppendingString:string];
                NSNumberFormatter *format = [NSNumberFormatter new];
                [format setNumberStyle:NSNumberFormatterCurrencyStyle];
                textField.text=[format stringFromNumber:[NSNumber numberWithDouble:[aid doubleValue]/100]];
                if(n!=0)[self.defPricesArray replaceObjectAtIndex:n withObject:[NSString stringWithFormat:@"%.02lf",[aid doubleValue]/100]];
                else if(n==0 && aid.length==1)[self.defPricesArray addObject:[NSString stringWithFormat:@"%.02lf",[aid doubleValue]/100]];
                else [self.defPricesArray replaceObjectAtIndex:0 withObject:[NSString stringWithFormat:@"%.02lf",[aid doubleValue]/100]];
                return NO;
            }
            else return NO;
        }
        
        else if (![textField isEqual:self.valueInput]){ if (textField.text.length==3 && string.length!=0) return NO;
            [self performSelector:@selector(updateLabels) withObject:nil afterDelay:0.01];}
    return YES;
    
    
}


-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    textField.text=@"";
    if([textField isEqual:self.valueInput]){
        aid=@"";
    }
    if([textField isEqual:self.tipPercentage]){
        [UIView animateWithDuration:0.25 animations:^{[self.view setFrame:CGRectMake(0, -165, 320, 460)];}];
    }
    [self updateLabels];
    return YES;
}


-(void)updateLabels{
    double personValue=0;
    for(NSInteger i = 0; i < n; i++) {
        if([[self.defPeopleArray objectAtIndex:i]doubleValue]>0) personValue += ([[self.defPricesArray objectAtIndex:i] doubleValue] * [[self.defQtyArray objectAtIndex:i]doubleValue]/ [[self.defPeopleArray objectAtIndex:i]doubleValue] * [[self.defTickArray objectAtIndex:i] intValue]);
        NSLog(@"index:%ld value: %@",(long)i, [self.defTickArray objectAtIndex:i]);
    }
    NSNumberFormatter *format = [NSNumberFormatter new];
    [format setNumberStyle:NSNumberFormatterCurrencyStyle];
    _perPerson.text=[format stringFromNumber:[NSNumber numberWithDouble:(1+([self.tipPercentage.text doubleValue]/100))*personValue]];
}

- (IBAction)clear {
    if (n!=0){
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Are you sure you wanna delete all items?" message:@"" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Yes",nil];
        [alert show];}
        
}
- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex;{
    if(buttonIndex==1){
    [self clearAll];
    }
}

-(void)clearAll{
    
        n=0;
        [self.defPricesArray removeAllObjects];
        [self.defQtyArray removeAllObjects];
        [self.defPeopleArray removeAllObjects];
        [self.defTickArray removeAllObjects];
        [self.defImageArray removeAllObjects];
        [_itemTable reloadData];
        if (self.addY.constant==-148.0f)[self.addButton setSelected:NO];
        [self updateLabels];
        [UIView animateWithDuration:0.15 animations:^{
            self.itemTable.alpha=0;
            self.subtitles.alpha=0;
            self.noItems.alpha=1;;}];
}
-(void)defineItemArrays{
    self.itemNames = [NSArray arrayWithObjects:@"item_nenhum", @"item_carne",@"item_frango", @"item_peixe", @"item_camarao", @"item_salada", @"item_suco", @"item_chopp", @"item_vinho", @"item_refrigerante",@"item_cafe",@"item_agua", @"item_pizza", @"item_hamburger",@"item_fritas", @"item_sushi", @"item_sopa", @"item_sobremesa",@"item_fruta",@"item_bolo", nil];
    self.selectedItemNames = [NSArray arrayWithObjects:@"item_nenhum_selecionado",@"item_carne_selecionado", @"item_frango_selecionado", @"item_peixe_selecionado",@"item_camarao_selecionado", @"item_salada_selecionado",  @"item_suco_selecionado", @"item_chopp_selecionado", @"item_vinho_selecionado", @"item_refrigerante_selecionado", @"item_cafe_selecionado", @"item_agua_selecionado", @"item_pizza_selecionado", @"item_hamburger_selecionado", @"item_fritas_selecionado", @"item_sushi_selecionado", @"item_sopa_selecionado", @"item_sobremesa_selecionado", @"item_fruta_selecionado", @"item_bolo_selecionado", nil];
    self.itemsForString = [NSArray arrayWithObjects:@"None", @"Steak", @"Chicken", @"Fish",@"Shrimp", @"Salad", @"Juice", @"Beer", @"Wine",@"Soda", @"Coffee", @"Water", @"Pizza", @"Hamburger", @"Fries", @"Sushi", @"Soup", @"Dessert", @"Fruit", @"Cake", nil];
    self.imageFromName = [NSDictionary dictionaryWithObjects:self.itemNames forKeys:self.itemsForString];
}

@end
