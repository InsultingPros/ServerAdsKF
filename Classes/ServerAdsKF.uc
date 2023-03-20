// Purpose      : displaying messages (advertisements) in every players console.
// Author       : Shtoyan
// Home repo    : https://github.com/InsultingPros/ServerAdsKF
// License      : https://www.gnu.org/licenses/gpl-3.0.en.html
class ServerAdsKF extends Mutator
    config(ServerAdsKF);

const VERSION="2.0.0";
enum AdDisplayStyle {
    RandomMessage,
    AllMessagesOnce,
    LoopMessages,
};

// service variables
var public transient array<PlayerController> allowedPlayers;
var private transient array<string> cachedColoredMessages;
var private transient array<string> cachedNormalizedMessages;
var private transient int cursor;
var public transient string BANNER;
var public transient int messageCount;

// config variables
var config AdDisplayStyle DisplayStyle; // how to show messages
var config float messageDelay;          // delay between a message in seconds
var config float AdminMsgDuration;      // seconds that an "admin" message will stay visible
var config array<string> Message;       // what messages to show
var config array<string> skipPlayers;   // people who do not want to see our messages

function PostBeginPlay() {
    BANNER = "^r^" $ class.outer.Name $ " ^w^version ^b^" $ VERSION;
    CheckDelay();
    CacheMessages();
    SetTimer(messageDelay, true);
    class'UtilInfoLines'.static.printStartUpInfo(self);
}

private final function CheckDelay() {
    messageDelay = fMax(messageDelay, 60);
    AdminMsgDuration = fMin(AdminMsgDuration, 10);
    SaveConfig();
}

private final function CacheMessages() {
    local int i;

    messageCount = Message.length;
    // pre color all messages
    for (i = 0; i < Message.length; i += 1) {
        cachedColoredMessages[i] = class'UtilityText'.static.ParseTags(Message[i]);
        cachedNormalizedMessages[i] = class'UtilityText'.static.NormalizeText(Message[i]);
    }
}

function bool CheckReplacement(Actor Other, out byte bSuperRelevant) {
    // at this moment we can get proper steamID's
    if (Other.IsA('KFSteamStatsAndAchievements')) {
        class'UtilityPlayers'.static.AddToAllowedList(PlayerController(other.owner), self);
    }
    return true;
}

function NotifyLogout(Controller Exiting) {
    class'UtilityPlayers'.static.RemoveFromAllowedList(Exiting, self);
    super.NotifyLogout(Exiting);
}

// broadcast the message
event Timer() {
    switch (DisplayStyle) {
        case RandomMessage:
            BroadcastText(rand(messageCount));
            break;
        case AllMessagesOnce:
            if (cursor >= messageCount) {
                break;
            }
            BroadcastText(cursor);
            cursor += 1;
            break;
        // if someone fuckup the config, just do the loop
        default:
            if (cursor >= messageCount) {
                cursor = 0;
            }
            BroadcastText(cursor);
            cursor += 1;
    }
}

