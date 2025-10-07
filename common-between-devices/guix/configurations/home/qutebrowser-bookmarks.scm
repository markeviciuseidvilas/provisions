;;; SPDX-License-Identifier: GPL-3.0-or-later
;;; Copyright © 2025 Eidvilas Markevičius <markeviciuseidvilas@gmail.com>

(use-modules (ice-9 popen)
             (ice-9 receive)
             (ice-9 string-fun)
             (ice-9 textual-ports)
             (json)
             (rnrs bytevectors)
             (srfi srfi-1)
             (web client))

(define %confidential-data
  (call-with-input-file (string-append %current-directory "/home/confidential-data.scm")
    read))

(define (origin-paths+titles->bookmarks origin origin-title paths+titles)
  (append (list (string-join (list origin origin-title)))
    (map (lambda (path+title)
           (let ((path (car path+title))
                 (title (cadr path+title)))
             (string-append origin "/" path " " origin-title " / " title)))
      paths+titles)))

(string-join
  (append
    '("http://edwardfeser.com"
      "http://kirtis.info"
      "http://litlogos.eu"
      "http://paulgraham.com"
      "http://reconquistapress.com"
      "http://retroknygos.lt"
      "http://satenai.lt")

    '("https://4chan.org"
      "https://4plebs.org"
      "https://9front.org"
      "https://aidai.eu"
      "https://aidas.lt"
      "https://alkas.lt"
      "https://alkonas.lt"
      "https://amazon.com"
      "https://angeluspress.org"
      "https://annas-archive.org"
      "https://antelopehillpublishing.com"
      "https://aquinas.cc"
      "https://arxiv.org"
      "https://ateitininkai.lt"
      "https://ateitis.lt"
      "https://atodangos.com"
      "https://austsaule.lv"
      "https://backloggd.com"
      "https://bernardinai.lt"
      "https://biblehub.com"
      "https://bibleref.com"
      "https://biblija.lt"
      "https://bisqwit.iki.fi"
      "https://britishpathe.com"
      "https://capcut.com"
      "https://captions.ai"
      "https://cat-v.org"
      "https://catenabible.com"
      "https://catholic.com"
      "https://catholicfidelity.com"
      "https://catholiclibrary.org"
      "https://ccel.org"
      "https://chatgpt.com"
      "https://christianbwagner.com"
      "https://christogenea.org"
      "https://classics.mit.edu"
      "https://contribee.com"
      "https://counter-currents.com"
      "https://ctmucommunity.org"
      "https://cutsinger.net"
      "https://cygwin.com"
      "https://deepl.com"
      "https://desuarchive.org"
      "https://discogs.com"
      "https://discord.com"
      "https://dominospizza.lt"
      "https://duckduckgo.com"
      "https://e-kinas.lt"
      "https://ekalba.lt"
      "https://elevenlabs.io"
      "https://epaveldas.lt"
      "https://esveikata.lt"
      "https://filmai.in"
      "https://fmhy.pages.dev"
      "https://forum.osdev.org"
      "https://forvo.com"
      "https://fsf.org"
      "https://fssp.com"
      "https://fssp.org"
      "https://fsspx.news"
      "https://fsspx.org"
      "https://geni.com"
      "https://gmail.com"
      "https://gornahoor.net"
      "https://gothicarchive.org"
      "https://gutenberg.org"
      "https://haydockcommentary.com"
      "https://holtz.org"
      "https://humanknowledge.net"
      "https://iep.utm.edu"
      "https://im1776.com"
      "https://imperiumpress.org"
      "https://incorectpolitic.com"
      "https://isidore.co"
      "https://john-uebersax.com"
      "https://jonathanbowden.org"
      "https://kaisiadoriuvyskupija.lt"
      "https://kalbi.lt"
      "https://karmelituparapija.lt"
      "https://katbib.lt"
      "https://katekizmas.lt"
      "https://kaunoarkivyskupija.lt"
      "https://kcromuva.lt"
      "https://kki.lt"
      "https://krikscioniuprofsajunga.lt"
      "https://kristoteka.lt"
      "https://kronikimyrtany.pl"
      "https://kuriulietuvai.lt"
      "https://laikmetis.lt"
      "https://lainchan.org"
      "https://laiskailietuviams.lt"
      "https://laisvavisuomene.lt"
      "https://last.fm"
      "https://legiunea.com"
      "https://libgen.is"
      "https://libgen.rs"
      "https://libgen.st"
      "https://lietuvai.lt"
      "https://limis.lt"
      "https://linkedin.com"
      "https://lituanistika.lt"
      "https://lkma.lt"
      "https://llvs.lt"
      "https://lrs.lt"
      "https://lrt.lt"
      "https://lukesmith.xyz"
      "https://lumalabs.ai"
      "https://lvk.lcn.lt"
      "https://lyricstranslate.com"
      "https://maceina.lt"
      "https://maldos.lt"
      "https://malduknyga.lt"
      "https://mally.stanford.edu"
      "https://maphub.net"
      "https://marijosradijas.lt"
      "https://massgrave.dev"
      "https://maypoleofwisdom.com"
      "https://mega.nz"
      "https://melskis.lt"
      "https://messenger.com"
      "https://metaphysicist.com"
      "https://militia-immaculatae.info"
      "https://militia-immaculatae.org"
      "https://miscarea.net/w"
      "https://modarchive.org"
      "https://morsecode.world"
      "https://newadvent.org"
      "https://newmanreader.org"
      "https://nonguix.org"
      "https://nyaa.si"
      "https://nzidinys.lt"
      "https://ocw.mit.edu"
      "https://office.com"
      "https://on.lt"
      "https://online.lt"
      "https://openlibrary.org"
      "https://opensubtitles.org"
      "https://outlook.com"
      "https://pakartot.lt"
      "https://paneveziovyskupija.lt"
      "https://partizanai.org"
      "https://patreon.com"
      "https://patriotfront.us"
      "https://peticijos.lt"
      "https://pildyk.lt"
      "https://pinesap.net"
      "https://pipedija.lt"
      "https://pixlr.com"
      "https://plato-dialogues.org"
      "https://plato.stanford.edu"
      "https://prodeoetpatria.lt"
      "https://project-mage.org"
      "https://propatria.lt"
      "https://qwant.com"
      "https://raštija.lt"
      "https://redketchup.io"
      "https://remove.bg"
      "https://returntotheland.org"
      "https://rofondas.lt"
      "https://romanianvoice.com"
      "https://rozancius.lt"
      "https://rutracker.org"
      "https://sacred-texts.com"
      "https://sanctamissa.org"
      "https://savitridevi.org"
      "https://sb.lt"
      "https://sci-hub.ru"
      "https://sci-hub.se"
      "https://sci-hub.st"
      "https://sena.lt"
      "https://serializd.com"
      "https://shanson-e.tk"
      "https://sheldrake.org"
      "https://siauliuvyskupija.lt"
      "https://sininearatus.ee"
      "https://skalvija.lt"
      "https://smetona.lt"
      "https://smnz.de"
      "https://sodra.lt"
      "https://spauda.org"
      "https://sr.ht"
      "https://sspx.org"
      "https://susivienijimas.lt"
      "https://swedbank.lt"
      "https://tautosakos-rankrastynas.lt"
      "https://telsiuvyskupija.lt"
      "https://temp-mailbox.com"
      "https://templeos.net"
      "https://templeos.org"
      "https://textboard.org"
      "https://thomisticmetaphysics.com"
      "https://tineye.com"
      "https://tradere.lt"
      "https://traditioninaction.org"
      "https://translate.fedoraproject.org"
      "https://truerestoration.org"
      "https://udio.com"
      "https://urbandictionary.com"
      "https://valstybingumas.com"
      "https://versme.lt"
      "https://vidzgiriobaznycia.lt"
      "https://vilkaviskiovyskupija.lt"
      "https://vilnensis.lt"
      "https://vle.lt"
      "https://vmi.lt"
      "https://vocalremover.org"
      "https://vydija.lt"
      "https://vydunodraugija.lt"
      "https://warosu.org"
      "https://web.postman.co"
      "https://wiby.me"
      "https://wiby.org"
      "https://wiki.c2.com"
      "https://wiki.osdev.org"
      "https://wikiart.org"
      "https://wikitree.com"
      "https://wolframalpha.com"
      "https://www-formal.stanford.edu"
      "https://www.vatican.va"
      "https://www.wga.hu"
      "https://zeitgeistreviews.com"
      "https://šaltiniai.info")

    (origin-paths+titles->bookmarks "https://archive.org" "Internet Archive"
      '(("details/@markeviciuseidvilas" "Profiliai / Eidvilas")
        ("details/@markeviciuseidvilas/lists" "Sąrašai / Eidvilas")))

    (map string-join
      '(("https://blogspot.com" "Blogger")
        ("https://bibliotecafascista.blogspot.com" "Blogger / Svetainės / Biblioteca Fascista")
        ("https://czc50.blogspot.com" "Blogger / Svetainės / Adevarul despre Corneliu Zelea Codreanu")
        ("https://don-colacho.blogspot.com" "Blogger / Svetainės / Don Colacho’s Aphorisms")
        ("https://edwardfeser.blogspot.com" "Blogger / Svetainės / Edward Feser")
        ("https://tautininkas.blogspot.com" "Blogger / Svetainės / Tomo Skorupskio blogas")
        ("https://thearmchairthomist.blogspot.com" "Blogger / Svetainės / The Armchair Thomist")
        ("https://thewaywardaxolotl.blogspot.com" "Blogger / Svetainės / The Wayward Axolotl")
        ("https://williamsonletters.blogspot.com" "Blogger / Svetainės / Bishop Williamson's Letters")))

    (origin-paths+titles->bookmarks "https://codeberg.org" "Codeberg"
      '(("markeviciuseidvilas" "Profiliai / Eidvilas Markevičius")))

    (origin-paths+titles->bookmarks "https://docsbot.ai" "DocsBot"
      '(("tools/image/text-extractor" "Įrankiai / Free AI Image to Text Extractor")))

    (origin-paths+titles->bookmarks "https://facebook.com" "Facebook"
      '(("?sk=h_chr" "Sklaidos kanalai")
        ("markeviciuseidvilas" "Profiliai / Eidvilas Markevičius")))

    (origin-paths+titles->bookmarks "https://fsspx.lt" "FSSPX Lietuva"
      '(("liturginis-kalendorius" "Liturginis kalendorius")
        ("maldos-ir-giesmes" "Maldos ir giesmės")
        ("pamaldu-tvarka-kaune" "Pamaldų tvarka Kaune")))

    (origin-paths+titles->bookmarks "https://github.com" "GitHub"
      '(("markeviciuseidvilas" "Profiliai / Eidvilas Markevičius")))

    (origin-paths+titles->bookmarks "https://gitlab.com" "GitLab"
      '(("markeviciuseidvilas" "Profiliai / Eidvilas Markevičius")))

    (map string-join
      '(("https://gnome.org" "GNOME")
        ("https://gitlab.gnome.org" "GNOME / GitLab")
        ("https://l10n.gnome.org" "GNOME / Damned Lies")
        ("https://wiki.gnome.org" "GNOME / Wiki")))

    (map string-join
      '(("https://gnu.org" "GNU")
        ("https://guix.gnu.org" "GNU / Guix")
        ("https://guix.gnu.org/blog" "GNU / Guix / Blog")
        ("https://guix.gnu.org/manual/devel/en/guix.html" "GNU / Guix / Reference Manual")
        ("https://guix.gnu.org/manual/devel/en/guix.html#Building-from-Git" "GNU / Guix / Reference Manual / Building from Git")
        ("https://guix.gnu.org/manual/devel/en/guix.html#Updating-the-Guix-Package" "GNU / Guix / Reference Manual / Updating the Guix Package")
        ("https://logs.guix.gnu.org" "GNU / Guix / IRC Channel Logs")
        ("https://savannah.gnu.org" "GNU / Savannah")))

    (origin-paths+titles->bookmarks "https://goodreads.com" "Goodreads"
      '(("markeviciuseidvilas" "Profiliai / Eidvilas Markevičius")))

    (origin-paths+titles->bookmarks "https://gog.com" "Good Old Games"
      '(("u/eidmar" "Profiliai / Eidvilas Markevičius")))

    (map string-join
      '(("https://google.com" "Google")
        ("https://docs.google.com" "Google Docs")
        ("https://drive.google.com" "Google Drive")
        ("https://fonts.google.com" "Google Fonts")
        ("https://gemini.google.com" "Google Gemini")
        ("https://groups.google.com" "Google Groups")
        ("https://images.google.com" "Google Images")
        ("https://mail.google.com" "Google Mail")
        ("https://maps.google.com" "Google Maps")
        ("https://scholar.google.com" "Google Scholar")
        ("https://translate.google.com" "Google Translate")))

    (origin-paths+titles->bookmarks "https://instagram.com" "Instagram"
      '(("eidvilas.markevicius" "Eidvilas Markevičius")))

    (map string-join
      '(("https://katalikai.lt" "Lietuvos Katalikų Bažnyčia")
        ("https://lk.katalikai.lt" "Lietuvos Katalikų Bažnyčia / Liturginis kalendorius")
        ("https://maldynas.katalikai.lt" "Lietuvos Katalikų Bažnyčia / Maldynas")
        ("https://paveldas.katalikai.lt" "Lietuvos Katalikų Bažnyčia / Lietuvos krikščioniškasis paveldas")
        ("https://vl.katalikai.lt" "Lietuvos Katalikų Bažnyčia / Valandų liturgija")))

    (origin-paths+titles->bookmarks "https://katalikutradicija.lt" "Katalikų Tradicija"
      '(("katekizmas" "Katekizmas")
        ("sv-misiu-tvarka" "Šv. Mišių tvarka")
        ("sventosios-misios/liturginiai-metai" "Liturginių metų šv. Mišios")))

    (map string-join
      '(("https://ktu.edu" "KTU")
        ("https://moodle.ktu.edu" "KTU / Moodle")))

    (map string-join
      '(("https://ktu.lt" "KTU")
        ("https://uais.cr.ktu.lt" "KTU / Akademinė informacinė sistema")))

    (origin-paths+titles->bookmarks "https://letterboxd.com" "Letterboxd"
      '(("eidvilas" "Profiliai / Eidvilas Markevičius")))

    (map string-join
      '(("https://metapedia.org" "Metapedia")
        ("https://en.metapedia.org" "Metapedia")))

    (origin-paths+titles->bookmarks "https://odysee.com" "Odysee"
      '(("@markeviciuseidvilas:3" "Kanalai / Eidvilas Markevičius")
        ("$/playlist/watchlater" "Grojaraščiai / Žiūrėti vėliau")))

    (origin-paths+titles->bookmarks "https://pinterest.com" "Pinterest"
      '(("markeviciuseidvilas" "Profiliai / Eidvilas Markevičius")))

    (origin-paths+titles->bookmarks "https://reddit.com" "Reddit"
      '(("u/markeviciuseidvilas" "Reddit / Profiliai / Eidvilas Markevičius")))

    (origin-paths+titles->bookmarks "https://restream.io" "Restream"
      '(("tools/transcribe-audio-to-text" "Įrankiai / Transcribe Audio to Text")
        ("tools/transcribe-video-to-text" "Įrankiai / Transcribe Video to Text")))

    (map string-join
      '(("https://softwareheritage.org" "Software Heritage")
        ("https://archive.softwareheritage.org" "Software Heritage Archive")))

    (origin-paths+titles->bookmarks "https://soundcloud.com" "SoundCloud"
      '(("markeviciuseidvilas" "Profiliai / Eidvilas Markevičius")))

    (origin-paths+titles->bookmarks "https://substack.com" "Substack"
      '(("@markeviciuseidvilas" "Profiliai / Eidvilas Markevičius")
        ("inbox" "Paštas")
        ("inbox/saved" "Paštas / Išsaugoti straipsniai")))

    (origin-paths+titles->bookmarks "https://tiktok.com" "TikTok"
      '(("@markeviciuseidvilas" "Profiliai / Eidvilas Markevičius")))

    (map string-join
      '(("https://wikipedia.org" "Wikipedia")
        ("https://en.wikipedia.org" "Wikipedia")
        ("https://la.wikipedia.org" "Vicipaedia")
        ("https://lt.wikipedia.org" "Vikipedija")
        ("https://lv.wikipedia.org" "Vikipēdija")))

    (map string-join
      '(("https://wikiquote.org" "Wikiquote")
        ("https://en.wikiquote.org" "Wikiquote")
        ("https://la.wikiquote.org" "Vicicitatio")
        ("https://lt.wikiquote.org" "Vikicitatos")
        ("https://lv.wikiquote.org" "Vikicitāti")))

    (map string-join
      '(("https://wikisource.org" "Wikisource")
        ("https://en.wikisource.org" "Wikisource")
        ("https://la.wikisource.org" "Vicifons")
        ("https://lt.wikisource.org" "Vikišaltiniai")
        ("https://lv.wikisource.org" "Vikiavoti")))

    (map string-join
      '(("https://wiktionary.org" "Wiktionary")
        ("https://en.wiktionary.org" "Wiktionary")
        ("https://la.wiktionary.org" "Victionarium")
        ("https://lt.wiktionary.org" "Vikižodynas")
        ("https://lv.wiktionary.org" "Vikivārdnīca")))

    (map string-join
      '(("https://wordpress.com" "WordPress")
        ("https://catholicgnosis.wordpress.com" "WordPress / Svetainės / Christian Platonism")
        ("https://isabelavs2.wordpress.com" "WordPress / Svetainės / Isabela Vasiliu-Scraba")
        ("https://thinkingthroughthesumma.wordpress.com" "WordPress / Svetainės / The Scholastic Tradition in the Modern World")))

    (origin-paths+titles->bookmarks "https://x.com" "X"
      '(("eidmar_" "Profiliai / Eidvilas Markevičius")))

    (map string-join
      '(("https://youtube.com" "YouTube")
        ("https://youtube.com/channel/UCjoBZHz5QXR23nWwy9Jw80Q" "YouTube / Kanalai / Eidvilas Markevičius")))

    (let loop ((page-token #f) (accumulated-bookmarks '()))
      (let ((request-url
              (string-append
                "https://www.googleapis.com/youtube/v3/subscriptions?channelId=UCjoBZHz5QXR23nWwy9Jw80Q"
                "&part=snippet"
                "&maxResults=50"
                "&key=" (assoc-ref %confidential-data "www.googleapis.com:api-keys:key1")
                (if page-token (string-append "&pageToken=" page-token) ""))))
        (receive (header body) (http-request request-url)
          (let* ((parsed-body (json-string->scm (utf8->string body)))
                 (next-page-token (assoc-ref parsed-body "nextPageToken"))
                 (items (vector->list (assoc-ref parsed-body "items")))
                 (bookmarks
                   (map (lambda (item)
                          (let* ((snippet (assoc-ref item "snippet"))
                                 (resource-id (assoc-ref snippet "resourceId"))
                                 (channel-id (assoc-ref resource-id "channelId"))
                                 (title (assoc-ref snippet "title")))
                            (string-join
                              (list (string-append "https://youtube.com/channel/" channel-id)
                                    (string-append "YouTube / Kanalai / " title)))))
                     items)))
            (if next-page-token
              (loop next-page-token (append accumulated-bookmarks bookmarks))
              (append accumulated-bookmarks bookmarks))))))

    (map string-join
      '(("https://youtube.com/feed/playlists" "YouTube / Grojaraščiai")
        ("https://youtube.com/playlist?list=LL" "YouTube / Grojaraščiai / Patikę vaizdo įrašai")
        ("https://youtube.com/playlist?list=WL" "YouTube / Grojaraščiai / Žiūrėti vėliau")))

    (string-split
      (string-replace-substring
        (get-string-all
          (open-input-pipe
            (string-join
              '("yt-dlp"
                "--skip-download"
                "--flat-playlist"
                "--print '%(url)s YouTube / Grojaraščiai / %(playlist_uploader)s / %(title)s'"
                "https://youtube.com/channel/UCjoBZHz5QXR23nWwy9Jw80Q/playlists"))))
        "https://www." "https://")
      #\newline)

    (origin-paths+titles->bookmarks "https://music.youtube.com" "YouTube Music"
      '(("library" "Fonoteka")
        ("library/albums" "Fonoteka / Albumai")
        ("library/artists" "Fonoteka / Atlikėjai")
        ("library/playlists" "Fonoteka / Grojaraščiai")
        ("library/podcasts" "Fonoteka / Tinklalaidės")
        ("library/songs" "Fonoteka / Dainos"))))
  "\n")
