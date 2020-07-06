//
//  ChatCell.h
//  Parse-Chat
//
//  Created by chadfranklin on 7/6/20.
//  Copyright © 2020 chadfranklin. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ChatCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *chatLabel;
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;

@end

NS_ASSUME_NONNULL_END
