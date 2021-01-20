/*
 * Created by {{author}} on {{date_day}}/{{date_month}}/{{date_year}}.
 * {{company_header}}
 * Copyright (c) {{date_year}} {{author}}. All rights reserved.
 */

package {{prefix}}.{{company}}.{{app_name}}.viewmodel.entityList

import com.qmobile.qmobileapi.model.entity.EntityModel
import com.qmobile.qmobileapi.network.ApiService
import com.qmobile.qmobiledatasync.viewmodel.EntityListViewModel
import timber.log.Timber

class EntityListViewModel{{tableName}}<T : EntityModel>(
    tableName: String,
    apiService: ApiService
) :
    EntityListViewModel<T>(tableName, apiService) {

    init {
        Timber.i("EntityListViewModel{{tableName}} initializing...")
    }
}
