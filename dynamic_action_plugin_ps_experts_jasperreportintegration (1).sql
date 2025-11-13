--------------------------------------------------------------------------------
-- Name: Sample File Upload and Download
-- Copyright (c) 2012, 2025 Oracle and/or its affiliates.
-- Licensed under the Universal Permissive License v 1.0
-- as shown at https://oss.oracle.com/licenses/upl/
--------------------------------------------------------------------------------
prompt --application/set_environment
set define off verify off feedback off
whenever sqlerror exit sql.sqlcode rollback
--------------------------------------------------------------------------------
--
-- Oracle APEX export file
--
-- You should run this script using a SQL client connected to the database as
-- the owner (parsing schema) of the application or as a database user with the
-- APEX_ADMINISTRATOR_ROLE role.
--
-- This export file has been automatically generated. Modifying this file is not
-- supported by Oracle and can lead to unexpected application and/or instance
-- behavior now or in the future.
--
-- NOTE: Calls to apex_application_install override the defaults below.
--
--------------------------------------------------------------------------------
begin
wwv_flow_imp.import_begin (
 p_version_yyyy_mm_dd=>'2024.11.30'
,p_release=>'24.2.8'
,p_default_workspace_id=>107030261249270219812
,p_default_application_id=>43957
,p_default_id_offset=>107031068598122557523
,p_default_owner=>'WKSP_ABDWS'
);
end;
/
 
prompt APPLICATION 43957 - Sample File Upload and Download
--
-- Application Export:
--   Application:     43957
--   Name:            Sample File Upload and Download
--   Date and Time:   04:16 Thursday November 13, 2025
--   Exported By:     ABDQARAWANI@GMAIL.COM
--   Flashback:       0
--   Export Type:     Component Export
--   Manifest
--     PLUGIN: 109066509387381702365
--   Manifest End
--   Version:         24.2.8
--   Instance ID:     63113759365424
--

begin
  -- replace components
  wwv_flow_imp.g_mode := 'REPLACE';
