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
        @left.classed \hidden yes
        @right.classed \hidden yes
        <~ setTimeout _, 400
        @left.remove!
        @right.remove!
