# Data IHNED.cz

[Datablog](http://ihned.cz/data/) portálu [IHNED.cz](http://ihned.cz/) vydavatelství [e.conomia](http://economia.ihned.cz/)
ve spolupráci s oddělením vývoje redakčních technologií [IHNED.cz](http://ihned.cz/)

## Úmrtí v ČR ve 20. století

Stála víc životů heydrichiáda, nebo osvobození? Přibývá násilných úmrtí při změně politického režimu? O kolik vyrostl počet smrtelných autonehod oproti první republice? Jak se změnil poměr infekčních nemocí, nemocí srdce a nádorů?

http://data.blog.ihned.cz/c1-61442270-nemoci-nehody-i-valky-podivejte-se-na-co-cesi-ve-20-stoleti-umirali

### Data
Počty úmrtí jsou ve složce data/csv, resp. csv_normalized. V normalized jsou všechny CSV v UTF8 a oddělené čárkou.

CSV jsou děleny podle roku, pohlaví (koncovka *m* nebo *z* pro muže, resp. ženy) a od roku 1949 se osamostatňují smrti z externích příčin (typicky dopravní i jiné nehody).

V každém souboru je výpis skupin, podskupin a konkrétních diagnóz. Hierarchie je zaznamenána pouze vizuálně, prázdnými řádky.

V prvním sloupci je vždy kategorizace diagnózy dle v daném roce platného číselníku, dále její slovní popis, počet celkem zemřelých na danou diagnózu / skupinu diagnóz a počty zemřelých v jednotlivých věkových kategoriích.

Věkové kategorie, názvy diagnóz i jejich klasifikace do skupin se během let významně měnily, a to v letech 1931, 1941, 1949, 1958, 1968 a 1979.

Tyto změny se snaží postihnout soubor data/klic.csv, kde jsou vypsány kategorie nemocí a řádky, na kterých se mezi lety nacházely příslušné diagnózy, vždy ve fomátu od řádku-do řádku. Pokud se diagnózy vyskytovaly v rámci souboru nespojitě, jsou jednotlivá pásma spojená znaménkem +. Záznam 1-5+8-9+12 tedy znamená, že se diagnózy dané kategorie vyskytovaly na řádcích 1, 2, 3, 4, 5, 8, 9 a 12.

Soubory data/summary-both, men a women obsahují předpočítané součty úmrtí podle pohlaví ve sledovaných kategoriích.

### Instalace:

    npm install -g LiveScript
    npm install
    slake build

S dotazy a přípomínkami se obracejte na e-mail petr.koci@economia.cz.

Obsah je uvolněn pod licencí CC BY-NC-SA 3.0 CZ (http://creativecommons.org/licenses/by-nc-sa/3.0/cz/), tedy vždy uveďte autora, nevyužívejte dílo ani přidružená data komerčně a zachovejte licenci.
