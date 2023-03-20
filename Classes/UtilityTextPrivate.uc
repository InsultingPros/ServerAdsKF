// Purpose      : holds random utilitary functions for private functions
// Author       : Shtoyan
// Home repo    : https://github.com/InsultingPros/ServerAdsKF
// License      : https://www.gnu.org/licenses/gpl-3.0.en.html
class UtilityTextPrivate extends object
    abstract;

// ==========================================================================
struct ColorRecord {
    var string Name;    // color name, for comfort
    var string Tag;     // color tag
    var color Color;    // RGBA values
};
var config array<ColorRecord> privateColorList;    // color list

// caching
var private transient bool bInit;
var private transient array<string> cachedTags;
var private transient array<string> cachedColoredStrings;

// ==========================================================================
// main function that colors strings from user defined tags / color structs
// converts color tags to colors

final static function Init() {
    local int i;

    if (!default.bInit) {
        for (i = 0; i < default.privateColorList.Length; i++) {
            default.cachedTags[i] = default.privateColorList[i].Tag;
            default.cachedColoredStrings[i] = class'GameInfo'.static.MakeColorCode(default.privateColorList[i].Color);
        }
        default.bInit = true;
        // log(">>>>>>>>>> All tags and colored strings cached!");
    }
}

final static function string ParseTags(string input) {
    local int i;

    if (!default.bInit) {
        Init();
    }

    for (i = 0; i < default.privateColorList.Length; i++) {
        ReplaceText(input, default.cachedTags[i], default.cachedColoredStrings[i]);
    }
    return input;
}

// remove all user defined tags, aka ^1^, #4#, etc.
final static function string StripTags(string input) {
    local int i;

    for (i = 0; i < default.privateColorList.length; i++) {
        ReplaceText(input, default.privateColorList[i].tag, "");
    }
    return input;
}

// Engine.GameInfo
// removes colors from a string
final static function string StripColor(string s) {
    local int p;

    p = InStr(s, chr(27));

    while (p >= 0) {
        s = left(s, p) $ mid(S, p + 4);
        p = InStr(s, Chr(27));
    }
    return s;
}

// remove both tags and colors
final static function string NormalizeText(string input) {
    input = StripColor(input);
    input = StripTags(input);

    return input;
}

defaultproperties {
    privateColorList(0)=(Name="Red",Tag="^r^",Color=(R=255))
    privateColorList(1)=(Name="Orange",Tag="^o^",Color=(R=200,G=77))
    privateColorList(2)=(Name="Yellow",Tag="^y^",Color=(R=255,G=255))
    privateColorList(3)=(Name="Green",Tag="^g^",Color=(R=50,G=200,B=50))
    privateColorList(4)=(Name="Blue",Tag="^b^",Color=(G=100,B=200))
    privateColorList(5)=(Name="Neon Blue",Tag="^nb^",Color=(G=150,B=200))
    privateColorList(6)=(Name="Cyan",Tag="^c^",Color=(G=255,B=255))
    privateColorList(7)=(Name="Violet",Tag="^v^",Color=(R=255,B=139))
    privateColorList(8)=(Name="Pink",Tag="^p^",Color=(R=255,G=192,B=203))
    privateColorList(9)=(Name="White",Tag="^w^",Color=(R=255,G=255,B=255))
    privateColorList(10)=(Name="Black",Tag="^bl^",Color=(R=1,G=1,B=1))
    privateColorList(11)=(Name="Gray",Tag="^gr^",Color=(R=96,G=96,B=96))
}