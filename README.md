# Server Ads KF

[![GitHub all releases](https://img.shields.io/github/downloads/InsultingPros/ServerAdsKF/total)](https://github.com/InsultingPros/ServerAdsKF/releases)

> **Warning** I released this under GPL3, as all my other mods, but I have to say this: if you decide to modify my code to remove all spam limits / disallow clients to control messages, you should burn in hell. Don't become one of those server owners, where people get 30 meaningless messages in 1 nanosecond, just to remind them "oh look I'm so cool, don't forget to join my discord, like my videos and donate to my feet".

Yet another chat spam mod? Nope, this is the only mod that allows clients to disable messages if desired. And the minimal message delay is 60 seconds.

![IMG](Docs/media/example.png)

## Features

- Set any amount of messages and color-tag pairs in [config file](Configs/ServerAdsKF.ini 'main config').
- Messages look clean in web admin, without unreadable characters.
- Add `#` character at the start of the message to show it in center of screen.
- Players can disable server ads for themselves.
- Doesn't allow massive chat spam (minimal message delay is 60 seconds).

List of `mutate` commands:

- **serverads enable** - enable messages for mutate caller.
- **serverads disable** - disable messages for mutate caller.
- **serverads delay** - change message delay (60 seconds minimum!).
- **serverads style** - change how ads are shown: loop, once, anytext_for_loop.
- **status** - print current settings.
- **credits** - who made this shit.

## Installation

```ini
ServerAdsKF.ServerAdsKF
```

## Building and Dependencies

Use [KF Compile Tool](https://github.com/InsultingPros/KFCompileTool) for easy compilation.

**EditPackages**

```ini
EditPackages=ServerAdsKF
```

## Credits

- [El Muerte](https://github.com/elmuerte) for original [ServerAdsSE](https://github.com/elmuerte/UT2003-ServerAdsSE).
- [DeeZNutZ](https://forums.tripwireinteractive.com/index.php?members/deeznutz.16749/) for [ServerAdsKF v101](https://forums.tripwireinteractive.com/index.php?threads/serveradskf-updated-for-kf-servers.40764/).
- My [old edit](https://web.archive.org/web/20200220070646/http://killingfloor.ru/xforum/threads/server-ads-kf-avto-soobschenija-v-chate-igry.3401/page-2#post-122522).
- [dkanus](https://github.com/dkanus) - for ideas and code-text review.
