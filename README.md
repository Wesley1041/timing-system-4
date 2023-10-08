# Wesley1041's Timing System 4
This repository hosts the source code and ROBLOX place file in which the model can be tested. This is an open source project where anyone will be able to contribute to it.

## Coding
### Single Script Architecture
This model has been developed with editing in Visual Studio Code in mind. It uses single-script architecture, which means that there is only one server and client script being used. The core logic of the system can be found in the module scripts. Another benefit of the single-script architecture is that tests can be written to test the logic of each module script.

### Modularity
The scripts are set up so that each serve their own purpose and that it is easy to adjust the timing system to your needs. For example, if you want to use this model in your game, and you want the times to be reset every X minutes, you can do that easily by calling the `ResetData()` method in `TimingDataService.lua`.

### Abstractions
The logic is broken down in layers so that more detailed logic is not visible at first. You don't always need to know how a function works, just know how to use it and what it does.

## Contributing
Want to contribute? Instructions will be provided at a later time on how you can help develop this model!