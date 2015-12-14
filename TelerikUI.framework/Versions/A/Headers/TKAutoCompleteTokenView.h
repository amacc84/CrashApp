//
//  TKAutoCompleteTokenView.h
//  TelerikUI
//
//  Copyright (c) 2015 Telerik. All rights reserved.
//

#import "TKView.h"

@class TKAutoCompleteToken;

/**
 Defines the token visual object.
 */
@interface TKAutoCompleteTokenView : TKView<UIKeyInput>

/**
 Initializes the TKAutoCompleteTokenView with token object model.
 @param token The token objec model.
 */
-(instancetype __nonnull)initWithToken:(TKAutoCompleteToken * __nonnull)token;

/**
 The text label showing the token text.
 */
@property(nonatomic, strong, readonly, nonnull) UILabel* textLabel;

/**
 The image view representing the token image.
 */
@property(nonatomic, strong, readonly, nonnull) UIImageView* imageView;

/**
 Sets highlight color of the token.
 */
@property(nonatomic, strong, nullable) UIColor* tokenHighlightColor;

/**
 Defines whether or not the token is highlighted.
 */
@property(nonatomic) BOOL isHighlighted;

/**
 Token inset.
 */
@property(nonatomic) CGFloat inset;

/**
 Delimeter separating each token from the next one. By default no delimeter is presented.
 */
@property(nonatomic, copy, nullable) NSString *delimeter;

/**
 Defines whether or not the token remove button is visible.
 */
@property(nonatomic) BOOL  isRemoveButtonVisisble;

/**
 The token remove button.
 */
@property(nonatomic, strong, nonnull) UIButton *removeButton;

@end
