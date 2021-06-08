# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
#
# Description
# ==============================================================================
#
#    Tests related to custom cells.
#
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

@testset "Custom cells - URL text cell" begin
    table = [
        1 "Ronan Arraes Jardim Chagas" URLTextCell("Ronan Arraes Jardim Chagas", "https://ronanarraes.com")
        2 "Google" URLTextCell("Google", "https://google.com")
        3 "Apple" URLTextCell("Apple", "https://apple.com")
        4 "Emojis!" URLTextCell("😃"^20, "https://emojipedia.org/github/")
    ]

    # Default
    # ==========================================================================

    expected = """
        ┌────────┬────────────────────────────┬──────────────────────────────────────────┐
        │ Col. 1 │                     Col. 2 │                                   Col. 3 │
        ├────────┼────────────────────────────┼──────────────────────────────────────────┤
        │      1 │ Ronan Arraes Jardim Chagas │               \e]8;;https://ronanarraes.com\e\\Ronan Arraes Jardim Chagas\e]8;;\e\\ │
        │      2 │                     Google │                                   \e]8;;https://google.com\e\\Google\e]8;;\e\\ │
        │      3 │                      Apple │                                    \e]8;;https://apple.com\e\\Apple\e]8;;\e\\ │
        │      4 │                    Emojis! │ \e]8;;https://emojipedia.org/github/\e\\😃😃😃😃😃😃😃😃😃😃😃😃😃😃😃😃😃😃😃😃\e]8;;\e\\ │
        └────────┴────────────────────────────┴──────────────────────────────────────────┘
        """

    result = pretty_table(String, table)
    @test expected == result

    # Alignment
    # ==========================================================================

    expected = """
        ┌────────┬────────────────────────────┬──────────────────────────────────────────────────────────────┐
        │ Col. 1 │           Col. 2           │                            Col. 3                            │
        ├────────┼────────────────────────────┼──────────────────────────────────────────────────────────────┤
        │   1    │ Ronan Arraes Jardim Chagas │                  \e]8;;https://ronanarraes.com\e\\Ronan Arraes Jardim Chagas\e]8;;\e\\                  │
        │   2    │           Google           │                            \e]8;;https://google.com\e\\Google\e]8;;\e\\                            │
        │   3    │           Apple            │                            \e]8;;https://apple.com\e\\Apple\e]8;;\e\\                             │
        │   4    │          Emojis!           │           \e]8;;https://emojipedia.org/github/\e\\😃😃😃😃😃😃😃😃😃😃😃😃😃😃😃😃😃😃😃😃\e]8;;\e\\           │
        └────────┴────────────────────────────┴──────────────────────────────────────────────────────────────┘
        """

    result = pretty_table(
        String,
        table;
        alignment = :c,
        columns_width = [-1, -1, 60]
    )
    @test expected == result

    expected = """
        ┌────────┬────────────────────────────┬──────────────────────────────────────────┐
        │ Col. 1 │ Col. 2                     │ Col. 3                                   │
        ├────────┼────────────────────────────┼──────────────────────────────────────────┤
        │ 1      │ Ronan Arraes Jardim Chagas │ \e]8;;https://ronanarraes.com\e\\Ronan Arraes Jardim Chagas\e]8;;\e\\               │
        │ 2      │ Google                     │ \e]8;;https://google.com\e\\Google\e]8;;\e\\                                   │
        │ 3      │ Apple                      │ \e]8;;https://apple.com\e\\Apple\e]8;;\e\\                                    │
        │ 4      │ Emojis!                    │ \e]8;;https://emojipedia.org/github/\e\\😃😃😃😃😃😃😃😃😃😃😃😃😃😃😃😃😃😃😃😃\e]8;;\e\\ │
        └────────┴────────────────────────────┴──────────────────────────────────────────┘
        """

    result = pretty_table(
        String,
        table;
        alignment = :l
    )
    @test expected == result

    # Filters
    # ==========================================================================

    expected = """
        ┌─────┬───┬────────┬────────────────────────────┐
        │ Row │   │ Col. 1 │                     Col. 3 │
        ├─────┼───┼────────┼────────────────────────────┤
        │   1 │ A │      1 │ \e]8;;https://ronanarraes.com\e\\Ronan Arraes Jardim Chagas\e]8;;\e\\ │
        │   3 │ C │      3 │                      \e]8;;https://apple.com\e\\Apple\e]8;;\e\\ │
        └─────┴───┴────────┴────────────────────────────┘
        """

    result = pretty_table(
        String,
        table,
        filters_col = ((data, j) -> j % 2 == 1,),
        filters_row = ((data, i)-> i % 2 == 1,),
        row_names = ["A", "B", "C", "D"],
        show_row_number = true,
    )
    @test expected == result

    # Highlighters
    # ==========================================================================

    expected = """
        ┌────────┬────────────────────────────┬──────────────────────────────────────────┐
        │\e[1m Col. 1 \e[0m│\e[1m                     Col. 2 \e[0m│\e[1m                                   Col. 3 \e[0m│
        ├────────┼────────────────────────────┼──────────────────────────────────────────┤
        │      1 │ Ronan Arraes Jardim Chagas │ \e[33;1m              \e]8;;https://ronanarraes.com\e\\Ronan Arraes Jardim Chagas\e]8;;\e\\\e[0m │
        │      2 │                     Google │ \e[33;1m                                  \e]8;;https://google.com\e\\Google\e]8;;\e\\\e[0m │
        │      3 │                      Apple │ \e[33;1m                                   \e]8;;https://apple.com\e\\Apple\e]8;;\e\\\e[0m │
        │      4 │                    Emojis! │ \e[33;1m\e]8;;https://emojipedia.org/github/\e\\😃😃😃😃😃😃😃😃😃😃😃😃😃😃😃😃😃😃😃😃\e]8;;\e\\\e[0m │
        └────────┴────────────────────────────┴──────────────────────────────────────────┘
        """

    buf = IOBuffer()
    io  = IOContext(buf, :color => true)
    pretty_table(io, table, highlighters = hl_col(3, crayon"yellow bold"))
    result = String(take!(buf))
    @test expected == result

    # Cropping
    # ==========================================================================

    # Column cropping
    # --------------------------------------------------------------------------
    
    expected = """
        ┌────────┬───────────────┬────────────────────┐
        │ Col. 1 │        Col. 2 │             Col. 3 │
        ├────────┼───────────────┼────────────────────┤
        │      1 │ Ronan Arraes… │ \e]8;;https://ronanarraes.com\e\\Ronan Arraes Jard\e]8;;\e\\… │
        │      2 │        Google │             \e]8;;https://google.com\e\\Google\e]8;;\e\\ │
        │      3 │         Apple │              \e]8;;https://apple.com\e\\Apple\e]8;;\e\\ │
        │      4 │       Emojis! │ \e]8;;https://emojipedia.org/github/\e\\😃😃😃😃😃😃😃😃 \e]8;;\e\\… │
        └────────┴───────────────┴────────────────────┘
        """

    result = pretty_table(String, table, columns_width = [-1, 13, 18])
    @test expected == result

    expected = """
        ┌────────┬───────────────┬─────────────────────┐
        │ Col. 1 │        Col. 2 │              Col. 3 │
        ├────────┼───────────────┼─────────────────────┤
        │      1 │ Ronan Arraes… │ \e]8;;https://ronanarraes.com\e\\Ronan Arraes Jardi\e]8;;\e\\… │
        │      2 │        Google │              \e]8;;https://google.com\e\\Google\e]8;;\e\\ │
        │      3 │         Apple │               \e]8;;https://apple.com\e\\Apple\e]8;;\e\\ │
        │      4 │       Emojis! │ \e]8;;https://emojipedia.org/github/\e\\😃😃😃😃😃😃😃😃😃\e]8;;\e\\… │
        └────────┴───────────────┴─────────────────────┘
        """

    result = pretty_table(String, table, columns_width = [-1, 13, 19])
    @test expected == result
end
