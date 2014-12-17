//
//  ViewController.m
//  BuildCoreDataStore
//
//  Created by Steven Shatz on 12/16/14.
//  Copyright (c) 2014 Steven Shatz. All rights reserved.
//

#import "ViewController.h"
#import "CoreDataCompany.h"
#import "CoreDataProduct.h"


@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initModelContext];
    
    [self loadInitialData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark --- Core Data setup

// self.model = Managed Object Model
// psc = Persistent Store Coordinator
// path = String showing path and name to SQL database (used by Core Data)
// storeURL = URL version of path
// self.context = Managed Object Model Context

- (void)initModelContext {
    
    [self setModel:[NSManagedObjectModel mergedModelFromBundles:nil]];
    // looks up all models in the specified bundles and merges them; if nil is specified as argument, uses the main bundle
    
    NSPersistentStoreCoordinator *psc = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self model]];
    
    NSString *path = [self archivePath];            // returns path to our CoreData database (see below)
    
    NSLog(@"Data Store is located at:\n%@\n", [path description]);
    
    NSURL *storeURL = [NSURL fileURLWithPath:path]; // convert path to a URL
    
    NSError *error = nil;
    
    if (![psc addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        
        // Adds the store at the specified URL (of the specified type) to the coordinator with the model configuration and options.
        //  The configuration can be nil -- then it's the complete model; storeURL is usually the file location of the database
        //
        //  We are using a SQLite store type -- NSSQLiteStoreType
        //
        // optons: A dictionary containing key-value pairs that specify whether the store should be read-only, and whether (for an XML store)
        //  the XML file should be validated against the DTD (Document Type Definition) before it is read. For key definitions,
        //  see “Store Options” and “Migration Options”. This value may be nil.
        
        [NSException raise:@"Open failed" format:@"Reason: %@", [error localizedDescription]];
    }
    
    [self setContext:[[NSManagedObjectContext alloc] init]];
    
    self.context.undoManager = [[NSUndoManager alloc] init];
    
    [[self context] setPersistentStoreCoordinator:psc];
}

- (NSString *)archivePath {
    
    NSArray *documentsDirectories = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    // returns array of current user's |documents| directories (but there's probably only one)
    
    NSString *documentsDirectory = [documentsDirectories objectAtIndex:0];  // point to current user's |documents| directory
    
    return [documentsDirectory stringByAppendingPathComponent:@"CompaniesProducts.data"];   // full path to our CoreData database}
}


// ************************
// * Add and Save To Disk *
// ************************

#pragma mark --- Core Data Actions

