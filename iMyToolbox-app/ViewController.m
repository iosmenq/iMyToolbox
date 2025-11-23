/*
* ViewController.m
*
* coded by iosmen (c) 2025
* 
* Mini iOS Toolbox App
*/

#import "ViewController.h"
#import <Foundation/Foundation.h>

@interface ViewController ()
@property (strong, nonatomic) UIButton *currentGameButton;
@property (strong, nonatomic) UIView *gameContainerView;
@property (strong, nonatomic) NSArray *quizQuestions;
@property (strong, nonatomic) NSArray *quizAnswers;
@property (assign, nonatomic) NSInteger currentQuestion;
@property (strong, nonatomic) UILabel *questionLabel;
@property (strong, nonatomic) NSArray *gameButtons;
@property (strong, nonatomic) NSMutableArray *memoryGameCards;
@property (assign, nonatomic) NSInteger memoryGameFirstIndex;
@property (assign, nonatomic) NSInteger memoryGameMatches;
@property (strong, nonatomic) NSTimer *gameTimer;
@property (assign, nonatomic) NSInteger timerSeconds;
@property (strong, nonatomic) UILabel *timerLabel;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"iMyToolbox";
    self.defaults = [NSUserDefaults standardUserDefaults];
    self.isDarkMode = [self.defaults boolForKey:@"DarkMode"];
    self.gameScore = [self.defaults integerForKey:@"GameScore"];
    [self initializeGames];
    [self setupUI];
    [self applyTheme];
}

- (void)initializeGames {
    self.quizQuestions = @[
        @"What is the capital of France?",
        @"Which planet is known as the Red Planet?",
        @"What is 2+2?",
        @"Who wrote 'Hamlet'?",
        @"What is the chemical symbol for Gold?"
    ];
    self.quizAnswers = @[@"Paris", @"Mars", @"4", @"Shakespeare", @"Au"];
    self.currentQuestion = 0;
    self.memoryGameCards = [NSMutableArray array];
    self.memoryGameFirstIndex = -1;
    self.memoryGameMatches = 0;
}

- (void)setupUI {
    self.scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    self.scrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self.view addSubview:self.scrollView];
    
    self.contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 2500)];
    self.scrollView.contentSize = self.contentView.frame.size;
    [self.scrollView addSubview:self.contentView];
    
    [self createHeaderSection];
    [self createThemeSection];
    [self createFileSystemSection];
    [self createSymlinkSection];
    [self createGamesSection];
    [self createQuizGame];
    [self createMemoryGame];
    [self createReactionGame];
    [self createUtilitiesSection];
    [self createOutputSection];
}

- (void)createHeaderSection {
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(20, 20, self.view.frame.size.width - 40, 100)];
    headerView.backgroundColor = [UIColor systemGray6Color];
    headerView.layer.cornerRadius = 15;
    [self.contentView addSubview:headerView];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 10, headerView.frame.size.width - 40, 30)];
    titleLabel.text = @"Mini iOS Test Toolbox";
    titleLabel.font = [UIFont boldSystemFontOfSize:24];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [headerView addSubview:titleLabel];
    
    self.scoreLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 50, headerView.frame.size.width - 40, 30)];
    self.scoreLabel.text = [NSString stringWithFormat:@"Score: %ld", (long)self.gameScore];
    self.scoreLabel.font = [UIFont systemFontOfSize:18];
    self.scoreLabel.textAlignment = NSTextAlignmentCenter;
    [headerView addSubview:self.scoreLabel];
}

