# HelloFresh logging platform serving multiple countries.

HelloFresh is the leading global provider of fresh food at home. Our subscription-based meal kits offer "cook from scratch" meal plans with easy–to–follow–recipes and high quality, pre-portioned fresh ingredients, delivered straight to your door. Every week customers can choose from a great variety of recipes and plan their meals several weeks ahead by ordering through desktop or mobile app. HelloFresh operates in the U.S., the United Kingdom, Germany, the Netherlands, Belgium, Luxembourg, Australia, Austria, Switzerland, Canada, New Zealand, France, Sweden and Denmark. HelloFresh delivered 149 million meals to 4.18 million active customers worldwide in Q2 2020 (April 1 - June 30, 2020). HelloFresh was founded in Berlin in November 2011 and went public on the Frankfurt Stock Exchange in November 2017. HelloFresh has offices in New York, Berlin, London, Amsterdam, Sydney, Toronto, Auckland, Copenhagen and Paris. 


## The goal : provide proper visibility for everyone within HelloTech
As our business grows, the team must constantly look at ways to improve our processes around managing hundreds of thousands of log events that come in every second. To manage and adapt to the business needs and scalability required, we chose to re-architect and optimise our logging pipeline. Understanding the important of the core value of logging system, we have defined some key criteria that aim to have 

- The new logging system should be resilient to adapt with business growth demand
- All HelloFresh engineers over 14 countries should be able to maintain and control their logging events end to end
- Monitoring the logging system is a must as we need to have insight into all messages in/out"

## The challenge : Performance - Usability & Accounting 

- Multiple workers is the first challenge we are facing as we want to send log events to GrayLog, however the GELF output plugin does not support this feature.
In fact, we adjusted and recompiled this plugin to support multi process workers, letting them work well under high load log events environment.

- Usability is one of the attractive core values that  we defined in the initial phase. Letting them understand the logging pipeline and giving them the right to control their logging events is the way to leverage to the platform level. Therefore we combined several solutions such as load multiple templated config files - auto reload over RPC - fault tolerance based on syntax checking.

- Monitoring is easy but giving the proper answer based on the customer's visibility is a challenge. With prometheus & flowcounter plugin we tracked every size of message per hour, visualizing all incoming log events and outgoing log as well. Especially the high log buffer / error rate for any specific message will be identified in a second (if any).

## The result : 

A new logging platform was introduced with a dozen documents to share across 14 countries and 50 engineering team department. We increased the resilience, robustness and availability of the service to help all colleagues investigate their issues.
