//
//  TKSideDrawerItem.h
//
//  Copyright (c) 2013 Telerik Inc. All rights reserved.
//

@class TKSideDrawerItemStyle;
@class TKStyleSheet;

/**
 Defines TKSideDrawer item.
 */
@interface TKSideDrawerItem : NSObject

/**
 TKSideDrawerItem's title.
 */
@property (nonatomic, strong, nullable) NSString *title;

/**
 TKSideDrawerItem's styles.
 */
@property (nonatomic, strong, readonly, nonnull) TKSideDrawerItemStyle *style;

/**
 TKSideDrawerItem's image.
 */
@property (nonatomic, strong, nullable) UIImage *image;

/**
 Creates new TKSideDrawerItem instance.
 @param title Title for the TKSideDrawerItem that will be created.
 @return New TKSideDrawerItem instance.
 */
- (instancetype __nonnull)initWithTitle:(NSString * __nullable)title;

/**
 Creates new TKSideDrawerItem instance.
 @param title Title for the TKSideDrawerItem that will be created.
 @param image UIImage fot the TKSideDrawerItem that will be created.
 @return New TKSideDrawerItem instance.
 */
- (instancetype __nonnull)initWithTitle:(NSString * __nullable)title image:(UIImage * __nullable)image;

@end
