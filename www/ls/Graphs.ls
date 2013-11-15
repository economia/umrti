window.Graphs = class Graphs
    (@parentElement, @menu, @yearRange, @data, {@width, @height}:options) ->
        @data .= slice 1 # remove totals

        @svg = @parentElement.append \svg
            ..attr \width @width
            ..attr \height @height
        @linesGroup = @svg.append \g
            ..attr \class \linesGroup
        @x = d3.scale.linear!
            ..domain @yearRange
            ..range [0 @width]
        @maxValue = -Infinity
        for {years}:category in @data
            for {normalized}:year in years
                if normalized > @maxValue
                    @maxValue = normalized

        @lines = @linesGroup.selectAll \g.line
            .data @data
            .enter!.append \g
                ..attr \class \line
                ..append \path

    draw: ->
        y = d3.scale.sqrt!
            ..domain [@maxValue, 0]
            ..range [0 @height]
        lineDef = d3.svg.line!
            ..x (point) ~> @x point.year
            ..y (point) ~> y point.normalized

        @lines.select \path
            ..attr \stroke (.color)
            ..attr \fill \none
            ..attr \d ~> lineDef it.years

    drawStacked: ->
        y = d3.scale.linear!
            ..domain [0 1]
            ..range [0 @height]

        @areaDef = d3.svg.area!
            ..x (point) ~> @x point.year
            ..y1 (point) ~> point.y0 + point.y
            ..y0 (point) ~> point.y0
        stack = d3.layout.stack!
            ..values (line) -> line.years
            ..x (point) ~> @x point.year
            ..y (point) ~> y point.normalized
            ..order \inside-out
        stack @data
        @lines.select \path
            ..attr \stroke (.color)
            ..attr \fill (.color)
            ..attr \d ~> @areaDef it.years
            ..on \mouseover ~> @menu.highlight it.id
            ..on \mouseout ~> @menu.downlight it.id

    highlight: (id) ->
        @lines.filter -> it.id == id
            .classed \active yes

    downlight: (id) ->
        @lines.filter -> it.id == id
            .classed \active no
