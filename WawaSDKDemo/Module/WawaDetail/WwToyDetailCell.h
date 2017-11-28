//
//  WwToyDetailCell.h
//  F_Sky
//

#import <UIKit/UIKit.h>

static NSString *const kToyDetailCellIdentifier = @"WwToyDetailCell";

@interface WwToyDetailCell : UITableViewCell

- (void)reloadCellWithImage:(NSString *)imgName;

@end
