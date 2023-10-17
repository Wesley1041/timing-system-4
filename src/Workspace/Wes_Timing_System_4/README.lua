--[[
----------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------
Wesley1041's Timing System 4 v1.1-beta

This fourth timing system is designed to be compatible with places that use StreamingEnabled.
It is the most feature-rich and modular timing system yet.

IMPORTANT: Configure the Timing System to your liking in the Config script that is part of this script.

----------------------------------------------------------------------------------------------------------

HOW TO INSTALL:
1. Move the "_Start" part to the start/finish line.
2. Move the "_S1" part to the end of Sector 1
3. Move the "_S2" part to the end of Sector 2
4. Duplicate and place the "_CC" parts wherever drivers can exceed track limits.
If they touch a "_CC" part, their lap will be invalidated.
You can set the "_CC"'s "InvalidsNextLap" attribute to "true" if you want the "_CC" part to invalidate the driver's next lap.
5. Move the Board model to wherever you like.

DO NOT UNGROUP ANYTHING! 
The "_Start", "_S1", "_S2", and "_CC" parts can be placed wherever in Workspace, but you cannot change their names.

----------------------------------------------------------------------------------------------------------

FOR SCRIPTERS:
The scripts and code in this model have been structured such that they are easy to edit and adapted to your needs!

The structure goes as follows:
- TimingBoardHandler - Contains all remote event/function handlers on the server side
- TimingDataService  - Contains the logic that keeps track of everyone's times
- TimingBoardService - Updates the timing board on the server side

----------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------
--]]