- (void)createThemeSection {
    UIView *themeView = [[UIView alloc] initWithFrame:CGRectMake(20, 140, self.view.frame.size.width - 40, 80)];
    themeView.backgroundColor = [UIColor systemGray5Color];
    themeView.layer.cornerRadius = 10;
    [self.contentView addSubview:themeView];
    
    UILabel *themeLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 10, themeView.frame.size.width - 40, 25)];
    themeLabel.text = @"Theme Selection";
    themeLabel.font = [UIFont boldSystemFontOfSize:18];
    [themeView addSubview:themeLabel];
    
    self.themeControl = [[UISegmentedControl alloc] initWithItems:@[@"Light", @"Dark", @"Auto"]];
    self.themeControl.frame = CGRectMake(20, 45, themeView.frame.size.width - 40, 30);
    [self.themeControl addTarget:self action:@selector(themeChanged) forControlEvents:UIControlEventValueChanged];
    self.themeControl.selectedSegmentIndex = self.isDarkMode ? 1 : 0;
    [themeView addSubview:self.themeControl];
}

- (void)createFileSystemSection {
    UIView *fsView = [[UIView alloc] initWithFrame:CGRectMake(20, 240, self.view.frame.size.width - 40, 200)];
    fsView.backgroundColor = [UIColor systemGray5Color];
    fsView.layer.cornerRadius = 10;
    [self.contentView addSubview:fsView];
    
    UILabel *fsLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 10, fsView.frame.size.width - 40, 25)];
    fsLabel.text = @"File System Explorer";
    fsLabel.font = [UIFont boldSystemFontOfSize:18];
    [fsView addSubview:fsLabel];
    
    NSArray *fsButtons = @[@"List Documents", @"Show System Info", @"Create Test Files", @"Explore Parent Dirs"];
    for (int i = 0; i < fsButtons.count; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
        button.frame = CGRectMake(20, 45 + (i * 35), fsView.frame.size.width - 40, 30);
        button.backgroundColor = [UIColor systemBlueColor];
        [button setTitle:fsButtons[i] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:14];
        button.layer.cornerRadius = 8;
        button.tag = i;
        [button addTarget:self action:@selector(fileSystemButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
        [fsView addSubview:button];
    }
}

- (void)createSymlinkSection {
    UIView *slView = [[UIView alloc] initWithFrame:CGRectMake(20, 460, self.view.frame.size.width - 40, 150)];
    slView.backgroundColor = [UIColor systemGray5Color];
    slView.layer.cornerRadius = 10;
    [self.contentView addSubview:slView];
    
    UILabel *slLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 10, slView.frame.size.width - 40, 25)];
    slLabel.text = @"Symlink Operations";
    slLabel.font = [UIFont boldSystemFontOfSize:18];
    [slView addSubview:slLabel];
    
    NSArray *slButtons = @[@"Create Symlinks", @"Test Sandbox Escape", @"Cleanup Symlinks"];
    for (int i = 0; i < slButtons.count; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
        button.frame = CGRectMake(20, 45 + (i * 35), slView.frame.size.width - 40, 30);
        button.backgroundColor = [UIColor systemPurpleColor];
        [button setTitle:slButtons[i] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:14];
        button.layer.cornerRadius = 8;
        button.tag = i;
        [button addTarget:self action:@selector(symlinkButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
        [slView addSubview:button];
    }
}

- (void)createGamesSection {
    UIView *gamesView = [[UIView alloc] initWithFrame:CGRectMake(20, 630, self.view.frame.size.width - 40, 50)];
    gamesView.backgroundColor = [UIColor systemGray5Color];
    gamesView.layer.cornerRadius = 10;
    [self.contentView addSubview:gamesView];
    
    UILabel *gamesLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 10, gamesView.frame.size.width - 40, 30)];
    gamesLabel.text = @"Mini Games";
    gamesLabel.font = [UIFont boldSystemFontOfSize:18];
    gamesLabel.textAlignment = NSTextAlignmentCenter;
    [gamesView addSubview:gamesLabel];
}

