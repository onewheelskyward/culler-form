culler-form
==========

This is now deprecated pending a re-envisoning into a multi-tier product.  

Tier 1: List collection.  
  Run at a regular interval, pull down the list and insert new raw items to scrape into a queue.  
   
Tier 2: Item collection.  
  Pull items off of the list queue and read the raw item data into the next queue.  
   
Tier 3: Data processing
  At the request of Tier 2, process the documents that have been collected and extract and store metadata for each type.  
  e.g. A house listing would have location, price, pets, sqft, $/sqft, description, contact info(?)
       A for-sale listing would have price, location, description.  
       
Tier 4: User-facing application
  User login, user administration, user filter addition
  Filters: User selects the category, and then adds specific filters- perhaps price range, keywords
  
Tier 5: User Alerts
  During the filter creation/editing process, the user should be able to select a type of alert- email or sms.  
  There should also be a way to set alert thresholds, every time, every x minutes.

It's important to remember that the type of data is determined at tier 1 and continues through the entire application.