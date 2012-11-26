//
//  PAOptionsTableViewCell.m
//  PhotoApp
//
//  Created by Ondrej Rafaj on 24/04/2012.
//  Copyright (c) 2012 Fuerte International. All rights reserved.
//

#import "PAOptionsTableViewCell.h"


@implementation PAOptionsTableViewCell

@synthesize identifier = _identifier;
@synthesize type = _type;
@synthesize titleLabel = _titleLabel;
@synthesize descriptionLabel = _descriptionLabel;
@synthesize enableSwitch = _enableSwitch;
@synthesize valueSlider = _valueSlider;
@synthesize delegate = _delegate;


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
		_titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(14, 5, 180, 20)];
		[_titleLabel setFont:[UIFont boldSystemFontOfSize:15]];
		[_titleLabel setTextColor:[UIColor darkGrayColor]];
		[_titleLabel setBackgroundColor:[UIColor clearColor]];
		[self addSubview:_titleLabel];
		
        _descriptionLabel = [[UILabel alloc] initWithFrame:CGRectMake(14, 29, 180, 14)];
		[_descriptionLabel setFont:[UIFont systemFontOfSize:12]];
		[_descriptionLabel setTextColor:[UIColor grayColor]];
		[_descriptionLabel setBackgroundColor:[UIColor clearColor]];
		[self addSubview:_descriptionLabel];
		
        _enableSwitch = [[UISwitch alloc] init];
		[_enableSwitch setOnTintColor:[UIColor darkGrayColor]];
		[_enableSwitch addTarget:self action:@selector(didSwitchSwitch:) forControlEvents:UIControlEventValueChanged];
		[_enableSwitch setAutoresizingMask:UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin];
		[self addSubview:_enableSwitch];
		CGRect r = _enableSwitch.frame;
		r.origin.x = (self.bounds.size.width - r.size.width - 10);
		r.origin.y = ((self.bounds.size.height - r.size.height) / 2);
		[_enableSwitch setFrame:r];
		[_enableSwitch setHidden:YES];
		
		_valueSlider = [[UISlider alloc] init];
		[_valueSlider setMinimumTrackTintColor:[UIColor darkGrayColor]];
		[_valueSlider addTarget:self action:@selector(sliderChangedValue:) forControlEvents:UIControlEventValueChanged];
		[_valueSlider setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
		r = _valueSlider.frame;
		r.origin.x = 12;
		r.origin.y = (_descriptionLabel.frame.origin.y + _descriptionLabel.frame.size.height + 7);
		r.size.width = (self.bounds.size.width - 25);
		[_valueSlider setFrame:r];
		[self addSubview:_valueSlider];
		[_valueSlider setHidden:YES];
        
        [self setAutoresizesSubviews:YES];
        [self setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)didSwitchSwitch:(UISwitch *)sender {
	if (_identifier) {
		[[NSUserDefaults standardUserDefaults] setBool:sender.isOn forKey:_identifier];
		[[NSUserDefaults standardUserDefaults]synchronize];
		if ([_delegate respondsToSelector:@selector(optionsTableViewCell:didChangeStatusTo:forIdentifier:)]) {
			[_delegate optionsTableViewCell:self didChangeStatusTo:sender.isOn forIdentifier:_identifier];
		}
		if ([_delegate respondsToSelector:@selector(optionsTableViewCell:didChangeStatusForIdentifier:)]) {
			[_delegate optionsTableViewCell:self didChangeStatusForIdentifier:_identifier];
		}
	}
}

- (void)sliderChangedValue:(UISlider *)sender {
	if (_identifier) {
		[[NSUserDefaults standardUserDefaults] setFloat:sender.value forKey:_identifier];
		[[NSUserDefaults standardUserDefaults]synchronize];
		if ([_delegate respondsToSelector:@selector(optionsTableViewCell:didChangeValueTo:forIdentifier:)]) {
			[_delegate optionsTableViewCell:self didChangeValueTo:sender.value forIdentifier:_identifier];
		}
		if ([_delegate respondsToSelector:@selector(optionsTableViewCell:didChangeStatusForIdentifier:)]) {
			[_delegate optionsTableViewCell:self didChangeStatusForIdentifier:_identifier];
		}
	}
}

- (void)reloadData {
	if ([_type isEqualToString:@"switch"]) {
		[_enableSwitch setOn:[[NSUserDefaults standardUserDefaults] boolForKey:_identifier]];
		[_enableSwitch setHidden:NO];
		[self didSwitchSwitch:_enableSwitch];
	}
	if ([_type isEqualToString:@"slider"]) {
		[_valueSlider setValue:[[NSUserDefaults standardUserDefaults] floatForKey:_identifier]];
		[_valueSlider setHidden:NO];
		[self sliderChangedValue:_valueSlider];
	}
}

@end
