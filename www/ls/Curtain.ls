window.Curtain = class Curtain
    (@parentElement, @x, @offset) ->
        @center = @parentElement.append \div
            ..attr \class "curtain center"

    draw: (left, right) ->
        @center.classed \hidden no
        leftX  = @x left
        rightX = @x right
        @center
            .style \left "#{@offset + leftX}px"
            .style \width "#{rightX - leftX}px"

    hide: ->
        @center.classed \hidden yes
