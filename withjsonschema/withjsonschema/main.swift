//
//  main.swift
//  withjsonschema
//
//  Created by Chakkra CHAK on 08/03/2017.
//  Copyright (c) 2017 Kisio Digital. All rights reserved.
//

import Foundation

let token:String = "9e304161-bb97-4210-b13d-c71eaf58961c"
let coverage:String = "fr-idf"

StopSchedulesResourcesBuilder(token: token, coverage: coverage).build()

RunLoop.main.run()