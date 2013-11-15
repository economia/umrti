window.Menu = class Menu
    (@parentElement, @graphs, @data) ->
        @elements = @parentElement.selectAll \li
            .data @data
            .enter!append \li
                ..append \span
                    ..attr \class \txt
                    ..html (.abbreviation)
                    ..attr \data-tooltip (.name)
                ..append \div
                    ..attr \class \line
                    ..append \div
                        ..style \background-color (.color)
                ..on \mouseover ~> @graphs.highlight it.id
                ..on \mouseout  ~> @graphs.downlight it.id
                ..on \click ~> @graphs.drawSingle it.id
    highlight: (id) ->
        @elements.filter -> it.id == id
            .classed \active yes

    downlight: (id) ->
        @elements.filter -> it.id == id
            .classed \active no
