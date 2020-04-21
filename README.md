# batteryblocks
a dynamic battery level indicator for i3blocks  
![](exhibit.gif)
  
All ye who stumble accross this repo be warned that;  
  at the time of writing,  
    - I have minimal experience with git and zero experience using markdown  
    ... so bare with me for now.  

* The module script itself is ready for use (assuming you want the indicator as shown in the above animation)  
* My goal is to use nothing more than bash-builtins, but you can do what you want.  
* For anyone wanting to try their own colors/customizations:  
  - Have at it!  
  - Provide your own custom color palette by changing the values of the "baseColors" list.  
  - Color testing is built in (mouse clicks 3-6)  
  - There is also a single (un/)commentable line for creating your own animated .gif, similar to the one shown above  
    -- (useful for seeing the entire spectrum of transitions, rather than temporarily simulating each one individually)  
  - All of these testing options (and any comments) can obviously be removed if/when you have no use for them.  

# IDEAS / TO-DO:  
  * Become better at math and flesh out custom baseColors palette input handling.  
    + perhaps simplifying integration with other utilities, such as pywal.  
    + currently seems to work fine with  ${#baseColors[@]} >= 4, but I haven't tried finding the limit(50 ?*  lol)  
  * notify-send a LOW warning at {9,6,3}%  
  * some kind of visual indicator as to whether battery is actually taking a charge or not. perhaps alternating the colors of Bracket[{1,2}] accordingly.
