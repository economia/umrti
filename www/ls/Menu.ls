window.Menu = class Menu
    (@parentElement, @data) ->
        @parentElement.selectAll \li
            .data @data
            .enter!append \li
                ..append \span
                    ..attr \class \txt
                    ..html (.abbreviation)
                ..append \div
                    ..attr \class \line
                    ..append \div
                        ..style \background-color (.color)
