window.Menu = class Menu
    (@parentElement, @graphs, @data) ->
        @form = @parentElement.append \form
        @list = @form.append \ul
        idGenerator = -> "menuItem-#{it.id}"
        @elements = @list.selectAll \li
            .data @data
            .enter!append \li
                ..append \input
                    ..attr \type \checkbox
                    ..attr \checked \checked
                    ..attr \id idGenerator
                ..append \label
                    ..attr \for idGenerator
                    ..attr \data-tooltip (.name)
                    ..append \span
                        ..attr \class \txt
                        ..html (.abbreviation)
                    ..append \span
                        ..attr \class \line
                        ..append \span
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
