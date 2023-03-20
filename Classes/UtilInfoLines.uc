// Purpose      : colored info messages!
// Author       : Shtoyan
// Home repo    : https://github.com/InsultingPros/ServerAdsKF
// License      : https://www.gnu.org/licenses/gpl-3.0.en.html
class UtilInfoLines extends Object
    abstract;

var public string clientDisableAdsMsg;
var public string clientEnableAdsMsg;
var public string notAdminMsg;

public final static function printStartUpInfo(ServerAdsKF mut) {
    log(
        "[StartUp] " $
        class'UtilityText'.static.StripTags(mut.BANNER) $
        " is active",
        mut.class.outer.Name
    );
    log(
        "> Number or messages: " $
        mut.messageCount $
        ", delay: " $
        mut.fDelay $
        ", broadcast style: " $
        mut.GetServerAdStyle(),
        mut.class.outer.Name
    );
}

// todo show this pc if is blocked from ads
public final static function printStatus(PlayerController pc, ServerAdsKF mut) {
    SendMessage(pc, mut, mut.BANNER $ " ^w^status");
    SendMessage(
        pc,
        mut,
        "^w^> Number or messages: ^y^" $
        mut.messageCount $
        "^w^, delay: ^y^" $
        mut.fDelay $
        "^w^, broadcast style: ^g^" $
        mut.GetServerAdStyle()
    );
}

public final static function printCredits(PlayerController pc, ServerAdsKF mut) {
    SendMessage(pc, mut, "^r^" $ mut.BANNER);
    SendMessage(pc, mut, "^w^> Author: ^b^NikC-");
    SendMessage(pc, mut, "^w^> Home Repo: github.com/InsultingPros/ServerAdsKF");
}

public final static function printHelp(PlayerController pc, ServerAdsKF mut) {
    SendMessage(pc, mut, "^r^" $ mut.BANNER $ " ^w^helper:");
    SendMessage(pc, mut, "^w^> Available mutate commands:");
    SendMessage(pc, mut, "    ^w^> ^y^serverads enable ^w^- enable messages for mutate caller.");
    SendMessage(pc, mut, "    ^w^> ^y^serverads disable ^w^- disable messages for mutate caller.");
    SendMessage(pc, mut, "    ^w^> ^y^serverads delay ^w^- change message delay (60 seconds minimum!).");
    SendMessage(pc, mut, "    ^w^> ^y^serverads style ^w^- change how ads are shown: ^g^loop^w^, ^g^once^w^, ^g^anytext_for_loop^w^.");
    SendMessage(pc, mut, "    ^w^> ^y^status ^w^- print current settings.");
    SendMessage(pc, mut, "    ^w^> ^y^credits ^w^- who made this shit.");
}

public final static function SendMessage(PlayerController pc, ServerAdsKF mut, coerce string text) {
    pc.teamMessage(none, class'UtilityTextPrivate'.static.ParseTags(text), mut.class.outer.Name);
}

defaultproperties {
    clientEnableAdsMsg="^w^You will now receive server ads. To disable them type ^y^`mutate serverads disable`^w^."
    clientDisableAdsMsg="^w^You will no longer receive server ads. To enable them type ^y^`mutate serverads enable`^w^."
    notAdminMsg="^w^This command requires ^r^admin rights^w^!"
}