- (void)createQuizGame {
    UIView *quizView = [[UIView alloc] initWithFrame:CGRectMake(20, 700, self.view.frame.size.width - 40, 200)];
    quizView.backgroundColor = [UIColor systemGray4Color];
    quizView.layer.cornerRadius = 10;
    quizView.tag = 100;
    [self.contentView addSubview:quizView];
    
    UILabel *quizLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 10, quizView.frame.size.width - 40, 25)];
    quizLabel.text = @"Quiz Game";
    quizLabel.font = [UIFont boldSystemFontOfSize:16];
    [quizView addSubview:quizLabel];
    
    self.questionLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 45, quizView.frame.size.width - 40, 40)];
    self.questionLabel.text = self.quizQuestions[0];
    self.questionLabel.numberOfLines = 2;
    self.questionLabel.font = [UIFont systemFontOfSize:14];
    [quizView addSubview:self.questionLabel];
    
    NSArray *quizButtons = @[@"Start Quiz", @"Next Question", @"Submit Answer"];
    for (int i = 0; i < quizButtons.count; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
        button.frame = CGRectMake(20, 95 + (i * 35), quizView.frame.size.width - 40, 30);
        button.backgroundColor = [UIColor systemGreenColor];
        [button setTitle:quizButtons[i] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:14];
        button.layer.cornerRadius = 8;
        button.tag = i;
        [button addTarget:self action:@selector(quizButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
        [quizView addSubview:button];
    }
}

- (void)createMemoryGame {
    UIView *memoryView = [[UIView alloc] initWithFrame:CGRectMake(20, 920, self.view.frame.size.width - 40, 200)];
    memoryView.backgroundColor = [UIColor systemGray4Color];
    memoryView.layer.cornerRadius = 10;
    memoryView.tag = 101;
    [self.contentView addSubview:memoryView];
    
    UILabel *memoryLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 10, memoryView.frame.size.width - 40, 25)];
    memoryLabel.text = @"Memory Game";
    memoryLabel.font = [UIFont boldSystemFontOfSize:16];
    [memoryView addSubview:memoryLabel];
    
    NSMutableArray *buttons = [NSMutableArray array];
    for (int i = 0; i < 6; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
        int row = i / 3;
        int col = i % 3;
        button.frame = CGRectMake(20 + (col * 100), 45 + (row * 60), 90, 50);
        button.backgroundColor = [UIColor systemBlueColor];
        [button setTitle:@"?" forState:UIControlStateNormal];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont boldSystemFontOfSize:20];
        button.layer.cornerRadius = 8;
        button.tag = i;
        [button addTarget:self action:@selector(memoryCardTapped:) forControlEvents:UIControlEventTouchUpInside];
        [memoryView addSubview:button];
        [buttons addObject:button];
    }
    self.gameButtons = [buttons copy];
    
    UIButton *startMemory = [UIButton buttonWithType:UIButtonTypeSystem];
    startMemory.frame = CGRectMake(20, 165, memoryView.frame.size.width - 40, 30);
    startMemory.backgroundColor = [UIColor systemOrangeColor];
    [startMemory setTitle:@"Start Memory Game" forState:UIControlStateNormal];
    [startMemory setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    startMemory.titleLabel.font = [UIFont systemFontOfSize:14];
    startMemory.layer.cornerRadius = 8;
    [startMemory addTarget:self action:@selector(startMemoryGame) forControlEvents:UIControlEventTouchUpInside];
    [memoryView addSubview:startMemory];
}

- (void)createReactionGame {
    UIView *reactionView = [[UIView alloc] initWithFrame:CGRectMake(20, 1140, self.view.frame.size.width - 40, 150)];
    reactionView.backgroundColor = [UIColor systemGray4Color];
    reactionView.layer.cornerRadius = 10;
    reactionView.tag = 102;
    [self.contentView addSubview:reactionView];
    
    UILabel *reactionLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 10, reactionView.frame.size.width - 40, 25)];
    reactionLabel.text = @"Reaction Time Test";
    reactionLabel.font = [UIFont boldSystemFontOfSize:16];
    [reactionView addSubview:reactionLabel];
    
    self.timerLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 45, reactionView.frame.size.width - 40, 30)];
    self.timerLabel.text = @"Tap to start!";
    self.timerLabel.font = [UIFont boldSystemFontOfSize:20];
    self.timerLabel.textAlignment = NSTextAlignmentCenter;
    [reactionView addSubview:self.timerLabel];
    
    UIButton *reactionButton = [UIButton buttonWithType:UIButtonTypeSystem];
    reactionButton.frame = CGRectMake(20, 85, reactionView.frame.size.width - 40, 50);
    reactionButton.backgroundColor = [UIColor systemRedColor];
    [reactionButton setTitle:@"Start Reaction Test" forState:UIControlStateNormal];
    [reactionButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    reactionButton.titleLabel.font = [UIFont boldSystemFontOfSize:16];
    reactionButton.layer.cornerRadius = 8;
    [reactionButton addTarget:self action:@selector(startReactionTest) forControlEvents:UIControlEventTouchUpInside];
    [reactionView addSubview:reactionButton];
}

