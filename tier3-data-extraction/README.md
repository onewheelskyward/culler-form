Data Extraction
---------------

Now the data starts to enter our domain.  

Read an item from the extraction queue, parse the HTML and pull out key elements based on the type of listing it is.

This is where our model domain will be created, and shared with the downstream tiers.

Once the item has been modeled and placed into the domain, push onto the alert queue for alert processing.
