//
//  PAOptionsTableViewCell.h
//  PhotoApp
//
//  Created by Ondrej Rafaj on 24/04/2012.
//  Copyright (c) 2012 Fuerte International. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PAOptionsTableViewCell;

@protocol PAOptionsTableViewCellDelegate <NSObject>

@optional

- (void)optionsTableViewCell:(PAOptionsTableViewCell *)cell didChangeStatusForIdentifier:(NSString *)identifier;
- (void)optionsTableViewCell:(PAOptionsTableViewCell *)cell didChangeStatusTo:(BOOL)enabled forIdentifier:(NSString *)identifier;
- (void)optionsTableViewCell:(PAOptionsTableViewCell *)cell didChangeValueTo:(CGFloat)value forIdentifier:(NSString *)identifier;

@end

@interface PAOptionsTableViewCell : UITableViewCell

@property (nonatomic, strong) NSString *identifier;
@property (nonatomic, strong) NSString *type;

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *descriptionLabel;

@property (nonatomic, strong) UISwitch *enableSwitch;
@property (nonatomic, strong) UISlider *valueSlider;

@property (nonatomic, assign) id <PAOptionsTableViewCellDelegate> delegate;

- (void)reloadData;


@end
