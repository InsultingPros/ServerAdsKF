class UtilTest extends Object;

public final static function noLocalTest(ServerAdsKF mut) {
    local int i;
    local array<string> locarrres;
    local string s;

    for (i = 0; i < mut.skipPlayers.length; i += 1) {
        s = mut.skipPlayers[i];
        locarrres[locarrres.length] = s;
    }
}

public final static function LocalTest(ServerAdsKF mut) {
    local int i;
    local array<string> locarrres;
    local array<string> loccopy;
    local string s;

    loccopy = mut.skipPlayers;
    for (i = 0; i < loccopy.length; i += 1) {
        s = loccopy[i];
        locarrres[locarrres.length] = s;
    }
}

public final static function outLocalTest(out ServerAdsKF mut) {
    local int i, n;
    local array<string> locarr;

    locarr = mut.skipPlayers;
    for (i = 0; i < locarr.length; i += 1) {
        n += 1;
    }
}

public final static function outNoLocalTest(out ServerAdsKF mut) {
    local int i, n;

    for (i = 0; i < mut.skipPlayers.length; i += 1) {
        n += 1;
    }
}