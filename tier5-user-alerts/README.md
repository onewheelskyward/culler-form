User Alerts
-----------

Reads from the alert queue, and then checks the item in question against all existing alerts.

This design has an issue, as the alerts increase, the processing time for each item will increase.  
Keep track of the timing, but this is going to be a private, low-volume site, so.
