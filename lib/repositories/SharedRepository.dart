import 'package:shared_preferences/shared_preferences.dart';

class SharedRepository{
  Future<String> getData(String name) async{
    try{
      SharedPreferences prefs = await SharedPreferences.getInstance();
      if(prefs.containsKey(name)){
        var val = prefs.getString(name);
        if(val != null){
          if(val.isNotEmpty){
            return val;
          }
        }

      }
      return "error";
    }
    on Exception catch(ex){
      return "error";
    }
  }

  Future<bool> clearData()async{
    try{
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var res= await prefs.clear();
      return res;
    }
    catch(e){
      return false;
    }
  }

  Future<bool> setData(String key, String value)async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    try{
      var res = await prefs.setString(key, value);
      return res;
    }
    catch(ex){
      return false;
    }
  }
}