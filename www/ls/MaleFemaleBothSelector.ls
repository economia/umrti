window.MaleFemaleBothSelector = class MaleFemaleBothSelector
    (@parentElement, bothData, @graphs) ->
        @data =
            men: null
            women: null
            both: bothData

        @parentElement.append \div
            ..attr \class "maleFemaleBothSelector buttonset"
            ..append \button
                ..html "M"
                ..on \click ~>
                    <~ @getData \men
                    @graphs.redrawWithData @data.men
            ..append \button
                ..html "F"
                ..on \click ~>
                    <~ @getData \women
                    @graphs.redrawWithData @data.women
            ..append \button
                ..html "B"
                ..on \click ~>
                    @graphs.redrawWithData @data.both

    getData: (gender, cb) ->
        if @data[gender]
            cb that
            return
        (err, data) <~ d3.csv "../data/summary-#{gender}.csv", utils.csvTransform
        @data[gender] = data
        cb @data[gender]
