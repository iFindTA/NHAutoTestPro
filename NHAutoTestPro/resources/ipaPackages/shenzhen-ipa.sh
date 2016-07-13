#https://github.com/nomad/shenzhen
$ ipa

Build and distribute iOS apps (.ipa files)

  Commands:
    build                       Create a new .ipa file for your app
    distribute:rivierabuild     Distribute an .ipa file over [RivieraBuild](http://rivierabuild.com)
    distribute:hockeyapp        Distribute an .ipa file over HockeyApp
    distribute:crashlytics      Distribute an .ipa file over Crashlytics
    distribute:deploygate       Distribute an .ipa file over deploygate
    distribute:firim            Distribute an .ipa file over fir.im
    distribute:itunesconnect    Upload an .ipa file to iTunes Connect for review
    distribute:pgyer            Distribute an .ipa file over Pgyer
    distribute:ftp              Distribute an .ipa file over FTP
    distribute:s3               Distribute an .ipa file over Amazon S3
    distribute:testfairy        Distribute an .ipa file over TestFairy
    info                        Show mobile provisioning information about an .ipa file
    help                        Display global or [command] help documentation.

  Global Options:
    -h, --help           Display help documentation
    -v, --version        Display version information
    -t, --trace          Display backtrace when an error occurs

#蒲公英
USER_KEY="2e0b4563271252509e18fd65327188ee"
API_KEY="2373bda2728f38d435e6a5d53a2bacc4"

#执行ipa build命令时生成的ipa是根据当前工程的配置生成的