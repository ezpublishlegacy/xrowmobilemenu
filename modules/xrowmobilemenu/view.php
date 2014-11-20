<?php

header("Access-Control-Allow-Origin: *", true );
header("Access-Control-Allow-Credentials: true", true );
header("Access-Control-Allow-Methods: GET, OPTIONS", true );
header("Access-Control-Expose-Headers: Content-Type", true );

eZDebug::updateSettings(array(
"debug-enabled" => false,
"debug-by-ip" => false
));

$module = $Params['Module'];
$http = eZHTTPTool::instance();
$tpl = eZTemplate::factory();
$viewParameters = array();
$availableTranslations = eZContentLanguage::fetchList();
$thisUrl = '/xrowmobilemenu/view';

$tpl->setVariable( 'baseurl', $thisUrl );
$tpl->setVariable( 'node_id', $Params[Parameters][0] );
$tpl->setVariable( 'current_node_id', $Params[Parameters][1] );
$tpl->setVariable( 'root_node_id', $Params[Parameters][2] );
$tpl->setVariable( 'focus_current_node', $Params[Parameters][3] );

$Result = array();
$Result['pagelayout'] = 'ajax/xrowmobilemenu.tpl';
$Result['path'] = array( array( 'url' => false,
                                'text' => "xrowmobilemenu" ) );