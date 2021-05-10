type
    Data* = object   
        img* : string
        name* : string
        website* : string
        link* : string
        dimension* : string

    Api* = object
        link* : string
        dimension* : string
        website* : string
        icon* : string
        icon_tag* : string
        asset_class* : string
        asset_tag* : string
        name_class* : string
        name_tag* : string
        img_class* : string
        img_tag* : string
        assetlink_class* : string
        assetlink_tag* : string

    Site* = object
        logo* : string
        apis* : seq[Api]