function Mutate(string MutateString, PlayerController sender) {
    local int i;
    local array<string> wordsArray;
    local string command, mod;
    local array<string> modArray;

    super.Mutate(MutateString, sender);

    // https://github.com/InsultingPros/FakedPlus/blob/main/Classes/FakedPlus.uc
    // ignore empty cmds and dont go further
    Split(MutateString, " ", wordsArray);
    if (wordsArray.Length == 0) {
        return;
    }

    // do stuff with our cmd
    command = wordsArray[0];
    if (wordsArray.Length > 1) {
        mod = wordsArray[1];
    } else {
        mod = "";
    }

    while (i + 1 < wordsArray.Length || i < 10) {
        if (i + 1 < wordsArray.Length) {
            modArray[i] = wordsArray[i + 1];
        } else {
            modArray[i] = "";
        }
        i += 1;
    }

    if (command ~= "HELP" || command ~= "HLP" || command ~= "HALP") {
        class'UtilInfoLines'.static.printHelp(sender, self);
        return;
    } else if (command ~= "serverads") {
        if (mod ~= "style"){
            if (!class'UtilityPlayers'.static.bAdmin(sender)) {
                class'UtilInfoLines'.static.SendMessage(
                    sender,
                    self,
                    class'UtilInfoLines'.default.notAdminMsg
                );
                return;
            }
            if (wordsArray.length >=3) {
                SetAdStyle(sender, wordsArray[2]);
            } else {
                SetAdStyle(sender, "");
            }
            return;
        } else if (mod ~= "delay") {
            if (wordsArray.length >=3) {
                messageDelay = float(wordsArray[2]);
            } else {
                messageDelay = 50;
            }
            CheckDelay();
            class'UtilInfoLines'.static.SendMessage(
                sender,
                self,
                "^w^Message ^b^delay ^w^changed to: ^y^" $ messageDelay
            );
            return;
        } else if (mod ~= "disable") {
            class'UtilityPlayers'.static.TryAddToSkipList(sender, self);
            return;
        } else if (mod ~= "enable") {
            class'UtilityPlayers'.static.TryRemoveFromSkipList(sender, self);
            return;
        }
    } else if (command ~= "credits") {
        class'UtilInfoLines'.static.printCredits(sender, self);
    } else if (command ~= "status") {
        class'UtilInfoLines'.static.printStatus(sender, self);
    }
}

private function SetAdStyle(PlayerController pc, string style) {
    switch (style) {
        case "random":
        case "1":
            DisplayStyle = RandomMessage;
            break;
        case "once":
        case "2":
            DisplayStyle = AllMessagesOnce;
            break;
        default:
            DisplayStyle = LoopMessages;
    }

    // reset the cursor
    cursor = 0;
    class'UtilInfoLines'.static.SendMessage(
        pc,
        self,
        "^w^DisplayStyle changed to: ^y^" $ GetServerAdStyle()
    );
    SaveConfig();
}

public final function string GetServerAdStyle() {
    return string(GetEnum(enum'AdDisplayStyle', DisplayStyle));
}

// send message to everyone and save to server log file
function BroadcastText(int idx) {
    local Controller c;
    local PlayerController pc;
    local Color col;
    local bool bAllow;
    local string tmp;
    // local string HASH;
    local int i;

    // local float f;
    // Clock(f);

    for (c = level.controllerList; c != none; c = c.nextController) {
        if (!c.IsA('PlayerController')) {
            continue;
        }

        pc = PlayerController(C);
        bAllow = false;
        // this is the WebAdmin, send clean text to him
        if (c.IsA('MessagingSpectator')) {
            pc.teamMessage(none, cachedNormalizedMessages[idx], class.outer.Name);
            continue;
        }

        // check if this player wants to get messages
        for (i = 0; i < allowedPlayers.length; i++) {
            if (pc == allowedPlayers[i]) {
                bAllow = true;
                break;
            }
        }
        // not-cached variant
        // HASH = pc.GetPlayerIDHash();
        // for (i = 0; i < skipPlayers.length; i += 1) {
        //     if (HASH == skipPlayers[i]) {
        //         bSkipMe = true;
        //         continue;
        //     }
        // }
        if (!bAllow) {
            continue;
        }
        // else usual players, send colored text
        if (left(cachedNormalizedMessages[idx], 1) == "#") {
            tmp = right(cachedColoredMessages[idx], len(cachedColoredMessages[idx]) - 1);

            pc.ClearProgressMessages();
            pc.SetProgressTime(AdminMsgDuration);
            pc.SetProgressMessage(0, tmp, col);
        } else {
            pc.teamMessage(none, cachedColoredMessages[idx], class.outer.Name);
        }
    }
    // Unclock(f);
    // warn("execution time: " $ f);
}

defaultproperties {
    GroupName="KF-ServerAds"
    FriendlyName="Server Ads"
    Description="Show server messages in player chat."
}