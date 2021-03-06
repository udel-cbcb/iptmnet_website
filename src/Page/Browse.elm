module Page.Browse exposing (..)
import Html.Styled exposing (..)
import Msgs exposing (..)
import Model.AppModel exposing (..)
import Html.Styled exposing (..)
import Css exposing (..)
import Html.Styled.Attributes exposing (..)
import Html.Styled.Events exposing (..)
import Msgs exposing (..)
import String.Interpolate exposing (interpolate)
import Views.Navbar
import Ionicon.Ios
import Colors
import Views.Footer exposing (..)
import Ionicon
import Model.AppModel exposing (..)
import Model.Misc exposing (..)
import Model.BrowseResult exposing (..)
import Model.BrowsePage exposing (..)

view : Model -> Html Msg
view model =  
            div [
                id "page",
                css [
                    displayFlex,
                    flexDirection column,
                    Css.property "min-height" "100%"
                ]] [  

                Views.Navbar.view model.navbar,

                (case model.browsePage.browseData.status of 
                0 ->
                    div [] []
                1 ->
                    viewLoading
                2 ->
                    viewSuccess model.browsePage
                _ ->
                    viewError model.browsePage.browseData.error model.browsePage.showErrorMsg Msgs.OnBrowseResultErrorButtonClicked),         

                div[
                    id "filler",
                    css [
                        flexGrow (num 1)
                    ]]
                [],

                Views.Footer.view        

        ]

viewLoading: Html Msg 
viewLoading = 
    div [
        id "div_loading_view_container",
        css [
            displayFlex,
            flexDirection row,
            alignSelf center,
            flexGrow (num 5),
            alignItems center
        ]
    ] [
        div [
            id "div_loading_view",
            css [
                displayFlex,
                flexDirection column,
                alignItems center
            ]
        ][
            div [
                id "loading_icon",
                        css [
                            Css.width (px 100),
                            Css.height (px 100),
                            Css.property "-webkit-animation" "spin 0.8s linear infinite",
                            Css.property "-moz-animation" "spin 0.8s linear infinite"
                        ]
                ][
                    div [
                            css [
                                margin auto
                            ]
                        ] [
                            Ionicon.loadC 100 Colors.emptyIcon |> Html.Styled.fromUnstyled
                    ]
            ],
            div [
                id "loading_label",
                css [
                    color Colors.emptyText,
                    fontSize (Css.em 1.5),
                    Css.fontWeight bold
                ]
            ][
                text "Loading results.."
            ]
        ]
    ]



viewEmpty: Html Msg 
viewEmpty = 
    div [
        id "div_empty_view_container",
        css [
            displayFlex,
            flexDirection row,
            alignSelf center,
            flexGrow (num 5),
            alignItems center
        ]
    ] [
        div [
            id "div_empty_view",
            css [
                displayFlex,
                flexDirection column,
                alignItems center
            ]
        ][
            div [
                id "empty_icon",
                        css [
                            displayFlex,
                            flexDirection column,
                            alignItems center
                        ]
                ][
                    div [
                            css [
                                margin auto
                            ]
                        ] [
                            Ionicon.coffee 150 Colors.emptyIcon |> Html.Styled.fromUnstyled
                    ]
            ],
            div [
                id "empty_label",
                css [
                    color Colors.emptyText,
                    fontSize (Css.em 2),
                    Css.fontWeight bold
                ]
            ][
                text "No results found!"
            ],

            div [
                id "error_label_1",
                css [
                    color Colors.emptyText,
                    fontSize (Css.em 1.1)
                ]
            ][
                text "Try browseing for a different protein or changing advanced options"
            ]
        ]
    ]

