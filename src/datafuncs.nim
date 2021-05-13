type
    Proxy* = object
        url* : string
        keyword_tag* : string
        keyword* : string
        page_tag* : string
        page* : string

    Data* = object   
        img* : string
        name* : string
        website* : string
        link* : string
        dimension* : string

    Api* = object
        link* : string
        keyword_tag* : string
        page_tag* : string
        dimension* : string
        website* : string
        icon* : string
        asset_class* : string
        asset_tag* : string
        name_class* : string
        name_tag* : string
        img_class* : string
        img_tag* : string
        assetlink_class* : string
        assetlink_tag* : string

    Site* = object
        apis* : seq[Api]