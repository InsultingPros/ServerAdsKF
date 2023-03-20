class UtilTest extends Object;

public final static function noLocalTest(ServerAdsKF mut) {
    local int i, n;

    for (i = 0; i < mut.skipPlayers.length; i += 1) {
        n += 1;
    }
}

public final static function LocalTest(ServerAdsKF mut) {
    local int i, n;
    local array<string> locarr;

    locarr = mut.skipPlayers;
    for (i = 0; i < locarr.length; i += 1) {
        n += 1;
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