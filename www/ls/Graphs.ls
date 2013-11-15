window.Graphs = class Graphs
    (@parentElement, @menu, @yearRange, @data, {@width, @height}:options) ->
        @data .= slice 1 # remove totals

        @svg = @parentElement.append \svg
            ..attr \width @width
            ..attr \height @height
        @linesGroup = @svg.append \g
            ..attr \class \linesGroup
        @yAxisGroup = @svg.append \g
            ..attr \class "axis y"
        @yAxis = d3.svg.axis!
            ..ticks 10
            ..tickSize @width - 20
            ..outerTickSize 0
            ..orient \right
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

        @yAxis
            ..scale y
            ..tickValues [0.2 1 3 5 10 20 30 40 50 60 70].map -> it*1e3
            ..tickFormat -> "#{formatPrice it}"
        @yAxisGroup
            ..attr \class "axis y non-stacked"
            ..call @yAxis
            ..selectAll "text"
                ..attr \x @width
                ..attr \dy 5
                ..style \text-anchor \end

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

        @yAxis
            ..scale y
            ..tickFormat -> "#{100 - it*100}%"
        @yAxisGroup
            ..attr \class "axis y stacked"
            ..call @yAxis
            ..selectAll "text"
                ..attr \x @width
                ..attr \dy (d, index) ->
                    | index == 0 => 10
                    | index == 10 => 0
                    | otherwise  => 5
                ..style \text-anchor \end

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
