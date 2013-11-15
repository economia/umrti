window.StackedOrNotSelector = class StackedOrNotSelector
    (@parentElement, @graphs) ->
        @parentElement.append \div
            ..attr \class "stackedOrNotSelector buttonset"
            ..append \button
                ..html "R"
                ..on \click @graphs~drawStacked
            ..append \button
                ..html "A"
                ..on \click @graphs~draw