- (void)createUtilitiesSection {
    UIView *utilView = [[UIView alloc] initWithFrame:CGRectMake(20, 1310, self.view.frame.size.width - 40, 180)];
    utilView.backgroundColor = [UIColor systemGray5Color];
    utilView.layer.cornerRadius = 10;
    [self.contentView addSubview:utilView];
    
    UILabel *utilLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 10, utilView.frame.size.width - 40, 25)];
    utilLabel.text = @"Utilities";
    utilLabel.font = [UIFont boldSystemFontOfSize:18];
    [utilView addSubview:utilLabel];
    
    NSArray *utilButtons = @[@"System Info", @"Device Stats", @"Network Test", @"Clear Output"];
    for (int i = 0; i < utilButtons.count; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
        button.frame = CGRectMake(20, 45 + (i * 35), utilView.frame.size.width - 40, 30);
        button.backgroundColor = [UIColor systemTealColor];
        [button setTitle:utilButtons[i] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:14];
        button.layer.cornerRadius = 8;
        button.tag = i;
        [button addTarget:self action:@selector(utilityButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
        [utilView addSubview:button];
    }
}

- (void)createOutputSection {
    UIView *outputView = [[UIView alloc] initWithFrame:CGRectMake(20, 1510, self.view.frame.size.width - 40, 400)];
    outputView.backgroundColor = [UIColor systemGray5Color];
    outputView.layer.cornerRadius = 10;
    [self.contentView addSubview:outputView];
    
    UILabel *outputLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 10, outputView.frame.size.width - 40, 25)];
    outputLabel.text = @"Output Console";
    outputLabel.font = [UIFont boldSystemFontOfSize:18];
    [outputView addSubview:outputLabel];
    
    self.outputTextView = [[UITextView alloc] initWithFrame:CGRectMake(20, 45, outputView.frame.size.width - 40, 340)];
    self.outputTextView.backgroundColor = [UIColor blackColor];
    self.outputTextView.textColor = [UIColor greenColor];
    self.outputTextView.font = [UIFont fontWithName:@"Courier" size:12];
    self.outputTextView.editable = NO;
    self.outputTextView.layer.cornerRadius = 8;
    self.outputTextView.text = @"Mega iOS Toolbox Started\nReady for operations...\n";
    [outputView addSubview:self.outputTextView];
}

- (void)fileSystemButtonTapped:(UIButton *)sender {
    switch (sender.tag) {
        case 0: [self listDocuments]; break;
        case 1: [self showSystemInfo]; break;
        case 2: [self createTestFiles]; break;
        case 3: [self exploreParentDirs]; break;
    }
}

- (void)symlinkButtonTapped:(UIButton *)sender {
    switch (sender.tag) {
        case 0: [self createSymlinks]; break;
        case 1: [self testSandboxEscape]; break;
        case 2: [self cleanupSymlinks]; break;
    }
}

- (void)quizButtonTapped:(UIButton *)sender {
    switch (sender.tag) {
        case 0: [self startQuiz]; break;
        case 1: [self nextQuestion]; break;
        case 2: [self submitAnswer]; break;
    }
}

