//
//  chapterTableViewCell.h
//  AntiqueCatalog
//
//  Created by Cangmin on 16/1/25.
//  Copyright © 2016年 Cangmin. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol chapterTableViewCellDelegate <NSObject>

@optional
-(void)gomenu:(NSInteger)integer;

@end

@interface chapterTableViewCell : UITableViewCell

-(void)loadstring:(NSString *)string andIndexPath:(NSIndexPath *)indexPath;
@property (nonatomic,assign)id <chapterTableViewCellDelegate>delegate;

@end