viewError: String -> Bool-> Msg -> Html Msg 
viewError errorMsg isMsgVisible erroButtonMsg = 
    div [
        id "div_error_container",
        css [
            displayFlex,
            flexDirection row,
            alignSelf center,
            flexGrow (num 5),
            alignItems center
        ]
    ] [
        div [
            id "div_error",
            css [
                displayFlex,
                flexDirection column,
                alignItems center
            ]
        ][
            div [
                id "error_icon",
                        css [
                            displayFlex,
                            flexDirection column,
                            alignItems center
                        ]
                ][
                    div [
                            css [
                                margin auto
                            ]
                        ] [
                            Ionicon.network 150 Colors.errorIcon |> Html.Styled.fromUnstyled
                    ]
            ],
            div [
                id "error_label",
                css [
                    color Colors.errorText,
                    fontSize (Css.em 2),
                    Css.fontWeight bold
                ]
            ][
                text "Whoops!"
            ],

            div [
                id "error_label_1",
                css [
                    color Colors.errorText,
                    fontSize (Css.em 1.2)
                ]
            ][
                text "Looks like something went wrong"
            ],

            div [
                id "btn_error",
                css [
                    displayFlex,
                    flexDirection row,
                    alignItems center,
                    Css.height (px 30),
                    backgroundColor Colors.errorButtonBackground,
                    borderRadius (px 5),
                    marginTop (px 10),
                    hover [
                        cursor pointer
                    ]
                ],
                onClick erroButtonMsg
            ][
                div [
                    css [
                        paddingLeft (px 10),
                        paddingRight (px 10),
                        color Colors.errorCodeIconBackground,
                        fontSize (Css.em 0.95)
                    ]
                ][
                    text "ERROR"
                ],
                div [
                    id "error_code",
                            css [
                                displayFlex,
                                flexDirection column,
                                alignItems center,
                                paddingLeft (px 5),
                                paddingRight (px 5),
                                Css.property "height" "100%",
                                backgroundColor Colors.errorCodeIconBackground,
                                borderTopRightRadius (px 5),
                                borderBottomRightRadius (px 5)
                            ]
                    ][
                        div [
                                css [
                                    marginTop (px 6),
                                    paddingLeft (px 5),
                                    paddingRight (px 5)
                                ]
                            ] [
                                Ionicon.code 16 Colors.errorCodeIcon |> Html.Styled.fromUnstyled
                        ]
                ]
            ],

            div [
                id "error_msg",
                css ([
                    color Colors.errorCodeIconBackground,
                    marginTop (px 10),
                    marginBottom (px 20),
                    marginLeft (px 20),
                    marginRight (px 20),
                    textAlign center
                ] ++ isVisible isMsgVisible)
            ][
                text errorMsg
            ]
        ]
    ]

viewSuccess: BrowsePage -> Html Msg
viewSuccess browsePage = 
    div [
        id "content",
        css [
            displayFlex,
            flexDirection column
        ]
    ][  
        div [
            id "browse_info",
            css [
                displayFlex,
                flexDirection row,
                alignItems center,
                marginTop (px 20),
                marginBottom (px 10)
            ]
        ][
            div [
                css [
                    displayFlex,
                    flexDirection row,
                    marginLeft auto,
                    marginRight (px 50),
                    alignItems center
                ]
            ][
                div [
                    css [
                        border (px 1),
                        borderStyle solid,
                        borderColor (hex "#232323ff"),
                        Css.height (px 30),
                        Css.width (px 30),
                        textAlign center,
                        lineHeight (px 30),
                        hover [
                            cursor pointer
                        ]
                    ],
                    onClick Msgs.OnClickPrevBrowseResults
                ][
                    text "<"
                ],
                div [
                    css [
                        marginLeft (px 20),
                        marginRight (px 20)
                    ]
                ][
                    let
                        startIndex = ((browsePage.selectedIndex * entriesPerPage) + 1)
                        endIndex = (startIndex + (entriesPerPage - 1))
                        actualEndIndex = (if endIndex > browsePage.browseData.count then
                                             browsePage.browseData.count
                                          else
                                             endIndex  
                                         )
                        progress = (interpolate "{0}-{1} of {2}" [toString startIndex, toString actualEndIndex, toString browsePage.browseData.count] ) 
                    in
                        text progress
                ],
                div [
                    css [
                        border (px 1),
                        borderStyle solid,
                        borderColor (hex "#232323ff"),
                        Css.height (px 30),
                        Css.width (px 30),
                        textAlign center,
                        lineHeight (px 30),
                        hover [
                            cursor pointer
                        ]
                    ],
                    onClick Msgs.OnClickNextBrowseResults
                ][
                    text ">"
                ]   
            ]

        ],

        -- browse table
        (if List.length browsePage.browseData.data > 0 then
            viewBrowseTable browsePage 
         else
            viewEmpty)
        

    ]