- (void)utilityButtonTapped:(UIButton *)sender {
    switch (sender.tag) {
        case 0: [self showSystemInfo]; break;
        case 1: [self showDeviceStats]; break;
        case 2: [self networkTest]; break;
        case 3: [self clearOutput]; break;
    }
}

- (void)listDocuments {
    [self appendOutput:@"Listing Documents Directory..."];
    NSFileManager *fm = [NSFileManager defaultManager];
    NSString *docsPath = [self getDocumentsPath];
    NSError *error = nil;
    NSArray *contents = [fm contentsOfDirectoryAtPath:docsPath error:&error];
    if (contents) {
        [self appendOutput:[NSString stringWithFormat:@"Found %lu items:", (unsigned long)contents.count]];
        for (NSString *item in contents) {
            NSString *fullPath = [docsPath stringByAppendingPathComponent:item];
            BOOL isDir = NO;
            [fm fileExistsAtPath:fullPath isDirectory:&isDir];
            NSString *type = isDir ? @"📁" : @"📄";
            [self appendOutput:[NSString stringWithFormat:@"%@ %@", type, item]];
        }
    } else {
        [self appendOutput:[NSString stringWithFormat:@"Error: %@", error.localizedDescription]];
    }
}

- (void)showSystemInfo {
    [self appendOutput:@"=== SYSTEM INFORMATION ==="];
    UIDevice *device = [UIDevice currentDevice];
    [self appendOutput:[NSString stringWithFormat:@"Device: %@", device.model]];
    [self appendOutput:[NSString stringWithFormat:@"System: %@ %@", device.systemName, device.systemVersion]];
    [self appendOutput:[NSString stringWithFormat:@"Device Name: %@", device.name]];
    
    NSProcessInfo *processInfo = [NSProcessInfo processInfo];
    [self appendOutput:[NSString stringWithFormat:@"Processor Count: %ld", (long)processInfo.processorCount]];
    [self appendOutput:[NSString stringWithFormat:@"Physical Memory: %.2f GB", processInfo.physicalMemory / 1024.0 / 1024.0 / 1024.0]];
    
    NSFileManager *fm = [NSFileManager defaultManager];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docsPath = [paths firstObject];
    NSDictionary *attrs = [fm attributesOfFileSystemForPath:docsPath error:nil];
    if (attrs) {
        NSNumber *freeSize = attrs[NSFileSystemFreeSize];
        NSNumber *totalSize = attrs[NSFileSystemSize];
        [self appendOutput:[NSString stringWithFormat:@"Free Space: %.2f GB", freeSize.doubleValue / 1024.0 / 1024.0 / 1024.0]];
        [self appendOutput:[NSString stringWithFormat:@"Total Space: %.2f GB", totalSize.doubleValue / 1024.0 / 1024.0 / 1024.0]];
    }
}

- (void)createTestFiles {
    [self appendOutput:@"Creating test files..."];
    NSFileManager *fm = [NSFileManager defaultManager];
    NSString *testDir = [[self getDocumentsPath] stringByAppendingPathComponent:@"test_files"];
    NSError *error = nil;
    
    if (![fm fileExistsAtPath:testDir]) {
        [fm createDirectoryAtPath:testDir withIntermediateDirectories:YES attributes:nil error:&error];
    }
    
    for (int i = 1; i <= 5; i++) {
        NSString *filePath = [testDir stringByAppendingPathComponent:[NSString stringWithFormat:@"test%d.txt", i]];
        NSString *content = [NSString stringWithFormat:@"This is test file %d created at %@", i, [NSDate date]];
        [content writeToFile:filePath atomically:YES encoding:NSUTF8StringEncoding error:&error];
        if (!error) {
            [self appendOutput:[NSString stringWithFormat:@"Created: %@", [filePath lastPathComponent]]];
        }
    }
    [self appendOutput:@"Test files created successfully"];
}

