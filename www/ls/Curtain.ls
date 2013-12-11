window.Curtain = class Curtain
    (@parentElement, @x, @offset) ->
        @left = @parentElement.append \div
            ..attr \class "curtain left"
        @right = @parentElement.append \div
            ..attr \class "curtain right"

    draw: (left, right) ->
        @left.style \width "#{@offset + @x left}px"
        @right.style \left "#{@offset + @x right}px"

    hide: ->
        @left.style \width "0px"
        @right.style \left "100%"
