//
//  Table of finished games.
//

#import <UIKit/UIKit.h>
#import "JWTableViewController.h"
#import "DGS.h"
#import "GameList.h"

@interface FinishedGamesController : JWTableViewController {
    UIView *noGamesView;
		UIView *gamesView;
}

@property (nonatomic, retain) IBOutlet UIView *noGamesView;
@property (nonatomic, retain) IBOutlet UIView *gamesView;

- (void)setGames:(GameList *)gameList;

@end
