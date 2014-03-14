{def $root_node = fetch( 'content', 'node', hash( 'node_id', cond($node_id|is_numeric(), $node_id , ezini('NodeSettings', 'RootNode','content.ini') ) ) )
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
                    </li>
                    {undef $children_count}
                {/if}
            {/foreach}
        </ul>
    {if $node_id|is_numeric()|not()}
        </div>
    {/if}
{/if}


{undef $root_node $top_menu_class_filter $top_menu_items $top_menu_items_count $item_class $content_node $current_depth}