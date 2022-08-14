// ignore_for_file: file_names, unnecessary_this, prefer_initializing_formals

class DataPoint{
  int timestamp = 0;
  int value = 0;

  DataPoint(int ts, int value){
    this.timestamp = ts;
    this.value = value;
  }
}