end;
/
prompt --application/shared_components/plugins/dynamic_action/ps_experts_jasperreportintegration
begin
wwv_flow_imp_shared.create_plugin(
 p_id=>wwv_flow_imp.id(109066509387381702365)
,p_plugin_type=>'DYNAMIC ACTION'
,p_name=>'PS.EXPERTS.JASPERREPORTINTEGRATION'
,p_display_name=>'JasperReport Integration'
,p_category=>'EXECUTE'
,p_plsql_code=>wwv_flow_string.join(wwv_flow_t_varchar2(
'/*define these application items: ',
'Name	        		Computed On	  		Protection Level				Scope		',
'APP_DATE_FORMAT					Restricted - May not be set from browser	Application				',
'JRI_DATASOURCE						Restricted - May not be set from browser	Application				',
'JRI_PRINTER_NAME					Restricted - May not be set from browser	Application				',
'JRI_URL							Restricted - May not be set from browser	Application',
'-----------------------------------------------------------------',
'define this application process after authentication:  ',
':APP_DATE_FORMAT := ''DD-MM-YYYY'';',
':JRI_URL := ''http://localhost:8888/jri/report'';',
':JRI_DATASOURCE := ''inv'';',
':JRI_PRINTER_NAME := ''HP LaserJet Pro MFP M127-M128 PCLmS'';*/',
'',
'FUNCTION render_jasper_report (',
'    p_dynamic_action IN apex_plugin.t_dynamic_action,',
'    p_plugin         IN apex_plugin.t_plugin',
') RETURN apex_plugin.t_dynamic_action_render_result IS',
'    l_additional_parameters VARCHAR2(32767);',
'    l_result                apex_plugin.t_dynamic_action_render_result;',
'',
'    -- Local function to get plugin attribute values safely',
'    FUNCTION get_attr (p_attr_no IN NUMBER) RETURN VARCHAR2 IS',
'        l_value VARCHAR2(4000);',
'    BEGIN',
'        -- Access the value of the custom attributes defined in the App Builder',
'        -- These are mapped to Attribute 01, 02, etc.',
'        IF p_attr_no = 1 THEN l_value := p_dynamic_action.attribute_01;',
'        ELSIF p_attr_no = 2 THEN l_value := p_dynamic_action.attribute_02;',
'        ELSIF p_attr_no = 3 THEN l_value := p_dynamic_action.attribute_03;',
'        ELSIF p_attr_no = 4 THEN l_value := p_dynamic_action.attribute_04;',
'        ELSIF p_attr_no = 5 THEN l_value := p_dynamic_action.attribute_05;',
'        ELSIF p_attr_no = 6 THEN l_value := p_dynamic_action.attribute_06;',
'        ELSIF p_attr_no = 7 THEN l_value := p_dynamic_action.attribute_07;',
'        END IF;',
'        ',
'        -- Resolve the session state for page items passed in the attributes',
'        IF l_value IS NOT NULL AND INSTR(l_value, '':'') > 0 THEN',
'           RETURN v(l_value);',
'        ELSE',
'           RETURN l_value;',
'        END IF;',
'    END get_attr;',
'',
'BEGIN',
'    -- The actual logic goes here. Use get_attr() to retrieve configuration.',
'',
'    -- Set Jasper Report server URL using the plugin attribute (Attribute 01)',
'  --  xlib_jasperreports.set_report_url(get_attr(1));',
'',
'    -- Prepare URL parameters using plugin attributes (Attributes 05, 06, 07)',
'    IF get_attr(5) IS NOT NULL THEN',
'      l_additional_parameters := ''&p_date1='' ||',
'        apex_util.url_encode(TO_CHAR(TO_DATE(get_attr(5), ''YYYY-MM-DD''), ''YYYY-MM-DD''));',
'    END IF;',
'',
'    IF get_attr(6) IS NOT NULL THEN',
'      l_additional_parameters := l_additional_parameters || ''&p_date2='' ||',
'        apex_util.url_encode(TO_CHAR(TO_DATE(get_attr(6), ''YYYY-MM-DD''), ''YYYY-MM-DD''));',
'    END IF;',
'',
'    IF get_attr(7) IS NOT NULL THEN',
'      l_additional_parameters := l_additional_parameters || ''&p_acc_no='' ||',
'        apex_util.url_encode(get_attr(7));',
'    END IF;',
'',
'    -- Generate and show the report (using Attributes 02, 03, 04, 07)',
'   /* xlib_jasperreports.show_report (',
'      p_rep_name       => get_attr(2),',
'      p_rep_format     => get_attr(3),',
'      p_data_source    => get_attr(4),',
'      p_rep_locale     => ''en-US'',',
'      p_out_filename   => APEX_UTIL.URL_ENCODE(''report_'' || get_attr(7) || ''.'' || get_attr(3)),',
'      p_additional_params => l_additional_parameters',
'    );*/',
'',
'    -- This line handles the redirection correctly within the APEX flow for processes/dynamic actions',
'    apex_application.g_unrecoverable_error := true;',
'',
'    -- Dynamic action plugins that execute PL/SQL must return a valid result record,',
'    -- even if they don''t produce client-side effects (like a redirect).',
'    RETURN l_result;',
'',
'EXCEPTION',
'    WHEN OTHERS THEN',
'        -- Add error handling/logging here',
'        apex_debug.error(''Error in jasper report plugin: %s'', SQLERRM);',
'        RETURN l_result;',
'END render_jasper_report;',
'',
'',
''))
,p_api_version=>1
,p_render_function=>'render_jasper_report'
,p_standard_attributes=>'STOP_EXECUTION_ON_ERROR:WAIT_FOR_RESULT'
,p_substitute_attributes=>true
,p_version_scn=>15670926171067
,p_subscribe_plugin_settings=>true
,p_version_identifier=>'24.2'
,p_about_url=>'https://github.com/AbdulrahmanQerawani/JasperReportsIntegration/tree/abdulrahman'
);
wwv_flow_imp_shared.create_plugin_attribute(
 p_id=>wwv_flow_imp.id(109077187117761690389)
,p_plugin_id=>wwv_flow_imp.id(109066509387381702365)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>1
,p_display_sequence=>10
,p_prompt=>'report_url'
,p_attribute_type=>'TEXT'
,p_is_required=>true
,p_default_value=>'test'
,p_is_translatable=>false
);
wwv_flow_imp_shared.create_plugin_attribute(
 p_id=>wwv_flow_imp.id(109077902224029022969)
,p_plugin_id=>wwv_flow_imp.id(109066509387381702365)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>2
,p_display_sequence=>20
,p_prompt=>'report_name'
,p_attribute_type=>'TEXT'
,p_is_required=>true
,p_default_value=>'test'
,p_is_translatable=>false
);
wwv_flow_imp_shared.create_plugin_attribute(
 p_id=>wwv_flow_imp.id(109078050972891028638)
,p_plugin_id=>wwv_flow_imp.id(109066509387381702365)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>3
,p_display_sequence=>30
,p_prompt=>'report_format'
,p_attribute_type=>'SELECT LIST'
,p_is_required=>true
,p_default_value=>'PDF'
,p_is_translatable=>false
,p_lov_type=>'STATIC'
);
wwv_flow_imp_shared.create_plugin_attr_value(
 p_id=>wwv_flow_imp.id(109077757199889716425)
,p_plugin_attribute_id=>wwv_flow_imp.id(109078050972891028638)
,p_display_sequence=>10
,p_display_value=>'PDF'
,p_return_value=>'pdf'
,p_is_quick_pick=>true
);
wwv_flow_imp_shared.create_plugin_attribute(
 p_id=>wwv_flow_imp.id(109077776555167720020)
,p_plugin_id=>wwv_flow_imp.id(109066509387381702365)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>4
,p_display_sequence=>40
,p_prompt=>'data_source'
,p_attribute_type=>'TEXT'
,p_is_required=>true
,p_default_value=>'HR'
,p_is_translatable=>false
);
wwv_flow_imp_shared.create_plugin_attribute(
 p_id=>wwv_flow_imp.id(109078362797881039326)
,p_plugin_id=>wwv_flow_imp.id(109066509387381702365)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>5
,p_display_sequence=>50
,p_prompt=>'from_date'
,p_attribute_type=>'TEXT'
,p_is_required=>false
,p_is_translatable=>false
);
wwv_flow_imp_shared.create_plugin_attribute(
 p_id=>wwv_flow_imp.id(109077821813838726376)
,p_plugin_id=>wwv_flow_imp.id(109066509387381702365)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>6
,p_display_sequence=>60
,p_prompt=>'to_date'
,p_attribute_type=>'TEXT'
,p_is_required=>false
,p_is_translatable=>false
);
wwv_flow_imp_shared.create_plugin_attribute(
 p_id=>wwv_flow_imp.id(109078508849655045095)
,p_plugin_id=>wwv_flow_imp.id(109066509387381702365)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>7
,p_display_sequence=>70
,p_prompt=>'acc_no'
,p_attribute_type=>'TEXT'
,p_is_required=>false
,p_is_translatable=>false
);
end;
/
prompt --application/end_environment
begin
wwv_flow_imp.import_end(p_auto_install_sup_obj => nvl(wwv_flow_application_install.get_auto_install_sup_obj, false)
);
commit;
end;
/
set verify on feedback on define on
prompt  ...done
