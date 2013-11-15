window.Menu = class Menu
    (@parentElement, @data) ->
        @elements = @parentElement.selectAll \li
            .data @data
            .enter!append \li
                ..append \span
                    ..attr \class \txt
                    ..html (.abbreviation)
                ..append \div
                    ..attr \class \line
                    ..append \div
                        ..style \background-color (.color)
    highlight: (id) ->
        @elements.filter -> it.id == id
            .classed \active yes

    downlight: (id) ->
        @elements.filter -> it.id == id
            .classed \active no
