//
//  TKCalendarYearPresenter.h
//  Telerik UI
//
//  Copyright (c) 2014 Telerik. All rights reserved.
//

#import "TKCalendar.h"

@class TKCalendarYearPresenterStyle;
@class TKCalendarYearPresenter;

/**
 @discussion A calendar presenter responsible for rendering TKCalendar in year view mode.
 */
@interface TKCalendarYearPresenter : UIView <TKCalendarPresenter>

/**
 Defines the number of columns.
 */
@property (nonatomic) NSInteger columns;

/**
 The class for the cell responsible for presenting a single month in TKCalendarYearPresenter. TKCalendarMonthCell by default.
 */
@property (nonatomic, strong) Class __nonnull monthCellClass;

/**
 The class for the view responsible for presenting a year title in TKCalendarYearPresenter. TKCalendarYearTitleView by default.
 */
@property (nonatomic, strong) Class __nonnull titleViewClass;

/**
 Returns the presenter style. Use the style properties to customize the visual appearance of TKCalendar in year view mode.
 */
@property (nonatomic, strong, readonly) TKCalendarYearPresenterStyle* __nonnull style;

/**
 Returns the collection view used by this presenter.
 */
@property (nonatomic, strong, readonly) UICollectionView* __nonnull collectionView;

@end
