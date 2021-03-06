module Page.BatchResult exposing (..)
import Html.Styled exposing (..)
import Css exposing (..)
import Html.Styled.Attributes exposing (..)
import Msgs exposing (..)
import RemoteData exposing (WebData)
import Views.Navbar
import Views.Score
import Views.Tabs
import String.Interpolate exposing (interpolate)
import String.Extra
import List
import Model.AppModel exposing (..)
import Model.BatchPage as BatchPage exposing (..)
import Model.BatchEnzyme exposing (..)
import Model.BatchPTMPPI exposing (..)
import Model.Kinase exposing (..)
import Model.Misc exposing (..)
import Model.Source exposing (..)

view : Model -> Html Msg
view model =  
            div [id "page",css [
            displayFlex,
            flexDirection column]] 
            [  

            Views.Navbar.view model.navbar,

            case model.batchPage.outputType of
                BatchPage.Enzymes ->
                    batchEnzymesView model
                BatchPage.PTMPPI ->
                    batchPTMPPIView model
        ]

batchEnzymesView: Model -> Html Msg
batchEnzymesView model =
            
            div [
                css [
                    displayFlex,
                    flexDirection column,
                    marginLeft (px 10),
                    marginRight (px 10)
                ]
            ][
                
                -- tabs
                div [
                    css [
                        marginTop (px 20),
                        marginBottom (px 20),
                        marginRight auto                        
                    ]
                ][
                    let
                        tabs = [
                            {
                                title = "Input sites found in iPTMnet",
                                count = model.batchPage.batchEnzymeData.data.list_found.count
                            },
                            {
                                title = "Input sites not found in iPTMnet",
                                count = List.length model.batchPage.batchEnzymeData.data.list_not_found
                            }
                        ]

                        tabData = {
                            tabs = tabs,
                            selectedTab = model.batchPage.selectedTab
                        }

                    in
                        Views.Tabs.view tabData Msgs.OnBatchTabClick
                ],
                case model.batchPage.selectedTab of
                    "Input sites not found in iPTMnet" -> 
                        renderKinaseTable model.batchPage.batchEnzymeData.data.list_not_found
                    _ -> 
                         renderEnzymesTable model.batchPage.batchEnzymeData.data.list_found.with_enzyme model.batchPage.batchEnzymeData.data.list_found.without_enzyme

            ]

