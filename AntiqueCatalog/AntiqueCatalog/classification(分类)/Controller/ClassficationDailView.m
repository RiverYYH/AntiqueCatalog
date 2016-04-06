//
//  ClassficationDailView.m
//  AntiqueCatalog
//
//  Created by cssweb on 16/4/6.
//  Copyright © 2016年 Cangmin. All rights reserved.
//

#import "ClassficationDailView.h"

@interface ClassficationDailView ()

@end

@implementation ClassficationDailView
- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(10, UI_NAVIGATION_BAR_HEIGHT, self.view.bounds.size.width, 40)];
    label.text = @"全部";
    [self.view addSubview:label];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
