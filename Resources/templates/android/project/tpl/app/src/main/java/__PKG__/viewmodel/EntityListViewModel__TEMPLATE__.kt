/*
 * Created by {{author}} on {{date_day}}/{{date_month}}/{{date_year}}.
 * {{company_header}}
 * Copyright (c) {{date_year}} {{author}}. All rights reserved.
 */

package {{package}}.viewmodel

import com.qmobile.qmobileapi.network.ApiService
import com.qmobile.qmobiledatasync.viewmodel.EntityListViewModel
import {{package}}.data.model.entity.{{tableName}}
import timber.log.Timber

class EntityListViewModel{{tableName}}(

    tableName: String,
    apiService: ApiService
) :
    EntityListViewModel<{{tableName}}>(tableName, apiService) {

    init {
        Timber.v("EntityListViewModel{{tableName}} initializing...")
    }
}
