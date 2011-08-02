
#import "FinishedGamesController.h"
#import "JoinWaitingRoomGameController.h"
#import "AddGameViewController.h"
#import "Move.h"
#import "GameViewController.h"

@implementation FinishedGamesController

@synthesize noGamesView;
@synthesize gamesView;

// The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
/*
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization.
    }
    return self;
}
*/

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
}
*/

- (void)gotSgfForGame:(Game *)game {
	// Navigation logic may go here. Create and push another view controller.
	GameViewController *gameViewController = [[GameViewController alloc] initWithNibName:@"GameView" bundle:nil];
	// ...
	// Pass the selected object to the new view controller.
	[gameViewController setGame:game];
	[self.navigationController pushViewController:gameViewController animated:YES];
	[gameViewController release];
	//	[self.selectedCell setAccessoryView:nil];
	//self.selectedCell = nil;
}

- (void)addGame:(NewGame *)game toSection:(TableSection *)section {
    TableRow *row = [[TableRow alloc] init];
    row.cellClass = [UITableViewCell class];
    row.cellInit = ^() {
        return (UITableViewCell *)[[[row.cellClass alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:NSStringFromClass(row.cellClass)] autorelease];
    };
    row.cellSetup = ^(UITableViewCell *cell) {
        NSString *ratingString = game.opponentRating ? game.opponentRating : @"Not Ranked";
        [[cell textLabel] setText:[NSString stringWithFormat:@"%@ - %@", game.opponent, ratingString]];
			[[cell detailTextLabel] setText:[NSString stringWithFormat:@"%@, %@", (game.color==kMovePlayerBlack) ? @"Black" : @"White", game.score]];
        [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    };
    row.cellTouched = ^(UITableViewCell *cell) {
        UIActivityIndicatorView *activityView = 
        [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        [activityView startAnimating];
        [cell setAccessoryView:activityView];
        [activityView release];
			if (game.sgfString) {
				[cell setAccessoryView:nil];
				[self gotSgfForGame:game];
			} else {
				[self.gs getSgfForGame:game onSuccess:^(Game *game) {
					[cell setAccessoryView:nil];
					[self gotSgfForGame:game];
				}];
			}
    };
    [section addRow:row];
    [row release];
}

- (void)addNextPageRowForGameList:(GameList *)gameList toSection:(TableSection *)section {
    
    TableRow *row = [[TableRow alloc] init];
    row.cellClass = [UITableViewCell class];
    row.cellInit = ^() {
        return (UITableViewCell *)[[[row.cellClass alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"NextPageCell"] autorelease];
    };
    row.cellSetup = ^(UITableViewCell *cell) {
        [[cell textLabel] setText:@"More Games..."];
    };
    row.cellTouched = ^(UITableViewCell *cell) {
        UIActivityIndicatorView *activityView = 
        [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        [activityView startAnimating];
        [cell setAccessoryView:activityView];
        [activityView release];
        [gameList loadNextPage:^(GameList *gameList) {
            [self setGames:gameList];
            [cell setAccessoryView:nil];
            [self deselectSelectedCell];
            [self.tableView reloadData];
        }];
    };
    [section addRow:row];
    [row release];
}

- (void)setGames:(GameList *)gameList {
    NSArray *games = gameList.games;
    if ([games count] > 0) {
        NSMutableArray *sections = [NSMutableArray array];
        TableSection *mainSection = [[TableSection alloc] init];
        
        for (NewGame *game in games) {
            [self addGame:game toSection:mainSection];
        }
        
        if (gameList.hasMorePages) {
            [self addNextPageRowForGameList:gameList toSection:mainSection];
        }
        
        [sections addObject:mainSection];
        [mainSection release];
        self.tableSections = sections;
        [self.tableView reloadData];
			
			if( self.view != self.gamesView )
			{
				self.view = self.gamesView;
			}
    }
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	self.navigationItem.title = @"Finished games";
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (!self.tableSections) {
			       self.view = self.noGamesView;
    }
}


/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations.
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
    self.noGamesView = nil;
		self.gamesView = nil;
    [super dealloc];
}


@end
