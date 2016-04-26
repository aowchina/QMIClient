//
//  DDQScreenProjectSubTableViewController.m
//  QuanMei
//
//  Created by Min-Fo-002 on 15/10/13.
//  Copyright (c) 2015年 min-fo. All rights reserved.
//

#import "DDQScreenProjectSubTableViewController.h"
#import "DDQScreenProjectSubTableViewCell.h"
#import "DDQScreenProjectViewController.h"

@interface DDQScreenProjectSubTableViewController ()
//{
//    NSIndexPath *selectedIndexPath;
//
//}
@property (nonatomic ,strong)NSMutableArray *listArray;
@property (nonatomic, retain) NSIndexPath *selectedIndexPath;

@end

@implementation DDQScreenProjectSubTableViewController
@synthesize selectedIndexPath;
//这个indexpath 是为了再次进入页面的时候记录下之前选择的状态
static NSIndexPath *indexpaths = 0;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = _titleStr;
    self.tableView.tableFooterView=[[UIView alloc]init];
//    _listArray = [NSMutableArray arrayWithObjects:@"眼部",@"脸型",@"嘴巴",@"眼部",@"脸型",@"嘴巴",@"眼部",@"脸型",@"嘴巴", nil];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _ListArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *r  = [NSString stringWithFormat:@"%ld",(long)indexPath.row];
    
    DDQScreenProjectSubTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:r ];
    if (!cell) {
        cell = [[DDQScreenProjectSubTableViewCell alloc]initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:@"cell"];
    }
    
    //对号效果
    
    if ([self.selectedIndexPath isEqual:indexPath])
    {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
    else
    {
        cell.accessoryType = UITableViewCellAccessoryNone;

    }
    cell.typeLabel.text = _ListArray[indexPath.row];
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    //对号效果
    
    if (self.selectedIndexPath) {
        
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:self.selectedIndexPath];
        
        cell.accessoryType = UITableViewCellAccessoryNone;
        
    }
    
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    cell.accessoryType = UITableViewCellAccessoryCheckmark;
    
    self.selectedIndexPath = indexPath;
    
    NSString *str = _ListArray[indexPath.row];
    DDQScreenProjectViewController *ddqVC = [[DDQScreenProjectViewController alloc]init];
    Singleton *model = [Singleton sharedDataTool];

    for (NSMutableArray *array in model.TH_TypesArray) {
        for (NSDictionary *dic in array) {
            if ([str isEqualToString:[dic objectForKey:@"name"]]) {
                ddqVC.types_id = [dic objectForKey:@"id"];
                
                if (model.CellName ==nil) {
                    model.CellName = [dic objectForKey:@"name"];
                    model.CellID = [dic objectForKey:@"id"];
                }else{
                    model.CellName = @"";
                    model.CellName = [dic objectForKey:@"name"];
                    
                    model.CellID = @"";
                    model.CellID = [dic objectForKey:@"id"];
                }
//                ddqVC.TypesName = [dic objectForKey:@"name"];
            }

        }
        
    }
    //pop到指定页面
    int index = (int)[[self.navigationController viewControllers]indexOfObject:self];
    [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:(index -2)] animated:YES];
    
    
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
