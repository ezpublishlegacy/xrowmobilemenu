xrowmobilemenu
==============

Mobile AJAX menu for eZ Publish Legacy

Steps to set up xrowmobilemenu:

1. Download xrowmobilemenu and install in <docroot>/<ezpublish_legacy>/extension/xrowmobilemenu directory.
2. Activate Extension
   in override/site.ini.append.php
   
  [ExtensionSettings]
  ActiveExtensions[]=xrowmobilemenu
  
  or in siteaccess/<your_siteaccess>/site.ini.append.php
  
  [ExtensionSettings]
  ActiveAccessExtensions[]=xrowmobilemenu
3. Add xrowmobilemenu.js and xrowmobilemenu.css to your design.ini
4. Activate jQuery.
5. Add one HTML-Tag of your desire with a proper class or an ID as Trigger for opening/closing the menu.
  <button class="example"></button>
6. Set up the Trigger in JS: $("button.example").xrowmobilemenu();
7. Optionally you can configure what the menu should do:
  a.
    I recommend, that you use data-Attributes in your HTML-Trigger to pass the variables to JS
    <button class="example" data-current_node={$current_node_id}></button>
  b.
    $("button.example").xrowmobilemenu({current_node_id: $("button.example").data("current_node")});
  c.
    More Possibilities:
8. Clear caches.
    
    $("button.example").xrowmobilemenu({
      current_node_id: <add the current node id like in b. - this is recommended>,
      focus_current_node: <if the menu should focus on the current node on load, elsewhise it will show the children of the root node>,
      root_node_id: <by default the root nodeconfigured in your site.ini is used. But for microsites you can set the root node manually>
    });
