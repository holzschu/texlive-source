/****************************************************************************\
 Part of the XeTeX typesetting system
 Copyright (c) 1994-2008 by SIL International
 Copyright (c) 2009 by Jonathan Kew
 Copyright (c) 2012, 2013 by Jiang Jiang

 SIL Author(s): Jonathan Kew

Permission is hereby granted, free of charge, to any person obtaining
a copy of this software and associated documentation files (the
"Software"), to deal in the Software without restriction, including
without limitation the rights to use, copy, modify, merge, publish,
distribute, sublicense, and/or sell copies of the Software, and to
permit persons to whom the Software is furnished to do so, subject to
the following conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
NONINFRINGEMENT. IN NO EVENT SHALL THE COPYRIGHT HOLDERS BE LIABLE
FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF
CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

Except as contained in this notice, the name of the copyright holders
shall not be used in advertising or otherwise to promote the sale,
use or other dealings in this Software without prior written
authorization from the copyright holders.
\****************************************************************************/

#ifdef __cplusplus
extern "C" {
#endif
#include <w2c/config.h>
#ifdef __cplusplus
}
#endif

#include "XeTeXFontMgr_Mac.h"

#ifndef __IPHONE__
#include <Cocoa/Cocoa.h>
#else
#import <Foundation/Foundation.h>
#import <Foundation/NSAutoreleasePool.h>
#import <CoreText/CoreText.h>
#import <CoreText/CTFontManager.h>
#import <CoreGraphics/CoreGraphics.h>
#import <CoreFoundation/CoreFoundation.h>
#import <UIKit/UiFont.h>
#endif

CTFontDescriptorRef findFontWithName(CFStringRef name, CFStringRef key)
{
    CFStringRef keys[] = { key };
    CFTypeRef values[] = { name };
    CFDictionaryRef attributes = CFDictionaryCreate(NULL, (const void **) &keys, (const void **) &values, 1,
        &kCFTypeDictionaryKeyCallBacks, &kCFTypeDictionaryValueCallBacks);
    CTFontDescriptorRef descriptor = CTFontDescriptorCreateWithAttributes(attributes);
    CFRelease(attributes);

    CFSetRef mandatoryAttributes = CFSetCreate(NULL, (const void **) &keys, 1, &kCFTypeSetCallBacks);
    CFArrayRef matches = CTFontDescriptorCreateMatchingFontDescriptors(descriptor, mandatoryAttributes);
    CFRelease(mandatoryAttributes);
    CFRelease(descriptor);

    CTFontDescriptorRef matched = NULL;
    if (matches) {
        if (CFArrayGetCount(matches)) {
            matched = (CTFontDescriptorRef) CFArrayGetValueAtIndex(matches, 0);
            CFRetain(matched);
        }
        CFRelease(matches);
    }
    return matched;
}

void
XeTeXFontMgr_Mac::appendNameToList(CTFontRef font,
                                   std::list<std::string>* nameList,
                                   CFStringRef nameKey)
{
    CFStringRef name = CTFontCopyName(font, nameKey);
    if (name) {
        appendToList(nameList, [(NSString *) name UTF8String]);
        CFRelease(name);
    }
    CFStringRef language;
    name = CTFontCopyLocalizedName(font, nameKey, &language);
    if (name) {
        appendToList(nameList, [(NSString *) name UTF8String]);
        CFRelease(name);
    }
}

XeTeXFontMgr::NameCollection*
XeTeXFontMgr_Mac::readNames(CTFontDescriptorRef fontRef)
{
    NameCollection* names = new NameCollection;

    CFStringRef psName = (CFStringRef) CTFontDescriptorCopyAttribute(fontRef, kCTFontNameAttribute);
    if (!psName)
        return names;

    NSAutoreleasePool *pool = [NSAutoreleasePool new];

    names->m_psName = [(NSString *) psName UTF8String];
    CFRelease(psName); 

    CTFontRef font = CTFontCreateWithFontDescriptor(fontRef, 0.0, 0);
    appendNameToList(font, &names->m_fullNames,   kCTFontFullNameKey);
    appendNameToList(font, &names->m_familyNames, kCTFontFamilyNameKey);
    appendNameToList(font, &names->m_styleNames,  kCTFontStyleNameKey);
    CFRelease(font);

    [pool release];

    return names;
}

void
XeTeXFontMgr_Mac::addFontsToCaches(CFArrayRef fonts)
{
    NSEnumerator* enumerator = [(NSArray*)fonts objectEnumerator];
    while (id aFont = [enumerator nextObject]) {
#ifndef __IPHONE__
        // get the name of the font. Either the first element of the NSArray (availableMembersOfFontFamily) or the element with fontNamesForFamilyName
		CTFontDescriptorRef fontRef = findFontWithName((CFStringRef)[aFont objectAtIndex: 0], kCTFontNameAttribute);
#else
		CTFontDescriptorRef fontRef = findFontWithName((CFStringRef)aFont, kCTFontNameAttribute);
#endif
        NameCollection* names = readNames(fontRef);
        addToMaps(fontRef, names);
        delete names;
    }
}