viewBrowseTable : BrowsePage -> Html Msg
viewBrowseTable browsePage =  
    div [id "browse_table", css [
                    displayFlex,
                    flexDirection column,
                    fontSize (Css.em 0.9)
                ]][
                    -- header
                    div [id "browse_table_header", css [
                        displayFlex,
                        flexDirection row,
                        -- backgroundColor (hex "#eff1f2"),
                        paddingTop (px 10),
                        paddingBottom (px 10),
                        fontWeight bold,
                        alignItems center
                    ]] [
                        div [css [flex (num 2),
                                marginLeft (px 5),
                                marginRight (px 20),
                                paddingLeft (px 5),
                                displayFlex,
                                flexDirection row,
                                alignItems center
                            ]]
                        [
                            input [type_ "checkbox", css[marginLeft (px 5), marginRight (px 15)]][],
                            text "iPTM ID"
                        ],
                        div [css [flex (num 2),
                                marginRight (px 10),
                                paddingLeft (px 8)         
                                ]] 
                        [
                            text "Protein Name"
                        ],
                        div [css [flex (num 1.5),
                            marginRight (px 20),
                            paddingLeft (px 5)         
                            ]]
                        [
                            text "Gene Name"
                        ],
                        div [css [flex (num 1.5),
                                marginRight (px 20),
                                paddingLeft (px 5)
                                ]]
                        [
                            text "Organism"
                        ],
                        div [css [flex (num 1),
                                marginRight (px 20),
                                paddingLeft (px 10)
                                ]]
                        [
                            text "Substrate Role"
                        ],
                        div [css [flex (num 1),
                                marginRight (px 20)
                                ]]
                        [
                            text "Enzyme Role"
                        ],
                        div [css [flex (num 1.5),
                                marginRight (px 20)
                                ]]
                        [
                            text "PTM-dependent PPI"
                        ],
                        div [css [flex (num 0.5),
                                marginRight (px 20)
                                ]]
                        [
                            text "Sites"
                        ],
                        div [css [flex (num 0.5),
                                marginRight (px 20)
                                ]]
                        [
                            text "Isoforms"
                        ]                  


                    ],

                    -- rows
                    div [] (List.map browseResultRow browsePage.browseData.data)               

                ]


browseResultRow: BrowseResult  -> Html Msg
browseResultRow browseResult = 
    div [id "browse_table_row", css [
                    displayFlex,
                    flexDirection row,
                    paddingTop (px 10),
                    paddingBottom (px 10),
                    hover [
                        backgroundColor (hex "#0000000D")
                    ]
                ]] [
                    div [css [flex (num 2),
                            marginLeft (px 5),
                            marginRight (px 20),
                            paddingLeft (px 5),
                            displayFlex,
                            flexDirection row,
                            alignItems center,
                            fontSize (Css.em 0.90),
                            Css.property "word-break" "break-all"
                        ]]
                    [
                        input [type_ "checkbox", css[marginLeft (px 5), marginRight (px 15)]][],
                        a [href (interpolate (pathname ++ "entry/{0}") [browseResult.iptm_id] )] [text (interpolate "iPTM:{0}/ {1}" [browseResult.iptm_id,browseResult.uniprot_ac])]
                    ],
                    div [css [flex (num 2),
                            marginRight (px 10)        
                            ]][
                                text browseResult.protein_name
                            ]
                    ,
                    div [css [flex (num 1.5),
                        marginRight (px 20),
                        Css.property "word-break" "break-all"          
                        ]]
                    [
                        span [] [
                            span [][text "Name: "],
                            span [][text browseResult.gene_name],
                            br[][],
                        text (interpolate "Synonyms: {0} " [String.join "," browseResult.synonyms])] 
                    ],
                    div [css [flex (num 1.5),
                            marginRight (px 20),
                            Css.property "word-break" "break-all"
                            ]]
                    [
                        text ( interpolate "{0} ({1})" [browseResult.organism.common_name,browseResult.organism.species] )
                    ],
                    div [css [flex (num 1),
                            marginRight (px 20),
                            displayFlex,
                            flexDirection row,
                            alignItems center,
                            Css.property "word-break" "break-all"
                            ]]
                    [
                        viewSubstrateRole browseResult.substrate_role browseResult.substrate_num
                    ],
                    div [css [flex (num 1),
                            marginRight (px 20),
                            Css.property "word-break" "break-all"
                            ]]
                    [
                        viewEnzymeRole browseResult.enzyme_num browseResult.enzyme_role
                    ],
                    div [css [flex (num 1.5),
                            marginRight (px 20),
                            Css.property "word-break" "break-all"
                        ]]
                    [
                        viewPTMDepPPIRole browseResult.ptm_dependent_ppi_role browseResult.ptm_dependent_ppi_num                        
                    ],
                    div [css [flex (num 0.5),
                            marginRight (px 20),
                            Css.property "word-break" "break-all"
                            ]]
                    [
                        text (toString browseResult.sites)
                    ],
                    div [css [flex (num 0.5),
                            marginRight (px 20),
                            Css.property "word-break" "break-all"
                            ]]
                    [
                        text (toString browseResult.isoforms)
                    ]
                ]

