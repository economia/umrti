window.Stories = class Stories
    (@element, @buttonsElement, @curtain, @menu, @graphs, @stackedOrNotSelector, @details) ->
        @heading = @element.select \h1
        @content = @element.select \p
        closeBtn = @element.append \span
            ..attr \class \close
            ..html "x"
            ..attr \title "Schovat zajímavosti"
            ..on \click @~hide
        @lastId = 0
        @stackedOrNotInputs = @stackedOrNotSelector.formElement.selectAll \input
        @menuInputs = @menu.list.selectAll \input
        @drawButtons!
        @showStory 0
        @hidden = no

    hide: ->
        @hidden = yes
        @graphs.setHeight 600px
        @graphs.draw!
        @element.attr \class \hiding
        @curtain.hide!
        <~ setTimeout _, 800
        @element.attr \class \hidden

    unhide: ->
        @hidden = no
        @graphs.setHeight 470px
        @element.attr \class ""

    move: (dir) ->
        id = @lastId + dir
        len = @stories.length
        if id >= len
            id -= len
        if id < 0
            id += len
        @showStory id

    showStory: (id) ->
        @unhide! if @hidden
        @lastId = id
        @buttons.classed \active no
        d3.select @buttons[0][id] .classed \active yes
        @stories[id]bind(@)!

    setText: (heading, text) ->
        @content.html text + " "
        @content.append \a
            ..html "Další zajímavý bod &raquo;"
            ..attr \href \#
            ..on \click ~> @move +1
        @heading.html heading

    display: (...ids) ->
        @details.hide!
        if ids.length
            @menuInputs.each (d) ->
                @checked =
                    | d.id in ids => yes
                    | otherwise   => no
        else
            @menuInputs.each (d) -> @checked = no
        if @lastId != 16 # hack.. but too tired to think of a clean solution
            @graphs.currentMethod = \normal
            @stackedOrNotInputs.each ->
                @checked =
                    | @value == \stacked => no
                    | otherwise          => yes
        @menu.redraw!

    drawButtons: ->
        @buttonsElement.append \li
            ..attr \class "side back"
            ..html "&laquo; Zpět"
            ..on \click ~> @move -1

        @buttons = @buttonsElement.selectAll \li.story
            .data @stories
            .enter!append \li
                ..attr \class \story
                ..html (d, i) -> i + 1
                ..on \click (d, i) ~> @showStory i

        @buttonsElement.append \li
            ..attr \class "side forward"
            ..html "Dále &raquo;"
            ..on \click ~> @move +1

    stories:
        ->
            @setText "1. Tuberkulosa ústrojí dýchacího" "Čtrtinu úmrtí v roce 1919 měly na svědomí infekční nemoci. Mezi nimi dominovala vůbec nejobávanější meziválečná diagnóza: tuberkulóza. Nemoc o to děsivější, že na ni nejčastěji umírali děti a mladí lidé."
            @display 1 2 3
            @curtain.draw 1918 1921
        ->
            @setText "2. Proč přibývá rakoviny" "Rakovina nebyla ve dvacátých letech tak obávaná jako dnes, mohla nejvýš za každé desáté úmrtí. Dnes způsobuje každé čtvrté. Za nárůstem stojí z velké části zlepšení diagnostiky - tam, kde dřív lékaři zapisovali jako příčinu smrti stařeckou sešlost, jsou dnes obvykle přesnější příčiny - zejména nádory a nemoci srdce."
            @display 2 16
            @curtain.draw 1919 1933
        ->
            @setText "3. Obezita se stává rizikem" "V roce 1926 měly kardiovaskulární choroby poprvé víc obětí než tuberkulóza. Znamenalo to zlom pro vnímání obezity - zatímco u tuberkulózy nadváha bránila rozvoji nemoci, a lékaři se proto snažili některé pacienty přimět k tomu, aby přibrali, u nemocí oběhové soustavy šlo naopak o rizikový faktor."
            @display 1 2
            @curtain.draw 1925 1931
        ->
            @setText "4. Krize, zoufalství a sebevraždy" "Důsledky krachu na newyorské burze v říjnu 1929 záhy dospěly i do Evropy. Nástup hospodářské krize doprovázela všude po světě vlna sebevražd. V českých zemích vyvrcholila v roce 1934 číslem 4007 sebevrahů."
            @display 19
            @curtain.draw 1930 1935
        ->
            @setText "5. Statistika bez Němců" "Od odstoupení pohraničí Německu v září 1938 do konce roku 1946 jsou k dispozici čísla pouze pro území Protektorátu Čechy a Morava. Do statistik se nepočítají Sudety ani němečtí občané na zbytku území. V počtu úmrtí za válečné roky se tedy neobjevují vojenské ztráty ani odsun Němců na konci války. Chybí v nich také oběti koncentračních táborů (statistíce) a oběti nuceného nasazení (tisíce)."
            @display!
            @curtain.draw 1936 1939
        ->
            @setText "6. Oběti Heydrichiády" "27. května 1942 spáchali čeští a slovenští parašutisté úspěšný atentát na zastupujícího říšského protektora Heydricha. Následovala vlna zatýkání, mučení a poprav. Podle dostupných statistik zemřelo 1800 lidí; podle jiných zdrojů mělo stanné právo po Heydrichově smrti až pět tisíc obětí. Za celé období okupace bylo prokazatelně popraveno nejméně 8237 Čechů."
            @display 20
            @curtain.draw 1941 1943
        ->
            @setText "7. Bombardování a osvobozovací boje" "V letech 1944 a 1945 narostl počet obětí spojeneckého bombardování a osvobozeneckých bojů. Podle oficiálních statistik jich je přibližně 12 tisíc, dalších 1500 obětí - nejčastěji mladých mužů - zemřelo po poranění střelnou zbraní."
            @display 20
            @curtain.draw 1944 1946
        ->
            @setText "8. Antibiotika a antituberkulotika" 'Dostupnost antibiotik a antituberkulotik pomohla snížit výskyt infekčních chorob. Změnila se i věková struktura obětí tuberkulózy - umíralo na ni méně dětí a mladých lidí. Po roce 1948 přispěl k úbytku infekčních nemocí i systém dostupné lékařské péče a povinného očkování pro všechny, přezdívaný někdy "Gottwald care".'
            @curtain.draw 1946 1966
            @display 1
        ->
            @setText "9. Doly, lomy, úrazy" "V letech 1950 až 1954 přibylo úmrtí v důsledku nehody. Největší nárůst zaznamenaly nehody v dolech a lomech. Tábory nucených prací a pomocnými technickými prapory si po nástupu komunismu prošlo přes 40 tisíc lidí."
            @curtain.draw 1948 1954
            @display 17
        ->
            @setText "10. Změna klasifikace" "Zub v grafu v roce 1968 kupodivu nezpůsobila sovětská okupace, ale změna klasifikace. Konkrétně jde o přesun krvácení a embolie mozku z kategorie nervových onemocnění mezi oběhové nemoci. Podobná změna není ojedinělá - od roku 1919 se Mezinárodní statistická klasifikace nemocí měnila sedmkrát (1931, 1941, 1949, 1958, 1968, 1979 a 1994). Skokové změny tedy obvykle znamenají změnu číselníku, nikoliv reality."
            @curtain.draw 1966 1969
            @display 2 7
        ->
            @setText "11. Bůček, cigarety, infarkty" 'V polovině osmdesátých let dosáhl počet úmrtí na nemoci srdce maxima. Socialistickému lékařství se nedařilo jejich počet snížit, označila je tedy za "civilizační nemoci", nutně spojené s pokrokem. Kardiovaskulární nemoci jsou od té doby zodpovědné přibližně za polovinu všech úmrtí. Procento úmrtí na nemoci srdce se podařilo mírně snížit až po roce 2000.'
            @curtain.draw 1982 1987
            @display 2
        ->
            @setText "12. Havárie v Černobylu" "26. dubna 1986 došlo v ukrajinském Černobylu k výbuchu jaderné elektrárny, radioaktivní mrak následně zasáhl celou Evropu. Nárůst úmrtí na vrozené vady v roce 1988 může s nejhorší jadernou katastrofou souviset. V širším časovém horizontu je pokles vrozených vad po roce 1980 zřejmě způsoben kvalitnějším screeningem a diagnostikou plodu.   "
            @curtain.draw 1987 1989
            @display 15
        ->
            @setText "13. Bezpečnější Škoda Felicia " "V roce 1994 se začala vyrábět Felicia, první škodovka pod dohledem Volkswagenu, o poznání bezpečnější než předrevoluční Favorit. Ve stejném roce začaly klesat i počty úmrtí na silnicích. Dnes se počty mrtvých při dopravních nehodách přiblížily číslům z období první republiky."
            @curtain.draw 1993 1999
            @display 18
        ->
            @setText "14. Nejnižší úmrtnost dětí" "Na začátku 21. století se Česko dostalo mezi deset zemí světa s nejnižší dětskou a mateřskou úmrtností. Pravděpodobnost, že se u nás dítě nedožije pátých narozenin, je aktuálně 0,3%. Přitom ještě v roce 1950 byla 4,4%, v polovině devatenáctého století se pěti let nedožilo kolem dvaceti procent dětí. "
            @curtain.draw 1999 2003
            @display 14
        ->
            @setText "15. Návrat infekčních nemocí" "Ke konci dvacátého století se počet úmrtí na infekční nemoci - včetně tuberkulózy - snížil téměř na nulu. Po roce 2000 se jejich počet opět mírně zvýšil na současných přibližně tisíc úmrtí ročně. Lékaři to vysvětlují stoupající odolností zmutovaných virů vůči běžným antibiotikům a také častějšímu cestování do exotických zemí."
            @curtain.draw 2003 2006
            @display 1
        ->
            @setText "16. Absolutní a relativní čísla" "Tlačítky absolutní / relativní (nad seznamem nemocí) můžete přepínat mezi absolutním počtem mrtvých a poměrným zastoupením zvolené příčiny."
            @curtain.hide!
            @graphs.currentMethod = \stacked
            @stackedOrNotInputs.each ->
                @checked =
                    | @value == \stacked => yes
                    | otherwise          => no
            @display!



