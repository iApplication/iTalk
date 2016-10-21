#import <UIKit/UIKit.h>

@class LJIndexView;

@protocol LJIndexViewDataSource

// you have to implement this method to provide this UIControl with NSArray of items you want to display in your index
- (NSArray *)sectionIndexTitlesForLJIndexView:(LJIndexView *)indexView;

// you have to implement this method to get the selected index item 
- (void)sectionForSectionLJIndexTitle:(NSString *)title atIndex:(NSInteger)index;

@end


@interface LJIndexView : UIControl

@property (nonatomic, weak) id <LJIndexViewDataSource> dataSource;


// FOR ALL COLORS USE RGB MODEL - DON'T USE whiteColor, blackColor, grayColor or colorWithWhite, colorWithHue

// set this to NO if you want to get selected items during the pan (default is YES)
@property (nonatomic, assign) BOOL getSelectedItemsAfterPanGestureIsFinished;

/* set the font and size of index items (if font size you choose is too large it will be automatically adjusted to the largest possible)
(default is HelveticaNeue 15.0 points)*/
@property (nonatomic, strong) UIFont *font;

/* set the font of the selected index item (usually you should choose the same font with a bold style and much larger)
(default is the same font as previous one with size 40.0 points) */
@property (nonatomic, strong) UIFont *selectedItemFont;

// set the color for index items 
@property (nonatomic, strong) UIColor *fontColor;

// set if items in index are going to darken during a pan (default is YES)
@property (nonatomic, assign) BOOL darkening;

// set if items in index are going ti fade during a pan (default is YES)
@property (nonatomic, assign) BOOL fading;

// set the color for the selected index item
@property (nonatomic, strong) UIColor *selectedItemFontColor;

// set index items aligment (NSTextAligmentLeft, NSTextAligmentCenter or NSTextAligmentRight - default is NSTextAligmentCenter)
@property (nonatomic, assign) NSTextAlignment itemsAligment;

// set the right margin of index items (default is 10.0 points)
@property (nonatomic, assign) CGFloat rightMargin;

/* set the upper margin of index items (default is 20.0 points)
please remember that margins are set for the largest size of selected item font*/
@property (nonatomic, assign) CGFloat upperMargin;

// set the lower margin of index items (default is 20.0 points)
// please remember that margins are set for the largest size of selected item font
@property (nonatomic, assign) CGFloat lowerMargin;

// set the maximum amount for item deflection (default is 75.0 points)
@property (nonatomic,assign) CGFloat maxItemDeflection;

// set the number of items deflected below and above the selected one (default is 3 items)
@property (nonatomic, assign) int rangeOfDeflection;

// set the curtain color if you want a curtain to appear (default is none)
@property (nonatomic, strong) UIColor *curtainColor;

// set the amount of fading for the curtain between 0 to 1 (default is 0.2)
@property (nonatomic, assign) CGFloat curtainFade;

// set if you need a curtain not to hide completely (default is NO)
@property (nonatomic, assign) BOOL curtainStays;

// set if you want a curtain to move while panning (default is NO)
@property (nonatomic, assign) BOOL curtainMoves;

// set if you need a curtain to have the same upper and lower margins (default is NO)
@property (nonatomic, assign) BOOL curtainMargins;

// set the minimum gap between item (default is 5.0 points)
@property (nonatomic, assign) CGFloat minimumGapBetweenItems;

// set this property to YES and it will automatically set margins so that gaps between items are set to the minimumItemGap value (default is YES)
@property BOOL ergonomicHeight;

// set the maximum height for index egronomicHeight - it might be useful for iPad (default is 400.0 ponts)
@property (nonatomic, assign) CGFloat maxValueForErgonomicHeight;



// use this method if you want to change index items or change some properties for layout
- (void)refreshIndexItems;


@end