- (void)exploreParentDirs {
    [self appendOutput:@"Exploring parent directories..."];
    NSString *currentPath = [self getDocumentsPath];
    NSFileManager *fm = [NSFileManager defaultManager];
    
    for (int i = 0; i < 4; i++) {
        currentPath = [currentPath stringByDeletingLastPathComponent];
        [self appendOutput:[NSString stringWithFormat:@"\nLevel %d: %@", i, currentPath]];
        
        NSError *error = nil;
        NSArray *contents = [fm contentsOfDirectoryAtPath:currentPath error:&error];
        if (contents) {
            NSArray *firstFew = [contents subarrayWithRange:NSMakeRange(0, MIN(5, contents.count))];
            for (NSString *item in firstFew) {
                [self appendOutput:[NSString stringWithFormat:@"  - %@", item]];
            }
            if (contents.count > 5) {
                [self appendOutput:[NSString stringWithFormat:@"  ... and %lu more", contents.count - 5]];
            }
        } else {
            [self appendOutput:[NSString stringWithFormat:@"  Access denied: %@", error.localizedDescription]];
        }
    }
}

- (void)createSymlinks {
    [self appendOutput:@"Creating symbolic links..."];
    NSFileManager *fm = [NSFileManager defaultManager];
    NSArray *targets = @[@"/var/mobile", @"/Applications", @"/usr", @"/var"];
    
    for (NSString *target in targets) {
        NSString *linkName = [NSString stringWithFormat:@"link_%@", [[target lastPathComponent] stringByReplacingOccurrencesOfString:@"/" withString:@""]];
        NSString *linkPath = [[self getDocumentsPath] stringByAppendingPathComponent:linkName];
        
        NSError *error = nil;
        if ([fm createSymbolicLinkAtPath:linkPath withDestinationPath:target error:&error]) {
            [self appendOutput:[NSString stringWithFormat:@"✅ Created: %@ -> %@", linkName, target]];
        } else {
            [self appendOutput:[NSString stringWithFormat:@"❌ Failed: %@ - %@", target, error.localizedDescription]];
        }
    }
}

- (void)testSandboxEscape {
    [self appendOutput:@"Testing sandbox escape..."];
    NSFileManager *fm = [NSFileManager defaultManager];
    NSArray *sensitivePaths = @[
        @"/var/mobile/Library/Caches",
        @"/var/root",
        @"/etc",
        @"/bin",
        @"/private/var"
    ];
    
    for (NSString *path in sensitivePaths) {
        NSError *error = nil;
        NSArray *contents = [fm contentsOfDirectoryAtPath:path error:&error];
        if (contents) {
            [self appendOutput:[NSString stringWithFormat:@"🎉 ACCESS GRANTED: %@ (%lu items)", path, (unsigned long)contents.count]];
        } else {
            [self appendOutput:[NSString stringWithFormat:@"🚫 ACCESS DENIED: %@ - %@", path, error.localizedDescription]];
        }
    }
}

- (void)cleanupSymlinks {
    [self appendOutput:@"Cleaning up symlinks..."];
    NSFileManager *fm = [NSFileManager defaultManager];
    NSString *docsPath = [self getDocumentsPath];
    NSError *error = nil;
    
    NSArray *contents = [fm contentsOfDirectoryAtPath:docsPath error:&error];
    for (NSString *item in contents) {
        if ([item hasPrefix:@"link_"]) {
            NSString *fullPath = [docsPath stringByAppendingPathComponent:item];
            [fm removeItemAtPath:fullPath error:&error];
            if (!error) {
                [self appendOutput:[NSString stringWithFormat:@"Deleted: %@", item]];
            }
        }
    }
    [self appendOutput:@"Cleanup completed"];
}

- (void)startQuiz {
    self.currentQuestion = 0;
    self.questionLabel.text = self.quizQuestions[0];
    [self appendOutput:@"Quiz started! Answer the questions."];
}

- (void)nextQuestion {
    self.currentQuestion = (self.currentQuestion + 1) % self.quizQuestions.count;
    self.questionLabel.text = self.quizQuestions[self.currentQuestion];
    [self appendOutput:@"Next question loaded"];
}

