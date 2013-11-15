window.utils =
    formatPrice : (price) ->
        price .= toString!
        out = []
        len = price.length
        for i in [0 til len]
            out.unshift price[len - i - 1]
            if 2 == i % 3 and i isnt len - 1
                out.unshift ' '
        out.join ''