viewSubstrateRole : Bool -> Int -> Html Msg
viewSubstrateRole substrate_role substrate_num =
            case substrate_role of 
            True ->
                div [
                    css [
                            displayFlex,
                            flexDirection row,
                            alignItems center
                        ] 
                        ][
                        div [
                            id "substrate_role_icon_container"
                        ] [
                            div [
                                id "substrate_role_icon"
                            ][
                                Ionicon.Ios.checkmarkEmpty 30 Colors.checkMark |> Html.Styled.fromUnstyled
                            ]
                        ],
                        div [][
                            text (interpolate "{0} enzymes" [toString substrate_num])
                        ]
                ]
            False ->
                div [
                    css [
                            displayFlex,
                            flexDirection column,
                            alignItems center
                        ] 
                        ][
                        div [
                            id "substrate_role_icon_container"
                        ] [
                            div [
                                id "substrate_role_icon"
                            ][
                                Ionicon.Ios.closeEmpty 30 Colors.checkMark |> Html.Styled.fromUnstyled
                            ]
                        ]
                ]

viewEnzymeRole : Int -> Bool -> Html Msg
viewEnzymeRole enzyme_num enzyme_role =
            case enzyme_role of 
            True ->
                div [
                    css [
                            displayFlex,
                            flexDirection row,
                            alignItems center
                        ] 
                        ][
                        div [
                            id "enzyme_role_icon_container"
                        ] [
                            div [
                                id "enzyme_role_icon"
                            ][
                                Ionicon.Ios.checkmarkEmpty 30 Colors.checkMark |> Html.Styled.fromUnstyled
                            ]
                        ],
                        div [][
                            text (interpolate "{0} enzymes" [toString enzyme_num])
                        ]
                ]
            False ->
                div [
                    css [
                            displayFlex,
                            flexDirection column,
                            alignItems center
                        ] 
                        ][
                        div [
                            id "enzyme_role_icon_container"
                        ] [
                            div [
                                id "enzyme_role_icon"
                            ][
                                Ionicon.Ios.closeEmpty 30 Colors.checkMark |> Html.Styled.fromUnstyled
                            ]
                        ]
                ]

viewPTMDepPPIRole : Bool -> Int -> Html Msg
viewPTMDepPPIRole ptm_dep_ppi_role ptm_dep_ppi_num =
            case ptm_dep_ppi_role of 
            True ->
                div [
                    css [
                            displayFlex,
                            flexDirection row,
                            alignItems center
                        ] 
                        ][
                        div [
                            id "ptm_dep_ppi_role_icon_container"
                        ] [
                            div [
                                id "ptm_dep_ppi_role_icon"
                            ][
                                Ionicon.Ios.checkmarkEmpty 30 Colors.checkMark |> Html.Styled.fromUnstyled
                            ]
                        ],
                        div [][
                            text (interpolate "{0} interactants" [toString ptm_dep_ppi_num])
                        ]
                ]
            False ->
                div [
                    css [
                            displayFlex,
                            flexDirection column,
                            alignItems center
                        ] 
                        ][
                        div [
                            id "enzyme_role_icon_container"
                        ] [
                            div [
                                id "enzyme_role_icon"
                            ][
                                Ionicon.Ios.closeEmpty 30 Colors.checkMark |> Html.Styled.fromUnstyled
                            ]
                        ]
                ]
