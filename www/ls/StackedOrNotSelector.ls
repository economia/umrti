window.StackedOrNotSelector = class StackedOrNotSelector
    (@parentElement, @graphs) ->
        formElement = @parentElement.append \form
            ..attr \class "stackedOrNotSelector"
            ..on \change ~>
                | d3.event.target.value == \stacked => @graphs.setMethod \stacked
                | otherwise                         => @graphs.setMethod \normal
            ..append \input
                ..attr \type \radio
                ..attr \name \stackedOrNot
                ..attr \value \stacked
                ..attr \id \stackedOrNotSelector-stacked
            ..append \label
                ..attr \for \stackedOrNotSelector-stacked
                ..html "Relativní"
            ..append \input
                ..append \input
                ..attr \type \radio
                ..attr \name \stackedOrNot
                ..attr \checked \checked
                ..attr \value \not
                ..attr \id \stackedOrNotSelector-not
            ..append \label
                ..attr \for \stackedOrNotSelector-not
                ..html "Absolutní"
