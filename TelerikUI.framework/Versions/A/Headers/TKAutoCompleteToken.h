//
//  TKAutoCompleteToken.h
//  TelerikUI
//
//  Copyright (c) 2015 Telerik. All rights reserved.
//

@class TKAutoCompleteTextView;

/**
 Represents token object model.
 */
@interface TKAutoCompleteToken : NSObject

/**
 Initializes TKAutoCompleteToken.
 @param text The token text
 */
- (instancetype __nonnull)initWithText:(NSString* __nullable)text;

/**
 The TKAutoCompleteView in which the token presents.
 */
@property (nonatomic, weak) TKAutoCompleteTextView *owner;

/**
 The token text.
 */
@property (nonatomic, copy, nullable) NSString *text;

/**
 The token detailed text.
 */
@property(nonatomic, strong, nullable) NSString *detailText;

/**
 The token image.
 */
@property (nonatomic, strong, nullable) UIImage *image;

/**
 The token attributed text.
 */
@property (nonatomic, strong, nullable) NSAttributedString *attributedText;

@end