renderEnzymesTable: (List BatchEnzyme) -> (List BatchEnzyme) -> Html Msg
renderEnzymesTable withEnzyme withoutEnzyme =
    div [

    ][
                -- label
                div [
                    id "lbl_ptm_with_enzyme",
                    css [
                        fontSize (Css.em 1.2),
                        fontWeight bold,
                        marginTop (px 5),
                        marginLeft (px 5),
                        marginBottom (px 10)
                    ]
                ][
                    text "PTM with Enzyme" 
                ],

                -- ptm with enzyme table
                div [id "ptm_with_enzyme_table", css [
                    displayFlex,
                    flexDirection column,
                    fontSize (px 13),
                    borderWidth (px 1),
                    borderStyle solid,
                    borderColor (hex "#d9dadb")
                ]][
                    -- header
                    div [id "header", css [
                        displayFlex,
                        flexDirection row,
                        backgroundColor (hex "#eff1f2"),
                        paddingTop (px 5),
                        paddingBottom (px 5),
                        fontWeight bold,
                        alignItems center
                    ]] [
                        div [css [flex (num 1),
                                marginLeft (px 5),
                                marginRight (px 20),
                                paddingLeft (px 5),
                                displayFlex,
                                flexDirection row,
                                alignItems center
                            ]]
                        [
                            input [type_ "checkbox", css[marginLeft (px 5), marginRight (px 15)]][],
                            text "PTM Type"
                        ],
                        div [css [flex (num 1),
                            marginRight (px 20)         
                            ]]
                        [
                            text "Substrate"
                        ],
                        div [css [flex (num 1),
                                marginRight (px 20)
                                ]]
                        [
                            text "Site"
                        ],
                        div [css [flex (num 1),
                                marginRight (px 20)
                                ]]
                        [
                            text "PTM Enzyme"
                        ],
                        div [css [flex (num 1),
                                marginRight (px 20)
                                ]]
                        [
                            text "Score"
                        ],
                        div [css [flex (num 1),
                                marginRight (px 20)
                                ]]
                        [
                            text "Source"
                        ],
                        div [css [flex (num 1),
                                marginRight (px 20)
                                ]]
                        [
                            text "PMID"
                        ]         

                    ],

                    -- rows
                    div [id "body"] (List.map enzymeResultRow withEnzyme)
                
                ],

                -- label
                div [
                    id "lbl_ptm_with_out_enzyme",
                    css [
                        fontSize (Css.em 1.2),
                        fontWeight bold,
                        marginTop (px 25),
                        marginLeft (px 5),
                        marginBottom (px 10)
                    ]
                ][
                    text "PTM without Enzyme" 
                ],

                -- ptm with enzyme table
                div [id "ptm_without_enzyme_table", css [
                    displayFlex,
                    flexDirection column,
                    fontSize (px 13),
                    borderWidth (px 1),
                    borderStyle solid,
                    borderColor (hex "#d9dadb")
                ]][
                    -- header
                    div [id "header", css [
                        displayFlex,
                        flexDirection row,
                        backgroundColor (hex "#eff1f2"),
                        paddingTop (px 5),
                        paddingBottom (px 5),
                        fontWeight bold,
                        alignItems center
                    ]] [
                        div [css [flex (num 1),
                                marginLeft (px 5),
                                marginRight (px 20),
                                paddingLeft (px 5),
                                displayFlex,
                                flexDirection row,
                                alignItems center
                            ]]
                        [
                            input [type_ "checkbox", css[marginLeft (px 5), marginRight (px 15)]][],
                            text "PTM Type"
                        ],
                        div [css [flex (num 1),
                            marginRight (px 20)         
                            ]]
                        [
                            text "Substrate"
                        ],
                        div [css [flex (num 1),
                                marginRight (px 20)
                                ]]
                        [
                            text "Site"
                        ],
                        div [css [flex (num 1),
                                marginRight (px 20)
                                ]]
                        [
                            text "PTM Enzyme"
                        ],
                        div [css [flex (num 1),
                                marginRight (px 20)
                                ]]
                        [
                            text "Score"
                        ],
                        div [css [flex (num 1),
                                marginRight (px 20)
                                ]]
                        [
                            text "Source"
                        ],
                        div [css [flex (num 1),
                                marginRight (px 20)
                                ]]
                        [
                            text "PMID"
                        ]         

                    ],

                    -- rows
                    div [id "body"] (List.map enzymeResultRow withoutEnzyme)
                
                ]
    ]

enzymeResultRow: BatchEnzyme -> Html Msg
enzymeResultRow enzyme = 
    div [id "enzyme_table_row", css [
                    displayFlex,
                    flexDirection row,
                    paddingTop (px 10),
                    paddingBottom (px 10),
                    hover [
                        backgroundColor (hex "#0000000D")
                    ]
                ]] [
                    div [
                        id "ptm_type",
                        css [flex (num 1),
                            marginLeft (px 5),
                            marginRight (px 20),
                            paddingLeft (px 5),
                            displayFlex,
                            flexDirection row,
                            alignItems center
                        ]]
                    [
                        input [type_ "checkbox", css[marginLeft (px 5), marginRight (px 15)]][],
                        text enzyme.ptm_type
                    ],
                    div [
                        id "substrate",
                        css [flex (num 1),
                        marginRight (px 20)         
                        ]]
                    [
                        text enzyme.substrate.uniprot_id
                    ],
                    div [
                        id "site",
                        css [flex (num 1),
                            marginRight (px 20)
                            ]]
                    [
                        text enzyme.site
                    ],
                    div [
                        id "ptm_enzyme",
                        css [flex (num 1),
                            marginRight (px 20)
                            ]]
                    [
                        text enzyme.enzyme.uniprot_id
                    ],
                    div [
                        id "score",
                        css [flex (num 1),
                            marginRight (px 20)
                            ]]
                    [
                        Views.Score.view enzyme.score
                    ],
                    div [
                        id "source",
                        css [flex (num 1),
                            marginRight (px 20)
                            ]]
                    [
                        div [] (List.map buildSource enzyme.source |> List.intersperse (span [css [display inline]] [text ", "]))
                    ],
                    div [
                        id "pmid",
                        css [flex (num 1),
                            marginRight (px 20)
                            ]]
                    [
                        div [] (case (List.length enzyme.pmids) > 3 of
                                    False -> 
                                        (List.map buildPMID enzyme.pmids |> List.intersperse (span [css [display inline]] [text ",  "]))
                                    True ->
                                        let 
                                            trimmed_list = (List.take 3 enzyme.pmids) ++ ["..."]
                                                           |> List.map buildPMID
                                                           |> List.intersperse (span [css [display inline]] [text ",  "])
                                        in 
                                            trimmed_list
                                )
                    ]                                   

                ]


