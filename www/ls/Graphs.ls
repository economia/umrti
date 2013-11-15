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

        @maxValue = -Infinity
        for {years}:category in @data
            for {value}:year in years
                if value > @maxValue
                    @maxValue = value

        @lines = @linesGroup.selectAll \g.line
            .data @data
            .enter!.append \g
                ..attr \class \line
                ..append \path
                    ..attr \stroke (.color)

    draw: ->
        @x.range [3 @width]
        @parentElement.classed \hoverOn off
        y = d3.scale.sqrt!
            ..domain [@maxValue, 0]
            ..range [10 @height]
        lineDef = d3.svg.line!
            ..x (point) ~> @x point.year
            ..y (point) ~> y point.value

        @lines.select \path
            ..on \mouseover ~>
                @parentElement.classed \hoverOn on
                @menu.highlight it.id
            ..on \mouseout ~>
                @parentElement.classed \hoverOn off
                @menu.downlight it.id
            ..transition!
                ..duration 800
                ..attr \stroke-width 2
                ..attr \fill \none
                ..attr \d ~> lineDef it.years

    drawStacked: ->
        @x.range [0 @width]
        @parentElement.classed \hoverOn on
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
            ..attr \fill \white
            ..on \mouseover ~> @menu.highlight it.id
            ..on \mouseout ~> @menu.downlight it.id
            ..transition!
                ..duration 800
                ..attr \stroke-width 1
                ..attr \fill (.color)
                ..attr \d ~> @areaDef it.years

    highlight: (id) ->
        @parentElement.classed \hoverOn on
        @lines.filter -> it.id == id
            .classed \active yes

    downlight: (id) ->
        @parentElement.classed \hoverOn off
        @lines.filter -> it.id == id
            .classed \active no
