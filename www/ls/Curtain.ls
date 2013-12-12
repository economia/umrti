window.Curtain = class Curtain
    (@parentElement, @x, @offset) ->
        @center = @parentElement.append \div
            ..attr \class "curtain center"

    draw: (left, right) ->
        leftX  = @x left
        rightX = @x right
        @center
            .style \left "#{@offset + leftX}px"
            .style \width "#{rightX - leftX}px"

    hide: ->
        @center.style \width "0px"
