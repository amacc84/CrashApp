//
//  TKDataFormCell.h
//  TelerikUI
//
//  Copyright (c) 2015 Telerik. All rights reserved.
//

@class TKEntityProperty;
@class TKDataFormEditorStyle;
@class TKDataForm;
@class TKGridLayout;
@class TKView;
@class TKLabel;
/**
 The base editor class used in TKDataForm.
 */
@interface TKDataFormEditor : UIView

/**
 The TKDataForm which owns the editor.
 */
@property (nonatomic, weak) TKDataForm *owner;

/**
 The grid layout used to layout the editor.
 */
@property (nonatomic, strong, readonly, nonnull) TKGridLayout *gridLayout;

/**
 The view shown when the editor is selected.
 */
@property (nonatomic, strong, nullable) TKView *selectedView;

/**
 The selected state of the editor.
 */
@property (nonatomic, readonly) BOOL selected;

/**
 The text label of the editor (read-only).
 */
@property (nonatomic, strong, readonly, nonnull) TKLabel *textLabel;

/**
 The image view of the editor (read-only).
 */
@property (nonatomic, strong, readonly, nonnull) UIImageView *imageView;

/**
 The validation image view in TKDataFormEditor (read-only).
 */
@property (nonatomic, strong, readonly, nonnull) UIImageView *feedbackImageView;

/**
 The validation text label in TKDataFormEditor.
 */
@property (nonatomic, strong, readonly, nonnull) UILabel *feedbackLabel;

/**
 @return The control used to edit a property.
 */
@property (nonatomic, strong, readonly, nonnull) UIView *editor;

/**
 The object responsible for TKDataFormEditor's styling and customization.
 */
@property (nonatomic, strong, readonly, nonnull) TKDataFormEditorStyle *style;

/**
 The property that is edited by this editor.
 */
@property (nonatomic, strong, nonnull) TKEntityProperty *property;

/**
 The TKDataFormEditor's value.
 */
@property (nonatomic, nullable) id value;

/**
 Initializes a TKDataFormEditor with an entity property.
 @param property The entity property used for creating TKDataFormEditor.
 */
- (instancetype __nonnull)initWithProperty:(TKEntityProperty * __nonnull)property;

/**
 Updates the editor when its property value has changed.
 */
- (void)update;

@end