void
XeTeXFontMgr_Mac::addFamilyToCaches(CTFontDescriptorRef familyRef)
{
    CFStringRef nameStr = (CFStringRef) CTFontDescriptorCopyAttribute(familyRef, kCTFontFamilyNameAttribute);
    if (nameStr) {
#ifndef __IPHONE__
// availableMembersOfFontFamily returns and NSArray of NSArray
        NSArray* members = [[NSFontManager sharedFontManager]
                            availableMembersOfFontFamily: (NSString*)nameStr];
#else 
// fontNamesForFamilyName returns a NSArray of NSString
        NSArray* members = [UIFont fontNamesForFamilyName: (NSString*)nameStr];
#endif
        CFRelease(nameStr);
        addFontsToCaches((CFArrayRef)members);
    }
}

void
XeTeXFontMgr_Mac::addFontAndSiblingsToCaches(CTFontDescriptorRef fontRef)
{
    CFStringRef name = (CFStringRef) CTFontDescriptorCopyAttribute(fontRef, kCTFontNameAttribute);
    if (name) {
#ifndef __IPHONE__
        NSFont* font = [NSFont fontWithName:(NSString*)name size:10.0];
#else 
        UIFont* font = [UIFont fontWithName:(NSString*)name size:10.0];
#endif
        CFRelease(name);
#ifndef __IPHONE__
// availableMembersOfFontFamily returns and NSArray of NSArray
        NSArray* members = [[NSFontManager sharedFontManager]
                            availableMembersOfFontFamily: [font familyName]];
#else 
// fontNamesForFamilyName returns a NSArray of NSString
        NSArray* members = [UIFont fontNamesForFamilyName: [font familyName]];
#endif
                            
        addFontsToCaches((CFArrayRef)members);
    }
}

void
XeTeXFontMgr_Mac::searchForHostPlatformFonts(const std::string& name)
{
    // the name might be:
    //  FullName
    //  Family-Style (if there's a hyphen)
    //  PSName
    //  Family
    // ...so we need to try it as each of these

    CFStringRef nameStr = CFStringCreateWithCString(kCFAllocatorDefault, name.c_str(), kCFStringEncodingUTF8);
    CTFontDescriptorRef matched = findFontWithName(nameStr, kCTFontDisplayNameAttribute);
    if (matched) {
        // found it, so locate the family, and add all members to the caches
        addFontAndSiblingsToCaches(matched);
        CFRelease(matched);
        return;
    }

    int hyph = name.find('-');
    if (hyph > 0 && hyph < name.length() - 1) {
        std::string family(name.begin(), name.begin() + hyph);
        CFStringRef familyStr = CFStringCreateWithCString(kCFAllocatorDefault, family.c_str(), kCFStringEncodingUTF8);

#ifndef __IPHONE__
        NSArray* familyMembers = [[NSFontManager sharedFontManager]
                                  availableMembersOfFontFamily: (NSString*)familyStr];
#else 
        NSArray* familyMembers = [UIFont fontNamesForFamilyName: (NSString*)familyStr];
#endif

        if ([familyMembers count] > 0) {
            addFontsToCaches((CFArrayRef)familyMembers);
            return;
        }

        matched = findFontWithName(familyStr, kCTFontFamilyNameAttribute);
        if (matched) {
            addFamilyToCaches(matched);
            CFRelease(matched);
            return;
        }
    }
    
    matched = findFontWithName(nameStr, kCTFontNameAttribute);
    if (matched) {
        addFontAndSiblingsToCaches(matched);
        CFRelease(matched);
        return;
    }

#ifndef __IPHONE__
    NSArray* familyMembers = [[NSFontManager sharedFontManager]
                              availableMembersOfFontFamily: (NSString*)nameStr];
#else 
	NSArray* familyMembers = [UIFont fontNamesForFamilyName: (NSString*)nameStr];
#endif
                              
    if ([familyMembers count] > 0) {
        addFontsToCaches((CFArrayRef)familyMembers);
        return;
    }

    matched = findFontWithName(nameStr, kCTFontFamilyNameAttribute);
    if (matched) {
        addFamilyToCaches(matched);
        CFRelease(matched);
        return;
    }
}

NSAutoreleasePool* pool = NULL;

void
XeTeXFontMgr_Mac::initialize()
{
    pool = [[NSAutoreleasePool alloc] init];
}

void
XeTeXFontMgr_Mac::terminate()
{
    if (pool != NULL) {
        [pool release];
    }
}

std::string
XeTeXFontMgr_Mac::getPlatformFontDesc(PlatformFontRef descriptor) const
{
    std::string path;
    CTFontRef ctFont = CTFontCreateWithFontDescriptor(descriptor, 0.0, 0);
    if (ctFont) {
        CFURLRef url = NULL;
        /* iOS: CTFontGetPlatformFont is not defined on iOS */
#if !defined(__IPHONE__) && (!defined(MAC_OS_X_VERSION_10_6) || MAC_OS_X_VERSION_MIN_REQUIRED < MAC_OS_X_VERSION_10_6)
        /* kCTFontURLAttribute was not avialable before 10.6 */
        FSRef fsref;
        ATSFontRef atsFont = CTFontGetPlatformFont(ctFont, NULL);
        OSStatus status = ATSFontGetFileReference(atsFont, &fsref);
        if (status == noErr)
            url = CFURLCreateFromFSRef(NULL, &fsref);
#else
        url = (CFURLRef) CTFontCopyAttribute(ctFont, kCTFontURLAttribute);
#endif
        if (url) {
            UInt8 posixPath[PATH_MAX];
            if (CFURLGetFileSystemRepresentation(url, true, posixPath, PATH_MAX)) {
                path = (char*)posixPath;
            }
            CFRelease(url);
        }
        CFRelease(ctFont);
    }
    if (path.length() == 0)
        path = "[unknown]";
    return path;
}
