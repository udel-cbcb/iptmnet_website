module Page.Entry exposing (..)
import Html.Styled exposing (..)
import Css exposing (..)
import Html.Styled.Attributes exposing (..)
import Html.Styled.Events exposing (..)
import Model exposing (..)
import Msgs exposing (..)
import Views.Info
import Views.Sequence
import Views.Substrate
import Views.Proteoforms
import Views.PTMDependentPPI
import Views.ProteoformPPI
import Views.Navbar
import Views.Footer
import String.Interpolate exposing (interpolate)

-- css
sideBarItemCSS: List Style
sideBarItemCSS = 
    [
        paddingLeft (px 25),
        paddingRight (px 10),
        paddingTop (px 10),
        paddingBottom (px 10),
        fontSize (Css.em 0.85),
        flex (num 1),
        hover [
            cursor pointer,
            backgroundColor (hex "#0000000D")
        ],
        textDecoration none,
        color (hex "#000000")
    ]

view : Model -> Html Msg
view model =

        div [id "page",css [
            displayFlex,
            flexDirection column,
            Css.property "min-height" "100%"
            ]] 
            [  

            Views.Navbar.view model,

            div [id "content",css [
                displayFlex,
                flexDirection row,
                flex (num 1)
                ]
            ] [
                
                div [id "sidebar", css [
                    displayFlex,
                    flexDirection column,
                    flex (num 1)
                ]][
                    div [css [
                        position fixed,
                        Css.property "width" "20%"
                    ]] [
                        div [css [
                            displayFlex,
                            flexDirection column,
                            margin (px 20),
                            backgroundColor (hex "ecececff")
                        ]]
                    [
                        div [css [fontWeight bold, padding (px 10)]] [
                            text "Display"
                        ],

                        div [
                            id "opt_info",
                            css sideBarItemCSS,
                            onClick (Msgs.ScrollToElement "info")   
                            ] [
                            text "Protein Information"
                        ],
                        
                        div [
                            id "opt_sequence_viewer",
                            css sideBarItemCSS,
                            onClick (Msgs.ScrollToElement "sequence_viewer")   
                            ] [
                            text "Interactive Sequence Viewer"
                        ],
                        
                        div [
                            id "opt_substrate",
                            css sideBarItemCSS,
                            onClick (Msgs.ScrollToElement "substrates")  
                            ] [
                            text "Substrate"
                        ],
                        
                        div [
                            id "opt_proteoforms",
                            css sideBarItemCSS,
                            onClick (Msgs.ScrollToElement "proteoforms")  
                            ] [
                            text "Proteoforms"
                        ],
                        
                        div [
                            id "opt_ptm_dep_ppi",
                            css sideBarItemCSS,
                            onClick (Msgs.ScrollToElement "ptm_dependent_ppi")  
                            ] [
                            text "PTM Dependent PPI"
                        ],
                        
                        div [
                            id "opt_proteoform_ppi",
                            css sideBarItemCSS,
                            onClick (Msgs.ScrollToElement "proteoforms_ppi") 
                            ] [
                            text "Proteoform PPI"
                        ],
                                            
                        div [
                            id "opt_back_to_top",
                            css sideBarItemCSS,
                            onClick (Msgs.ScrollToElement "info")
                            ] [
                            text "Back to top"
                        ]

                    ],

                    -- cytoscape
                    div [css [
                            backgroundColor (hex "ecececff"),
                            displayFlex,
                            flexDirection column,
                            margin (px 20),
                            paddingLeft (px 10),
                            paddingRight (px 10)
                        ]]
                    [
                        div [
                            css [fontWeight bold,
                                 marginTop (px 10),
                                 marginBottom (px 10)
                                 ]
                        ][
                            text "Cytoscape View"
                        ],
                        div [
                            css [
                                displayFlex,
                                flexDirection column
                            ]
                        ](List.map buildCytoscapeItem model.entryPage.cytoscapeItems)
                    ]
                    ]
                    
                ],
                div [id "entry_content", css [
                    displayFlex,
                    flexDirection column,
                    flex (num 4),
                    paddingLeft (px 40),
                    paddingRight (px 40),
                    paddingBottom (px 40)
                ]][
                    Views.Info.view model.entryPage.infoData model.entryPage.showInfoErrorMsg,
                    Views.Sequence.view,
                    Views.Substrate.view model.entryPage.substrateData model.entryPage.infoData.data.uniprot_ac model.entryPage.infoData.data.gene_name model.entryPage.showSubstrateErrorMsg,
                    Views.Proteoforms.view model.entryPage.proteoformsData model.entryPage.showProteoformsErrorMsg,
                    Views.PTMDependentPPI.view model.entryPage.ptmDependentPPIData model.entryPage.showPTMDepPPIErrorMsg,
                    Views.ProteoformPPI.view model.entryPage.proteoformPPIData model.entryPage.showProteoformsPPIErrorMsg
                ]
            ],

            div[
                        id "filler",
                        css [
                            alignSelf stretch
                        ]
                    ][],

                    Views.Footer.view


        ]


buildCytoscapeItem : CytoscapeItem -> Html Msg
buildCytoscapeItem cytoscapeItem =
    div[css [
        padding (px 8),
        marginTop (px 5),
        marginBottom (px 5),
        backgroundColor (hex "#c7c9cc" ),
        borderRadius (px 20),
        fontSize (Css.em 0.85)
    ]][
        text (interpolate "{0} - {1}" [cytoscapeItem.id_1,cytoscapeItem.id_2])
    ]