batchPTMPPIView: Model -> Html Msg
batchPTMPPIView model =
            div [
                css [
                    displayFlex,
                    flexDirection column,
                    marginLeft (px 10),
                    marginRight (px 10)
                ]
            ][
                
                -- tabs
                div [
                    css [
                        marginTop (px 20),
                        marginBottom (px 20),
                        marginRight auto                        
                    ]
                ][
                    let
                        tabs = [
                            {
                                title = "PTM Dependent PPIs",
                                count = List.length model.batchPage.batchPTMPPIData.data.ptm_ppi
                            },
                            {
                                title = "Sites without interactants",
                                count = List.length model.batchPage.batchEnzymeData.data.list_not_found
                            },
                            {
                                title = "Input site not found in iPTMnet",
                                count = List.length model.batchPage.batchPTMPPIData.data.not_found
                            }
                        ]

                        tabData = {
                            tabs = tabs,
                            selectedTab = model.batchPage.selectedTab
                        }

                    in
                        Views.Tabs.view tabData Msgs.OnBatchTabClick
                ],
                case model.batchPage.selectedTab of
                    "Input site not found in iPTMnet" -> 
                        renderKinaseTable model.batchPage.batchPTMPPIData.data.not_found
                    "Sites without interactants" ->
                        renderKinaseTable model.batchPage.batchPTMPPIData.data.sites_without_interactants
                    _ -> 
                         renderPTMPPITable model.batchPage.batchPTMPPIData.data.ptm_ppi
            ]


renderPTMPPITable: (List BatchPTMPPI) -> Html Msg
renderPTMPPITable ptm_ppi =
    div [

    ][

                -- ptm ppi table
                div [id "ptm_with_enzyme_table", css [
                    displayFlex,
                    flexDirection column,
                    fontSize (px 13),
                    borderWidth (px 1),
                    borderStyle solid,
                    borderColor (hex "#d9dadb")
                ]][
                    -- header
                    div [id "header", css [
                        displayFlex,
                        flexDirection row,
                        backgroundColor (hex "#eff1f2"),
                        paddingTop (px 5),
                        paddingBottom (px 5),
                        fontWeight bold,
                        alignItems center
                    ]] [
                        div [css [flex (num 1),
                            marginLeft (px 10),
                            marginRight (px 20)         
                            ]]
                        [
                            text "Substrate"
                        ],
                        div [css [flex (num 1),
                                marginRight (px 20)
                                ]]
                        [
                            text "Site"
                        ],
                        div [css [flex (num 1),
                                marginRight (px 20)
                                ]]
                        [
                            text "Interactant"
                        ],
                        div [css [flex (num 1),
                                marginRight (px 20)
                                ]]
                        [
                            text "Association Type"
                        ],
                        div [css [flex (num 1),
                                marginRight (px 20)
                                ]]
                        [
                            text "Source"
                        ],
                        div [css [flex (num 1),
                                marginRight (px 20)
                                ]]
                        [
                            text "PMID"
                        ]         

                    ],

                    -- rows
                    div [id "body"] (List.map ptmPPIResultRow ptm_ppi)
                
                ]
    ]