- (void)loadInitialData {
    
    // Companies
    
    [self createCompanyWithName:@"Apple" logo:@"AppleLogo.jpeg" stockSymbol:@"AAPL" sortID:0];
    [self createCompanyWithName:@"Samsung" logo:@"SamsungLogo.jpeg" stockSymbol:@"SSNLF" sortID:1];
    [self createCompanyWithName:@"Microsoft" logo:@"MicrosoftLogo.png" stockSymbol:@"MSFT" sortID:2];
    [self createCompanyWithName:@"Everything" logo:@"EverythingLogo.png" stockSymbol:@"EVRY" sortID:3];
    
    // Products
    
    [self createProductWithName:@"iPad Air" forCompany:@"Apple" logo:@"iPadAir.png" url:@"https://www.apple.com/ipad-air-2/" sortID:0];
    [self createProductWithName:@"iPod Touch" forCompany:@"Apple" logo:@"iPodTouch.jpeg" url:@"https://www.apple.com/ipod-touch/" sortID:1];
    [self createProductWithName:@"iPhone 6" forCompany:@"Apple" logo:@"iPhone6.jpeg" url:@"https://www.apple.com/iphone-6/" sortID:2];
    
    [self createProductWithName:@"Galaxy S4" forCompany:@"Samsung" logo:@"GalaxyS4.jpeg" url:@"http://www.samsung.com/global/microsite/galaxys4/" sortID:3];
    [self createProductWithName:@"Galaxy Note" forCompany:@"Samsung" logo:@"GalaxyNote.png" url:@"http://www.samsung.com/global/microsite/galaxynote4/note4_main.html" sortID:4];
    [self createProductWithName:@"Galaxy Tab" forCompany:@"Samsung" logo:@"GalaxyTab.jpeg" url:@"http://www.samsung.com/us/mobile/galaxy-tab/SM-T230NZWAXAR" sortID:5];
    
    [self createProductWithName:@"Windows Phone 8" forCompany:@"Microsoft" logo:@"WindowsPhone.jpeg" url:@"http://www.windowsphone.com/en-us" sortID:6];
    [self createProductWithName:@"Surface Pro 3 Tablet" forCompany:@"Microsoft" logo:@"SurfacePro.png" url:@"http://www.microsoft.com/surface/en-us/products/surface-pro-2" sortID:7];
    [self createProductWithName:@"Lumia 1520" forCompany:@"Microsoft" logo:@"Lumia.png" url:@"http://www.expansys-usa.com/nokia-lumia-1520-unlocked-32gb-yellow-rm-937-255929/" sortID:8];

    [self createProductWithName:@"The I Can't Believe It's An Everything Tablet" forCompany:@"Everything" logo:@"EverythingTablet.png" url:@"http://instagram.com/everythingtablet" sortID:9];
    [self createProductWithName:@"TThe Amazing Everything Phone" forCompany:@"Everything" logo:@"EverythingPhone.jpg" url:@"http://everything.me" sortID:10];
    [self createProductWithName:@"The Holds Everything 100TB Music Player" forCompany:@"Everything" logo:@"EverythingMusicPlayer.png" url:@"http://www.umplayer.com" sortID:11];
    
}

// **************************************
// * Create Company and Product Objects *
// **************************************

#pragma mark --- Data operations

- (void)createCompanyWithName:(NSString *)coName logo:(NSString *)coLogo stockSymbol:(NSString *)coStockSymbol sortID:(int)coSortID {
    
    CoreDataCompany *company = [NSEntityDescription insertNewObjectForEntityForName:@"Company" inManagedObjectContext:[self context]];
    
    [company setCo_name:coName];
    [company setCo_logo:coLogo];
    [company setCo_stocksymbol:coStockSymbol];
    [company setCo_deleted:NO];
    [company setCo_sortid:[NSNumber numberWithInt:coSortID]];
    
    NSLog(@"\nAbout to save Company name: %@, logo: %@, stock symbol: %@, sortID: %d ...", coName, coLogo, coStockSymbol, coSortID);
    
    [self saveData];
}

- (void)createProductWithName:(NSString *)prodName forCompany:(NSString *)prodCompanyName logo:(NSString *)prodLogo url:(NSString *)prodURL sortID:(int)prodSortID {
    
    CoreDataProduct *product = [NSEntityDescription insertNewObjectForEntityForName:@"Product" inManagedObjectContext:[self context]];
    
    [product setProd_name:prodName];
    [product setProd_name:prodCompanyName];
    [product setProd_logo:prodLogo];
    [product setProd_url:prodURL];
    [product setProd_deleted:NO];
    [product setProd_sortid:[NSNumber numberWithInt:prodSortID]];
    
    NSLog(@"\nAbout to save Product name: %@, for company: %@, logo: %@, url: %@, sortID: %d ...", prodName, prodCompanyName, prodLogo, prodURL, prodSortID);

    [self saveData];
}

- (void)saveData {
    NSError *err = nil;
    
    BOOL successful = [[self context] save:&err];
    
    if (successful) {
        NSLog(@"... Data Saved\n");
    } else {
        NSLog(@"... Error saving data to Persistent Store: %@\n", [err localizedDescription]);
    }
}


@end
