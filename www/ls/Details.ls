window.Details = class Details
    (@parentElement, {@histogramWidth}) ->
        @heading = @parentElement.append \h2
        @content = @parentElement.append \ul

    display: (name, id, year, gender) ->
        @parentElement.classed \active on
        @heading.html "#name #year, #gender"
        (err, data) <~ d3.csv "../data/csv_details/#id-#year-#gender.csv"
        data.sort (a, b) ->
            a = +a.total
            b = +b.total
            b - a
        console.log data[0]
        fields = @getYearFields data.0
        maxSingleField = -Infinity
        for line in data
            for field in fields
                line[field] = +line[field]
                if line[field] > maxSingleField
                    maxSingleField = line[field]

        y = d3.scale.linear!
            ..domain [0 maxSingleField]
            ..range [0 31]

        histoBarWidth = @histogramWidth / fields.length
        tooltip = (d, i) -> "Věková kategorie #{fields[i]} let: #d úmrtí"
        @content.selectAll \li
            .remove!
            .data data
            .enter!append \li
                ..append \h3
                    ..html (.subcategory)
                    ..attr \data-tooltip (.subcategory)
                ..append \div
                    ..attr \class \histogram
                    ..selectAll \div
                        .data (line) -> fields.map -> line[it]
                        .enter!append \div
                            ..attr \class \col
                            ..style \width "#{histoBarWidth}px"
                            ..style \left (d, index) -> "#{index * histoBarWidth}px"
                            ..attr \data-tooltip tooltip
                            ..append \div
                                ..style \height -> "#{y it}px"
                                ..attr \data-tooltip tooltip

    getYearFields: (data) ->
        fields = []
        console.log data
        for own field of data
            unless isNaN +field[0]
                fields.push field
        fields.sort (a, b) ->
            a = parseInt (a.split "-" .0), 10
            b = parseInt (b.split "-" .0), 10
            a - b
        fields

    hide: ->
        @parentElement.classed \active off