ptmPPIResultRow: BatchPTMPPI -> Html Msg
ptmPPIResultRow ptmppi = 
    div [id "ptmppi_table_row", css [
                    displayFlex,
                    flexDirection row,
                    paddingTop (px 10),
                    paddingBottom (px 10),
                    hover [
                        backgroundColor (hex "#0000000D")
                    ]
                ]] [
                    div [
                        id "substrate",
                        css [flex (num 1),
                        marginLeft (px 10),
                        marginRight (px 20)         
                        ]]
                    [
                        text ptmppi.substrate.uniprot_id
                    ],
                    div [
                        id "site",
                        css [flex (num 1),
                            marginRight (px 20)
                            ]]
                    [
                        text ptmppi.site
                    ],
                    div [
                        id "interactant",
                        css [flex (num 1),
                            marginRight (px 20)
                            ]]
                    [
                        text ptmppi.interactant.uniprot_id
                    ],
                    div [
                        id "association_type",
                        css [flex (num 1),
                            marginRight (px 20)
                            ]]
                    [
                        text ptmppi.association_type
                    ],
                    div [
                        id "source",
                        css [flex (num 1),
                            marginRight (px 20)
                            ]]
                    [
                        div [] [text ptmppi.source.name]
                    ],
                    div [
                        id "pmid",
                        css [flex (num 1),
                            marginRight (px 20)
                            ]]
                    [
                        div [] (case (List.length ptmppi.pmid) > 3 of
                                    False -> 
                                        (List.map buildPMID ptmppi.pmid |> List.intersperse (span [css [display inline]] [text ",  "]))
                                    True ->
                                        let 
                                            trimmed_list = (List.take 3 ptmppi.pmid) ++ ["..."]
                                                           |> List.map buildPMID
                                                           |> List.intersperse (span [css [display inline]] [text ",  "])
                                        in 
                                            trimmed_list
                                )
                    ]                                   

                ]


renderKinaseTable: (List Kinase) -> Html Msg
renderKinaseTable kinases =
                -- ptm with enzyme table
                div [id "ptm_with_enzyme_table", css [
                    displayFlex,
                    flexDirection column,
                    fontSize (px 13),
                    borderWidth (px 1),
                    borderStyle solid,
                    borderColor (hex "#d9dadb")
                ]][
                    -- header
                    div [id "header", css [
                        displayFlex,
                        flexDirection row,
                        backgroundColor (hex "#eff1f2"),
                        paddingTop (px 5),
                        paddingBottom (px 5),
                        fontWeight bold,
                        alignItems center
                    ]] [
                        div [css [flex (num 1),
                            marginRight (px 20),
                            paddingLeft (px 10)         
                            ]]
                        [
                            text "Substrate AC"
                        ],
                        div [css [flex (num 1),
                                marginRight (px 20)
                                ]]
                        [
                            text "Site Residue"
                        ],
                        div [css [flex (num 1),
                                marginRight (px 20)
                                ]]
                        [
                            text "Site Position"
                        ]
                    ],

                    -- rows
                    div [id "body"] (List.map kinaseRow kinases)
                
                ] 

kinaseRow : Kinase -> Html Msg
kinaseRow kinase =
        div [id "enzyme_table_row", css [
                    displayFlex,
                    flexDirection row,
                    paddingTop (px 10),
                    paddingBottom (px 10),
                    hover [
                        backgroundColor (hex "#0000000D")
                    ]
                ]] [
                    div [
                        id "substrate_ac",
                        css [flex (num 1),
                        marginRight (px 20),
                        paddingLeft (px 10)         
                        ]]
                    [
                        text kinase.substrate_ac
                    ],
                    div [
                        id "site_residue",
                        css [flex (num 1),
                            marginRight (px 20)
                            ]]
                    [
                        text kinase.site_residue
                    ],
                    div [
                        id "site_position",
                        css [flex (num 1),
                            marginRight (px 20)
                            ]]
                    [
                        text kinase.site_position
                    ]                                  

            ]
     


