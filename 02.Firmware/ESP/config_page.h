#ifndef INDEX_H
#define INDEX_H

const char index_page[] PROGMEM = R"=====(
<html>
<head>
<title>Config Mode</title>
<meta name="viewport" content="width=device-width, initial-scale=1">
<style>
form{
  width: 400px; 
  margin: auto; 
  margin-top: 180px; 
  padding-left: 50px;
  padding-right: 50px;
  border: solid 8px #fd5050; 
  border-radius: 20px;
  text-align: center;
}
h1{
  color: red;
  margin-bottom: 50px
}
.inp{
  width: 300px;
  height: 30px;
  margin-bottom: 15px;
}
.btn{
  margin-top: 25px;
  margin-bottom: 20px;
  padding: 10px 40px; 
  background: #50CFFD; 
  color: #fff;
  cursor: pointer;
  border: none
}
.btn:hover{
  opacity: 0.7
}
</style>
</head>
<body>
<form method="POST" action="/save_config">
<h1>WIFI CONFIG</h1>
<input name="ssid" placeholder="WIFI SSID" class="inp">
<input type="password" name="pass" placeholder="WIFI PASSWORD" class="inp">
<input name="server" placeholder="SERVER ADDRESS" class="inp" style="width: 220px; margin-right: 20px">
<input name="port" placeholder="PORT" class="inp" style="width: 60px">
<button type="submit" class="btn">Save</button>
</form>
</body>
</html>
)=====";

#endif
