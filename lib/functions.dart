
String timeConverter(int time){
  if (time <= 0){
    return "00 : 00 : 00";
  }
  String hours = ((time / 3600)).floor().toString();
  if (hours.length == 1){
    hours = "0" + hours;
  }
  String minutes = ((time % 3600)/ 60).floor().toString();
  if (minutes.length == 1){
    minutes = "0" + minutes;
  }
  String seconds = ((time % 3600) % 60).floor().toString();
  if (seconds.length == 1){
    seconds = "0" + seconds;
  }
  return hours + " : " + minutes + " : " + seconds;
}