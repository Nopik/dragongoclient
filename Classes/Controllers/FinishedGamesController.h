//
//  Table of finished games.
//

#import <UIKit/UIKit.h>
#import "JWTableViewController.h"
#import "DGS.h"
#import "GameList.h"

@interface FinishedGamesController : JWTableViewController {
    UIView *noGamesView;
}

@property (nonatomic, retain) IBOutlet UIView *noGamesView;

- (void)setGames:(GameList *)gameList;

@end
