//
//  TKSuggestionListView.h
//  TelerikUI
//
//  Copyright (c) 2015 Telerik. All rights reserved.
//

#import "TKListView.h"
#import "TKAutoCompleteTextView.h"

/**
 The default suggestions view used by the autocomplete.
 */
@interface TKSuggestionListView : TKListView<TKAutoCompleteSuggestViewDelegate, TKListViewDataSource, TKListViewDelegate>

/**
 Initializes the TKSuggestionListView with an corresponding TKAutoCompleteTextView object.
 @param autocomplete The TKAutoCompleteTextView objec owning the instance.
 */
- (instancetype __nonnull)initWithAutoComplete:(TKAutoCompleteTextView* __nonnull)autocomplete;

/**
 The TKAutoCompleteTextView objec owning the instance.
 */
@property (weak, nonatomic) TKAutoCompleteTextView *owner;

/**
 The selected item.
 */
@property (strong, nonatomic, nullable) TKAutoCompleteToken *selectedItem;

/**
 The selected index path.
 */
@property (strong, nonatomic, nullable) NSIndexPath *selectedIndexPath;

/**
 The data collection which populates the view.
 */
@property (strong, nonatomic, nonnull) NSArray<__kindof TKAutoCompleteToken*> *items;

/**
 The progress bar indicating that operation is being performed and will take a while.
 */
@property (strong,nonatomic, readonly, nonnull) UIProgressView *progressBar;

@end
