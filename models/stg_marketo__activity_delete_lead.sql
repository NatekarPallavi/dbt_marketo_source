with base as (

    select *
    from {{ ref('stg_marketo__activity_delete_lead_tmp') }}

), macro as (

    select
        {{
            fivetran_utils.fill_staging_columns(
                source_columns=adapter.get_columns_in_relation(ref('stg_marketo__activity_delete_lead_tmp')),
                staging_columns=get_activity_delete_lead_columns()
            )
        }}
    from base

), fields as (

    select
        id as activity_id,
        _fivetran_synced,
        cast(activity_date as {{ dbt_utils.type_timestamp() }}) as activity_timestamp, -- ensure timestamp is passed without timezone in Redshift 
        activity_type_id,
        campaign as campaign_name,
        campaign_id,
        lead_id,
        primary_attribute_value,
        primary_attribute_value_id
    from macro

)

select *
from fields

