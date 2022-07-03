#ifndef CONFIG_PAGE_H
#define CONFIG_PAGE_H

const char index_page[] PROGMEM = R"=====(
<html>
<head>
<title>Config Mode</title>
<meta name="viewport" content="width=device-width, initial-scale=1">
<style>
form{
  width: 60vw; 
  margin: auto; 
  margin-top: 20vh; 
  padding-left: 5vw;
  padding-right: 5vw;
  border: solid 8px #fd5050; 
  border-radius: 20px;
  text-align: center;
}
h1{
  color: red;
  margin-bottom: 50px
}
.inp{
  width: 90%;
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
<input name="ssid" placeholder="WIFI SSID" class="inp" value="">
<input type="password" name="pass" placeholder="WIFI PASSWORD" class="inp" value="">
<input name="uid" placeholder="DEVICE ID" class="inp" value="">
<button type="submit" class="btn">Save</button>
</form>
</body>
</html>
)=====";

#endif
