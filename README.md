# Wesley1041's Timing System 4
This repository hosts the source code and ROBLOX place file in which the model can be tested. This is an open source project where anyone will be able to contribute to it.

## Coding
### Single Script Architecture
This model has been developed with editing in Visual Studio Code in mind. It uses single-script architecture, which means that there is only one server and client script being used. The core logic of the system can be found in the module scripts. Another benefit of the single-script architecture is that tests can be written to test the logic of each module script.

### Modularity
The scripts are set up so that each serve their own purpose and that it is easy to adjust the timing system to your needs. For example, if you want to use this model in your game, and you want the times to be reset every X minutes, you can do that easily by calling the `ResetData()` method in `TimingDataService.lua`.

### Abstractions
The logic is broken down in layers so that more detailed logic is not visible at first. You don't always need to know how a function works, just know how to use it and what it does.

### Practices
- Handlers are used to handle player input, touched, or remote events.
- Services contain the logic of the system and can be coupled with a particular GUI frame.
- DataModels contain templates of Instances. They add an element of object-oriented programming (OOP) to the project.
- Modules inside the `Wes_Timing_System_4/Modules` folder are replicated between the server and client. This also applies to `_Config.lua`.
- Other scripts in Workspace are server-only. In a game project you would place them in the `ServerScriptService`, but because the model needs to be easily-installable we don't do this.
- Scripts in `StarterGui` are client-only.

## Contributing
Want to contribute? Please read the instructions below carefully before you start!

Here are the steps on how to contribute:
1. [Fork](https://docs.github.com/en/pull-requests/collaborating-with-pull-requests/working-with-forks/about-forks) this repository. It will create you a new repository as a copy of this one.
2. Make changes to the project in your forked repository.
3. Go to this repository and create a [pull request](https://docs.github.com/en/pull-requests/collaborating-with-pull-requests/proposing-changes-to-your-work-with-pull-requests/about-pull-requests). You want to compare this repo's `master` branch with a branch from your fork. Select __Compare across forks__ so you can select the branch from your fork.
4. Your changes will be reviewed by an admin of this project.
5. If your PR gets approved, the model will be published to Roblox.

### Coding Standards
Any code that is merged into the `master` branch should be up to standards:
- Functions should be commented.
- Stick to the existing architecture as much as possible.
- A function must be specifically for one thing.

### Discord
You can join our Discord server for discussing development and to hang out. [Join here.](https://discord.gg/GSam4GWFuG)