decodeEnzymeResponse: WebData (List BatchEnzyme) -> (List Kinase) -> BatchEnzymeData 
decodeEnzymeResponse response kinases = 
    case response of
        RemoteData.NotAsked ->
            {
                status = NotAsked,
                error = "",
                data = {
                    list_found = {
                        count = 0,
                        with_enzyme = [],
                        without_enzyme = []
                    },
                    list_not_found = []
                }
            }

        RemoteData.Loading ->
            {
                status = Loading,
                error = "",
                data = {
                    list_found = {
                        count = 0,
                        with_enzyme = [],
                        without_enzyme = []
                    },
                    list_not_found = []
                }
            }

        RemoteData.Success enzymeList ->
            let
                with_enzyme = List.filter isEnzymeNotEmpty enzymeList
                without_enzyme = List.filter isEnzymeEmpty enzymeList
                sites_not_found = List.filter (isKinaseNotPresentInEnzymeList enzymeList) kinases 
                _ = Debug.log "sites_not_found" sites_not_found 
            in
                {
                    status = Success,
                    error = "",
                    data = {
                        list_found = {
                            count = (List.length kinases) - (List.length sites_not_found),
                            with_enzyme = with_enzyme,
                            without_enzyme = without_enzyme
                        },
                        list_not_found = sites_not_found
                    }
                }

        RemoteData.Failure error ->
            {
                status = Error,
                error = (toString error),
                data = {
                    list_found = {
                        count = 0,
                        with_enzyme = [],
                        without_enzyme = []
                    },
                    list_not_found = []
                }
            }

decodePTMPPIResponse: WebData (List BatchPTMPPI) -> (List Kinase) -> BatchPTMPPIData 
decodePTMPPIResponse response kinases = 
    case response of
        RemoteData.NotAsked ->
            {
                status = NotAsked,
                error = "",
                data = {
                    ptm_ppi = [],
                    sites_without_interactants = [],
                    not_found = []
                }  
            }

        RemoteData.Loading ->
            {
                status = Loading,
                error = "",
                data = {
                    ptm_ppi = [],
                    sites_without_interactants = [],
                    not_found = []
                }
            }

        RemoteData.Success ptmPPIList ->
            let
                ptm_ppi = List.filter isInteractantNotEmpty ptmPPIList
                sites_without_interactants = []
                not_found = List.filter (isKinaseNotPresentInPTMPPIList ptmPPIList) kinases
            in
                {
                    status = Success,
                    error = "",
                    data = {
                        ptm_ppi = ptm_ppi,
                        sites_without_interactants = [],
                        not_found = not_found
                    }
                }

        RemoteData.Failure error ->
            {
                status = Error,
                error = (toString error),
                data = {
                    ptm_ppi = [],
                    sites_without_interactants = [],
                    not_found = []
                }
            }

isEnzymeEmpty : BatchEnzyme -> Bool
isEnzymeEmpty batchEnzyme = 
    String.Extra.isBlank batchEnzyme.enzyme.uniprot_id

isEnzymeNotEmpty : BatchEnzyme -> Bool
isEnzymeNotEmpty batchEnzyme =
    not (isEnzymeEmpty batchEnzyme)

isKinaseNotPresentInEnzymeList : (List BatchEnzyme) -> Kinase -> Bool
isKinaseNotPresentInEnzymeList batchEnzymes kinase =
    List.filter (\enz -> (kinase.site_residue ++ kinase.site_position) == enz.site) batchEnzymes
    |> List.isEmpty


isInteractantEmpty : BatchPTMPPI -> Bool
isInteractantEmpty batchPTMPPI = 
    String.Extra.isBlank batchPTMPPI.interactant.uniprot_id

isInteractantNotEmpty : BatchPTMPPI -> Bool
isInteractantNotEmpty batchPTMPPI = 
    not (isInteractantEmpty batchPTMPPI)

isKinaseNotPresentInPTMPPIList : (List BatchPTMPPI) -> Kinase -> Bool
isKinaseNotPresentInPTMPPIList batchPTMPPIs kinase =
    List.filter (\ptm_ppi -> (kinase.site_residue ++ kinase.site_position) == ptm_ppi.site) batchPTMPPIs
    |> List.isEmpty

buildSource: Source -> Html Msg 
buildSource source =
    a [
        css [
            display inline
        ],
        href "#",
        Html.Styled.Attributes.target "_blank"
    ] [
        text source.name
    ]

buildPMID: String -> Html Msg
buildPMID pmid =
    a [css [display inline], 
       href (interpolate "https://www.ncbi.nlm.nih.gov/pubmed/{0}" [pmid]), Html.Styled.Attributes.target "_blank"] [text pmid]