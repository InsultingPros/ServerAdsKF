// Purpose      : Player list related stuff
// Author       : Shtoyan
// Home repo    : https://github.com/InsultingPros/ServerAdsKF
// License      : https://www.gnu.org/licenses/gpl-3.0.en.html
class UtilityPlayers extends Object
    abstract;

public static function TryAddToSkipList(PlayerController controllerToSkip, ServerAdsKF mut) {
    local string HASH;
    local bool hashAlreadyAdded;
    local int i;

    HASH = controllerToSkip.GetPlayerIDHash();
    for (i = 0; i < mut.skipPlayers.length; i += 1) {
        if (HASH == mut.skipPlayers[i]) {
            hashAlreadyAdded = true;
        }
    }
    // no further work required, he is already in the list
    if (hashAlreadyAdded) {
        return;
    }

    mut.skipPlayers[mut.skipPlayers.length] = HASH;
    mut.SaveConfig();
    RemoveFromAllowedList(controllerToSkip, mut);
    class'UtilInfoLines'.static.SendMessage(
        controllerToSkip,
        mut,
        class'UtilInfoLines'.default.clientDisableAdsMsg
    );
}

public static function TryRemoveFromSkipList(PlayerController controllerToRemove, ServerAdsKF mut) {
    local string HASH;
    local int i;

    HASH = controllerToRemove.GetPlayerIDHash();
    for (i = 0; i < mut.skipPlayers.length; i += 1) {
        if (HASH == mut.skipPlayers[i]) {
            mut.skipPlayers.Remove(i, 1);
            class'UtilInfoLines'.static.SendMessage(
                controllerToRemove,
                mut,
                class'UtilInfoLines'.default.clientEnableAdsMsg
            );
            mut.SaveConfig();
            AddToAllowedList(controllerToRemove, mut);
            return;
        }
    }
}

public static function AddToAllowedList(PlayerController pc, ServerAdsKF mut) {
    local string HASH;
    local bool hashAlreadyAdded;
    local int i;

    HASH = pc.GetPlayerIDHash();
    for (i = 0; i < mut.skipPlayers.length; i += 1) {
        if (HASH == mut.skipPlayers[i]) {
            hashAlreadyAdded = true;
            break;
        }
    }
    // this player doesn't want to be here, do nothing
    if (hashAlreadyAdded) {
        return;
    }

    mut.allowedPlayers[mut.allowedPlayers.length] = pc;
}

public static function RemoveFromAllowedList(Controller c, ServerAdsKF mut) {
    local PlayerController pc;
    local string HASH;
    local bool hashAlreadyAdded;
    local int i;

    if (!c.IsA('PlayerController')) {
        return;
    }

    pc = PlayerController(c);
    HASH = pc.GetPlayerIDHash();
    for (i = 0; i < mut.skipPlayers.length; i += 1) {
        if (HASH == mut.skipPlayers[i]) {
            hashAlreadyAdded = true;
            break;
        }
    }

    // he is already not in skip list, do nothing
    if (!hashAlreadyAdded) {
        return;
    }

    for (i = 0; i < mut.allowedPlayers.length; i += 1) {
        if (pc == mut.allowedPlayers[i]) {
            mut.allowedPlayers.Remove(i, 1);
            break;
        }
    }
}

public static function bool bAdmin(PlayerController pc) {
    local PlayerReplicationInfo pri;

    pri = pc.PlayerReplicationInfo;
    if (pri != none && pri.bAdmin)
        return true;

    // fallback
    return false;
}