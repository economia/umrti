window.Menu = class Menu
    (@parentElement, @graphs, @data) ->
        @form = @parentElement.append \form
        @list = @form.append \ul
        @manualMode = no
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
        @form.on \change ~>
            if not @manualMode
                for input in @list.selectAll \input .0
                    input.checked = no
                d3.event.target.checked = yes
                @manualMode = yes
            @list.classed \manual yes

            selectedIds = @elements.selectAll "input:checked"
                .map -> if it.0 then d3.select that .datum!.id else null
                .filter -> it

            idsToDraw =
                | selectedIds.length
                    selectedIds
                | otherwise
                    @manualMode = no
                    @list.classed \manual no
                    for input in @list.selectAll \input .0
                        input.checked = yes
                    @data.map (.id)
            @graphs.drawSelection idsToDraw
        <~ setTimeout _, 200

    highlight: (id) ->
        @elements.filter -> it.id == id
            .classed \active yes

    downlight: (id) ->
        @elements.filter -> it.id == id
            .classed \active no
