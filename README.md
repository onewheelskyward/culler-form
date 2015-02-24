culler-form
==========

This is now deprecated pending a re-envisoning into a multi-tier product.  

Tier 1: Data collection.  
  Run at a regular interval, pull down the listing and insert new raw items into the database.  
   
Tier 2: Data processing
  At the request of Tier 1, process the documents that have been collected and extract and store metadata for each type.  
  e.g. A house listing would have location, price, pets, sqft, $/sqft, description, contact info(?)
       A for-sale listing would have price, location, description.  
       
Tier 3: User-facing application
  User login, user administration, user filter addition
  Filters: User selects the category, and then adds specific filters- perhaps price range, keywords
  
Tier 4: User Alerts
  During the filter creation/editing process, the user should be able to select a type of alert- email or sms.  
  There should also be a way to set alert thresholds, every time, every x minutes.

