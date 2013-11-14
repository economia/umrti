window.Graphs = class Graphs
    (@parentElement, @yearRange, @data, {@width, @height}:options) ->
        @data .= slice 1 # remove totals
        @svg = @parentElement.append \svg
            ..attr \width @width
            ..attr \height @height
        @linesGroup = @svg.append \g
            ..attr \class \linesGroup
        @x = d3.scale.linear!
            ..domain @yearRange
            ..range [0 @width]
        maxValue = -Infinity
        for {years}:category in @data
            for {normalized}:year in years
                if normalized > maxValue
                    maxValue = normalized

        @y = d3.scale.sqrt!
            ..domain [maxValue, 0]
            ..range [0 @height]

        @lines = @linesGroup.selectAll \g.line
            .data @data
            .enter!.append \g
                ..attr \class \line
                ..append \path

    draw: ->
        @lineDef = d3.svg.line!
            ..x (point) ~> @x point.year
            ..y (point) ~> @y point.normalized

        @lines.select \path
            ..attr \stroke (.color)
            ..attr \d ~> @lineDef it.years
