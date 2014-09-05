<?php

require_once( "kernel/common/template.php" );

eZDebug::updateSettings(array(
"debug-enabled" => false,
"debug-by-ip" => false
));

$module = $Params['Module'];
$http = eZHTTPTool::instance();
$tpl = templateInit();
$viewParameters = array();
$availableTranslations = eZContentLanguage::fetchList();
$thisUrl = '/xrowmobilemenu/view';

$tpl->setVariable( 'baseurl', $thisUrl );
$tpl->setVariable( 'node_id', $Params[Parameters][0] );
$tpl->setVariable( 'current_node_id', $Params[Parameters][1] );
$tpl->setVariable( 'root_node_id', $Params[Parameters][2] );

$Result = array();
$Result['pagelayout'] = 'ajax/xrowmobilemenu.tpl';
$Result['path'] = array( array( 'url' => false,
                                'text' => "xrowmobilemenu" ) );

?>