# batteryblocks
a dynamic battery level indicator for i3blocks<br/ >
![](exhibit.gif)
<br/ >
All ye who stumble accross this repo be warned that;<br/ >
  at the time of writing,<br/ >
    - I have done little more than cloning with git<br/ >
    - I've never used markdown<br/ >
... so bare with me for now.<br/ >

* The script itself is good to go (still has some commented-out development/todo notes)<br/ >
* The handful of "alternative modes" are just commented/uncommented for now.<br/ >
* My goal is to use nothing more than bash-builtins,<br/ >
    such that a fair amount of customization can be worked in without bloating it down.
<br/ >
# TO-DO:
  * Become better at math and flesh out custom baseColors palette input handling.<br/ >
    + perhaps simplifying integration with other utilities, such as pywal.<br/ >
  * currently seems to work fine with  4 <= ${#baseColors[@]} <= ?*<br/ >
  * Make the exhibition .gif... better<br/ >
  * notify-send at {9,6,3}%<br/ >
  * set color of Bracket[{1,2}] according to whether battery is actually taking a charge or not.<br/ >
