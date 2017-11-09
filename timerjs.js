var timerVar = setInterval(countTimer, 1000);
var totalSeconds = 0;
function countTimer() {
   ++totalSeconds;
   var hour = Math.floor(totalSeconds /3600);
   var minute = Math.floor((totalSeconds - hour*3600)/60);
   seconds = totalSeconds - (hour*3600 + minute*60);
   timervalue = hour + ":" + minute + ":" + seconds;
   document.getElementById("timer").innerHTML = timervalue;
   document.getElementById("timer").style.color = "blue";
   document.getElementById("timer").style.font = "italic bold 50px arial,serif";
   }
