window.Graphs = class Graphs
    defaultYTicks : [200 1000 3000 5000 10000 20000 30000 40000 50000 60000 70000]
    displayedGender: \both
    (@parentElement, @menu, @details, @histogram, @yearRange, data, {@width, @height}:options) ->
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

        @yAxisGroup.selectAll \text
            ..attr \dy 9

        @xAxisGroup = @svg.append \g
            ..attr \class "x axis"

        @xAxis = d3.svg.axis!
            ..tickSize 3
            ..tickFormat -> it
            ..outerTickSize 0
            ..orient \bottom

        @x = d3.scale.linear!
            ..domain @yearRange
        @y = d3.scale.sqrt!
            ..range [10 @height]

        @absoluteLineDef = d3.svg.line!
            ..x (point) ~> @x point.year
            ..y (point) ~> @y point.value

        @recalculateData data

        @lines = @linesGroup.selectAll \g.line
            .data @data, (.id)
            .enter!.append \g
                ..attr \class \line
                ..append \path
                    ..attr \class \dataline
                    ..on \click ~>
                        if not @currentSelection
                            @setSelection [it.id]
                        @setMethod \normal
                    ..attr \stroke (.color)
        @currentSelection = null
        @currentMethod    = \normal

    setSelection: (ids) ->
        @currentSelection = ids
        @redraw!

    setMethod: (stackedOrNormal) ->
        @currentMethod = stackedOrNormal
        @redraw!

    redraw: ->
        | @currentMethod == \stacked => @drawStacked!
        | @currentSelection is null => @draw!
        | otherwise => @drawSelection!


    draw: ->
        @clearDatapoints!
        @nowDrawn = [\normal]
        @x.range [3 @width]
        @redrawXAxis \non-stacked
        @parentElement.classed \hoverOn off
        @y.domain [@maxValue, 0]

        @redrawYAxis!

        @lines
            ..classed \disabled off
            ..select \path.dataline
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
                    ..attr \d ~> @absoluteLineDef it.years

    drawSelection: ->
        ids = @currentSelection
        @clearDatapoints!
        @nowDrawn = [\normal ids]
        @x.range [3 @width]
        @parentElement.classed \hoverOn off
        @redrawXAxis \non-stacked
        @lines.classed \disabled on
        lines = @lines.filter -> it.id in ids
        lines.classed \disabled off
        data = lines.data!
        maxes = for datum in data
            Math.max ...datum.years.map (.value)
        max = Math.max ...maxes
        @y.domain [max, 0]
        @redrawYAxis @defaultYTicks.filter -> it < max
        @lines.select \path.dataline
            ..transition!
                ..duration 800
                ..attr \stroke-width 2
                ..attr \fill \none
                ..attr \d ~> @absoluteLineDef it.years
        symbol = d3.svg.symbol!
            ..size 45

        <~ setTimeout _, 300
        lines
            .selectAll \path.datapoint
            .data (.years)
            .enter!.append \path
                ..attr \class \datapoint
                ..attr \data-tooltip (it, i, parentIndex) ~> escape "#{it.year}, #{data[parentIndex].name}: #{utils.formatPrice it.value .replace ' ' '&nbsp;'}&nbsp;mrtvých<br />Klikněte pro detailní pohled na přesné diagnózy a věkovou strukturu"
                ..attr \transform ~> "translate(#{@x it.year}, #{@y it.value}) scale(0)"
                ..attr \stroke (it, i, parentIndex) ~> data[parentIndex].color
                ..attr \fill (it, i, parentIndex) ~> data[parentIndex].color
                ..attr \d symbol
                ..on \click (it, i, parentIndex) ~> @details.display data[parentIndex].id, it.year, @displayedGender
                ..transition!
                    ..delay (d, i) -> i * 10
                    ..duration 600
                    ..attr \transform ~> "translate(#{@x it.year}, #{@y it.value}) scale(1)"

    clearDatapoints: ->
        @svg.selectAll \path.datapoint .remove!

    drawStacked: ->
        lastDrawn = @nowDrawn
        @clearDatapoints!
        @nowDrawn = [\stacked]
        @x.range [0 @width]
        @redrawXAxis \stacked

        @parentElement.classed \hoverOn on
        @y = d3.scale.linear!
            ..domain [0 1]
            ..range [0 @height]

        @yAxis
            ..scale @y
            ..tickValues null
            ..tickFormat -> "#{100 - it*100}%"
        @yAxisGroup
            ..attr \class "axis y stacked"
            ..call @yAxis
            ..selectAll "text"
                ..attr \x @width
                ..attr \dy (d, index) ->
                    | index == 0 => 15
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
            ..y (point) ~> @y point.normalized
            ..order \inside-out
        if @currentSelection
            stack.order \default
            @data.sort (a, b) ~>
                aInSelection = if a.id in @currentSelection then 1 else 0
                bInSelection = if b.id in @currentSelection then 1 else 0
                switch
                | aInSelection - bInSelection => that
                | otherwise => a.id - b.id
            @lines.classed \selected ~> it.id in @currentSelection
        @linesGroup.classed \stackedSelection @currentSelection != null
        stack @data
        datalines = @lines
            .classed \disabled off
            .select \path.dataline
        if lastDrawn.0 != \stacked
            datalines
                ..attr \fill \white
                ..on \mouseover ~> @menu.highlight it.id
                ..on \mouseout ~> @menu.downlight it.id
        datalines
                ..transition!
                    ..duration 800
                    ..attr \stroke-width 1
                    ..attr \fill (.color)
                    ..attr \d ~> @areaDef it.years

    redrawWithData: (data, @displayedGender) ->
        @recalculateData data
        @lines = @linesGroup.selectAll \g.line
            .data @data, (.id)
        switch
        | @nowDrawn.0 == \stacked => @drawStacked!
        | @nowDrawn.1 is void => @draw!
        | otherwise => @drawSingle @nowDrawn.1

    recalculateData: (data) ->
        @data = data.slice 1 # remove totals
        @maxValue = -Infinity
        for {years}:category in @data
            for {value}:year in years
                if value > @maxValue
                    @maxValue = value

    redrawXAxis: (type) ->
        @xAxis
            ..scale @x
        @xAxisGroup
            ..attr \class "axis x #type"
            ..call @xAxis
            ..selectAll \text
                ..attr \dy 9

    redrawYAxis: (yTicks = @defaultYTicks)->
        @yAxis
            ..scale @y
            ..tickValues yTicks
            ..tickFormat -> "#{utils.formatPrice it}"
        @yAxisGroup
            ..attr \class "axis y non-stacked"
            ..transition!
                ..duration 800
                ..call @yAxis
                ..selectAll "text"
                    ..attr \x @width
                    ..attr \dy 5
                    ..style \text-anchor \end

    highlight: (id) ->
        @parentElement.classed \hoverOn on
        @lines.filter -> it.id == id
            .classed \active yes

    downlight: (id) ->
        @parentElement.classed \hoverOn off if @nowDrawn.0 isnt \stacked
        @lines.filter -> it.id == id
            .classed \active no