- (void)submitAnswer {
    NSString *correctAnswer = self.quizAnswers[self.currentQuestion];
    [self appendOutput:[NSString stringWithFormat:@"Correct answer: %@", correctAnswer]];
    
    int points = arc4random_uniform(10) + 1;
    self.gameScore += points;
    self.scoreLabel.text = [NSString stringWithFormat:@"Score: %ld", (long)self.gameScore];
    [self.defaults setInteger:self.gameScore forKey:@"GameScore"];
    [self appendOutput:[NSString stringWithFormat:@"+%d points! Total: %ld", points, (long)self.gameScore]];
}

- (void)startMemoryGame {
    [self appendOutput:@"Memory Game: Matching pairs"];
    NSArray *symbols = @[@"🐱", @"🐶", @"🐼", @"🐰", @"🐯", @"🐨"];
    self.memoryGameCards = [NSMutableArray arrayWithArray:symbols];
    [self.memoryGameCards addObjectsFromArray:symbols];
    
    for (NSUInteger i = 0; i < self.memoryGameCards.count; i++) {
        NSUInteger j = arc4random_uniform((uint32_t)(i + 1));
        [self.memoryGameCards exchangeObjectAtIndex:i withObjectAtIndex:j];
    }
    
    for (UIButton *button in self.gameButtons) {
        [button setTitle:@"?" forState:UIControlStateNormal];
        button.backgroundColor = [UIColor systemBlueColor];
        button.enabled = YES;
    }
    
    self.memoryGameFirstIndex = -1;
    self.memoryGameMatches = 0;
}

- (void)memoryCardTapped:(UIButton *)sender {
    NSInteger index = sender.tag;
    NSString *symbol = self.memoryGameCards[index];
    
    [sender setTitle:symbol forState:UIControlStateNormal];
    sender.backgroundColor = [UIColor systemYellowColor];
    
    if (self.memoryGameFirstIndex == -1) {
        self.memoryGameFirstIndex = index;
    } else {
        NSString *firstSymbol = self.memoryGameCards[self.memoryGameFirstIndex];
        
        for (UIButton *button in self.gameButtons) {
            button.enabled = NO;
        }
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            if ([firstSymbol isEqualToString:symbol]) {
                [sender setBackgroundColor:[UIColor systemGreenColor]];
                UIButton *firstButton = self.gameButtons[self.memoryGameFirstIndex];
                [firstButton setBackgroundColor:[UIColor systemGreenColor]];
                firstButton.enabled = NO;
                sender.enabled = NO;
                
                self.memoryGameMatches++;
                [self appendOutput:[NSString stringWithFormat:@"Match found! %@", symbol]];
                
                if (self.memoryGameMatches == 3) {
                    [self appendOutput:@"Memory Game Completed!"];
                    self.gameScore += 20;
                    self.scoreLabel.text = [NSString stringWithFormat:@"Score: %ld", (long)self.gameScore];
                    [self.defaults setInteger:self.gameScore forKey:@"GameScore"];
                }
            } else {
                [sender setTitle:@"?" forState:UIControlStateNormal];
                sender.backgroundColor = [UIColor systemBlueColor];
                UIButton *firstButton = self.gameButtons[self.memoryGameFirstIndex];
                [firstButton setTitle:@"?" forState:UIControlStateNormal];
                firstButton.backgroundColor = [UIColor systemBlueColor];
            }
            
            for (UIButton *button in self.gameButtons) {
                if ([button titleForState:UIControlStateNormal] != @"?") {
                    button.enabled = YES;
                }
            }
            
            self.memoryGameFirstIndex = -1;
        });
    }
}

- (void)startReactionTest {
    [self appendOutput:@"Reaction Test: Wait for GO then tap!"];
    self.timerLabel.text = @"Wait...";
    self.timerLabel.backgroundColor = [UIColor systemRedColor];
    
    double delay = (arc4random_uniform(30) + 10) / 10.0;
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delay * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.timerLabel.text = @"GO!";
        self.timerLabel.backgroundColor = [UIColor systemGreenColor];
        self.timerSeconds = 0;
        self.gameTimer = [NSTimer scheduledTimerWithTimeInterval:0.01 target:self selector:@selector(updateTimer) userInfo:nil repeats:YES];
    });
}

