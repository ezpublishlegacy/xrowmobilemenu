{def $root_node = fetch( 'content', 'node', hash( 'node_id', cond($node_id|is_numeric(), $node_id , cond($root_node_id|is_numeric(), $root_node_id, ezini('NodeSettings', 'RootNode','content.ini') ) ) ) )
     $content_node = fetch( 'content', 'node', hash( 'node_id', ezini('NodeSettings', 'RootNode','content.ini') ) )
     $current_depth = $root_node.depth|sub($content_node.depth)
     $limit = 50
     $top_menu_class_filter = ezini( 'MenuContentSettings', 'TopIdentifierList', 'menu.ini' )
     $top_menu_items = fetch( 'content', 'list', hash( 'parent_node_id', $root_node.node_id,
                                                       'sort_by', $root_node.sort_array,
                                                       'limit', $limit,
                                                       'class_filter_type', 'include',
                                                       'class_filter_array', $top_menu_class_filter ) )
     $top_menu_items_count = $top_menu_items|count()
     $item_class = array()}
{if $top_menu_items_count}
    {if $node_id|is_numeric()|not()}
        <div class="xrow-mobile-menu">
    {/if}
        <ul>
            {if $node_id|is_numeric()}
                <li>
                    <span class="back" data-depth="{$current_depth|dec}">
                        {"back"|i18n("extension/xrowmobilemenu")}
                    </span>
                </li>
            {/if}
            <li>
                <a class="current" href={$root_node.url_alias|ezurl}>
                    {$root_node.name}
                </a>
            </li>
            {foreach $top_menu_items as $key => $item}
                {set $item_class = array()}
                {if $key|eq(0)}
                    {set $item_class = $item_class|append("firstli")}
                {/if}
                {if $top_menu_items_count|eq( $key|inc )}
                    {set $item_class = $item_class|append("lastli")}
                {/if}
                {if $item.node_id|eq( $current_node_id )}
                    {set $item_class = $item_class|append("current")}
                {/if}
                {if eq( $item.class_identifier, 'link')}
                    <li {if $item_class} class="{$item_class|implode(" ")}"{/if}>
                        <a href={$item.data_map.location.content|ezurl}{if and( is_set( $item.data_map.open_in_new_window ), $item.data_map.open_in_new_window.data_int )} target="_blank"{/if} title="{$item.data_map.location.data_text|wash}" rel={$item.url_alias|ezurl}>
                            {if $item.data_map.location.data_text}
                                {$item.data_map.location.data_text|wash()}
                            {else}
                                {$item.name|wash()}
                            {/if}
                        </a>
                    </li>
                {else}
                    {def $children_count = fetch('content', 'list_count', hash('parent_node_id', $item.node_id,
                                                                               'limit', $limit,
                                                                               'class_filter_type', 'include',
                                                                               'class_filter_array', $top_menu_class_filter))}
                    {if $children_count|gt(0)}
                        {set $item_class = $item_class|append("children")|append(concat("depth-", $current_depth))}
                    {/if}
                    {if and($node_id|is_numeric()|not(), $focus_current_node|eq('true'))}
                        {def $path = fetch('content', 'node', hash('node_id', $current_node_id)).path_string|explode("/")
                             $path_nodes = array()}
                        {if $path|contains($item.node_id)}
                            {foreach $path as $path_node_id}
                                {if $root_node.path_string|explode("/")|contains($path_node_id)|not()}
                                    {def $tmp_node = fetch('content', 'node', hash('node_id', $path_node_id))}
                                    {if $sub_menu_class_filter|contains($tmp_node.class_identifier)}
                                        {set $path_nodes = $path_nodes|append($tmp_node)}
                                    {else}
                                        {break}
                                    {/if}
                                    {undef $tmp_node}
                                {/if}
                            {/foreach}
                            {def $path_nodes_count = $path_nodes|count()}
                            {if $path_nodes_count|gt(0)}
                                {set $item_class = $item_class|append("active")}
                            {/if}
                        {/if}
                    {/if}
                    <li{if $item_class} class="{$item_class|implode(" ")}"{/if}{if $children_count|gt(0)} data-nodeid="{$item.node_id}"{/if}>
                        {if $children_count|le(0)}
                            <a href={$item.url_alias|ezurl}>
                        {else}
                            <span data-depth="{$current_depth|inc}">
                        {/if}
                            {$item.name|wash()}
                        {if $children_count|le(0)}
                            </a>
                        {else}
                            </span>
                        {/if}
                        {if and($path_nodes_count|gt(0), $path|contains($item.node_id))}
                            {def $current_path = array()}
                            {foreach $path_nodes as $tmp_item}
                                {def $hash = hash( 'text', $tmp_item.name|wash(),
                                                   'url', concat('/content/view/full/', $tmp_item.node_id),
                                                   'url_alias', $tmp_item.url_alias,
                                                   'node_id', $tmp_item.node_id )}
                                {set $current_path = $current_path|append($hash)}
                                {undef $hash}
                            {/foreach}
                            {def $docs=treemenu( $current_path, null(), $sub_menu_class_filter, 0, 20, 'tree', '10' )
                                 $depth=0}
                                {if $docs|count|gt(0)}
                                    <ul>
                                        <li>
                                            <span class="back" data-depth="0">
                                                {"back"|i18n("extension/xrowmobilemenu")}
                                            </span>
                                        </li>
                                        <li>
                                            <a class="current" href={$root_node.url_alias|ezurl}>
                                                {$item.name|wash()}
                                            </a>
                                        </li>
                                        {foreach $docs as $key => $menu}
                                            {if and( is_set( $menu.node.data_map.hide ), $menu.node.data_map.hide.content )}{skip}{/if}
                                            {if $depth|ne( $menu.level )}
                                                {if $depth|gt( $menu.level )}
                                                    {* closing menu *}
                                                    {concat('<li class="closemenu"><span>','close menu'|i18n("extension/hannover/wifoe"),'</span></li></ul>')|repeat(sub($depth,$menu.level))}
                                                {else}
                                                    {* add menu *}
                                                    <ul>
                                                        <li>
                                                            <span class="back" data-depth="{$menu.level}">
                                                                {"back"|i18n("extension/xrowmobilemenu")}
                                                            </span>
                                                        </li>
                                                        <li>
                                                            <a class="current" href={$menu.node.parent.url_alias|ezurl}>
                                                                {$menu.node.parent.name|wash()}
                                                            </a>
                                                        </li>
                                                {/if}
                                            {/if}
                                            <li {if $menu.has_children}data-nodeid="{$menu.id}" {/if}class="depth-{$menu.level|inc}{if and($path_nodes_count|dec|ne($menu.level|inc), $menu.is_selected)} active{/if}{if and($path_nodes_count|dec|eq($menu.level|inc), $menu.is_selected)} selected{/if}{if $menu.has_children} children{/if}">
                                                {if $menu.has_children}
                                                    <span data-depth="{$menu.level|sum(2)}">
                                                        {$menu.text|wash}
                                                    </span>
                                                {else}
                                                    <a href={$menu.url_alias|ezurl} title="{$menu.text|wash}">
                                                        {$menu.text|wash}
                                                    </a>
                                                {/if}
                                            {set $depth=$menu.level}
                                        {/foreach}
                                        {if $depth|ne(0)}
                                            {concat('</li><li class="closemenu"><span>','close menu'|i18n("extension/wifoe"),'</span></li></ul>')|repeat($depth)}
                                        {/if}
                                    </ul>
                                {/if}
                            {undef $docs $depth $current_path}
                        {/if}
                    </li>
                    {undef $children_count}
                {/if}
            {/foreach}
            <li class="closemenu"><span>{'close menu'|i18n("extension/hannover/wifoe")}</span></li>
        </ul>
    {if $node_id|is_numeric()|not()}
        </div>
    {/if}
{/if}


{undef $root_node $top_menu_class_filter $top_menu_items $top_menu_items_count $item_class $content_node $current_depth}