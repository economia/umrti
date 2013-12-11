window.Details = class Details
    (@parentElement, @basedata, {@histogramWidth}) ->
        @heading = @parentElement.append \h2
        addText = ~>
            @heading.append \span
                ..attr \class \txt
                ..html it
        addText "Na "
        @backButton = @parentElement.append \button
            ..attr \class \backButton
            ..attr \title \Zpět
            ..append \img
                ..attr \src \./img/back.png
                ..attr \alt \Zpět
            ..on \click @~hide
        @categoryContainer = @heading.append \span
        @categoryName = @categoryContainer.append \span
            ..attr \class "name"
        @categoryContainer
            ..append \div
                ..attr \class "arrow left"
                ..append \span
                ..on \click ~>
                    @lastDisplay.0 -= 1
                    @~display ...@lastDisplay
            ..append \div
                ..attr \class "arrow right"
                ..append \span
                ..on \click ~>
                    @lastDisplay.0 += 1
                    @~display ...@lastDisplay
        addText " zemřelo v roce "
        @yearContainer = @heading.append \span
        @yearName = @yearContainer.append \span
        @yearContainer
            ..append \div
                ..attr \class "arrow left"
                ..append \span
                ..on \click ~>
                    @lastDisplay.1 -= 1
                    @~display ...@lastDisplay
            ..append \div
                ..attr \class "arrow right"
                ..append \span
                ..on \click ~>
                    @lastDisplay.1 += 1
                    @~display ...@lastDisplay
        addText " celkem "
            ..attr \class "text preTotal"
        @totalCount = addText "----"
            ..attr \class \total
        @genderContainer = @heading.append \span
        @genderName = @genderContainer.append \span
            ..attr \class "gender"
        @genderContainer
            ..append \div
                ..attr \class "arrow left"
                ..append \span
                ..on \click ~>
                    | @lastDisplay.2 == \both => @lastDisplay.2 = "men"
                    | @lastDisplay.2 == \men => @lastDisplay.2 = "women"
                    | @lastDisplay.2 == \women => @lastDisplay.2 = "both"
                    @~display ...@lastDisplay
            ..append \div
                ..attr \class "arrow right"
                ..append \span
                ..on \click ~>
                    | @lastDisplay.2 == \men => @lastDisplay.2 = "both"
                    | @lastDisplay.2 == \women => @lastDisplay.2 = "men"
                    | @lastDisplay.2 == \both => @lastDisplay.2 = "women"
                    @~display ...@lastDisplay
        @content = @parentElement.append \ul

    display: (id, year, gender) ->
        if id < 1 => id = 20
        if id > 20 => id = 1
        if year > 2006 => year = 1919
        if year < 1919 => year = 2006
        @lastDisplay = [id, year, gender]
        @parentElement.classed \active on
        category =  @basedata[id]
        @categoryName.html category.name
        @genderName.html switch gender
        | \men   => "mužů"
        | \women => "žen"
        | \both  => "mužů a žen"
        @yearName.html year
        @content.html ""
        (err, data) <~ d3.csv "../data/csv_details/#id-#year-#gender.csv"
        data.sort (a, b) ->
            a = +a.total
            b = +b.total
            b - a
        fields = @getYearFields data.0
        maxSingleField = -Infinity
        total = 0
        for line in data
            total += +line.total
            for field in fields
                line[field] = +line[field]
                if line[field] > maxSingleField
                    maxSingleField = line[field]

        @totalCount.html utils.formatPrice total

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
                    ..html (line) -> utils.formatPrice line.total
                    ..attr \class \total
                    ..attr \data-tooltip "Celkem zemřelých"
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

