
#import "ASNSString+SurrogatePair.h"

@implementation NSString (SurrogatePair)

- (NSArray *)extractSurrogatePairCharactersIn{
    NSMutableArray *characters = @[].mutableCopy;
    
    [self enumerateSubstringsInRange:NSMakeRange(0, self.length)
                               options:NSStringEnumerationByComposedCharacterSequences
                            usingBlock:^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop){
                                if(substringRange.length > 1 && ![characters containsObject:substring]){
                                    [characters addObject:substring];
                                }
                            }];
    
    return characters.count > 0 ? characters : nil;
}

@end