- (void)updateTimer {
    self.timerSeconds++;
    double seconds = self.timerSeconds / 100.0;
    self.timerLabel.text = [NSString stringWithFormat:@"%.2fs", seconds];
}

- (void)showDeviceStats {
    [self appendOutput:@"=== DEVICE STATISTICS ==="];
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenRect.size.width;
    CGFloat screenHeight = screenRect.size.height;
    CGFloat scale = [[UIScreen mainScreen] scale];
    
    [self appendOutput:[NSString stringWithFormat:@"Screen: %.0fx%.0f @%.0fx", screenWidth, screenHeight, scale]];
    [self appendOutput:[NSString stringWithFormat:@"Bounds: %@", NSStringFromCGRect(screenRect)]];
    
    UIUserInterfaceIdiom idiom = [[UIDevice currentDevice] userInterfaceIdiom];
    NSString *idiomString = @"Unknown";
    switch (idiom) {
        case UIUserInterfaceIdiomPhone: idiomString = @"iPhone"; break;
        case UIUserInterfaceIdiomPad: idiomString = @"iPad"; break;
        case UIUserInterfaceIdiomTV: idiomString = @"Apple TV"; break;
        case UIUserInterfaceIdiomCarPlay: idiomString = @"CarPlay"; break;
        default: break;
    }
    [self appendOutput:[NSString stringWithFormat:@"Device Type: %@", idiomString]];
    
    NSLocale *locale = [NSLocale currentLocale];
    [self appendOutput:[NSString stringWithFormat:@"Locale: %@", locale.localeIdentifier]];
    [self appendOutput:[NSString stringWithFormat:@"Language: %@", [[NSLocale preferredLanguages] firstObject]]];
}

- (void)networkTest {
    [self appendOutput:@"Testing network connectivity..."];
    NSURL *url = [NSURL URLWithString:@"https://www.apple.com"];
    NSURLSessionDataTask *task = [[NSURLSession sharedSession] dataTaskWithURL:url completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (error) {
            [self appendOutput:[NSString stringWithFormat:@"Network error: %@", error.localizedDescription]];
        } else {
            NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
            [self appendOutput:[NSString stringWithFormat:@"Network OK - Status: %ld", (long)httpResponse.statusCode]];
        }
    }];
    [task resume];
}

- (void)clearOutput {
    self.outputTextView.text = @"Output cleared\n";
    [self appendOutput:@"Ready for new operations..."];
}

- (void)themeChanged {
    self.isDarkMode = (self.themeControl.selectedSegmentIndex == 1);
    [self.defaults setBool:self.isDarkMode forKey:@"DarkMode"];
    [self applyTheme];
}

- (void)applyTheme {
    if (self.isDarkMode) {
        self.view.backgroundColor = [UIColor blackColor];
        self.outputTextView.backgroundColor = [UIColor blackColor];
        self.outputTextView.textColor = [UIColor greenColor];
    } else {
        self.view.backgroundColor = [UIColor whiteColor];
        self.outputTextView.backgroundColor = [UIColor whiteColor];
        self.outputTextView.textColor = [UIColor blackColor];
    }
}

- (void)appendOutput:(NSString *)text {
    dispatch_async(dispatch_get_main_queue(), ^{
        NSString *timestamp = [NSDateFormatter localizedStringFromDate:[NSDate date] dateStyle:NSDateFormatterNoStyle timeStyle:NSDateFormatterMediumStyle];
        self.outputTextView.text = [NSString stringWithFormat:@"%@[%@] %@\n", self.outputTextView.text, timestamp, text];
        NSRange range = NSMakeRange(self.outputTextView.text.length - 1, 1);
        [self.outputTextView scrollRangeToVisible:range];
    });
}

- (NSString *)getDocumentsPath {
    return NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject;
}

@end
